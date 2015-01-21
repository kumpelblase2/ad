-module(avlbaum).
-author("tim_hagemann & tim_hartig").

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
	%% Erstelle Balancing durch die Hoehendifferenz.
	hoehe(getNode(AVL, left)) - hoehe(getNode(AVL, right)).

insert(AVL, VAL) ->
	EMPTY = isEmpty(AVL),
	if
		%% Wenn der Baum leer ist, einfach setzten.
		EMPTY ->
			setValue(AVL, VAL);
		true ->
			%% Eigenen Wert bestimmen um zu schauen, wo der Wert weitergeleitet werden soll.
			OWN_VALUE = getValue(AVL),
			if
				%% Wenns gleich der eigene Wert ist, wird der ignoriert.
				VAL == OWN_VALUE ->
					POS = none;
				%% Groeßere Werte kommen immer rechts vom aktuellen Wert hin.
				VAL > OWN_VALUE ->
					POS = right;
				%% Sonst (also kleiner), kommt der immer links vom aktuellen Wert.
				true ->
					POS = left
			end,
			if
				POS == none ->
					AVL;
				true ->
					%% Rekursiv im Unterbaum einfügen.
					SUB_AVL = insert(getNode(AVL, POS), VAL),
					INSERTED = setNode(AVL, POS, SUB_AVL),
					%% Neue Hoehe berechnen.
					NEW_HEIGHT = hoehe(SUB_AVL) + 1,
					MY_NEW = setHeight(INSERTED, NEW_HEIGHT),
					%% Balancing bestimmen
					BALANCE = abs(balancing(MY_NEW)),
					if
						%% Wenn eine Dysbalance vorliegt -> rebalancing
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
		%% Wenn der Wert kleiner ist als der aktuelle Knoten
		CURRENT_VALUE > VALUE ->
			%% Lösche rekursiv aus dem linken Teilbaum
			SET = setNode(AVL, left, delete(getNode(AVL, left), VALUE)),
			%% Updated die Höhe des kompletten Baums
			setHeight(SET, erlang:max(hoehe(getNode(SET, left)), hoehe(getNode(SET, right))) + 1);
		%% Wenn der Wert größer ist als der aktuelle Knoten
		CURRENT_VALUE < VALUE ->
			%% Lösche rekursiv aus dem rechten Teilbaum
			SET = setNode(AVL, right, delete(getNode(AVL, right), VALUE)),
			%% Updated die Höhe des komplette Baums
			setHeight(SET, erlang:max(hoehe(getNode(SET, right)), hoehe(getNode(SET, left))) + 1);
		%% Wenn der aktuelle Knoten der zu löschende Wert ist
		true ->
			%% Schau, ob Kinder vorhande sind
			LEFT_EMPTY = isEmpty(getNode(AVL, left)),
			RIGHT_EMPTY = isEmpty(getNode(AVL, right)),
			if
				%% Wenn beide leer sind
				LEFT_EMPTY and RIGHT_EMPTY ->
					%% wir haben nun ein leeren Teilbaum
					create();
				%% Wenn links leer ist
				LEFT_EMPTY ->
					%% Haben wir nurnoch den rechten Teilbaum
					getNode(AVL, right);
				%% Wenn rechts leer ist
				RIGHT_EMPTY ->
					%% Haben wir nurnoch den linken Teilbaum
					getNode(AVL, left);
				%% Wenn wir zwei Kinder haben
				true ->
					LEFT_TREE = getNode(AVL, left),
					%% Finde den hoechsten Wert im linken Teilbaum
					HIGHEST = findHighestValue(LEFT_TREE),
					%% Lösche diesen aus dem Baum
					DELETE_HIGHEST = delete(LEFT_TREE, HIGHEST),
					%% Setzte den linken Teilbaum auf den ohne hoechsten Wert
					RESET_LEFT = setNode(AVL, left, DELETE_HIGHEST),
					%% Setzte den Wert des aktuell, zu löschenden, Knotens auf den hoechsten Wert
					setValue(RESET_LEFT, HIGHEST)
			end
	end.

