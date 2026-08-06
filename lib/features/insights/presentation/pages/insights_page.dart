import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../body_measurement/presentation/pages/body_measurement_timeline_page.dart';
import '../../../body_measurement/presentation/widgets/add_measurement_sheet.dart';
import '../../../workout_log/presentation/pages/streak_analytics_view.dart';

class InsightsPage extends StatefulWidget {
  final int initialTabIndex;

  const InsightsPage({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<InsightsPage> createState() =>
      _InsightsPageState();
}

class _InsightsPageState
    extends State<InsightsPage> {
  late int _tabIndex;

  @override
  void initState() {
    super.initState();
    _tabIndex = widget.initialTabIndex; // ⬅️ YENİ
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.insightsTitle),
      ),
      // FAB sadece Ölçümler sekmesinde anlamlı — Disiplin sekmesinde salt
      // görüntüleme var, ekleme aksiyonu yok.
      floatingActionButton: _tabIndex == 0
          ? FloatingActionButton.extended(
              onPressed: () =>
                  AddMeasurementSheet.show(
                    context,
                  ),
              icon: const Icon(Icons.add),
              label: Text(l10n.logDataButton),
            )
          : null,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(
              AppSpacing.containerMargin,
            ),
            child: SegmentedButton<int>(
              segments: [
                ButtonSegment(
                  value: 0,
                  label: Text(
                    l10n.measurementsTab,
                  ),
                ),
                ButtonSegment(
                  value: 1,
                  label: Text(
                    l10n.consistencyTab,
                  ),
                ),
              ],
              selected: {_tabIndex},
              onSelectionChanged: (selected) =>
                  setState(
                    () => _tabIndex =
                        selected.first,
                  ),
            ),
          ),
          // IndexedStack: sekme değişince controller'lar dispose OLMASIN —
          // her ikisi de her zaman mount edilmiş kalır, sekmeler arası
          // geçişte yeniden veri çekme/flicker yaşanmaz.
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: const [
                BodyMeasurementTimelineView(),
                StreakAnalyticsView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
