allprojects {
    repositories {
        google()
        mavenCentral()
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
// Beberapa plugin (misal tflite_flutter) mengompilasi Java dengan target 11,
// sedangkan Kotlin default ke 17, sehingga build gagal dengan
// "Inconsistent JVM Target Compatibility". Samakan target Kotlin dengan
// target Java milik setiap modul. Harus didaftarkan sebelum blok
// evaluationDependsOn di bawah, agar berlaku sebelum modul dievaluasi.
// Modul :app dilewati karena sudah mengatur Java & Kotlin ke 17 sendiri.
subprojects {
    if (name == "app") return@subprojects
    afterEvaluate {
        val android = extensions.findByName("android")
            as? com.android.build.gradle.BaseExtension ?: return@afterEvaluate
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            // Dibaca saat task disiapkan, setelah pengaturan Java modul final.
            val javaTarget = android.compileOptions.targetCompatibility.toString()
            compilerOptions.jvmTarget.set(
                org.jetbrains.kotlin.gradle.dsl.JvmTarget.fromTarget(javaTarget),
            )
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
