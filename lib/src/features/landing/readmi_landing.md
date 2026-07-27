# Documentación y Plan de Modularización - Landing Page (Raft DB)

## 1. Análisis de Secciones y Componentes

El archivo actual (`borrador_landing.dart`) consta de 1,922 líneas en una sola estructura monolítica. Contiene la configuración inicial de tema, la página principal (`LandingPage`) y 10 secciones clave con sus respectivos subcomponentes y modelos.

### A. Configuración y Estructura Principal
* **RaftDbApp (Líneas 7 - 67):** Define la aplicación `MaterialApp`, el tema global (`ThemeData`), la paleta de colores base (`navy`, `blue`, `cyan`, `background`) y la tipografía.
* **LandingPage (Líneas 69 - 95):** Contenedor principal con `Scaffold`, `SelectionArea` (para seleccionar texto) y un `SingleChildScrollView` vertical que apila las 10 secciones de la landing.

### B. Desglose de Secciones y Componentes

#### 1. Navegación (NavigationBarSection)
* **Sección Principal:** `NavigationBarSection` (Líneas 97 - 153). Barra superior responsiva. En escritorio muestra links y botones de acción; en móvil muestra un botón de menú hamburguesa.
* **Subcomponentes:**
  * `RaftLogo` (Líneas 155 - 203): Logo compuesto por icono con gradiente y texto "Raft DB".
  * `NavLink` (Líneas 205 - 224): Botón de enlace simple del menú.

#### 2. Encabezado Principal (HeroSection)
* **Sección Principal:** `HeroSection` (Líneas 226 - 369). Banner de impacto con gradiente claro y gráficos en segundo plano. Muestra títulos, descripción, 2 botones CTA (Crear cuenta / Cómo funciona) e ilustración.
* **Subcomponentes y Gráficos:**
  * `Pill` (Líneas 371 - 410): Badge redondeado ("PARA ESTUDIANTES Y DESARROLLADORES").
  * `MiniBenefit` (Líneas 412 - 438): Check verde con texto corto ("Sin tarjeta", etc.).
  * `RaftIllustration` (Líneas 440 - 559): Ilustración vectorial hecha en Flutter con la balsa, vela y discos de servidor.
  * `ServerDisk` (Líneas 561 - 590): Componente visual que simula un disco de servidor.
  * `SailClipper` (Líneas 592 - 616): CustomClipper para darle curva a la vela del barco.
  * `WaveBackground` & `WavePainter` (Líneas 618 - 665): CustomPainter que dibuja las olas de fondo.

#### 3. Motores de Bases de Datos (DatabaseSection)
* **Sección Principal:** `DatabaseSection` (Líneas 667 - 731). Muestra los 4 motores soportados (MySQL, PostgreSQL, SQL Server, MongoDB) en una cuadrícula responsiva.
* **Subcomponentes:**
  * `DatabaseCard` (Líneas 733 - 817): Tarjeta individual de base de datos con icono, estado ("Disponible") y botón "Crear instancia".

#### 4. Beneficios (BenefitsSection)
* **Sección Principal:** `BenefitsSection` (Líneas 819 - 902). Sección con fondo oscuro (navy) que resalta 6 características clave.
* **Subcomponentes y Datos:**
  * `BenefitData` (Líneas 904 - 911): Clase de modelo simple para almacenar datos del beneficio.
  * `BenefitCard` (Líneas 913 - 966): Tarjeta semi-transparente para el modo oscuro.

#### 5. Cómo Funciona (HowItWorksSection)
* **Sección Principal:** `HowItWorksSection` (Líneas 968 - 1051). Explicación paso a paso en 4 etapas (01 al 04) desde registro hasta conexión.
* **Subcomponentes y Datos:**
  * `StepData` (Líneas 1053 - 1061): Modelo de datos del paso.
  * `StepCard` (Líneas 1063 - 1125): Tarjeta con número flotante y caja de icono con gradiente.

