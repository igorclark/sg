i can only really find [two](http://blog.differentpla.net/blog/2014/11/07/erlang-sup-event/) [posts](https://erlangcentral.org/wiki/index.php?title=Gen_event_behavior_demystified) which talk in any detail about supervising ```gen_event``` handlers while making sure the handlers *and* their managers get restarted after crashes. both posts are instructive yet still leave me feeling a bit confused, because i don't really get the mechanics behind the whole "[```gen_event``` handlers aren't processes](http://erlang.org/pipermail/erlang-questions/2010-January/048970.html)" thing clearly enough to grasp exactly which processes are guarding which other ones when i look at ```i()``` in the shell, and how to test whether killing the _thing1_ that's supposed to guard/restart _thing2_ will result in _thing1_ getting restarted by _thing0_ as hoped. which i guess is what the whole "[who supervises the supervisors](http://learnyousomeerlang.com/supervisors)" thing is getting at - but that doesn't go into detail of the where and when to plug in to the supervision tree. seems this area gets quite complex when you have these multi-layer dependencies.

so to try to understand a bit better (and poke around in the process list while it's going on), i made this skeleton project version of the approach taken in [the first post](http://blog.differentpla.net/blog/2014/11/07/erlang-sup-event/), which has more detail about how to plug into supervision using ```add_sup_handler/3``` in an OTP tree rather than in straight-up erlang processes. i extended it to use 2 different handlers for two different event types.

it seems to start up all the right processes, the handlers respond to the events and seem to get re-installed (i.e. ```init;/0```'d) by the ```gen_server``` when you make them crash (by using ```crash/0```, which just makes the ```gen_event``` proc return ```badarg``` instead of ```{ok, State}```). but i can't see how to make the event manager get restarted if it dies, or even really how to kill it in a way that should make it get restarted, other than just ```exit(pid(0,X,0),kill)``` - which definitely seems not to get it restarted.

there's also a [gist implementing a ```gen_server``` ```event_handler_guard```](https://gist.github.com/marcelog/5560239) which seems pretty neat, but again i'm not sure about the best way to glue it into a supervision tree.
in fact if i do a ```kill``` exit on the event_manager process (i.e. the process started by ```gen_event``` and named for the event it handles, e.g. ```sg_event1```) and then try to ```gen_event:notify(sg_event1, whatever)``` then no handler catches it, and if i then try to run ```sg_event1_handler:get_state/0``` i just get ```{error,badmodule}```. both of which make sense, because there's no handler installed to call and process for it to ```gen_event:call/2``` to, but, well, how do we deal with the event manager dying? or do we just trust to OTP that it won't?

so basically, yeah.
