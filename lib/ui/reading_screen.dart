import 'dart:convert';

import 'package:material_ui/material_ui.dart';
import 'package:lumen_missal/settings/settings_notifier.dart';
import 'package:lumen_missal/state/calendar_notifier.dart';
import 'package:lumen_missal/state/reading_notifier.dart';
import 'package:lumen_missal/ui/settings_screen.dart';

class ReadingScreen extends StatefulWidget {
  final ReadingNotifier notifier;
  final SettingsNotifier settingsNotifier;
  final CalendarNotifier calendarNotifier;

  const ReadingScreen({
    super.key,
    required this.notifier,
    required this.settingsNotifier,
    required this.calendarNotifier,
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
                    calendarNotifier: widget.calendarNotifier,
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (data.season != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      data.season!.toUpperCase(),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.secondary,
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Text(
                  data.title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 28,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      context,
                      'Color: ${data.liturgicalColorName.toUpperCase()}',
                      Icons.palette,
                    ),
                    if (data.grade != null)
                      _buildInfoChip(context, data.grade!, Icons.grade),
                    if (data.liturgicalYear != null)
                      _buildInfoChip(
                        context,
                        data.liturgicalYear!,
                        Icons.calendar_today,
                      ),
                    if (data.psalterWeek != null)
                      _buildInfoChip(
                        context,
                        'Psalter Week ${data.psalterWeek}',
                        Icons.menu_book,
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                ...readings.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primaryContainer,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            entry.key
                                .replaceAllMapped(
                                  RegExp(r'([A-Z])'),
                                  (match) => ' ${match.group(0)}',
                                )
                                .trim()
                                .toUpperCase(),
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          entry.value.toString(),
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontSize: 19,
                                fontStyle:
                                    entry.key.contains('Psalm') ||
                                        entry.key.contains('Acclamation')
                                    ? FontStyle.italic
                                    : FontStyle.normal,
                              ),
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

  Widget _buildInfoChip(BuildContext context, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
