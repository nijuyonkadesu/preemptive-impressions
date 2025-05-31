## insights

[01](https://news.ycombinator.com/item?id=21870889)
if every user creates these structures in a database, every 5 minutes, we can expect that this table will have n records by time y. If that happens, one, is the size tractable, does it need an index, and do we want to reconsider this approach in favor of a cleverer design that can avoid this query? Things like that
A recent example for me was researching max zookeeper writes per second and deciding if it can be used for super high volume writes in a system. The conclusion, based on some napkin math of the system needs, and some benchmarking of ZooKeeper was that a different tool needs to fill that spot in the architecture because it was too write-heavy for zookeeper.

> Dig in to problems with more angles of investigation

ericb on Dec 26, 2019 | root | parent | next [–]:

Let's say there's "slowness" on a route in a Rails app. A really junior engineer might start blindly optimizing.

A mid-skill engineer might start by trying to diagnose the problem, and usually will get somewhere, but occasionally they'll run out of ideas. They might assume it has to be one of the things they've seen before, but their list is not exhaustive.

A top engineer will start by looking at the big picture and generating hypothesis. They will usually be able to generate more hypothesis and have more ways to test them than less seasoned folks. Often this is because they've seen more things.

For example, off the top of my head, the slowness could be:

- n+1 query problems
- slow remote service calls
- streaming to slow clients
- object allocations
- loops in loops--bad big O
- resource limitation (memory, CPU, IOPS)
- database connection limits
- worker process/thread limit
- frequent cache misses
- noisy neighbor problem
- lack of indexing and data size growth

A top engineer will run through their own list, and for each, they have some ideas on how to check on that item or to rule out what is unlikely. Some of them are trickier than others. The key is they have more angles that they'll know off-hand to follow up on.

Their ability to "context switch" when describing a situation to other experts vs novices vs non-particpants.
And one that's not explicitly from the book but is contained in its wisdom:

- Skate where the puck is going, not where it is.

- Research & Finalize architecture design before jumping to code

I think the best definition of engineering is that it's a process of optimization within a solution space bounded by constraints. If you pile up some mud and let it dry, you have made a dwelling but you are not an engineer. If you calculate the load requirements for a series of I-beams given a certain budget and build a skyscraper, you are an engineer.

As the author correctly notes, there aren't necessarily hard boundaries on what qualifies as engineering, but I think there clearly are axes on which something is "more engineer-y" vs "less engineer-y", and as the constraints of the solution space go from physical (tension, voltage, pressure) to non-physical (interpersonal relations, public perception, aesthetic judgment), the activity goes from more engineer-y to less engineer-y.

In software, we're always optimizing on cost / developer time, but that's closer to the non-physical side of the constraint physicality axis. As you optimize for things like memory usage, execution time, binary size, then you get closer to the physical end of the constraint-type axis, and are thus more engineer-y.

[02](https://news.ycombinator.com/item?id=29998868) **NASA needs software engineers. Microsoft doesn't.**
