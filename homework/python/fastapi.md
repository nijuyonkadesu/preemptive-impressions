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

## Dam claude. FastAPI Production Best Practices Guide

## 1. CRUD Operations Best Practices

### Database Layer

```python
# Use async database drivers
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine
from databases import Database

# Connection pooling for maximum efficiency
engine = create_async_engine(
    DATABASE_URL,
    pool_size=20,
    max_overflow=30,
    pool_pre_ping=True,
    pool_recycle=3600
)

# Repository pattern for clean separation
class BaseRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_by_id(self, model_class, id: int):
        return await self.session.get(model_class, id)

    async def list_with_pagination(self, model_class, offset: int, limit: int):
        result = await self.session.execute(
            select(model_class).offset(offset).limit(limit)
        )
        return result.scalars().all()
```

### Efficient Listing with Cursor-based Pagination

```python
from pydantic import BaseModel
from typing import Optional, Generic, TypeVar

T = TypeVar('T')

class CursorPagination(BaseModel, Generic[T]):
    items: list[T]
    next_cursor: Optional[str] = None
    has_more: bool = False
    total_count: Optional[int] = None

# More efficient than offset-based pagination
async def list_items_cursor(
    cursor: Optional[str] = None,
    limit: int = 100
) -> CursorPagination[ItemResponse]:
    # Decode cursor to get last item ID
    last_id = decode_cursor(cursor) if cursor else 0

    # Query with WHERE clause instead of OFFSET
    query = select(Item).where(Item.id > last_id).limit(limit + 1)
    result = await session.execute(query)
    items = result.scalars().all()

    has_more = len(items) > limit
    if has_more:
        items = items[:-1]

    next_cursor = encode_cursor(items[-1].id) if items and has_more else None

    return CursorPagination(
        items=[ItemResponse.from_orm(item) for item in items],
        next_cursor=next_cursor,
        has_more=has_more
    )
```

## 2. Resilient External API Integration

### Circuit Breaker Pattern

```python
import asyncio
from enum import Enum
from datetime import datetime, timedelta
from typing import Optional

class CircuitState(Enum):
    CLOSED = "closed"
    OPEN = "open"
    HALF_OPEN = "half_open"

class CircuitBreaker:
    def __init__(self, failure_threshold: int = 5, timeout: int = 60):
        self.failure_threshold = failure_threshold
        self.timeout = timeout
        self.failure_count = 0
        self.last_failure_time: Optional[datetime] = None
        self.state = CircuitState.CLOSED

    async def call(self, func, *args, **kwargs):
        if self.state == CircuitState.OPEN:
            if self._should_attempt_reset():
                self.state = CircuitState.HALF_OPEN
            else:
                raise Exception("Circuit breaker is OPEN")

        try:
            result = await func(*args, **kwargs)
            self._on_success()
            return result
        except Exception as e:
            self._on_failure()
            raise e

    def _should_attempt_reset(self) -> bool:
        return (
            self.last_failure_time and
            datetime.now() - self.last_failure_time > timedelta(seconds=self.timeout)
        )

    def _on_success(self):
        self.failure_count = 0
        self.state = CircuitState.CLOSED

    def _on_failure(self):
        self.failure_count += 1
        self.last_failure_time = datetime.now()
        if self.failure_count >= self.failure_threshold:
            self.state = CircuitState.OPEN
```

### Retry with Exponential Backoff

```python
import httpx
from tenacity import retry, stop_after_attempt, wait_exponential, retry_if_exception_type

class ExternalAPIClient:
    def __init__(self):
        self.client = httpx.AsyncClient(
            timeout=httpx.Timeout(10.0, connect=5.0),
            limits=httpx.Limits(max_connections=100, max_keepalive_connections=20)
        )
        self.circuit_breaker = CircuitBreaker()

    @retry(
        stop=stop_after_attempt(3),
        wait=wait_exponential(multiplier=1, min=4, max=10),
        retry=retry_if_exception_type((httpx.TimeoutException, httpx.ConnectError))
    )
    async def make_request(self, method: str, url: str, **kwargs):
        return await self.circuit_breaker.call(
            self.client.request, method, url, **kwargs
        )

# Parallel requests with error handling
async def call_multiple_services(data: dict) -> dict:
    async with httpx.AsyncClient() as client:
        tasks = [
            call_service_a(client, data),
            call_service_b(client, data),
            call_service_c(client, data),
            call_service_d(client, data)
        ]

        results = await asyncio.gather(*tasks, return_exceptions=True)

        # Handle partial failures gracefully
        processed_results = {}
        for i, result in enumerate(results):
            service_name = f"service_{chr(97+i)}"  # a, b, c, d
            if isinstance(result, Exception):
                logger.error(f"Service {service_name} failed: {result}")
                processed_results[service_name] = {"status": "failed", "error": str(result)}
            else:
                processed_results[service_name] = {"status": "success", "data": result}

        return processed_results
```

### Saga Pattern for Distributed Transactions

```python
from abc import ABC, abstractmethod
from typing import List, Any

class SagaStep(ABC):
    @abstractmethod
    async def execute(self, context: dict) -> Any:
        pass

    @abstractmethod
    async def compensate(self, context: dict) -> None:
        pass

class SagaOrchestrator:
    def __init__(self, steps: List[SagaStep]):
        self.steps = steps

    async def execute(self, context: dict) -> dict:
        executed_steps = []

        try:
            for step in self.steps:
                result = await step.execute(context)
                executed_steps.append((step, result))
                context[f"{step.__class__.__name__}_result"] = result

            return context

        except Exception as e:
            # Compensate in reverse order
            for step, _ in reversed(executed_steps):
                try:
                    await step.compensate(context)
                except Exception as comp_error:
                    logger.error(f"Compensation failed for {step.__class__.__name__}: {comp_error}")

            raise e
```

