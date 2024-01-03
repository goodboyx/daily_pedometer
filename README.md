# daily_pedometer

I measure my step count daily. Supports Android only

# Permissions
```
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
```


# Example Usage 
```
DailyPedometer.stepCountStream.listen(_onStepCount);

Future<void> _onStepCount(StepCount event) async {
  print(event);
}
```