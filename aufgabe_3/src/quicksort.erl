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

%% Hauptfunktion f. quicksortRekursiv
quicksortRekursiv(ARRAY, START, END) ->
	quicksortRekursiv(ARRAY, START, END, START).


quicksortRekursiv(ARRAY, START, END, _PIVOT) when (END - START) < 1 ->
	SWAPS = util:countread(swap),
	COMPARISON = util:countread(compare),
	util:countreset(swap),
	util:countreset(compare),
	{ARRAY, {SWAPS, COMPARISON}};

%% Falls das uebergebene Array weniger als 12 Elemente hat,
%% wird es mit SelectionSort sortiert
%% und das sortierte Array zurueckgegeben
quicksortRekursiv(ARRAY, START, END, _PIVOT) when (END - START) < 12 ->
	{ TEMP, { SWAP_SEL, COMPARE_SEL }} = selections:selectionS(ARRAY, START, END),
	SWAPS = util:countread(swap),
	COMPARISON = util:countread(compare),
	util:countreset(swap),
	util:countreset(compare),
	{ TEMP, { SWAPS + SWAP_SEL, COMPARISON + COMPARE_SEL }};

%%
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
	
	

%% Hauptfunktion
%% Sortiert den Pivot an der korrekten Stelle im Array ein
insertPivot(ARRAY, START, END, PIVOT) ->
	insertPivot(ARRAY, START, END, PIVOT, []).

%% Abbruch
insertPivot(ARRAY, START, END, PIVOT, OPEN) when START == END ->
	[LAST_OPEN | _] = OPEN,
	TO_SWAP = LAST_OPEN - 1,
	RESULT = swap(ARRAY, PIVOT, TO_SWAP),
	{RESULT, TO_SWAP};

%% Sind Start und Pivot an der gleichen Stelle,
%% rueckt der Start um eine Stelle nach rechts weiter
insertPivot(ARRAY, START, END, PIVOT, OPEN) when START == PIVOT ->
	insertPivot(ARRAY, START + 1, END, PIVOT, OPEN);

%%
insertPivot(ARRAY, START, END, PIVOT, OPEN) ->
	PIVOT_VALUE = array:getA(ARRAY, PIVOT), %% Wert des Pivotelements ermitteln
	START_VALUE = array:getA(ARRAY, START), %% Wert des Elements an Startposition ermitteln
	util:counting1(compare),
	if
		START_VALUE < PIVOT_VALUE -> %% Falls das Element bei Start kleiner ist, als das Pivotelement
			if
				OPEN == [] ->  %% sind keine "Karten" mehr offen,
					insertPivot(ARRAY, START + 1, END, PIVOT, OPEN);  %% gehe eine Position weiter
				true ->
					[ TO_SWAP | REST ] = OPEN, %% Aufteilung von Liste aufgedeckter "Karten" -> TO_SWAP: Zu tauschendes Element
          TEMP = swap(ARRAY, START, TO_SWAP), %% Tausche
					insertPivot(TEMP, START + 1, END, PIVOT, REST ++ [START])
			end;
		true -> %%
			insertPivot(ARRAY, START + 1, END, PIVOT, OPEN ++ [START])
	end.
	
randomPivot(START, END) ->
	random:uniform(END - START + 1) + START - 1.
	
%% Tauscht zwei Element in der array, zwische POS und POS2.
swap(ARRAY, POS, POS2) ->
	util:counting1(swap),
	TEMP = array:getA(ARRAY, POS),
	TEMP_ARR = array:setA(ARRAY, POS, array:getA(ARRAY, POS2)),
	array:setA(TEMP_ARR, POS2, TEMP).