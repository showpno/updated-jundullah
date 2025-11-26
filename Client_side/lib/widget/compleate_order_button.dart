import 'package:flutter/material.dart';
import 'package:nexara_cart/utility/app_color.dart';

class CompleteOrderButton extends StatelessWidget {
  final String? labelText;
  final Function()? onPressed;

  const CompleteOrderButton({
    super.key,
    this.onPressed,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      margin: const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColor.primary, AppColor.brandGold],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColor.primary.withOpacity(0.4),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
        onPressed: onPressed,
        child: Text(
          labelText ?? 'Complete Order',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
