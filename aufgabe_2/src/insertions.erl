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

%% API
-export([insertionS/3]).

insertionS(ARRAY, START, END) ->
  insertionS({ ARRAY, 0, 0 }, START, END, 1).

insertionS({ ARRAY, SWAPS, COMPARISON }, _START, END, CURRENT) when CURRENT > END ->
  generator:saveList(ARRAY),
  { ARRAY, { SWAPS, COMPARISON }};

insertionS({ ARRAY, SWAPS, COMPARISON }, START, END, CURRENT) ->
  CURR_ELEM = array:getA(ARRAY, CURRENT),
  { INSERT_POS, COMPARES } = findInsert(ARRAY, START, CURRENT - 1, CURR_ELEM),
  { TEMP, SWAP } = insertAt(ARRAY, INSERT_POS, CURRENT),
  insertionS({ TEMP, SWAPS + SWAP, COMPARES + COMPARISON }, START, END, CURRENT + 1).

findInsert(ARRAY, START, END, ELEM) when START > END ->
  COMPARES = util:countread(compare),
  util:countreset(compare),
  { START, COMPARES };

findInsert(ARRAY, START, END, ELEM) ->
  LAST = array:getA(ARRAY, END),
  PREVIOUS = array:getA(ARRAY, END + 1),
  SMALLER = (ELEM > LAST),
  LARGER = (ELEM < PREVIOUS),
  util:counting(compare, 2),
  CORRECT = SMALLER and LARGER,
  if CORRECT ->
      COMPARES = util:countread(compare),
      util:countreset(compare),
      { END + 1, COMPARES };
    true ->
      findInsert(ARRAY, START, END - 1, ELEM)
  end.

insertAt(ARRAY, POS, CURRENT_POS) when POS == CURRENT_POS ->
  SWAPS = util:countread(swap),
  util:countreset(swap),
  { ARRAY, SWAPS};

insertAt(ARRAY, POS, CURRENT_POS) ->
  TEMP_ARRAY = switch(ARRAY, CURRENT_POS - 1, CURRENT_POS),
  util:counting1(swap),
  insertAt(TEMP_ARRAY, POS, CURRENT_POS - 1).

switch(ARRAY, POS, POS2) ->
  TEMP = array:getA(ARRAY, POS),
  TEMP_ARR = array:setA(ARRAY, POS, array:getA(ARRAY, POS2)),
  array:setA(TEMP_ARR, POS2, TEMP).