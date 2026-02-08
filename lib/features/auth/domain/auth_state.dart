import 'package:flutter/foundation.dart';

/// Sealed class representing the authentication state machine.
sealed class AuthState {
  const AuthState();
}

/// Initial state — no auth action in progress.
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Sending OTP or verifying code.
class AuthLoading extends AuthState {
  final String message;
  const AuthLoading([this.message = 'Loading...']);
}

/// OTP has been sent, waiting for user to enter code.
class AuthOtpSent extends AuthState {
  final String phoneNumber;
  const AuthOtpSent(this.phoneNumber);
}

/// OTP verification in progress.
class AuthOtpVerifying extends AuthState {
  const AuthOtpVerifying();
}

/// Successfully authenticated.
class AuthAuthenticated extends AuthState {
  final String userId;
  const AuthAuthenticated(this.userId);
}

/// Authentication error.
class AuthError extends AuthState {
  final String message;
  final AuthState previousState;
  const AuthError(this.message, this.previousState);
}

/// State for the 3-step profile setup wizard.
@immutable
class ProfileSetupState {
  final int currentStep;
  final String displayName;
  final String? photoPath;
  final DateTime? birthday;
  final DateTime? anniversary;
  final bool isSaving;
  final String? error;

  const ProfileSetupState({
    this.currentStep = 0,
    this.displayName = '',
    this.photoPath,
    this.birthday,
    this.anniversary,
    this.isSaving = false,
    this.error,
  });

  ProfileSetupState copyWith({
    int? currentStep,
    String? displayName,
    String? Function()? photoPath,
    DateTime? Function()? birthday,
    DateTime? Function()? anniversary,
    bool? isSaving,
    String? Function()? error,
  }) {
    return ProfileSetupState(
      currentStep: currentStep ?? this.currentStep,
      displayName: displayName ?? this.displayName,
      photoPath: photoPath != null ? photoPath() : this.photoPath,
      birthday: birthday != null ? birthday() : this.birthday,
      anniversary: anniversary != null ? anniversary() : this.anniversary,
      isSaving: isSaving ?? this.isSaving,
      error: error != null ? error() : this.error,
    );
  }

  bool get canProceedFromName => displayName.trim().length >= 2;
  bool get canComplete => canProceedFromName;
}
