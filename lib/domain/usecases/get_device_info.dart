import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/error_message.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/device_details.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/profile_repository.dart';

class GetDeviceInfo {
  const GetDeviceInfo(this._repository);

  final ProfileRepository _repository;

  Future<Result<DeviceDetails>> call() async {
    try {
      final details = await _repository.getDeviceInfo();
      return Success(details);
    } catch (error) {
      return Err(Failure(friendlyError(error)));
    }
  }
}
