## Revision
1. Strategy Pattern: 
    - Prevent class explosion.
    - Every method inside this class is a wrapper of another class with a single method.
    - FOR SINGLE METHOD ONLY??
    - Dependency injection, composability
> means, one concrete class, but behaviour varies through composition of different method implemntation.
> Interesting: Applying abstractions on methods rather than on classes.

2. Observation Pattern:
    - Push updates to subscribers.
    - subscribers take Subject when instantiation -> means, they can read update directly
> Interesting: having the 'Subject' class itself stored inside 'Observer'

3. Decorator Pattern: 
    - Prevent class explosion
    - Actually useful only when the behaviour between decorators are significantly different. [behaviour variation]
    - Change behaviour of object at runtime.
    - One = new Two(One)
    - Three = new Three(Two), and two indirectly contains one, so any operation performed on three, modifies two, and two indirectly modifies one. And construction of new classes can be done at runtime, and therefor the Decorator pattern. 
    - Coffee = new MoreCaffine(Coffee)
    - Coffee = new MoreSugar(Coffee) // Coffee here is MoreCaffine which inturns wraps the original Coffee. [they all implement the same interface]
> Interesting: two different ideas, but implements the same interface.
> Interesting: The idea 2 holds a instance of idea 1, so that the changes can propagate recursively. 
> irl: deprecations

4. Factory Pattern: 
    - Avoid class explosions, depend only on key classes.
    - Defer instantiation to sub classes, but parameters differs, and the way in which consturcted differes. [polymorphism]
    - How / Why / With which parameters you want to construct an object doesn't matter, at the end you want an object. That's all. 
> Spaceship, astroid game example. [CreateObstacle Factory]
> Parametring portions of the system

5. Abstract Factory Pattern: 
    - An interface to create families of related products without specifying their concrete classes.
    - have control over creating multiple objects, but related ones together.
> irl: cross-platform UI libraries 
> Interesting: builds on factory pattern, but imposing strict rules

6. Singleton Pattern:
    - Single global instance of heavy class
    - check-lock-check creation during instantiation. 

7. Commmand Pattern: 
    - Undo for every action. [execute, unexecute]
    - two sections: [hardcoded region] (variable) <- | <- [generalized region] (constant)
    - two behaviour:   [actual action]        <-     | <- [trigger action]
    - couple with queue mechanism to facilitae undo
> Invoker (different device which has commands instances stored in them), quite interesting. 
> check gary bernhardt's talk: boundaries (avoid mutation when possible)

[Adapter, Facade, Proxy, Decorator]

8. Adapter Pattern: 
    - Just middle class that we design, to work with some rapidly changing external library (or on something that you don't have any control over)
    - or, to handle input format / stadard changes in a centralized manner. 
> mind having dependency injection
> DO NOT ADD / REMOVE / MODIFY EXISTING BEHAVIOUR THAT WE ARE TARGETTING FOR, JUST A PASSTHROUGH ONLY

9. Facade Pattern: 
    - To interact with complex system, complex wired system. 
    - The black box of the above system, but with simple interface. 
    - Unified interface to a set of interfaces in a subsystem. (provides a higher-level interface) 
> !!NOT ADDING ADDIONAL BEHAVIOUR!!
> "There is not some order to this madness, it's just madness" - Christopher Okhravi
> Side note: "The princile of least knowledge": Talk only to your immediate friends, but not friends of friends. Coz, coupling

10. Proxy Pattern:
    - Interface is **unchanged**, but introduces interception of all requests before accessing the underlying thing. 
    - Interception, Access control, security, caching, lazy evaluation, logging,...
    - **Remote** - remote resources, differnt location, [Node Promises]. Takes responsibility of retrieving that external resource for you. 
    - **Virtual** - lazy evaluation
    - **Protection** - access management
    - has an instance of the of object this proxy is proxying.
> Remote, Virtual, Protection

11. Bridge Pattern:
    - Decouple abstraction from implementation. [yes blows mind]
    - Adapt over a concrete
    - Similar to Abstract Factory Pattern, except the combination of classes is relaxed
> Example: Say there are two types of `<concrete [Abstraction]>` Book [MediaResource] and Portrait [View]. Bride allows to mix any of those two regardless of the concrete implementation. 
> Interesting: Coupling an abstract class with another interface, so that the concrets can vary independently...
> Interface segregation principle
> kind of extends proxy pattern?
> Check visitor pattern too
> Diagram: https://youtu.be/F1YQ7YRjttI?si=puCLBLW1uJ5I9glE&t=1849
> A-A

12. Template Method Pattern:
    - Defines a skeleton of an algorithm where some steps are deferred to subclasses, where the remaining is constant.
    - Those common operations should be the same across all cases. It has to be, else go shop for another design pattern.
    - Do you really nead this?? Why not Strategy Pattern work for you?? think for yourself...
    - Custom Hooks [before, after], interesing...
    - Quite dangerous if used inappropriately.
> Validate (const) - custom operation1, 2, 3, ... - validate (const)
> Open Closed principle?
> Dependency Inversion??
