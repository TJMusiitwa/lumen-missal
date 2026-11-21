import 'package:flutter/material.dart';

import '../settings/settings_notifier.dart';
import '../state/calendar_notifier.dart';
import '../theme/popup_theme.dart';

class const SettingsScreen({
  required final SettingsNotifier settingsNotifier,
  required final CalendarNotifier calendarNotifier,
  super.key,
}) extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  static const _translations = {
    'web': 'World English Bible',
    'webbe': 'World English Bible (British Edition)',
    'asv': 'American Standard Version',
    'bsb': 'Berean Standard Bible',
    'bbe': 'Bible in Basic English',
    'darby': 'Darby Bible',
    'dra': 'Douay-Rheims 1899 American Edition',
    'kjv': 'King James Version',
    'oeb-cw': 'Open English Bible (Commonwealth Edition)',
    'oeb-us': 'Open English Bible (US Edition)',
    'cherokee': 'Cherokee New Testament',
    'cuv-simp': 'Chinese Union Version (Simplified)',
    'cuv': 'Chinese Union Version (Traditional, saved preference)',
    'cuv-trad': 'Chinese Union Version (Traditional)',
    'bkr': 'Bible kralická (Czech)',
    'clementine': 'Clementine Latin Vulgate',
    'rccv': 'Romanian Corrected Cornilescu Version',
    'swahili': 'Swahili Bible',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.calendarNotifier.loadMetadata();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final settings = widget.settingsNotifier;
    final calendars = widget.calendarNotifier;
    return PopupFrame(
      Column(
        children: [
          PopupToolbar(
            leading: Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back_rounded, size: 17),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 10,
                  ),
                ),
                label: const Text('Daily readings'),
              ),
            ),
            actions: const [],
          ),
          Expanded(
            child: ListenableBuilder(
              listenable: Listenable.merge([settings, calendars]),
              builder: (context, _) => ListView(
                padding: const EdgeInsets.fromLTRB(
                  popupPadding,
                  20,
                  popupPadding,
                  24,
                ),
                children: [
                  Semantics(
                    header: true,
                    child: Text(
                      'Settings',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text('Appearance', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 7),
                  SegmentedButton<ThemeMode>(
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('System'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                      ),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                    ],
                    selected: {settings.themeMode},
                    onSelectionChanged: (modes) =>
                        settings.updateThemeMode(modes.single),
                  ),
                  const SizedBox(height: 18),
                  const Divider(height: 1),
                  const SizedBox(height: 18),
                  Text('Scripture', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 12),
                  _translationField(settings),
                  const SizedBox(height: 18),
                  const Divider(height: 1),
                  const SizedBox(height: 18),
                  Text(
                    'Liturgical calendar',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                  if (calendars.isLoading)
                    const LinearProgressIndicator(
                      semanticsLabel: 'Loading calendars',
                    )
                  else if (calendars.metadata case final metadata?)
                    ..._calendarFields(settings, metadata)
                  else if (calendars.error != null) ...[
                    Text(
                      'Calendar choices couldn’t be loaded.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: calendars.loadMetadata,
                        child: const Text('Retry calendar list'),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _translationField(SettingsNotifier settings) {
    final value = settings.bibleTranslation;
    final options = {
      if (!_translations.containsKey(value))
        value: '${value.toUpperCase()} (saved preference)',
      ..._translations,
    };
    return _settingField(
      label: 'Bible translation',
      value: value,
      options: options,
      onChanged: settings.updateBibleTranslation,
    );
  }

  List<Widget> _calendarFields(
    SettingsNotifier settings,
    CalendarMetadata metadata,
  ) {
    final nation = switch (settings.calendarType) {
      'nation' => settings.calendarId,
      'diocese' =>
        metadata.dioceses.entries
                .where(
                  (entry) => entry.value.any(
                    (item) => item['id'] == settings.calendarId,
                  ),
                )
                .firstOrNull
                ?.key ??
            'general',
      _ => 'general',
    };
    final nations = {
      'general': 'General Roman Calendar',
      ...metadata.nations,
      if (nation != 'general' && !metadata.nations.containsKey(nation))
        nation: nation,
    };
    final dioceses = {
      '': 'Use national calendar',
      for (final diocese
          in metadata.dioceses[nation] ?? const <Map<String, String>>[])
        diocese['id']!: diocese['name']!,
    };

    return [
      _settingField(
        label: 'Calendar',
        value: nation,
        options: nations,
        onChanged: (value) => settings.updateCalendar(
          value == 'general' ? 'general' : 'nation',
          value == 'general' ? '' : value,
        ),
      ),
      if (dioceses.length > 1) ...[
        const SizedBox(height: 14),
        _settingField(
          label: 'Diocese',
          value:
              settings.calendarType == 'diocese' &&
                  dioceses.containsKey(settings.calendarId)
              ? settings.calendarId
              : '',
          options: dioceses,
          onChanged: (value) => settings.updateCalendar(
            value.isEmpty ? 'nation' : 'diocese',
            value.isEmpty ? nation : value,
          ),
        ),
      ],
    ];
  }

  Widget _settingField({
    required String label,
    required String value,
    required Map<String, String> options,
    required ValueChanged<String> onChanged,
  }) => DropdownButtonFormField<String>(
    key: ValueKey((label, value)),
    decoration: InputDecoration(labelText: label),
    initialValue: value,
    isExpanded: true,
    items: [
      for (final MapEntry(:key, :value) in options.entries)
        DropdownMenuItem(
          value: key,
          child: Text(value, overflow: TextOverflow.ellipsis),
        ),
    ],
    onChanged: (selection) {
      if (selection != null) onChanged(selection);
    },
  );
}
