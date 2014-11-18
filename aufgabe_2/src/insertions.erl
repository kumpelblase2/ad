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
  RESULT = insertionS({ ARRAY, 0, 0 }, START, END, 1),
  { TEMP, _ } = RESULT,
  file:write_file("sortiert.dat", io_lib:format("~p",[TEMP])),
  RESULT.

insertionS({ ARRAY, SWAPS, COMPARISON }, _START, END, CURRENT) when CURRENT > END ->
  { ARRAY, { SWAPS, COMPARISON }};

insertionS({ ARRAY, SWAPS, COMPARISON }, START, END, CURRENT) ->
  CURR_ELEM = array:getA(ARRAY, CURRENT),
  io:write(ARRAY),
  io:nl(),
  { INSERT_POS, COMPARES } = findInsert(ARRAY, START, CURRENT - 1, CURR_ELEM),
  { TEMP, SWAP } = insertAt(ARRAY, INSERT_POS, CURRENT),
  io:write(TEMP),
  io:nl(),
  io:nl(),
  insertionS({ TEMP, SWAPS + SWAP, COMPARES + COMPARISON }, START, END, CURRENT + 1).

findInsert(ARRAY, START, END, ELEM) when START > END ->
  COMPARES = util:countread(compare),
  util:countreset(compare),
  { START, COMPARES };

findInsert(ARRAY, START, END, ELEM) ->
  LAST = array:getA(ARRAY, END),
  PREVIOUS = array:getA(ARRAY, END + 1),
  SMALLER = (ELEM >= LAST),
  LARGER = (ELEM =< PREVIOUS),
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
  { ARRAY, SWAPS };

insertAt(ARRAY, POS, CURRENT_POS) ->
  TEMP_ARRAY = switch(ARRAY, CURRENT_POS - 1, CURRENT_POS),
  util:counting1(swap),
  insertAt(TEMP_ARRAY, POS, CURRENT_POS - 1).

switch(ARRAY, POS, POS2) ->
  TEMP = array:getA(ARRAY, POS),
  TEMP_ARR = array:setA(ARRAY, POS, array:getA(ARRAY, POS2)),
  array:setA(TEMP_ARR, POS2, TEMP).