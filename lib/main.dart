import 'package:flutter/material.dart';

import 'api/litcal_api.dart';
import 'database/database.dart';
import 'settings/settings_notifier.dart';
import 'settings/settings_service.dart';
import 'state/calendar_notifier.dart';
import 'state/reading_notifier.dart';
import 'theme/popup_theme.dart';
import 'ui/reading_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = SettingsNotifier(settingsService: SettingsService());
  final litCal = LitCalApi();
  await settings.loadSettings();

  runApp(
    MyApp(
      readingNotifier: ReadingNotifier(
        database: AppDatabase(),
        settingsNotifier: settings,
        litCalApi: litCal,
      ),
      settingsNotifier: settings,
      calendarNotifier: CalendarNotifier(api: litCal),
    ),
  );
}

class const MyApp({
  required final ReadingNotifier readingNotifier,
  required final SettingsNotifier settingsNotifier,
  required final CalendarNotifier calendarNotifier,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: settingsNotifier,
    builder: (context, child) => MaterialApp(
      title: 'Lumen Missal',
      themeMode: settingsNotifier.themeMode,
      themeAnimationDuration: Duration.zero,
      debugShowCheckedModeBanner: false,
      theme: popupTheme(Brightness.light),
      darkTheme: popupTheme(Brightness.dark),
      // Pointer-driven passage navigation has its own transition. Settings
      // and keyboard navigation open immediately.
      home: child,
    ),
    child: ReadingScreen(
      notifier: readingNotifier,
      settingsNotifier: settingsNotifier,
      calendarNotifier: calendarNotifier,
    ),
  );
}
