-module(sg_sup).
-behaviour(supervisor).
-export([start_link/0, init/1]).

start_link() ->
    % The name is optional.
    supervisor:start_link(?MODULE, []).

init([]) ->
    Children = [
        % event1 manager
        {sg_event1, {gen_event, start_link, [{local, sg_event1}]},
            permanent, 5000, worker, [dynamic]},
        % event1 handler guard supervisor
        {sg_event1_guard_sup, {sg_event1_guard_sup, start_link, []},
            permanent, 5000, supervisor, [sg_event1_guard_sup]},

        % event2 manager
        {sg_event2, {gen_event, start_link, [{local, sg_event2}]},
            permanent, 5000, worker, [dynamic]},
        % event2 handler guard supervisor
        {sg_event2_guard_sup, {sg_event2_guard_sup, start_link, []},
            permanent, 5000, supervisor, [sg_event2_guard_sup]}
    ],
    {ok, { {one_for_one, 10, 60}, Children } }.
