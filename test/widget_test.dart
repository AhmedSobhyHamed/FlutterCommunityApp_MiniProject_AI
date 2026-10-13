import 'package:flutter_test/flutter_test.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/validators.dart';
import 'package:fluttercommunityapp_miniproject_ai/data/models/user_model.dart';

void main() {
  test('sign-up builder sets only the fields collected on the form', () {
    final user = UserBuilder()
        .setId('user-1')
        .setFullName('Ahmed')
        .setEmail('ahmed@email.com')
        .build();

    expect(user.id, 'user-1');
    expect(user.fullName, 'Ahmed');
    expect(user.email, 'ahmed@email.com');
    expect(user.photoUrl, isNull);
    expect(user.toJson()['photoUrl'], isNull);
  });

  test('profile photo is applied only when the builder receives it', () {
    final user = UserBuilder()
        .setId('user-1')
        .setFullName('Ahmed')
        .setEmail('ahmed@email.com')
        .setPhotoUrl('https://example.com/photo.jpg')
        .build();

    expect(user.photoUrl, 'https://example.com/photo.jpg');
  });

  test('full name must start with a capital letter', () {
    expect(validateFullName('ahmed'), isNotNull);
    expect(validateFullName('Ahmed Sobhy'), isNull);
  });

  test('email must contain @', () {
    expect(validateEmail('ahmed.email.com'), isNotNull);
    expect(validateEmail('ahmed@email.com'), isNull);
  });

  test(
    'password must be at least 6 characters and confirmation must match',
    () {
      expect(validatePassword('12345'), isNotNull);
      expect(validatePassword('123456'), isNull);
      expect(validateConfirmPassword('123456', '1234567'), isNotNull);
      expect(validateConfirmPassword('123456', '123456'), isNull);
    },
  );
}
