import 'package:flutter/material.dart' show Color, Colors;

class AppColor {
  const AppColor._();

  // Jundullah Lifestyle Brand Colors (matching website)
  static const primary = Color(0xFFECBE23); // Jundullah Orange/Gold - main brand color
  static const primaryDark = Color(0xFFD4A61F); // Darker orange
  static const primaryLight = Color(0xFFF5D047); // Lighter orange
  
  // Brand accent colors
  static const brandOrange = Color(0xFFECBE23); // Jundullah orange/gold
  static const brandOrangeDark = Color(0xFFD4A61F);
  static const brandGold = Color(0xFFFFD700); // Gold accent
  static const accent = Color(0xFFECBE23); // Orange accent
  static const accent2 = Color(0xFF8B4513); // Brown accent (matching website dark brown)
  static const accent3 = Color(0xFFF5A623); // Amber
  
  // Gradient colors - Jundullah brand gradients
  static const gradientStart = Color(0xFFECBE23); // Orange
  static const gradientEnd = Color(0xFFFFD700); // Gold
  static const gradientSecondary = Color(0xFFD4A61F); // Dark orange
  
  // Background colors
  static const background = Color(0xFFF8FAFC); // Light background
  static const cardBackground = Colors.white;
  static const darkBackground = Color(0xFF2C2C2C); // Dark brown/black like website
  
  // Text colors
  static const darkAccent = Color(0xFF1F2937); // Dark text
  static const lightAccent = Color(0xFF6B7280); // Light text
  static const brandText = Color(0xFFECBE23); // Brand orange text
  
  // Old colors (for compatibility)
  static const darkGrey = Color(0xFFB0B2B7);
  static const lightGrey = Color(0xFFE6E8EC);
  
  // Status colors
  static const success = Color(0xFF10B981);
  static const warning = Color(0xFFECBE23); // Using brand orange
  static const error = Color(0xFFEF4444);
  static const info = Color(0xFFECBE23); // Using brand orange
}
