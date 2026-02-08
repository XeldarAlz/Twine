import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_service.dart';
import '../data/mock_auth_service.dart';
import '../domain/auth_state.dart';

/// Provides the current [AuthService] implementation.
final authServiceProvider = Provider<AuthService>((ref) {
  return MockAuthService();
});

/// Manages authentication state transitions.
final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authServiceProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _service;

  AuthNotifier(this._service) : super(const AuthInitial());

  Future<void> sendOtp(String phoneNumber) async {
    state = const AuthLoading('Sending code...');
    try {
      final sent = await _service.sendOtp(phoneNumber);
      if (sent) {
        state = AuthOtpSent(phoneNumber);
      } else {
        state = AuthError('Failed to send code. Please try again.', const AuthInitial());
      }
    } catch (e) {
      state = AuthError('Something went wrong. Please try again.', const AuthInitial());
    }
  }

  Future<void> verifyOtp(String phoneNumber, String code) async {
    final previous = state;
    state = const AuthOtpVerifying();
    try {
      final userId = await _service.verifyOtp(phoneNumber, code);
      if (userId != null) {
        state = AuthAuthenticated(userId);
      } else {
        state = AuthError('Invalid code. Please try again.', previous);
      }
    } catch (e) {
      state = AuthError('Verification failed. Please try again.', previous);
    }
  }

  void reset() {
    state = const AuthInitial();
  }
}

/// Manages profile setup wizard state.
final profileSetupNotifierProvider =
    StateNotifierProvider<ProfileSetupNotifier, ProfileSetupState>((ref) {
  return ProfileSetupNotifier(ref.watch(authServiceProvider));
});

class ProfileSetupNotifier extends StateNotifier<ProfileSetupState> {
  final AuthService _service;

  ProfileSetupNotifier(this._service) : super(const ProfileSetupState());

  void setDisplayName(String name) {
    state = state.copyWith(displayName: name);
  }

  void setPhotoPath(String? path) {
    state = state.copyWith(photoPath: () => path);
  }

  void setBirthday(DateTime? date) {
    state = state.copyWith(birthday: () => date);
  }

  void setAnniversary(DateTime? date) {
    state = state.copyWith(anniversary: () => date);
  }

  void nextStep() {
    if (state.currentStep < 2) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<bool> saveProfile(String userId) async {
    state = state.copyWith(isSaving: true, error: () => null);
    try {
      final success = await _service.updateProfile(
        userId: userId,
        displayName: state.displayName.trim(),
        photoPath: state.photoPath,
        birthday: state.birthday,
        anniversary: state.anniversary,
      );
      state = state.copyWith(isSaving: false);
      return success;
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        error: () => 'Failed to save profile. Please try again.',
      );
      return false;
    }
  }
}
