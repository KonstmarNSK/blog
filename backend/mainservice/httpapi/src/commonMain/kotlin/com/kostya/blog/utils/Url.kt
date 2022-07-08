package com.kostya.blog.utils


enum class HttpMethod{ GET, POST }

/*

  https://example.com:8042/over/there?name=ferret#nose
  \___/   \______________/\_________/ \_________/ \__/
    |            |            |            |        |
  scheme     authority       path        query   fragment

 */

sealed interface PartOfPath {
    data class StringPathPart(val s: String) : PartOfPath
    data class PathVariable(val name: String) : PartOfPath
}

sealed interface PartOfQuery{
    data class StringQueryPart(val s: String) : PartOfQuery
    data class QueryVariable(val name: String) : PartOfQuery
}

sealed interface UrlPart{
    data class PathUrlPart(val pathParts: List<PartOfPath>) : UrlPart
    data class QueryUrlPart(val queryParts: List<PartOfQuery>) : UrlPart
}



class Url private constructor(
    private val pathPart: UrlPart.PathUrlPart,
    private val queryPart: UrlPart.QueryUrlPart
) {
    companion object { fun builder(): UrlBuilder = UrlBuilder.empty() }

    fun toClientString(
        pathVariables: Map<String, String> = emptyMap(),
        queryVariables: Map<String, String> = emptyMap()
    ): Result<String> =
        with(ClientUrlStringifier(pathVariables, queryVariables)) {

            pathPart.pathParts.runCatching {
                fold("") { accum, next ->
                        accum.trimEnd('/') + "/" + pathPartProcess(next).trimStart('/')
                    }
            }.mapCatching {
                if (showQuery(queryPart))
                    "$it?" + queryPart.queryParts.joinToString(separator = "&") { queryPart ->
                            queryPartProcess(queryPart)
                    }
                else
                    it
            }
        }


    interface Stringifier {
        fun pathPartProcess(pathPart: PartOfPath) : String
        fun queryPartProcess(queryPart: PartOfQuery) : String
        fun showQuery(query: UrlPart.QueryUrlPart) : Boolean
    }

    private class ClientUrlStringifier(
        val pathVariables: Map<String, String>,
        val queryVariables: Map<String, String>
    ) : Stringifier {

        override fun pathPartProcess(pathPart: PartOfPath) =
            when(pathPart) {
                is PartOfPath.StringPathPart -> pathPart.s

                is PartOfPath.PathVariable ->
                    when(val value = pathVariables[pathPart.name]) {
                        is String -> value
                        else -> throw IllegalArgumentException("Value for path variable '${pathPart.name}' wasn't set")
                    }
            }

        override fun queryPartProcess(queryPart: PartOfQuery) =
            when(queryPart) {
                is PartOfQuery.StringQueryPart -> queryPart.s

                is PartOfQuery.QueryVariable ->
                    when(val value = queryVariables[queryPart.name]) {
                        is String -> "${queryPart.name}=$value"
                        else -> throw IllegalArgumentException("Value for query variable '${queryPart.name}' wasn't set")
                    }
            }

        override fun showQuery(query: UrlPart.QueryUrlPart): Boolean = query.queryParts.isNotEmpty()
    }



    class UrlBuilder private constructor(
        private val pathBuilder: PathPartUrlBuilder,
        private val queryBuilder: QueryPartUrlBuilder
    ){
        companion object { fun empty() = UrlBuilder(PathPartUrlBuilder.empty(), QueryPartUrlBuilder.empty())}

        fun path(pathBuilder: PathPartUrlBuilder.() -> PathPartUrlBuilder) =
            UrlBuilder(pathBuilder.invoke(this.pathBuilder), queryBuilder)

        fun query(queryBuilder: QueryPartUrlBuilder.() -> QueryPartUrlBuilder) =
            UrlBuilder(pathBuilder, queryBuilder.invoke(this.queryBuilder))


        fun build() = Url(pathBuilder.build(), queryBuilder.build())
    }
}






class PathPartUrlBuilder private constructor(
    private val pathParts: List<PartOfPath>
) {
    companion object { fun empty() = PathPartUrlBuilder(emptyList())}

    fun s(s: String) = PathPartUrlBuilder(pathParts + PartOfPath.StringPathPart(s))
    fun pv(s: String) = PathPartUrlBuilder(pathParts + PartOfPath.PathVariable(s))

    fun build() = UrlPart.PathUrlPart(pathParts)
}


class QueryPartUrlBuilder constructor(
    private val queryParts: List<PartOfQuery>
) {
    companion object { fun empty() = QueryPartUrlBuilder(emptyList())}

    fun s(s: String) = QueryPartUrlBuilder(queryParts + PartOfQuery.StringQueryPart(s))
    fun qv(s: String) = QueryPartUrlBuilder(queryParts + PartOfQuery.QueryVariable(s))

    fun build() = UrlPart.QueryUrlPart(queryParts)
}

