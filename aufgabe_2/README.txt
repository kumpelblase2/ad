         _____     _                   
        |  ___|   | |                  
        | |__ _ __| | __ _ _ __   __ _ 
        |  __| '__| |/ _` | '_ \ / _` |
        | |__| |  | | (_| | | | | (_| |
        \____/_|  |_|\__,_|_| |_|\__, |
                                  __/ |
                                 |___/ 
##############################################
##       - ADP WS14/15 Aufgabe 2 -          ##
##          Gruppe 03 // Team 9             ##
##            Tim Hagemann                  ##
##            Tim Hartig                    ##
##############################################

/--------------------------\
  Zu kompilierende Dateien
\--------------------------/

liste.erl
array.erl
util.erl
generator.erl
messung.erl
selections.erl
insertions.erl

/--------------------------\
   Verfügbare Funktionen
\--------------------------/

generator.erl
  sortNum/2 (LENGTH, MODE): Generiert eine Zahlenfolge der Länge LENGTH und schreibt sie in die Datei "zahlen.dat" aus.
                            Die Art der Reihenfolge wird über MODE bestimmt.
                            Akzeptierte Werte für MODE sind:
                            random:        Zufällige Zahlenfolge
                            random_nodup:  Zufällige Zahlenfolge ohne doppelte Vorkommen
                            ascending:     Aufsteigend sortierte Zahlenfolge
                            descending:    Absteigend sortierte Zahlenfolge

  readList/0 ():            Liest aus der Datei "zahlen.dat" eine Erlang-Liste ein, konvertiert diese in ein ADT-Array und gibt es zurück.
  saveList/1 (ARRAY):       Speichert ARRAY als Erlang-Liste in der Datei "sortiert.dat".
  
  
messung.erl
  startMessung/1 (ALGORITHM): Führt insgesamt 100 Sortierdurchgänge, mit 100-stelligen Zahlenfolgen, für den gewählten Algorithmus ALGORITHM durch
                              und sichert die Durchschnittswerte aller Messungen in der Datei "messung.dat".
                              Davon sind 80 Durchgänge mit Zufallszahlenfolgen, 10 mit aufsteigend sortierten und 10 mit absteigend sortierten Zahlenfolgen.
                              Aktzeptierte Werte für ALGORITHM sind:
                              insertion:  Durchführung mit InsertionSort
                              selection:  Durchführung mit SelectionSort
                              all:        Je eine vollständige Durchführung, wie oben beschrieben, für alle Algorithmen.
                              
  run/0 ():                   Ruft startMessungen(ALGORITHM) mit ALGORITHM = all auf

  
selection.erl
  selectionS/3 (ARRAY, START, END):  Sortiert ein ADT-Array ARRAY im Bereich von START bis END mittels SelectionSort
  
  
insertions.erl
  insertionS/3 (ARRAY, START, END):  Sortiert ein ADT-Array ARRAY im Bereich von START bis END mittels InsertionSort