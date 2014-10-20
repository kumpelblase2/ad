%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Okt 2014 12:00
%%%-------------------------------------------------------------------
-module(array).
-author("tim_hagemann").

%% API
-export([]).

create() ->
  {array, liste:create()}.

setA({array, LIST}, POS, ELEM) ->
  LISTPOS = POS + 1,
  LIST_LENGTH = liste:laenge(LIST),
  if
    LIST_LENGTH < LISTPOS ->
      setA({array, liste:insert(LIST, liste:laenge(LIST), undefine)}, POS, ELEM)
  end.

getA({array, LIST}, POS) ->
  liste:retrieve(LIST, POS + 1).

laenge({array, LIST}) ->
  liste:laenge(LIST).