// lib/core/error/result.dart

import 'app_exception.dart';

/// Repository/UseCase katmanlarında exception fırlatmak yerine
/// açık, tip-güvenli sonuç döndürmek için kullanılan sealed class.
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

class Failure<T> extends Result<T> {
  final AppException exception;
  const Failure(this.exception);
}

extension ResultX<T> on Result<T> {
  T? get valueOrNull => switch (this) {
    Success<T>(data: final data) => data,
    Failure<T>() => null,
  };
}
