/// App-wide constants for Twine.
class AppConstants {
  AppConstants._();

  // ─── App Info ──────────────────────────────────────────────
  static const String appName = 'Twine';
  static const String appTagline = 'The Relationship Operating System';

  // ─── Pagination ────────────────────────────────────────────
  static const int defaultPageSize = 20;
  static const int chatPageSize = 50;
  static const int memoryPageSize = 30;

  // ─── Validation ────────────────────────────────────────────
  static const int displayNameMinLength = 2;
  static const int displayNameMaxLength = 30;
  static const int messageMaxLength = 5000;
  static const int bioMaxLength = 150;
  static const int inviteCodeLength = 8;

  // ─── Timeouts ──────────────────────────────────────────────
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration otpResendCooldown = Duration(seconds: 60);
  static const Duration tapCooldown = Duration(milliseconds: 500);

  // ─── Cache Ages ────────────────────────────────────────────
  static const Duration profileCacheAge = Duration(hours: 1);
  static const Duration moodCacheAge = Duration(minutes: 15);
  static const Duration questionCacheAge = Duration(hours: 24);

  // ─── Free Tier Limits ──────────────────────────────────────
  static const int freePhotoUploadsPerMonth = 50;
  static const int freeAlbumsMax = 3;
  static const int freeCalendarEventsMax = 10;
  static const int freeCustomThemes = 0;
}
