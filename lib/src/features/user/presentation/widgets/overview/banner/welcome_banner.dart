// ==========================================
// Qué hace: Banner de bienvenida con gradiente marino que ensamble WelcomeBannerActions y WelcomeBannerIllustration.
// Dónde se conecta: Renderizado en la parte superior de OverviewPage.
// De dónde trae datos: Recibe onCreateDatabase y onGoDocumentation.
// ==========================================

import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/banner/welcome_banner_actions.dart';
import 'package:frontend_landing/src/features/user/presentation/widgets/overview/banner/welcome_banner_illustration.dart';

/// Banner principal de bienvenida del panel de usuario
class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({
    required this.onCreateDatabase, // Callback para abrir el modal de creación de BD
    required this.onGoDocumentation, // Callback para ir a la pestaña de documentación
    super.key,
  });

  final VoidCallback onCreateDatabase;
  final VoidCallback onGoDocumentation;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradientColors = isDark
        ? [const Color(0xFF0A1E32), const Color(0xFF132F4C)]
        : [const Color(0xFF092648), AppColors.dayPrimary];

    final pillBg = isDark
        ? AppColors.nightSecondary.withValues(alpha: 0.20)
        : AppColors.daySecondary.withValues(alpha: 0.25);

    final pillTextColor = isDark ? AppColors.nightSecondary : const Color(0xFF59B9E6);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 28 : 20,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Sección Izquierda: Textos y botones
          Expanded(
            flex: 3,
            child: WelcomeBannerActions(
              pillBg: pillBg,
              pillTextColor: pillTextColor,
              onCreateDatabase: onCreateDatabase,
              onGoDocumentation: onGoDocumentation,
            ),
          ),

          // 2. Sección Derecha: Ilustración náutica de la balsa
          if (isDesktop) ...[
            const SizedBox(width: 16),
            const Expanded(
              flex: 2,
              child: WelcomeBannerIllustration(),
            ),
          ],
        ],
      ),
    );
  }
}
