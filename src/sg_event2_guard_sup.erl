-module(sg_event2_guard_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() ->
	Name = {local, ?MODULE},
	{ok, Pid} = Link = supervisor:start_link(Name, ?MODULE, []),
	error_logger:info_msg("~p ~p started ~p", [?MODULE, self(), Pid]),
	Link.

init([]) ->
	% This is a 'simple_one_for_one' supervisor, so this must be a single
	% child spec.
	Children = [
		{sg_event2_guard, {sg_event2_guard, start_link, []},
			temporary, 5000, worker, [sg_event2_guard]}
	],
	{ok, { {simple_one_for_one, 10, 60}, Children } }.