findHighestValue(TREE) ->
	EMPTY = isEmpty(TREE),
	if
		%% Wenn der Baum leer ist, gibt es keinen Hoechsten.
		EMPTY ->
			undenfined;
		true ->
			%% Ist der rechten Unterknoten leer
    		RIGHT_EMPTY = isEmpty(getNode(TREE, right)),
			if
				%% Wenn ja, ist dies der hoechste Wert
				RIGHT_EMPTY ->
					getValue(TREE);
				%% Sonst gehe weiter den rechten Baum durch.
				true ->
					findHighestValue(getNode(TREE, right))
			end
	end.

rebalance(AVL) ->
	%% Balancing bestimmen
	BALANCING = balancing(AVL),
	if
		%% Balancing >= 2, übergewicht auf der linken Seite
		BALANCING >= 2 ->
			%% Balancing des linken Unterknoten bestimmen
			BALANCING_LEFT = balancing(getNode(AVL, left)),
			if
				%% Balancing >= 1, übergewicht auf der linken Seite, also einfache Rechtsrotation
				BALANCING_LEFT > 0 ->
					rightRotation(AVL);
				%% Übergewicht auf der rechten Seite, also doppelte Rechtsrotation (1. Linksrotation + 2. Rechtsrotation)
				true ->
					doubleRightRotation(AVL)
			end;
		%% Übergewicht auf der rechten Seite
		BALANCING =< -2 ->
			%% Balancing des linken Unterknoten bestimmen
			BALANCING_RIGHT = balancing(getNode(AVL, right)),
			if
				%% Übergewicht des Unterknotens auf der rechten Seite, also einfache Linksrotation.
				BALANCING_RIGHT < 0 ->
					leftRotation(AVL);
				%% Übergewicht auf der linken Seite, also doppelte Linksrotation (1. Rechtsrotation + 2. Linksrotation)
				true ->
					doubleLeftRotation(AVL)
			end;
		%% Baum ist balanciert, nichts zu tun.
		true ->
			AVL
	end.

leftRotation({}) ->
	{};

leftRotation(AVL) ->
	SUB_RIGHT = getNode(AVL, right),
	%% Linker Baum des rechten Unterknoten hochholen
	REPLACE_LEFT = setNode(AVL, right, getNode(SUB_RIGHT, left)),
	LEFT_HEIGHT_UPDATE = setHeight(REPLACE_LEFT, erlang:max(hoehe(getNode(REPLACE_LEFT, left)), hoehe(getNode(REPLACE_LEFT, right))) + 1),
	%% Rechter Unterknoten als neuen Hauptknoten festlegen.
	REPLACE_RIGHT = setNode(SUB_RIGHT, left, LEFT_HEIGHT_UPDATE),
	setHeight(REPLACE_RIGHT, erlang:max(hoehe(getNode(REPLACE_RIGHT, left)), hoehe(getNode(REPLACE_RIGHT, right))) + 1).

rightRotation({}) ->
	{};

rightRotation(AVL) ->
	SUB_LEFT = getNode(AVL, left),
	%% Rechten Baum des linken Unterknoten hochholen
	REPLACE_RIGHT = setNode(AVL, left, getNode(SUB_LEFT, right)),
	RIGHT_HEIGHT_UPDATE = setHeight(REPLACE_RIGHT, erlang:max(hoehe(getNode(REPLACE_RIGHT, left)), hoehe(getNode(REPLACE_RIGHT, right))) + 1),
	%% Linker Unterknoten also neuen Hauptknoten festlegen
	REPLACE_LEFT = setNode(SUB_LEFT, right, RIGHT_HEIGHT_UPDATE),
	setHeight(REPLACE_LEFT, erlang:max(hoehe(getNode(REPLACE_LEFT, left)), hoehe(getNode(REPLACE_LEFT, right))) + 1).

doubleLeftRotation({}) ->
	{};

doubleLeftRotation(AVL) ->
	%% Erst eine Rechtsrotation auf den rechten Unterknoten.
	FIRST_ROTATION = setNode(AVL, right, rightRotation(getNode(AVL, right))),
	%5 Linksrotation auf den ganzen Baum.
	leftRotation(FIRST_ROTATION).

doubleRightRotation({}) ->
	{};

doubleRightRotation(AVL) ->
	%% Linksrotation auf den linken Unterknoten
	FIRST_ROTATION = setNode(AVL, left, leftRotation(getNode(AVL, left))),
	%% Rechtsrotation auf den ganzen Baum
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
