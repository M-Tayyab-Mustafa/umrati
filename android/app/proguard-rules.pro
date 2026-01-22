# Keep all Stripe classes
-keep class com.stripe.** { *; }

# Avoid warnings for ReactNative Stripe SDK push provisioning references
-dontwarn com.stripe.android.pushProvisioning.**
-dontwarn com.reactnativestripesdk.pushprovisioning.**

# Optional (helps with other missing references)
-dontwarn com.stripe.**
