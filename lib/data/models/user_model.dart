import 'package:fluttercommunityapp_miniproject_ai/domain/entities/user.dart';

class UserModel extends AppUser {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.email,
    super.photoUrl,
  });

  factory UserModel.fromEntity(AppUser user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      photoUrl: user.photoUrl,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      photoUrl: json['photoUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'photoUrl': photoUrl,
    };
  }
}

/// Builder — sign-up sets only the fields the form collected.
/// [photoUrl] stays unset until the member picks a gallery image later.
class UserBuilder {
  String? _id;
  String? _fullName;
  String? _email;
  String? _photoUrl;

  UserBuilder setId(String id) {
    _id = id;
    return this;
  }

  UserBuilder setFullName(String fullName) {
    _fullName = fullName;
    return this;
  }

  UserBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserBuilder setPhotoUrl(String photoUrl) {
    _photoUrl = photoUrl;
    return this;
  }

  UserModel build() {
    return UserModel(
      id: _id ?? '',
      fullName: _fullName ?? '',
      email: _email ?? '',
      photoUrl: _photoUrl,
    );
  }
}
