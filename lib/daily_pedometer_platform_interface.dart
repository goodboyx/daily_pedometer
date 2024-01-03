import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'daily_pedometer_method_channel.dart';

abstract class DailyPedometerPlatform extends PlatformInterface {
  /// Constructs a DailyPedometerPlatform.
  DailyPedometerPlatform() : super(token: _token);

  static final Object _token = Object();

  static DailyPedometerPlatform _instance = MethodChannelDailyPedometer();

  /// The default instance of [DailyPedometerPlatform] to use.
  ///
  /// Defaults to [MethodChannelDailyPedometer].
  static DailyPedometerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DailyPedometerPlatform] when
  /// they register themselves.
  static set instance(DailyPedometerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
