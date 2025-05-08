- scad datei allgemeine datei. Wenn man di folgenden Sachen auf 1 setz kriegt man ne Aubauvorschau
  // Show lasercutted housing [0,1]
  showWall = 0;
  // Show lasercutted mechanics [0,1]
  showMechanics = 0;
  // Show 3D-printed parts [0,1]
  showPrint = 0;
  // Show axis and motors [0,1]
  showDrive = 0;
  // Show electronics [0,1]
  showElectronic = 0;
  bzw. mit // Flatten for lasercutting [0,1] flatten = 1;
  projection(cut = false) mechanics();
  oder
  projection(cut = false) walls();
  die Laserdateien und unter // 3D-printed die einzelnen 3D-Druckdateien
- svg für den laser, bei der Mechanics datei die z-achse platte und zahnstangen
  (links, zweite/dritte/vierte von oben) nicht cutten, wird vermutlich durch 3D druck ersetzt.
-  stl dateien zum drucken, Anzahl am Ende des Namens. Die 3 Toolhalter (Mill, Penholder, Laser)
  müssen noch mal überarbeitet werden (und dann zusammen mit z-Achsenplatte und Zahnstangen) 
