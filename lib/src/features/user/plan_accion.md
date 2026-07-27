
## 3. Plan de Ejecución Interactivo (Checklist Clickeable)

### Paso 1: Crear Estructura de Carpetas

- [ ] `lib/src/features/user/domain/entities/`
- [ ] `lib/src/features/user/domain/repositories/`
- [ ] `lib/src/features/user/data/datasources/`
- [ ] `lib/src/features/user/data/models/`
- [ ] `lib/src/features/user/data/repositories/`
- [ ] `lib/src/features/user/presentation/pages/`
- [ ] `lib/src/features/user/presentation/widgets/common/`
- [ ] `lib/src/features/user/presentation/widgets/layout/`
- [ ] `lib/src/features/user/presentation/widgets/overview/`
- [ ] `lib/src/features/user/presentation/widgets/databases/`
- [ ] `lib/src/features/user/presentation/widgets/tools/`
- [ ] `lib/src/features/user/presentation/widgets/documentation/`
- [ ] `lib/src/features/user/presentation/widgets/account/`
- [ ] `lib/src/features/user/presentation/widgets/dialogs/`

---

### Paso 2: Extraer Entidades de Dominio (`domain/entities/`)

- [ ] `database_instance.dart` <- Extraer [DatabaseInstance](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L81-L110)
- [ ] `database_engine.dart` <- Extraer [DatabaseEngine](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L112-L126)
- [ ] `sidebar_item_data.dart` <- Extraer [SidebarItemData](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L520-L525)
- [ ] `tool_data.dart` <- Extraer [ToolData](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2209-L2221)
- [ ] `guide_data.dart` <- Extraer [GuideData](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2520-L2532)

---

### Paso 3: Extraer Componentes Comunes (`presentation/widgets/common/`)

- [ ] `dashboard_scroll_view.dart` <- Extraer [DashboardScrollView](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L3658-L3678)
- [ ] `dashboard_card.dart` <- Extraer [DashboardCard](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L3680-L3712)
- [ ] `section_header.dart` <- Extraer [SectionHeader](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L3714-L3775)
- [ ] `engine_style.dart` <- Extraer [EngineStyle y engineStyle()](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L3777-L3812)
- [ ] `engine_icon.dart` <- Extraer [EngineIcon](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L3814-L3844)
- [ ] `status_badge.dart` <- Extraer [StatusBadge](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L3846-L3877)
- [ ] `info_line.dart` <- Extraer [InfoLine](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L3879-L3920)
- [ ] `field_label.dart` <- Extraer [FieldLabel](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L3922-L3938)

---

### Paso 4: Extraer Modales y Diálogos (`presentation/widgets/dialogs/`)

- [ ] `create_database_dialog.dart` <- Extraer [CreateDatabaseDialog](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2958-L3281)
- [ ] `credentials_dialog.dart` <- Extraer [CredentialsDialog y CredentialItem](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L3283-L3539)
- [ ] `notifications_dialog.dart` <- Extraer [NotificationsDialog y NotificationItem](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L3541-L3657)

---

### Paso 5: Extraer Componentes de Layout (`presentation/widgets/layout/`)

- [ ] `raft_logo.dart` <- Extraer [RaftLogo](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L781-L829)
- [ ] `sidebar_item.dart` <- Extraer [SidebarItem](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L527-L603)
- [ ] `sidebar_user.dart` <- Extraer [SidebarUser](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L605-L661)
- [ ] `dashboard_sidebar.dart` <- Extraer [DashboardSidebar](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L398-L518)
- [ ] `dashboard_topbar.dart` <- Extraer [DashboardTopbar](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L663-L779)

---

### Paso 6: Extraer Widgets Específicos e Integrar Páginas Web (`presentation/pages/`)

- [ ] **Overview:**
  - Extraer [WelcomeBanner](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L969-L1094), [MetricCard](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L1096-L1166), [UsageChartCard](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L1168-L1363), [AccountUsageCard](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L1365-L1485), [CompactDatabaseCard](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L1487-L1590), [ActivitySection](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L1592-L1710) en `presentation/widgets/overview/`.
  - Crear `overview_page.dart` desde [OverviewPage](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L830-L967).
- [ ] **Databases:**
  - Extraer [DatabaseManagementCard](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L1859-L2047) y [EmptyDatabases](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2049-L2110) en `presentation/widgets/databases/`.
  - Crear `databases_page.dart` desde [DatabasesPage](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L1711-L1857).
- [ ] **Tools:**
  - Extraer [ToolCard](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2223-L2281) y [CodePreview](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2283-L2385) en `presentation/widgets/tools/`.
  - Crear `tools_page.dart` desde [ToolsPage](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2111-L2207).
- [ ] **Documentation:**
  - Extraer [GuideCard](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2534-L2607) en `presentation/widgets/documentation/`.
  - Crear `documentation_page.dart` desde [DocumentationPage](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2386-L2518).
- [ ] **Account:**
  - Extraer [SettingsTitle, SettingsSwitch, SettingsAction](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2827-L2957) en `presentation/widgets/account/`.
  - Crear `account_page.dart` desde [AccountPage](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L2608-L2825).

---

### Paso 7: Crear el Contenedor Principal `dashboard_page.dart`

- [ ] Crear `lib/src/features/user/presentation/pages/dashboard_page.dart` desacoplado desde [DashboardPage](file:///c:/Users/ASUS/Desktop/RIWI/complementos/celulas/raft-db/frontend_landing/lib/src/features/user/dashboard/borrador_user.dart#L128-L397).
