import Ep.Companion.endpoint
import com.kostya.blog.utils.EndpointImpl
import com.kostya.blog.utils.InputData
import com.kostya.blog.utils.OutputData
import kotlin.reflect.KClass
import kotlin.test.Test
import kotlin.test.assertEquals
import kotlin.test.assertTrue

class SampleTests {
    class EmptyOut : OutputData

    @Test
    fun testUrlToString() {
        val endpoint = EndpointImpl.get<InputData.Empty, EmptyOut> { path { s("/") } }
        val compositeEndpoint = EndpointImpl.get<InputData.Empty, EmptyOut> { path { s("/abd") s ("def") } }
        val endpointWithPathVar = EndpointImpl.get<InputData.Empty, EmptyOut> { path { s("/") pv ("somePv") s ("a") } }
        val endpointWithQuery =
            EndpointImpl.get<InputData.Empty, EmptyOut> { path { s("/addr1") } query { rp("someQueryVariable") } }
        val endpointWithOptionalQuery =
            EndpointImpl.get<InputData.Empty, EmptyOut> { path { s("/addr2") } query { op("someQV") } }


        assertEquals("/", endpoint.url.toClientString().getOrNull())
        assertEquals("/abd/def", compositeEndpoint.url.toClientString().getOrNull())

        assertEquals(
            "/someVal/a",
            endpointWithPathVar.url.toClientString(pathVariables = mapOf("somePv" to "someVal")).getOrNull()
        )
        assertEquals(
            "/addr1?someQueryVariable=123",
            endpointWithQuery.url.toClientString(queryVariables = mapOf("someQueryVariable" to "123")).getOrNull()
        )
        assertEquals(
            "/addr2?someQV=456",
            endpointWithOptionalQuery.url.toClientString(queryVariables = mapOf("someQV" to "456")).getOrNull()
        )

        assertTrue { endpointWithPathVar.url.toClientString(pathVariables = mapOf("non-existing" to "someVal")).isFailure }
        assertTrue { endpointWithPathVar.url.toClientString().isFailure }

        assertTrue { endpointWithQuery.url.toClientString(queryVariables = mapOf("non-existing" to "someVal")).isFailure }
        assertTrue { endpointWithQuery.url.toClientString().isFailure }

        assertEquals("/addr2", endpointWithOptionalQuery.url.toClientString().getOrNull())
    }
}


