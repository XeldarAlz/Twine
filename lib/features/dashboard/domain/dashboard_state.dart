import 'package:flutter/material.dart';

import 'package:twine/core/theme/twine_colors.dart';

// ─── Mood ──────────────────────────────────────────────────────

enum MoodType {
  happy,
  loved,
  excited,
  calm,
  tired,
  sad,
  stressed,
  sick,
}

extension MoodTypeExtension on MoodType {
  String get emoji => switch (this) {
        MoodType.happy => '😊',
        MoodType.loved => '🥰',
        MoodType.excited => '🤩',
        MoodType.calm => '😌',
        MoodType.tired => '😴',
        MoodType.sad => '😢',
        MoodType.stressed => '😰',
        MoodType.sick => '🤒',
      };

  String get label => switch (this) {
        MoodType.happy => 'Happy',
        MoodType.loved => 'Loved',
        MoodType.excited => 'Excited',
        MoodType.calm => 'Calm',
        MoodType.tired => 'Tired',
        MoodType.sad => 'Sad',
        MoodType.stressed => 'Stressed',
        MoodType.sick => 'Sick',
      };

  Color get color => switch (this) {
        MoodType.happy => TwineColors.moodHappy,
        MoodType.loved => TwineColors.moodLoved,
        MoodType.excited => TwineColors.coral,
        MoodType.calm => TwineColors.moodGrateful,
        MoodType.tired => TwineColors.moodTired,
        MoodType.sad => TwineColors.moodSad,
        MoodType.stressed => TwineColors.moodStressed,
        MoodType.sick => TwineColors.gray,
      };
}

// ─── Questions ─────────────────────────────────────────────────

enum QuestionCategory {
  fun,
  deep,
  spicy,
  memories,
  future,
}

extension QuestionCategoryExtension on QuestionCategory {
  String get label => switch (this) {
        QuestionCategory.fun => 'Fun',
        QuestionCategory.deep => 'Deep',
        QuestionCategory.spicy => 'Spicy',
        QuestionCategory.memories => 'Memories',
        QuestionCategory.future => 'Future',
      };

  Color get color => switch (this) {
        QuestionCategory.fun => TwineColors.moodHappy,
        QuestionCategory.deep => TwineColors.info,
        QuestionCategory.spicy => TwineColors.coral,
        QuestionCategory.memories => TwineColors.moodGrateful,
        QuestionCategory.future => TwineColors.moodTired,
      };
}

@immutable
class DailyQuestion {
  final String id;
  final String questionText;
  final QuestionCategory category;

  const DailyQuestion({
    required this.id,
    required this.questionText,
    required this.category,
  });
}

enum QuestionState { unanswered, waitingForPartner, bothAnswered }

// ─── Activity ──────────────────────────────────────────────────

enum ActivityType {
  tap,
  message,
  photo,
  mood,
  question,
}

extension ActivityTypeExtension on ActivityType {
  IconData get icon => switch (this) {
        ActivityType.tap => Icons.favorite,
        ActivityType.message => Icons.chat_bubble_outline,
        ActivityType.photo => Icons.photo_camera,
        ActivityType.mood => Icons.emoji_emotions_outlined,
        ActivityType.question => Icons.help_outline,
      };

  String get label => switch (this) {
        ActivityType.tap => 'Tap',
        ActivityType.message => 'Message',
        ActivityType.photo => 'Photo',
        ActivityType.mood => 'Mood',
        ActivityType.question => 'Question',
      };
}

@immutable
class ActivityItem {
  final String id;
  final ActivityType type;
  final String description;
  final DateTime timestamp;

  const ActivityItem({
    required this.id,
    required this.type,
    required this.description,
    required this.timestamp,
  });
}

// ─── Dashboard Data ────────────────────────────────────────────

@immutable
class DashboardData {
  final String userName;
  final String partnerName;
  final String? partnerNickname;
  final String? partnerAvatarUrl;
  final bool isPartnerOnline;
  final DateTime? partnerLastSeen;
  final MoodType? partnerMood;
  final DateTime anniversaryDate;
  final int streakCount;
  final MoodType? currentMood;
  final DailyQuestion? todaysQuestion;
  final QuestionState questionState;
  final List<ActivityItem> recentActivity;

  const DashboardData({
    required this.userName,
    required this.partnerName,
    this.partnerNickname,
    this.partnerAvatarUrl,
    required this.isPartnerOnline,
    this.partnerLastSeen,
    this.partnerMood,
    required this.anniversaryDate,
    required this.streakCount,
    this.currentMood,
    this.todaysQuestion,
    this.questionState = QuestionState.unanswered,
    this.recentActivity = const [],
  });

  int get daysTogether => DateTime.now().difference(anniversaryDate).inDays;

  DashboardData copyWith({
    String? userName,
    String? partnerName,
    String? Function()? partnerNickname,
    String? Function()? partnerAvatarUrl,
    bool? isPartnerOnline,
    DateTime? Function()? partnerLastSeen,
    MoodType? Function()? partnerMood,
    DateTime? anniversaryDate,
    int? streakCount,
    MoodType? Function()? currentMood,
    DailyQuestion? Function()? todaysQuestion,
    QuestionState? questionState,
    List<ActivityItem>? recentActivity,
  }) {
    return DashboardData(
      userName: userName ?? this.userName,
      partnerName: partnerName ?? this.partnerName,
      partnerNickname:
          partnerNickname != null ? partnerNickname() : this.partnerNickname,
      partnerAvatarUrl:
          partnerAvatarUrl != null ? partnerAvatarUrl() : this.partnerAvatarUrl,
      isPartnerOnline: isPartnerOnline ?? this.isPartnerOnline,
      partnerLastSeen:
          partnerLastSeen != null ? partnerLastSeen() : this.partnerLastSeen,
      partnerMood: partnerMood != null ? partnerMood() : this.partnerMood,
      anniversaryDate: anniversaryDate ?? this.anniversaryDate,
      streakCount: streakCount ?? this.streakCount,
      currentMood: currentMood != null ? currentMood() : this.currentMood,
      todaysQuestion:
          todaysQuestion != null ? todaysQuestion() : this.todaysQuestion,
      questionState: questionState ?? this.questionState,
      recentActivity: recentActivity ?? this.recentActivity,
    );
  }
}

// ─── Dashboard State ───────────────────────────────────────────

sealed class DashboardState {
  const DashboardState();
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardLoaded extends DashboardState {
  final DashboardData data;
  const DashboardLoaded(this.data);
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
}
