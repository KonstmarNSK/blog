package com.kostya.blog

import com.kostya.blog.utils.EndpointImpl
import com.kostya.blog.utils.InputData
import com.kostya.blog.utils.OutputData
import kotlinx.serialization.Serializable


object pages {
    val homepageEndpoint =          EndpointImpl.get<InputData.Empty, HPOut> { path{ s("/") }}
    val createPostPageEndpoint =    EndpointImpl.get<InputData.Empty, CPOut> { path{ s("/post/create") }}
    val viewPostPageEndpoint =      EndpointImpl.get<InputData.Empty, VPOut> { path{ s("/post/view") pv ("post_id") }}
    val viewAllPostsPageEndpoint =  EndpointImpl.get<InputData.Empty, VAOut> { path{ s("/post/all") }}

    val experimental = EndpointImpl.get<InputData.Empty, HPOut> { path{ s("/someurl") }}

    @Serializable data class HPOut(val someData: String): OutputData
    @Serializable data class CPOut(val someData: String): OutputData
    @Serializable data class VPOut(val someData: String): OutputData
    @Serializable data class VAOut(val someData: String): OutputData
}

