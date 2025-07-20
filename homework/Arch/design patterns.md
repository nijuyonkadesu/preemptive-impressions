## 1. Strategy Pattern:

- Prevent class explosion.
- Every method inside this class is a wrapper of another class with a single method.
- FOR SINGLE METHOD ONLY??
- Dependency injection, composability

> [!NOTE]
> means, one concrete class, but behaviour varies through composition of different method implemntation.
> Interesting: Applying abstractions on methods rather than on classes.

## 2. Observation Pattern:

- Push updates to subscribers.
- subscribers take Subject when instantiation -> means, they can read update directly

> [!NOTE]
> Interesting: having the 'Subject' class itself stored inside 'Observer'

## 3. Decorator Pattern:

- Prevent class explosion
- Actually useful only when the behaviour between decorators are significantly different. [behaviour variation]
- Change behaviour of object at runtime.
- One = new Two(One)
- Three = new Three(Two), and two indirectly contains one, so any operation performed on three, modifies two, and two indirectly modifies one. And construction of new classes can be done at runtime, and therefor the Decorator pattern.
- Coffee = new MoreCaffine(Coffee)
- Coffee = new MoreSugar(Coffee) // Coffee here is MoreCaffine which inturns wraps the original Coffee. [they all implement the same interface]

> [!NOTE]
> Interesting: two different ideas, but implements the same interface.
> Interesting: The idea 2 holds a instance of idea 1, so that the changes can propagate recursively.
> irl: deprecations

## 4. Factory Pattern:

- Avoid class explosions, depend only on key classes.
- Defer instantiation to sub classes, but parameters differs, and the way in which consturcted differes. [polymorphism]
- How / Why / With which parameters you want to construct an object doesn't matter, at the end you want an object. That's all.

> [!NOTE]
> Spaceship, astroid game example. [CreateObstacle Factory]
> Parametring portions of the system

## 5. Abstract Factory Pattern:

- An interface to create families of related products without specifying their concrete classes.
- have control over creating multiple objects, but related ones together.

> [!NOTE]
> irl: cross-platform UI libraries
> Interesting: builds on factory pattern, but imposing strict rules

## 6. Singleton Pattern:

- Single global instance of heavy class
- check-lock-check creation during instantiation.

## 7. Commmand Pattern:

- Undo for every action. [execute, unexecute]
- two sections: [hardcoded region] (variable) <- | <- [generalized region] (constant)
- two behaviour: [actual action] <- | <- [trigger action]
- couple with queue mechanism to facilitae undo

> [!NOTE]
> Invoker (different device which has commands instances stored in them), quite interesting.
> check gary bernhardt's talk: boundaries (avoid mutation when possible)

[Adapter, Facade, Proxy, Decorator]

## 8. Adapter Pattern:

