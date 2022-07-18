use actix_web::{get, Responder, web};
use serde::Serialize;

pub fn init_api(cfg: &mut web::ServiceConfig) {
    cfg
        // .service(get_all_posts)
        // .service(get_all_posts)
        .service(get_all_posts);
}


#[derive(Serialize)]
struct Post{
    title: String,
    content: String
}

#[get("/get-all-posts")]
async fn get_all_posts() -> impl Responder {
    let posts =
        vec![
            Post{
                title: "First title".to_owned(),
                content: "First content".to_owned()
            },

            Post{
                title: "Second title".to_owned(),
                content: "Second content".to_owned()
            }
        ];

    web::Json(posts)
}
