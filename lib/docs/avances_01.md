
### Resumen de Logros de la Sesión

#### 1. Integración con el Backend Live y Manejo de Errores

- **Conexión Exitosa:** Conectamos el `ApiClient` a la nueva URL del servidor backend: `https://api.raft.andrescortes.dev`.
- **Verificación de CORS:** Confirmamos que el servidor web (Nginx) ya responde correctamente los encabezados `Access-Control-Allow-Origin: http://localhost:5000`.
- **Parseo de Errores de ASP.NET Core:** Actualizamos [api_client.dart](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/core/network/api_client.dart) para extraer los mensajes del mapa `errors` y `title` de respuestas `400 Bad Request`, mostrando avisos claros en la UI.

#### 2. Autenticación Social (Google y GitHub OAuth)

- Unificamos el comportamiento de los botones de registro e inicio de sesión social en [login_page.dart](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/auth/presentation/pages/login_page.dart) y [register_page.dart](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/auth/presentation/pages/register_page.dart) usando `url_launcher`.
- Diagnosticamos que los mensajes de `redirect_uri_mismatch` corresponden a la configuración de URLs autorizadas en la consola de Google Cloud y GitHub Developer App por parte del equipo de backend.

#### 3. Soporte de Roles de Usuario (`User` vs `Admin`)

- Agregamos la propiedad `role` a la entidad [auth_user.dart](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/auth/domain/entities/auth_user.dart) y al modelo [user_model.dart](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/auth/data/models/user_model.dart).
- Actualizamos [login_page.dart](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/auth/presentation/pages/login_page.dart) para decidir la redirección de forma dinámica según el rol del usuario autenticado:
  - **`Admin`** -> Redirige a la vista administrativa `/admin`.
  - **`User`** -> Redirige al panel de bases de datos `/dashboard`.

#### 4. Arquitectura de Rutas Reactiva y Fluida (GoRouter + Riverpod)

- Solucionamos el problema del rebote hacia la Landing Page en [app_router.dart](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/core/routers/app_router.dart) implementando `refreshListenable`. Ahora GoRouter reevalúa las reglas sin destruir la instancia del router ni reiniciar la pantalla inicial.
- Registramos oficialmente la pantalla `AdminDashboard` en la ruta `/admin`, corrigiendo el error 404 de página no encontrada.

#### 5. Limpieza de Repositorio y Git

- Eliminamos carpetas nativas innecesarias (`android/`, `ios/`, `windows/`, etc.), dejando un proyecto Web limpio y liviano.
- Fusionamos los cambios en `develop`, sincronizamos con GitHub y dejamos activa la rama limpia **`landing/integration`**.
- Creamos la estructura base para la sección de métricas de la plataforma en la Landing Page (`platform_metrics.dart`, `platform_metrics_model.dart`, `metrics_remote_datasource.dart`, `metrics_provider.dart`).

---

### Pendientes sugeridos para mañana:

1. Finalizar la integración visual de la **Sección de Métricas** (`GET /api/metrics/platform`) en la Landing Page.
2. Hacer una ronda de pruebas generales con los endpoints corregidos por el equipo de backend.

¡Que descanses! Quedó una arquitectura sólida y limpia lista para continuar.
