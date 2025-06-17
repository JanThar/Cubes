//Pinout ESP32-3248S035
// LED onboard: Blue-IO17, Red-IO4, Green-IO16  -> replace status LED on front
// Photoresistor: IO34
// Speaker: V01,V02 - IO26
// SD DAT2-3.3V,CD-IO5, CMD/MOSI-IO23,VDD-3.3V,CLX/CLK-IO18,VSS-GND,DAT0/MISO-IO19,DAT1-??,CD-?? -> Data storage (images)
// I2C
// 4Pin VIN,TX-IO1,RX-IO3,GND Serial            -> GRBL sender, power supply
// TPC???
// 4Pin GND/NC/IO21/3.3V Temp&Humidity???       -> 
// 4Pin GND/IO35/IO22/IO21 Extended IO          -> check door?? check housing??
// Display IO27 LED, CLK-IO14, MISO-IO12, MOSI-IO13, CS-IO15, RS-IO2
// Flash IO6, IO7, IO8, IO9, IO10, IO11         -> alternative for data storage, unpopulated
// Touch SDA-IO33,SCL-32,IRQ-IO36,RST-IO25
// !! (missing) 5V led strip (white) - solder directly at Serial or pads S3/S1 (or LED driver)

// BMP und GCODE parallel auf SD-Karte, gleicher Name, andere Endung


// LED pinout
#define LED_RED    4
#define LED_GREEN 16
#define LED_BLUE  17

// Bluetooth
#include "BluetoothSerial.h"

#if !defined(CONFIG_BT_ENABLED) || !defined(CONFIG_BLUEDROID_ENABLED)
#error Bluetooth is not enabled! Please run `make menuconfig` to and enable it
#endif

BluetoothSerial SerialBT;
String deviceName = "CubeLASER";
int BTconfirmed = 0;

// Tft
#include <SPI.h>
#include <TFT_eSPI.h>
TFT_eSPI tft = TFT_eSPI(320,480);

#include "VeraMono17pt7b.h"
#define TEXTOFFSET 20
#define TEXTSIZESMALL 1
#define TEXTSIZEBIG 1

// Touch
#include "TouchDrvGT911.hpp"
#define SENSOR_SDA  33
#define SENSOR_SCL  32
#define SENSOR_IRQ  36
#define SENSOR_RST  25

TouchDrvGT911 touch;
int16_t touchX[5], touchY[5];

//  SD CARD
#include "FS.h"
#include "SD.h"
#include "SPI.h"

#define SPI_SCK 18
#define SPI_MISO 19
#define SPI_MOSI 23
#define SPI_SS_SD 5

void init_sd();
void listDir(fs::FS &fs, const char * dirname, uint8_t levels);

File myDesigns;

char namebuf[32] = "/";   //BMP files in root directory

// screen stuff

#include "bitmaps.h"
#include "letters.h"
#include "screens.h"

#define MINPRESSURE 200
#define MAXPRESSURE 1000

#define NAMEMATCH ""         // "" matches any name
#define PALETTEDEPTH   8     // support 256-colour Palette

bool debug = true;
bool GRBLactive = false;

int txtPos = 0;
int txtIndex = 0;
int txtMaxLength = 10;

int imgIndex = 0;

int pageIndex = 0;

int txtBuf[30];

String fileNameBMP, fileNameNC;

TFT_eSPI_Button keypad[3][10];
TFT_eSPI_Button imageBTN;
TFT_eSPI_Button okBTN;
TFT_eSPI_Button backBTN;
char keyChar[30] = {  // Only Uppercase
  'Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P',
  'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', '-',
  'Z', 'X', 'C', 'V', 'B', 'N', 'M', '@', '#', ' '
};

String allLetters = "QWERTYUIOPASDFGHJKL-ZXCVBNM@# ";
char theLetter = allLetters.charAt(0);

String Test = "Hallo";
int pixel_x, pixel_y;  //Touch_getXY() updates global vars

