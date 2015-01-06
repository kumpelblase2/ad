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
	CURR = getNode(AVL, POS).
	if
		isNode(CURR) ->
			if
				isNode(VAL) ->
					replaceNode(AVL, POS, VAL);
				true ->
					setNodeVal(AVL, POS, VAL)
			end;
		true ->
			if
				isNode(VAL) ->
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
	NODE = getNode(AVL, POS).
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

isEmpty({})->
	true.

balancing({}) ->
	0;

balancing(AVL) ->
	hoehe(getNode(AVL, right)) - hoehe(getNode(AVL, left)).

insert(AVL, VAL) ->
	if
		isEmpty(AVL) ->
			setHeight(setValue(AVL, VAL), 1);
		true ->
			OWN_VALUE = getValue(AVL).
			if
				VAL == OWN_VALUE ->
					POS = none;
				VAL > OWN_VALUE ->
					POS = right;
				true ->
					POS = left
			end.
			if
				POS == none ->
					AVL;
				true ->
					SUB_AVL = insert(getNode(AVL, POS), VAL).
					NEW_HEIGHT = getHeight(SUB_AVL) + 1,
					CURR_HEIGHT = getHeight(AVL),
					if
						NEW_HEIGHT > CURR_HEIGHT ->
							MY_NEW = setHeight(AVL, NEW_HEIGHT);
						true ->
							MY_NEW = AVL
					end,
					BALANCE = abs(balancing(MY_NEW)).
					if
						BALANCE > 1 ->
							rebalance(MY_NEW).
						true ->
							MY_NEW
					end
			end
	end.

rebalance(AVL) ->
	BALANCING = balancing(AVL),
	if
		BALANCING >= 2 ->
			leftRotation(AVL).
		BALANCING <= -2 ->
			rightRotation(AVL).
		true ->
			AVL.
	end.

leftRotation(AVL) ->
	SUB_RIGHT = getNode(AVL, right),
	REPLACE_LEFT = setNode(AVL, right, getNode(SUB_RIGHT, left)),
	LEFT_HEIGHT_UPDATE = setHeight(REPALCE_LEFT, erlang:max(getHeight(getNode(REPLACE_LEFT, left)), getHeight(getNode(REPALCE_LEFT, right)))),
	REPLACE_RIGHT = setNode(SUB_RIGHT, left, LEFT_HEIGHT_UPDATE),
	RIGHT_HEIGHT_UPDATE = setHeight(REPALCE_RIGHT, erlang:max(getHeight(getNode(REPALCE_RIGHT, left)), getHeight(getNode(REPALCE_RIGHT, right)))),
	RIGHT_HEIGHT_UPDATE.

rightRotation(AVL) ->
	SUB_LEFT = getNode(AVL, left),
	REPLACE_RIGHT = setNode(AVL, left, getNode(SUB_LEFT, right)),
	RIGHT_HEIGHT_UPDATE = setHeight(REPLACE_RIGHT, erlang:max(getHeight(getNode(REPLACE_RIGHT, left)), getHeight(getNode(REPLACE_RIGHT, right)))),
	REPLACE_LEFT = setNode(SUB_LEFT, right, RIGHT_HEIGHT_UPDATE),
	LEFT_HEIGHT_UPDATE = setHeight(REPLACE_LEFT, erlang:max(getHeight(getNode(REPLACE_LEFT, left)), getHeight(getNode(REPLACE_LEFT, right)))),
	LEFT_HEIGHT_UPDATE.

doubleLeftRotation(AVL) ->
	FIRST_ROTATION = setNode(AVL, right, rightRotation(getNode(AVL, right))),
	leftRotation(FIRST_ROTATION).

doubleRightRotation(AVL) ->
	FIRST_ROTATION = setNode(AVL, left, leftRotation(getNode(AVL, left))),
	rightRotation(FIRST_ROTATION).
