import 'package:flutter/material.dart';
import '../settings/settings_notifier.dart';

class SettingsScreen extends StatelessWidget {
  final SettingsNotifier settingsNotifier;

  const SettingsScreen({super.key, required this.settingsNotifier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListenableBuilder(
        listenable: settingsNotifier,
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
        DropdownButtonFormField<ThemeMode>(
          decoration: const InputDecoration(
            labelText: 'Theme Mode',
            border: OutlineInputBorder(),
          ),
          value: settingsNotifier.themeMode,
          items: const [
            DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
            DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
            DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
          ],
          onChanged: (value) {
            if (value != null) {
              settingsNotifier.updateThemeMode(value);
            }
          },
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
          value: settingsNotifier.bibleTranslation,
          items: const [
            DropdownMenuItem(value: 'cherokee', child: Text('Cherokee New Testament')),
            DropdownMenuItem(value: 'cuv', child: Text('Chinese Union Version')),
            DropdownMenuItem(value: 'bkr', child: Text('Bible kralická (Czech)')),
            DropdownMenuItem(value: 'asv', child: Text('American Standard Version (1901)')),
            DropdownMenuItem(value: 'bbe', child: Text('Bible in Basic English')),
            DropdownMenuItem(value: 'darby', child: Text('Darby Bible')),
            DropdownMenuItem(value: 'dra', child: Text('Douay-Rheims 1899 American Edition')),
            DropdownMenuItem(value: 'kjv', child: Text('King James Version')),
            DropdownMenuItem(value: 'web', child: Text('World English Bible')),
            DropdownMenuItem(value: 'ylt', child: Text("Young's Literal Translation (NT only)")),
            DropdownMenuItem(value: 'oeb-cw', child: Text('Open English Bible, Commonwealth Edition')),
            DropdownMenuItem(value: 'webbe', child: Text('World English Bible, British Edition')),
            DropdownMenuItem(value: 'oeb-us', child: Text('Open English Bible, US Edition')),
            DropdownMenuItem(value: 'clementine', child: Text('Clementine Latin Vulgate')),
            DropdownMenuItem(value: 'almeida', child: Text('João Ferreira de Almeida (Portuguese)')),
            DropdownMenuItem(value: 'rccv', child: Text('Protestant Romanian Corrected Cornilescu Version')),
          ],
          onChanged: (value) {
            if (value != null) {
              settingsNotifier.updateBibleTranslation(value);
            }
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    // Basic mapping of nations and their dioceses
    const Map<String, List<Map<String, String>>> calendarOptions = {
      'General Roman': [],
      'IT': [
        {'id': 'romamo_it', 'name': 'Rome'},
      ],
      'US': [
        {'id': 'boston_us', 'name': 'Boston'},
      ],
      'NL': [],
      'VA': [],
      'CA': [],
    };

    final nations = calendarOptions.keys.toList();

    // Determine current selected nation based on calendarId if type is diocese
    String currentNation = 'General Roman';
    if (settingsNotifier.calendarType == 'nation') {
      currentNation = settingsNotifier.calendarId;
      if (!nations.contains(currentNation)) currentNation = 'General Roman';
    } else if (settingsNotifier.calendarType == 'diocese') {
      // Find the nation for the current diocese
      for (final entry in calendarOptions.entries) {
        if (entry.value.any((d) => d['id'] == settingsNotifier.calendarId)) {
          currentNation = entry.key;
          break;
        }
      }
    }

    final diocesesForNation = calendarOptions[currentNation] ?? [];

    String? currentDiocese;
    if (settingsNotifier.calendarType == 'diocese') {
      if (diocesesForNation.any((d) => d['id'] == settingsNotifier.calendarId)) {
        currentDiocese = settingsNotifier.calendarId;
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
          value: currentNation,
          items: nations.map((nation) {
            return DropdownMenuItem(
              value: nation,
              child: Text(nation == 'General Roman' ? 'General Roman Calendar' : nation),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              if (value == 'General Roman') {
                settingsNotifier.updateCalendar('general', '');
              } else {
                settingsNotifier.updateCalendar('nation', value);
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
            value: currentDiocese,
            items: [
              const DropdownMenuItem(value: null, child: Text('None (Use National)')),
              ...diocesesForNation.map((diocese) {
                return DropdownMenuItem(
                  value: diocese['id'],
                  child: Text(diocese['name']!),
                );
              }),
            ],
            onChanged: (value) {
              if (value != null) {
                settingsNotifier.updateCalendar('diocese', value);
              } else {
                // If none is selected, revert to the nation
                settingsNotifier.updateCalendar('nation', currentNation);
              }
            },
          ),
        ],
        const SizedBox(height: 16),
      ],
    );
  }
}
