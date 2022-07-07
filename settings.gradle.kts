rootProject.name = "blog"

include(
    "frontend",
    "frontend:main",
    "frontend:httpapi",

    "backend",
    "backend:mainservice:webserver",
    "backend:mainservice:httpapi"
)


