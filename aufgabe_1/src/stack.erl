%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Okt 2014 11:42
%%%-------------------------------------------------------------------
-module(stack).
-author("tim_hagemann").
%% API
-export([create/0, pop/1, push/2, top/1, empty/1]).

create() ->
  {stack, liste:create()}.

push({stack, LIST}, ELEM) ->
  {stack, liste:insert(LIST, liste:laenge(LIST) + 1, ELEM)}.

pop({stack, LIST}) ->
  {stack, liste:delete(LIST, liste:laenge(LIST))}.

top({stack, LIST}) ->
  liste:retrieve(liste:laenge(LIST)).

empty({stack, LIST}) ->
  liste:isEmpty(LIST).