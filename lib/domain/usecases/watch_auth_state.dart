import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/auth_repository.dart';

class WatchAuthState {
  const WatchAuthState(this._repository);

  final AuthRepository _repository;

  Stream<AppUser?> call() => _repository.watchAuthState();
}
