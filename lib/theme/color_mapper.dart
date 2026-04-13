import 'package:flutter/material.dart';

Color mapLiturgicalColor(String colorName) {
  final lowerCaseColor = colorName.toLowerCase();

  switch (lowerCaseColor) {
    case 'green':
      return const Color(0xFF228B22); // Deep forest green
    case 'purple':
    case 'violet':
      return const Color(0xFF6A0DAD); // Rich violet
    case 'white':
    case 'gold':
      return const Color(0xFFFFD700); // Soft gold/amber
    case 'red':
      return const Color(0xFF8B0000); // Deep crimson
    case 'rose':
    case 'pink':
      return const Color(0xFFFFC0CB); // Soft pink
    default:
      return const Color(0xFF0175C2); // Default blue
  }
}
