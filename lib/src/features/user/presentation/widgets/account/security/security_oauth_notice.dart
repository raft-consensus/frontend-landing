import 'package:flutter/material.dart';

/// Banner informativo cuando la cuenta fue creada mediante OAuth.
/// 
/// ¿Qué hace?: Notifica visualmente al usuario que su inicio de sesión se gestiona por Google o GitHub.
/// ¿De dónde recibe datos?: Del proveedor de OAuth registrado en la sesión ([provider]).
/// ¿Hacia dónde se conecta?: Renderizado en SecurityCard si el usuario no usa contraseña local.
class SecurityOauthNotice extends StatelessWidget {
  const SecurityOauthNotice({
    required this.provider,
    super.key,
  });

  final String provider;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = isDark 
        ? Colors.amber.shade900.withValues(alpha: 0.2) 
        : Colors.amber.shade50;
    final borderColor = isDark 
        ? Colors.amber.shade700.withValues(alpha: 0.5) 
        : Colors.amber.shade200;
    final textColor = isDark 
        ? Colors.amber.shade200 
        : Colors.amber.shade900;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: textColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Iniciaste sesión mediante OAuth ($provider). Esta cuenta no utiliza contraseña local.',
              style: TextStyle(color: textColor, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
