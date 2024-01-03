
import 'daily_pedometer_platform_interface.dart';

class DailyPedometer {
  Future<String?> getPlatformVersion() {
    return DailyPedometerPlatform.instance.getPlatformVersion();
  }
}
