import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../settings/settings_notifier.dart';
import '../state/calendar_notifier.dart';
import '../state/reading_notifier.dart';
import '../theme/color_mapper.dart';
import '../theme/popup_theme.dart';
import 'settings_screen.dart';

class const ReadingScreen({
  required final ReadingNotifier notifier,
  required final SettingsNotifier settingsNotifier,
  required final CalendarNotifier calendarNotifier,
  super.key,
}) extends StatefulWidget {
  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final _readingScroll = ScrollController();
  final _passageFocus = <String, FocusNode>{};
  final _readerBackFocus = FocusNode();
  String? _selectedLabel;
  String? _selectedDay;
  bool _animateReader = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.notifier.loadTodayReading();
    });
  }

  @override
  void dispose() {
    _readingScroll.dispose();
    _readerBackFocus.dispose();
    for (final node in _passageFocus.values) {
      node.dispose();
    }
    super.dispose();
  }

  void _settings() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (context, _, _) => SettingsScreen(
          settingsNotifier: widget.settingsNotifier,
          calendarNotifier: widget.calendarNotifier,
        ),
      ),
    );
  }

  void _openPassage(ReadingData data, ReadingPassage passage, bool pointer) {
    setState(() {
      _selectedDay = data.dateKey;
      _selectedLabel = passage.label;
      _animateReader = pointer;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _selectedDay == data.dateKey &&
          _selectedLabel == passage.label) {
        _readerBackFocus.requestFocus();
      }
    });
  }

  void _closePassage() {
    final label = _selectedLabel;
    setState(() {
      _selectedLabel = null;
      _animateReader = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _selectedLabel == null) {
        _passageFocus[label]?.requestFocus();
      }
    });
  }

  void _refresh() => widget.notifier.loadSelectedReading(forceRefresh: true);

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([
      widget.notifier,
      widget.settingsNotifier,
      widget.calendarNotifier,
    ]),
    builder: (context, _) {
      final notifier = widget.notifier;
      final reduceMotion = MediaQuery.disableAnimationsOf(context);
      final surface = Theme.of(context).colorScheme.surface;
      final data = notifier.data;
      final palette = LiturgicalPalette.forDay(
        Theme.of(context).colorScheme,
        data?.liturgicalColors ?? const [],
      );
      final selected = data?.dateKey == _selectedDay
          ? data?.passages
                .where((passage) => passage.label == _selectedLabel)
                .firstOrNull
          : null;
      final (calendar, translation) = (
        widget.settingsNotifier.calendarType,
        widget.settingsNotifier.bibleTranslation,
      );

      return PopupFrame(
        Column(
          children: [
            PopupToolbar(
              leading: const _Wordmark(),
              actions: [
                PopupIconButton(
                  icon: Icons.refresh_rounded,
                  tooltip: 'Refresh readings',
                  onPressed: notifier.isLoading ? null : _refresh,
                ),
                PopupIconButton(
                  icon: Icons.settings_outlined,
                  tooltip: 'Settings',
                  onPressed: _settings,
                ),
              ],
            ),
            SizedBox(
              height: 2,
              child: notifier.isLoading
                  ? const LinearProgressIndicator(
                      semanticsLabel: 'Loading readings',
                    )
                  : null,
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: _animateReader
                    ? Duration(milliseconds: reduceMotion ? 100 : 170)
                    : Duration.zero,
                reverseDuration: Duration(
                  milliseconds: reduceMotion ? 100 : 110,
                ),
                switchInCurve: popupEaseOut,
                switchOutCurve: popupEaseOut,
                layoutBuilder: (current, previous) => Stack(
                  fit: StackFit.expand,
                  children: [
                    if (previous.lastOrNull case final outgoing?)
                      IgnorePointer(
                        child: ExcludeSemantics(
                          child: ExcludeFocus(child: outgoing),
                        ),
                      ),
                    ?current,
                  ],
                ),
                transitionBuilder: (child, animation) {
                  // A panel carries its text and controls through one transition.
                  final panel = ColoredBox(color: surface, child: child);
                  final slide =
                      child.key != const ValueKey('reading-index') &&
                      _animateReader &&
                      !reduceMotion;
                  return FadeTransition(
                    opacity: animation,
                    child: slide
                        ? SlideTransition(
                            position: Tween(
                              begin: const Offset(0.018, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: panel,
                          )
                        : panel,
                  );
                },
                child: selected == null
                    ? _buildIndex(context, data, palette)
                    : CallbackShortcuts(
                        key: ValueKey((data!.dateKey, selected.label)),
                        bindings: {
                          const SingleActivator(LogicalKeyboardKey.escape):
                              _closePassage,
                        },
                        child: _PassageReader(
                          passage: selected,
                          accent: palette.accent,
                          backFocus: _readerBackFocus,
                          onBack: _closePassage,
                          onRetry: notifier.isLoading ? null : _refresh,
                        ),
                      ),
              ),
            ),
            _SourceFooter(
              calendar: switch (calendar) {
                'nation' =>
                  widget.calendarNotifier.metadata?.nations[widget
                          .settingsNotifier
                          .calendarId] ??
                      '${widget.settingsNotifier.calendarId} national calendar',
                'diocese' => 'Diocesan calendar',
                _ => 'General Roman Calendar',
              },
              translation: translation.toUpperCase(),
            ),
          ],
        ),
      );
    },
  );

  Widget _buildIndex(
    BuildContext context,
    ReadingData? data,
    LiturgicalPalette palette,
  ) {
    final theme = Theme.of(context);
    final notifier = widget.notifier;
    return SingleChildScrollView(
      key: const ValueKey('reading-index'),
      controller: _readingScroll,
      padding: const EdgeInsets.fromLTRB(popupPadding, 12, popupPadding, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      'Daily Readings',
                      style: theme.textTheme.headlineSmall,
                    ),
                  ),
                ),
                if (notifier.selectedDate != notifier.today)
                  TextButton(
                    onPressed: notifier.loadTodayReading,
                    child: const Text('Today'),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _DateNavigator(notifier: notifier, accent: palette.accent),
          const SizedBox(height: 9),
          if (data != null) ...[
            _DayCard(data, palette),
            const SizedBox(height: 16),
            if (notifier.error != null) ...[
              const _ReadingStatus(
                icon: Icons.cloud_off_outlined,
                heading: 'Showing saved calendar data',
                message: 'The latest readings couldn’t be loaded.',
              ),
              const SizedBox(height: 16),
            ],
            if (data.passages.isEmpty)
              _ReadingStatus(
                icon: Icons.menu_book_outlined,
                heading: notifier.isLoading
                    ? 'Checking for citations'
                    : 'Citations unavailable',
                message: notifier.isLoading
                    ? 'Looking for the readings for this celebration.'
                    : 'LitCal hasn’t provided reading references for this celebration.',
              )
            else ...[
              Semantics(
                header: true,
                child: Text(
                  'Reading order',
                  style: theme.textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              for (final passage in data.passages) ...[
                const Divider(height: 1),
                _PassageRow(
                  passage: passage,
                  accent: palette.accent,
                  focusNode: _passageFocus.putIfAbsent(
                    passage.label,
                    FocusNode.new,
                  ),
                  onOpen: (pointer) => _openPassage(data, passage, pointer),
                ),
              ],
              const Divider(height: 1),
            ],
          ] else if (notifier.error != null)
            _ReadingStatus(
              icon: Icons.cloud_off_outlined,
              heading: 'Couldn’t load readings for this date',
              message: 'Check your connection and try again.',
              action: FilledButton.tonal(
                onPressed: _refresh,
                child: const Text('Try again'),
              ),
            )
          else
            const _ReadingStatus(
              icon: Icons.calendar_today_outlined,
              heading: 'Loading the calendar',
              message: 'Looking up the celebration and its readings.',
            ),
        ],
      ),
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(
            Icons.auto_stories_outlined,
            size: 18,
            color: colors.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text('Lumen Missal', style: theme.textTheme.titleMedium),
        ),
      ],
    );
  }
}

