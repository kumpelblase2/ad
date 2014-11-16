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
  RESULT = doMessung(TYPE, RUNS, SIZE, []),
  ok.

doMessung(TYPE, RUNS, SIZE, TEMP) ->
  if RUNS > 20 ->
      ok;
    RUNS > 10 ->
      ok;
    RUNS > 0 ->
      ok;
    true ->
      TEMP
  end,
  ok.