package com.kostya.blog

import com.kostya.blog.utils.Endpoint
import com.kostya.blog.utils.InputData
import com.kostya.blog.utils.OutputData
import kotlinx.browser.window
import kotlinx.coroutines.await

class ClientEndpoint<TInput : InputData, TOutput : OutputData>(
    val serverLocation: String,
    val endpoint: Endpoint<TInput, TOutput>
) {
    fun req() =
        EndpointReqBuilder<TInput, TOutput>(
            serverLocation,
            endpoint,
            null
        )
}


class EndpointReqBuilder<TInput : InputData, TOutput : OutputData>(
    val serverLocation: String,
    val endpoint: Endpoint<TInput, TOutput>,
    val reqData: TInput?
) {

    fun withData(data: TInput) =
        EndpointReqBuilder<TInput, TOutput>(
            serverLocation,
            endpoint,
            data
        )

    suspend fun send() : String {
        val (pathVars, queryVars) = when (reqData) {
            is TInput -> Pair(reqData.pathParams, reqData.queryParams)
            else -> Pair(mapOf<String, String>(), mapOf<String, String>())
        }

        val url : String = serverLocation + endpoint.url.toClientString(pathVars, queryVars).getOrThrow()
        console.log("Url is $url")

        return window
            .fetch(
                url
            )
            .await()
            .text()
            .await()
    }
}
