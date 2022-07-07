plugins {
    kotlin("js") version "1.7.0"
    kotlin("plugin.serialization") version "1.7.0"
}

group = "com.kostya"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

kotlin {
    js(IR) {
        browser {}
        binaries.executable()
    }
}

dependencies {
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.6.0")
    implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.3.2")
    implementation(project(":backend:mainservice:httpapi"))
}