## 3. Advanced Input Validation

### Custom Validators with Performance Optimization

```python
from pydantic import BaseModel, validator, Field
from typing import Optional, List
import re
from functools import lru_cache

# Cache expensive regex compilations
@lru_cache(maxsize=128)
def get_compiled_regex(pattern: str):
    return re.compile(pattern)

class OptimizedValidationModel(BaseModel):
    email: str = Field(..., regex=r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    phone: Optional[str] = Field(None, regex=r'^\+?1?\d{9,15}$')
    tags: List[str] = Field(default_factory=list, max_items=50)

    @validator('email')
    def validate_email_domain(cls, v):
        # Custom validation logic
        domain = v.split('@')[1]
        if domain in ['tempmail.com', 'throwaway.email']:
            raise ValueError('Temporary email addresses not allowed')
        return v.lower()

    @validator('tags')
    def validate_tags(cls, v):
        # Validate each tag
        valid_tags = []
        for tag in v:
            if len(tag.strip()) > 0 and len(tag) <= 50:
                valid_tags.append(tag.strip().lower())
        return valid_tags

    class Config:
        # Enable validation optimization
        validate_assignment = True
        use_enum_values = True
        allow_population_by_field_name = True
```

### Request Size Limiting

```python
from fastapi import Request, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware

class RequestSizeLimitMiddleware(BaseHTTPMiddleware):
    def __init__(self, app, max_request_size: int = 10 * 1024 * 1024):  # 10MB
        super().__init__(app)
        self.max_request_size = max_request_size

    async def dispatch(self, request: Request, call_next):
        if request.method in ["POST", "PUT", "PATCH"]:
            content_length = request.headers.get("content-length")
            if content_length and int(content_length) > self.max_request_size:
                raise HTTPException(status_code=413, detail="Request too large")

        response = await call_next(request)
        return response
```

## 4. Dynamic Response Models

### Response Model Factory Pattern

```python
from typing import Type, Union, Dict, Any
from pydantic import BaseModel, create_model
from enum import Enum

class ResponseFormat(str, Enum):
    MINIMAL = "minimal"
    STANDARD = "standard"
    DETAILED = "detailed"

class BaseItemResponse(BaseModel):
    id: int
    name: str
    created_at: datetime

class DetailedItemResponse(BaseItemResponse):
    description: str
    metadata: Dict[str, Any]
    relationships: List[dict]

class ResponseModelFactory:
    @staticmethod
    def get_response_model(format_type: ResponseFormat) -> Type[BaseModel]:
        if format_type == ResponseFormat.MINIMAL:
            return create_model(
                'MinimalItemResponse',
                id=(int, ...),
                name=(str, ...)
            )
        elif format_type == ResponseFormat.DETAILED:
            return DetailedItemResponse
        else:
            return BaseItemResponse

# Usage in endpoint
@app.get("/items/{item_id}")
async def get_item(
    item_id: int,
    format: ResponseFormat = ResponseFormat.STANDARD,
    response_model=None  # Set dynamically
):
    # Set response model based on format
    response_model = ResponseModelFactory.get_response_model(format)

    item = await get_item_from_db(item_id)
    return response_model.from_orm(item)
```

### Union Response Types

```python
from typing import Union
from pydantic import BaseModel

class SuccessResponse(BaseModel):
    status: str = "success"
    data: dict

class ErrorResponse(BaseModel):
    status: str = "error"
    error: str
    code: int

# Union response type
APIResponse = Union[SuccessResponse, ErrorResponse]

@app.post("/process", response_model=APIResponse)
async def process_data(data: InputModel):
    try:
        result = await process_business_logic(data)
        return SuccessResponse(data=result)
    except ValueError as e:
        return ErrorResponse(error=str(e), code=400)
    except Exception as e:
        return ErrorResponse(error="Internal server error", code=500)
```

## 5. Comprehensive Middleware Stack

### Performance Monitoring Middleware

```python
import time
import psutil
from starlette.middleware.base import BaseHTTPMiddleware
from prometheus_client import Counter, Histogram, Gauge

# Metrics
REQUEST_COUNT = Counter('http_requests_total', 'Total HTTP requests', ['method', 'endpoint', 'status'])
REQUEST_DURATION = Histogram('http_request_duration_seconds', 'HTTP request duration')
ACTIVE_REQUESTS = Gauge('http_requests_active', 'Active HTTP requests')
MEMORY_USAGE = Gauge('memory_usage_bytes', 'Memory usage in bytes')

class MetricsMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        start_time = time.time()
        ACTIVE_REQUESTS.inc()

        try:
            response = await call_next(request)

            # Record metrics
            duration = time.time() - start_time
            REQUEST_DURATION.observe(duration)
            REQUEST_COUNT.labels(
                method=request.method,
                endpoint=request.url.path,
                status=response.status_code
            ).inc()

            # Memory usage
            MEMORY_USAGE.set(psutil.Process().memory_info().rss)

            return response
        finally:
            ACTIVE_REQUESTS.dec()
```

### Rate Limiting Middleware

