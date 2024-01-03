import 'package:flutter/services.dart';

import 'daily_pedometer_platform_interface.dart';

class DailyPedometer {
  static const EventChannel _stepCountChannel =
      EventChannel('daily_step_count');

  Future<String?> getPlatformVersion() {
    return DailyPedometerPlatform.instance.getPlatformVersion();
  }

  static Stream<StepCount> get stepCountStream => _stepCountChannel
      .receiveBroadcastStream()
      .map((event) => StepCount._(event));
}

class StepCount {
  late DateTime _timeStamp;
  int _steps = 0;

  StepCount._(dynamic e) {
    _steps = e as int;
    _timeStamp = DateTime.now();
  }

  int get steps => _steps;

  DateTime get timeStamp => _timeStamp;

  @override
  String toString() =>
      'Steps taken: $_steps at ${_timeStamp.toIso8601String()}';
}
