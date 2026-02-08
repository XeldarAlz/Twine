/// Abstract authentication service interface.
///
/// Implementations include [MockAuthService] for development and
/// a future Supabase-backed service for production.
abstract class AuthService {
  /// Sends an OTP to the given phone number.
  ///
  /// Returns `true` if the OTP was sent successfully.
  Future<bool> sendOtp(String phoneNumber);

  /// Verifies the OTP code entered by the user.
  ///
  /// Returns a user ID string on success, or `null` on failure.
  Future<String?> verifyOtp(String phoneNumber, String code);

  /// Updates the user's profile after initial setup.
  Future<bool> updateProfile({
    required String userId,
    required String displayName,
    String? photoPath,
    DateTime? birthday,
    DateTime? anniversary,
  });

  /// Signs the current user out.
  Future<void> signOut();
}
