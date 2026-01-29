plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") 
}

android {
    namespace = "com.umrati.umrah.guide.app"
    compileSdk = 36
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.umrati.umrah.guide.app"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
    signingConfigs {
        create("release") {
            keyAlias = project.findProperty("MY_KEY_ALIAS") as String
            keyPassword = project.findProperty("MY_KEY_PASSWORD") as String
            storeFile = file(project.findProperty("MY_STORE_FILE") as String)
            storePassword = project.findProperty("MY_KEYSTORE_PASSWORD") as String
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:32.8.0"))
    implementation("com.google.firebase:firebase-auth") 
    implementation("com.google.android.gms:play-services-auth:20.9.0")
    implementation("com.android.billingclient:billing-ktx:6.1.0")
    implementation("com.google.android.play:integrity")
    implementation("com.stripe:stripe-android:22.5.0")
}