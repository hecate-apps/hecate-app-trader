%%% @doc Hecate Trader top-level supervisor.
%%%
%%% Supervision tree:
%%% hecate_app_traderd_sup (one_for_one)
%%%   (empty for now - domain desks will be added here)
%%% @end
-module(hecate_app_traderd_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    SupFlags = #{
        strategy => one_for_one,
        intensity => 10,
        period => 60
    },
    ChildSpecs = [
        #{
            id => app_traderd_plugin_registrar,
            start => {app_traderd_plugin_registrar, start_link, []},
            restart => transient,
            type => worker
        }
    ],
    {ok, {SupFlags, ChildSpecs}}.