#### 6. Dashboard Preview (DashboardSection)
* **Sección Principal:** `DashboardSection` (Líneas 1127 - 1195). Demostración del panel de control de la app.
* **Subcomponentes:**
  * `DashboardFeature` (Líneas 1197 - 1233): Viñeta con checkmark verde.
  * `DashboardMockup` (Líneas 1235 - 1329): Mockup de interfaz web que simula el navegador.
  * `DashboardDbRow` (Líneas 1331 - 1391): Fila que representa una BD activa dentro del mockup.

#### 7. Casos de Uso (UseCasesSection)
* **Sección Principal:** `UseCasesSection` (Líneas 1393 - 1453). Dirigido a Estudiantes, Desarrolladores y Docentes.
* **Subcomponentes:**
  * `UseCaseCard` (Líneas 1455 - 1496): Tarjeta blanca con icono circular centrado.

#### 8. Preguntas Frecuentes (FaqSection)
* **Sección Principal:** `FaqSection` (Líneas 1498 - 1586). Acordeón desplegable de preguntas comunes usando ExpansionTile.

#### 9. Llamado a la Acción Final (FinalCtaSection)
* **Sección Principal:** `FinalCtaSection` (Líneas 1588 - 1677). Banner azul curvo al final con botones principales para iniciar sesión o ver docs.

#### 10. Pie de Página (FooterSection)
* **Sección Principal:** `FooterSection` (Líneas 1679 - 1794). Pie de página oscuro con marca, links en columnas y derechos reservados.
* **Subcomponentes:**
  * `FooterColumn` (Líneas 1796 - 1837): Columna de enlaces de pie de página.

#### 11. Componentes Reutilizables de Maquetación (Transversales)
* **SectionContainer (Líneas 1839 - 1866):** Contenedor genérico que centra el contenido y aplica márgenes laterales y ancho máximo (1180px).
* **SectionTitle (Líneas 1868 - 1921):** Encabezado reutilizable con antetítulo (eyebrow), título grande y subtítulo.

---

## 2. Estructura de Carpetas Objetivo

```text
lib/
├── src/
│   ├── core/
│   │   └── theme/
│   │       ├── app_colors.dart
│   │       └── app_theme.dart
│   └── features/
│       └── landing/
│           ├── presentation/
│           │   ├── pages/
│           │   │   └── landing_page.dart
│           │   └── widgets/
│           │       ├── common/
│           │       │   ├── section_container.dart
│           │       │   ├── section_title.dart
│           │       │   └── raft_logo.dart
│           │       ├── navigation/
│           │       │   ├── navigation_bar_section.dart
│           │       │   └── nav_link.dart
│           │       ├── hero/
│           │       │   ├── hero_section.dart
│           │       │   ├── raft_illustration.dart
│           │       │   ├── wave_background.dart
│           │       │   ├── pill_badge.dart
│           │       │   └── mini_benefit.dart
│           │       ├── databases/
│           │       │   ├── database_section.dart
│           │       │   └── database_card.dart
│           │       ├── benefits/
│           │       │   ├── benefits_section.dart
│           │       │   ├── benefit_card.dart
│           │       │   └── benefit_data.dart
│           │       ├── how_it_works/
│           │       │   ├── how_it_works_section.dart
│           │       │   ├── step_card.dart
│           │       │   └── step_data.dart
│           │       ├── dashboard/
│           │       │   ├── dashboard_section.dart
│           │       │   ├── dashboard_mockup.dart
│           │       │   ├── dashboard_feature.dart
│           │       │   └── dashboard_db_row.dart
│           │       ├── use_cases/
│           │       │   ├── use_cases_section.dart
│           │       │   └── use_case_card.dart
│           │       ├── faq/
│           │       │   └── faq_section.dart
│           │       ├── final_cta/
│           │       │   └── final_cta_section.dart
│           │       └── footer/
│           │           ├── footer_section.dart
│           │           └── footer_column.dart
