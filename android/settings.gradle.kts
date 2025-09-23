pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

include(":app")

// Подключаем Flutter SDK для плагина
val localProperties = java.util.Properties()
val localPropertiesFile = File(rootDir, "local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(Charsets.UTF_8).use { localProperties.load(it) }
}

val flutterSdkPath = localProperties.getProperty("flutter.sdk")
if (flutterSdkPath != null) {
    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")
}
