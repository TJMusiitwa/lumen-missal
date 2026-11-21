import 'package:flutter/material.dart';

Color mapLiturgicalColor(String colorName) {
  final lowerCaseColor = colorName.toLowerCase();

  return switch (lowerCaseColor) {
    'green' => const Color(0xFF228B22), // Deep forest green
    'purple' || 'violet' => const Color(0xFF6A0DAD), // Rich violet
    'white' || 'gold' => const Color(0xFFFFD700), // Soft gold/amber
    'red' => const Color(0xFF8B0000), // Deep crimson
    'rose' || 'pink' => const Color(0xFFFFC0CB), // Soft pink
    _ => const Color(0xFF0175C2), // Default blue
  };
}
