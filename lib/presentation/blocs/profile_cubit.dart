import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/device_details.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/get_device_info.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/get_profile.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/send_donation.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/usecases/update_profile_photo.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileReady extends ProfileState {
  const ProfileReady({
    required this.user,
    required this.device,
    this.isUpdatingPhoto = false,
    this.isDonating = false,
    this.message,
  });

  final AppUser user;
  final DeviceDetails device;
  final bool isUpdatingPhoto;
  final bool isDonating;
  final String? message;

  ProfileReady copyWith({
    AppUser? user,
    bool? isUpdatingPhoto,
    bool? isDonating,
    String? message,
    bool clearMessage = false,
  }) {
    return ProfileReady(
      user: user ?? this.user,
      device: device,
      isUpdatingPhoto: isUpdatingPhoto ?? this.isUpdatingPhoto,
      isDonating: isDonating ?? this.isDonating,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    user,
    device,
    isUpdatingPhoto,
    isDonating,
    message,
  ];
}

class ProfileError extends ProfileState {
  const ProfileError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required GetProfile getProfile,
    required UpdateProfilePhoto updateProfilePhoto,
    required GetDeviceInfo getDeviceInfo,
    required SendDonation sendDonation,
  }) : _getProfile = getProfile,
       _updateProfilePhoto = updateProfilePhoto,
       _getDeviceInfo = getDeviceInfo,
       _sendDonation = sendDonation,
       super(const ProfileLoading());

  final GetProfile _getProfile;
  final UpdateProfilePhoto _updateProfilePhoto;
  final GetDeviceInfo _getDeviceInfo;
  final SendDonation _sendDonation;

  Future<void> load(String userId) async {
    emit(const ProfileLoading());
    final profileResult = await _getProfile(userId);
    final deviceResult = await _getDeviceInfo();

    final AppUser? user;
    final DeviceDetails? device;
    switch (profileResult) {
      case Success(:final value):
        user = value;
      case Err(:final failure):
        emit(ProfileError(failure.message));
        return;
    }
    switch (deviceResult) {
      case Success(:final value):
        device = value;
      case Err(:final failure):
        emit(ProfileError(failure.message));
        return;
    }
    if (user == null || device == null) {
      emit(const ProfileError('Could not load your profile.'));
      return;
    }
    emit(ProfileReady(user: user, device: device));
  }

  Future<void> updatePhoto({
    required String userId,
    required String filePath,
  }) async {
    final current = state;
    if (current is! ProfileReady) {
      return;
    }
    emit(current.copyWith(isUpdatingPhoto: true, clearMessage: true));
    final result = await _updateProfilePhoto(
      userId: userId,
      filePath: filePath,
    );
    switch (result) {
      case Success(:final value):
        emit(
          current.copyWith(
            user: value,
            isUpdatingPhoto: false,
            message: 'Profile photo updated.',
          ),
        );
      case Err(:final failure):
        emit(
          current.copyWith(isUpdatingPhoto: false, message: failure.message),
        );
    }
  }

  Future<bool> donate({required String userId, required double amount}) async {
    final current = state;
    if (current is! ProfileReady) {
      return false;
    }
    emit(current.copyWith(isDonating: true, clearMessage: true));
    final result = await _sendDonation(userId: userId, amount: amount);
    switch (result) {
      case Success():
        emit(
          current.copyWith(
            isDonating: false,
            message: 'Thank you. Your donation was recorded.',
          ),
        );
        return true;
      case Err(:final failure):
        emit(current.copyWith(isDonating: false, message: failure.message));
        return false;
    }
  }
}
