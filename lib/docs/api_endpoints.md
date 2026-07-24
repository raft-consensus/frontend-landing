# API Reference — Raft Backend

Guía para el equipo de frontend. Cubre todos los endpoints expuestos hoy, con forma exacta de request/response.

## Convenciones generales

**Base URL:** la que corresponda por entorno (local: `http://localhost:5133` según `Properties/launchSettings.json`; producción: el dominio detrás de nginx).

**Todas las respuestas** usan el mismo sobre, sin excepción:

```json
{
  "success": true,
  "message": "texto legible",
  "data": { }
}
```

- `success: false` con `data: null` en errores de negocio (404, 400, 401, 409).
- `400` también puede venir de **validación automática de modelo** (ver más abajo) — en ese caso el cuerpo no es el `ServiceResponse` normal, sino el formato estándar de ASP.NET (`errors: { campo: [mensajes] }`).
- Errores no controlados devuelven `success: false`, `message: "An unexpected error occurred."`, status `500`.
- `429 Too Many Requests` cuando se excede un límite de rate limiting (ver tabla más abajo) — sin cuerpo `ServiceResponse`, es la respuesta estándar del middleware de rate limiting de ASP.NET.

**Validación automática de modelo:** los endpoints que reciben un DTO con atributos (`[Required]`, `[EmailAddress]`, `[MinLength]`, etc. — hoy solo `register`/`login`, sección 2) devuelven `400` automáticamente si falta un campo o no cumple la regla, **antes** de que el controller se ejecute. El cuerpo se ve así:

```json
{
  "type": "https://tools.ietf.org/html/rfc9110#section-15.5.1",
  "title": "One or more validation errors occurred.",
  "status": 400,
  "errors": {
    "Password": ["The field Password must be a string with a minimum length of 8."],
    "Email": ["The Email field is not a valid e-mail address."]
  }
}
```

El resto de los DTOs (los de la sección 4, administración) no tienen estos atributos todavía — llegan tal cual al backend sin validar formato/longitud del lado del servidor.

**Autenticación:** `Authorization: Bearer <jwt>` en cada endpoint que no diga "Público". El JWT se obtiene por dos caminos — login con email+contraseña o login OAuth (sección 2) — y expira en 60 minutos (`Jwt:ExpirationMinutes`).

**CORS:** solo el origen configurado en `Frontend:BaseUrl` (`https://raft.andrescortes.dev`) puede llamar al API desde el navegador. Si el frontend corre en otro dominio (otro entorno, localhost, etc.), avisar para agregarlo — hoy es un único origen permitido, no una lista.

**Rate limiting:**

| Alcance | Límite | Aplica a |
| --- | --- | --- |
| Global (por IP) | 120 req/min | Todo el API |
| `auth` (por IP) | 10 req/min | `/api/auth/*` (incluye `register` y `login` con password) |
| `credential-reveal` (por usuario) | 5 req/min | `GET /api/me/databases/{id}/password` |

---

## 1. Landing page (público)

### `GET /api/metrics/platform`

Sin autenticación. Estadísticas globales para la página principal.

```json
{
  "success": true,
  "message": "Platform metrics retrieved successfully.",
  "data": {
    "totalUsers": 12,
    "totalDatabases": 18,
    "activeDatabases": 17,
    "totalLogins": 34,
    "activeUsers": 9,
    "serviceAvailability": 100.0
  }
}
```

`serviceAvailability` está fijo en `100.0` hasta que se integre monitoreo real — no lo trates como un dato en vivo todavía.

---

## 2. Autenticación

Hay **dos caminos** para obtener un JWT: registro/login normal con email y contraseña (llamadas `fetch` normales), y login con OAuth (Google/GitHub, navegación de navegador completa). El `AuthResponseDto` que devuelven es el mismo en ambos casos.

### 2.1 Con email y contraseña

Estos dos son `fetch`/`axios` normales — nada de redirects ni `window.location`.

#### `POST /api/auth/register`

Público. Crea un usuario nuevo y devuelve el JWT directo (queda logueado al registrarse, no hace falta un segundo login).

Request:
```json
{
  "name": "Jane Doe",
  "email": "jane@correo.com",
  "password": "unaContraseñaSegura123"
}
```