#define BLACK 0x0000
#define BLUE 0x001F
#define RED 0xF800
#define GREEN 0x07E0
#define CYAN 0x07FF
#define MAGENTA 0xF81F
#define YELLOW 0xFFE0
#define WHITE 0xFFFF
#define GREY 0x39E7

bool Touch_getXY(void) {
  uint8_t touched = touch.getPoint(touchX, touchY, touch.getSupportTouchPoint());
  if (touched > 0) {
    pixel_x = touchY[0];
    pixel_y = 320-touchX[0];
    if(debug) {
      //Serial.print(millis());
      //Serial.print("ms ");
      //for (int i = 0; i < touched; ++i) {
        Serial.print("X: ");
        Serial.print(pixel_x);
        Serial.print(" ,Y: ");
        Serial.println(pixel_y);
        //Serial.print(" ,Pressed: ");
        //Serial.println(touched > 0);
        //tft.fillRect(touchY[0], 320-touchX[0], 5, 5, RED);
      //}
    }
    return true;
  }
  return false;
}

//  SD CARD
//  ==========================================
void init_sd() {
  if(!SD.begin(SS)){
    SPIClass spi = SPIClass(VSPI);
    if(!SD.begin(SS, spi, 80000000))
      Serial.println("Card Mount Failed");
    return;
  }
  uint8_t cardType = SD.cardType();

  if(cardType == CARD_NONE){
    Serial.println("No SD card attached");
    return;
  }

  Serial.print("SD Card Type: ");
  if(cardType == CARD_MMC){
    Serial.println("MMC");
  } else if(cardType == CARD_SD){
    Serial.println("SDSC");
  } else if(cardType == CARD_SDHC){
    Serial.println("SDHC");
  } else {
    Serial.println("UNKNOWN");
  }

  uint64_t cardSize = SD.cardSize() / (1024 * 1024);
  Serial.printf("SD Card Size: %lluMB\n", cardSize);

  listDir(SD, "/", 1);
  Serial.println("------");
  listDir(SD, "/", 1);
}

void listDir(fs::FS &fs, const char * dirname, uint8_t levels){
  Serial.printf("Listing directory: %s\n", dirname);
  try {
    File root = fs.open(dirname);
    if(!root){
      Serial.println("Failed to open directory");
      return;
    }
    if(!root.isDirectory()){
      Serial.println("Not a directory");
      return;
    }

    File file = root.openNextFile();
    while(file){
      if(file.isDirectory()){
        Serial.print("  DIR : ");
       Serial.println(file.name());
        if(levels){
          listDir(fs, file.name(), levels -1);
        }
      } else {
        Serial.print("  FILE: ");
       Serial.print(file.name());
        Serial.print("  SIZE: ");
        Serial.println(file.size());
      }
      file = root.openNextFile();
    }
    root.close();

  } catch(String error) {
    Serial.println("LS: Oops exception");
  }
  Serial.println("LS: NEXT");
}

