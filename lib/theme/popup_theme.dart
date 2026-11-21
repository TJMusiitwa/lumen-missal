import 'package:flutter/material.dart';

const popupEaseOut = Cubic(0.23, 1, 0.32, 1);
const popupPadding = 22.0;

ThemeData popupTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final colors =
      ColorScheme.fromSeed(
        seedColor: dark ? const Color(0xff718597) : const Color(0xff6455a4),
        brightness: brightness,
      ).copyWith(
        surface: dark ? const Color(0xff1b1d20) : const Color(0xfffdfcfe),
        onSurface: dark ? const Color(0xfff0f2f4) : const Color(0xff23212a),
        onSurfaceVariant: dark
            ? const Color(0xffb9c0c7)
            : const Color(0xff5f586b),
        surfaceContainerLow: dark
            ? const Color(0xff23262a)
            : const Color(0xfff7f5f9),
        surfaceContainer: dark
            ? const Color(0xff2b2f34)
            : const Color(0xffefedf4),
        outlineVariant: dark
            ? const Color(0xff373c42)
            : const Color(0xffe3dfeb),
        outline: dark ? const Color(0xff8a929a) : null,
        secondaryContainer: dark ? const Color(0xff37434d) : null,
        onSecondaryContainer: dark ? const Color(0xffdfebf4) : null,
        primary: dark ? const Color(0xffc4d3df) : const Color(0xff544387),
        primaryContainer: dark
            ? const Color(0xff303943)
            : const Color(0xffece5fa),
        onPrimaryContainer: dark
            ? const Color(0xffe3ebf2)
            : const Color(0xff30234f),
      );
  return ThemeData(
    colorScheme: colors,
    fontFamily: 'Inter',
    scaffoldBackgroundColor: dark
        ? const Color(0xff111315)
        : const Color(0xffecebf0),
    dividerColor: colors.outlineVariant,
    textSelectionTheme: TextSelectionThemeData(
      selectionColor: colors.primary.withValues(alpha: 0.3),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceContainerLow,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    ),
    textTheme: const TextTheme(
      headlineSmall: TextStyle(
        fontSize: 25,
        height: 1.18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.7,
      ),
      titleLarge: TextStyle(
        fontSize: 19,
        height: 1.27,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.4,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        height: 1.35,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: TextStyle(fontSize: 17, height: 1.65),
      bodyMedium: TextStyle(fontSize: 13, height: 1.5),
      bodySmall: TextStyle(fontSize: 12, height: 1.45),
    ),
  );
}

class const PopupFrame(final Widget child, {super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final inTab = constraints.maxWidth >= 520;
          if (!inTab) {
            return Material(color: colors.surface, child: child);
          }

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: 428,
                  maxHeight: 640,
                ),
                child: Material(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  elevation: 8,
                  shadowColor: colors.brightness == Brightness.dark
                      ? Colors.black54
                      : const Color(0x40201b30),
                  child: child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class const PopupToolbar({
  required final Widget leading,
  required final List<Widget> actions,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.fromLTRB(popupPadding, 7, 12, 7),
        child: Row(
          children: [
            Expanded(child: leading),
            ...actions,
          ],
        ),
      ),
      const Divider(height: 1),
    ],
  );
}

class const PopupIconButton({
  required final IconData icon,
  required final String tooltip,
  required final VoidCallback? onPressed,
  super.key,
}) extends StatefulWidget {
  @override
  State<PopupIconButton> createState() => _PopupIconButtonState();
}

class _PopupIconButtonState extends State<PopupIconButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final motion = !MediaQuery.disableAnimationsOf(context);
    return Listener(
      onPointerDown: widget.onPressed == null || !motion
          ? null
          : (_) => setState(() => _pressed = true),
      onPointerUp: (_) => _release(),
      onPointerCancel: (_) => _release(),
      child: AnimatedScale(
        duration: motion ? const Duration(milliseconds: 120) : Duration.zero,
        curve: popupEaseOut,
        scale: motion && _pressed ? 0.96 : 1,
        child: IconButton(
          tooltip: widget.tooltip,
          onPressed: widget.onPressed,
          icon: Icon(widget.icon, size: 20),
        ),
      ),
    );
  }

  void _release() {
    if (_pressed) setState(() => _pressed = false);
  }
}
