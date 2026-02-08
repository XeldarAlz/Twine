import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:twine/core/services/haptic_service.dart';

import '../data/mock_dashboard_service.dart';
import '../domain/dashboard_state.dart';

/// Provides the current [DashboardService] implementation.
final dashboardServiceProvider = Provider<DashboardService>((ref) {
  return MockDashboardService();
});

/// Manages dashboard state.
final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  return DashboardNotifier(ref.watch(dashboardServiceProvider));
});

class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardService _service;

  DashboardNotifier(this._service) : super(const DashboardInitial()) {
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    state = const DashboardLoading();
    try {
      final data = await _service.getDashboardData();
      state = DashboardLoaded(data);
    } catch (e) {
      state = DashboardError(e.toString());
    }
  }

  Future<void> refresh() async => loadDashboard();

  void setMood(MoodType mood) {
    final current = state;
    if (current is DashboardLoaded) {
      // Optimistic update
      state = DashboardLoaded(
        current.data.copyWith(currentMood: () => mood),
      );
      _service.setMood(mood);
    }
  }

  void sendTap() {
    TwineHaptics.tapSent();
    final current = state;
    if (current is DashboardLoaded) {
      final activity = ActivityItem(
        id: 'tap-${DateTime.now().millisecondsSinceEpoch}',
        type: ActivityType.tap,
        description: 'You sent a tap to ${current.data.partnerName}',
        timestamp: DateTime.now(),
      );
      state = DashboardLoaded(
        current.data.copyWith(
          recentActivity: [activity, ...current.data.recentActivity],
        ),
      );
    }
  }
}