void setup(void) { //setup second serial for sending gcode
  pinMode(LED_RED, OUTPUT);
  pinMode(LED_GREEN, OUTPUT);
  pinMode(LED_RED, OUTPUT);
  setStatusLED(0,255,255);
  delay(100);
  setStatusLED(255,255,0);
  delay(100);
  Serial.begin(115200); 

  // Set the default PIN - not working
//  esp_bt_pin_type_t pin_type = ESP_BT_PIN_TYPE_FIXED;
//  esp_bt_pin_code_t pin_code = {'1', '2', '3', '4'}; // Change '1234' to your desired PIN
//  esp_bt_gap_set_pin(pin_type, 4, pin_code);

  SerialBT.begin(deviceName); 
  tft.init();
  tft.setRotation(1);  //PORTRAIT
  tft.setFreeFont(&VeraMono15pt7b);

  // start SD
  init_sd();

  touch.setPins(SENSOR_RST, SENSOR_IRQ);
  if (!touch.begin(Wire, GT911_SLAVE_ADDRESS_L, SENSOR_SDA, SENSOR_SCL)) {
    while (1) {
      Serial.println("Failed to find GT911 - check your wiring!");
      delay(1000);
    }
  }

  Serial.println("Init GT911 Sensor success!");

  // Set the center button to trigger the callback , Only for specific devices, e.g LilyGo-EPD47 S3 GT911
  touch.setHomeButtonCallback([](void *user_data) {
    Serial.println("Home button pressed!");
  }, NULL);

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 10; j++) {
      theLetter = allLetters.charAt(i*10+j);//i*10+j
      keypad[i][j].initButton(&tft, 24 + j * 48, 154 + i * 46, 42, 40, WHITE, BLACK, WHITE,&theLetter, TEXTSIZESMALL); 
    }
  }

  initKeyPadButtons();

  imageBTN.initButton(&tft, 128, 62, 70, 112, BLACK, BLACK, WHITE, " ", TEXTSIZESMALL);
  backBTN.initButton(&tft, 336, 296, 90, 40, WHITE, BLACK, WHITE, "<-", TEXTSIZESMALL);
  okBTN.initButton(&tft, 432, 296, 90, 40, WHITE, BLACK, WHITE, "OK", TEXTSIZESMALL);

  if (debug) Serial.println("Startup done");
  setStatusLED(255,0,255);
  initWelcomeScreen();
}

void setStatusLED(int red, int green, int blue) {
  analogWrite(LED_RED, red);
  analogWrite(LED_GREEN, green);
  analogWrite(LED_BLUE, blue);
}

void sendGRBL(const char text[][14], int size) {
  // send command
  for(int j=0;j<size/14;j++) {
    Serial1.println(text[j]);
    Serial1.flush();
    if (debug) Serial.println(text[j]);
    Serial.flush();
  
    //wait for ok
    bool ack = false;
    while(!ack) {
      while (Serial1.available()) {       
       // If anything comes in Serial1 (pins 0 & 1)
       char test = Serial1.read();
       Serial.write(test);
       Serial.flush();
        if (test == 'k') {
          ack = true;
        }
      }
    }
  }
}

void initWelcomeScreen() {
  tft.fillScreen(BLACK);
  tft.drawRoundRect(3, 2, 474, 120, 10, WHITE);
  // Text/Image Printenlaser, Preparations

  okBTN.drawButton(false);

  tft.drawRoundRect(3, 2, 474, 120, 10, WHITE);

  tft.setTextColor(WHITE);
  tft.setTextSize(TEXTSIZEBIG);
  tft.setCursor(180, 20+TEXTOFFSET);
  tft.print(welcometitle[0]);
  tft.setCursor(180, 50+TEXTOFFSET);
  tft.print(welcometitle[1]);
  tft.setCursor(180, 80+TEXTOFFSET);
  tft.print(welcometitle[2]);

  tft.drawBitmap(93, 10, epd_bitmap_allArray[0], 70, 100, WHITE);

  tft.setTextSize(TEXTSIZESMALL);

  for(int i=0;i<(sizeof(startscreen)/40);i++) {
    tft.setCursor(10, 140+i*30+TEXTOFFSET);
    tft.print(startscreen[i]);
  }
  for(int i=0; i<5; i++) {
    tft.setCursor(10, 140+i*30+TEXTOFFSET);
    tft.print(startscreen[i]);
  }
}

void initDesignScreen() {
  tft.fillScreen(BLACK);
  tft.drawRoundRect(3, 2, 474, 120, 10, WHITE);

  drawTextArea();

  imageBTN.drawButton(false);
  drawImageArea();

  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 10; j++) {
      keypad[i][j].drawButton(false);
    }
  }
  backBTN.drawButton(false);
  okBTN.drawButton(false);
}

