%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Okt 2014 08:32
%%%-------------------------------------------------------------------
-module(schlange).
-author("tim_hagemann").

%% API
-export([create/0, dequeue/1, enqueue/2, first/1, transfer/1]).

% Erstellt eine leere Queue.
create() ->
  {stack:create(), stack:create()}.

% Fuegt ein Element an das Ende der Queue an und gibt sie zurueck.
enqueue({INSTACK, OUTSTACK}, ELEM) ->
  {stack:push(INSTACK, ELEM), OUTSTACK}.      % Element auf dem INSTACK ablegen

% Loescht das erste Element aus der Queue.
dequeue({INSTACK, OUTSTACK}) ->
  OUTEMPTY = stack:empty(OUTSTACK),
  INEMPTY = stack:empty(INSTACK),
  if
    OUTEMPTY ->
      if
        INEMPTY ->                                            % OUTSTACK und INSTACK sind leer
          {INSTACK, OUTSTACK};                                % Queue ist leer => Queue zurückgeben, wie erhalten.
        true ->                                               % OUTSTACK ist leer und INSTACK ist -nicht- leer
          {RES_IN, RES_OUT} = transfer({INSTACK, OUTSTACK}),  % => INSTACK umschichten
          dequeue({RES_IN, RES_OUT})                          % rek. Aufruf.
      end;
    true ->
      {INSTACK, stack:pop(OUTSTACK)}
  end.

% Gibt das erste Element aus der Queue zurueck.
first({INSTACK, OUTSTACK}) ->
  OUTEMPTY = stack:empty(OUTSTACK),
  INEMPTY = stack:empty(INSTACK),
  if
    OUTEMPTY ->
      if
        INEMPTY ->                                      % OUTSTACK und INSTACK sind leer
          null;                                         % => Queue ist leer: Null-Element zurueckgeben
        true ->                                         % Keine Elemente im OUTSTACK, aber im INSTACK enthalten
          {_, RES_OUT} = transfer({INSTACK, OUTSTACK}), % => INSTACK umschichten
          stack:top(RES_OUT)                            % und oberstes Element des OUTSTACKs zurueckgeben
      end;
    true ->                                             % Elemente im OUTSTACK enthalten
      stack:top(OUTSTACK)                               % Oberstes Element des OUTSTACKs zurueckgeben
  end.

% Schichtet alle Elemente des INSTACKs in den OUTSTACK um
transfer({INSTACK, OUTSTACK}) ->
  INEMPTY = stack:empty(INSTACK),
  if
    INEMPTY ->                                            % Falls keine Elemente im INSTACK zum umschichten
      {INSTACK, OUTSTACK};                                % Queue zurueckgeben, wie erhalten.
    true ->
      NEW_OUT = stack:push(OUTSTACK, stack:top(INSTACK)), % Oberstes Elem vom INSTACK auf den OUTSTACK legen
      NEW_IN = stack:pop(INSTACK),                        % und vom INSTACK loeschen
      transfer({NEW_IN, NEW_OUT})
  end.