-module(sg_event1_handler).
%% API
-export([start_link/0, add_handler/0, get_state/0]).

%% gen_event callbacks
-export([init/1, handle_event/2, handle_call/2, 
		 handle_info/2, terminate/2, code_change/3]).

-behaviour(gen_event).

-define(SERVER, ?MODULE). 

-record(state, {}).

start_link() ->
	gen_event:start_link({local, ?SERVER}).

add_handler() ->
	gen_event:add_handler(?SERVER, ?MODULE, []).

get_state() ->
	gen_event:call(sg_event1, ?MODULE, get_state).

init([]) ->
	{ok, #state{}}.

handle_event(Event, State) ->
	error_logger:info_msg("~p ~p handle_event: ~p", [?MODULE, self(), Event]),
	{ok, State}.

handle_call(get_state, State) ->
	{ok, State, State};

handle_call(_Request, State) ->
	Reply = ok,
	{ok, Reply, State}.

handle_info(_Info, State) ->
	{ok, State}.

terminate(_Reason, _State) ->
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
