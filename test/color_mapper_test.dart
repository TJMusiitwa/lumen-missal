import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_missal/theme/color_mapper.dart';

void main() {
  group('Color Mapper Tests', () {
    test('maps green correctly', () {
      expect(mapLiturgicalColor('green'), const Color(0xFF228B22));
      expect(mapLiturgicalColor('GREEN'), const Color(0xFF228B22));
    });

    test('maps purple correctly', () {
      expect(mapLiturgicalColor('purple'), const Color(0xFF6A0DAD));
      expect(mapLiturgicalColor('violet'), const Color(0xFF6A0DAD));
    });

    test('maps white correctly', () {
      expect(mapLiturgicalColor('white'), const Color(0xFFFFD700));
      expect(mapLiturgicalColor('gold'), const Color(0xFFFFD700));
    });

    test('maps red correctly', () {
      expect(mapLiturgicalColor('red'), const Color(0xFF8B0000));
    });

    test('maps rose correctly', () {
      expect(mapLiturgicalColor('rose'), const Color(0xFFFFC0CB));
      expect(mapLiturgicalColor('pink'), const Color(0xFFFFC0CB));
    });

    test('returns default for unknown color', () {
      expect(mapLiturgicalColor('unknown'), const Color(0xFF0175C2));
    });
  });
}
