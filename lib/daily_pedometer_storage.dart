import 'dart:convert';

import 'package:daily_pedometer/daily_pedometer.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyPedometerStorage {
  final storageKey = 'STEPS';

  checkPreviousDate(steps, StepCount event) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    String todayDate = today.toIso8601String().split('T')[0];
    String yesterdayDate = yesterday.toIso8601String().split('T')[0];
    var currentSteps = event.steps;

    // print("----------");
    // print("PerometerStorage: after read : $steps");

    if (steps["todayDate"] == null) {
      // 오늘 날짜에 정보가 없다는 것은 앱 설치등 초기
      steps = {
        "previousDate": yesterdayDate,
        "previousStepCount": currentSteps,
        "todayDate": todayDate,
        "todayStepCount": currentSteps,
        "stack": [],
      };
    } else if (steps["todayDate"] != todayDate) {
      // 오늘 날짜와 같지 않으면, 날짜가 변경되었기 대문에 이전 날짜로 옮김
      // 날짜가 변경 되었는데, 기존에 저장된 걸음수가 현재 걸음수보다 높으면 부팅이 된 상태라서,
      // 기본 비교값을 0 으로 세팅함!
      int previousStepCount = (steps["todayStepCount"] > currentSteps)
          ? 0
          : steps["todayStepCount"];

      steps = {
        "previousDate": yesterdayDate,
        "previousStepCount": previousStepCount,
        "todayDate": todayDate,
        "todayStepCount": currentSteps,
        "stack": [],
      };
    } else if (steps["todayStepCount"] > currentSteps) {
      if (!steps.containsKey("stack")) {
        steps["stack"] = [];
      }

      steps["stack"].add(steps["todayStepCount"]);
    }

    debugPrint("PerometerStorage : ${steps}");
    return steps;
  }

  Future save(StepCount event) async {
    dynamic steps = await read();
    steps = checkPreviousDate(steps, event);
    steps["todayStepCount"] = event.steps;

    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(storageKey, jsonEncode(steps));
    return steps;
  }

  flush() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.reload();
  }

  read() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // dynamic testData = {
    //   "previousDate": "2024-01-04",
    //   "previousStepCount": 25332,
    //   "todayDate": "2024-01-05",
    //   "todayStepCount": 25348,
    //   "stack": [15]
    // };
    // await preferences.setString(storageKey, jsonEncode(testData));

    String? value = preferences.getString(storageKey);
    dynamic steps = {
      "previousDate": null,
      "previousStepCount": 0,
      "todayDate": null,
      "todayStepCount": 0,
      "stack": [],
    };

    if (value != null) {
      steps = jsonDecode(value);
    }

    // steps["todayDate"] = '2020-12-13';
    // print("==========");
    // print("PerometerStorage: read: $steps");

    return steps;
  }
}
