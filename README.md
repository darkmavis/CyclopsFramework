[New C# version for Unity (https://github.com/darkmavis/com.smonch.cyclopsframework)](https://github.com/darkmavis/com.smonch.cyclopsframework)

## CYCLOPS FRAMEWORK - LESS CODE. MORE GAME.
### Tweening, psuedo-threading, cascading tags and so much more.

Update from the future, regarding the use of the term psuedo-threading:

I've been using coroutines with properties overlapping async/await and state machines since 2007.  I didn't learn the term coroutine until several years later.  That's probably the term I should have used, but just not something most developers were aware of at the time.  I did ask around a bit though and nobody I knew was familiar with this style of coding.  I think async/await took even longer to catch on, slightly later in the 2010s.  Before that though, I used this framework to achieve the exact same style of code when dealing with RESTful web APIs and other types of remote procedure calls.

Welcome to the Cyclops Framework!  This is an active AS3 based
project that I use in my professional life as a game developer
and would like to share with the community.  The purpose of
this framework is to support an alternative style of
development, which honestly, isn't quite as alternative as it
was when I wrote my first framework of this type in early
2007, but is definitely still very fun, productive and
evolving.

So what makes this framework fun and worth a look?

For one, it's biased towards functional programming in
Action Script 3.  But more important is the combination of
psuedo-threading with a robust object tagging system.
More on this in a moment.

One of the immediate draws of the framework is it's ease
of use for tweening.  If you've used other tweening libraries
or Cocos2D, some of this might look familiar, but the tagging
system provides critical functionality not found in other
systems, at least to the best of my knowledge at the time of
this writing.

It's quick and easy to create fire and forget built-in and
custom tweens (aka actions) such as fades, scaling,
rotation, etc. via a single line of code.
```
// fade mySprite in and out over .2 seconds, 5 times.
engine.add(new CFFade(mySprite, 0, 1, .2, 5, CFBias.SINE_WAVE));
```
It's also as easy to create a sequence of actions, even custom
one-offs, right on the spot.
```
engine
        // sugar for: .add(new CFSleep(5)) // sleep for 5 seconds.
    .sleep(5)
        // anonymous method converted to an action.
    .add(function():void { trace("Hello World!"); })
        // fade mySprite in and out over .2 seconds, 5 times.
    .add(new CFFade(mySprite, 0, 1, .2, 5, CFBias.SINE_WAVE));
```
And while all of this is happening, what if we want to
create another sequence that will run concurrently? No problem!
```
engine
    .sleep(1) // sleep for 1 second.
	      // translate mySprite by x+100, y+50 over 5s.
    .add(new CFTranslateBy(
		mySprite, 100, 50, 5, 1, CFBias.EASE_IN_OUT));
```
Let's add one more thing to the mix... looping.
To demonstrate, let's say that while everything is running,
you'd also like to track the frame rate once every
1/2 second.  How easy would that be?
```
engine.loop(function():void
{
    trace("fps: " + engine.fps);
}, .5);
```
Now imagine, that you have a number of sequences running
concurrently and you need an easy way to manage them.
That brings us to the tagging system.

The framework provides an interface, ICFTaggable, which can be
used to assign as many string tags to an object as you'd
like.  CFAction, from which all actions are derived, already
implements this for you.
Note: Any ICFTaggable can be managed via the tagging system
and it's often quite useful for reasons such as querying and
messaging which will be explained just a little further down.

What does tagging look like?

In the case of an plain old ICFTaggable, it looks like this:
```
myObject.tags.addItem("foo");
```

In the case of an action, it could look like this:
```
myAction.addTag("foo");
```

However in practice with actions, it usually looks something
like this:
```
engine
    .add("foo", new CFSleep(10))
    .add(function():void { trace("We made it!"); });
```
In above example, CFSleep is tagged with "foo".  You could add
more tags... "foo", "bar", new CFSleep(10)... and in that
case, both tags would be applied.

Now let's say, 5 seconds into this sequence, it seems like a
good idea to shut it down.  Here's a way to do that.
```
engine.remove("foo"); // remove anything tagged with "foo".
```
At the end of the current frame, when all actions have been
processed and before new actions are added, everything tagged
with "foo" will be removed (and in the case of actions,
stopped.)

So what happened to the function with the trace statement?

It was removed as well because child actions are removed by
default. If that isn't your intent, then you can specify that
as such:
```
// "We made it!" will be printed during the following frame.
engine.remove("foo", false); 
```
And now it's time for cascading tags, one of the most important
features of this framework.  So what the heck are they?

Let's say you had a sequence like this:
```
engine
    .add("cool_stuff", new CFSleep(10))
	// who knows how long this will run?
    .add(new DoCoolStuffIndefinitely());
```
Suppose that you want to think of this sequence as a single
unit of work that may need to be shut down at any
point in time.  No problem! 
The "cool_stuff" tag cascades into all child actions...
in this case, just DoCoolStuffIndefinitely.
So if you were to remove that tag the way we did before,
then regardless of whether CFSleep or DoCoolStuffIndefinitely
was active, the process would shut down.

If you noticed that child actions was plural, it's because
sequences aren't chains, they're trees.  You can start as many
child actions as you'd like after a parent actions finishes. 
That could look like this:
```
engine
    .add("foo", new CFSleep(1))
	// all children of CFSleep and all tagged with "foo".
    .add(new Foo(), new Bar(), function():void {
		trace ("42"); });
```
In the example above, after one second, all three actions will
start concurrently and all are registered with the "foo" tag.

Now to skip ahead a bit, here's perhaps a more advanced use of
the tagging system.
```
k.space = function():void
{
    if (engine.count("missile_throttle") == 0)
    {
        engine.add("missile_throttle", new CFSleep(.5));
        engine.send("missile", "fire");
    }
};
```
In this example, every time the user presses SPACE, a missile
should fire.  But a new missile should only fire once every
1/2 second.  Here we're using a simple query feature, 
engine.count, to determine how many objects are registered
with the "missile_throttle" tag.  We're also
using the tag based messaging system.

So how does messaging work?

Well, since we have this nice little database of tagged 
objects at our disposal, wouldn't it be nice to be able to
message objects by tag?
And while we're at it, who wants to deal with the old message
pump switch statement variety of messaging?  Yuck!

In this system, if an object tagged with "missile" implements
a fire() method, then the message above, will trigger the
fire() method.  If another object is tagged with "missile" but
doesn't implement fire(), no worries, it's just ignored.
This can be very useful for situations where you've already
implemented a method and at some later date realize that you
need to call that on a whole group of objects and don't want
to bother writing any additional code.
Besides being easier to implement than events, an additional
benefit is that messages are synchronized and called after all
objects have been processed in the current frame to make
concurrency easier to handle.

Messages can contain payloads and even specify a specific
receiver type if required.  Additionally, they also work on
properties without any changes.  To top it off, they even work
with nested properties.
```
// equivalent to: player.position.x = 5
engine.send("player", "position", ["x", 5]); 
```
For even more fun, you might want to try proxies.
They work like this:
```
engine.proxy("player").health = 10;
engine.proxy("missile").fire();
```
Using some sugar in the CFScene class, things might wind up
looking a little like something from jQuery:
```
$("player").fire();
```
Note that sending a message is faster and more flexible than
using a proxy, but in most cases, it really doesn't matter.

So far we've barely scratched the core.  But hopefully this will
provide a decent glimpse of what this framework is about.  I'll
continue this intro another day and delve further into more of
the core features, including advanced querying, functional
programming support, the various utilities, scene framework,
Box2D physics support, tile base engine, etc.

Something worth mentioning right now though, because I haven't
been able to find it elsewhere is the console: CFConsole.

CFConsole is a very robust in-game console.  It supports
built-in and easily added custom commands with a help system
to boot.  It handles built-in and custom channels, channel
filtering and embedded AS3 scripting using D.eval.

Embedded REPL scripting plus robust object tagging offers some
very interesting debugging capabilities.  Imagine being able
to easily query, message and tweak your objects and actions as
they are running!  Additionally, you can get status updates of
all the current actions that are running, along with their
progress, tags, etc.

Using CFGame and CFScene as intended, from the console, you
could type something like this:
```
find("Gameplay").status();
```
Given the correct setup, that would find a CFScene tagged with
"Gameplay" and call the status() method which would then print
a list of all active actions with progress, tags, etc.  Or you
could do your own status query and send the report to some
external program that would let you monitor every tagged
object and action in your game in real-time.

Here's a quick look at the "inner loop" of a CFEngine,
the engine at the heart of every CFScene, the scene(s) at the
heart of every CFGame! :P
```
public function update(delta:Number):void
{
    _delta = delta;    
    processDelayedFunctions();
    processActions(delta);
    processMessages();
    processStopRequests();
    processRemovals();
    processAdditions();
    // pause and resume act on new additions intentionally.
    processResumeRequests();
    processPauseRequests();
    _blocksRequested.clear();
}
```
Thanks so much for taking a look!  I plan on maintaining this
library for many years to come.

Update from the distant future:

I was planning to release a C# version when the AS3 project was still active.  It's been over 10 years, but I'm happy to announce that the C# / Unity version is finally available on GitHub.  At the time of this writing, the C# version is stripped down to the essentials.  For the time being, you won't find anything resembling the data pipe or proxies.  Proxies relied on hooking into dynamic dispatch and used dynamic language features to do so.  While C# does have support for this, the new framework is aimed at Unity development and dynamic language features are not supported by IL2CPP builds.  Also missing, intercepted messages don't automagically work with properties using reflection like they did in AS3.  That said, the C# framework works quite well with Unity development and integrates nicely with Unity specific features.

[New C# version for Unity (https://github.com/darkmavis/com.smonch.cyclopsframework)](https://github.com/darkmavis/com.smonch.cyclopsframework)

Please feel free to ask if you have any questions.

Thanks again,

Mark Davis
