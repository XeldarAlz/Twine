import '../domain/dashboard_state.dart';

/// Contract for fetching and updating dashboard data.
abstract class DashboardService {
  Future<DashboardData> getDashboardData();
  Future<void> setMood(MoodType mood);
}

/// Mock implementation with hardcoded data and simulated latency.
class MockDashboardService implements DashboardService {
  @override
  Future<DashboardData> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 800));

    final now = DateTime.now();

    return DashboardData(
      userName: 'Jamie',
      partnerName: 'Alex',
      partnerNickname: 'Babe',
      isPartnerOnline: true,
      partnerMood: MoodType.happy,
      anniversaryDate: now.subtract(const Duration(days: 180)),
      streakCount: 12,
      todaysQuestion: const DailyQuestion(
        id: 'q-001',
        questionText:
            "What's one thing you'd love to do together this weekend?",
        category: QuestionCategory.fun,
      ),
      questionState: QuestionState.unanswered,
      recentActivity: [
        ActivityItem(
          id: 'a-001',
          type: ActivityType.tap,
          description: 'Alex sent you a tap',
          timestamp: now.subtract(const Duration(minutes: 15)),
        ),
        ActivityItem(
          id: 'a-002',
          type: ActivityType.mood,
          description: 'Alex is feeling happy',
          timestamp: now.subtract(const Duration(hours: 2)),
        ),
        ActivityItem(
          id: 'a-003',
          type: ActivityType.photo,
          description: 'You shared a photo',
          timestamp: now.subtract(const Duration(hours: 5)),
        ),
      ],
    );
  }

  @override
  Future<void> setMood(MoodType mood) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
