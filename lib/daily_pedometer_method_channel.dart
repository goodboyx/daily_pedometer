import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'daily_pedometer_platform_interface.dart';

/// An implementation of [DailyPedometerPlatform] that uses method channels.
class MethodChannelDailyPedometer extends DailyPedometerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('daily_pedometer');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