Reglas de validación (`400` si no se cumplen, ver formato de error arriba):
- `name`: obligatorio, máx. 200 caracteres.
- `email`: obligatorio, formato de email válido, máx. 320 caracteres.
- `password`: obligatorio, mínimo 8 caracteres.

Response (`200`):
```json
{
  "success": true,
  "message": "User registered successfully.",
  "data": {
    "accessToken": "eyJhbGciOi...",
    "tokenType": "Bearer",
    "expiresAt": "2026-07-23T15:30:00Z",
    "provider": "Password",
    "user": {
      "id": 7,
      "name": "Jane Doe",
      "email": "jane@correo.com",
      "avatarUrl": null,
      "provider": "",
      "providerUserId": "",
      "role": "User",
      "createdAt": "2026-07-23T14:30:00Z",
      "updatedAt": null,
      "deletedAt": null,
      "lastLogin": null
    }
  }
}
```

Nota sobre el `user` de un registro por password: `provider` y `providerUserId` vienen como string vacío (`""`), no `null` — a diferencia de un usuario OAuth, que sí los trae con valor (`"Google"`/`"GitHub"` + su id externo). Es la forma de distinguir del lado del frontend cómo entró ese usuario, si lo necesitás mostrar en algún lado (ej. "cambiar contraseña" no debería mostrarse para un usuario que entró por OAuth).

`409 Conflict` si el email ya está registrado:
```json
{
  "success": false,
  "message": "That email is already registered."
}
```

#### `POST /api/auth/login`

Público. Login con email y contraseña.

Request:
```json
{
  "email": "jane@correo.com",
  "password": "unaContraseñaSegura123"
}
```

Response (`200`): mismo shape que `register`, con `"provider": "Password"`.

`401 Unauthorized` si el email no existe, el password no coincide, **o** el email pertenece a un usuario que se registró por OAuth y nunca tuvo contraseña (mismo mensaje en los tres casos, a propósito — no revela cuál de las tres pasó):
```json
{
  "success": false,
  "message": "Invalid email or password."
}
```

### 2.2 Con OAuth (Google / GitHub)

Todo este flujo es **navegación de navegador completa** (redirects HTTP), no llamadas `fetch`/AJAX — ni el login ni el callback se deben llamar con `fetch`.

#### Paso 1 — `GET /api/auth/login/{provider}`

`provider` = `google` | `github`. Público. El frontend dispara esto con una navegación real, no un `fetch`:

```js
window.location.href = "https://<api-host>/api/auth/login/google";
```

Redirige al proveedor (`302`), que al terminar redirige a `/api/auth/callback/{provider}` (interno, el frontend nunca llama esto directo).

#### Paso 2 — el backend redirige de vuelta al frontend

Tras procesar el login, `GET /api/auth/callback/{provider}` **no devuelve JSON** — redirige (`302`) a:

```
https://raft.andrescortes.dev/auth/callback#access_token=<jwt>&expires_at=<iso8601>&provider=<Google|GitHub>
```

El frontend tiene que tener una ruta montada en **`/auth/callback`** que, al cargar, lea `window.location.hash` (no query params — van después del `#`, a propósito, para que nunca se manden a ningún servidor ni queden en logs), extraiga `access_token`, y guarde la sesión.

Si algo falla, el redirect trae `#error=<código>` en vez de `access_token`:

| Código | Cuándo |
| --- | --- |
| `oauth_failed` | El proveedor externo no completó la autenticación |
| `unsupported_provider` | El `{provider}` de la URL no era `google`/`github` |
| `login_failed` | Error inesperado al persistir el login |

Ejemplo de handler típico en el frontend:

```js
// en la ruta /auth/callback
const params = new URLSearchParams(window.location.hash.slice(1));
const error = params.get("error");
if (error) {
  // mostrar mensaje según el código, redirigir a /login
} else {
  const accessToken = params.get("access_token");
  const expiresAt = params.get("expires_at");
  // guardar accessToken, redirigir a la pantalla principal
}
```

**El `user` (nombre, email, avatar, `role`, etc.) no viaja en la URL de este flujo.** El JWT ya es un estándar (header.payload.signature) — decodificar la parte `payload` (base64) del lado del cliente da acceso a los claims (`sub`, `name`, `email`, `role`, `provider`) sin otra llamada. Si preferís no decodificar el JWT a mano, decime y agrego un endpoint `GET /api/me` que devuelva el usuario como JSON normal (ya autenticado con el Bearer token) — hoy no existe, y sería útil también para refrescar los datos del usuario tras el login por password.

