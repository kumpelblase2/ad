%%%-------------------------------------------------------------------
%%% @author tim_hartig
%%% @copyright (C) 2014, HAW
%%% @doc
%%%
%%% @end
%%% Created : 12. Nov 2014 10:53
%%%-------------------------------------------------------------------
-module(generator).
-author("tim_hartig").

%% API
-export([sortNum/2, sortNum/3, readList/0, saveList/1]).

%% Generiert eine Zahlenfolge als Liste mit der Länge LENGTH, nach dem Schema MODE.
sortNum(LENGTH, MODE) when LENGTH > 0 ->
  sortNum(LENGTH, MODE, "zahlen.dat").

sortNum(LENGTH, MODE, FILENAME) when LENGTH > 0 ->
  Result = sortNum(LENGTH, MODE, LENGTH, []),
  case file:write_file(FILENAME, io_lib:fwrite("~p", [Result])) of
    ok -> ok;
    {error, Reason} -> {error,Reason}
  end.



%% Abbruchbedingung
sortNum(_, _, 0, ACCU) ->
  ACCU;

%% Generiert eine zufällige Zahlenfolge.
sortNum(LENGTH, random, REMAINING, ACCU) ->
  sortNum(LENGTH, random, REMAINING - 1, lists:append([ACCU, [random:uniform(LENGTH)]]));

%% EXTRA
%% Generiert eine zufällige Zahlenfolge ohne doppelte Vorkommen von Zahlen.
sortNum(LENGTH, random_nodup, REMAINING, ACCU) ->
  RANDOM = random:uniform(LENGTH),
  IS_MEMBER = lists:member(RANDOM, ACCU),

  if %% Prüfung, ob Element bereits in der Liste enthalten
    IS_MEMBER ->
      sortNum(LENGTH, random_nodup, REMAINING, ACCU);
    true ->
      sortNum(LENGTH, random_nodup, REMAINING - 1, lists:append([ACCU, [RANDOM]]))
  end;

%% Generiert eine aufsteigend sortierte Zahlenfolge.
sortNum(LENGTH, ascending, REMAINING, ACCU) ->
  sortNum(LENGTH, ascending, REMAINING - 1, lists:append([ACCU, [LENGTH - REMAINING]]));

%% Generiert eine absteigend sortierte Zahlenfolge.
sortNum(LENGTH, descending, REMAINING, ACCU) ->
  sortNum(LENGTH, descending, REMAINING - 1, lists:append([ACCU, [REMAINING]])).



%%% HILFSFUNKTIONEN %%%
%%%%%%%%%%%%%%%%%%%%%%%

%% Schreibt das Ergebnis-Array in eine Datei
saveList(ARRAY) ->
  saveList(ARRAY, "sortiert.dat").

saveList(ARRAY, FILENAME) ->
  ResultList = arrayToList(ARRAY),
  file:write_file(FILENAME, io_lib:format("~p",[ResultList])).

%% Konvertiert ein rekursiv geschachteltes Tupel zu einer Erlang-Liste
arrayToList(ARRAY) ->
  lists:reverse(arrayToList(ARRAY, [])).

arrayToList({}, ACCU) ->
  ACCU;

arrayToList({HEAD, TAIL}, ACCU) ->
  arrayToList(TAIL, [HEAD] ++ ACCU).

%% Liest die Zahlenfolge aus der angegebenen Datei ein
readList() ->
  readList("zahlen.dat").

readList(FileName) ->
  listToArray(util:zahlenfolgeRT(FileName)).



%% Konvertiert eine Erlang-Liste zu einem rekursiv geschachtelten Tupel
listToArray(List) ->
  if
    is_list(List) ->
      listToArray(List, liste:create());
    true ->
      {error, not_a_list}
  end.

listToArray([H|T], Accu) ->
  NewAccu = liste:insert(Accu, liste:laenge(Accu)+1, H),
  listToArray(T, NewAccu);

listToArray([], Accu) ->
  Accu.