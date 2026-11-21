import 'package:material_ui/material_ui.dart';

import '../settings/settings_notifier.dart';
import '../state/calendar_notifier.dart';

class SettingsScreen extends StatefulWidget {
  final SettingsNotifier settingsNotifier;
  final CalendarNotifier calendarNotifier;

  const SettingsScreen({
    super.key,
    required this.settingsNotifier,
    required this.calendarNotifier,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    widget.calendarNotifier.loadMetadata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.settingsNotifier,
          widget.calendarNotifier,
        ]),
        builder: (context, child) {
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              _buildThemeSection(context),
              const Divider(),
              _buildBibleSection(context),
              const Divider(),
              _buildCalendarSection(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Appearance',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment<ThemeMode>(
                value: ThemeMode.system,
                label: Text('System'),
                icon: Icon(Icons.brightness_auto),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.light,
                label: Text('Light'),
                icon: Icon(Icons.light_mode),
              ),
              ButtonSegment<ThemeMode>(
                value: ThemeMode.dark,
                label: Text('Dark'),
                icon: Icon(Icons.dark_mode),
              ),
            ],
            selected: {widget.settingsNotifier.themeMode},
            onSelectionChanged: (Set<ThemeMode> newSelection) {
              widget.settingsNotifier.updateThemeMode(newSelection.first);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBibleSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bible Source',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Translation',
            border: OutlineInputBorder(),
          ),
          initialValue: widget.settingsNotifier.bibleTranslation,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 'cherokee',
              child: Text('Cherokee New Testament'),
            ),
            DropdownMenuItem(
              value: 'cuv',
              child: Text('Chinese Union Version'),
            ),
            DropdownMenuItem(
              value: 'bkr',
              child: Text('Bible kralická (Czech)'),
            ),
            DropdownMenuItem(
              value: 'asv',
              child: Text('American Standard Version (1901)'),
            ),
            DropdownMenuItem(
              value: 'bbe',
              child: Text('Bible in Basic English'),
            ),
            DropdownMenuItem(value: 'darby', child: Text('Darby Bible')),
            DropdownMenuItem(
              value: 'dra',
              child: Text('Douay-Rheims 1899 American Edition'),
            ),
            DropdownMenuItem(value: 'kjv', child: Text('King James Version')),
            DropdownMenuItem(value: 'web', child: Text('World English Bible')),
            DropdownMenuItem(
              value: 'ylt',
              child: Text("Young's Literal Translation (NT only)"),
            ),
            DropdownMenuItem(
              value: 'oeb-cw',
              child: Text('Open English Bible, Commonwealth Edition'),
            ),
            DropdownMenuItem(
              value: 'webbe',
              child: Text('World English Bible, British Edition'),
            ),
            DropdownMenuItem(
              value: 'oeb-us',
              child: Text('Open English Bible, US Edition'),
            ),
            DropdownMenuItem(
              value: 'clementine',
              child: Text('Clementine Latin Vulgate'),
            ),
            DropdownMenuItem(
              value: 'almeida',
              child: Text('João Ferreira de Almeida (Portuguese)'),
            ),
            DropdownMenuItem(
              value: 'rccv',
              child: Text('Protestant Romanian Corrected Cornilescu Version'),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              widget.settingsNotifier.updateBibleTranslation(value);
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    final metadata = widget.calendarNotifier.metadata;

    if (widget.calendarNotifier.isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (widget.calendarNotifier.error != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Error loading calendars: ${widget.calendarNotifier.error}',
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    if (metadata == null) {
      return const SizedBox.shrink();
    }

    final nations = metadata.nations;
    final nationKeys = nations.keys.toList();

    // Determine current selected nation based on calendarId if type is diocese
    String currentNation = 'general';
    if (widget.settingsNotifier.calendarType == 'nation') {
      currentNation = widget.settingsNotifier.calendarId;
    } else if (widget.settingsNotifier.calendarType == 'diocese') {
      // Find the nation for the current diocese
      for (final entry in metadata.dioceses.entries) {
        if (entry.value.any(
          (d) => d['id'] == widget.settingsNotifier.calendarId,
        )) {
          currentNation = entry.key;
          break;
        }
      }
    }

    final diocesesForNation = metadata.dioceses[currentNation] ?? [];

    String? currentDiocese;
    if (widget.settingsNotifier.calendarType == 'diocese') {
      if (diocesesForNation.any(
        (d) => d['id'] == widget.settingsNotifier.calendarId,
      )) {
        currentDiocese = widget.settingsNotifier.calendarId;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Liturgical Calendar',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'National / General Calendar',
            border: OutlineInputBorder(),
          ),
          initialValue: currentNation,
          items: [
            const DropdownMenuItem(
              value: 'general',
              child: Text('General Roman Calendar'),
            ),
            ...nationKeys.map((key) {
              return DropdownMenuItem(value: key, child: Text(nations[key]!));
            }),
          ],
          onChanged: (value) {
            if (value != null) {
              if (value == 'general') {
                widget.settingsNotifier.updateCalendar('general', '');
              } else {
                widget.settingsNotifier.updateCalendar('nation', value);
              }
            }
          },
        ),
        if (diocesesForNation.isNotEmpty) ...[
          const SizedBox(height: 16),
          DropdownButtonFormField<String?>(
            decoration: const InputDecoration(
              labelText: 'Diocesan Calendar (Optional)',
              border: OutlineInputBorder(),
            ),
            initialValue: currentDiocese,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('None (Use National)'),
              ),
              ...diocesesForNation.map((diocese) {
                return DropdownMenuItem(
                  value: diocese['id'],
                  child: Text(diocese['name']!),
                );
              }),
            ],
            onChanged: (value) {
              if (value != null) {
                widget.settingsNotifier.updateCalendar('diocese', value);
              } else {
                // If none is selected, revert to the nation
                widget.settingsNotifier.updateCalendar('nation', currentNation);
              }
            },
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}
