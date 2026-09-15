package com.alinmapay.payment

import android.app.Activity
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import android.graphics.drawable.BitmapDrawable
import android.util.Log

import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


import com.alinmapay.android.PaymentSDK
import com.alinmapay.android.Interface.PaymentCallback
import com.alinmapay.android.Theme.SDKButtonStyle
import com.alinmapay.android.Theme.SDKTheme
import com.alinmapay.android.Theme.SDKMerchantBranding
import com.alinmapay.android.Theme.SDKInputStyle
import com.alinmapay.android.Theme.SDKTextStyle
import com.alinmapay.android.model.Request.PaymentRequest
import com.alinmapay.android.model.SDKConfiguration

class FlutterAlinmapayPaymentPlugin :
    FlutterPlugin,
    MethodCallHandler,
    ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var flutterAssets: FlutterPlugin.FlutterAssets? = null

    override fun onAttachedToEngine(
        @NonNull binding: FlutterPlugin.FlutterPluginBinding
    ) {
        flutterAssets = binding.flutterAssets

        channel = MethodChannel(
            binding.binaryMessenger,
            "flutter_alinmapay_payment"
        )

        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "initialize" -> initializeSDK(call, result)
            "startPayment" -> startPayment(call, result)
            else -> result.notImplemented()
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun initializeSDK(call: MethodCall, result: Result) {
        try {
            val args = call.arguments as? Map<String, Any>
            if (args == null) {
                result.error("INVALID_ARGUMENTS", "Arguments missing", null)
                return
            }

            val themeMap = args["theme"] as? Map<String, Any>
            val theme = createTheme(themeMap)

            val configuration = SDKConfiguration.Builder()
                .setTerminalId(args["terminalId"] as? String ?: "")
                .setPassword(args["password"] as? String ?: "")
                .setMerchantKey(args["merchantKey"] as? String ?: "")
                .setBaseUrl(args["baseUrl"] as? String ?: "")
                .setTheme(theme)
                .build()

            Log.d("AlinmaPay", "========== SDK Configuration ==========")
            Log.d("AlinmaPay", "Terminal ID : ${configuration.terminalId}")
            Log.d("AlinmaPay", "Base URL    : ${configuration.baseUrl}")
            Log.d("AlinmaPay", "MerchantKey : ${configuration.merchantKey}")
            Log.d("AlinmaPay", "=======================================")

            PaymentSDK.initialize(configuration)
            result.success(true)

        } catch (e: Exception) {
            result.error("INIT_ERROR", e.localizedMessage ?: "SDK initialization failed", null)
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun createTheme(map: Map<String, Any>?): SDKTheme {
        val theme = SDKTheme()
        if (map == null) return theme
        val context = activity ?: return theme
        (map["primaryColor"] as? String)?.let { parseColorSafely(it)?.let { c -> theme.setPrimaryColor(c) } }
        (map["backgroundColor"] as? String)?.let { parseColorSafely(it)?.let { c -> theme.setBackgroundColor(c) } }

        val brandingMap = map["merchantBranding"] as? Map<String, Any>
        val branding = if (brandingMap != null) {
            when (brandingMap["type"] as? String) {
                "logo" -> {
                    val bitmap = getLogoBitmap(brandingMap["logo"] as? String)

                    if (bitmap != null) {
                        val drawable = BitmapDrawable(
                            context.resources,
                            bitmap
                        )

                        SDKMerchantBranding.logo(drawable)
                    } else {
                        SDKMerchantBranding.none()
                    }
                }
                "text" -> SDKMerchantBranding.text(brandingMap["text"] as? String ?: "")
                else -> SDKMerchantBranding.none()
            }
        } else {
            SDKMerchantBranding.none()
        }
        theme.setMerchantBranding(branding)

        val primaryButtonMap = map["primaryButton"] as? Map<String, Any>
        val primaryButtonStyle = SDKButtonStyle()
        primaryButtonMap?.let { btn ->
            (btn["backgroundColor"] as? String)?.let { parseColorSafely(it)?.let { c -> primaryButtonStyle.setBackgroundColor(c) } }
            (btn["textColor"] as? String)?.let { parseColorSafely(it)?.let { c -> primaryButtonStyle.setTextColor(c) } }
            (btn["borderColor"] as? String)?.let { parseColorSafely(it)?.let { c -> primaryButtonStyle.setBorderColor(c) } }
            (btn["borderWidth"] as? Number)?.let { primaryButtonStyle.setBorderWidth(it.toFloat()) }
            (btn["cornerRadius"] as? Number)?.let { primaryButtonStyle.setCornerRadius(it.toFloat()) }
            (btn["height"] as? Number)?.let { primaryButtonStyle.setHeight(it.toFloat()) }
        } ?: run {
            primaryButtonStyle.setCornerRadius(12f)
            primaryButtonStyle.setBorderWidth(0f)
            primaryButtonStyle.setHeight(50f)
        }
        theme.setPrimaryButtonStyle(primaryButtonStyle)

        val textStyleMap =
            map["sdkTextStyle"] as? Map<String, Any>

        val textColor =
            (textStyleMap?.get("textColor") as? String)
                ?.let { parseColorSafely(it) }
                ?: Color.TRANSPARENT

        val textSize =
            (textStyleMap?.get("textSize") as? Number)
                ?.toInt()
                ?: 26

        val bold =
            textStyleMap?.get("bold") as? Boolean
                ?: false

        val textStyle = SDKTextStyle(
            textSize,
            bold,
            textColor
        )

        theme.setTextStyle(textStyle)

        val inputStyleMap =
            map["inputStyle"] as? Map<String, Any>

        val inputBackgroundColor =
            (inputStyleMap?.get("backgroundColor") as? String)
                ?.let { parseColorSafely(it) }
                ?: Color.WHITE

        val inputBorderColor =
            (inputStyleMap?.get("borderColor") as? String)
                ?.let { parseColorSafely(it) }
                ?: Color.TRANSPARENT

        val inputBorderWidth =
            (inputStyleMap?.get("borderWidth") as? Number)
                ?.toFloat()
                ?: 1f

        val inputCornerRadius =
            (inputStyleMap?.get("cornerRadius") as? Number)
                ?.toFloat()
                ?: 12f

        val inputStyle = SDKInputStyle(
            inputBackgroundColor,
            inputBorderColor,
            inputBorderWidth,
            inputCornerRadius
        )

        theme.setInputStyle(inputStyle)

        return theme
    }

    private fun parseColorSafely(value: String): Int? {
        return try { Color.parseColor(value) } catch (e: Exception) { Log.e("AlinmaPay", "Invalid color: $value"); null }
    }

    private fun getLogoBitmap(logoName: String?): Bitmap? {
        if (logoName.isNullOrBlank()) {
            return null
        }

        val context = activity ?: return null
        val assets = flutterAssets ?: return null

        return try {
            val assetPath: String =
                assets.getAssetFilePathByName(logoName)

            Log.d(
                "AlinmaPay",
                "Loading Flutter logo: $logoName"
            )

            Log.d(
                "AlinmaPay",
                "Resolved asset path: $assetPath"
            )

            context.assets.open(assetPath).use { inputStream ->
                BitmapFactory.decodeStream(inputStream)
            }

        } catch (e: Exception) {
            Log.e(
                "AlinmaPay",
                "Failed to load logo: $logoName",
                e
            )
            null
        }
    }
    private fun startPayment(call: MethodCall, result: Result) {
        val currentActivity = activity ?: run { result.error("NO_ACTIVITY", "Activity is null", null); return }
        try {
            val request = PaymentRequest.Builder()
                .setAmount(call.argument<String>("amount") ?: "")
                .setTransactionType(call.argument<String>("transactionType") ?: "")
                .setCurrency(call.argument<String>("currency") ?: "")
                .setEmail(call.argument<String>("email") ?: "")
                .setAddress(call.argument<String>("address") ?: "")
                .setCity(call.argument<String>("city") ?: "")
                .setState(call.argument<String>("state") ?: "")
                .setZip(call.argument<String>("zip") ?: "")
                .setCountryCode(call.argument<String>("countryCode") ?: "")
                .setTrackId(call.argument<String>("trackId") ?: "")
                .setCardOperation(call.argument<String>("cardOperation") ?: "")
                .setCardToken(call.argument<String>("cardToken") ?: "")
                .setTokenType(call.argument<String>("tokenType") ?: "0")
                .setTransactionId(call.argument<String>("transactionId") ?: "")
                .setMetadata(call.argument<String>("metadata") ?: "")
                .build()

            PaymentSDK.getInstance().startPayment(currentActivity, request, object : PaymentCallback {
                override fun onResult(response: String) {
                    currentActivity.runOnUiThread { result.success(response) }
                }
            })
        } catch (e: Exception) {
            result.error("PAYMENT_ERROR", e.localizedMessage ?: "Payment failed", null)
        }
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) { activity = binding.activity }
    override fun onDetachedFromActivity() { activity = null }
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) { activity = binding.activity }
    override fun onDetachedFromActivityForConfigChanges() { activity = null }
    override fun onDetachedFromEngine(
        @NonNull binding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel.setMethodCallHandler(null)
        flutterAssets = null
    }
}
