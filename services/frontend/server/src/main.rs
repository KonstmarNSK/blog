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



// todo: add ssl and authentication via rustls and actix-web-httpauth
#[actix_web::main]
async fn main() -> std::io::Result<()> {

    HttpServer::new(move || {
        App::new()
            .service(
                web::scope("/assets")
                    .route("/spinner", web::get().to(show_spinner))
                    .route("/Main-compressed.js", web::get().to(show_js))
            )
            .service(show_page)
    })
        .bind(("127.0.0.1", 8080))?
        .run()
        .await
}




// http endpoints

#[get("/")]
async fn show_page(req: HttpRequest) -> impl Responder {
    let mut page_root = "".to_owned();
    page_root.push_str(req.connection_info().scheme());
    page_root.push_str("://");
    page_root.push_str(req.connection_info().host());

    let page : String = PageTemplate{
        elm_flags: ElmInputFlags {
            api_root_addr: "http://localhost:8080/api".to_owned(),
            page_root_addr: page_root
        }
    }.render_once().unwrap();

    HttpResponse::Ok().body(page)
}

async fn show_spinner() -> impl Responder {
    HttpResponse::Ok()
        .insert_header(header::ContentType(mime::IMAGE_GIF))
        .body(LOADING_SPINNER_BYTES)
}

async fn show_js() -> impl Responder {
    HttpResponse::Ok()
        .insert_header(header::ContentType(mime::APPLICATION_JAVASCRIPT))
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
    page_root_addr: String,
}


