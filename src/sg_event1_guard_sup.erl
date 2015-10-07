-module(sg_event1_guard_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() ->
	Name = {local, ?MODULE},
	supervisor:start_link(Name, ?MODULE, []).

init([]) ->
	% This is a 'simple_one_for_one' supervisor, so this must be a single
	% child spec.
	Children = [
		{sg_event1_guard, {sg_event1_guard, start_link, []},
			temporary, 5000, worker, [sg_event1_guard]}
	],
	{ok, { {simple_one_for_one, 10, 60}, Children } }.
