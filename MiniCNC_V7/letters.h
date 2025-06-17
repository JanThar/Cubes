// x -69 ... -1 -> 18mm Bild, -50... -1 Text > 53mm/10
// letter 4*6mm + 1mm abstand
// Y -63 ... -1 -> 3cm Höhe max?? -> -32 Middle
// z -20 ... -1
//    -> nach homingschritt auf neutralstellung fahren.
//    -> nach buchstaben in Neutralstellung fahren for weiterem bewegen
//    -> StartBild/Nach ersten Schritt Buchstaben runterfahren auf Arbeitshöhe

// https://rop.nl/truetype2gfx/ 

//7x5 pixel font
// -> mit 4 Pixel pro mm 16x24pixel font
// font erstellen: fontsize+3 pixel=breite font
// 70x100 pixel Bild
// 18mmm Bildbreite 4 Pixel pro mm... alte Bilschirmauflösung
// Auflösungsgrenze Auge 0.1mm, dh. 10Pixel pro mm wären optimal
// https://javl.github.io/image2cpp/ nutzen mit nem Standardfont, bzw alten Mac-Systefont
// Chicago (sans-serif) 1-7.6 (also: iPods)
// Charcoal 8-9
//Adafruit" GLCD font which is 7x5 used on TFT, textsize 3: 21x15?? -> change font?? 
//(gleicher Font wiew im "reallen" Druck, zumindest weniger pixelig)
//dann ggfs ein grosses bitmap erstellen - ungleichmässige Abstände beim font erlauben zwischen Buchstaben.. monospace font wäre aber einfacher!
// entweder direct aus font erzeugen oder font zerlegen in EInzelbitmaps
// im einem Fall einheitlich mit Bild, aber schlechter falls Font ersetzt wird
// und vor allem: schlechter für Anzeige, daher font verwenden
// problem font is real bmp, byte array would be easier
// test if only offset
// check bitmap format... image2cpp ist nen byteformat

// display: 0x00 (black) background, mill: 0xFF (white) background
/*
//900 bytes für 100*70 -> x filled up to bytes: 72
int bitmapDelay = 0;
int bitmapZWork = -19.2;
int bitmapZRest = -15;
int bitmapIndex = 0;
int bitmapTempIndex = 0;
int bitmapX = 72;   //correct: 72
int bitmapY = 100;  //correct: 100
int bitmapSize = (bitmapX * bitmapY)/8;
int bitmapPositionX,bitmapPositionY;
char maskIndex[] = {0x80, 0x40, 0x20, 0x10, 0x08, 0x04, 0x02, 0x01};

for (int i=0; i<bitmapSize; i++) {
  char value = bitmap[i]; //get a value from the bitmap
  if (value == 0x00) // do nothing
  else {
    //get bit by bit, if bit == 1 sendGcode(positionX, positionY)
    for(int j=0; j<8; j++)n {
      if ((value && maskIndex[j])>0) { //display value
        bitmapTempIndex = bitMapIndex+j;
        bitmapPositionX = tempIndex%bitmapX;
        bitmapPositionY = tempIndex/bitmapY;
        //move to position, moveZ down (bitmapZOffset), delay (bitmapDelay), moveZ up -> only zOffset,zTime needs to be adjusted for different machines
        convert pixel to mm (*0.25) 18mm Bild, 70 Pixel -> 17,5mm
        String bitmapPosition = "G0 X" + bitmapPositionX + " Y" + bitmapPositionY;
        // same replacement with tempstring, but 5 values (0,25mm)
        // but tempstring needs to be adjusted as well (different font)
        char goToPixel[][14]{
          bitmapPosition;
          //"G0 Z" + bitmapZWork
          //delay(bitmapDelay);
          //"G0 Z" + bitmapZRest
        }
        sendGRBL(goToPixel, sizeof(goToPixel));
        sendGRBL(goToWork, sizeof(goToWork));
        delay(bitmapDelay);
        sendGRBL(goToMove, sizeof(goToMove));
      }
    }
  }
  bitMapIndex +=8;
}
*/

// Start sequence
const char initGRBL[][14]{
  //Settings on GRBL board
  // dir and step pins exchanged
  "$0 = 10",        // Step pulse length in µs 3
  "$1 = 5",         // Step idle time - motors stay on, 255 always on
  "$3 = 0",         // axis direction XYZ 0NNN 1YNN 2NYN 3YYN 4NNY 5YNY 6NYY 7YYY
  "$4 = 0",         // step enable invert
  "$5 = 0",         // Limits switch with pullup
  "$6 = 0",         // ???
  "$10 = 1",        // status report 1
  "$11 = 0.010",    // cornering speed 0.020
  "$12 = 0.002",    // arc speed
  "$13 = 0",        // 1 for report in inches instead of mm
  "$22 = 1",        // Homing cycle enforced/enabled
  "$20 = 1",        // Soft Limit switch on
  "$21 = 1",        // Hard Limit switch on
  "$23 = 6", //6       // ... direction XYZ 0NNN 1YNN 2NYN 3YYN 4NNY 5YNY 6NYY 7YYY
  "$24 = 50",       // Homing feed mm/min
  "$26 = 50",       // Homing debounce 250
  "$27 = 1",        // Homing pull off - distance to button
  "$30 = 1000",     // Max Spindle speed
  "$31 = 0",        // Min spindle speed
  "$32 = 0",        // Laser-mode enable, boolean
  "$100 = 460",     // X Steps/mm
  "$101 = 460",     // Y Steps/mm
  "$102 = 460",     // Z Steps/mm
  "$110 = 460",     // max X rate mm/min 500
  "$111 = 460",     // max Y rate mm/min 500
  "$112 = 460",     // max Z rate mm/min 500
  "$120 = 50",      // max X acc mm/sec^2 50
  "$121 = 50",      // max Y acc mm/sec^2 50
  "$122 = 50",      // max Z acc mm/sec^2 50
  "$130 = 69",      // max X Travel mm -69 -> !0 triggers button, -1 ok
  "$131 = 69",      // max Y Travel mm -63 -> !0 triggers button, -1 ok
  "$132 = 32"       // max Z Travel mm -20
};

