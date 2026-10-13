import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';

/// Outcome of a use case. Screens read [Success] or [Err] and never see a throw.
sealed class Result<T> {
  const Result();
}

final class Success<T> extends Result<T> {
  const Success([this.value]);

  final T? value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;
}