- Just middle class that we design, to work with some rapidly changing external library (or on something that you don't have any control over)
- or, to handle input format / stadard changes in a centralized manner.

> [!NOTE]
> mind having dependency injection
> DO NOT ADD / REMOVE / MODIFY EXISTING BEHAVIOUR THAT WE ARE TARGETTING FOR, JUST A PASSTHROUGH ONLY

## 9. Facade Pattern:

- To interact with complex system, complex wired system.
- The black box of the above system, but with simple interface.
- Unified interface to a set of interfaces in a subsystem. (provides a higher-level interface)

> [!NOTE] !!NOT ADDING ADDIONAL BEHAVIOUR!!
> "There is not some order to this madness, it's just madness" - Christopher Okhravi
> Side note: "The princile of least knowledge": Talk only to your immediate friends, but not friends of friends. Coz, coupling

## 10. Proxy Pattern:

- Interface is **unchanged**, but introduces interception of all requests before accessing the underlying thing.
- Interception, Access control, security, caching, lazy evaluation, logging,...
- **Remote** - remote resources, differnt location, [Node Promises]. Takes responsibility of retrieving that external resource for you.
- **Virtual** - lazy evaluation
- **Protection** - access management
- has an instance of the of object this proxy is proxying.

> [!NOTE]
> Remote, Virtual, Protection

## 11. Bridge Pattern:

- Decouple abstraction from implementation. [yes blows mind]
- Adapt over a concrete
- Similar to Abstract Factory Pattern, except the combination of classes is relaxed

> [!NOTE]
> Example: Say there are two types of `<concrete [Abstraction]>` Book [MediaResource] and Portrait [View]. Bride allows to mix any of those two regardless of the concrete implementation.
> Interesting: Coupling an abstract class with another interface, so that the concrets can vary independently...
> Interface segregation principle
> kind of extends proxy pattern?
> Check visitor pattern too
> Diagram: [ref: youtube](https://youtu.be/F1YQ7YRjttI?t=1849)
> A-A

## 12. Template Method Pattern:

- Defines a skeleton of an algorithm where some steps are deferred to subclasses, where the remaining is constant.675986
- Those common operations should be the same across all cases. It has to be, else go shop for another design pattern.
- Do you really nead this?? Why not Strategy Pattern work for you?? think for yourself...
- Custom Hooks [before, after], interesing...
- Quite dangerous if used inappropriately.

> [!NOTE]
> Validate (const) - custom operation1, 2, 3, ... - validate (const)
> Open Closed principle?
> Dependency Inversion??

## 13. Composite Pattern:

- Collection of objects, or single object it doesn't matter - Treat inidividual components and collection of components uniformly.
- Full power of trees!! [strings in javascript?]
- Data usefully Modeled Heirarchically + Computing over the heirarchy becomes trival, coz, you can treat all nodes as some.
- Tree Structures - Part Whole hierarchies...
- TODO: need more understanding...
- Initalizing this structure is still a mystry to me, coz, I think, we cannot treat Todo, TodoList, and Project the same way during initialization stage...
- The base functionality is similar to Decorator pattern.

```
           [TodoList]<li>
      Component(everything)<-.
        /       \            |
  Leaf(unique), Composite(unique)
   [Todo]<li>      [Project]<ul> (responsible to use proper html tags)
```

> [!NOTE]
> Replace a conditional with polymorphism - How? - by implementing the same interface! (that's lame).
> jQuery, React, Redux reducers.
> Send data downwards, and events upwards.
> [ref: youtube](https://youtu.be/EWDmWbJ4wRA?t=2571)

> [!tip]- A nice youtube comment
> A list is still considered a hierarchical structure. It has a head (root), a tail (leaf), and potentially stuff in the middle. As you clearly stated, composite pattern is all about establishing the structure WITHOUT changing the underlying behavior of the component of the structure. Decorator is not about structure, but about changing (augmenting) the behavior of the component.
> Your example of decorator gave me an idea. In Rich Text Editors, text can be "decorated" with different styles like bolded, italicized, and underlined. It can also be decorated with color. It can also be decorated with font families. These decorations can be used in conjunction with each other. This sort of thing cannot (should not) be done using Composite Pattern.
> In the same context, Composite Pattern can be used to establish structures such as toolbars, menu bars, and even the document device context. This is important because (for instance) when you resize your Word Processor window, you will want to resize all of the children elements that belong to it (in order to keep the aspect ratio, for instance). This sort of functionality cannot (should not) be done with a Decorator Pattern.
> I think the confusion can be attributed in part (at least for me) to the fact that Decorator Pattern is categorized as a STRUCTURAL design pattern rather than BEHAVIORAL. I think this is a mistake because clearly the intent of the pattern is to add additional responsibilities (behaviors) to objects.

## 14. Iterator Pattern

- Single responsibility
- Give me each of the items one by one, I'll iterate. That's all. I don't care what their types are, I'll iterate, and that's my only job.
- Simply gives the element when asked for.
- Lazy evaluation.
- Infinity
- Be wary if you send a reference or a copy of the object or a infinite generator
- remember current index.
- without exposing the underlying structure. [coz, in an aggregation, it can be of anything]
- ITERABLE, ITERATOR

> [!NOTE]
> command query separation: separate mutable and immutable operations into functions. Do not mix them, if not the result will be a mess.
> [ref: youtube](https://youtu.be/uNTNEfwYXhI?t=3092)

## 15. State Pattern

- Memoryless, works based on current state
- state1 -> transisiton -> state2, and loops are there ofc
- replacing conditional with polymorphism
- alter an object's behavior when its internal state changes - the object appears to change it's class
- states | behaviours - combinations
- Keep in mind that coupling to interfaces / abstrations is better than coupling to concrete classes.
- Components:

```
    [turn stile]
    **the thing** that **can** have states
         Context -------------------> State (Interface)
              ^                         |
              |____<change state>____ [open, close, processing] or,
                                      [return a new state instead of mutating state]
```

> [!NOTE]
> Interesting: we've modeled the state and how it responds to different events, but we have not modeled how the events themselves are triggered. That will be the business logic tied up with 'Context'.
> [ref: youtube](https://youtu.be/N12L5D78MAA?t=3074)

## 16. Null Object Pattern

- nothing, no operation

> [!NOTE]
> kek, the creator of null apologized for creating 'null', kekkekekekekek, Sandy Metz

## Intesting co-pilot nonsense

Downcasting, Upcasting, Polymorphism, Inheritance, Composition, Aggregation, Association, Dependency, Encapsulation, Abstraction, Interface, Abstract Class, Concrete Class, Class, Object, Instance, Method, Function, Variable, Constant, Property, Attribute, Field, Parameter, Argument, Return Value, Type, Value, Reference, Pointer, Memory, Stack, Heap, Garbage Collection, Recursion, Iteration, Loop, Condition, Branch, Expression, Statement, Block, Scope, Namespace, Module, Package, Library, Framework, API, SDK, Compiler, Interpreter, Transpiler, Debugger, Profiler, Editor, IDE, Version Control, Repository, Branch, Commit, Merge, Pull Request, Issue, Ticket, Agile, Scrum, Kanban, Waterfall, Lean, XP, Pair Programming, TDD, BDD, DDD, CI, CD, DevOps, Microservices, Serverless, Container, Virtualization, Cloud, IaaS, PaaS, SaaS, FaaS, Web, HTTP, REST, SOAP, GraphQL, TCP, UDP, IP, DNS, CDN, SSL, TLS, CORS, CSP, JWT, OAuth, OpenID, SAML, WebSockets, SSE, PWA, SPA, SSR, CSR, SEO, AMP, AR, VR, AI, ML, DL, NLP, RPA, Blockchain, Cryptography, Cryptocurrency, Bitcoin, Ethereum, Smart Contract, Solidity, Wallet, Exchange, Mining, Hash, Proof of Work, Proof of Stake, Fork, ICO, Token, ERC20, ERC721, Gas, Scalability, Interoperability, Security, Privacy, Anonymity, Identity, Access Control, Authorization, Authentication, Federation, SSO, MFA, RBAC, ABAC, ACL, CAP, BASE, ACID, CRUD, CQRS, Event Sourcing, DDD, Hexagonal, Onion, Clean, Micro, Serverless, Monolithic, SOA, REST, GraphQL, gRPC, WebSockets, SSE, PWA, SPA, SSR, CSR, SEO, AMP, AR, VR, AI, ML, DL, NLP, RPA, Blockchain, Cryptography, Cryptocurrency, Bitcoin, Ethereum, Smart Contract, Solidity, Wallet, Exchange, Mining, Hash, Proof of Work, Proof of Stake, Fork, ICO, Token, ERC20, ERC721, Gas, Scalability, Interoper

---

# Entity Composition System

Propagating a data to another object is easy, but it is nightmare in a fairly complex oops system. It has to be propagated and requires changes in interface at often times.

- OOPs draws boundaries at an entity level.
- ECS draws boundaries at the system level. Entities are free to access by anyone.

[source: youtube](https://www.youtube.com/watch?v=wo84LFzx5nI&t=6832s)

`Data | logic` -> are completely separate -> this is not tree structure at all.

**The Big OOPs, 37 year mistake:**

> "A compile time hierarchy of encapsulation that matches the domain model"

- template <datatype> -> use a class with your own type - okay.
- `virtual functions (typ *ptr)` - without virtual the object assumes type typ. methods of derived class of this 'typ' cannot be accessed - because it is fixed during compile time. with virtual, the method of the actual object we pass is accessed instead of the one defined in the typ base class.

ECS is more suitable for rigid, well defined systems. Like games, where the universe and how each piece interacts are well understood and known. 
TODO: (but it that 100% true? - when to use which and when does it makes sense???)

#### cpp example

> [!NOTE]
>
> 1. Each system has access to all objects - all entities.
> 2. you have type safety.
> 3. just make the business logic and done. [MIND BLOWING]

```cpp
struct Transform {
    Vector3 position;
    Vector3 velocity;
};

struct Health {
    int currentHealth;
    int maxHealth;
};

struct PlayerInput {
    bool moveLeft, moveRight, jump;
};

struct EnemyAI {
    float attackCooldown;
    float detectionRadius;
};

struct Renderable {
    ModelID modelId;
    TextureID textureId;
};

// Entity is just an ID
using Entity = uint32_t;

// Component storage
class ComponentManager {
    std::unordered_map<Entity, Transform> transforms;
    std::unordered_map<Entity, Health> healths;
    std::unordered_map<Entity, PlayerInput> playerInputs;
    std::unordered_map<Entity, EnemyAI> enemyAIs;
    std::unordered_map<Entity, Renderable> renderables;

public:
    template<typename T>
    void AddComponent(Entity entity, const T& component);

    template<typename T>
    T& GetComponent(Entity entity);

    template<typename T>
    bool HasComponent(Entity entity) const;
};

// Systems operate on component data - NO virtual functions
class MovementSystem {
public:
    void Update(ComponentManager& components, float deltaTime) {
        // Process all entities with Transform components
        for (auto& [entity, transform] : components.GetComponents<Transform>()) {
            transform.position += transform.velocity * deltaTime;
        }
    }
};

class PlayerInputSystem {
public:
    void Update(ComponentManager& components, float deltaTime) {
        // Process entities with both PlayerInput AND Transform
        auto& inputs = components.GetComponents<PlayerInput>();
        auto& transforms = components.GetComponents<Transform>();

        for (auto& [entity, input] : inputs) {
            if (transforms.find(entity) != transforms.end()) {
                auto& transform = transforms[entity];

                if (input.moveLeft) transform.velocity.x = -5.0f;
                if (input.moveRight) transform.velocity.x = 5.0f;
                if (input.jump) transform.velocity.y = 10.0f;
            }
        }
    }
};

class EnemyAISystem {
public:
    void Update(ComponentManager& components, float deltaTime) {
        auto& ais = components.GetComponents<EnemyAI>();
        auto& transforms = components.GetComponents<Transform>();

        for (auto& [entity, ai] : ais) {
            if (transforms.find(entity) != transforms.end()) {
                // AI logic here - no virtual functions
                UpdateAI(ai, transforms[entity], deltaTime);
            }
        }
    }

private:
    void UpdateAI(EnemyAI& ai, Transform& transform, float deltaTime) {
        // Direct function call - no virtual dispatch
        ai.attackCooldown -= deltaTime;
        // ... AI logic
    }
};

class RenderSystem {
public:
    void Render(ComponentManager& components) {
        auto& renderables = components.GetComponents<Renderable>();
        auto& transforms = components.GetComponents<Transform>();

        // Batch process all renderable entities
        for (auto& [entity, renderable] : renderables) {
            if (transforms.find(entity) != transforms.end()) {
                DrawModel(renderable.modelId, transforms[entity].position);
            }
        }
    }
};

// Game loop - systems process components directly
class Game {
    ComponentManager components;
    MovementSystem movementSystem;
    PlayerInputSystem inputSystem;
    EnemyAISystem aiSystem;
    RenderSystem renderSystem;

public:
    void Update(float deltaTime) {
        // Direct system calls - no virtual functions
        inputSystem.Update(components, deltaTime);
        aiSystem.Update(components, deltaTime);
        movementSystem.Update(components, deltaTime);
    }

    void Render() {
        renderSystem.Render(components);
    }

    Entity CreatePlayer() {
        Entity player = GetNextEntityID();
        components.AddComponent(player, Transform{{0, 0, 0}, {0, 0, 0}});
        components.AddComponent(player, Health{100, 100});
        components.AddComponent(player, PlayerInput{});
        components.AddComponent(player, Renderable{PLAYER_MODEL, PLAYER_TEXTURE});
        return player;
    }

    Entity CreateEnemy() {
        Entity enemy = GetNextEntityID();
        components.AddComponent(enemy, Transform{{10, 0, 0}, {0, 0, 0}});
        components.AddComponent(enemy, Health{50, 50});
        components.AddComponent(enemy, EnemyAI{0.0f, 5.0f});
        components.AddComponent(enemy, Renderable{ENEMY_MODEL, ENEMY_TEXTURE});
        return enemy;
    }
};

```

#### golang example

```go
type FileReader struct {
    filename string
}

func NewFileReader(filename string) *FileReader {
    return &FileReader{filename: filename
}

// Implements Read
func (fr *FileReader) Read(p []byte) (int, error) {
    file, err := os.Open(fr.filename)
    if err != nil {
        return 0, err
    }
    defer file.Close()

    n, err = file.Read(p)
    return n, nil
}

func main() {
    reader := NewFileReader("example.txt")

    // As long as reader has `Read` defined, this is valid - polymorphism
    _, err := io.ReadAll(reader)
    if err != nil {
        fmt.Println("Error reading file:", err)
        return
    }

    fmt.Println("File contents read successfully")
}
```
