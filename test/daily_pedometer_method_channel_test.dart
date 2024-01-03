import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:daily_pedometer/daily_pedometer_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelDailyPedometer platform = MethodChannelDailyPedometer();
  const MethodChannel channel = MethodChannel('daily_pedometer');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
