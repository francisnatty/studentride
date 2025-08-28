plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // FlutterFire
    id("org.jetbrains.kotlin.android")   // prefer this id on KTS
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.studentride"

    // Move to API 35 to match androidx.core:core-ktx:1.16.0 requirement
    compileSdk = 35
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.studentride"

     
        minSdk = 23
        targetSdk = 35

        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// (Optional if you actually need multidex at minSdk < 21; usually Flutter minSdk is 21+)
// dependencies {
//     implementation("androidx.multidex:multidex:2.0.1")
// }