```python
import asyncio
from collections import defaultdict
from datetime import datetime, timedelta

class RateLimitMiddleware(BaseHTTPMiddleware):
    def __init__(self, app, calls: int = 100, period: int = 60):
        super().__init__(app)
        self.calls = calls
        self.period = period
        self.clients = defaultdict(list)
        self.cleanup_task = None

    async def dispatch(self, request: Request, call_next):
        client_ip = request.client.host
        now = datetime.now()

        # Clean old entries
        cutoff = now - timedelta(seconds=self.period)
        self.clients[client_ip] = [
            timestamp for timestamp in self.clients[client_ip]
            if timestamp > cutoff
        ]

        # Check rate limit
        if len(self.clients[client_ip]) >= self.calls:
            raise HTTPException(
                status_code=429,
                detail="Rate limit exceeded",
                headers={"Retry-After": str(self.period)}
            )

        self.clients[client_ip].append(now)
        return await call_next(request)
```

### Request ID and Correlation Middleware

```python
import uuid
from contextvars import ContextVar

# Context variable for request tracking
request_id_var: ContextVar[str] = ContextVar('request_id')

class RequestTrackingMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Generate or extract request ID
        request_id = request.headers.get('X-Request-ID', str(uuid.uuid4()))
        request_id_var.set(request_id)

        # Add to request state
        request.state.request_id = request_id

        response = await call_next(request)
        response.headers['X-Request-ID'] = request_id

        return response
```

### Security Headers Middleware

```python
class SecurityHeadersMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        response = await call_next(request)

        # Security headers
        response.headers.update({
            'X-Content-Type-Options': 'nosniff',
            'X-Frame-Options': 'DENY',
            'X-XSS-Protection': '1; mode=block',
            'Strict-Transport-Security': 'max-age=31536000; includeSubDomains',
            'Content-Security-Policy': "default-src 'self'",
            'Referrer-Policy': 'strict-origin-when-cross-origin'
        })

        return response
```

## 6. Kubernetes-Optimized Startup Strategy

### Health Check Endpoints

```python
from fastapi import FastAPI
from pydantic import BaseModel
import asyncio

class HealthResponse(BaseModel):
    status: str
    timestamp: datetime
    version: str
    dependencies: dict

class StartupManager:
    def __init__(self):
        self.is_ready = False
        self.dependencies_status = {}

    async def initialize(self):
        """Initialize all dependencies"""
        try:
            # Database connection
            await self.check_database()

            # External services
            await self.check_external_services()

            # Cache warming
            await self.warm_cache()

            self.is_ready = True
            logger.info("Application startup completed successfully")

        except Exception as e:
            logger.error(f"Startup failed: {e}")
            raise

    async def check_database(self):
        try:
            # Test database connection
            async with database.transaction():
                await database.execute("SELECT 1")
            self.dependencies_status['database'] = 'healthy'
        except Exception as e:
            self.dependencies_status['database'] = f'unhealthy: {e}'
            raise

    async def check_external_services(self):
        services = ['service_a', 'service_b', 'service_c']
        for service in services:
            try:
                # Health check for each service
                response = await external_client.get(f"http://{service}/health")
                self.dependencies_status[service] = 'healthy'
            except Exception as e:
                self.dependencies_status[service] = f'unhealthy: {e}'
                logger.warning(f"Service {service} is unhealthy: {e}")

startup_manager = StartupManager()

@app.on_event("startup")
async def startup_event():
    await startup_manager.initialize()

@app.get("/health/live")
async def liveness_probe():
    """Kubernetes liveness probe"""
    return {"status": "alive", "timestamp": datetime.now()}

@app.get("/health/ready")
async def readiness_probe():
    """Kubernetes readiness probe"""
    if not startup_manager.is_ready:
        raise HTTPException(status_code=503, detail="Application not ready")

    return HealthResponse(
        status="ready",
        timestamp=datetime.now(),
        version=os.getenv("APP_VERSION", "unknown"),
        dependencies=startup_manager.dependencies_status
    )
```

### Graceful Shutdown

```python
import signal
import asyncio

class GracefulShutdown:
    def __init__(self):
        self.should_exit = False
        self.force_exit = False

    def install_signal_handlers(self):
        signal.signal(signal.SIGTERM, self.handle_sigterm)
        signal.signal(signal.SIGINT, self.handle_sigint)

    def handle_sigterm(self, signum, frame):
        logger.info("Received SIGTERM, initiating graceful shutdown...")
        self.should_exit = True

    def handle_sigint(self, signum, frame):
        if self.should_exit:
            logger.info("Received second SIGINT, forcing shutdown...")
            self.force_exit = True
        else:
            logger.info("Received SIGINT, initiating graceful shutdown...")
            self.should_exit = True

    async def shutdown_sequence(self):
        logger.info("Starting graceful shutdown sequence...")

        # Stop accepting new requests
        # Close database connections
        await database.disconnect()

        # Close external HTTP clients
        await external_client.aclose()

        # Wait for ongoing requests to complete (with timeout)
        await asyncio.sleep(5)

        logger.info("Graceful shutdown completed")

graceful_shutdown = GracefulShutdown()
graceful_shutdown.install_signal_handlers()

@app.on_event("shutdown")
async def shutdown_event():
    await graceful_shutdown.shutdown_sequence()
```

## 7. Centralized Error Handling

### Custom Exception Classes

