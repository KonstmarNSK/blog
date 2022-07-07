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
            mutableMapOf(),
            null
        )
}


class EndpointReqBuilder<TInput : InputData, TOutput : OutputData>(
    val serverLocation: String,
    val endpoint: Endpoint<TInput, TOutput>,
    val pathVariables: Map<String, String>,
    val reqData: TInput?
) {

    fun withPathVar(name: String, value: String) =
        EndpointReqBuilder<TInput, TOutput>(
            serverLocation,
            endpoint,
            pathVariables + (name to value),
            reqData
        )

    fun withData(data: TInput) =
        EndpointReqBuilder<TInput, TOutput>(
            serverLocation,
            endpoint,
            pathVariables,
            data
        )

    suspend fun send() {
        val response = window
            .fetch(
                serverLocation + endpoint.url.toString(pathVariables).getOrThrow()
            )
            .await()
            .text()
            .await()
    }
}
