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
  insertionS(ARRAY, START, END, 1).

insertionS(ARRAY, START, END, CURRENT) when CURRENT > END ->
  ARRAY;

insertionS(ARRAY, START, END, CURRENT) ->
  io:write(END),
  CURR_ELEM = array:getA(ARRAY, CURRENT),
  INSERT_POS = findInsert(ARRAY, START, CURRENT - 1, CURR_ELEM),
  TEMP = insertAt(ARRAY, INSERT_POS, CURRENT),
  io:write(TEMP),
  insertionS(TEMP, START, END, CURRENT + 1).

findInsert(ARRAY, START, END, ELEM) when START > END ->
  START;

findInsert(ARRAY, START, END, ELEM) ->
  LAST = array:getA(ARRAY, END),
  PREVIOUS = array:getA(ARRAY, END + 1),
  SMALLER = (ELEM > LAST),
  LARGER = (ELEM < PREVIOUS),
  CORRECT = SMALLER and LARGER,
  if CORRECT ->
      END + 1;
    true ->
      findInsert(ARRAY, START, END - 1, ELEM)
  end.

insertAt(ARRAY, POS, CURRENT_POS) when POS == CURRENT_POS ->
  ARRAY;

insertAt(ARRAY, POS, CURRENT_POS) ->
  TEMP_ARRAY = switch(ARRAY, CURRENT_POS - 1, CURRENT_POS),
  insertAt(TEMP_ARRAY, POS, CURRENT_POS - 1).

switch(ARRAY, POS, POS2) ->
  TEMP = array:getA(ARRAY, POS),
  TEMP_ARR = array:setA(ARRAY, POS, array:getA(ARRAY, POS2)),
  array:setA(TEMP_ARR, POS2, TEMP).