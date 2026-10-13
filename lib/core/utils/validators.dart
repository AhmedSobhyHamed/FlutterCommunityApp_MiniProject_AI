/// Sign-up and login field checks required by the product rules.
String? validateFullName(String? value) {
  final name = value?.trim() ?? '';
  if (name.isEmpty) {
    return 'Enter your full name.';
  }
  final first = name[0];
  final isLetter = first.toLowerCase() != first.toUpperCase();
  if (!isLetter || first != first.toUpperCase()) {
    return 'Full name must start with a capital letter.';
  }
  return null;
}

String? validateEmail(String? value) {
  final email = value?.trim() ?? '';
  if (!email.contains('@')) {
    return 'Email must contain @.';
  }
  return null;
}

String? validatePassword(String? value) {
  if (value == null || value.length < 6) {
    return 'Password must be at least 6 characters.';
  }
  return null;
}

String? validateConfirmPassword(String? value, String password) {
  if (value != password) {
    return 'Passwords do not match.';
  }
  return null;
}

String? validatePostContent(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Write something before posting.';
  }
  return null;
}

String? validateDonationAmount(String? value) {
  final amount = double.tryParse(value?.trim() ?? '');
  if (amount == null || amount <= 0) {
    return 'Enter an amount greater than zero.';
  }
  return null;
}
