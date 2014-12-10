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

(quicksort.erl kompilieren und compileDependencies/0 ausführen!)

liste.erl
array.erl
generator.erl
util.erl
selections.erl

/--------------------------\
   Verfügbare Funktionen
\--------------------------/

quicksort.erl
  compileDependencies/0 (): Kompiliert alle benötigten Module. Die Module müssen dafür im Arbeitsverzeichnis liegen.

  quicksortRekursiv/3 (ARRAY, START, END): Sortiert ARRAY von der Position START bis Position END mittels Quicktsort.
                                           Je Aufruf wird das erste (linkeste) Element wird als Pivot-Element gewählt.
                                            
  quicksortRekursiv/4 (ARRAY, START, END, PIVOT_FUNC(X,Y)): Sortiert ARRAY von der Position START bis Position END mittels Quicktsort.
                                                            Mittels PIVOT_FUNC(X,Y) kann eine anonyme Funktion zur Bestimmung des Pivot-Elements übergeben werden.

  quicksortRandom/3 (ARRAY, START, END): Sortiert ARRAY von der Position ANFANG bis Position END mittels Quicktsort.
                                         Je Aufruf wird das Pivot-Element zufällig innerhalb ARRAY bestimmt.