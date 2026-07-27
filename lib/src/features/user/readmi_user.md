# Documentación y Plan de Modularización - User Feature (Raft DB)

Documento de arquitectura y plan de migración para la feature de **User** (`lib/src/features/user/`), aplicando **Clean Architecture** (Dominio, Datos, Presentación) y principios de **Flutter Web (Feature-First)**.

---

## 1. Análisis de Secciones y Componentes

El archivo original (`borrador_user.dart`) constaba de 3,938 líneas monolíticas que contienen la experiencia completa del portal del usuario.

### A. Estructura Principal y Navegación
* **RaftDashboardApp:** `MaterialApp` de pruebas y tema base.
* **DashboardPage:** Orquestador principal de la vista en `presentation/pages/dashboard_page.dart`. Maneja el índice activo (`_selectedIndex`), el estado de las instancias de bases de datos (`_instances`), el `Scaffold`, el `Drawer` responsivo para móvil y la navegación entre las 5 páginas.
* **DashboardSidebar & DashboardTopbar:** Estructura de navegación persistente (lateral y superior).

### B. Desglose por Capas (Clean Architecture)

#### 1. Capa de Dominio (`domain/`)
Contiene los modelos y reglas de negocio puras, independientes de paquetes externos o llamadas a la red:
* `domain/entities/database_instance.dart`: Entidad principal de una instancia de BD.
* `domain/entities/database_engine.dart`: Metadata de los motores (PostgreSQL, MySQL, MongoDB, SQL Server).
* `domain/entities/sidebar_item_data.dart`, `tool_data.dart`, `guide_data.dart`: Entidades livianas para datos de UI.
* `domain/repositories/`: (Reservado para contratos abstractos de acceso a datos).

#### 2. Capa de Datos (`data/`)
*(Estructura lista para integración con API REST/GraphQL Backend)*:
* `data/models/`: DTOs con métodos `fromJson()` y `toJson()`.
* `data/datasources/`: Clientes de conexión HTTP/WebSockets.
* `data/repositories/`: Implementaciones concretas de las interfaces de dominio.

#### 3. Capa de Presentación (`presentation/`)

##### Páginas Web (`presentation/pages/`)
* `dashboard_page.dart`: Contenedor base con navegación y estado global del portal.
* `overview_page.dart`: Vista principal con resumen de métricas y gráficos de consumo.
* `databases_page.dart`: Vista de gestión y administración de bases de datos.
* `tools_page.dart`: Catálogo de herramientas SQL/NoSQL integradas y visor de snippets.
* `documentation_page.dart`: Centro de guías de inicio rápido e integración.
* `account_page.dart`: Vista de configuración de cuenta, perfil y seguridad.

##### Componentes Visuales (`presentation/widgets/`)
* **`layout/`**: `dashboard_sidebar.dart`, `sidebar_item.dart`, `sidebar_user.dart`, `dashboard_topbar.dart`, `raft_logo.dart`.
* **`common/`**: `dashboard_scroll_view.dart`, `dashboard_card.dart`, `section_header.dart`, `engine_icon.dart`, `engine_style.dart`, `status_badge.dart`, `info_line.dart`, `field_label.dart`.
* **`overview/`**: `welcome_banner.dart`, `metric_card.dart`, `usage_chart_card.dart`, `usage_chart_painter.dart`, `account_usage_card.dart`, `compact_database_card.dart`, `activity_section.dart`.
* **`databases/`**: `database_management_card.dart`, `empty_databases.dart`.
* **`tools/`**: `tool_card.dart`, `code_preview.dart`.
* **`documentation/`**: `guide_card.dart`.
* **`account/`**: `settings_title.dart`, `settings_switch.dart`, `settings_action.dart`.
* **`dialogs/`**: `create_database_dialog.dart`, `credentials_dialog.dart`, `notifications_dialog.dart`.

---

## 2. Estructura Oficial de Carpetas Objetivo

```text
lib/src/features/user/
├── domain/                                   # CAPA DE DOMINIO (Lógica de Negocio)
│   ├── entities/                             # Entidades puras de Dart
│   │   ├── database_instance.dart
│   │   ├── database_engine.dart
│   │   ├── tool_data.dart
│   │   ├── guide_data.dart
│   │   └── sidebar_item_data.dart
│   └── repositories/                         # Contratos e Interfaces
├── data/                                     # CAPA DE DATOS (Infraestructura / API)
│   ├── datasources/                          # Clientes API HTTP
│   ├── models/                               # DTOs Mapeadores JSON
│   └── repositories/                         # Implementaciones de Repositorios
├── presentation/                             # CAPA DE PRESENTACIÓN (UI / Web)
│   ├── pages/                                # Páginas navegables del portal
│   │   ├── dashboard_page.dart
│   │   ├── overview_page.dart
│   │   ├── databases_page.dart
│   │   ├── tools_page.dart
│   │   ├── documentation_page.dart
│   │   └── account_page.dart
│   └── widgets/                              # Componentes divididos por contexto
│       ├── common/
│       ├── layout/
│       ├── overview/
│       ├── databases/
│       ├── tools/
│       ├── documentation/
│       ├── account/
│       └── dialogs/
└── readmi_user.md                            # Documentación técnica de la feature
