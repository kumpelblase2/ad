%%%-------------------------------------------------------------------
%%% @author tim_hartig
%%% @copyright (C) 2014, HAW
%%% @doc
%%%
%%% @end
%%% Created : 12. Nov 2014 10:52
%%%-------------------------------------------------------------------
-module(selections).
-author("tim_hartig").

%% REQUIRED MODULES
%% liste.erl
%% array.erl
%% generator.erl
%% util.erl

%% API
-export([selectionS/3]).

%%selectionS() ->
%%  A = {5, {3, {9, {2, {10, {1, {}}}}}}},
%%  selectionS(A, 0, array:laenge(A) - 1).

%% Selection-Sort Algorithmus. Sortiert eine in ARRAY enthaltene Zahlenfolge aufsteigend
%% und schreibt das Ergebnis in eine Datei
selectionS(ARRAY, CurPos, END) when CurPos == END ->
  Swaps = util:countread(swap),
  util:countreset(swap),

  Comparison = util:countread(compare),
  util:countreset(compare),

  generator:saveList(ARRAY),
  { ARRAY, { Swaps, Comparison }};

selectionS(ARRAY, CurPos, END) ->
  MinPos = posOfMin(ARRAY, CurPos, END),
  selectionS(switch(ARRAY, MinPos, CurPos), CurPos + 1, END).



%% Ermittelt die Position des kleinsten Elements innerhalb START und END in ARRAY
%% (Um das gesamte Array anzuwählen --> START = 0 und END = array:laenge(ARRAY) - 1)
posOfMin(ARRAY, START, END) ->
  UBOUND = (array:laenge(ARRAY) - 1),
  if
    END > UBOUND ->
      {error,illegal_end};
    START > END ->
      {error,illegal_start};
    true ->
      INIT_MIN = array:getA(ARRAY, START),
      posOfMin(ARRAY, START, END, {INIT_MIN, START})
  end.

posOfMin(_ARRAY, CurPos, END, {_MinVal, MinPos}) when CurPos > END ->
  MinPos;

posOfMin(ARRAY, CurPos, END, {MinVal, MinPos}) ->
  CurElemVal = array:getA(ARRAY, CurPos),
  util:counting1(compare),
  if
    MinVal > CurElemVal ->
      posOfMin(ARRAY, CurPos + 1, END, {CurElemVal, CurPos});
    true ->
      posOfMin(ARRAY, CurPos + 1, END, {MinVal, MinPos})
  end.

%% Vertauscht die Elemente an den Positionen POS und POS2
switch(ARRAY, POS, POS2) ->
  util:counting1(swap),
  TEMP = array:getA(ARRAY, POS),
  TEMP_ARR = array:setA(ARRAY, POS, array:getA(ARRAY, POS2)),
  array:setA(TEMP_ARR, POS2, TEMP).
