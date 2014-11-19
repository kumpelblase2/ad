%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 12. Nov 2014 10:53
%%%-------------------------------------------------------------------
-module(messung).
-author("tim_hagemann").

%% API
-export([run/0, startMessung/1]).

run() ->
  startMessung(all).

% Startet eine Messung für eine bestimmte Auswahl von Algorithmen.
% Type = { all, insertion, selection }
startMessung(all) ->
  SIZE = 100,
  RUNS = 100,
  {_, SecsStart, MicroSecsStart} = now(),
  { INS_SIZE, INS_ALGORITHM, INS_AVERAGE_TIME, INS_AVERAGE_SWAPS, INS_AVERAGE_COMPARISON  } = doMessung(insertion, RUNS, SIZE),
  { SEL_SIZE, SEL_ALGORITHM, SEL_AVERAGE_TIME, SEL_AVERAGE_SWAPS, SEL_AVERAGE_COMPARISON  } = doMessung(selection, RUNS, SIZE),
  INS_DATA = { INS_SIZE, INS_ALGORITHM, INS_AVERAGE_TIME, INS_AVERAGE_SWAPS, INS_AVERAGE_COMPARISON  },
  SEL_DATA = { SEL_SIZE, SEL_ALGORITHM, SEL_AVERAGE_TIME, SEL_AVERAGE_SWAPS, SEL_AVERAGE_COMPARISON  },
  file:write_file("messung.dat", io_lib:format("~p\n~p\n",[INS_DATA, SEL_DATA]), [append]),
  {_, SecsEnd, MicroSecsEnd} = now(),
  RESULT_TIME = (SecsEnd - SecsStart) * 1000 + (MicroSecsEnd - MicroSecsStart) / 1000,
  io:write(io:format("Run took: ~p ms", [RESULT_TIME])),
  ok;

startMessung(insertion) ->
  SIZE = 100,
  RUNS = 100,
  {_, SecsStart, MicroSecsStart} = now(),
  { INS_SIZE, INS_ALGORITHM, INS_AVERAGE_TIME, INS_AVERAGE_SWAPS, INS_AVERAGE_COMPARISON  } = doMessung(insertion, RUNS, SIZE),
  INS_DATA = { INS_SIZE, INS_ALGORITHM, INS_AVERAGE_TIME, INS_AVERAGE_SWAPS, INS_AVERAGE_COMPARISON  },
  file:write_file("messung.dat", io_lib:format("~p",[INS_DATA])),
  {_, SecsEnd, MicroSecsEnd} = now(),
  RESULT_TIME = (SecsEnd - SecsStart) * 1000 + (MicroSecsEnd - MicroSecsStart) / 1000,
  io:write(io:format("Run took: ~p ms", [RESULT_TIME])),
  ok;

startMessung(selection) ->
  SIZE = 100,
  RUNS = 100,
  {_, SecsStart, MicroSecsStart} = now(),
  { SEL_SIZE, SEL_ALGORITHM, SEL_AVERAGE_TIME, SEL_AVERAGE_SWAPS, SEL_AVERAGE_COMPARISON  } = doMessung(selection, RUNS, SIZE),
  SEL_DATA = { SEL_SIZE, SEL_ALGORITHM, SEL_AVERAGE_TIME, SEL_AVERAGE_SWAPS, SEL_AVERAGE_COMPARISON  },
  file:write_file("messung.dat", io_lib:format("~p",[SEL_DATA])),
  {_, SecsEnd, MicroSecsEnd} = now(),
  RESULT_TIME = (SecsEnd - SecsStart) * 1000 + (MicroSecsEnd - MicroSecsStart) / 1000,
  io:write(io:format("Run took: ~p ms", [RESULT_TIME])),
  ok.


% Führt eine Messung für eine bestimmte Anzahl Durchläufen und einer Listengröße durch.
% Als Rückgabe gibt es die Größe und Typ, als auch die durchschnittliche Zeit, Täusche und Vergleiche.
doMessung(TYPE, RUNS, SIZE) ->
  doMessung(TYPE, RUNS, SIZE, []).

doMessung(TYPE, RUNS, SIZE, TEMP) ->
  if RUNS > 20 ->
      generator:sortNum(SIZE, random),
      GEN = generator:readList(),
      doMessung(TYPE, RUNS - 1, SIZE, TEMP ++ [execute(TYPE, GEN)]);
    RUNS > 10 ->
      generator:sortNum(SIZE, ascending),
      GEN = generator:readList(),
      doMessung(TYPE, RUNS - 1, SIZE, TEMP ++ [execute(TYPE, GEN)]);
    RUNS > 0 ->
      generator:sortNum(SIZE, descending),
      GEN = generator:readList(),
      doMessung(TYPE, RUNS - 1, SIZE, TEMP ++ [execute(TYPE, GEN)]);
    true ->
      {AVG_TIME, AVG_SWAPS, AVG_COMPARE} = calc_average(TEMP),
      {SIZE, TYPE, AVG_TIME, AVG_SWAPS, AVG_COMPARE}
  end.

% Führ einen einzenen durchlauf auf einer Liste durch und nimmt Zeit, Täusche und Vergleiche auf.
execute(insertion, ARR) ->
  {_, SecsStart, MicroSecsStart} = now(),
  {_, { SWAPS, COMPARISONS }} = insertions:insertionS(ARR, 0, array:laenge(ARR) - 1),
  {_, SecsEnd, MicroSecsEnd} = now(),
  RESULT_TIME = (SecsEnd - SecsStart) * 1000 + (MicroSecsEnd - MicroSecsStart) / 1000,
  {RESULT_TIME, SWAPS, COMPARISONS};

execute(selection, ARR) ->
  {_, SecsStart, MicroSecsStart} = now(),
  {_, { SWAPS, COMPARISONS }} = selections:selectionS(ARR, 0, array:laenge(ARR) - 1),
  {_, SecsEnd, MicroSecsEnd} = now(),
  RESULT_TIME = (SecsEnd - SecsStart) * 1000 + (MicroSecsEnd - MicroSecsStart) / 1000,
  {RESULT_TIME, SWAPS, COMPARISONS}.

% Berechnet die durchschnitts Werte der Messungen.
calc_average(DATA) ->
  calc_average(DATA, 0, 0, 0, 0).

calc_average([], ALL_TIME, ALL_SWAPS, ALL_COMPARE, SIZE) ->
  {ALL_TIME / SIZE, ALL_SWAPS / SIZE, ALL_COMPARE / SIZE};

calc_average([{ TIME, SWAPS, COMPARISONS } | TAIL], ALL_TIME, ALL_SWAPS, ALL_COMPARE, SIZE) ->
  calc_average(TAIL, ALL_TIME + TIME, ALL_SWAPS + SWAPS, ALL_COMPARE + COMPARISONS, SIZE + 1).