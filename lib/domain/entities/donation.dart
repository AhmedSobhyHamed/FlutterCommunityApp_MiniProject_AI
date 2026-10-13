import 'package:equatable/equatable.dart';

/// A community donation recorded for the signed-in member.
class Donation extends Equatable {
  const Donation({
    required this.userId,
    required this.amount,
    required this.createdAt,
  });

  final String userId;
  final double amount;
  final DateTime createdAt;

  @override
  List<Object?> get props => [userId, amount, createdAt];
}
