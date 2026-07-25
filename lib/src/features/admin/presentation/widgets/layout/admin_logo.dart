import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core

class AdminLogo extends StatelessWidget {
  const AdminLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 7),
      child: Row(
        children: [
          LogoIcon(),
          SizedBox(width: 10),
          Text(
            'Raft',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(width: 3),
          Text(
            'DB',
            style: TextStyle(
              color: AppColors.cyan,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          Spacer(),
          Text(
            'ADMIN',
            style: TextStyle(
              color: Color(0xFF758AA6),
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class LogoIcon extends StatelessWidget {
  const LogoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43,
      height: 43,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.cyan, AppColors.blue],
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Icon(
        Icons.sailing_rounded,
        color: Colors.white,
        size: 26,
      ),
    );
  }
}
