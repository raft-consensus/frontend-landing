
# Documentación y Plan de Modularización - Pantalla de Registro (Raft DB)

## 1. Análisis de Secciones y Componentes

El archivo `borrador_register.dart` consta de 1,062 líneas en una estructura monolítica. Contiene la configuración del tema visual de autenticación, la pantalla principal de registro (`RegisterPage`), subcomponentes UI y un fondo animado en 2D.

### A. Configuración y Estructura Principal

* **RegisterApp (Líneas 1 - 74):** Configuración local del `MaterialApp`, definición de colores (`AppColors`) y estilo global de los campos de texto (`inputDecorationTheme`).
* **RegisterPage (Líneas 76 - 288):** `StatefulWidget` que gestiona:
  * Controladores de formulario (`_nameController`, `_emailController`, `_passwordController`).
  * Controlador de animación para el fondo (`_backgroundController`).
  * Estado del formulario (`_hidePassword`, `_acceptTerms`, `_loading`).
  * Responsividad con `LayoutBuilder` y animación de entrada fade/slide con `TweenAnimationBuilder`.

### B. Desglose de Componentes

#### 1. Panel de Presentación Izquierdo (RegisterPresentation)

* **Componente Principal:** `RegisterPresentation` (Líneas 290 - 343). Visible en pantalla grande (escritorio >= 900px). Muestra el logo, distintivo de estado ("REGISTRO GRATUITO"), título destacado, subtítulo y 3 viñetas descriptivas (`FeatureItem`).
* **Subcomponentes:**
  * `RaftLogo` (Líneas 366 - 418): Logo oficial de Raft DB con gradiente cyan a azul e icono de velero.
  * `StatusPill` (Líneas 420 - 450): Badge azul cyan redondeado con punto indicador.
  * `FeatureItem` (Líneas 452 - 501): Fila descriptiva con caja de icono translúcida, título y texto.

#### 2. Encabezado Móvil (MobileBrand)

* **Componente:** `MobileBrand` (Líneas 345 - 364). Muestra una versión compacta del logo y subtítulo para dispositivos móviles.

#### 3. Tarjeta de Formulario (RegisterCard)

* **Componente Principal:** `RegisterCard` (Líneas 503 - 774). Tarjeta blanca flotante con bordes redondeados (27px) y sombra profunda.
* **Elementos Internos:**
  * Título ("Crea tu cuenta") y subtítulo.
  * Botones de registro social con Google y GitHub (`SocialButton`).
  * Divisor de texto ("o regístrate con correo") (`AuthDivider`).
  * Campo `TextFormField` para Nombre con icono de usuario.
  * Campo `TextFormField` para Correo electrónico con validación de sintaxis.
  * Campo `TextFormField` para Contraseña con botón de alternar visibilidad (`Icons.visibility`).
  * Indicación de seguridad de clave (letras, números y símbolos).
  * Checkbox de aceptación de Términos y Política de privacidad.
  * Botón principal `FilledButton` ("Crear cuenta") con estado de carga `AnimatedSwitcher` y `CircularProgressIndicator`.
  * Enlace inferior para alternar hacia el Login ("¿Ya tienes una cuenta? Inicia sesión").

#### 4. Subcomponentes Reutilizables de Autenticación

* `FieldLabel` (Líneas 776 - 793): Etiqueta en negrita sobre cada campo de texto.
* `SocialButton` (Líneas 795 - 833): Botón `OutlinedButton.icon` para inicio social.
* `AuthDivider` (Líneas 835 - 859): Línea divisora horizontal con texto en el centro.

#### 5. Fondo Animado 2D (DatabaseBackgroundPainter)

* `DatabaseBackgroundPainter` (Líneas 861 - 1062): `CustomPainter` que dibuja un fondo oscuro en degradado, malla cuadriculada, red de nodos interconectados con efecto de pulso y cilindros de base de datos flotantes.

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
            ├── www/                          # Estructura www solicitada para modelos
            │   └── register_form_data.dart
            └── presentation/
                ├── screens/
                │   └── register_screen.dart  # Pantalla principal limpia
                └── widgets/
                    ├── common/               # Compartidos entre Login y Register
                    │   ├── auth_background.dart
                    │   ├── auth_divider.dart
                    │   ├── field_label.dart
                    │   └── social_button.dart
                    └── register/             # Exclusivos de Registro
                        ├── feature_item.dart
                        ├── register_card.dart
                        └── register_presentation.dart
```