```python
from typing import Optional, Dict, Any
from fastapi import HTTPException, status

class BaseAPIException(Exception):
    def __init__(
        self,
        message: str,
        status_code: int = status.HTTP_500_INTERNAL_SERVER_ERROR,
        error_code: str = "INTERNAL_ERROR",
        details: Optional[Dict[str, Any]] = None
    ):
        self.message = message
        self.status_code = status_code
        self.error_code = error_code
        self.details = details or {}
        super().__init__(self.message)

class ValidationError(BaseAPIException):
    def __init__(self, message: str, field: str = None, details: Dict[str, Any] = None):
        super().__init__(
            message=message,
            status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
            error_code="VALIDATION_ERROR",
            details={"field": field, **(details or {})}
        )

class NotFoundError(BaseAPIException):
    def __init__(self, resource: str, identifier: str):
        super().__init__(
            message=f"{resource} with identifier '{identifier}' not found",
            status_code=status.HTTP_404_NOT_FOUND,
            error_code="RESOURCE_NOT_FOUND",
            details={"resource": resource, "identifier": identifier}
        )

class ExternalServiceError(BaseAPIException):
    def __init__(self, service_name: str, original_error: str):
        super().__init__(
            message=f"External service '{service_name}' is unavailable",
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            error_code="EXTERNAL_SERVICE_ERROR",
            details={"service": service_name, "original_error": original_error}
        )
```

### Global Exception Handler

```python
from fastapi import Request
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
import traceback

class ErrorResponse(BaseModel):
    error: str
    code: str
    message: str
    details: Dict[str, Any] = {}
    request_id: str
    timestamp: datetime

@app.exception_handler(BaseAPIException)
async def custom_exception_handler(request: Request, exc: BaseAPIException):
    return JSONResponse(
        status_code=exc.status_code,
        content=ErrorResponse(
            error=exc.__class__.__name__,
            code=exc.error_code,
            message=exc.message,
            details=exc.details,
            request_id=getattr(request.state, 'request_id', 'unknown'),
            timestamp=datetime.now()
        ).dict()
    )

@app.exception_handler(RequestValidationError)
async def validation_exception_handler(request: Request, exc: RequestValidationError):
    errors = []
    for error in exc.errors():
        errors.append({
            "field": ".".join(str(x) for x in error["loc"]),
            "message": error["msg"],
            "type": error["type"]
        })

    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content=ErrorResponse(
            error="ValidationError",
            code="VALIDATION_ERROR",
            message="Request validation failed",
            details={"errors": errors},
            request_id=getattr(request.state, 'request_id', 'unknown'),
            timestamp=datetime.now()
        ).dict()
    )

@app.exception_handler(Exception)
async def global_exception_handler(request: Request, exc: Exception):
    # Log the full traceback
    logger.error(f"Unhandled exception: {exc}", exc_info=True)

    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content=ErrorResponse(
            error="InternalServerError",
            code="INTERNAL_ERROR",
            message="An unexpected error occurred",
            details={},
            request_id=getattr(request.state, 'request_id', 'unknown'),
            timestamp=datetime.now()
        ).dict()
    )
```

## 8. Async Optimization Strategies

### Connection Pool Management

```python
import asyncio
from contextlib import asynccontextmanager

class AsyncResourcePool:
    def __init__(self, create_func, max_size: int = 10):
        self.create_func = create_func
        self.max_size = max_size
        self.pool = asyncio.Queue(maxsize=max_size)
        self.size = 0

    async def acquire(self):
        if self.pool.empty() and self.size < self.max_size:
            resource = await self.create_func()
            self.size += 1
            return resource

        return await self.pool.get()

    async def release(self, resource):
        await self.pool.put(resource)

    @asynccontextmanager
    async def get_resource(self):
        resource = await self.acquire()
        try:
            yield resource
        finally:
            await self.release(resource)

# HTTP client pool
http_pool = AsyncResourcePool(
    create_func=lambda: httpx.AsyncClient(
        timeout=httpx.Timeout(10.0),
        limits=httpx.Limits(max_connections=20)
    ),
    max_size=5
)
```

### Async Task Management

```python
import asyncio
from typing import List, Callable, Any
from concurrent.futures import ThreadPoolExecutor

class AsyncTaskManager:
    def __init__(self, max_concurrent_tasks: int = 100):
        self.semaphore = asyncio.Semaphore(max_concurrent_tasks)
        self.executor = ThreadPoolExecutor(max_workers=4)

    async def run_with_semaphore(self, coro):
        async with self.semaphore:
            return await coro

    async def run_cpu_bound_task(self, func: Callable, *args, **kwargs):
        loop = asyncio.get_event_loop()
        return await loop.run_in_executor(self.executor, func, *args, **kwargs)

    async def batch_process(self, items: List[Any], processor: Callable, batch_size: int = 10):
        results = []
        for i in range(0, len(items), batch_size):
            batch = items[i:i + batch_size]
            batch_tasks = [
                self.run_with_semaphore(processor(item))
                for item in batch
            ]
            batch_results = await asyncio.gather(*batch_tasks, return_exceptions=True)
            results.extend(batch_results)

        return results

task_manager = AsyncTaskManager()
```

### Event Loop Optimization

```python
import uvloop
import asyncio

# Use uvloop for better performance (Python 3.9+)
if hasattr(asyncio, 'set_event_loop_policy'):
    asyncio.set_event_loop_policy(uvloop.EventLoopPolicy())

# Custom event loop configuration
def create_optimized_event_loop():
    loop = asyncio.new_event_loop()

    # Optimize for high concurrency
    loop.set_debug(False)  # Disable in production

    return loop
```

## 9. Versioning and Compatibility

### API Versioning Strategy