void initStartScreen() {
  //Everything ok (Printe, door closed)
  tft.fillRect(3, 122, 474, 150, BLACK);

  tft.setTextSize(TEXTSIZESMALL);
  tft.setTextColor(WHITE);
  for(int i=0; i<5; i++) {
    tft.setCursor(10, 140+i*30+TEXTOFFSET);
    tft.print(initscreen[i]);
  }

  backBTN.drawButton(false);
  okBTN.drawButton(false);
}

void initProcessScreen() {
  tft.fillRect(0, 0, 480, 320, BLACK);
  tft.drawRoundRect(3, 2, 474, 120, 10, WHITE);
  
  tft.setTextSize(TEXTSIZESMALL);
  tft.setTextColor(WHITE);
  for(int i=0; i<5; i++) {
    tft.setCursor(10, 140+i*30+TEXTOFFSET);
    tft.print(processscreen[i]);
  }
}

void initFinishScreen() {
  //delete keyboard, keep the rest
  tft.fillRect(3, 122, 474, 152, BLACK);

  tft.setTextSize(TEXTSIZESMALL);
  tft.setTextColor(WHITE);
  for(int i=0; i<5; i++) {
    tft.setCursor(10, 140+i*30+TEXTOFFSET);
    tft.print(finishscreen[i]);
  }

  backBTN.drawButton(false);
  okBTN.drawButton(false);
}

void initConfirmationScreen() {
  //delete keyboard, keep the rest
  tft.fillRect(3, 122, 474, 152, BLACK);

  tft.setTextSize(TEXTSIZESMALL);
  tft.setTextColor(RED);
  for(int i=0; i<5; i++) {
    tft.setCursor(10, 140+i*30+TEXTOFFSET);
    tft.print(confirmationscreen[i]);
  }

  tft.setTextColor(WHITE);
  backBTN.drawButton(false);
  okBTN.drawButton(false);
}

void initExternalControlScreen() {
  //delete keyboard, keep the rest
  tft.fillRect(0,0, 480, 320, BLACK);

  tft.setTextSize(TEXTSIZESMALL);
  tft.setTextColor(RED);
  for(int i=0; i<5; i++) {
    tft.setCursor(10, 140+i*30+TEXTOFFSET);
    tft.print(externalscreen[i]);
  }
}

void drawImageArea() {
  if (imgIndex == 0) {
    tft.fillRoundRect(93, 6, 70, 112, 10, BLACK);
    tft.setTextColor(GREY);
    tft.setTextSize(TEXTSIZESMALL);
    tft.setCursor(95, 20+TEXTOFFSET);
    tft.print(designtitle[0]);
    tft.setCursor(95, 50+TEXTOFFSET);
    tft.print(designtitle[1]);
    tft.setCursor(95, 80+TEXTOFFSET);
    tft.print(designtitle[2]);
    tft.drawRoundRect(93, 6, 70, 112, 10, GREY);
  } else {
    tft.drawBitmap(93, 10, epd_bitmap_allArray[imgIndex-1], 70, 100, WHITE);
  }
}

void drawTextArea() {
  if(txtIndex == 0) {
    tft.fillRect(163, 6, 300, 112, BLACK);
    tft.setTextColor(GREY);
    tft.setTextSize(TEXTSIZEBIG);
    tft.setCursor(180, 20+TEXTOFFSET);
    tft.print(designtitle[3]);
    tft.setCursor(180, 50+TEXTOFFSET);
    tft.print(designtitle[4]);
    tft.setCursor(180, 80+TEXTOFFSET);
    tft.print(designtitle[5]);
  } else {
    tft.fillRect(163, 6, 300, 112, BLACK);
    tft.setTextColor(WHITE);
    tft.setTextSize(TEXTSIZEBIG);
    int txtOffset = 30;
    if (txtIndex>txtMaxLength) txtOffset = 15;
    if (txtIndex>txtMaxLength*2) txtOffset = 0;
    for (int i = 0; i < txtIndex; i++) {
      tft.setCursor(180 + 18 * (i%txtMaxLength), 20 + 30 * (i/txtMaxLength)+txtOffset+TEXTOFFSET);
      tft.print(keyChar[txtBuf[i]]);
    }
    if (txtIndex<txtMaxLength*3) {
      tft.setTextColor(GREY);
      tft.setCursor(180 + 18 * (txtIndex%txtMaxLength), 20 + 30 * (txtIndex/txtMaxLength)+txtOffset+TEXTOFFSET);
      tft.print("|");
    }
  }
}

