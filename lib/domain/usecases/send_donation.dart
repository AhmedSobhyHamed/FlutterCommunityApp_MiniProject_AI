import 'package:fluttercommunityapp_miniproject_ai/core/errors/failures.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/error_message.dart';
import 'package:fluttercommunityapp_miniproject_ai/core/utils/result.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/donation.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/donation_processor.dart';

/// SOLID — Single responsibility: this use case only submits a donation.
/// It depends on [DonationProcessor], so a different payment writer can replace
/// the Firestore one without editing this class (open/closed, Liskov).
class SendDonation {
  const SendDonation(this._processor);

  final DonationProcessor _processor;

  Future<Result<void>> call({
    required String userId,
    required double amount,
  }) async {
    if (amount <= 0) {
      return const Err(Failure('Enter an amount greater than zero.'));
    }
    try {
      await _processor.process(
        Donation(userId: userId, amount: amount, createdAt: DateTime.now()),
      );
      return const Success();
    } catch (error) {
      return Err(Failure(friendlyError(error)));
    }
  }
}
