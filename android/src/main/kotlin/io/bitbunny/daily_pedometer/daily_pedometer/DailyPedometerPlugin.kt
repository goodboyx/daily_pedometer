package io.bitbunny.daily_pedometer.daily_pedometer

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import android.util.Log

/** DailyPedometerPlugin */
class DailyPedometerPlugin: FlutterPlugin {
  private lateinit var stepCountChannel: EventChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    Log.d("DailyPedometerPlugin", "onAttachedToEngine called");

    /// Create channels
    stepCountChannel = EventChannel(flutterPluginBinding.binaryMessenger, "daily_step_count")

    /// Create handlers
    val stepCountHandler = SensorStreamHandler(flutterPluginBinding)

    /// Set handlers
    stepCountChannel.setStreamHandler(stepCountHandler)

    
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    stepCountChannel.setStreamHandler(null)
  }
}
