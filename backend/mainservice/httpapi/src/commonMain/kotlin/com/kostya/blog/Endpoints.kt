package com.kostya.blog

import com.kostya.blog.utils.Endpoint
import com.kostya.blog.utils.InputData
import com.kostya.blog.utils.OutputData
import kotlinx.serialization.Serializable


object pages {
    val homepageEndpoint =          Endpoint.get<InputData.Empty, HPOut> { s("/") }
    val createPostPageEndpoint =    Endpoint.get<InputData.Empty, CPOut> { s("/post/create") }
    val viewPostPageEndpoint =      Endpoint.get<InputData.Empty, VPOut> { s("/post/view").pv("post_id") }
    val viewAllPostsPageEndpoint =  Endpoint.get<InputData.Empty, VAOut> { s("/post/all") }


    @Serializable data class HPOut(val someData: String): OutputData
    @Serializable data class CPOut(val someData: String): OutputData
    @Serializable data class VPOut(val someData: String): OutputData
    @Serializable data class VAOut(val someData: String): OutputData
}

