%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Okt 2014 08:27
%%%-------------------------------------------------------------------
-module(liste).
-author("tim_hagemann").

%% API
-export([create/0, isEmpty/1, laenge/1, insert/3, delete/2, retrieve/2, find/2, concat/2]).

% Erstellt eine leere Liste. Hier ist das erste Element an der Position 1.
create() ->
  {}.

% Prueft obt die Liste leer ist, also keine Elemente enthaelt.
% Siehe liste:laenge/1
isEmpty(LIST) ->
  laenge(LIST) == 0.

% Gibt die Laenge der Liste zurueck.
laenge(LIST) ->
  laenge(LIST, 0).

laenge(DATA, ACC) when {} == DATA->
  ACC;

laenge({_, REST}, ACC) ->
  laenge(REST, ACC + 1).

% Setzt ein neues Element in die Liste an einer bestimmten Position hinein.
% Wenn die Position groesser als die Laenge der Liste ist, wird das Element an das Ende der Liste angehaengt.
% Das vorherige Element an der gegebenen Stelle und damit auch die nachfolgenden Elemente werden um eine Position weiter nach hinten verschoben.
insert(DATA, POS, ELEM) ->
  insert_data(DATA, POS - 1, ELEM).

insert_data(DATA, _, ELEM) when DATA == {}->
  {ELEM, {}};

insert_data({DATA, REST}, POS, ELEM) when POS /= 0->
  {DATA, insert_data(REST, POS - 1, ELEM)};

insert_data({DATA, REST}, POS, ELEM) when POS == 0 ->
  {ELEM, {DATA, REST}};

insert_data({DATA, REST}, _, ELEM) when REST == {} ->
  {DATA, { ELEM, {} }}.

% Loescht ein Element an einer gegebenen Position aus der Liste.
% Wenn die Position nicht in der Liste existiert, passiert nichts.
% Wenn ein Element geloescht wird, werden die nachfolgenden Elemente um eine Position weiter nach vorne gerueckt.
delete(DATA, POS) ->
  delete_data(DATA, POS - 1).

delete_data({}, _) ->
  {};

delete_data({DATA, REST}, POS) when POS /= 0 ->
  {DATA, delete_data(REST, POS -1)};

delete_data({_, REST}, POS) when POS == 0 ->
  REST;

delete_data({DATA, REST}, _) when REST == {} ->
  {DATA, {}}.

% Gibt das Element an der gegebenen Position zurueck.
% Wenn sich die Position ausserhalt der Liste befindet, wird 'null' zurueckgegeben.
retrieve(DATA, POS) ->
  retrieve_data(DATA, POS - 1).

retrieve_data({DATA, _}, 0) ->
  DATA;

retrieve_data({}, _POS) ->
  null;

retrieve_data({_, REST}, POS) ->
  retrieve_data(REST, POS - 1).

% Sucht in der Liste nach dem gegebenen Element und gibt, falls gefunden, die Position zurueck.
% Wenn sich das Element nicht in der Liste befindet wird -1 zurueckgegeben.
find(DATA, ELEM) ->
  find(DATA, ELEM, 1).

find({CURR, _}, ELEM, POS) when CURR == ELEM ->
  POS;

find({_, REST}, ELEM, POS) ->
  find(REST, ELEM, POS + 1);

find({}, _, _) ->
  -1.

% Fuegt die Elemente der zweiten Liste an das Ende der Ersten Liste an.
concat(FIRST, DATA2) when DATA2 /= {}->
  {DATA2ELEM, DATA2REST} = DATA2,
  NEW = insert(FIRST, laenge(FIRST), DATA2ELEM),
  concat(NEW, DATA2REST);

concat(FIRST, {}) ->
  FIRST;

concat({}, LAST) ->
  LAST.