### 2.3 Qué hacer con el `access_token` (ambos caminos)

Guardarlo (localStorage/sessionStorage, a definir con el equipo) y mandarlo como `Authorization: Bearer <token>` en el resto de las llamadas — esas sí son `fetch` normales, con CORS habilitado para `https://raft.andrescortes.dev`.

---

## 3. Mis bases de datos (autoservicio — requiere JWT)

El flujo principal del producto: lo que ve un estudiante logueado sobre sus propias bases de datos. Aplica igual sin importar si el usuario entró por password o por OAuth — el aprovisionamiento automático de la primera base de datos se dispara en ambos casos, al registrarse/loguearse por primera vez.

### `GET /api/me/databases`

Devuelve las bases de datos del usuario autenticado (el id sale del JWT, nunca de la URL — no hace falta ni existe un parámetro para pedir las de otro usuario).

```json
{
  "success": true,
  "message": "Databases retrieved successfully.",
  "data": [
    {
      "databaseInstanceId": 5,
      "host": "49.13.85.216",
      "port": 3306,
      "databaseName": "raft_u1_a1b2c3d4",
      "databaseUser": "raft_u1_a1b2c3d4",
      "engine": "MySQL",
      "status": "Active",
      "usedSpaceBytes": 40960,
      "maxSpaceBytes": 20971520,
      "lastActivity": "2026-07-22T13:45:00Z",
      "createdAt": "2026-07-20T10:00:00Z"
    }
  ]
}
```

`status` puede ser `Active`, `Suspended` (pausada por 7 días de inactividad o por exceder `maxSpaceBytes`) o, si ya no aparece en la lista, fue eliminada (30 días de inactividad).

Si el usuario todavía no tiene ninguna BD (p. ej. el aprovisionamiento automático falló tras su primer login/registro), `data` viene como lista vacía — no es un error, es un estado real a manejar en la UI ("aún no tienes una base de datos").

### `GET /api/me/databases/{databaseInstanceId}/password`

Revela la contraseña de una instancia — solo si pertenece al usuario autenticado. Rate limit propio: **5 req/min**. Cada llamada queda auditada del lado del servidor.

```json
{
  "success": true,
  "message": "Password retrieved successfully.",
  "data": {
    "databaseInstanceId": 5,
    "password": "K7mP2xQw9vLnR4tYbZs8"
  }
}
```

`404` si el `databaseInstanceId` no existe o no le pertenece al usuario del token (mismo mensaje en ambos casos, a propósito — no revela si la instancia existe pero es de otro).

Con esto más lo que ya trae `GET /api/me/databases`, el frontend tiene todos los campos que pide el entregable: host, puerto, nombre de BD, usuario, contraseña (bajo demanda), motor, fecha de creación y estado.

---

## 4. Administración (requiere rol `Admin`)

Todo lo de esta sección devuelve `403 Forbidden` si el usuario autenticado no tiene `role: "Admin"` en su token. No hay forma de auto-promoverse — el primer admin se marca a mano en la base de datos. Usar solo para un panel interno de soporte, no para las pantallas que ve un estudiante normal.

### Users — `/api/users`

| Método | Ruta | Body | Notas |
| --- | --- | --- | --- |
| `GET` | `/api/users` | — | Lista usuarios activos |
| `GET` | `/api/users/{id}` | — | |
| `POST` | `/api/users` | `UserCreateDto` | Crea un usuario manualmente (no es el flujo de registro/login de la sección 2) |
| `PUT` | `/api/users/{id}` | `UserUpdateDto` | |
| `DELETE` | `/api/users/{id}` | — | Soft delete |

`UserCreateDto` / `UserUpdateDto`:
```json
{
  "name": "Jane Doe",
  "email": "jane@correo.com",
  "avatarUrl": "https://example.com/avatar.png",
  "provider": "Google",
  "providerUserId": "google-sub-123",
  "lastLogin": "2026-07-22T10:00:00Z"
}
```

Importante: esta ruta **no** tiene forma de fijar una contraseña — no existe ese campo aquí. No sirve para crear un usuario que después pueda loguearse con `POST /api/auth/login`; ese usuario solo podría entrar por OAuth (si `provider`/`providerUserId` coinciden con una cuenta real), o quedar sin forma de loguearse si se dejan vacíos. Para crear un usuario con contraseña utilizable, el único camino es `POST /api/auth/register` (sección 2.1).

