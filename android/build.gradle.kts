allprojects {
    repositories {
        google()
        mavenCentral()
        flatDir {
            dirs("openCV/native/libs")
        }
    }

    configurations.all {
        resolutionStrategy {
            force("com.google.mediapipe:tasks-vision:0.10.14")
        }
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
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
