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
  %% ARRAY partitionieren
	{ARRAY_WITH_CORRECT_PIVOT, NEW_PIVOT } = insertPivot(ARRAY, START, END, PIVOT),
  %% Linkes Teilarray von ARRAY an rekursiven Aufruf uebergeben
	{ SORTED_LEFT, { LEFT_SWAP, LEFT_COMPARE }} = quicksortRekursiv(ARRAY_WITH_CORRECT_PIVOT, START, NEW_PIVOT - 1),
	{ RESULT, { RIGHT_SWAP, RIGHT_COMPARE }} = quicksortRekursiv(SORTED_LEFT, NEW_PIVOT + 1, END),
	{ RESULT, { LEFT_SWAP + RIGHT_SWAP, LEFT_COMPARE + RIGHT_COMPARE }}.



	
quicksortRandom(ARRAY, START, END) ->
	if
		(START - END) < 1 ->
			quicksortRandom(ARRAY, START, END, 0);
		true ->
			PIVOT = randomPivot(START, END),
			io:write(PIVOT), io:nl(),
			quicksortRandom(ARRAY, START, END, PIVOT)
	end.

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
	if
		NEW_PIVOT == END ->
			{ SORTED_LEFT, { LEFT_SWAP, LEFT_COMPARE }} = quicksortRandom(TEMP, START, NEW_PIVOT - 1),
			{ RESULT, { RIGHT_SWAP, RIGHT_COMPARE }} = { SORTED_LEFT, { 0, 0 } };
		NEW_PIVOT == START ->
			{ SORTED_LEFT, { LEFT_SWAP, LEFT_COMPARE }} = { TEMP, { 0, 0 } },
			{ RESULT, { RIGHT_SWAP, RIGHT_COMPARE }} = quicksortRandom(SORTED_LEFT, NEW_PIVOT + 1, END);
		true ->
			{ SORTED_LEFT, { LEFT_SWAP, LEFT_COMPARE }} = quicksortRandom(TEMP, START, NEW_PIVOT - 1),
			{ RESULT, { RIGHT_SWAP, RIGHT_COMPARE }} = quicksortRandom(SORTED_LEFT, NEW_PIVOT + 1, END)
	end,
	{ RESULT, { LEFT_SWAP + RIGHT_SWAP, LEFT_COMPARE + RIGHT_COMPARE }}.


%% Hauptfunktion
%% Sortiert den Pivot an der korrekten Stelle im Array ein
insertPivot(ARRAY, START, END, PIVOT) ->
	insertPivot(ARRAY, START, END, PIVOT, []).

%% Abbruch
insertPivot(ARRAY, CURPOS, END, PIVOT, OPEN_CARDS) when CURPOS > END ->
	if
		OPEN_CARDS == [] ->
			RESULT = swap(ARRAY, PIVOT, END),
			{RESULT, END};
		true ->
			[FIRST_OPEN_CARD | _] = OPEN_CARDS,
			LAST_CLOSED_CARD = FIRST_OPEN_CARD - 1, %% Position der letzten geschlossenen Karte

			if
			%% liegt das Pivot innerhalb der offenen Karten
				PIVOT > FIRST_OPEN_CARD ->
					%% tausche es mit der ersten offenen Karte
					RESULT = swap(ARRAY, PIVOT, FIRST_OPEN_CARD),
					NEW_POS = FIRST_OPEN_CARD;

			%% liegt das Pivot vor der letzten geschlossenen Karte
				PIVOT < LAST_CLOSED_CARD ->
					%% tausche es mit der letzten geschlossenen Karte
					RESULT = swap(ARRAY, PIVOT, LAST_CLOSED_CARD),
					NEW_POS = LAST_CLOSED_CARD;

			%% liegt das Pivot bereits an der richtigen Stelle
				true ->
					RESULT = ARRAY,
					NEW_POS = PIVOT
			end,
			{RESULT, NEW_POS}
	end;

%% Sind Start und Pivot an der gleichen Stelle,
%% rueckt der Start um eine Stelle nach rechts weiter
insertPivot(ARRAY, CURPOS, END, PIVOT, OPEN) when CURPOS == PIVOT ->
	insertPivot(ARRAY, CURPOS + 1, END, PIVOT, OPEN);

%%
insertPivot(ARRAY, CURPOS, END, PIVOT, OPEN_CARDS) ->
	%% OPEN: "Open-Cards-List" - enthaelt die Positionen aller Elemente, die groesser als das Pivot sind

  PIVOT_VALUE = array:getA(ARRAY, PIVOT), %% Wert des Pivotelements ermitteln
	CURPOS_VALUE = array:getA(ARRAY, CURPOS), %% Wert des Elements an aktueller Position ermitteln
	util:counting1(compare),
	if
		CURPOS_VALUE < PIVOT_VALUE -> %% Falls das Element an aktueller Position kleiner ist, als das Pivotelement
			if
				OPEN_CARDS == [] ->  %% und keine "Karten" mehr offen sind,
					insertPivot(ARRAY, CURPOS + 1, END, PIVOT, OPEN_CARDS);  %% gehe eine Position weiter
				true ->
					[ TO_SWAP | REST ] = OPEN_CARDS, %% teile die Liste aufgedeckter "Karten" auf -> TO_SWAP: Zu tauschendes Element
          TEMP = swap(ARRAY, CURPOS, TO_SWAP), %% Tausche die Elemente
					insertPivot(TEMP, CURPOS + 1, END, PIVOT, REST ++ [CURPOS]) %% fuege Element von aktueller Position
                                                                      %% ans Ende der Open-Cards-List an
			end;
		true -> %% wenn Element bei aktueller Position nicht kleiner ist
			insertPivot(ARRAY, CURPOS + 1, END, PIVOT, OPEN_CARDS ++ [CURPOS]) %% fuege Element von aktueller Position
                                                                         %% ans Ende der Open-Cards-List an
	end.
	
randomPivot(START, END) ->
	random:uniform(END - START + 1) + START - 1.

%% Vertauscht die Elemente an den Positionen POS und POS2
swap(ARRAY, POS, POS2) ->
	util:counting1(swap),
	TEMP = array:getA(ARRAY, POS),
	TEMP_ARR = array:setA(ARRAY, POS, array:getA(ARRAY, POS2)),
	array:setA(TEMP_ARR, POS2, TEMP).