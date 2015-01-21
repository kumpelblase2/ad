-module(main).
-author("tim_hagemann & tim_hartig").

-export([readTree/1, deleteRandom/2]).


readTree(FileName) ->
    LIST = util:zahlenfolgeRT(FileName),
    listToTree(LIST).

%% Konvertiert eine Erlang-Liste zu einem rekursiv geschachtelten Tupel
listToTree(List) ->
    if
        is_list(List) ->
            listToTree(List, avlbaum:create());
        true ->
            {error, not_a_list}
    end.

listToTree([H|T], Accu) ->
    NewAccu = avlbaum:insert(Accu, H),
    listToTree(T, NewAccu);

listToTree([], Accu) ->
    Accu.

deleteRandom(AVL, FileName) ->
    deleteRandomList(AVL, 25, util:zahlenfolgeRT(FileName)).

deleteRandomList(AVL, _, []) ->
    AVL;

deleteRandomList(AVL, 0, _) ->
    AVL;

deleteRandomList(AVL, Remaining, [H|T]) ->
    RANDOM = random:uniform(),
    if
        RANDOM >= 0.7 ->
            deleteRandomList(avlbaum:delete(AVL, H), Remaining - 1, T);
        true ->
            deleteRandomList(AVL, Remaining, T)
    end.
