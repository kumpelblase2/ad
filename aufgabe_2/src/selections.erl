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

%% API
-export([selectionS/3]).
selectionS(ARRAY, START, END) ->
  SMALLEST_INDEX = findSmallest(ARRAY, START, END),
  selectionS(switch(ARRAY, START, SMALLEST_INDEX), START + 1, END).

findSmallest(ARRAY, START, END) ->
  findSmallest(ARRAY, START, END, 0).

findSmallest(_, START, END, CURRENT) when START > END ->
  CURRENT;

findSmallest(ARRAY, START, END, CURRENT) ->
  NEXT = array:getA(ARRAY, START),
  if NEXT > CURRENT ->
    findSmallest(ARRAY, START + 1, END, START);
    true ->
      findSmallest(ARRAY, START + 1, END, CURRENT)
  end.

switch(ARRAY, FIRST, SECOND) ->
  TEMP = array:getA(ARRAY, FIRST),
  FIRST_SWAP = array:setA(ARRAY, FIRST, array:getA(ARRAY, SECOND)),
  RESULT = array:setA(FIRST_SWAP, SECOND, TEMP),
  RESULT.