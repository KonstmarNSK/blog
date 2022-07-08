plugins {
    kotlin("multiplatform") version "1.7.0"
    kotlin("plugin.serialization") version "1.7.0"
}

group = "me.konstantin"
version = "1.0-SNAPSHOT"

repositories {
    mavenCentral()
}

kotlin {
    jvm {
        compilations.all {
            kotlinOptions.jvmTarget = "11"
        }
        withJava()
        testRuns["test"].executionTask.configure {
            useJUnitPlatform()
        }
    }

    js(IR) {
        browser {
            testTask {
                enabled = false
            }
        }
        binaries.executable()
    }

    sourceSets {
        val commonMain by getting {
            dependencies {
                implementation("org.jetbrains.kotlinx:kotlinx-serialization-json:1.3.3")
            }
        }

        val commonTest by getting {
            dependencies {
                implementation(kotlin("test"))
//                testImplementation(kotlin("test-js"))
            }
        }
    }
}
