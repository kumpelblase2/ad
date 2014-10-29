%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Okt 2014 08:31
%%%-------------------------------------------------------------------
-module(stack).
-author("tim_hagemann").

%% API
-export([create/0, pop/1, push/2, top/1, empty/1]).

create() ->
  liste:create().

push(STACK, ELEM) ->
  liste:insert(STACK, liste:laenge(STACK) + 1, ELEM).

pop(STACK) ->
  liste:delete(STACK, liste:laenge(STACK)).

top(STACK) ->
  liste:retrieve(liste:laenge(STACK)).

empty(STACK) ->
  liste:isEmpty(STACK).