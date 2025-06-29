# Profiling

To analyse runtime components of a program such as: memory allocation, garbage collection, threads and locks, call stacks, or frequency and duration of specific functions.
It can help you find deadlocks, memory leaks, or inefficient memory allocation, and help inform decisions around resource allocation (ie: CPU or RAM).
[more](https://microsoft.github.io/code-with-engineering-playbook/observability/profiling/)

## FastAPI's Recommendation (can identify IO Bound bottlenecks)

Pyinstrument has to be registed as a middleware in the fastapi application. Accounts for IO wait time in async context. Clear visualization of where async execution is stalled.

```py
# This blocking call in async context
async def get_user(user_id: int):
    # This will show up clearly in pyinstrument as a long bar
    result = requests.get(f"http://slow-api/users/{user_id}")  # BLOCKING!
    return result.json()
```

[profile requests to FastAPI using pyinstrument](https://blog.balthazar-rouberol.com/how-to-profile-a-fastapi-asynchronous-request)

export the json into speedscope (flamegraph viewer) and do the analysis

---

## **Top Choice: py-spy** (can identify CPU Bound bottlenecks)

This is your best bet for production Python profiling:

```sh
# Install
pip install py-spy

# profile from start
py-spy record -o profile.svg -- python -m uvicorn main:app

# Profile running FastAPI service
py-spy record -o profile.svg --pid <fastapi-pid>
```

**Why py-spy rocks for your use case:**

- Works without running in the same process - you pass the PID and it explores the running state externally
- Zero code changes needed (unlike cProfile)
- Minimal performance overhead (~1-5%)
- Generates beautiful flame graphs like those Node.js/Go tweets
- Works in production containers
- Can profile by duration or continuously

## How to use:

```sh
py-spy record -p 1670524 --duration 10 -F -t -f speedscope -o profile_monitoring
```

refer [blog](https://codilime.com/blog/spying-on-python-with-py-spy/).

## **Alternative: Pyflame** (if you need more control)

Pyflame is based on Linux ptrace system calls and can take snapshots without explicit instrumentation, but py-spy is more actively maintained.

## **What You Can Expect:**

### **Flame Graphs Will Show:**

- Hot code paths (wide bars = more CPU time)
- Call stack relationships
- Time spent in your FastAPI routes vs dependencies vs database calls
- Performance bottlenecks across your entire service stack

### **For Company-Wide Framework:**

```python
# middleware.py - Add to all FastAPI apps
import py_spy
from fastapi import Request
import os

class ProfilingMiddleware:
    def __init__(self, app):
        self.app = app

    async def __call__(self, scope, receive, send):
        if scope["type"] == "http":
            # Trigger profiling on specific header/endpoint
            if should_profile(scope):
                # Start py-spy profiling
                pass

        await self.app(scope, receive, send)
```

### **Production Setup:**

```bash
# In your containers
py-spy record -o /tmp/profiles/profile-$(date +%s).svg \
    --duration 30 --rate 100 --pid $(pgrep -f uvicorn)
```

## **Expected Results:**

- **Identification**: Find your actual bottlenecks (often not where you think)
- **Quantification**: See exact CPU time distribution
- **Optimization**: 10-50% performance improvements are common
- **Monitoring**: Continuous profiling in production
- **Comparison**: Before/after deployment comparisons

## **Framework Architecture:**

1. **Profiling trigger**: HTTP header, admin endpoint, or scheduled
2. **Collection**: py-spy generates SVG flame graphs
3. **Storage**: S3/blob storage for flame graph files
4. **Dashboard**: Simple web UI to view/compare profiles
5. **Alerting**: Performance regression detection

The flame graphs will look exactly like those sexy Node.js ones you've seen on Twitter, but for your "crappy Python" FastAPI services. You'll probably discover some surprising bottlenecks and get those sweet performance wins to tweet about.

Want me to show you a complete setup example?
