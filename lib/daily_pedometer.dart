import 'package:daily_pedometer/daily_pedometer_storage.dart';
import 'package:flutter/services.dart';

class DailyPedometer {
  final EventChannel _stepCountChannel = const EventChannel('daily_step_count');
  final DailyPerometerStorage storage = DailyPerometerStorage();

  bool _isWriteMode = false;
  int _step = 0;
  dynamic _storageSteps;
  DateTime? _lastEventTime;

  Stream<int> get stepCountStream {
    return _stepCountChannel.receiveBroadcastStream().asyncMap((event) async {
      StepCount stepCount = StepCount._(event);

      if (_isWriteMode) {
        _storageSteps = await storage.save(stepCount);
      } else {
        await getStorageSteps(stepCount);
      }

      _step = await getSteps(stepCount);
      return _step;
    });
  }

  int get steps {
    return _step;
  }

  void setMode(bool isWriteMode) {
    _isWriteMode = isWriteMode;
  }

  getStorageSteps(stepCount) async {
    DateTime eventTime = stepCount.timeStamp;
    bool isFlush = false;

    if (_storageSteps != null &&
        stepCount.getDateAsString() != _storageSteps["todayDate"]) {
      isFlush = true;
    }

    if (_lastEventTime == null ||
        eventTime.difference(_lastEventTime!).inMinutes >= 10) {
      isFlush = true;
    }

    if (isFlush) {
      storage.flush();
      _storageSteps = await storage.read();
      _lastEventTime = eventTime;

      print("DailyPedometer : flush read");
    }
  }

  getSteps(StepCount stepCount) async {
    if (stepCount.getDateAsString() == _storageSteps["todayDate"]) {
      if (!_storageSteps.containsKey("stack")) {
        _storageSteps["stack"] = [];
      }

      final stackCount = _storageSteps["stack"].fold(0, (a, b) => a + b);
      return (stepCount.steps + stackCount) -
          _storageSteps["previousStepCount"];
    } else {
      return 0;
    }
  }
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

  String getDateAsString() {
    return _timeStamp.toIso8601String().split('T')[0];
  }

  @override
  String toString() =>
      'Steps taken: $_steps at ${_timeStamp.toIso8601String()}';
}

String today = DateTime.now().toIso8601String().split('T')[0];
