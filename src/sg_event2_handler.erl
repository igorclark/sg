-module(sg_event2_handler).
%% API
-export([start_link/0, get_state/0, crash/0]).

%% gen_event callbacks
-export([init/1, handle_event/2, handle_call/2, 
		 handle_info/2, terminate/2, code_change/3]).

-behaviour(gen_event).

-define(SERVER, ?MODULE). 

-record(state, {}).

start_link() ->
	gen_event:start_link({local, ?SERVER}).

get_state() ->
	gen_event:call(sg_event2, ?MODULE, get_state).

crash() ->
	error_logger:info_msg("~p CRASHING ON REQUEST FROM PROCESS ~p", [?MODULE, self()]),
	gen_event:call(sg_event2, ?MODULE, crash).

init([]) ->
	error_logger:info_msg("~p ~p init()", [?MODULE, self()]),
	{ok, #state{}}.

handle_event(Event, State) ->
	error_logger:info_msg("~p ~p handle_event: ~p", [?MODULE, self(), Event]),
	{ok, State}.

handle_call(crash, _State) ->
	badarg;

handle_call(get_state, State) ->
	{ok, {self(), State}, State};

handle_call(_Request, State) ->
	Reply = ok,
	{ok, Reply, State}.

handle_info(_Info, State) ->
	{ok, State}.

terminate(_Reason, _State) ->
	error_logger:info_msg("~p TERMINATING: ~p~n", [?MODULE, self()]),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
