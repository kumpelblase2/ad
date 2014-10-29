%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Okt 2014 08:32
%%%-------------------------------------------------------------------
-module(queue).
-author("tim_hagemann").

%% API
-export([create/0, dequeue/1, enqueue/2, first/1, transfer/1]).

create() ->
  {stack:create(), stack:create()}.

enqueue({INSTACK, OUTSTACK}, ELEM) ->
  {stack:push(INSTACK, ELEM), OUTSTACK}.

dequeue({INSTACK, OUTSTACK}) ->
  OUTEMPTY = stack:empty(OUTSTACK),
  INEMPTY = stack:empty(INSTACK),
  if
    OUTEMPTY ->
      if
        INEMPTY ->
          {INSTACK, OUTSTACK};
        true ->
          {RES_IN, RES_OUT} = transfer({INSTACK, OUTSTACK}),
          dequeue({RES_IN, RES_OUT})
      end;
    true ->
      {INSTACK, stack:pop(OUTSTACK)}
  end.

first({INSTACK, OUTSTACK}) ->
  OUTEMPTY = stack:empty(OUTSTACK),
  INEMPTY = stack:empty(INSTACK),
  if
    OUTEMPTY ->
      if
        INEMPTY ->
          ok;
        true ->
          {_, RES_OUT} = transfer({INSTACK, OUTSTACK}),
          stack:top(RES_OUT)
      end;
    true ->
      stack:top(OUTSTACK)
  end.

transfer({INSTACK, OUTSTACK}) ->
  INEMPTY = stack:empty(INSTACK),
  if
    INEMPTY ->
      {INSTACK, OUTSTACK};
    true ->
      NEW_OUT = stack:push(OUTSTACK, stack:top(INSTACK)),
      NEW_IN = stack:pop(INSTACK),
      {NEW_IN, NEW_OUT}
  end.