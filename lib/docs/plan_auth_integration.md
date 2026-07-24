# Plan de Integración Técnica: Módulo de Autenticación (Auth)

## 1. Objetivo del Plan
Implementar el flujo completo y funcional de Autenticación real conectando el frontend de Flutter con la API del backend en ASP.NET Core. 

El plan abarca:
1. Registro por formulario con nombre, correo y contraseña (`POST /api/auth/register`).
2. Inicio de sesión por formulario (`POST /api/auth/login`).
3. Almacenamiento seguro del token JWT en el dispositivo/navegador.
4. Protección de rutas y redirección automática hacia `/dashboard`.
5. Redirección para inicio de sesión social OAuth con Google y GitHub.

---

## 2. Estructura de Archivos del Módulo (`lib/src/features/auth/`)

Siguiendo Clean Architecture y manteniendo la consistencia con el módulo `user`, organizaremos las capas de la siguiente manera:

```text
lib/src/core/
├── network/
│   ├── api_client.dart             # Cliente HTTP base con URL del servidor y manejo de respuestas JSON.
│   └── session_storage.dart        # Guardado local del JWT (SharedPreferences / Web LocalStorage).
│
lib/src/features/auth/
├── domain/
│   └── entities/
│       ├── login_form_data.dart    # DTO del formulario de inicio de sesión.
│       ├── register_form_data.dart # DTO del formulario de registro.
│       ├── auth_user.dart          # Entidad pura del usuario autenticado.
│       └── auth_session.dart       # Entidad del token y estado de sesión.
│
├── data/
│   ├── models/
│   │   ├── user_model.dart         # Parser JSON -> AuthUser.
│   │   └── auth_response_model.dart# Parser JSON -> AuthSession.
│   ├── datasources/
│   │   └── auth_remote_datasource.dart # Llamadas HTTP a /api/auth/register y /api/auth/login.
│   └── repositories/
│       └── auth_repository_impl.dart   # Implementación del repositorio de autenticación.
│
└── presentation/
    ├── screens/                    # Pantallas principales (LoginScreen, RegisterScreen).
    └── widgets/                    # Componentes atómicos (LoginCard, RegisterCard, etc.).
```

---

## 3. Desglose de Pasos de Ejecución

### Paso 1: Reorganización de la Capa Domain
* Crear la carpeta `lib/src/features/auth/domain/entities/`.
* Mover los archivos `login_form_data.dart` y `register_form_data.dart` a `domain/entities/` y eliminar la carpeta obsoleta `www/`.

### Paso 2: Configuración de Dependencias (`pubspec.yaml`)
Instalaremos las librerías oficiales para peticiones HTTP y persistencia de sesión:
* `http`: Para la comunicación cliente-servidor mediante peticiones REST.
* `shared_preferences`: Para almacenar el token JWT en almacenamiento persistente.

### Paso 3: Cliente de Red Base (`lib/src/core/network/api_client.dart`)
Crearemos una abstracción de red que:
* Defina la `baseUrl` del servidor (ej. `https://raft.andrescortes.dev` o `http://localhost:5133`).
* Procese el sobre JSON estándar de respuesta del backend (`success`, `message`, `data`).
* Capture los códigos de error `400` (validación de formulario), `401` (credenciales inválidas), `409` (correo ya registrado) y `500` (error interno).

### Paso 4: Persistencia de Token JWT (`lib/src/core/network/session_storage.dart`)
Crearemos un servicio para:
* `saveToken(String token)`: Guardar el token al iniciar sesión o registrarse.
* `getToken()`: Leer el token para adjuntarlo en las cabeceras `Authorization: Bearer <token>`.
* `clearSession()`: Eliminar el token al cerrar sesión.

### Paso 5: Capa Data de Autenticación (`lib/src/features/auth/data/`)
* **`auth_response_model.dart`**: Mapea la respuesta `AuthResponseDto` del backend (`accessToken`, `expiresAt`, `provider`, `user`).
* **`auth_remote_datasource.dart`**:
  * `register({name, email, password})`: Envía `POST /api/auth/register`. Si el status es `200`, retorna el modelo. Si es `409`, lanza excepción "El correo ya está registrado".
  * `login({email, password})`: Envía `POST /api/auth/login`. Si el status es `200`, retorna el modelo. Si es `401`, lanza excepción "Correo o contraseña incorrectos".

### Paso 6: Conectar el Formulario de Registro (`RegisterScreen` -> `RegisterCard`)
* En `RegisterScreen`, invocamos la llamada `register`.
* Al recibir respuesta exitosa:
  1. Guardamos el token JWT recibido.
  2. Muestra mensaje flotante de confirmación.
  3. Redirige automáticamente al panel del usuario con `context.go('/dashboard')`.
* Si ocurre un error de validación (`400` o `409`), muestra el mensaje enviado por el servidor en pantalla.

### Paso 7: Conectar el Formulario de Login (`LoginScreen` -> `LoginCard`)
* En `LoginScreen`, invocamos la llamada `login`.
* Al recibir respuesta exitosa:
  1. Guardamos el token JWT.
  2. Redirige a `/dashboard`.
* Si el servidor responde `401 Unauthorized`, resalta el campo de error y muestra "Correo o contraseña incorrectos".

### Paso 8: Flujo de Autenticación OAuth (Google y GitHub)
* Al presionar "Google" o "GitHub":
  1. Redirigimos el navegador a `/api/auth/login/google` o `/api/auth/login/github`.
  2. Configuramos la escucha de la ruta `/auth/callback` en `app_router.dart`.
  3. Leemos los parámetros fragmento del hash de la URL (`#access_token=...`), guardamos el JWT y redirigimos a `/dashboard`.
```
