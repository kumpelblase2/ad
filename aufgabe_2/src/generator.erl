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
-export([sortNum/2]).


sortNum(LENGTH, MODE) when LENGTH > 0 ->
  sortNum(LENGTH, MODE, LENGTH, liste:create()).

% Abbruchbedingung
sortNum(_, _, 0, ACCU) ->
  ACCU;

sortNum(LENGTH, random, REMAINING, ACCU) ->
  sortNum(LENGTH, random, REMAINING - 1, liste:insert(ACCU, liste:laenge(ACCU), random:uniform(LENGTH)));

sortNum(LENGTH, ascending, REMAINING, ACCU) ->
  sortNum(LENGTH, random, REMAINING - 1, liste:insert(ACCU, liste:laenge(ACCU), LENGTH - REMAINING));

sortNum(LENGTH, descending, REMAINING, ACCU) ->
  sortNum(LENGTH, random, REMAINING - 1, liste:insert(ACCU, liste:laenge(ACCU), REMAINING)).

% Ein Versuch, die Methode, welche Art von Nummer generiert wird, zu refaktorisieren, abhängig von MODE --> getNum()
% Bis auf die Zahl, die als nächstes eingefügen werden soll, ist der Code der gleiche.
%sortNum(LENGTH, MODE, REMAINING, ACCU, NUMBER) ->
%  sortNum(LENGTH, MODE, REMAINING - 1, liste:insert(ACCU, liste:laenge(ACCU), NUMBER), getNum(MODE, LENGTH, REMAINING)).
%
%genNum(random, LENGTH, _) ->
%  randon:uniform(LENGTH).
%
%genNum(ascending, LENGTH, REMAINING) ->
%  LENGTH - REMAINING.
%
%genNum(descending, LENGTH, REMAINING) ->
%  REMAINING.