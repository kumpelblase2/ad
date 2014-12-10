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
-export([compileRequiredModules/0, quicksortRekursiv/3, quicksortRandom/3]).

%% Hauptfunktion f. quicksortRekursiv mit linkestem Element als Pivot
quicksortRekursiv(ARRAY, START, END) ->
	quicksortRekursiv(ARRAY, START, END, START).

%% Aufruf, falls das Ende erreicht bzw. 'ueberschritten' wurde
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

%% Regulaerer Aufruf
quicksortRekursiv(ARRAY, START, END, PIVOT) ->
  %% ARRAY partitionieren
	{PARTITIONED_ARRAY, NEW_PIVOT} = insertPivot(ARRAY, START, END, PIVOT),
  %% Teil, links vom Pivot, des Arrays sortieren
	{ARRAY_WITH_LEFT_PART_SORTED, {LEFT_SWAPS, LEFT_COMPARES}} = quicksortRekursiv(PARTITIONED_ARRAY, START, NEW_PIVOT - 1),
  %% Teil, rechts vom Pivot, des Arrays mit links sortiertem Teil, sortieren
	{SORTED_ARRAY, {RIGHT_SWAPS, RIGHT_COMPARES}} = quicksortRekursiv(ARRAY_WITH_LEFT_PART_SORTED, NEW_PIVOT + 1, END),

  %% Sortiertes Array mit zusammengezaehlten Messdaten zurueckgeben
	{SORTED_ARRAY, {LEFT_SWAPS + RIGHT_SWAPS, LEFT_COMPARES + RIGHT_COMPARES}}.


%% Hauptfunktion f. quicksortRandom mit zufaelligem Pivot
quicksortRandom(ARRAY, START, END) ->
	quicksortRandom(ARRAY, START, END, randomPivot(START, END)).

%% Aufruf, falls das Ende erreicht oder 'ueberschritten' wurde:
%% Das sortierte Array und die Messdaten werden zurueckgegeben
quicksortRandom(ARRAY, START, END, _PIVOT) when (END - START) < 1 ->
	SWAPS = util:countread(swap),
	COMPARISON = util:countread(compare),
	util:countreset(swap),
	util:countreset(compare),
	{ARRAY, {SWAPS, COMPARISON}};

%% Aufruf fuer Arrays bzw. Bereichen mit weniger als 12 Elementen
%% => Sortierung des Teils wird mit Selection-Sort durchgefuehrt
quicksortRandom(ARRAY, START, END, _PIVOT) when (END - START) < 12 ->
	{SORTED_ARRAY, {SWAPS_SEL, COMPARES_SEL}} = selections:selectionS(ARRAY, START, END),
	SWAPS = util:countread(swap),
	COMPARISON = util:countread(compare),
	util:countreset(swap),
	util:countreset(compare),
	{SORTED_ARRAY, {SWAPS + SWAPS_SEL, COMPARISON + COMPARES_SEL}};

%% Regulaerer Aufruf
quicksortRandom(ARRAY, START, END, PIVOT) ->
  %% ARRAY partitionieren
	{PARTITIONED_ARRAY, NEW_PIVOT} = insertPivot(ARRAY, START, END, PIVOT),

	if% Falls nach der Partitionierung das Pivot...
    % ...an das Ende gerueckt wurde...
		NEW_PIVOT == END ->
      % ...muss 'nur' der Teil links vom Pivot uebergeben werden (ein lokaler worst case)...
			{ ARRAY_WITH_LEFT_PART_SORTED, {LEFT_SWAPS, LEFT_COMPARES}} = quicksortRandom(PARTITIONED_ARRAY, START, NEW_PIVOT - 1),
			% ...und fuer den fiktiven, rechten Teil werden die Swaps und Compares auf 0 gesetzt
      { SORTED_ARRAY, {RIGHT_SWAPS, RIGHT_COMPARES}} = {ARRAY_WITH_LEFT_PART_SORTED, { 0, 0 } };

    % ...an den Anfang gerueckt wurde...
		NEW_PIVOT == START ->
      % ...werden fuer den fiktiven, linken Teil Swaps und Compares auf 0 gesetzt und...
			{ ARRAY_WITH_LEFT_PART_SORTED, {LEFT_SWAPS, LEFT_COMPARES}} = {PARTITIONED_ARRAY, { 0, 0 } },
      % ...es muss 'nur' der Teil rechts vom Pivot uebergeben werden (ein lokaler worst case)
			{ SORTED_ARRAY, {RIGHT_SWAPS, RIGHT_COMPARES}} = quicksortRandom(ARRAY_WITH_LEFT_PART_SORTED, NEW_PIVOT + 1, END);

    % ...zwischen Anfang und Ende gerueckt wurde...
		true ->
      % ...wird erst der Teil links vom Pivot sortiert...
			{ ARRAY_WITH_LEFT_PART_SORTED, {LEFT_SWAPS, LEFT_COMPARES}} = quicksortRandom(PARTITIONED_ARRAY, START, NEW_PIVOT - 1),
      % ...und anschließend der rechte Teile des Arrays mit links sortiertem Teil sortiert
			{ SORTED_ARRAY, {RIGHT_SWAPS, RIGHT_COMPARES}} = quicksortRandom(ARRAY_WITH_LEFT_PART_SORTED, NEW_PIVOT + 1, END)
	end,

  % Sortiertes Array mit zusammengezaehlten Messdaten zurueckgeben
	{ SORTED_ARRAY, { LEFT_SWAPS + RIGHT_SWAPS, LEFT_COMPARES + RIGHT_COMPARES}}.