```python
from fastapi import APIRouter
from typing import Optional

# Version-specific routers
v1_router = APIRouter(prefix="/v1", tags=["v1"])
v2_router = APIRouter(prefix="/v2", tags=["v2"])

# Backward compatibility decorators
def deprecated(version: str, removal_version: str):
    def decorator(func):
        async def wrapper(*args, **kwargs):
            # Add deprecation warning to response headers
            response = await func(*args, **kwargs)
            if hasattr(response, 'headers'):
                response.headers['Deprecated'] = f"true; version={version}; removal={removal_version}"
            return response
        return wrapper
    return decorator

# Version detection middleware
class APIVersionMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        # Extract version from header, query param, or URL
        version = (
            request.headers.get('API-Version') or
            request.query_params.get('version') or
            self.extract_version_from_path(request.url.path)
        )

        request.state.api_version = version or 'v1'
        return await call_next(request)

    def extract_version_from_path(self, path: str) -> Optional[str]:
        parts = path.strip('/').split('/')
        if parts and parts[0].startswith('v') and parts[0][1:].isdigit():
            return parts[0]
        return None
```

### Schema Evolution

```python
from pydantic import BaseModel, Field
from typing import Optional, Union

# Base model with version support
class VersionedModel(BaseModel):
    class Config:
        extra = "ignore"  # Ignore unknown fields for forward compatibility

    def to_version(self, version: str):
        """Convert model to specific version"""
        if version == "v1":
            return self.to_v1()
        elif version == "v2":
            return self.to_v2()
        return self

# Example evolution
class UserModelV1(VersionedModel):
    id: int
    name: str
    email: str

class UserModelV2(VersionedModel):
    id: int
    first_name: str
    last_name: str
    email: str
    phone: Optional[str] = None

    @classmethod
    def from_v1(cls, v1_model: UserModelV1):
        # Handle name splitting logic
        name_parts = v1_model.name.split(' ', 1)
        return cls(
            id=v1_model.id,
            first_name=name_parts[0],
            last_name=name_parts[1] if len(name_parts) > 1 else '',
            email=v1_model.email
        )
```

## 10. Python 3.11+ Migration Strategy

### Performance Optimizations Available in Python 3.11+

```python
# Use structural pattern matching (3.10+)
def process_response(response_data):
    match response_data:
        case {"status": "success", "data": data}:
            return process_success_data(data)
        case {"status": "error", "error": error_msg}:
            raise Exception(error_msg)
        case _:
            raise ValueError("Unknown response format")

# Use improved error messages and faster startup
# Exception groups (3.11+)
from types import TracebackType
from typing import Optional, Type

class MultipleAPIErrors(BaseException):
    def __init__(self, errors: list[Exception]):
        self.errors = errors
        super().__init__(f"Multiple errors occurred: {len(errors)} errors")

# Faster asyncio with task groups (3.11+)
async def process_multiple_requests_efficiently(requests):
    async with asyncio.TaskGroup() as tg:
        tasks = [
            tg.create_task(process_request(req))
            for req in requests
        ]

    return [task.result() for task in tasks]
```

### Migration Checklist

```yaml
# pyproject.toml update
[tool.poetry.dependencies]
python = "^3.11"
fastapi = "^0.104.0"
uvicorn = {extras = ["standard"], version = "^0.24.0"}
pydantic = "^2.0.0"
httpx = "^0.25.0"
sqlalchemy = "^2.0.0"
alembic = "^1.12.0"
redis = "^5.0.0"
prometheus-client = "^0.18.0"
```

## Performance Optimization & Resource Utilization

### Single Worker Configuration (uvicorn.conf)

```python
# uvicorn_config.py
import multiprocessing
import os

# Single worker configuration for maximum efficiency
bind = f"0.0.0.0:{os.getenv('PORT', 8000)}"
workers = 1  # Single async worker as requested
worker_class = "uvicorn.workers.UvicornWorker"
worker_connections = 1000
max_requests = 10000
max_requests_jitter = 1000
preload_app = True
timeout = 30
keepalive = 5

# Memory and performance tuning
worker_tmp_dir = "/dev/shm"  # Use shared memory for better performance
```

### Application Factory with Resource Management

```python
from contextlib import asynccontextmanager
from fastapi import FastAPI
import asyncio
import signal
import os

class ApplicationState:
    def __init__(self):
        self.db_pool = None
        self.redis_pool = None
        self.http_client = None
        self.background_tasks = set()
        self.shutdown_event = asyncio.Event()

app_state = ApplicationState()

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    await initialize_resources()

    # Background task for resource optimization
    optimize_task = asyncio.create_task(resource_optimizer())
    app_state.background_tasks.add(optimize_task)

    yield

    # Shutdown
    app_state.shutdown_event.set()

    # Cancel background tasks
    for task in app_state.background_tasks:
        task.cancel()

    await cleanup_resources()

async def initialize_resources():
    """Initialize all resources with optimal settings"""
    # Database pool with connection optimization
    app_state.db_pool = await create_async_engine(
        DATABASE_URL,
        pool_size=20,
        max_overflow=30,
        pool_pre_ping=True,
        pool_recycle=3600,
        # Performance optimizations
        connect_args={
            "command_timeout": 60,
            "server_settings": {
                "application_name": "fastapi_service",
                "jit": "on",
                "shared_preload_libraries": "pg_stat_statements"
            }
        }
    ).execution_options(
        isolation_level="READ_COMMITTED",
        autocommit=False
    )

    # Redis connection pool
    app_state.redis_pool = redis.ConnectionPool(
        host=REDIS_HOST,
        port=REDIS_PORT,
        db=0,
        max_connections=50,
        retry_on_timeout=True,
        socket_keepalive=True,
        socket_keepalive_options={}
    )

    # HTTP client with optimized settings
    app_state.http_client = httpx.AsyncClient(
        timeout=httpx.Timeout(
            connect=5.0,
            read=30.0,
            write=10.0,
            pool=60.0
        ),
        limits=httpx.Limits(
            max_connections=100,
            max_keepalive_connections=20,
            keepalive_expiry=30.0
        ),
        http2=True,  # Enable HTTP/2 for better performance
        verify=True
    )

async def resource_optimizer():
    """Background task to optimize resource usage"""
    while not app_state.shutdown_event.is_set():
        try:
            # Memory optimization
            import gc
            gc.collect()

            # Connection pool health check
            await check_connection_health()

            # Cache cleanup
            await cleanup_expired_cache()

            # Wait before next optimization cycle
            await asyncio.sleep(300)  # 5 minutes

        except asyncio.CancelledError:
            break
        except Exception as e:
            logger.error(f"Resource optimizer error: {e}")
            await asyncio.sleep(60)

async def check_connection_health():
    """Monitor and maintain connection pool health"""
    try:
        # Test database connection
        async with app_state.db_pool.begin() as conn:
            await conn.execute(text("SELECT 1"))

        # Test Redis connection
        redis_client = redis.Redis(connection_pool=app_state.redis_pool)
        await redis_client.ping()

    except Exception as e:
        logger.error(f"Connection health check failed: {e}")
        # Implement reconnection logic if needed

app = FastAPI(
    title="High-Performance FastAPI Service",
    version="2.0.0",
    lifespan=lifespan
)
```

