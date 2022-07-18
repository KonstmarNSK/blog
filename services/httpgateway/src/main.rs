mod api;

use actix_web::{get, App, HttpServer, Responder, HttpResponse, web};


// todo: add ssl and authentication via rustls and actix-web-httpauth
#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .service(
                web::scope("/api").configure(api::init_api)
            )
    })
        .bind(("127.0.0.1", 8080))?
        .run()
        .await
}


#[get("/")]
async fn show_page() -> impl Responder {
    HttpResponse::Ok().body("(&data.the_page).to_owned()")
}