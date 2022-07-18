use std::path::PathBuf;
use sailfish::TemplateOnce;

use actix_web::{get, web, App, HttpServer, Responder, HttpResponse, HttpRequest};
use actix_files as fs;
use actix_web::http::header;
use actix_web::web::{get, Header, route};
use mime;
use serde::Serialize;


const LOADING_SPINNER_BYTES: &'static [u8] = include_bytes!("static/spinner.gif");
const JS_SCRIPT: &'static [u8] = include_bytes!("static/Main-compressed.js");



struct AppState{
    the_page: String
}

// todo: add ssl and authentication via rustls and actix-web-httpauth
#[actix_web::main]
async fn main() -> std::io::Result<()> {

    let page : String = PageTemplate{
            elm_flags: ElmInputFlags {
                    api_root_addr: "http://localhost:8080/api".to_owned()
            }
    }.render_once().unwrap();

    HttpServer::new(move || {
        App::new()
            .app_data(web::Data::new(
                AppState{
                    the_page: page.clone()
                }))
            .service(show_page)
            .route("/assets/pic", web::get().to(show_pic))
            .route("/assets/Main-compressed.js", web::get().to(show_js))
    })
        .bind(("127.0.0.1", 8080))?
        .run()
        .await
}




// http endpoints

#[get("/")]
async fn show_page(data: web::Data<AppState>) -> impl Responder {
    HttpResponse::Ok().body((&data.the_page).to_owned())
}

async fn show_pic() -> impl Responder {
    HttpResponse::Ok()
        .append_header(header::ContentType(mime::IMAGE_GIF))
        .body(LOADING_SPINNER_BYTES)
}

async fn show_js() -> impl Responder {
    HttpResponse::Ok()

        .append_header(header::ContentType(mime::APPLICATION_JAVASCRIPT))
        .insert_header(header::ContentEncoding::Gzip)
        .body(JS_SCRIPT)
}



// page template

#[derive(TemplateOnce)]
#[template(path = "thePage.html")]
struct PageTemplate{
    elm_flags: ElmInputFlags
}

#[derive(Serialize)]
struct ElmInputFlags {
    api_root_addr: String,
}


