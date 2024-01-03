package io.bitbunny.daily_pedometer.daily_pedometer

import android.hardware.Sensor
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import android.hardware.SensorEventListener

/** DailyPedometerPlugin */
class DailyPedometerPlugin: FlutterPlugin {
  private lateinit var stepCountChannel: EventChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    /// Create channels
    stepCountChannel = EventChannel(flutterPluginBinding.binaryMessenger, "daily_step_count")

    /// Create handlers
    val stepCountHandler = SensorStreamHandler(flutterPluginBinding, Sensor.TYPE_STEP_COUNTER)

    /// Set handlers
    stepCountChannel.setStreamHandler(stepCountHandler)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    stepCountChannel.setStreamHandler(null)
  }
}
