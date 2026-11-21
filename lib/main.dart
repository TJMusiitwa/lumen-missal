import 'package:material_ui/material_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lumen_missal/ui/reading_screen.dart';

import 'database/database.dart';
import 'settings/settings_notifier.dart';
import 'settings/settings_service.dart';
import 'state/calendar_notifier.dart';
import 'state/reading_notifier.dart';
import 'theme/color_mapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final settingsService = SettingsService();
  final settingsNotifier = SettingsNotifier(settingsService: settingsService);

  await settingsNotifier.loadSettings();

  final calendarNotifier = CalendarNotifier();

  final readingNotifier = ReadingNotifier(
    database: database,
    settingsNotifier: settingsNotifier,
  );

  runApp(
    MyApp(
      readingNotifier: readingNotifier,
      settingsNotifier: settingsNotifier,
      calendarNotifier: calendarNotifier,
    ),
  );
}

class MyApp extends StatelessWidget {
  final ReadingNotifier readingNotifier;
  final SettingsNotifier settingsNotifier;
  final CalendarNotifier calendarNotifier;

  const MyApp({
    super.key,
    required this.readingNotifier,
    required this.settingsNotifier,
    required this.calendarNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([readingNotifier, settingsNotifier]),
      builder: (context, child) {
        final liturgicalColorName =
            readingNotifier.data?.liturgicalColorName ?? 'green';
        final seedColor = mapLiturgicalColor(liturgicalColorName);

        final textTheme = TextTheme(
          bodyLarge: GoogleFonts.crimsonText(fontSize: 18, height: 1.5),
          bodyMedium: GoogleFonts.crimsonText(fontSize: 16, height: 1.5),
          titleLarge: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          labelLarge: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        );

        return MaterialApp(
          title: 'Lumen Missal',
          themeMode: settingsNotifier.themeMode,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: Brightness.light,
            ),
            textTheme: textTheme,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: seedColor,
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor,
              brightness: Brightness.dark,
            ),
            textTheme: textTheme,
            scaffoldBackgroundColor: const Color(0xFF121212),
            appBarTheme: AppBarTheme(
              backgroundColor: const Color(0xFF1E1E1E),
              foregroundColor: seedColor,
            ),
          ),
          home: ReadingScreen(
            notifier: readingNotifier,
            settingsNotifier: settingsNotifier,
            calendarNotifier: calendarNotifier,
          ),
        );
      },
    );
  }
}
