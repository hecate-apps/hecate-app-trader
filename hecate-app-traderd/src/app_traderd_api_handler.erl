%%% @doc General API handler: /api/*
%%%
%%% Placeholder for future trader-specific API endpoints.
%%% Currently returns 404 for all paths.
%%% @end
-module(app_traderd_api_handler).

-export([init/2]).

init(Req0, State) ->
    Path = cowboy_req:path(Req0),
    Req1 = cowboy_req:reply(404, #{
        <<"content-type">> => <<"application/json">>,
        <<"access-control-allow-origin">> => <<"*">>
    }, json:encode(#{
        <<"ok">> => false,
        <<"error">> => <<"not_found">>,
        <<"path">> => Path
    }), Req0),
    {ok, Req1, State}.
