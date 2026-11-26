import java.util.Base64

plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Options --dart-define et --dart-define-from-file : Flutter les transmet à Gradle
// encodées en base64 et séparées par des virgules.
val dartDefines: Map<String, String> =
    (findProperty("dart-defines") as String?)
        ?.split(",")
        ?.filter { it.isNotBlank() }
        ?.map { String(Base64.getDecoder().decode(it)).split("=", limit = 2) }
        ?.filter { it.size == 2 }
        ?.associate { it[0] to it[1] }
        ?: emptyMap()

// APK à partager (--dart-define=ENV_MARKS=false) : nom « ZAKA » et version sans suffixe.
// Le bandeau « DEV » est retiré côté Dart par la même option (lib/app/flavor.dart).
val envMarks = dartDefines["ENV_MARKS"] != "false"

android {
    namespace = "com.zaka.zaka"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.zaka.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    // Nécessaire depuis AGP 9 pour les resValue des flavors (nom de l'app).
    buildFeatures {
        resValues = true
    }

    // Un flavor par projet Firebase : zaka-dev-01, zaka-staging, zaka-prod-8c5c8.
    // Le google-services.json de chaque flavor va dans src/<flavor>/.
    // Lancer avec : flutter run --flavor dev --dart-define=FLAVOR=dev
    flavorDimensions += "env"
    productFlavors {
        // L'identifiant (.dev, .staging) ne change pas avec ENV_MARKS : il doit
        // correspondre au google-services.json du flavor.
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            if (envMarks) versionNameSuffix = "-dev"
            resValue("string", "app_name", if (envMarks) "ZAKA Dev" else "ZAKA")
        }
        create("staging") {
            dimension = "env"
            applicationIdSuffix = ".staging"
            if (envMarks) versionNameSuffix = "-staging"
            resValue("string", "app_name", if (envMarks) "ZAKA Test" else "ZAKA")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "ZAKA")
        }
    }

    buildTypes {
        release {
            // À remplacer par la clé de signature Play (voir docs/MISE_EN_PLACE.md, section 3.2).
            // Clé de debug en attendant, pour que `flutter run --release` fonctionne.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
