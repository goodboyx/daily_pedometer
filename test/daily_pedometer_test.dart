import 'package:flutter_test/flutter_test.dart';
import 'package:daily_pedometer/daily_pedometer.dart';
import 'package:daily_pedometer/daily_pedometer_platform_interface.dart';
import 'package:daily_pedometer/daily_pedometer_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDailyPedometerPlatform
    with MockPlatformInterfaceMixin
    implements DailyPedometerPlatform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DailyPedometerPlatform initialPlatform =
      DailyPedometerPlatform.instance;

  test('$MethodChannelDailyPedometer is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDailyPedometer>());
  });

  test('getPlatformVersion', () async {
    // DailyPedometer dailyPedometerPlugin = DailyPedometer();
    // MockDailyPedometerPlatform fakePlatform = MockDailyPedometerPlatform();
    // DailyPedometerPlatform.instance = fakePlatform;
  });
}