class const _DateNavigator({
  required final ReadingNotifier notifier,
  required final Color accent,
}) extends StatelessWidget {
  static const _day = Duration(days: 1);

  Future<void> _chooseDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: notifier.selectedDate,
      currentDate: notifier.today,
      firstDate: notifier.firstDate,
      lastDate: notifier.lastDate,
      helpText: 'Choose a reading date',
    );
    if (context.mounted && picked != null) {
      await notifier.selectDate(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final date = notifier.selectedDate;
    final labels = MaterialLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: colors.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          IconButton(
            tooltip: 'Previous day',
            onPressed: date.isAfter(notifier.firstDate)
                ? () => notifier.selectDate(date.subtract(_day))
                : null,
            icon: const Icon(Icons.chevron_left_rounded, size: 20),
          ),
          Expanded(
            child: Tooltip(
              message: 'Choose a date. ${labels.formatFullDate(date)}',
              child: TextButton.icon(
                onPressed: () => _chooseDate(context),
                style: TextButton.styleFrom(foregroundColor: accent),
                icon: const Icon(Icons.calendar_today_outlined, size: 15),
                label: Text(labels.formatMediumDate(date)),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Next day',
            onPressed: date.isBefore(notifier.lastDate)
                ? () => notifier.selectDate(date.add(_day))
                : null,
            icon: const Icon(Icons.chevron_right_rounded, size: 20),
          ),
        ],
      ),
    );
  }
}

