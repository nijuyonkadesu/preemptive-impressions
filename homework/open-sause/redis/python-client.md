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

1. EventInterface, EventException
2. Event (not a strict implementation, except method signature)
3. EventDispatcher

idk, but I feel the whole event stuff is a bit messy...

the whole event thing, needs a revisit
