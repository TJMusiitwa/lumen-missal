import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'database/database.dart';
import 'state/reading_notifier.dart';
import 'theme/color_mapper.dart';
import 'settings/settings_service.dart';
import 'settings/settings_notifier.dart';
import 'ui/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();
  final settingsService = SettingsService();
  final settingsNotifier = SettingsNotifier(settingsService: settingsService);

  // Load settings before running app
  await settingsNotifier.loadSettings();

  final readingNotifier = ReadingNotifier(
    database: database,
    settingsNotifier: settingsNotifier,
  );

  runApp(MyApp(
    readingNotifier: readingNotifier,
    settingsNotifier: settingsNotifier,
  ));
}

class MyApp extends StatelessWidget {
  final ReadingNotifier readingNotifier;
  final SettingsNotifier settingsNotifier;

  const MyApp({
    super.key,
    required this.readingNotifier,
    required this.settingsNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([readingNotifier, settingsNotifier]),
      builder: (context, child) {
        final liturgicalColorName = readingNotifier.data?.liturgicalColorName ?? 'green';
        final seedColor = mapLiturgicalColor(liturgicalColorName);

        final textTheme = TextTheme(
          bodyLarge: GoogleFonts.crimsonText(fontSize: 18, height: 1.5),
          bodyMedium: GoogleFonts.crimsonText(fontSize: 16, height: 1.5),
          titleLarge: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600),
          labelLarge: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
        );

        return MaterialApp(
          title: 'Lumen Missal',
          themeMode: settingsNotifier.themeMode,
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
          ),
        );
      },
    );
  }
}

class ReadingScreen extends StatefulWidget {
  final ReadingNotifier notifier;
  final SettingsNotifier settingsNotifier;

  const ReadingScreen({
    super.key,
    required this.notifier,
    required this.settingsNotifier,
  });

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.notifier.loadTodayReading();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Readings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    settingsNotifier: widget.settingsNotifier,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: widget.notifier,
        builder: (context, child) {
          if (widget.notifier.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (widget.notifier.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error loading readings:\n${widget.notifier.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final data = widget.notifier.data;
          if (data == null) {
            return const Center(child: Text('No readings available.'));
          }

          Map<String, dynamic> readings = {};
          try {
            readings = json.decode(data.readingsJson) as Map<String, dynamic>;
          } catch (e) {
            readings = {'Error': 'Failed to parse readings json'};
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Liturgical Color: ${data.liturgicalColorName.toUpperCase()}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 24),
                ...readings.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          entry.value.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
