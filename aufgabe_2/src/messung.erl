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

% Type = { all, insertion, selection }
startMessung(all) ->
  SIZE = 100,
  RUNS = 100,
  { INS_SIZE, INS_ALGORITHM, INS_AVERAGE_TIME, INS_AVERAGE_SWAPS, INS_AVERAGE_COMPARISON  } = doMessung(insertion, RUNS, SIZE),
  { SEL_SIZE, SEL_ALGORITHM, SEL_AVERAGE_TIME, SEL_AVERAGE_SWAPS, SEL_AVERAGE_COMPARISON  } = doMessung(selection, RUNS, SIZE),
  INS_DATA = { INS_SIZE, INS_ALGORITHM, INS_AVERAGE_TIME, INS_AVERAGE_SWAPS, INS_AVERAGE_COMPARISON  },
  SEL_DATA = { SEL_SIZE, SEL_ALGORITHM, SEL_AVERAGE_TIME, SEL_AVERAGE_SWAPS, SEL_AVERAGE_COMPARISON  },
  file:write_file("messung.dat", io_lib:format("~p\n~p",[INS_DATA, SEL_DATA])),
  ok;

startMessung(insertion) ->
  SIZE = 100,
  RUNS = 100,
  { INS_SIZE, INS_ALGORITHM, INS_AVERAGE_TIME, INS_AVERAGE_SWAPS, INS_AVERAGE_COMPARISON  } = doMessung(insertion, RUNS, SIZE),
  INS_DATA = { INS_SIZE, INS_ALGORITHM, INS_AVERAGE_TIME, INS_AVERAGE_SWAPS, INS_AVERAGE_COMPARISON  },
  file:write_file("messung.dat", io_lib:format("~p",[INS_DATA])),
  ok;

startMessung(selection) ->
  SIZE = 100,
  RUNS = 100,
  { SEL_SIZE, SEL_ALGORITHM, SEL_AVERAGE_TIME, SEL_AVERAGE_SWAPS, SEL_AVERAGE_COMPARISON  } = doMessung(selection, RUNS, SIZE),
  SEL_DATA = { SEL_SIZE, SEL_ALGORITHM, SEL_AVERAGE_TIME, SEL_AVERAGE_SWAPS, SEL_AVERAGE_COMPARISON  },
  file:write_file("messung.dat", io_lib:format("~p",[SEL_DATA])),
  ok.


doMessung(TYPE, RUNS, SIZE) ->
  doMessung(TYPE, RUNS, SIZE, []).

doMessung(TYPE, RUNS, SIZE, TEMP) ->
  if RUNS > 20 ->
      GEN = generator:sortNum(SIZE, random),
      doMessung(TYPE, RUNS - 1, SIZE, TEMP ++ [execute(TYPE, GEN)]);
    RUNS > 10 ->
      GEN = generator:sortNum(SIZE, ascending),
      doMessung(TYPE, RUNS - 1, SIZE, TEMP ++ [execute(TYPE, GEN)]);
    RUNS > 0 ->
      GEN = generator:sortNum(SIZE, descending),
      doMessung(TYPE, RUNS - 1, SIZE, TEMP ++ [execute(TYPE, GEN)]);
    true ->
      {AVG_TIME, AVG_SWAPS, AVG_COMPARE} = calc_average(TEMP),
      {SIZE, TYPE, AVG_TIME, AVG_SWAPS, AVG_COMPARE}
  end.

execute(insertion, ARR) ->
  {_, _, MicroSecsStart} = now(),
  {_, { SWAPS, COMPARISONS }} = insertions:insertionS(ARR, 0, array:laenge(ARR)),
  {_, _, MicroSecsEnd} = now(),
  RESULT_TIME = MicroSecsEnd - MicroSecsStart,
  {RESULT_TIME, SWAPS, COMPARISONS};

execute(selection, ARR) ->
  {_, _, MicroSecsStart} = now(),
  {_, { SWAPS, COMPARISONS }} = selections:selectionS(ARR, 0, array:laenge(ARR)),
  {_, _, MicroSecsEnd} = now(),
  RESULT_TIME = MicroSecsEnd - MicroSecsStart,
  {RESULT_TIME, SWAPS, COMPARISONS}.

calc_average(DATA) ->
  calc_average(DATA, 0, 0, 0, 0).

calc_average([], ALL_TIME, ALL_SWAPS, ALL_COMPARE, SIZE) ->
  {ALL_TIME / SIZE, ALL_SWAPS / SIZE, ALL_COMPARE / SIZE};

calc_average([{ TIME, SWAPS, COMPARISONS } | TAIL], ALL_TIME, ALL_SWAPS, ALL_COMPARE, SIZE) ->
  calc_average(TAIL, ALL_TIME + TIME, ALL_SWAPS + SWAPS, ALL_COMPARE + COMPARISONS, SIZE + 1).