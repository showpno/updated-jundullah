import 'package:flutter/material.dart';

import '../../../utility/app_color.dart';


class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const AppBarActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [AppColor.primary, AppColor.brandGold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
      ),
    );
  }
}
