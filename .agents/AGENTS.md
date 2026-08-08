
# AGENTS.md - Contexto e Inferencia de Arquitectura del Proyecto

## 1. Identificación del Proyecto

- Nombre del Repositorio: frontend_landing (Raft DB Frontend)
- Dominio del Proyecto: Interfaz Web y Móvil para el sistema de base de datos distribuida Raft DB.
- Lenguaje y SDK: Dart 3.12+ / Flutter SDK
- Tipo de Aplicación: Flutter Web (HTML5 PathUrlStrategy sin '#') y Móvil.

## 2. Inferencia Tecnológica y Librerías Principales

- Gestor de Estado: `flutter_riverpod` (^2.6.1) con `ProviderScope` en la raíz.
- Enrutamiento: `go_router` (^17.3.0) con notificador reactivo (`refreshListenable`) y Guards por autenticación/rol.
- Cliente HTTP: `http` (^1.2.2) encapsulado en `ApiClient` para el backend REST ASP.NET Core (`https://api.raft.andrescortes.dev`).
- Persistencia de Sesión: `shared_preferences` (^2.3.2) mediante `SessionStorage` para almacenamiento persistente del Token JWT.
- Apertura de Enlaces: `url_launcher` (^6.3.0).

## 3. Estructura del Código y Patrón Arquitectónico

El proyecto utiliza Clean Architecture organizada modularmente por features en `lib/src/`:

- `lib/main.dart`: Punto de entrada. Inicializa `usePathUrlStrategy()`, envuelve en `ProviderScope` y configura `MaterialApp.router`.
- `lib/src/core/`:
  - `network/api_client.dart`: Cliente HTTP global. Inyecta el header `Authorization: Bearer <token>`, analiza respuestas JSON y lanza `ApiException` para códigos 401, 403, 429.
  - `network/session_storage.dart`: Persistencia local del token de sesión JWT.
  - `routers/app_router.dart`: Definición de GoRouter. Protege rutas privadas (`/dashboard`, `/admin`), redirige según autenticación y rol (`Admin` vs `User`), y permite exención en `/auth/callback`.
  - `theme/app_theme.dart`: Configuración centralizada de colores, tipografías y componentes de interfaz.
- `lib/src/features/`:
  - `auth/`: Dominio, DataSources y vistas (`LoginPage`, `RegisterPage`, `AuthCallbackPage`) junto con `authProvider`.
  - `user/`: Panel de usuario (`DashboardPage`), diálogos de creación de bases de datos, credenciales y límites.
  - `admin/`: Panel de administración (`AdminDashboardPage`) para el clúster Raft.
  - `landing/`: Vista pública principal (`LandingPage`).
- `lib/docs/`: Documentación técnica interna de endpoints (`api_endpoints.md`), integración auth (`plan_auth_integration.md`) y requerimientos.

## 4. Directivas de Trabajo para el Agente (Modo Guía)

- Operar exclusivamente en Modo Guía según `.agents/rules/modo-guia.md`.
- El agente NO debe editar ni modificar ningún archivo del proyecto directamente.
- Todo código, corrección o propuesta debe ponerse en el chat para ejecución manual por parte del desarrollador.
- Prohibido utilizar stickers o emojis en archivos markdown, documentación o comentarios de código.
- Cada archivo propuesto debe incluir comentarios explicando qué hace, de dónde recibe datos y hacia dónde se conecta.
- Añadir comentarios sobre cada clase, al frente de cada atributo, encima de cada metodo y al frente o encima de cada funcion o componente importante y facil de seguir visualemente en la interfaz grafica
