import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:fluttercommunityapp_miniproject_ai/domain/entities/device_details.dart';

class DeviceInfoService {
  DeviceInfoService({DeviceInfoPlugin? plugin})
    : _plugin = plugin ?? DeviceInfoPlugin();

  final DeviceInfoPlugin _plugin;

  Future<DeviceDetails> read() async {
    if (Platform.isAndroid) {
      final info = await _plugin.androidInfo;
      return DeviceDetails(
        model: info.model,
        osVersion: 'Android ${info.version.release}',
      );
    }
    return const DeviceDetails(model: 'Unknown device', osVersion: 'Unknown');
  }
}
