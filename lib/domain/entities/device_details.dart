import 'package:equatable/equatable.dart';

/// Model and OS version read from the phone.
class DeviceDetails extends Equatable {
  const DeviceDetails({required this.model, required this.osVersion});

  final String model;
  final String osVersion;

  @override
  List<Object?> get props => [model, osVersion];
}
