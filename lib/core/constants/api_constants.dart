/// API and service constants for Twine.
///
/// Placeholder values until Supabase is configured.
class ApiConstants {
  ApiConstants._();

  // ─── Supabase (placeholder) ────────────────────────────────
  static const String supabaseUrl = 'https://your-project.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key';

  // ─── Deep Links ────────────────────────────────────────────
  static const String deepLinkScheme = 'twine';
  static const String universalLinkHost = 'twine.app';

  // ─── Storage Buckets ───────────────────────────────────────
  static const String avatarsBucket = 'avatars';
  static const String memoriesBucket = 'memories';
  static const String chatMediaBucket = 'chat-media';
}
