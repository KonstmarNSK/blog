package ru.kostya.blog

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.ConfigurationPropertiesScan
import org.springframework.boot.context.properties.EnableConfigurationProperties
import org.springframework.boot.runApplication

@ConfigurationPropertiesScan(basePackages = ["ru.kostya.blog.configs.properties"])
@SpringBootApplication
class Main

fun main(args: Array<String>) {
	runApplication<Main>(*args)
}
