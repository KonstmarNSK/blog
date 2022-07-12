package ru.kostya.blog

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.context.properties.ConfigurationPropertiesScan
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.web.servlet.function.RequestPredicates.GET
import org.springframework.web.servlet.function.RouterFunction
import org.springframework.web.servlet.function.RouterFunctions.route
import org.springframework.web.servlet.function.ServerResponse
import org.springframework.web.servlet.function.ServerResponse.ok
import ru.kostya.blog.Ep.Companion.endpoint
import kotlin.reflect.KClass

@ConfigurationPropertiesScan(basePackages = ["ru.kostya.blog.configs.properties"])
@SpringBootApplication
class Main

fun main(args: Array<String>) {
//	runApplication<Main>(*args)
	f(Api.first)
}

@Bean
fun getEmployeeByIdRoute(): RouterFunction<ServerResponse> {
	return route(
		GET("/employees")
	) {
		ok().body(
			"some answer"
		)
	}
}

@Bean
fun productListing(): RouterFunction<ServerResponse> {
	return route().GET("/product") { req -> ok().body("ps.findAll()") }
		.build()
}





interface Ep<T: Any> {
	companion object {
		inline fun <reified T: Any, reified TApi: Any> endpoint(ep: TApi) : Ep<T> {
			println("Ep is $ep")
			return EpImpl<T>(T::class)
		}
	}
}


inline fun <reified Tk: Any> Ep<Tk>.f() = Tk::class

class EpImpl<T: Any> (val k: KClass<T>) : Ep<T>




sealed interface Api {
	object first : Api, Ep<String> by endpoint(first)
}


inline fun <reified T, reified V> f (va : T)
		where
		T: Api,
		T: Ep<V>,
		V: Any =
	when (va as Api) { // https://youtrack.jetbrains.com/issue/KT-21908
		is Api.first -> va.f()
	}