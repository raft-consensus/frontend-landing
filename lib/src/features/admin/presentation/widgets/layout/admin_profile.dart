import 'package:flutter/material.dart';
import 'package:frontend_landing/src/core/theme/app_colors.dart'; // Core


class AdminProfile extends StatelessWidget {
  const AdminProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Color(0xFF18375F),
          child: Text(
            'RA',
            style: TextStyle(
              color: AppColors.cyan,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        SizedBox(width: 11),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Raft Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Superadministrador',
                style: TextStyle(
                  color: Color(0xFF7F94AE),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Icon(
          Icons.logout_rounded,
          color: Color(0xFF8094AD),
          size: 19,
        ),
      ],
    );
  }
}