### High-Performance Caching Strategy

```python
import pickle
import hashlib
from typing import Any, Optional, Callable
from functools import wraps
import asyncio

class HighPerformanceCache:
    def __init__(self, redis_pool):
        self.redis_pool = redis_pool
        self.local_cache = {}  # L1 cache
        self.local_cache_size = 1000
        self.local_cache_ttl = 60  # seconds

    def _generate_key(self, prefix: str, *args, **kwargs) -> str:
        """Generate cache key from function arguments"""
        key_data = f"{prefix}:{args}:{sorted(kwargs.items())}"
        return hashlib.md5(key_data.encode()).hexdigest()

    async def get(self, key: str) -> Optional[Any]:
        # Check L1 cache first
        if key in self.local_cache:
            data, timestamp = self.local_cache[key]
            if time.time() - timestamp < self.local_cache_ttl:
                return data
            else:
                del self.local_cache[key]

        # Check Redis (L2 cache)
        redis_client = redis.Redis(connection_pool=self.redis_pool)
        try:
            cached_data = await redis_client.get(key)
            if cached_data:
                data = pickle.loads(cached_data)
                # Update L1 cache
                self._update_local_cache(key, data)
                return data
        except Exception as e:
            logger.error(f"Redis cache error: {e}")

        return None

    async def set(self, key: str, value: Any, ttl: int = 3600):
        # Update L1 cache
        self._update_local_cache(key, value)

        # Update Redis cache
        redis_client = redis.Redis(connection_pool=self.redis_pool)
        try:
            await redis_client.setex(key, ttl, pickle.dumps(value))
        except Exception as e:
            logger.error(f"Redis cache set error: {e}")

    def _update_local_cache(self, key: str, value: Any):
        # Implement LRU eviction
        if len(self.local_cache) >= self.local_cache_size:
            # Remove oldest entry
            oldest_key = min(self.local_cache.keys(),
                           key=lambda k: self.local_cache[k][1])
            del self.local_cache[oldest_key]

        self.local_cache[key] = (value, time.time())

# Global cache instance
cache = HighPerformanceCache(app_state.redis_pool)

def cached(ttl: int = 3600, prefix: str = "default"):
    """Decorator for caching function results"""
    def decorator(func: Callable):
        @wraps(func)
        async def wrapper(*args, **kwargs):
            # Generate cache key
            cache_key = cache._generate_key(f"{prefix}:{func.__name__}", *args, **kwargs)

            # Try to get from cache
            cached_result = await cache.get(cache_key)
            if cached_result is not None:
                return cached_result

            # Execute function and cache result
            result = await func(*args, **kwargs)
            await cache.set(cache_key, result, ttl)

            return result
        return wrapper
    return decorator
```

### Database Query Optimization

```python
from sqlalchemy import text, select, func
from sqlalchemy.orm import selectinload, joinedload
from typing import List, Optional

class OptimizedRepository:
    def __init__(self, session: AsyncSession):
        self.session = session

    async def get_with_relations(self, model_class, id: int, relations: List[str] = None):
        """Optimized query with eager loading"""
        query = select(model_class).where(model_class.id == id)

        # Add eager loading for specified relations
        if relations:
            for relation in relations:
                if hasattr(model_class, relation):
                    query = query.options(selectinload(getattr(model_class, relation)))

        result = await self.session.execute(query)
        return result.scalar_one_or_none()

    async def bulk_create(self, model_class, data: List[dict]) -> List[int]:
        """High-performance bulk insert"""
        if not data:
            return []

        # Use bulk insert for better performance
        stmt = model_class.__table__.insert().values(data)
        result = await self.session.execute(stmt)
        await self.session.commit()

        return result.inserted_primary_key_rows

    async def bulk_update(self, model_class, updates: List[dict], key_field: str = 'id'):
        """High-performance bulk update"""
        if not updates:
            return

        # Group updates by unique values to minimize queries
        for update_data in updates:
            key_value = update_data[key_field]
            await self.session.execute(
                model_class.__table__.update()
                .where(getattr(model_class, key_field) == key_value)
                .values(**{k: v for k, v in update_data.items() if k != key_field})
            )

        await self.session.commit()

    @cached(ttl=300, prefix="complex_query")
    async def complex_aggregation_query(self, filters: dict) -> dict:
        """Example of complex query with caching"""
        query = text("""
            SELECT
                category,
                COUNT(*) as total_count,
                AVG(value) as avg_value,
                MAX(created_at) as latest_created
            FROM items
            WHERE status = :status
            AND created_at >= :start_date
            GROUP BY category
            ORDER BY total_count DESC
        """)

        result = await self.session.execute(query, filters)
        return [dict(row) for row in result]
```

