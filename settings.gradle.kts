rootProject.name = "blog"

include(
    "frontend",
    "frontend:main",
    "frontend:clienthttp",

    "backend",
    "backend:mainservice:webserver",
    "backend:mainservice:httpapi"
)


