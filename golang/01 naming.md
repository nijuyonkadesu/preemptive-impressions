# Doubts

1. when to use PascalCase, when to use camelCase.
2. how to name structures,
3. how to name interfaces
4. how to name functions that need to be imported from another file
5. private functions / variables vs public functions / variables

## Answers

1. camelCase vs PascalCase

| Case Style   | Usage                | Visibility | Example             |
| ------------ | -------------------- | ---------- | ------------------- |
| `PascalCase` | **Exported** names   | Public     | `User`, `NewClient` |
| `camelCase`  | **Unexported** names | Private    | `config`, `doLogin` |

2. structures

- PascalCase

```go
type User struct {
    ID    int
    Email string
}

type MessageQueue struct {
    messages []string
}
```

3. interfaces

- PascalCase + optional `-er` for defining verb like behaviour

```go
type Reader interface {
    Read(p []byte) (n int, err error)
}

type Closer interface {
    Close() error
}

type ReadCloser interface {
    Reader
    Closer
}
```

4. variables

- camelCase

```go
var userID int
var connPool *sql.DB
```

5. costants

```go
const Pi = 3.14
const MaxLimit = 10

// say 'Bruhh'
const DEBUG = true
```

5. packages

- all lower case, no `_` underscores

```go
package auth
package config

// say 'Bruhh'
package AuthUtils
package config_utils
```

6. visibility matrix

| Element      | Style      | Exported? | Example                 |
| ------------ | ---------- | --------- | ----------------------- |
| Struct       | PascalCase | Yes       | `type User struct`      |
| Interface    | PascalCase | Yes       | `type Reader interface` |
| Public var   | PascalCase | Yes       | `Logger`, `Pi`          |
| Private var  | camelCase  | No        | `dbConn`, `userID`      |
| Public func  | PascalCase | Yes       | `InitApp()`             |
| Private func | camelCase  | No        | `connectDB()`           |
| Package name | lowercase  | N/A       | `config`, `db`, `api`   |

---

# Steps for setting up a project

# Testing

```go
go test ./...
go test ./internal/headers/
```
