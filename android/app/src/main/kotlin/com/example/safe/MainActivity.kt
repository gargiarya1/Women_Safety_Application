package com.example.safe

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.example.sos/sms" // must match the Dart side channel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "sendSMS") {
                val recipients = call.argument<List<String>>("recipients") ?: listOf()
                val message = call.argument<String>("message") ?: ""

                try {
                    val uri = Uri.parse("smsto:" + recipients.joinToString(";"))
                    val intent = Intent(Intent.ACTION_SENDTO, uri)
                    intent.putExtra("sms_body", message)
                    intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                    startActivity(intent)
                    result.success(null)
                } catch (e: Exception) {
                    result.error("SMS_FAILED", "Could not send SMS: ${e.message}", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
