package ru.kostya.blog.endpoints

import com.kostya.blog.pages
import com.kostya.blog.utils.*
import org.springframework.context.annotation.Bean
import org.springframework.http.HttpMethod
import org.springframework.web.servlet.function.RequestPredicates
import org.springframework.web.servlet.function.RouterFunction
import org.springframework.web.servlet.function.RouterFunctions.route
import org.springframework.web.servlet.function.ServerResponse
import org.springframework.web.servlet.function.ServerResponse.ok
import com.kostya.blog.utils.HttpMethod as EndpointHttpMethod



@Bean
fun getServerEndpointsImplementation() : RouterFunction<ServerResponse> =
    pages.homepageEndpoint.intoSpringRoute{ _ -> Result.success(pages.HPOut(someData = "from home controller"))}.getOrThrow()



private inline fun <reified TInput : InputData, reified TOutput : OutputData> Endpoint<TInput, TOutput>.intoSpringRoute(
    crossinline handler: (Result<TInput?>) -> Result<TOutput>
): Result<RouterFunction<ServerResponse>> =
    this.url.toString(clientUrlStringifier).map { strUrl ->
        route(
            RequestPredicates.method(this.method.intoSpringMethod())
                .and(RequestPredicates.path(strUrl))
        ) { request ->
//            val pv = request.pathVariables()
//            val qv = request.params()
//
//            val input = InputData(pv, qv)

            ok().body(
                handler.invoke(Result.success(null))
            )
        }
    }


private fun EndpointHttpMethod.intoSpringMethod() =
    when (this) {
        EndpointHttpMethod.GET -> HttpMethod.GET
        EndpointHttpMethod.POST -> HttpMethod.POST
    }


private object clientUrlStringifier : Url.Stringifier {

    override fun pathPartProcess(pathPart: PartOfPath) =
        when (pathPart) {
            is PartOfPath.StringPathPart -> pathPart.s
            is PartOfPath.PathVariable -> "{${pathPart.name}}"
        }


    override fun queryPartProcess(queryPart: PartOfQuery) =
        throw java.lang.UnsupportedOperationException("We don't show queries here")  // never happens


    override fun showQuery(query: UrlPart.QueryUrlPart): Boolean = false

}