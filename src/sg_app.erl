-module(sg_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
	Handlers = [
		{sg_event1, []},
		{sg_event2, []}
	],

	{ok, Pid} = sg_sup:start_link(),
	lists:foreach(
		fun({EventType, Config}) ->
			GuardSupModule = list_to_atom(atom_to_list(EventType) ++ "_guard_sup"),
			HandlerModule = list_to_atom(atom_to_list(EventType) ++ "_handler"),
			supervisor:start_child(GuardSupModule, [EventType, HandlerModule, Config])
		end, Handlers),
	{ok, Pid}.

stop(_State) ->
	ok.
