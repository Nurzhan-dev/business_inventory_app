pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
    includeBuild("/opt/hostedtoolcache/flutter/stable-3.35.2-x64/packages/flutter_tools/gradle")
}

include(":app")
