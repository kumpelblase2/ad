         _____     _                   
        |  ___|   | |                  
        | |__ _ __| | __ _ _ __   __ _ 
        |  __| '__| |/ _` | '_ \ / _` |
        | |__| |  | | (_| | | | | (_| |
        \____/_|  |_|\__,_|_| |_|\__, |
                                  __/ |
                                 |___/ 
##############################################
##        - ADP WS14/15 Aufgabe 3 -         ##
##           Gruppe 03 // Team 9            ##
##               Tim Hagemann               ##
##                Tim Hartig                ##
##############################################

/--------------------------\
  Zu kompilierende Dateien
\--------------------------/

liste.erl
array.erl
generator.erl
util.erl
selections.erl

/--------------------------\
   Verfügbare Funktionen
\--------------------------/

quicksort.erl
  quicksortRekursiv/3 (ARRAY, START, ENDE): Sortiert ARRAY von der Position ANFANG bis Position ENDE mittels Quicktsort.
                                            Je Aufruf wird das erste (linkeste) Element wird als Pivot-Element gewählt.

  quicksortRandom/3 (ARRAY, START, ENDE): Sortiert ARRAY von der Position ANFANG bis Position ENDE mittels Quicktsort.
                                          Je Aufruf wird das Pivot-Element zufällig innerhalb ARRAY bestimmt.