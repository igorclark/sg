-module(sg_event1_guard).
-behaviour(gen_server).
-export([start_link/3]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
		 terminate/2, code_change/3]).

-record(state, {event, module, config}).

start_link(Event, Module, Config) ->
	gen_server:start_link(?MODULE, [Event, Module, Config], []).

init([Event, Module, Config]) ->
	error_logger:info_msg("~p ~p init()", [?MODULE, self()]),
	install_handler(Event, Module, Config),
	{ok, #state{event=Event, module=Module, config=Config}}.

install_handler(Event, Module, Config) ->
	error_logger:info_msg("~p ~p install_handler(~p, ~p, ~p)", [?MODULE, self(), Event, Module, Config]),
	ok = gen_event:add_sup_handler(Event, Module, Config).



handle_call(_Request, _From, State) ->
	Reply = ok,
	{reply, Reply, State}.

handle_cast(_Msg, State) ->
	{noreply, State}.



handle_info({gen_event_EXIT, Module, normal}, #state{module=Module} = State) ->
	error_logger:info_msg("~p ~p got gen_event_EXIT: ~p", [?MODULE, self(), normal]),
	{stop, normal, State};

handle_info({gen_event_EXIT, Module, shutdown}, #state{module=Module} = State) ->
	error_logger:info_msg("~p ~p got gen_event_EXIT: ~p", [?MODULE, self(), shutdown]),
	{stop, normal, State};

handle_info({gen_event_EXIT, Module, Reason},
	#state{event=Event, module=Module, config=Config} = State) ->
		error_logger:info_msg("~p ~p got gen_event_EXIT: ~p", [?MODULE, self(), Reason]),
		install_handler(Event, Module, Config),
		{noreply, State};



handle_info(Info, State) ->
	error_logger:info_msg("~p ~p got handle_info: ~p", [?MODULE, self(), Info]),
	{noreply, State}.

terminate(Reason, _State) ->
	error_logger:info_msg("~p ~p terminating: ~p", [?MODULE, self(), Reason]),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.
