-module(avlbaum).
-author("tim_hagemann").

-export([create/0, create/1, getNode/2, getValue/1, hoehe/1, insert/2, delete/2, export/2]).

create() ->
	{}.

create(SELF) ->
	{{}, {SELF, 1}, {}}.

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

setValue({}, VAL) ->
	create(VAL);

setValue({LEFT, {_, HEIGHT}, RIGHT}, VAL) ->
	{LEFT, {VAL, HEIGHT}, RIGHT}.

hoehe({}) ->
	0;

hoehe({_, {_, HEIGHT}, _}) ->
	HEIGHT.

setHeight({LEFT, {VAL, _}, RIGHT}, HEIGHT_VAL) ->
	{LEFT, {VAL, HEIGHT_VAL}, RIGHT}.

isEmpty({})->
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
			create(VAL);
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

delete(AVL, VALUE) ->
	CURRENT_VALUE = getValue(AVL),
	if
		CURRENT_VALUE > VALUE ->
			setNode(AVL, left, delete(getNode(AVL, left), VALUE));
		CURRENT_VALUE < VALUE ->
			setNode(AVL, right, delete(getNode(AVL, right), VALUE));
		true ->
			LEFT_EMPTY = isEmpty(getNode(AVL, left)),
			RIGHT_EMPTY = isEmpty(getNode(AVL, right)),
			if
				LEFT_EMPTY and RIGHT_EMPTY ->
					create();
				LEFT_EMPTY ->
					getNode(AVL, right);
				RIGHT_EMPTY ->
					getNode(AVL, left);
				true ->
					LEFT_TREE = getNode(AVL, left),
					HIGHEST = findHighestValue(LEFT_TREE),
					DELETE_HIGHEST = delete(LEFT_TREE, HIGHEST),
					ok
			end
	end.

findHighestValue(TREE) ->
	EMPTY = isEmpty(TREE),
	if
		EMPTY ->
			undenfined;
		true ->
      RIGHT_EMPTY = isEmpty(getNode(TREE, right)),
			if
				RIGHT_EMPTY ->
					getValue(TREE);
				true ->
					findHighestValue(getNode(TREE, right))
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
					doubleRightRotation(AVL)
			end;
		BALANCING =< -2 ->
			BALANCING_RIGHT = balancing(getNode(AVL, right)),
			if
				BALANCING_RIGHT < 0 ->
					leftRotation(AVL);
				true ->
					doubleLeftRotation(AVL)
			end;
		true ->
			AVL
	end.

leftRotation({}) ->
	{};

leftRotation(AVL) ->
	SUB_RIGHT = getNode(AVL, right),
	REPLACE_LEFT = setNode(AVL, right, getNode(SUB_RIGHT, left)),
	LEFT_HEIGHT_UPDATE = setHeight(REPLACE_LEFT, erlang:max(hoehe(getNode(REPLACE_LEFT, left)), hoehe(getNode(REPLACE_LEFT, right))) + 1),
	REPLACE_RIGHT = setNode(SUB_RIGHT, left, LEFT_HEIGHT_UPDATE),
	RIGHT_HEIGHT_UPDATE = setHeight(REPLACE_RIGHT, erlang:max(hoehe(getNode(REPLACE_RIGHT, left)), hoehe(getNode(REPLACE_RIGHT, right))) + 1),
	RIGHT_HEIGHT_UPDATE.

rightRotation({}) ->
	{};

rightRotation(AVL) ->
	SUB_LEFT = getNode(AVL, left),
	REPLACE_RIGHT = setNode(AVL, left, getNode(SUB_LEFT, right)),
	RIGHT_HEIGHT_UPDATE = setHeight(REPLACE_RIGHT, erlang:max(hoehe(getNode(REPLACE_RIGHT, left)), hoehe(getNode(REPLACE_RIGHT, right))) + 1),
	REPLACE_LEFT = setNode(SUB_LEFT, right, RIGHT_HEIGHT_UPDATE),
	LEFT_HEIGHT_UPDATE = setHeight(REPLACE_LEFT, erlang:max(hoehe(getNode(REPLACE_LEFT, left)), hoehe(getNode(REPLACE_LEFT, right))) + 1),
	LEFT_HEIGHT_UPDATE.

doubleLeftRotation({}) ->
	{};

doubleLeftRotation(AVL) ->
	FIRST_ROTATION = setNode(AVL, right, rightRotation(getNode(AVL, right))),
	leftRotation(FIRST_ROTATION).