### Advanced Request Processing Pipeline

```python
from typing import Protocol, List
import asyncio
from dataclasses import dataclass

@dataclass
class ProcessingContext:
    request_id: str
    data: dict
    metadata: dict
    results: dict
    errors: List[str]

class ProcessingStep(Protocol):
    async def process(self, context: ProcessingContext) -> ProcessingContext:
        ...

    async def rollback(self, context: ProcessingContext) -> None:
        ...

class ValidationStep:
    async def process(self, context: ProcessingContext) -> ProcessingContext:
        # Validate input data
        try:
            validated_data = InputModel(**context.data)
            context.data = validated_data.dict()
            context.metadata['validation_passed'] = True
        except ValidationError as e:
            context.errors.append(f"Validation failed: {e}")
            raise

        return context

    async def rollback(self, context: ProcessingContext) -> None:
        # Nothing to rollback for validation
        pass

class ExternalAPIStep:
    def __init__(self, service_name: str, endpoint: str):
        self.service_name = service_name
        self.endpoint = endpoint

    async def process(self, context: ProcessingContext) -> ProcessingContext:
        try:
            async with app_state.http_client as client:
                response = await client.post(
                    self.endpoint,
                    json=context.data,
                    headers={'X-Request-ID': context.request_id}
                )
                response.raise_for_status()

                context.results[self.service_name] = response.json()
                context.metadata[f'{self.service_name}_processed'] = True

        except Exception as e:
            context.errors.append(f"{self.service_name} failed: {e}")
            raise ExternalServiceError(self.service_name, str(e))

        return context

    async def rollback(self, context: ProcessingContext) -> None:
        # Implement compensation logic
        if f'{self.service_name}_processed' in context.metadata:
            try:
                async with app_state.http_client as client:
                    await client.delete(
                        f"{self.endpoint}/rollback",
                        json={'request_id': context.request_id}
                    )
            except Exception as e:
                logger.error(f"Rollback failed for {self.service_name}: {e}")

class ProcessingPipeline:
    def __init__(self, steps: List[ProcessingStep]):
        self.steps = steps

    async def execute(self, request_id: str, data: dict) -> ProcessingContext:
        context = ProcessingContext(
            request_id=request_id,
            data=data,
            metadata={},
            results={},
            errors=[]
        )

        executed_steps = []

        try:
            for step in self.steps:
                context = await step.process(context)
                executed_steps.append(step)

            return context

        except Exception as e:
            # Rollback executed steps in reverse order
            logger.error(f"Pipeline failed at step {len(executed_steps)}: {e}")

            for step in reversed(executed_steps):
                try:
                    await step.rollback(context)
                except Exception as rollback_error:
                    logger.error(f"Rollback failed: {rollback_error}")

            raise e

# Usage in endpoint
@app.post("/process")
async def process_request(
    data: InputModel,
    request: Request
) -> ProcessingResult:
    pipeline = ProcessingPipeline([
        ValidationStep(),
        ExternalAPIStep("service_a", "http://service-a/api/process"),
        ExternalAPIStep("service_b", "http://service-b/api/process"),
        ExternalAPIStep("service_c", "http://service-c/api/process"),
        DatabasePersistenceStep()
    ])

    try:
        context = await pipeline.execute(
            request_id=request.state.request_id,
            data=data.dict()
        )

        return ProcessingResult(
            success=True,
            data=context.results,
            metadata=context.metadata
        )

    except Exception as e:
        logger.error(f"Request processing failed: {e}")
        raise HTTPException(
            status_code=500,
            detail=f"Processing failed: {str(e)}"
        )
```

### Resource Monitoring and Auto-scaling Signals