`UserReadDto` (respuesta): igual que el objeto `user` de la sección 2, incluye `role`.

### Database Instances — `/api/database-instances`

| Método | Ruta | Body |
| --- | --- | --- |
| `GET` | `/api/database-instances` | — |
| `GET` | `/api/database-instances/{id}` | — |
| `POST` | `/api/database-instances` | `DatabaseInstanceCreateDto` |
| `PUT` | `/api/database-instances/{id}` | `DatabaseInstanceUpdateDto` |
| `DELETE` | `/api/database-instances/{id}` | — |

Mismo shape que los objetos de `GET /api/me/databases` (sección 3) más `userId`. Crear/editar acá **no** dispara el aprovisionamiento real en MySQL — es solo el registro de metadata. El aprovisionamiento real solo lo dispara el registro/login (sección 2).

### Access Credentials — `/api/access-credentials`

| Método | Ruta | Body |
| --- | --- | --- |
| `GET` | `/api/access-credentials` | — |
| `GET` | `/api/access-credentials/{id}` | — |
| `GET` | `/api/access-credentials/by-database-instance/{databaseInstanceId}` | — |
| `POST` | `/api/access-credentials` | `AccessCredentialCreateDto` |
| `PUT` | `/api/access-credentials/{id}` | `AccessCredentialUpdateDto` |
| `DELETE` | `/api/access-credentials/{id}` | — |

**Nunca devuelve la contraseña**, ni en admin. Solo `id`, `databaseInstanceId`, `createdAt`, `updatedAt`, `deletedAt`. Para ver la contraseña, incluso como admin, hoy solo existe el camino de autoservicio (sección 3) — no hay un endpoint admin equivalente todavía.

### Audit Events — `/api/audit-events`

| Método | Ruta | Body |
| --- | --- | --- |
| `GET` | `/api/audit-events` | — |
| `GET` | `/api/audit-events/{id}` | — |
| `POST` | `/api/audit-events` | `AuditEventCreateDto` |
| `PUT` | `/api/audit-events/{id}` | `AuditEventUpdateDto` |
| `DELETE` | `/api/audit-events/{id}` | — |

```json
{
  "id": 101,
  "userId": 1,
  "eventType": "Login",
  "description": "OAuth login completed with Google.",
  "ipAddress": null,
  "additionalData": "{\"provider\":\"Google\",\"providerUserId\":\"...\"}",
  "createdAt": "2026-07-22T14:00:00Z",
  "deletedAt": null
}
```

`eventType` conocidos hoy: `Login`, `Provisioning`, `ProvisioningFailed`, `CredentialRevealed`. Nota: hoy el login con password (sección 2.1) **no** genera un `AuditEvent` de tipo `Login` — solo el login por OAuth lo hace. Es una diferencia pendiente de resolver del lado del backend, no algo que el frontend deba compensar.

### User Dashboard (admin) — `GET /api/users/{userId}/dashboard`

Igual shape que `GET /api/me/databases` (sección 3), pero para cualquier `userId` — uso exclusivo de soporte/admin, ya que expone datos de otros usuarios.

---

## Apéndice — códigos de estado a manejar en el frontend

| Código | Cuándo | Sugerencia UI |
| --- | --- | --- |
| `200` / `201` | Éxito | — |
| `400` | Body inválido (campo faltante/formato incorrecto en `register`/`login`), o provider no soportado en login OAuth | Mostrar el/los mensaje(s) de `errors` (validación de modelo) o `message` (`ServiceResponse`) según el caso |
| `401` | Falta token, token vencido, credenciales incorrectas en login por password, o falló el OAuth externo | Redirigir a login / mostrar "credenciales inválidas" |
| `403` | Sin rol `Admin` para una ruta admin | Ocultar la sección, no solo bloquear la llamada |
| `404` | Recurso no existe o no pertenece al usuario | "No encontrado" |
| `409` | Conflicto (email ya registrado en `register`, o creación de usuario duplicado por admin) | Mostrar el `message` |
| `429` | Rate limit excedido | "Probá de nuevo en un minuto" |
| `500` | Error no controlado | Mensaje genérico, no exponer detalles |
