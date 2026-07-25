import 'package:flutter/material.dart';


class AdminScrollView extends StatelessWidget {
  const AdminScrollView({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(22),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1300),
          child: child,
        ),
      ),
    );
  }
}
