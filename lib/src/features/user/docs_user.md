Edited docs_user.md
Viewed borrador_user.dart:1-30
Edited borrador_user.dart

Aquí tienes la documentación técnica mejorada y **100% libre de stickers o emojis**, respetando estrictamente las reglas del proyecto.

Puedes colocar este contenido en [lib/src/features/user/docs_user.md](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/docs_user.md) o `readmi_user.md`:

```markdown
# Documentación Técnica del Módulo User Dashboard

## 1. Descripción General
El módulo `user` contiene la interfaz web de gestión para los usuarios autenticados del sistema Raft DB. Este panel de control permite crear y administrar instancias de bases de datos relacionales y NoSQL (PostgreSQL, MySQL, MongoDB, SQL Server), consultar credenciales seguras de conexión, acceder a gestores web integrados, revisar guías de integración técnica por lenguaje y gestionar los datos del perfil y la suscripción.

---

## 2. Arquitectura de la Feature (`lib/src/features/user/`)

El módulo sigue los principios de Clean Architecture combinados con la organización Feature-First orientada a la web. Garantiza la separación entre el dominio, los componentes gráficos reutilizables y las vistas principales.

```text
lib/src/features/user/
├── domain/
│   └── entities/
│       ├── database_instance.dart  # Entidad inmutable que representa una instancia de BD.
│       ├── databse_engine.dart     # Entidad que define las propiedades de los motores soportados.
│       ├── sidebar_item_data.dart  # Entidad para las opciones del menú lateral.
│       ├── tool_data.dart          # Entidad para herramientas web de administración.
│       └── guide_data.dart         # Entidad para tutoriales y bloques de código.
│
└── presentation/
    ├── pages/
    │   ├── dashboard_page.dart     # Orquestador principal del portal de usuario.
    │   ├── overview_page.dart      # Vista 0: Resumen General con métricas y gráficos.
    │   ├── databases_page.dart     # Vista 1: Administración y filtrado de instancias de BD.
    │   ├── tools_page.dart         # Vista 2: Catálogo de herramientas web externas.
    │   ├── documentation_page.dart # Vista 3: Guías de conexión y snippets por lenguaje.
    │   └── account_page.dart       # Vista 4: Configuración de perfil, clave y plan.
    │
    └── widgets/
        ├── common/                 # Widgets atómicos compartidos.
        │   ├── dashboard_card.dart        # Contenedor visual estilizado con bordes y sombra.
        │   ├── dashboard_scroll_view.dart # Envoltorio de scroll con padding responsivo.
        │   ├── engine_icon.dart           # Insignia gráfica del motor de BD.
        │   ├── engine_style.dart          # Mapeador de colores e iconos por motor.
        │   ├── field_label.dart           # Etiqueta de texto para campos de entrada.
        │   ├── info_banner.dart           # Banner decorativo para avisos y alertas.
        │   ├── info_line.dart             # Fila descriptiva (icono, etiqueta y valor).
        │   ├── section_header.dart        # Encabezado estándar para secciones.
        │   └── status_badge.dart          # Etiqueta de estado (Activa / Detenida).
        │
        ├── dialogs/                # Modales y sus sub-componentes.
        │   ├── create_database_dialog.dart # Modal para la creación de una nueva BD.
        │   ├── engine_picker_grid.dart     # Cuadrícula de selección entre motores.
        │   ├── credentials_dialog.dart     # Modal para consulta de credenciales seguras.
        │   ├── credential_item.dart        # Fila individual de credencial con opción de copia.
        │   ├── notifications_dialog.dart   # Modal de lista de notificaciones.
        │   └── notification_item.dart      # Fila individual de notificación.
        │
        ├── layout/                 # Estructura visual persistente.
        │   ├── raft_logo.dart          # Isotipo y logotipo de Raft DB.
        │   ├── sidebar_item.dart       # Botón de menú lateral con estado activo.
        │   ├── sidebar_user.dart       # Tarjeta de perfil e inicio/cierre de sesión.
        │   ├── dashboard_sidebar.dart  # Menú lateral completo con indicador de cuota.
        │   └── dashboard_topbar.dart   # Barra superior con buscador y notificaciones.
        │
        ├── overview/               # Widgets específicos de la sección Resumen.
        │   ├── welcome_banner.dart     # Banner superior de bienvenida con gradiente.
        │   ├── metric_card.dart        # Tarjetas de métricas clave.
        │   ├── usage_chart_card.dart   # Gráfico en lienzo (CustomPainter) de tráfico.
        │   ├── compact_database.dart   # Tarjeta corta para acceso rápido a BD.
        │   └── activity_section.dart   # Registro cronológico de actividad reciente.
        │
        ├── databases/              # Widgets específicos de la sección Bases de Datos.
        │   ├── database_management_card.dart # Tarjeta de administración de la instancia.
        │   └── empty_databases.dart          # Vista para estados vacíos o sin resultados.
        │
        ├── tools/                  # Widgets específicos de la sección Herramientas.
        │   └── tool_card.dart          # Tarjeta informativa para abrir herramientas.
        │
        ├── documentation/          # Widgets específicos de la sección Documentación.
        │   └── guide_card.dart         # Tarjeta expandible con código de ejemplo.
        │
        └── account/                # Widgets específicos de la sección Mi Cuenta.
            ├── profile_info_card.dart  # Formulario de datos personales.
            ├── security_card.dart      # Formulario de cambio de contraseña.
            └── plan_details_card.dart  # Detalles y cuotas del plan actual.
```

---

## 3. Enrutamiento e Integración (`AppRouter`)

La navegación hacia el portal de usuario está integrada con la librería `go_router` en `lib/src/core/routers/app_router.dart`:

1. **Ruta de Autenticación (`/login`)**:
   En `LoginScreen`, al presionar el botón de inicio de sesión o realizar la autenticación social (Google / GitHub), se redirige mediante la instrucción:
   `context.go('/dashboard');`

2. **Ruta del Dashboard (`/dashboard`)**:
   Esta ruta está asociada directamente al widget `DashboardPage`, el cual carga el menú lateral, la barra superior y las 5 sub-páginas mediante un `IndexedStack`.

---

## 4. Estándar de Documentación de Código

Cada archivo `.dart` dentro de la carpeta `lib/src/features/user/` cuenta con un encabezado estructurado mediante comentarios de documentación que responden a tres preguntas clave:

* `/// ¿Qué hace?:` Explica la responsabilidad técnica del archivo o widget.
* `/// ¿De dónde trae?:` Enumera los módulos consumidos (core, domain, otros widgets).
* `/// ¿Hacia dónde va / Cómo se conecta?:` Especifica qué archivo lo importa o renderiza.

---

## 5. Principios de Diseño y Responsividad

* **Diseño Atómico:** Ningún archivo de presentación supera las 130 líneas. Los sub-componentes complejos se dividieron en piezas pequeñas.
* **Paleta Centralizada:** Todos los colores visuales se consumen desde la abstracción central `AppColors` (`lib/src/core/theme/app_colors.dart`).
* **Adaptabilidad Web y Móvil:** Uso de `LayoutBuilder` y `MediaQuery` para mostrar un panel con menú fijo de 260px en pantallas grandes (>= 900px) o un menú deslizante tipo `Drawer` en dispositivos de menor resolución (< 900px).
```
