import java.lang.ProcessBuilder.Redirect
import java.nio.file.Files
import java.nio.file.LinkOption


group = "ru.kostya"
version = "0.0.1-SNAPSHOT"


val buildDirParam = File(projectDir, "build")
val elmStuffDirParam = File(projectDir, "elm-stuff")
val pathToElmExecutableParam = "elm"
val maxBuildTimeSecondsParam = 300L

buildDir = buildDirParam

abstract class BuildFrontend : DefaultTask() {
    @get:Input
    abstract val maxBuildTimeSeconds: Property<Long>

    @get:Input
    abstract val pathToElmExecutable: Property<String?>

    @get:InputDirectory
    abstract val elmRootDirectory: DirectoryProperty

    @get:OutputDirectory
    abstract val outputDir: DirectoryProperty

    @TaskAction
    fun doBuild() {
        val maxBuildTimeSeconds = maxBuildTimeSeconds.get()
        val pathToElmExecutable = pathToElmExecutable.get()
        val elmRootDirectory = elmRootDirectory.get().asFile
        val outputDir = outputDir.get().asFile

        println("maxBuildTimeSeconds is $maxBuildTimeSeconds")
        println("pathToElmExecutable is $pathToElmExecutable")
        println("elmRootDirectory is ${elmRootDirectory.absolutePath}")
        println("outputDir is ${outputDir.absolutePath}")

        File(elmRootDirectory, "src")
            .listFiles()
            ?.filter { it.extension == "elm" }
            ?.map {

                val cmd = """
                    
                    $pathToElmExecutable
                     make 
                    ${it.absolutePath}
                     --output 
                    ${outputDir.absolutePath}/${it.nameWithoutExtension}.js
                
                """.trimIndent()
                    .replace(System.lineSeparator(), "")
                    .split(" ")

                println("Cmd is $cmd")

                ProcessBuilder(cmd)
                    .directory(elmRootDirectory)
                    .redirectOutput(Redirect.INHERIT)
                    .redirectError(Redirect.INHERIT)
                    .start()
            }
            ?.forEach {
                it.waitFor(maxBuildTimeSeconds, TimeUnit.SECONDS)
            }
    }
}



abstract class CleanFrontend : DefaultTask() {

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


tasks.register<BuildFrontend>("build") {
    maxBuildTimeSeconds.set(maxBuildTimeSecondsParam)
    outputDir.set(buildDirParam)
    pathToElmExecutable.set(pathToElmExecutableParam)
    elmRootDirectory.set(layout.projectDirectory)
}

tasks.register<CleanFrontend>("clean"){
    filesToRemove = listOf(buildDirParam, elmStuffDirParam)
}