         _____     _
        |  ___|   | |
        | |__ _ __| | __ _ _ __   __ _
        |  __| '__| |/ _` | '_ \ / _` |
        | |__| |  | | (_| | | | | (_| |
        \____/_|  |_|\__,_|_| |_|\__, |
                                  __/ |
                                 |___/
##############################################
##        - ADP WS14/15 Aufgabe 4 -         ##
##           Gruppe 03 // Team 9            ##
##               Tim Hagemann               ##
##                Tim Hartig                ##
##############################################

/--------------------------\
  Zu kompilierende Dateien
\--------------------------/

avlbaum.erl

/--------------------------\
   Verfügbare Funktionen
\--------------------------/

avlbaum.erl
    create/0 (): Erstellt einen neuen, leeren AVL baum

    create/1 (ELEM): Erstellt einen neuen AVL Baum mit dem ELEM als ersten Node

    getNode/2 (TREE, POS): Gibt die Node an POS (left | right) an der Quelle des TREE zurück.

    getValue/1 (NODE): Gibt den Wert der aktuellen Node zurück.

    setValue/2 (NODE, VALUE): Setzt den Wert der aktuellen Node auf VALUE.

    setNode/3 (TREE, POS, NODE): Setzt die Node an POS (left | right) des TREE auf NODE.

    hoehe/1 (NODE): Gibt die Höhe der aktuellen Node aus.

    balancing/1 (TREE): (Re)Balanciert den Baum ggf. unter Verwendung von Links- bzw. Rechtsrotationen.

    insert/2 (TREE, VALUE): Fügt VALUE in den Baum an der entsprechenden Stelle ein und balanciert den Baum ggf. neu.
