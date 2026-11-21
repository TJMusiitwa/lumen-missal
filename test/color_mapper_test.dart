import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumen_missal/theme/color_mapper.dart';
import 'package:lumen_missal/theme/popup_theme.dart';

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
      expect(mapLiturgicalColor('  WHITE '), Colors.white);
      expect(mapLiturgicalColor('gold'), const Color(0xFFFFD700));
    });

    test('maps red correctly', () {
      expect(mapLiturgicalColor('red'), const Color(0xFF8B0000));
    });

    test('maps rose correctly', () {
      expect(mapLiturgicalColor('rose'), const Color(0xFFFFC0CB));
      expect(mapLiturgicalColor('pink'), const Color(0xFFFFC0CB));
    });

    test('does not assign a liturgical color to an unknown name', () {
      expect(mapLiturgicalColor('unknown'), isNull);
    });
  });
  test('keeps each distinct LitCal option and uses its first known colour', () {
    final theme = ColorScheme.fromSeed(seedColor: Colors.deepPurple);
    final palette = LiturgicalPalette.forDay(theme, [
      '',
      'unknown',
      'red',
      'white',
      'RED',
    ]);
    expect(palette.swatches.map((swatch) => swatch.label), ['Red', 'White']);
    expect(palette.surface, LiturgicalPalette.forDay(theme, ['red']).surface);
    expect(
      LiturgicalPalette.forDay(theme, ['unknown']).surface,
      theme.surfaceContainerLow,
    );
  });

  test(
    'keeps date, swatch labels and reading accents legible in both themes',
    () {
      for (final brightness in Brightness.values) {
        final theme = popupTheme(brightness).colorScheme;
        for (final name in [
          'green',
          'purple',
          'white',
          'gold',
          'red',
          'rose',
        ]) {
          final palette = LiturgicalPalette.forDay(theme, [name]);
          for (final background in [theme.surface, palette.surface]) {
            final luminances = [
              palette.accent.computeLuminance(),
              background.computeLuminance(),
            ]..sort();
            expect(
              (luminances.last + 0.05) / (luminances.first + 0.05),
              greaterThanOrEqualTo(4.5),
              reason: '$name in ${brightness.name}',
            );
          }
        }
      }
    },
  );
}
