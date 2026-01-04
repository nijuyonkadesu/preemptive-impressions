Just a breakdown of internals of opensource redis python client package.

Project LOC: ~155k

# Basic stuffs:

- Credentials management & initialization

# Connection management

- SSL vs Normal unix connection
- AbstractConnection: [base]

# Notifications

- Maintenance notifications
- Keyspace notifications
- pub/sub listener

# Async operations

- simple url & query constructions
```py
def extract_expire_flags(
    ex: Optional[ExpiryT] = None,
    px: Optional[ExpiryT] = None,
    exat: Optional[AbsExpiryT] = None,
    pxat: Optional[AbsExpiryT] = None,
```
- other resilient configurations

# Pipelines

A way to run multiple commands in a single roundtrip in redis.
(MULTI/EXEC)

# Observability

- otel

# Benchmarking


---

## Thoughtprocess, code breakdown

... what files do matter, look at tree.
umm, util is kept at root level, minor thing but makes sense, so tests and application can make use of common utils.

reverse split, hmm
typing.Protocol class?! - woahh,... so you can also do composition in python...

okay, can understand why TypeVar is used instead of Union.
coupling with Mapping, makes a powerful & flexible abstraction...

custom types are appended with 'T' to avoid confusion with classes?

They have a mapping bw error response message to python exception in `_parsers/base.py`, BaseParser, separate string for different redis version with some error messages

so you can specify python to not use dictionary object for classes and instead `__slots__`, feels more like struct in other languages.

for push message callback handlers, they accept muliple Callable (function) and invoke the right one based on the response message.

some lifecycle methods in parser (on_connect, on_disconnect)

readexactly - working with the raw bytestream, or any reader for that matter.  - AHHH, so you can literally pass a filepointer and code still works. 

Coming to socket.py...

buffer is a simple BytesIO, nice, rest of the methods like read, readline, they'll make sense only if protocol structure is familiar, so I'm skipping.

`import errno` - maps to host OS specific error codes, to provide platform independence

There are lot of legacy unsupported workarounds still present in the codebase... like the assignment with ssl.SSLWantReadError in socket.py.

In SSL/TLS, performing read might raise an write error, coz underneath some complex cryptographic operation with some negotiation might be running, in that case the SSL library has to write data to socket when we tried to access the data. nice.

Whitelisting exception classes with normal dicts, okay.
```py
    allowed = NONBLOCKING_EXCEPTION_ERROR_NUMBERS.get(ex.__class__, -1)
    if not raise_on_timeout and ex.errno == allowed:
        # ...

```

using object() to detect "whether the default value has been modified in a method" is quite ingenious (`_parsers/socket.py`).

If you ever want to work with socket, humbly take a copy of socket.py ~

organising classes from different python files in a flat structure with `__all__` in init.py.

mystery: events... how are they fired and received? (check multidb/command_executor.py), how does setting new_database / new_pubsub is just enough? - oh, we call on_connect()

`@property` for read-only encapsulation

1. EventListenerInterface & EventDispatcherInterface, EventException
    - register_listener()
    - listen()
    - dispatch()
2. Event (not a strict implementation, except method signature)
3. EventDispatcher

idk, but I feel the whole event stuff is a bit messy...
it's not "really" event, there are actually just chains of callback. quite decisive.

what is the use of pybreaker... what is it doing? - to isolate the dead database, to prevent overwhelming already unhealthy db. (But if you're on kubernetes and, traffic is routed dynamically to different pods, then this is probably not needed (health probe does the similar stuffs like circuit breaker) - unless you connect to statefulsets directly)

using pybreaker to quickly switch to a fallback db.

```lua
Complete State Machine

CLOSED
   ↓ (failure threshold exceeded or health check fails)
OPEN
   ↓ (after grace period: 60s)
HALF_OPEN
   ↙ (health check passes)     ↘ (health check fails)  
CLOSED                       OPEN

```

check `from redis.multidb.circuit import State as CBState`, state is completely tied up with callback event.

Connection - ocsp (ssl socket connection)
they're trying to get IP from the socket. it's behaviour can change based on the type of service (normal & headless service) is used in kubernetes.

- normal: resolves to cluster ip, trafic is passed through kubeproxy and then sent to appropriate pods.
- headless: resolved ips point to the actual pods themselves (cluster ip is None)

typically, dbs are deployed as sts, which uses headless service. helpful when clients want to discover all database nodes. So, pybreaker does makes sense...

threading.RLock does not deadlock when the same thread requests multiple locks at the same time. within redis-py, cache is maybe shared between different cache pools? so a single lock would unnecessarily block operation that once again reuse the same lock?



