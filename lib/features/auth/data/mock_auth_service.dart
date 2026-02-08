import 'auth_service.dart';

/// Mock authentication service for development.
///
/// Simulates network delays and always succeeds.
class MockAuthService implements AuthService {
  @override
  Future<bool> sendOtp(String phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return true;
  }

  @override
  Future<String?> verifyOtp(String phoneNumber, String code) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    // Any 6-digit code is accepted in mock mode.
    if (code.length == 6) {
      return 'mock-user-${DateTime.now().millisecondsSinceEpoch}';
    }
    return null;
  }

  @override
  Future<bool> updateProfile({
    required String userId,
    required String displayName,
    String? photoPath,
    DateTime? birthday,
    DateTime? anniversary,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return true;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
