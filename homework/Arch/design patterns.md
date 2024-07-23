## Revision
1. Strategy Pattern: 
    - Prevent class explosion.
    - Every method inside this class is a wrapper of another class with a single method.
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
    - have control over creating multiple objects.
> irl: cross-platform UI libraries 
> Interesting: builds on factory pattern, but imposing strict rules

6. Singleton Pattern:
    - Single global instance of heavy class
    - check-lock-check creation during instantiation. 

7. Commmander Pattern: 
    - Undo for every action. [execute, unexecute]
    - two sections: [hardcoded region] (variable) <- | <- [generalized region] (constant)
    - two behaviour:   [actual action]        <-     | <- [trigger action]
    - couple with queue mechanism to facilitae undo
> Invoker (different device which has commands instances stored in them), quite interesting. 
> check gary bernhardt's talk: boundaries (avoid mutation when possible)

8. Adapter Pattern: 

