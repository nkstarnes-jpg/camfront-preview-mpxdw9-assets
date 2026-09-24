/// Base app error for domain/data layers.
class AppError implements Exception {
  const AppError(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => 'AppError: $message';
}

class EntitlementDeniedError extends AppError {
  const EntitlementDeniedError(String feature)
      : super('Feature not available on current plan: $feature');
}

class CameraAdapterError extends AppError {
  const CameraAdapterError(super.message, {super.cause});
}
