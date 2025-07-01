Things you can and cannot tolerate in FastAPI.

## Usually,

1. basic CRUDL. (where listing is a simple)
2. invokes 4-8 API internal service API calls. (mix of patch, post, list, delete)
3. Input parsing and validation (pydantic models)
4. Response validation (pydantic model)
   - switch between different response model based on the query for certain special APIs.
5. common middlewares for logging for observability.
   - except auth, what middlewares can be possible to be added?.
6. startup script (which is the right place to put this in a kubernetes deployment with multiple replicas run all at the same time?)
7. raise informative and self descriptive error messages in a centralized manner.
8. need to respect async
9. forward and backward compatibility.
10. Dockerfile (proper two staged build)
11. using python 3.9, would love to upgrade python (eg 3.11 which offers better performance ootb)
12. CI-CD
13. k8s healthchecks

## Manual

- [DI on service / repositories using Annotated type](https://blog.dotcs.me/posts/fastapi-dependency-injection-x-layers)

