import 'package:fluttercommunityapp_miniproject_ai/domain/entities/donation.dart';

class DonationModel extends Donation {
  const DonationModel({
    required super.userId,
    required super.amount,
    required super.createdAt,
  });

  factory DonationModel.fromEntity(Donation donation) {
    return DonationModel(
      userId: donation.userId,
      amount: donation.amount,
      createdAt: donation.createdAt,
    );
  }

  factory DonationModel.fromJson(Map<String, dynamic> json) {
    final raw = json['createdAt'];
    final createdAt = raw is int
        ? DateTime.fromMillisecondsSinceEpoch(raw)
        : DateTime.now();
    return DonationModel(
      userId: json['userId'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'amount': amount,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