// Array of button addresses to behave like a list
TFT_eSPI_Button *keyPadButtons[60];
TFT_eSPI_Button *backButtons[] = {&backBTN, NULL};
TFT_eSPI_Button *okButtons[] = {&okBTN, NULL};
TFT_eSPI_Button *imageButtons[] = {&imageBTN, NULL};

void initKeyPadButtons() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 10; j++) {
      keyPadButtons[i*10+j] = &keypad[i][j];
    }
  }
  keyPadButtons[30] = NULL;
}

// update the state of a button and redraw
bool update_button(TFT_eSPI_Button *b, bool down) {  
  b->press(down && b->contains(pixel_x, pixel_y));
  if (b->justReleased())
    b->drawButton(false);
  if (b->justPressed())
    b->drawButton(true);
  return down;
}

bool update_button_list(TFT_eSPI_Button **pb) {
  bool down = Touch_getXY();
  //Serial.println("Update Buttons");
  for (int i = 0; pb[i] != NULL; i++) {
    //Serial.println("check button");
    update_button(pb[i], down);
  }
  return down;
}

void loop(void) {
  bool down = Touch_getXY();
  // direct connection through bluetooth for external control
  if (Serial.available()) {
    SerialBT.write(Serial.read());
  }
  //passcode not working, alternative confirmation on screen for first received char
  if (SerialBT.available()) {
    if (BTconfirmed==0){
      initConfirmationScreen();    
      while(BTconfirmed==0) {
        down = Touch_getXY();
        confirmationWindow();
      }
    }
      // show cinfirmation window, set unconfirmed == true}
    if (BTconfirmed==2){
      Serial.write(SerialBT.read());
    }
  }

  if(pageIndex == 0) welcomeBadge();
  if(pageIndex == 1) designBadge();
  if(pageIndex == 2) startBadge();
  if(pageIndex == 3) processBadge();
  if(pageIndex == 4) finishBadge();
}

void confirmationWindow() {
  update_button_list(backButtons);
  if (backBTN.justPressed()) {
    BTconfirmed = 1;
    if(pageIndex == 0) initWelcomeScreen();
    if(pageIndex == 1) initDesignScreen();
    if(pageIndex == 2) initStartScreen();
    if(pageIndex == 3) initProcessScreen();
    if(pageIndex == 4) initFinishScreen();
  }
  update_button_list(okButtons);
  if (okBTN.justPressed()) {
    BTconfirmed = 2;
    pageIndex = 5;
    initExternalControlScreen();
  }
}

void welcomeBadge() {
   update_button_list(okButtons);
  if (okBTN.justPressed()) {
    pageIndex++;
    initDesignScreen();    
  }
}

void designBadge() {
  update_button_list(keyPadButtons);
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 10; j++) {
      if(keypad[i][j].justPressed()){
        if (txtIndex < 30) {
          txtBuf[txtIndex] = i*10+j;
          txtIndex++;
          drawTextArea();
        }
      }
    }
  }
  update_button_list(imageButtons);
  if (imageBTN.justReleased()) {
    imgIndex++;
    if(imgIndex>imgNumber) imgIndex=1;
    drawImageArea();
  }
  update_button_list(backButtons);
  if (backBTN.justPressed()) {
    if(txtIndex > 0) {
      txtIndex--;
      drawTextArea();
    }
  }
  update_button_list(okButtons);
  if (okBTN.justPressed()) {
    pageIndex++;
    initStartScreen();
  }
}

