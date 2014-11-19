%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, HAW
%%% @doc
%%%
%%% @end
%%% Created : 12. Nov 2014 10:52
%%%-------------------------------------------------------------------
-module(quicksort).
-author("tim_hagemann").

%% REQUIRED MODULES
%% liste.erl
%% array.erl
%% generator.erl
%% util.erl
%% selections.erl

%% API
-export([quicksortRekursiv/3, quicksortRandom/3]).

quicksortRekursiv(ARRAY, START, END) ->
	quicksortRekursiv(ARRAY, START, END, START).
	
quicksortRekursiv(ARRAY, START, END, _PIVOT) when (END - START) < 1 ->
	SWAPS = util:countread(swap),
	COMPARISON = util:countread(compare),
	util:countreset(swap),
	util:countreset(compare),
	{ARRAY, {SWAPS, COMPARISON}};
	
quicksortRekursiv(ARRAY, START, END, _PIVOT) when (END - START) < 12 ->
	{ TEMP, { SWAP_SEL, COMPARE_SEL }} = selections:selectionS(ARRAY, START, END),
	SWAPS = util:countread(swap),
	COMPARISON = util:countread(compare),
	util:countreset(swap),
	util:countreset(compare),
	{ TEMP, { SWAPS + SWAP_SEL, COMPARISON + COMPARE_SEL }};
	
quicksortRekursiv(ARRAY, START, END, PIVOT) ->
	{ TEMP, NEW_PIVOT } = insertPivot(ARRAY, START, END, PIVOT),
	{ SORTED_LEFT, { LEFT_SWAP, LEFT_COMPARE }} = quicksortRekursiv(TEMP, START, NEW_PIVOT - 1),
	{ RESULT, { RIGHT_SWAP, RIGHT_COMPARE }} = quicksortRekursiv(SORTED_LEFT, NEW_PIVOT + 1, END),
	{ RESULT, { LEFT_SWAP + RIGHT_SWAP, LEFT_COMPARE + RIGHT_COMPARE }}.
	
	
	
quicksortRandom(ARRAY, START, END) ->
	quicksortRandom(ARRAY, START, END, randomPivot(START, END)).
	
quicksortRandom(ARRAY, START, END, _PIVOT) when (END - START) < 1 ->
	SWAPS = util:countread(swap),
	COMPARISON = util:countread(compare),
	util:countreset(swap),
	util:countreset(compare),
	{ARRAY, {SWAPS, COMPARISON}};
	
quicksortRandom(ARRAY, START, END, _PIVOT) when (END - START) < 12 ->
	{TEMP, {SWAP_SEL, COMPARE_SEL}} = selections:selectionS(ARRAY, START, END),
	SWAPS = util:countread(swap),
	COMPARISON = util:countread(compare),
	util:countreset(swap),
	util:countreset(compare),
	{TEMP, {SWAPS + SWAP_SEL, COMPARISON + COMPARE_SEL}};
	
quicksortRandom(ARRAY, START, END, PIVOT) ->
	{TEMP, NEW_PIVOT} = insertPivot(ARRAY, START, END, PIVOT),
	{ SORTED_LEFT, { LEFT_SWAP, LEFT_COMPARE }} = quicksortRandom(TEMP, START, NEW_PIVOT - 1),
	{ RESULT, { RIGHT_SWAP, RIGHT_COMPARE }} = quicksortRandom(SORTED_LEFT, NEW_PIVOT + 1, END),
	{ RESULT, { LEFT_SWAP + RIGHT_SWAP, LEFT_COMPARE + RIGHT_COMPARE }}.
	
	

	
insertPivot(ARRAY, START, END, PIVOT) ->
	insertPivot(ARRAY, START, END, PIVOT, []).
	
insertPivot(ARRAY, START, END, PIVOT, OPEN) when START == END ->
	[LAST_OPEN | _] = OPEN,
	io:write(OPEN), io:nl(),
	TO_SWAP = LAST_OPEN - 1,
	RESULT = swap(ARRAY, PIVOT, TO_SWAP),
	{RESULT, TO_SWAP};
	
insertPivot(ARRAY, START, END, PIVOT, OPEN) when START == PIVOT ->
	insertPivot(ARRAY, START + 1, END, PIVOT, OPEN);
	
insertPivot(ARRAY, START, END, PIVOT, OPEN) ->
	PIVOT_VALUE = array:getA(ARRAY, PIVOT),
	NEXT = array:getA(ARRAY, START),
	util:counting1(compare),
	if
		NEXT < PIVOT_VALUE ->
			if
				OPEN == [] ->
					insertPivot(ARRAY, START + 1, END, PIVOT, OPEN);
				true ->
					[ TO_SWAP | REST ] = OPEN,
					TEMP = swap(ARRAY, START, TO_SWAP),
					insertPivot(TEMP, START + 1, END, PIVOT, [START] ++ REST)
			end;
		true ->
			insertPivot(ARRAY, START + 1, END, PIVOT, OPEN ++ [START])
	end.
	
randomPivot(START, END) ->
	io:write(START), io:nl(), io:write(END), io:nl(),
	RESULT = random:uniform(END - START + 1) + START - 1,
	io:write(RESULT),
	io:nl(),
	RESULT.
	
%% Tauscht zwei Element in der array, zwische POS und POS2.
swap(ARRAY, POS, POS2) ->
	util:counting1(swap),
	TEMP = array:getA(ARRAY, POS),
	TEMP_ARR = array:setA(ARRAY, POS, array:getA(ARRAY, POS2)),
	array:setA(TEMP_ARR, POS2, TEMP).