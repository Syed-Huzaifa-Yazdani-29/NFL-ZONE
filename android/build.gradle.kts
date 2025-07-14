buildscript {
    repositories {
        google()
        mavenCentral()  // Changed from jcentre() to mavenCentral()
    }

    dependencies {
        classpath("com.google.gms:google-services:4.4.2")  // Fixed classpath syntax and artifact ID
        classpath("com.android.tools.build:gradle:7.3.1")  // Added Android Gradle plugin
        classpath("com.google.gms:google-services:4.3.15") // in dependencies
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.7.20")  // Added Kotlin plugin
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