//scanne array, hex zu bit, position mitzählen, je pixel+1, daraus x,y Koordinaten (%Breite, /Höhe)
// ggfs fallunterschiedung hex oder direkt in binär wandeln
// 0x00 -> position+32, nix machen da alles null
// sonst binärwerte durchgehen, wenn ≠1 an position fahren und Pixel ausführen (ggfs mit delay, hoch/runter, laser an/aus), in jedem Fall position +1
//-> abhängig Tool, rest immer gleich

void startBadge() {
  update_button_list(okButtons);
  if (okBTN.justPressed()) {
    pageIndex++;
    initProcessScreen();   
  } 
   update_button_list(backButtons);
  if (backBTN.justPressed()) {
    pageIndex=1;
    tft.fillRect(3, 122, 474, 150, BLACK);
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 10; j++) {
        keypad[i][j].drawButton(false);
      }
    }
  }
}

// home ersetzen zum beschleunigen
// endposition Buchstabe bekannt, (i%10)*breite Buchstabe zurück zur Startposition. Problem von da aus weiter da abhängig von aktueller Zeile. Aber: nach startzeile wird jede zeile um konstanten wert verschoben, d.h. ne y-bewegung reicht
// G0 -X((i%10)*5)) Y0 ... ist aber eh nur interessant bei voller zeile, d.h. G0 X-50 Y0
// dann G0 X0 Y8 ggfs zusammenfassen, aber bei letzer Zeile & 3 Zeilen würde man dann aus der Begrenzung fahren.
void processBadge() {
  //ToDo: send gcode G90/G81 umschalten zwischen relativ & absoluten Koordinaten
  //update progress bar?, design file on top (passiv - aktiv - fertig)
  // 1. Init Laser. Homing etc.: sendGRBL(initGRBL,sizeof(initGRBL)); only once at startup
  setStatusLED(0,255,255);
  if (debug) Serial.println("Start GCode Image: ");
  if(GRBLactive)sendGRBL(startGCODE,sizeof(startGCODE));
  // 2. Laser Bild
  //tft.fillRect(93, 6, 70, 112, BLACK);
  //start sending GCODE for image
  if(imgIndex>0) tft.drawBitmap(93, 10, epd_bitmap_allArray[imgIndex-1], 70, 100, GREY);

  
  delay(200);  // ToDO: send gcode for image
  for(int j=0;j<(sizeof(imagePosition)/15);j++) Serial.println(imagePosition[j]);
  
  //finished sending GCODE for image
  if(imgIndex>0) tft.drawBitmap(93, 10, epd_bitmap_allArray[imgIndex-1], 70, 100, WHITE);
  // 3. Laser Text
  if (debug) Serial.println("Start GCode Text: ");
  //tft.fillRect(163, 6, 300, 112, BLACK);
  tft.setTextSize(TEXTSIZEBIG);
  int txtOffset = 30;
  if (txtIndex>txtMaxLength) txtOffset = 15;
  if (txtIndex>txtMaxLength*2) txtOffset = 0;
  for (int i = 0; i < txtIndex; i++) {
    tft.setCursor(180 + 18 * (i%txtMaxLength), 20 + 30 * (i/txtMaxLength)+txtOffset+TEXTOFFSET);
    tft.setTextColor(GREY);
    tft.print(keyChar[txtBuf[i]]);
    // start sending GCODE for letter
    // set start position
    if (i==0) { // first letter
      //home 
      if(GRBLactive) sendGRBL(home,sizeof(home)); // if end position of image known we can accelerate this
      if (txtIndex<txtMaxLength+1) // depending on total number of letters
        if(GRBLactive)sendGRBL(middleRow,sizeof(middleRow));
      else if (txtIndex<2*txtMaxLength+1)
        if(GRBLactive)sendGRBL(upperRow,sizeof(upperRow));
      else
        if(GRBLactive) sendGRBL(firstRow,sizeof(firstRow));
    } else if (i==txtMaxLength) { // first letter of second row
      if(GRBLactive) sendGRBL(nextRow,sizeof(nextRow));
      // //home 
      // sendGRBL(home,sizeof(home));
      // if (txtIndex<txtMaxLength*2+1)
      //   sendGRBL(lowerRow,sizeof(lowerRow));
      // else 
      //   sendGRBL(secondRow,sizeof(secondRow));
    } else if (i==2*txtMaxLength) { // first letter of third row
      if(GRBLactive)sendGRBL(nextRow,sizeof(nextRow));
      // //home 
      // sendGRBL(home,sizeof(home));
      // sendGRBL(thirdRow,sizeof(thirdRow));
    }
    if(GRBLactive)sendGRBL(setPos,sizeof(setPos));
    // send code for individual letter
    Serial.print("Letter: ");
    Serial.println(keyChar[txtBuf[i]]);
    if(GRBLactive)for(int j=0;j<letterLength[i];j++) {
      //Serial.println(j);
      //J==0: head floating above
      if (j==1) sendGRBL(goToWork,sizeof(goToWork)); //move head to working position
          bufferString[0][4] = letterList[txtBuf[i]][j][0];
          bufferString[0][8] = letterList[txtBuf[i]][j][1];
        sendGRBL(bufferString,sizeof(bufferString));
    }
    Serial.println("EndLetter");
    if(GRBLactive)sendGRBL(goToMove,sizeof(goToMove));
    if(GRBLactive)sendGRBL(endLetter,sizeof(endLetter));

    //finished sending GCODE for letter
    tft.setCursor(180 + 18 * (i%txtMaxLength), 20 + 30 * (i/txtMaxLength)+txtOffset+TEXTOFFSET);
    tft.setTextColor(WHITE);
    tft.print(keyChar[txtBuf[i]]);
  }
  //end GCode Letters
  if (debug) Serial.println("End GCode: ");
  if(GRBLactive)sendGRBL(endGCODE,sizeof(endGCODE));
  setStatusLED(255,0,255);
  pageIndex++;
  initFinishScreen();  
}

