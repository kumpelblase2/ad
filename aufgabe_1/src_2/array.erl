%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Okt 2014 08:34
%%%-------------------------------------------------------------------
-module(array).
-author("tim_hagemann").

%% API
-export([]).

create() ->
  liste:create().

setA(LIST, POS, ELEM) ->
  LISTPOS = POS + 1,
  LIST_LENGTH = liste:laenge(LIST),
  if
    LIST_LENGTH < LISTPOS ->
      setA(liste:insert(LIST, liste:laenge(LIST), undefine), POS, ELEM)
  end.

getA(LIST, POS) ->
  liste:retrieve(LIST, POS + 1).

laenge(LIST) ->
  liste:laenge(LIST).