char bufferString[][14] = {"G0 X0 Y-0"};

const char home[][14]{
  "G28"   // Set current position as 0
};

const char startGCODE[][14]{
  "$22 = 1",    // Homing cycle enforced/enabled
  "$20 = 1",    // Soft Limit switch on
  "$21 = 1",    // Hard Limit switch on
  "$H",         // do homing cycle
  "$22 = 0",    // Homing cycle enforced/enabled
  "$20 = 0",    // Soft Limit switch off
  "$21 = 0",    // Hard Limit switch off
  "G92 X0 Y0",  // Set current position as 0
  "G90",        // absolute positions
  "G21",        // metric
  "G17",        // xy plane
  "G28",        // home x and y axis
  "M8",         // turn on door led - red
  "M4 S1000"    // Laser on max power
};

// End sequence
const char endGCODE[][14]{
  "G28",          // home x and y axis
  "G92 X0 Y0",    // Set current position as 0
  "G0 X0 Y-63",   // Move platform to front
  "M5",           // turn off laser
  "M9",           // turn on door led - green - has to be enabled!!
};

// turn on green front LED - has to be enabled!!
const char LEDgreen[][14]{
  "M7"
};

// turn on red front LED - has to be enabled!!
const char LEDred[][14]{
  "M8"
};

// turn off front LED - has to be enabled!!
const char LEDoff[][14]{
  "M9"
};

const char imagePosition[][14]{
  "G0 X-60 Y-32"
};

const char firstRow[][14]{
  "G0 X-50 Y-37"
};
const char middleRow[][14]{
  "G0 X-50 Y-29"
};
const char upperRow[][14]{
  "G0 X-50 Y-33"
};
// const char lowerRow[][14]{
//   "G0 X-50 Y-25"
// };

const char nextRow[][14]{
  // "G0 X-45 Y8"
};

const char setPos[][14]{
  "G92 X0 Y0"  // Set current position as 0
};

const char goToWork[][14]{
  "G0 Z-19.2"  // move toolhead down //18.8
};
const char goToMove[][14]{
  "G0 Z-15"  // move toolhead up
};

const char endLetter[][14]{
  "G0 X5 Y0"  // Set current position as 0
};

const char letterList[30][16][3] = {
  { "30", "10", "01", "05", "16", "36", "45", "40", "21" }, //(Q) 9
  { "06", "00", "22", "40", "46" }, //(W) 5
  { "46", "06", "03", "33", "03", "00", "40" }, //(E) 7
  { "00", "06", "36", "45", "44", "33", "03", "23", "40" }, //(R) 9
  { "06", "46", "26", "20" }, //(T) 4
  { "06", "23", "20", "23", "46" }, //(Y) 5
  { "06", "01", "10", "30", "41", "46" }, //(U) 6
  { "16", "36", "26", "20", "30", "10" }, //(I) 6
  { "05", "01", "10", "30", "41", "45", "36", "16", "05" }, //(O) 9
  { "00", "06", "36", "45", "44", "33", "03" }, //(P) 7
  { "00", "26", "33", "13", "33", "40" }, //A 6
  { "00", "30", "41", "42", "33", "13", "04", "05", "16", "46" }, //(S) 10
  { "00", "06", "36", "45", "41", "30", "00" }, //(D) 7
  { "00", "03", "33", "03", "06", "46" }, //(F) 6
  { "23", "43", "41", "30", "10", "01", "05", "16", "36", "45" }, //(G) 10
  { "00", "06", "03", "43", "46", "40" }, //(H) 6
  { "02", "01", "10", "30", "41", "46", "06" }, //(J) 7
  { "00", "06", "03", "40", "03", "46" }, //(K) 6
  { "06", "00", "40" }, //(L) 3
  { "03", "43" }, //(-) 2
  { "06", "46", "00", "40" }, //(Z) 4
  { "00", "46", "23", "06", "40" }, //(X) 5
  { "45", "36", "16", "05", "01", "10", "30", "41" }, //(C) 8
  { "06", "20", "46" }, //(V) 3
  { "00", "06", "36", "45", "44", "33", "13", "33", "42", "41", "30", "00" }, // B 12
  { "00", "06", "40", "46" }, //(N) 4
  { "00", "06", "24", "46", "40" }, //(M) 5
  { "31", "34", "24", "13", "12", "21", "31", "42", "44", "35", "15", "04", "01", "10", "30", "41" }, //(@) 16
  { "00", "36", "24", "14", "44", "34", "46", "10", "22", "02", "32" }, //(#) 11
  { "40" } //( ) 1
};

const int letterLength[30]{
  9, 5, 7, 9, 4, 5, 6, 6, 9, 7,
  6, 10, 7, 6, 10, 6, 7, 6, 3, 2,
  4, 5, 8, 3, 12, 4, 5, 16, 11, 1
};