void finishBadge() {
  update_button_list(backButtons);
  if (backBTN.justPressed()) {
    pageIndex = 2;
    initStartScreen();
  }
  update_button_list(okButtons);
  if (okBTN.justPressed()) {
    pageIndex = 0;
    txtIndex = 0;
    imgIndex = 0;
    initWelcomeScreen();
  }
}

void sendGcode(){
  //READING GCODE FILE AND SEND ON SERIAL PORT TO GRBL
  //START GCODE SENDING PROTOCOL ON SERIAL 1
  String line = "";
  Serial1.print("\r\n\r\n");      //Wake up grbl
  delay(2);
  //emptySerialBuf(1);
  if(myDesigns){                                                                      
    while(myDesigns.available()){    //until the file's end
      line = readLine(myDesigns);  //read line in gcode file 
      Serial.print(line);   //send to serials
      Serial1.print(line);
//           Serial.print(getSerial(1)); //print grbl return on serial
    }
  }
  else
    //fileError();

  myDesigns.close();
  Serial.println("Finish!!\n");
  //delay(2000);
}

void openFileSD(int number){
  fileNameNC = "/IMG";
  fileNameNC += number;
  fileNameNC += ".png";
  
  if(!SD.exists(fileNameNC)){       //check if file already exists
    Serial.print(fileNameNC);
    Serial.println(" doesn't exists");
  }else{
    myDesigns = SD.open(fileNameNC, FILE_READ);    //create a new file based upon fileNameChar
    Serial.print(fileNameNC);
    
  fileNameBMP = "/IMG";
  fileNameBMP += number;
  fileNameBMP += ".bmp";
  }
}

