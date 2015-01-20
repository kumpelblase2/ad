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
    create/0 (): Erstellt einen neuen, leeren AVL Baum

    create/1 (ELEM): Erstellt einen neuen AVL Baum mit ELEM als ersten Knoten

    getNode/2 (TREE, POS): Gibt den Knoten an POS (left | right) an der Quelle des TREE zurück.

    getValue/1 (NODE): Gibt den Wert der aktuellen Knotens NODE zurück.

    setValue/2 (NODE, VALUE): Setzt den Wert ddes aktuellen Knotens NODE auf VALUE.

    setNode/3 (TREE, POS, NODE): Setzt den Knoten an POS (left | right) des TREE auf NODE.

    hoehe/1 (NODE): Gibt die Höhe des aktuellen Knoten NODE aus.

    balancing/1 (TREE): (Re)Balanciert den Baum ggf. durch Rotationen.

    insert/2 (TREE, VALUE): Fügt VALUE in den Baum TREE an der entsprechenden Stelle ein und balanciert den Baum ggf. neu.

    delete/2 (TREE, VALUE): Löscht VALUE aus dem Baum TREE und stellt anschließend ggf. die Balance wieder her.
    
    export/2 (AVL, PATH): Exportiert den AVL Baum in eine Datei nach PATH im .dot-Format.