class const _DayCard(final ReadingData data, final LiturgicalPalette palette)
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final metadata = [
      if (data.season case final season? when season.isNotEmpty) season,
      if (data.grade case final grade? when grade.isNotEmpty) grade,
      if (data.liturgicalYear case final year? when year.trim().isNotEmpty)
        year,
      if (data.psalterWeek case final week?) 'Psalter week $week',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: palette.accent.withValues(alpha: 0.20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(data.title, style: theme.textTheme.titleLarge),
          ),
          if (metadata.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              metadata.join(' · '),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
          if (palette.swatches.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 4,
              children: [
                for (final (:label, :color) in palette.swatches)
                  Semantics(
                    label: 'Liturgical colour: $label',
                    excludeSemantics: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: color,
                            border: Border.all(color: colors.outline),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          label,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: palette.accent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class const _PassageRow({
  required final ReadingPassage passage,
  required final Color accent,
  required final ValueChanged<bool> onOpen,
  required final FocusNode focusNode,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    var pointer = false;
    return InkWell(
      focusNode: focusNode,
      onTapUp: (_) => pointer = true,
      onTap: () => onOpen(pointer),
      focusColor: accent.withValues(alpha: 0.16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(passage.label, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 2),
                  Text(
                    passage.reference,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Icon(Icons.chevron_right_rounded, color: accent, size: 20),
          ],
        ),
      ),
    );
  }
}

class const _PassageReader({
  required final ReadingPassage passage,
  required final Color accent,
  required final VoidCallback onBack,
  required final FocusNode backFocus,
  required final VoidCallback? onRetry,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(popupPadding, 12, popupPadding, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: onBack,
            focusNode: backFocus,
            icon: const Icon(Icons.arrow_back_rounded, size: 17),
            label: const Text('All readings'),
          ),
          const SizedBox(height: 15),
          Semantics(
            header: true,
            child: Text(passage.label, style: theme.textTheme.headlineSmall),
          ),
          const SizedBox(height: 5),
          Text(
            passage.reference,
            style: theme.textTheme.titleMedium?.copyWith(color: accent),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          if (passage.text case final text?)
            SelectableText(text, style: theme.textTheme.bodyLarge)
          else
            _ReadingStatus(
              icon: Icons.cloud_off_outlined,
              heading: 'Passage text unavailable',
              message: 'Bible API couldn’t provide this citation in the selected translation.',
              action: FilledButton.tonal(
                onPressed: onRetry,
                child: const Text('Try again'),
              ),
            ),
        ],
      ),
    );
  }
}

class const _ReadingStatus({
  required final IconData icon,
  required final String heading,
  required final String message,
  final Widget? action,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: 19, color: colors.primary),
            ),
            const SizedBox(width: 11),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(heading, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 3),
                  Text(
                    message,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  if (action case final button?) ...[
                    const SizedBox(height: 9),
                    button,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _SourceFooter({
  required final String calendar,
  required final String translation,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 12,
            horizontal: popupPadding,
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 13,
                color: colors.onSurfaceVariant,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  calendar,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Tooltip(
                message: 'Bible translation',
                child: Text(
                  translation,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