String readLine(File f){
  //return line from file reading  
  char inChar;
  String line = "";
  do{
    inChar =(char)f.read();
      line += inChar;
    }while(inChar != '\n');
  return line;
}

////https://github.com/tchepperz/ArdSketch/blob/master/serialGrblSkch/serialGrblSkch.ino
//
////void loop(){
////
////  while(restart){
////    openFileSD();
////    sendGcode();
////  }
////}
//
////change fo file numbers
//void openFileSD(){
//
//  String fileName = "";
//  char fileNameChar[100]={0};       // char array for SD functions arguments
//
//  Serial.println("Enter name for a gcode file on SD : \n");
//  emptySerialBuf(0);
//  fileName=getSerial(0);
//
//  for(int i=0;fileName.charAt(i)!='\n';i++)   //convert String in char array removing '\n'
//    fileNameChar[i]=fileName.charAt(i);
//
//  if(!SD.exists(fileNameChar)){       //check if file already exists
//    Serial.print("-- ");
//    Serial.print(fileNameChar);
//    Serial.print(" doesn't exists");
//    Serial.println(" --");
//    Serial.println("Please select another file\n");
//        delay(200);
//        openFileSD();
//    } 
//    else{
//      myFile = SD.open(fileNameChar, FILE_READ);    //create a new file
//      Serial.print("-- ");
//      Serial.print("File : ");
//    Serial.print(fileNameChar);
//    Serial.print(" opened!");
//    Serial.println(" --\n");
//    }
//}
//
//void emptySerialBuf(int serialNum){
//  //Empty Serial buffer
//  if(serialNum==0){
//    while(Serial.available())                      
//      Serial.read();
//  }
//  else if(serialNum==1){
//    while(Serial1.available())                      
//      Serial1.read();
//    }
//}
//
//void waitSerial(int serialNum){
//  // Wait for data on Serial
//  //Argument serialNum for Serial number
//
//  boolean serialAv = false;
//
//  if(serialNum==0){
//    while(!serialAv){ 
//      if(Serial.available())
//        serialAv=true;
//    }
//  }
//  else if(serialNum==1){
//    while(!serialAv){ 
//      if(Serial1.available())
//      serialAv=true;
//    }
//  }
//}
//
//String getSerial(int serialNum){
//
//  //Return String  from serial line reading
//  //Argument serialNum for Serial number
//
//  String inLine = "";
//  waitSerial(serialNum);
//
//  if(serialNum==0){
//    while(Serial.available()){              
//      inLine += (char)Serial.read();
//      delay(2);
//    }
//    return inLine;
//  }
//  else if(serialNum==1){
//    while(Serial1.available()){               
//        inLine += (char)Serial1.read();
//        delay(2);
//    }
//    return inLine;
//  }
//}
//
//void sendGcode(){
//
//  //READING GCODE FILE AND SEND ON SERIAL PORT TO GRBL
//
//  //START GCODE SENDING PROTOCOL ON SERIAL 1
//
//  String line = "";
//
//    Serial1.print("\r\n\r\n");      //Wake up grbl
//    delay(2);
//    emptySerialBuf(1);
//    if(myFile){                                                                      
//      while(myFile.available()){    //until the file's end
//        line = readLine(myFile);  //read line in gcode file 
//          Serial.print(line);   //send to serials
//          Serial1.print(line);
//          Serial.print(getSerial(1)); //print grbl return on serial
//    }
//  }
//  else
//    fileError();
//
//  myFile.close();
//  Serial.println("Finish!!\n");
//  delay(2000);
//}
//
//void fileError(){
//
//  // For file open or read error
//
//  Serial.println("\n");
//  Serial.println("File Error !");
//}
//
//String readLine(File f){
//  
//  //return line from file reading
//  
//  char inChar;
//  String line = "";
//
//  do{
//    inChar =(char)f.read();
//      line += inChar;
//    }while(inChar != '\n');
//
//  return line;
//}
