package com.kostya.blog.utils

import kotlin.reflect.KProperty


data class Endpoint<TInput: InputData, TOutput: OutputData>(
    val url: Url,
    val method: HttpMethod
) {

    companion object {

        inline fun <reified TIn: InputData, reified TOut: OutputData> get(url: Url.UrlBuilder.() -> Url.UrlBuilder) =
            Endpoint<TIn, TOut>(url = url.invoke(Url.builder()).build(), HttpMethod.GET)

        inline fun <reified TIn: InputData, reified TOut: OutputData> post(url: Url.UrlBuilder.() -> Url.UrlBuilder) =
            Endpoint<TIn, TOut>(url = url.invoke(Url.builder()).build(), HttpMethod.POST)

    }

}


interface OutputData

abstract class InputData{
    val queryParams: MutableMap<String, String> = mutableMapOf()
    val pathParams: MutableMap<String, String> = mutableMapOf()


    class QueryParamDelegate(private val pName: String){
        operator fun getValue(thisRef: InputData, property: KProperty<*>): String? =
            thisRef.queryParams[pName]

        operator fun setValue(thisRef: InputData, property: KProperty<*>, value: String) {
            thisRef.queryParams[pName] = value
        }
    }


    class PathParamDelegate(private val pName: String){
        operator fun getValue(thisRef: InputData, property: KProperty<*>): String? =
            thisRef.pathParams[pName]

        operator fun setValue(thisRef: InputData, property: KProperty<*>, value: String) {
            thisRef.pathParams[pName] = value
        }
    }


    class Empty: InputData()


    companion object {
        fun queryParam(name: String) = QueryParamDelegate(name)
        fun pathParam(name: String) = PathParamDelegate(name)
    }
}

