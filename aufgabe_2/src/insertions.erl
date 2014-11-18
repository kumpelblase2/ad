%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, HAW
%%% @doc
%%%
%%% @end
%%% Created : 12. Nov 2014 10:52
%%%-------------------------------------------------------------------
-module(insertions).
-author("tim_hagemann").

%% REQUIRED MODULES
%% liste.erl
%% array.erl
%% generator.erl
%% util.erl

%% API
-export([insertionS/3]).

%%selectionS() ->
%%  A = {5, {3, {9, {2, {10, {1, {}}}}}}},
%%  insertionS(A, 0, array:laenge(A) - 1).

%% Insertion-Sort Algorithmus. Sortiert eine in ARRAY enthaltene Zahlenfolge aufsteigend
%% und schreibt das Ergebnis in eine Datei
insertionS(ARRAY, START, END) ->
  RESULT = insertionS(ARRAY, START, END, 1),
  { TEMP, _ } = RESULT,
  generator:saveList(TEMP),
  RESULT.

insertionS(ARRAY, _START, END, CURRENT) when CURRENT > END ->
  SWAPS = util:countread(swap),
  COMPARISON = util:countread(compare),
  util:countreset(swap),
  util:countreset(compare),
  { ARRAY, { SWAPS, COMPARISON }};

insertionS(ARRAY, START, END, CURRENT) ->
  CURR_ELEM = array:getA(ARRAY, CURRENT),
  INSERT_POS = findInsert(ARRAY, START, CURRENT - 1, CURR_ELEM),
  TEMP = insertAt(ARRAY, INSERT_POS, CURRENT),
  insertionS(TEMP, START, END, CURRENT + 1).

%% Findet die Position in der Array wo ELEM eingefügt werden muss.
%% Dabei wird ein Counter hochgezählt, welcher die Vergleiche mitschreibt.
findInsert(_ARRAY, START, END, _ELEM) when START > END ->
  START;

findInsert(ARRAY, START, END, ELEM) ->
  LAST = array:getA(ARRAY, END),
  PREVIOUS = array:getA(ARRAY, END + 1),
  SMALLER = (ELEM >= LAST),
  LARGER = (ELEM =< PREVIOUS),
  util:counting(compare, 2),
  CORRECT = SMALLER and LARGER,
  if CORRECT ->
      util:countread(compare),
      END + 1;
    true ->
      findInsert(ARRAY, START, END - 1, ELEM)
  end.

%% Tauscht ein Element mit einem Anderen in einer Array.
%% Dabei wird ein Zähler für die Tauschforgänge erhöht.
insertAt(ARRAY, POS, CURRENT_POS) when POS == CURRENT_POS ->
  ARRAY;

insertAt(ARRAY, POS, CURRENT_POS) ->
  TEMP_ARRAY = switch(ARRAY, CURRENT_POS - 1, CURRENT_POS),
  util:counting1(swap),
  insertAt(TEMP_ARRAY, POS, CURRENT_POS - 1).

%% Tauscht zwei Element in der array, zwische POS und POS2.
switch(ARRAY, POS, POS2) ->
  TEMP = array:getA(ARRAY, POS),
  TEMP_ARR = array:setA(ARRAY, POS, array:getA(ARRAY, POS2)),
  array:setA(TEMP_ARR, POS2, TEMP).