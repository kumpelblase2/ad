%%%-------------------------------------------------------------------
%%% @author tim_hagemann
%%% @copyright (C) 2014, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. Okt 2014 08:34
%%%-------------------------------------------------------------------
-module(array).
-author("tim_hagemann").

%% API
-export([create/0, setA/3, getA/2, laenge/1]).

% Erstellt eine neue Array die die Laenge 0 hat und bei der die Position 0 das erste Element besitzt.
create() ->
  liste:create().

% Setzt das Element an der gegebenen Position zu dem neuen Element.
% Wenn die Array noch nicht groß genug ist, wird diese mit leeren Elementen aufgefüllt.
setA(LIST, POS, ELEM) ->
  LISTPOS = POS + 1,
  LIST_LENGTH = liste:laenge(LIST),
  if
    LIST_LENGTH < LISTPOS ->
      setA(liste:insert(LIST, liste:laenge(LIST) + 1, undefined), POS, ELEM);
    true ->
      TempList = liste:delete(LIST, LISTPOS),
      liste:insert(TempList, LISTPOS, ELEM)
  end.

% Gibt das Element an der gegebenen Position zurück.
% Wenn sich an dieser Stelle kein Element befindet, wird 'undefined' zurueckgegeben.
% Wenn die Array kleiner ist als der Index wird 'null' zurückgegeben.
% Siehe liste:retrieve/2
getA(LIST, POS) ->
  liste:retrieve(LIST, POS + 1).

% Gibt die aktuelle Laenge der Array zurueck.
laenge(LIST) ->
  liste:laenge(LIST).