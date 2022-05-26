import org.gradle.internal.enterprise.test.FileProperty
import java.lang.ProcessBuilder.Redirect

group = "ru.kostya"
version = "0.0.1-SNAPSHOT"


val buildDir = File(layout.projectDirectory.asFile, "build")
val elmStuffDir = File(layout.projectDirectory.asFile, "elm-stuff")

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
        val outputDir = outputDir.get()

        println("maxBuildTimeSeconds is $maxBuildTimeSeconds")
        println("pathToElmExecutable is $pathToElmExecutable")
        println("elmRootDirectory is ${elmRootDirectory.absolutePath}")
        println("outputDir is ${outputDir.asFile.absolutePath}")

        val cmdsList = File(elmRootDirectory, "src")
            .listFiles()
            ?.filter { it.extension == "elm" }
            ?.map {

                val cmd = """
                    
                    $pathToElmExecutable
                     make 
                    ${it.absolutePath}
                     --output 
                    ${outputDir.asFile.absolutePath}/${it.nameWithoutExtension}.js
                
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
    abstract val filesToRemove: Property<List<File>>

    @TaskAction
    fun doClean() {
        println("Will delete: \n ${filesToRemove.get().joinToString(",\n") { it.absolutePath }}")
        filesToRemove.get().forEach{it.delete()}
    }
}








tasks.register<BuildFrontend>("build-frontend") {
    maxBuildTimeSeconds.set(300)
    outputDir.set(File(layout.projectDirectory.asFile, "build"))
    pathToElmExecutable.set("elm")
    elmRootDirectory.set(layout.projectDirectory)
}

tasks.register<CleanFrontend>("clean")

