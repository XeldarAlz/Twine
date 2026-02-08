/// Base exception for data-layer errors in Twine.
///
/// These are caught by repositories and mapped to [Failure] types.
sealed class TwineException implements Exception {
  const TwineException(this.message, [this.statusCode]);

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType($statusCode): $message';
}

class ServerException extends TwineException {
  const ServerException([super.message = 'Server error', super.statusCode]);
}

class CacheException extends TwineException {
  const CacheException([super.message = 'Cache error']);
}

class NetworkException extends TwineException {
  const NetworkException([super.message = 'Network error']);
}

class AuthException extends TwineException {
  const AuthException([super.message = 'Auth error', super.statusCode]);
}
