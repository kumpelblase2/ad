-module(avlbaum).
-author("tim_hagemann").

-export([create/0, create/1, getNode/2, getValue/1, setValue/2, hoehe/1, balancing/1, setNode/3, insert/2]).

create() ->
	create(empty).

create(SELF) ->
	{{}, {SELF, 0}, {}}.

isNode({}) ->
	true;

isNode({_, {_, _}, _}) ->
	true;

isNode(_) ->
	false.

getNode({LEFT,_,_}, left) ->
	LEFT;

getNode({_, _, RIGHT}, right) ->
	RIGHT.

setNode(AVL, POS, VAL) ->
	CURR = getNode(AVL, POS),
	IS_NODE = isNode(CURR),
	IS_VAL_NODE = isNode(VAL),
	if
		IS_NODE ->
			if
				IS_VAL_NODE ->
					replaceNode(AVL, POS, VAL);
				true ->
					setNodeVal(AVL, POS, VAL)
			end;
		true ->
			if
				IS_VAL_NODE ->
					replaceNode(AVL, POS, VAL);
				true ->
					replaceNode(AVL, POS, create(VAL))
			end
	end.

replaceNode({_, OWN, RIGHT}, left, NEW) ->
	{NEW, OWN, RIGHT};

replaceNode({LEFT, OWN, _}, right, NEW) ->
	{LEFT, OWN, NEW}.

setNodeVal(AVL, POS, VAL) ->
	NODE = getNode(AVL, POS),
	setValue(NODE, VAL).

getValue({}) ->
	undefined;

getValue({_, {VAL, _}, _}) ->
	VAL.

setValue({LEFT, {_, HEIGHT}, RIGHT}, VAL) ->
	{LEFT, {VAL, HEIGHT}, RIGHT}.

hoehe({}) ->
	0;

hoehe({_, {_, HEIGHT}, _}) ->
	HEIGHT.

setHeight({LEFT, {VAL, _}, RIGHT}, HEIGHT_VAL) ->
	{LEFT, {VAL, HEIGHT_VAL}, RIGHT}.

isEmpty({_, {empty, _}, _}) ->
	true;

isEmpty({})->
	true;

isEmpty({empty, _}) ->
	true;

isEmpty(_) ->
	false.

balancing({}) ->
	0;

balancing(AVL) ->
	hoehe(getNode(AVL, left)) - hoehe(getNode(AVL, right)).

insert(AVL, VAL) ->
	EMPTY = isEmpty(AVL),
	if
		EMPTY ->
			EMPTY_NODE = create(),
			VALUED = setValue(EMPTY_NODE, VAL),
			setHeight(VALUED, 1);
		true ->
			OWN_VALUE = getValue(AVL),
			if
				VAL == OWN_VALUE ->
					POS = none;
				VAL > OWN_VALUE ->
					POS = right;
				true ->
					POS = left
			end,
			if
				POS == none ->
					AVL;
				true ->
					SUB_AVL = insert(getNode(AVL, POS), VAL),
					INSERTED = setNode(AVL, POS, SUB_AVL),
					NEW_HEIGHT = hoehe(SUB_AVL) + 1,
					CURR_HEIGHT = hoehe(AVL),
					if
						NEW_HEIGHT > CURR_HEIGHT ->
							MY_NEW = setHeight(INSERTED, NEW_HEIGHT);
						true ->
							MY_NEW = INSERTED
					end,
					BALANCE = abs(balancing(MY_NEW)),
					if
						BALANCE > 1 ->
							rebalance(MY_NEW);
						true ->
							MY_NEW
					end
			end
	end.

rebalance(AVL) ->
	BALANCING = balancing(AVL),
	if
		BALANCING >= 2 ->
			BALANCING_LEFT = balancing(getNode(AVL, left)),
			if
				BALANCING_LEFT > 0 ->
					rightRotation(AVL);
				true ->
					doubleLeftRotation(AVL)
			end;
		BALANCING =< -2 ->
			BALANCING_RIGHT = balancing(getNode(AVL, right)),
			if
				BALANCING_RIGHT < 0 ->
					leftRotation(AVL);
				true ->
					doubleRightRotation(AVL)
			end;
		true ->
			AVL
	end.

leftRotation(AVL) ->
	SUB_RIGHT = getNode(AVL, right),
	REPLACE_LEFT = setNode(AVL, right, getNode(SUB_RIGHT, left)),
	LEFT_HEIGHT_UPDATE = setHeight(REPLACE_LEFT, erlang:max(hoehe(getNode(REPLACE_LEFT, left)), hoehe(getNode(REPLACE_LEFT, right))) + 1),
	REPLACE_RIGHT = setNode(SUB_RIGHT, left, LEFT_HEIGHT_UPDATE),
	RIGHT_HEIGHT_UPDATE = setHeight(REPLACE_RIGHT, erlang:max(hoehe(getNode(REPLACE_RIGHT, left)), hoehe(getNode(REPLACE_RIGHT, right))) + 1),
	RIGHT_HEIGHT_UPDATE.

rightRotation(AVL) ->
	SUB_LEFT = getNode(AVL, left),
	REPLACE_RIGHT = setNode(AVL, left, getNode(SUB_LEFT, right)),
	RIGHT_HEIGHT_UPDATE = setHeight(REPLACE_RIGHT, erlang:max(hoehe(getNode(REPLACE_RIGHT, left)), hoehe(getNode(REPLACE_RIGHT, right))) + 1),
	REPLACE_LEFT = setNode(SUB_LEFT, right, RIGHT_HEIGHT_UPDATE),
	LEFT_HEIGHT_UPDATE = setHeight(REPLACE_LEFT, erlang:max(hoehe(getNode(REPLACE_LEFT, left)), hoehe(getNode(REPLACE_LEFT, right))) + 1),
	LEFT_HEIGHT_UPDATE.

doubleLeftRotation(AVL) ->
	FIRST_ROTATION = setNode(AVL, left, rightRotation(getNode(AVL, left))),
	leftRotation(FIRST_ROTATION).

doubleRightRotation(AVL) ->
	FIRST_ROTATION = setNode(AVL, right, leftRotation(getNode(AVL, right))),
	rightRotation(FIRST_ROTATION).
