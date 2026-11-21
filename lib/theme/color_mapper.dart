import 'package:flutter/material.dart';

Color? mapLiturgicalColor(String colorName) =>
    switch (colorName.trim().toLowerCase()) {
      'green' => const Color(0xff228b22),
      'purple' || 'violet' => const Color(0xff6a0dad),
      'white' => Colors.white,
      'gold' => const Color(0xffffd700),
      'red' => const Color(0xff8b0000),
      'rose' || 'pink' => const Color(0xffffc0cb),
      _ => null,
    };

typedef LiturgicalSwatch = ({String label, Color color});

class const LiturgicalPalette(
  final Color surface,
  final Color accent,
  final List<LiturgicalSwatch> swatches,
) {
  factory LiturgicalPalette.forDay(
    ColorScheme theme,
    Iterable<String> colorNames,
  ) {
    final swatches = {
      for (final name in colorNames)
        ?mapLiturgicalColor(name): switch (name.trim().toLowerCase()) {
          'violet' => 'Purple',
          'pink' => 'Rose',
          final label => '${label[0].toUpperCase()}${label.substring(1)}',
        },
    }.entries.map((entry) => (label: entry.value, color: entry.key)).toList();
    final seed = swatches.firstOrNull?.color;
    if (seed == null) {
      return LiturgicalPalette(
        theme.surfaceContainerLow,
        theme.primary,
        swatches,
      );
    }

    final dark = theme.brightness == Brightness.dark;
    // A small amount of the liturgical color keeps the card readable in
    // either theme. Preserve the unmodified color in the labelled swatch.
    return LiturgicalPalette(
      Color.alphaBlend(
        seed.withValues(alpha: dark ? 0.11 : 0.09),
        theme.surface,
      ),
      Color.lerp(theme.onSurface, seed, 0.32)!,
      swatches,
    );
  }
}
