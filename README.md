# daily_pedometer

I measure my step count daily. Supports Android only

# Permissions
```
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
```


# Example Usage 
```
See the [example app](https://github.com/ganer9r/daily_pedometer/blob/main/example/lib/main.dart) for a fully-fledged example.

Below is shown a more generalized example. Remember to set the required permissions, as described above. This may require you to manually allow the permission in the "Settings" on the phone.


DailyPedometer().stepCountStream.listen((event) async {
  setState(() {
    _platformVersion = " ${event} daily steps";
  });
});

```