doubleRightRotation({}) ->
	{};

doubleRightRotation(AVL) ->
	FIRST_ROTATION = setNode(AVL, left, leftRotation(getNode(AVL, left))),
	rightRotation(FIRST_ROTATION).

%% Wenn linker und rechter Kindknoten leer sind, ist der Knoten ein Blatt
isLeaf({true, true}) ->
  true;

isLeaf({false,_}) ->
  false;

isLeaf({_,false}) ->
  false;

%% Gibt an, ob Wurzelknoten ein Blatt ist
isLeaf(ROOT_NODE) ->
  isLeaf({isEmpty(getNode(ROOT_NODE, left)), isEmpty(getNode(ROOT_NODE, right))}).

%% Exportiert den AVL Baum in eine Datei im DOT Format
export(AVL, PATH) ->
  AVL_IS_EMPTY = isEmpty(AVL),
  if
    %% Falls Baum leer
    AVL_IS_EMPTY ->
      {no_export, tree_empty};
    %% Falls Baum nicht leer
    true ->
      %% Datei öffnen und Dateikopf schreiben
      FILE = initDot(PATH),

      ROOT_VAL = getValue(AVL),
      LEFT_NODE = getNode(AVL, left),
      RIGHT_NODE = getNode(AVL, right),

      AVL_IS_LEAF = isLeaf(AVL),
      if
        %% Falls der Wurzelknoten keine Kinder hat
        AVL_IS_LEAF ->
          %% kann nur der Wert des WK, ohne Pfeile auf andere Knoten, geschrieben werden
          writeDot(FILE, ROOT_VAL);

        %% Andernfalls
        true ->
          LEFT_VAL = getValue(LEFT_NODE),
          RIGHT_VAL = getValue(RIGHT_NODE),

          %% Zeilen für die Verbindung zwischen Root und seinen Kindern ausschreiben
          writeDot(FILE, ROOT_VAL, LEFT_VAL, hoehe(LEFT_NODE)),
          writeDot(FILE, ROOT_VAL, RIGHT_VAL, hoehe(RIGHT_NODE)),

          %% und rekursiv absteigen
          export(FILE, LEFT_NODE, l),
          export(FILE, RIGHT_NODE, r)
      end,

      %% Datei (ab)schließen
      closeDot(FILE)
  end.

%% Rekursionsabbruch
export(_FILE, {}, _) ->
  nil;

%% Standartaufruf für alle nachfolgenden Knoten
export(FILE, ROOT_NODE, _) when (ROOT_NODE /= {}) ->
  LEFT_NODE = getNode(ROOT_NODE, left),
  RIGHT_NODE = getNode(ROOT_NODE, right),

  ROOT_VAL = getValue(ROOT_NODE),
  LEFT_VAL = getValue(LEFT_NODE),
  RIGHT_VAL = getValue(RIGHT_NODE),

  writeDot(FILE, ROOT_VAL, LEFT_VAL, hoehe(LEFT_NODE)),
  writeDot(FILE, ROOT_VAL, RIGHT_VAL, hoehe(RIGHT_NODE)),

  %% Rekursiv absteigen
  export(FILE, LEFT_NODE, l),
  export(FILE, RIGHT_NODE, r).

%% Initialisierung der Dot Datei
initDot(PATH) ->
  {ok, FILE} = file:open(PATH, [write]),
  io:fwrite(FILE, "digraph avltree\r\n{\r\n", []),
  file:open(PATH, [write, append]),
  FILE.

%% Nur Ausgabe des Wurzelknotens
writeDot(FILE, ROOT_VAL) ->
  io:fwrite(FILE, "  ~b;\r\n", [ROOT_VAL]).

%% Ausgabe einer Zeile mit Elternknoten, Kindknoten und Höhe
writeDot(_FILE, _ROOT_VAL, CHILD_VAL, _HEIGHT) when (CHILD_VAL == undefined) ->
  nil;

writeDot(FILE, ROOT_VAL, CHILD_VAL, HEIGHT) ->
  io:fwrite(FILE, "  ~b -> ~b [label=\~b\];\r\n", [ROOT_VAL, CHILD_VAL, HEIGHT]).

%% Abschluss der Dot Datei
closeDot(FILE) ->
  io:fwrite(FILE, "}\r\n", []),
  file:close(FILE).
