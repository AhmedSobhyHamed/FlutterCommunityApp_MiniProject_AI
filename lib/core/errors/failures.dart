/// A failure the UI can show. Use cases catch raw errors and return this.
class Failure {
  const Failure(this.message);

  final String message;
}
