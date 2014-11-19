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
   Verf�gbare Funktionen
\--------------------------/

generator.erl
  sortNum/2 (LENGTH, MODE): Generiert eine Zahlenfolge der L�nge LENGTH und schreibt sie in die Datei "zahlen.dat" aus.
                            Die Art der Reihenfolge wird �ber MODE bestimmt.
                            Akzeptierte Werte f�r MODE sind:
                            random:        Zuf�llige Zahlenfolge
                            random_nodup:  Zuf�llige Zahlenfolge ohne doppelte Vorkommen
                            ascending:     Aufsteigend sortierte Zahlenfolge
                            descending:    Absteigend sortierte Zahlenfolge

  readList/0 ():            Liest aus der Datei "zahlen.dat" eine Erlang-Liste ein, konvertiert diese in ein ADT-Array und gibt es zur�ck.
  saveList/1 (ARRAY):       Speichert ARRAY als Erlang-Liste in der Datei "sortiert.dat".
  
  
messung.erl
  startMessung/1 (ALGORITHM): F�hrt insgesamt 100 Sortierdurchg�nge, mit 100-stelligen Zahlenfolgen, f�r den gew�hlten Algorithmus ALGORITHM durch
                              und sichert die Durchschnittswerte aller Messungen in der Datei "messung.dat".
                              Davon sind 80 Durchg�nge mit Zufallszahlenfolgen, 10 mit aufsteigend sortierten und 10 mit absteigend sortierten Zahlenfolgen.
                              Aktzeptierte Werte f�r ALGORITHM sind:
                              insertion:  Durchf�hrung mit InsertionSort
                              selection:  Durchf�hrung mit SelectionSort
                              all:        Je eine vollst�ndige Durchf�hrung, wie oben beschrieben, f�r alle Algorithmen.
                              
  run/0 ():                   Ruft startMessungen(ALGORITHM) mit ALGORITHM = all auf

  
selection.erl
  selectionS/3 (ARRAY, START, END):  Sortiert ein ADT-Array ARRAY im Bereich von START bis END mittels SelectionSort
  
  
insertions.erl
  insertionS/3 (ARRAY, START, END):  Sortiert ein ADT-Array ARRAY im Bereich von START bis END mittels InsertionSort