%% Partitioniert das ARRAY, indem es das Pivot an die korrekte Stelle im ARRAY einrueckt
%% (Hauptfunktion)
insertPivot(ARRAY, START, END, PIVOT) ->
	insertPivot(ARRAY, START, END, PIVOT, []).

%% Abbruch
insertPivot(ARRAY, CURPOS, END, PIVOT, OPEN_CARDS) when CURPOS > END ->
	if
    % Falls keine Karten offen sind...
		OPEN_CARDS == [] ->
      % ...wird Pivot mit Element am Ende getauscht
			RESULT = swap(ARRAY, PIVOT, END),
			{RESULT, END};

    % Falls es offene Karten gibt...
		true ->
      % ...hole die erste Karte
			[FIRST_OPEN_CARD | _] = OPEN_CARDS,
      % und die Position der letzten geschlossenen Karte
			LAST_CLOSED_CARD = FIRST_OPEN_CARD - 1,

			if
			%% Ist das Pivot unter den offenen Karten...
				PIVOT > FIRST_OPEN_CARD ->
					%% ...tausche es mit der ersten offenen Karte
					RESULT = swap(ARRAY, PIVOT, FIRST_OPEN_CARD),
					NEW_POS = FIRST_OPEN_CARD;

			%% Liegt das Pivot vor der letzten geschlossenen Karte...
				PIVOT < LAST_CLOSED_CARD ->
					%% ...tausche es mit der letzten geschlossenen Karte
					RESULT = swap(ARRAY, PIVOT, LAST_CLOSED_CARD),
					NEW_POS = LAST_CLOSED_CARD;

			%% Liegt das Pivot bereits an der richtigen Stelle...
				true ->
          % dann ist alles prima und das Array kann so weitergegeben werden
					RESULT = ARRAY,
					NEW_POS = PIVOT
			end,
			{RESULT, NEW_POS}
	end;

%% Sind Start und Pivot an der gleichen Stelle,
%% rueckt der Start um eine Stelle nach rechts weiter
insertPivot(ARRAY, CURPOS, END, PIVOT, OPEN) when CURPOS == PIVOT ->
	insertPivot(ARRAY, CURPOS + 1, END, PIVOT, OPEN);

%% Regulaerer Aufruf
insertPivot(ARRAY, CURPOS, END, PIVOT, OPEN_CARDS) ->
	%% OPEN_CARDS: "Open-Cards-List" - enthaelt die Positionen aller Elemente, die groesser als das Pivot sind

  %% Wert des Pivotelements ermitteln
  PIVOT_VALUE = array:getA(ARRAY, PIVOT),
  %% Wert des Elements an aktueller Position ermitteln
	CURPOS_VALUE = array:getA(ARRAY, CURPOS),
	util:counting1(compare),
	if
    %% Falls das Element an aktueller Position kleiner als das Pivot ist...
		CURPOS_VALUE < PIVOT_VALUE ->
			if
        %% ...und keine "Karten" mehr offen sind,...
				OPEN_CARDS == [] ->
          %% ...gehe eine Position weiter
					insertPivot(ARRAY, CURPOS + 1, END, PIVOT, OPEN_CARDS);
				true ->
          %% ...teile die Liste aufgedeckter "Karten" auf (TO_SWAP: Zu tauschendes Element)
					[ TO_SWAP | REST ] = OPEN_CARDS,
          %% Tausche die Elemente
          TEMP = swap(ARRAY, CURPOS, TO_SWAP),
          %% fuege Element von aktueller Position ans Ende der Open-Cards-List an
					insertPivot(TEMP, CURPOS + 1, END, PIVOT, REST ++ [CURPOS])
			end;
    %% Falls das Element an aktueller Position nicht kleiner als das Pivot ist...
		true ->
      %% ...fuege das Element ans Ende der Open-Cards-List an...
      %% ...und gehe einen Schritt weiter
			insertPivot(ARRAY, CURPOS + 1, END, PIVOT, OPEN_CARDS ++ [CURPOS])
	end.

%% Wahl einer zufaelligen Position innerhalb des vorgegebenen Bereichs, die als Pivot fungieren soll
randomPivot(START, END) ->
	if
		(END - START) =< 1 ->
			START;
		true ->
			random:seed(now()),
			random:uniform(END - START + 1) + START - 1
	end.

%% Vertauscht die Elemente an den Positionen POS und POS2
swap(ARRAY, POS, POS2) ->
	util:counting1(swap),
	TEMP = array:getA(ARRAY, POS),
	TEMP_ARR = array:setA(ARRAY, POS, array:getA(ARRAY, POS2)),
	array:setA(TEMP_ARR, POS2, TEMP).

compileRequiredModules() ->
  compile:file('liste.erl'),
  compile:file('array.erl'),
  compile:file('generator.erl'),
  compile:file('util.erl'),
  compile:file('selections.erl').