
# Documentación y Plan de Modularización - Pantalla de Iniciar Sesión / Login (Raft DB)

## 1. Análisis de Secciones y Componentes

El archivo `borrador_login.dart` consta de 1,107 líneas en una sola estructura monolítica. Comparte la misma filosofía visual y animaciones que el registro, pero agrega la previsualización del panel de usuario (`PlatformPreview`).

### A. Configuración y Estructura Principal

* **LoginApp (Líneas 1 - 74):** Configuración local del `MaterialApp`, paleta de colores (`AppColors`) y estilo global de los campos de texto (`inputDecorationTheme`).
* **LoginPage (Líneas 76 - 280):** `StatefulWidget` que gestiona:
  * Controladores de formulario (`_emailController`, `_passwordController`).
  * Controlador de animación para el fondo (`_backgroundController`).
  * Estado del formulario (`_hidePassword`, `_rememberMe`, `_loading`).
  * Métodos de acción (`_login()`, `_socialLogin()`, `_recoverPassword()`).
  * Layout responsivo con `LayoutBuilder` y animación de entrada con `TweenAnimationBuilder`.

### B. Desglose de Componentes

#### 1. Panel de Presentación Izquierdo (LoginPresentation)

* **Componente Principal:** `LoginPresentation` (Líneas 286 - 327). Visible en pantallas escritorio (>= 900px). Muestra el logo, distintivo verde de estado ("SERVICIOS DISPONIBLES"), título ("Regresa a bordo y sigue construyendo"), subtítulo y el widget `PlatformPreview`.
* **Subcomponentes:**
  * `StatusPill` (Líneas 532 - 562): Badge verde redondeado con punto indicador activo.
  * `MobileBrand` (Líneas 456 - 475): Encabezado simplificado para dispositivos móviles.

#### 2. Vista Previa de la Plataforma (PlatformPreview)

* **Componente Principal:** `PlatformPreview` (Líneas 329 - 364). Tarjeta semi-transparente que simula el resumen de bases de datos del usuario logueado.
* **Subcomponentes:**
  * `PreviewHeader` (Líneas 366 - 396): Encabezado con icono de Dashboard, título "Tus bases de datos" y badge "2 activas".
  * `PreviewInstance` (Líneas 398 - 454): Fila que representa una instancia activa (ej. PostgreSQL, MongoDB) con su color característico y estado ("● Activa").

#### 3. Tarjeta de Formulario de Login (LoginCard)

* **Componente Principal:** `LoginCard` (Líneas 568 - 876). Tarjeta blanca flotante con bordes redondeados (27px) y sombra profunda.
* **Elementos Internos:**
  * Título ("Inicia sesión") y subtítulo.
  * Botones de acceso social con Google y GitHub (`SocialButton`).
  * Divisor de texto ("o continúa con tu correo") (`AuthDivider`).
  * Campo `TextFormField` para Correo electrónico con autocompletado `AutofillHints.email`.
  * Campo `TextFormField` para Contraseña con botón alternador de visibilidad.
  * Fila con Checkbox "Recordarme" y botón de enlace "¿Olvidaste tu contraseña?".
  * Botón principal `FilledButton` ("Iniciar sesión") con `AnimatedSwitcher` e indicador de carga `CircularProgressIndicator`.
  * Enlace inferior para cambiar hacia Registro ("¿Aún no tienes una cuenta? Regístrate gratis").

#### 4. Componentes Comunes Reutilizados

* `DatabaseBackgroundPainter`: Reutilizado de `widgets/common/auth_background.dart`.
* `FieldLabel`: Reutilizado de `widgets/common/field_label.dart`.
* `SocialButton`: Reutilizado de `widgets/common/social_button.dart`.
* `AuthDivider`: Reutilizado de `widgets/common/auth_divider.dart`.
* `RaftLogo`: Reutilizado de `widgets/common/raft_logo.dart`.

---

## 2. Estructura de Carpetas Objetivo (Uso de carpeta www)

```text
lib/
└── src/
    ├── core/
    │   └── theme/
    │       ├── app_colors.dart
    │       └── app_theme.dart
    └── features/
        └── auth/
            ├── www/                          # Modelos DTO
            │   ├── register_form_data.dart
            │   └── login_form_data.dart      # DTO de login (email, password, rememberMe)
            └── presentation/
                ├── screens/
                │   ├── register_screen.dart
                │   └── login_screen.dart     # Pantalla principal limpia de Login
                └── widgets/
                    ├── common/               # Reutilizados de la fase de Registro
                    │   ├── auth_background.dart
                    │   ├── auth_divider.dart
                    │   ├── field_label.dart
                    │   └── social_button.dart
                    └── login/                # Exclusivos de Login
                        ├── platform_preview.dart
                        ├── login_presentation.dart
                        └── login_card.dart
```
