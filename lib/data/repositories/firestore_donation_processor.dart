import 'package:fluttercommunityapp_miniproject_ai/data/models/donation_model.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/donation.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/repositories/donation_processor.dart';
import 'package:fluttercommunityapp_miniproject_ai/services/firestore_service.dart';

/// SOLID — Single responsibility: write one donation document.
/// This class can be swapped for another [DonationProcessor] without
/// changing the use case that calls it.
class FirestoreDonationProcessor implements DonationProcessor {
  FirestoreDonationProcessor(this._firestoreService);

  final FirestoreService _firestoreService;

  @override
  Future<void> process(Donation donation) {
    final model = DonationModel.fromEntity(donation);
    return _firestoreService.donations.add(model.toJson());
  }
}
