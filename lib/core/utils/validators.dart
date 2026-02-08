import 'package:twine/core/constants/app_constants.dart';

/// Input validators for Twine forms.
class TwineValidators {
  TwineValidators._();

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final _phoneRegex = RegExp(r'^\+?[1-9]\d{6,14}$');

  static String? required(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'Email is required';
    if (!_emailRegex.hasMatch(value.trim())) return 'Enter a valid email';
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return 'Phone number is required';
    if (!_phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-()]'), ''))) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? displayName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Name is required';
    final trimmed = value.trim();
    if (trimmed.length < AppConstants.displayNameMinLength) {
      return 'Name must be at least ${AppConstants.displayNameMinLength} characters';
    }
    if (trimmed.length > AppConstants.displayNameMaxLength) {
      return 'Name must be at most ${AppConstants.displayNameMaxLength} characters';
    }
    return null;
  }

  static String? inviteCode(String? value) {
    if (value == null || value.trim().isEmpty) return 'Invite code is required';
    if (value.trim().length != AppConstants.inviteCodeLength) {
      return 'Invite code must be ${AppConstants.inviteCodeLength} characters';
    }
    return null;
  }

  static String? message(String? value) {
    if (value == null || value.trim().isEmpty) return null; // messages can be empty (draft)
    if (value.length > AppConstants.messageMaxLength) {
      return 'Message is too long';
    }
    return null;
  }
}