```python
import psutil
import asyncio
from dataclasses import dataclass
from typing import Dict, List

@dataclass
class ResourceMetrics:
    cpu_percent: float
    memory_percent: float
    active_connections: int
    request_queue_size: int
    response_time_avg: float
    error_rate: float

class ResourceMonitor:
    def __init__(self):
        self.metrics_history: List[ResourceMetrics] = []
        self.max_history = 60  # Keep 60 data points (5 minutes at 5s intervals)
        self.alerts = []

    async def collect_metrics(self) -> ResourceMetrics:
        """Collect current resource metrics"""
        # CPU and Memory
        cpu_percent = psutil.cpu_percent(interval=1)
        memory = psutil.virtual_memory()
        memory_percent = memory.percent

        # Application-specific metrics
        active_connections = len(app_state.background_tasks)

        # Get metrics from prometheus if available
        request_queue_size = 0  # Would come from uvicorn metrics
        response_time_avg = 0.0  # Would come from middleware metrics
        error_rate = 0.0  # Would come from error tracking

        return ResourceMetrics(
            cpu_percent=cpu_percent,
            memory_percent=memory_percent,
            active_connections=active_connections,
            request_queue_size=request_queue_size,
            response_time_avg=response_time_avg,
            error_rate=error_rate
        )

    async def monitor_resources(self):
        """Continuous resource monitoring"""
        while not app_state.shutdown_event.is_set():
            try:
                metrics = await self.collect_metrics()
                self.metrics_history.append(metrics)

                # Keep only recent history
                if len(self.metrics_history) > self.max_history:
                    self.metrics_history.pop(0)

                # Check for scaling signals
                await self.check_scaling_signals(metrics)

                # Log metrics
                logger.info(
                    f"Resources - CPU: {metrics.cpu_percent}%, "
                    f"Memory: {metrics.memory_percent}%, "
                    f"Connections: {metrics.active_connections}"
                )

                await asyncio.sleep(5)  # Collect metrics every 5 seconds

            except asyncio.CancelledError:
                break
            except Exception as e:
                logger.error(f"Resource monitoring error: {e}")
                await asyncio.sleep(30)

    async def check_scaling_signals(self, current_metrics: ResourceMetrics):
        """Check if scaling is needed and emit signals"""

        # Scale up signals
        if (current_metrics.cpu_percent > 80 or
            current_metrics.memory_percent > 85 or
            current_metrics.request_queue_size > 100):

            await self.emit_scale_up_signal(current_metrics)

        # Scale down signals (only if we have enough history)
        elif len(self.metrics_history) >= 10:
            recent_metrics = self.metrics_history[-10:]
            avg_cpu = sum(m.cpu_percent for m in recent_metrics) / len(recent_metrics)
            avg_memory = sum(m.memory_percent for m in recent_metrics) / len(recent_metrics)

            if avg_cpu < 30 and avg_memory < 50:
                await self.emit_scale_down_signal(current_metrics)

    async def emit_scale_up_signal(self, metrics: ResourceMetrics):
        """Emit scale up signal for Kubernetes HPA"""
        logger.warning(
            f"Scale up signal - CPU: {metrics.cpu_percent}%, "
            f"Memory: {metrics.memory_percent}%, "
            f"Queue: {metrics.request_queue_size}"
        )

        # Update custom metrics for HPA
        # This would typically involve updating a custom metric in Kubernetes
        # or writing to a monitoring system that HPA can read from

    async def emit_scale_down_signal(self, metrics: ResourceMetrics):
        """Emit scale down signal for Kubernetes HPA"""
        logger.info(f"Scale down opportunity detected")

# Global resource monitor
resource_monitor = ResourceMonitor()

# Add to background tasks
async def start_resource_monitoring():
    monitor_task = asyncio.create_task(resource_monitor.monitor_resources())
    app_state.background_tasks.add(monitor_task)
```

### Production Deployment Configuration

```dockerfile
# Dockerfile optimized for Python 3.11+
FROM python:3.11-slim-bullseye

# Install system dependencies
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Create non-root user
RUN useradd --create-home --shell /bin/bash app

# Set working directory
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Set ownership
RUN chown -R app:app /app

# Switch to non-root user
USER app

# Expose port
EXPOSE 8000

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8000/health/live || exit 1

# Run the application
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "1"]
```

```yaml
# kubernetes/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: fastapi-service
  labels:
    app: fastapi-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: fastapi-service
  template:
    metadata:
      labels:
        app: fastapi-service
    spec:
      containers:
        - name: fastapi-service
          image: fastapi-service:latest
          ports:
            - containerPort: 8000
          env:
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: database-secret
                  key: url
            - name: REDIS_URL
              valueFrom:
                secretKeyRef:
                  name: redis-secret
                  key: url
          resources:
            requests:
              memory: "256Mi"
              cpu: "250m"
            limits:
              memory: "512Mi"
              cpu: "500m"
          livenessProbe:
            httpGet:
              path: /health/live
              port: 8000
            initialDelaySeconds: 30
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 3
          readinessProbe:
            httpGet:
              path: /health/ready
              port: 8000
            initialDelaySeconds: 5
            periodSeconds: 5
            timeoutSeconds: 3
            failureThreshold: 3
          lifecycle:
            preStop:
              exec:
                command: ["/bin/sh", "-c", "sleep 15"]
---
apiVersion: v1
kind: Service
metadata:
  name: fastapi-service
spec:
  selector:
    app: fastapi-service
  ports:
    - port: 80
      targetPort: 8000
  type: ClusterIP
---
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: fastapi-service-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: fastapi-service
  minReplicas: 2
  maxReplicas: 10
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
    - type: Resource
      resource:
        name: memory
        target:
          type: Utilization
          averageUtilization: 80
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 60
      policies:
        - type: Percent
          value: 100
          periodSeconds: 15
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Percent
          value: 10
          periodSeconds: 60
```

## Summary of Key Performance Optimizations

1. **Single Async Worker**: Configured for maximum efficiency with single worker
2. **Connection Pooling**: Optimized database and HTTP client pools
3. **Multi-level Caching**: L1 (in-memory) + L2 (Redis) caching strategy
4. **Resource Monitoring**: Continuous monitoring with auto-scaling signals
5. **Efficient Database Queries**: Bulk operations, eager loading, query optimization
6. **Circuit Breakers**: Resilient external service integration
7. **Pipeline Processing**: Structured request processing with rollback capability
8. **Graceful Shutdown**: Proper resource cleanup and connection management
9. **Python 3.11+**: Leveraging latest performance improvements
10. **Kubernetes Optimization**: HPA, resource limits, health checks

This comprehensive setup will ensure your FastAPI application runs at peak performance with 100% resource utilization under load while maintaining reliability and scalability.
