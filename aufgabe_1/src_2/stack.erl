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

% Erstellt einen leeren Stack
create() ->
  liste:create().

% Packt das Element auf den Stack.
push(STACK, ELEM) ->
  liste:insert(STACK, liste:laenge(STACK) + 1, ELEM).

% Loescht das oberste Element vom Stack.
pop(STACK) ->
  liste:delete(STACK, liste:laenge(STACK)).

% Gibt das oberste Element aus dem Stack zurueck.
top(STACK) ->
  liste:retrieve(STACK, liste:laenge(STACK)).

% Prueft ob der Stack leer ist.
empty(STACK) ->
  liste:isEmpty(STACK).