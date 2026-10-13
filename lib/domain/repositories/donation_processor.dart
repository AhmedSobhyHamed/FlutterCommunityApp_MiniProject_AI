import 'package:fluttercommunityapp_miniproject_ai/domain/entities/donation.dart';

/// SOLID — Dependency inversion and interface segregation.
/// Callers depend on this contract, not on Firestore.
/// A new processor (wallet, card) can be added without changing [SendDonation].
abstract interface class DonationProcessor {
  Future<void> process(Donation donation);
}
