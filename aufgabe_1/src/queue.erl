%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 16. Okt 2014 11:47
%%%-------------------------------------------------------------------
-module(queue).
-author("tim_hagemann").

%% API
-export([create/0, dequeue/1, enqueue/2, first/1, transfer/1]).

create() ->
  {queue, stack:create(), stack:create()}.

enqueue({stack, INSTACK, OUTSTACK}, ELEM) ->
  {stack, stack:push(INSTACK, ELEM), OUTSTACK}.

dequeue({stack, INSTACK, OUTSTACK}) ->
  OUTEMPTY = stack:empty(OUTSTACK),
  INEMPTY = stack:empty(INSTACK),
  if
    OUTEMPTY ->
      if
        INEMPTY ->
          {stack, INSTACK, OUTSTACK};
        true ->
          {RES_IN, RES_OUT} = transfer({INSTACK, OUTSTACK}),
          dequeue({stack, RES_IN, RES_OUT})
      end;
    true ->
      {stack, INSTACK, stack:pop(OUTSTACK)}
  end.

first({stack, INSTACK, OUTSTACK}) ->
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