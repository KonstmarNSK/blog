import java.lang.ProcessBuilder.Redirect
import java.nio.file.Files
import java.nio.file.LinkOption


group = "ru.kostya"
version = "0.0.1-SNAPSHOT"


val buildDirParam = File(projectDir, "build")
val pathToCargoExecutableParam = "cargo"
val maxBuildTimeSecondsParam = 300L
val cargoBuildDir = File(projectDir, "build")

buildDir = buildDirParam

abstract class BuildServer : DefaultTask() {
    @get:Input
    abstract val maxBuildTimeSeconds: Property<Long>

    @get:Input
    abstract val pathToCargoExecutable: Property<String?>

    @get:InputDirectory
    abstract val elmRootDirectory: DirectoryProperty

    @get:OutputDirectory
    abstract val outputDir: DirectoryProperty

    @TaskAction
    fun doBuild() {
        val maxBuildTimeSeconds = maxBuildTimeSeconds.get()
        val pathToCargoExecutable = pathToCargoExecutable.get()
        val cargoRootDirectory = elmRootDirectory.get().asFile
        val outputDir = outputDir.get().asFile


        val cmd = """ $pathToCargoExecutable build --release""".trimIndent()
            .replace(System.lineSeparator(), "")
            .split(" ")

        println("Cmd is $cmd")

        ProcessBuilder(cmd)
            .directory(cargoRootDirectory)
            .redirectOutput(Redirect.INHERIT)
            .redirectError(Redirect.INHERIT)
            .start()
            .waitFor(maxBuildTimeSeconds, TimeUnit.SECONDS)
    }
}


abstract class CleanServer : DefaultTask() {

    @get:Input
    abstract var filesToRemove: List<File>

    @TaskAction
    fun doClean() {
        println("Will delete: \n ${filesToRemove.joinToString(",\n") { it.absolutePath }}")

        filesToRemove.forEach{deleteDirectory(it.toPath())}
    }


    private fun deleteDirectory(path: java.nio.file.Path) {
        if (Files.isDirectory(path, LinkOption.NOFOLLOW_LINKS)) {
            Files.newDirectoryStream(path).use { entries ->
                for (entry in entries) {
                    deleteDirectory(entry)
                }
            }
        }
        Files.deleteIfExists(path)
    }
}

tasks.register<BuildServer>("build") {
//    dependsOn("copy-front-clienthttp")

    maxBuildTimeSeconds.set(maxBuildTimeSecondsParam)
    outputDir.set(buildDirParam)
    pathToCargoExecutable.set(pathToCargoExecutableParam)
    elmRootDirectory.set(layout.projectDirectory)
}

tasks.register<CleanServer>("clean"){
    filesToRemove = listOf(buildDirParam, cargoBuildDir)
}




