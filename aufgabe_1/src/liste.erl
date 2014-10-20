%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 15. Okt 2014 15:57
%%%-------------------------------------------------------------------
-module(liste).
-author("tim_hagemann").

%% API
-export([create/0, isEmpty/1, laenge/1, insert/3, delete/2, retrieve/2, find/2, concat/2]).

create() ->
  {list, {}}.

isEmpty(LIST) ->
  laenge(LIST) == 0.

laenge({list, DATA}) ->
  laenge(DATA, 0).

laenge(DATA, ACC) when {} == DATA->
  ACC;

laenge({_, REST}, ACC) ->
  laenge(REST, ACC + 1).

insert({list, DATA}, POS, ELEM) ->
  {list, insert_data(DATA, POS - 1, ELEM)}.

insert_data(DATA, _, ELEM) when DATA == {}->
  {ELEM, {}};

insert_data({DATA, REST}, POS, ELEM) when POS /= 0->
  {DATA, insert_data(REST, POS - 1, ELEM)};

insert_data({DATA, REST}, POS, ELEM) when POS == 0 ->
  {ELEM, {DATA, REST}};

insert_data({DATA, REST}, _, ELEM) when REST == {} ->
  {DATA, { ELEM, {} }}.

delete({list, DATA}, POS) ->
  {list, delete_data(DATA, POS - 1)}.

delete_data({}, _) ->
  {};

delete_data({DATA, REST}, POS) when POS /= 0 ->
  {DATA, delete_data(REST, POS -1)};

delete_data({_, REST}, POS) when POS == 0 ->
  REST;

delete_data({DATA, REST}, _) when REST == {} ->
  {DATA, {}}.

retrieve({list, DATA}, POS) ->
  retrieve_data(DATA, POS - 1).

retrieve_data({DATA, _}, 0) ->
  DATA;

retrieve_data({_, REST}, POS) ->
  retrieve_data(REST, POS - 1).

find({list, DATA}, ELEM) ->
  find(DATA, ELEM, 1).

find({CURR, _}, ELEM, POS) when CURR == ELEM ->
  POS;

find({_, REST}, ELEM, POS) ->
  find(REST, ELEM, POS + 1);

find({}, _, _) ->
  -1.

concat(FIRST, {list, DATA2}) ->
  concat(FIRST, DATA2);

concat(FIRST, DATA2) when DATA2 /= {}->
  {DATA2ELEM, DATA2REST} = DATA2,
  NEW = insert(FIRST, laenge(FIRST), DATA2ELEM),
  concat(NEW, DATA2REST);

concat(FIRST, {}) ->
  FIRST.
