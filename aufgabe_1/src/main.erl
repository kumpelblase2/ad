%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Okt 2014 13:37
%%%-------------------------------------------------------------------
-module(main).
-author("tim_hagemann").

%% API
-export([init/0]).

init() ->
  LISTE = liste:create(),
  io:write(LISTE),
  LISTE2 = liste:insert(LISTE, 1, test),
  io:write(LISTE2),
  LISTE3 = liste:insert(LISTE2, 1, test2),
  io:write(LISTE3),
  io:write(liste:find(LISTE3, test)),
  io:write(liste:retrieve(LISTE3, 1)),
  LISTE4 = liste:delete(LISTE3, 2),
  io:write(LISTE4).