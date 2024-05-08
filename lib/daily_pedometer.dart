import 'dart:async';
import 'dart:io';
import 'package:daily_pedometer/daily_pedometer_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class DailyPedometer {
  static final EventChannel _stepCountChannel = Platform.isAndroid ? EventChannel('daily_step_count') : EventChannel('step_count');
  final DailyPedometerStorage storage = DailyPedometerStorage();

  bool _isWriteMode = false;
  int _step = 0;
  dynamic _storageSteps;
  DateTime? _lastEventTime;

  static create() async {
    var pedometer = DailyPedometer();
    await pedometer.initialized();
    return pedometer;
  }

  Stream<int> get stepCountStream {
    return _stepCountChannel.receiveBroadcastStream().asyncMap((event) async {

      StepCount stepCount = StepCount._(event);

      if (_isWriteMode) {
        _storageSteps ??= await storage.read();
      } else {
        if(Platform.isIOS)
        {
          saveStepCount(stepCount);
        }
        await getStorageSteps(stepCount);
      }

      _step = await getSteps(stepCount);
      return _step;
    });
  }

  Future<void> initialized() async {
    _storageSteps = await storage.read();
    if (_storageSteps["todayStepCount"] != null) {
      StepCount stepCount = StepCount._(_storageSteps["todayStepCount"]);
      _step = await getSteps(stepCount);

      print("DailyPedometer initialized $_step");
    }
  }

  int get steps {
    return _step;
  }

  void setMode(bool isWriteMode) {
    _isWriteMode = isWriteMode;
    print("DailyPedometer setMode $_isWriteMode");
  }

  Timer? _debounceTimer;

  void saveStepCount(StepCount stepCount) {
    if (_debounceTimer?.isActive ?? false) {
      _debounceTimer!.cancel();
    }

    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      debugPrint("DailyPedometer : save count");
      _storageSteps = await storage.save(stepCount);
    });
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

      debugPrint("DailyPedometer : flush read");
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
