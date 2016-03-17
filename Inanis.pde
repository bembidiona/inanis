import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.net.*;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.event.KeyEvent;

final private String appName = "Inanis";
final private String version = "v0.4";


final int USER = 0;
final int ROBOT = 1;

JSONArray inputs = new JSONArray();
int inputNum = 0;
Boolean recording = false;
Boolean recordingStarted = false;
int recordStartTime = 0;

Robot robot;
Boolean streamLoopOn = true;

int uiZone = 100;
int uiZoneNormal = 100;


String debugLog = "LOG: ";

String altKeys = "";
color colorBg;
color colorGradient;
color colorGradientAlpha;
color colorTxt;
color colorTrigger;
color colorExtra;
int themeSelected = 0;
int fontSelected = 0;


int step = 8;

String pilcrow = "¶ ";
String savePath = "";
PFont fontOptions;
String pixFormat = "png"; 

Boolean filterInvert = false;

boolean mainShow = true;
String[] buttonsNames = {"LOAD", "-", ".sav", ".txt", ".img", "-", "font", "theme", "day/night", "-", "sound/silence", "-", "start server", "start client", "-", "keys", "   ?", "-", "exit"};
ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<Writer> writers = new ArrayList<Writer>();
int writersNum = 0;
ArrayList<Star> stars = new ArrayList<Star>();
ArrayList<Rain> rain = new ArrayList<Rain>();
Boolean isRaining = false;

Boolean firstBlood = true;

int timerMouseInactive = 0;
int timeMouseInactive = 2000;
Boolean mouseInactive = false;
Boolean clickedOverACaret = false;
Boolean mouseIsDragging = false;
int mousePressX = 0;
int mousePressY = 0;

int timerKeysInactive = 0;
int timeKeysInactive = 2000;
Boolean keysInactive = true;

Boolean cursorHand = false;
Boolean releasedLoadJson = true;

//don't forget to also add the new TRIGGERS in the setup section!!!
String[] triggerLOVE = {"amor", "love", "amar", "shrimp", "afecto"};
String[] triggerDEAD = {"muerte", "mori", "dead", "fetal"};
String[] triggerGLITCH = {"glitch", "bakun", "art", "arte"};
String[] triggerCLIENT = {"connect", "conectar"};
String[] triggerSAVE = {".sav"};
String[] triggerTXT = {".txt"};
String[] triggerDEBUG = {"debug"};
String[] triggerCOLOR = {"color", "colour"};
String[] triggerFONT = {"font", "letra"};
String[] triggerPIX = {".png", ".bmp", ".jpg", ".jpeg", ".tiff"};
String[] triggerSCALE = {"encerrado", "grande", "big", "close", "cerca"};
String[] triggerBLOOD = {"sangre", "blood", "pelo", "hair"};
String[] triggerPANIC = {"panic", "ansiedad", "attack", "panico", "pánico", "manija"};
String[] triggerPICADO = {"odio", "mar", "ocean", "hate", "water", "tormenta"};
String[] triggerRAIN = {"lluvia", "llover", "llueve", "lloviendo", "rain", "llorar", "cry", "tormenta"};
private int charsTriggerMax;
private int charsTriggerMin;

String mode = "stars";

Message messager;

Writer user;
Writer writerDraged;



int bgAlpha = 255;
Ani tweenGlitch;
Ani tweenScale;
Ani tweenBlood;
Ani tweenLetterGlicth;
Ani tweenPicado;

float scaleAll = 1;
int blood = 0;

float letterGlitch = 0;

Recorder recorder;
SoundPlayer soundPlayer;
Minim minim;

//net
Boolean conectedServer = false;
Boolean conectedClient = false;
Server server;
Client client;
private final int port = 12345;
String input;

// perlin waves
float yoff = 0.0;
private int wavesY;
final private int wavesStep = 5; 
int picado = 5;

Boolean DEBUG = true;
void settings() {
  //fullScreen(FX2D);
  size(displayWidth, displayHeight);
  
  
}


void setup() {
  surface.setTitle(appName + " " + version);
  PImage icon = loadImage("icon.png");  
  surface.setIcon(icon);

  try {
    robot = new Robot();
  }
  catch(AWTException e) {
    println(e);
  }
  
  

  changeTheme();
  changeFont();    
  timerMouseInactive = millis();

  Ani.init(this);

  minim = new Minim(this);
  soundPlayer = new SoundPlayer();
  recorder = new Recorder();  


  textAlign(RIGHT, CENTER);  
  fill(50);
  cursor(CROSS);

  int uiBlank = 0;
  for (int i = 0; i < buttonsNames.length; i++) {
    if (buttonsNames[i] != "-") {
      buttons.add(new Button("main", buttonsNames[i], i, uiBlank));
    } else uiBlank++;
  }

  createUIStreams();

  user = new Writer(USER);
  writers.add(user);  



  messager = new Message();


  //----------
  for (int i = 0; i < triggerLOVE.length; i++) {    
    setMaxMinTriggers(triggerLOVE[i].length());
  }
  for (int i = 0; i < triggerDEAD.length; i++) {    
    setMaxMinTriggers(triggerDEAD[i].length());
  }
  for (int i = 0; i < triggerGLITCH.length; i++) {    
    setMaxMinTriggers(triggerGLITCH[i].length());
  }
  for (int i = 0; i < triggerCLIENT.length; i++) {    
    setMaxMinTriggers(triggerCLIENT[i].length());
  }
  for (int i = 0; i < triggerSAVE.length; i++) {    
    setMaxMinTriggers(triggerSAVE[i].length());
  }
  for (int i = 0; i < triggerSCALE.length; i++) {    
    setMaxMinTriggers(triggerSCALE[i].length());
  }
  for (int i = 0; i < triggerPANIC.length; i++) {    
    setMaxMinTriggers(triggerPANIC[i].length());
  }
  for (int i = 0; i < triggerBLOOD.length; i++) {    
    setMaxMinTriggers(triggerBLOOD[i].length());
  }
  for (int i = 0; i < triggerPICADO.length; i++) {    
    setMaxMinTriggers(triggerPICADO[i].length());
  }
  for (int i = 0; i < triggerRAIN.length; i++) {    
    setMaxMinTriggers(triggerRAIN[i].length());
  }
  for (int i = 0; i < triggerDEBUG.length; i++) {    
    setMaxMinTriggers(triggerDEBUG[i].length());
  }

  wavesY = height - height/10;
}



void draw() { 
  textFont(fontOptions);

  fill(colorBg, bgAlpha);
  rect(0, 0, width, height); 



  if (scaleAll != 1) {
    translate( width/2, height/2);  
    scale(scaleAll);    
    translate( -(width/2), -(height/2));
  }



  noStroke();  
  fill(colorTxt);

  soundPlayer.display();

  for (Writer w : writers) {
    w.display();
  }     




  mouseCheckDrag();
  if (!mouseInactive) {
    if (cursorHand) cursor(HAND);
    else cursor(CROSS);
  }
  cursorHand = false;

  //stars
  for (int i=stars.size()-1; i >= 0; i--) {
    Star s = stars.get(i);
    if (s.isOut) stars.remove(i);
    else s.display();
  }

  // RAIN
  if (isRaining) {
    rain.add(new Rain());
  }
  for (int i=rain.size()-1; i >= 0; i--) {
    Rain r = rain.get(i);
    if (r.isOut) rain.remove(i);
    else r.display();
  }  


  //Timers
  if (millis() - timerMouseInactive >= timeMouseInactive && !cursorHand) {
    timerMouseInactive = millis();
    mouseInactive = true;
    noCursor();
  }  
  if (millis() - timerKeysInactive >= timeKeysInactive) {
    timerKeysInactive = millis();
    keysInactive = true;
  }
  if (recordingStarted && millis() > recordStartTime + 500) {
    recording = true;
  }

  //net
  if (conectedServer || conectedClient) {
    text("m8 say: "+input, width/2, height/2+50);


    if (conectedServer) {
      server.write(user.lastWord);

      client = server.available();
      if (client != null) {         
        checkNetInput();
      }
    } else if (conectedClient) {
      client.write(user.lastWord);

      if (client.available() > 0) {        
        checkNetInput();
      }
    }
  }




  //gradients
  int gradientSize = 40; 
  setGradient(0, 0, gradientSize, height, colorGradient, colorGradientAlpha, 1);
  setGradient(width-gradientSize, 0, gradientSize, height, colorGradient, colorGradientAlpha, 2);
  setGradient(0, 0, width, gradientSize, colorGradient, colorGradientAlpha, 3);
  setGradient(0, height-gradientSize, width, gradientSize, colorGradient, colorGradientAlpha, 4);

  //marco
  int cosito = 5;  
  noFill();  
  for (int i = 1; i <= 5; i++) {
    stroke(colorTxt, 100 - cosito*i*5);
    rect(cosito*i, cosito*i, width-cosito*2*i, height - cosito*2*i);
  }  
  noStroke();   
  //----------

  for (Button b : buttons) {
    b.display();
  }
  messager.display();

  // -------------------
  // perlin ocean
  // --------------------
  int seasDistance = 5;
  for (int i = 0; i <= 2; i++) {
    if (true) fill(colorTxt, 255 - 100*i);
    else {
      noFill();
      stroke(colorTxt, 255 - 100*i);
    }

    beginShape();  
    float xoff = 0;  
    for (float x = 0; x <= width; x += 10) {
      float y = map(noise(xoff, yoff), 0, 1, wavesY - seasDistance*i, wavesY + picado - seasDistance*i);

      vertex(x, y); 

      xoff += 0.05;
    }
    yoff += 0.01;
    vertex(width, height);
    vertex(0, height);
    endShape(CLOSE);
  }
  //-------------------------

  if (filterInvert) filter(INVERT);
  //filter(THRESHOLD);

  recorder.display();




  //debug
  if (DEBUG) {

    fill(colorTxt);
    stroke(255, 0, 0);    
    text(debugLog, width/2, height/2-150);

    line(width - uiZone, 0, width - uiZone, height);

    textAlign(LEFT, CENTER);
    text("FPS:"+str(ceil(frameRate)), 55, 30);
  }
  
  
   
}

void keyPressed() {
  keysInactive = false;
  messager.itsEnded();

  if (firstBlood) {
    for (Button b : buttons) {
      b.out();
    }
    user.stream = "";    
    firstBlood = false;
  } 

  if (key == CODED) {
    user.keyPress(int(keyCode));
  } else {
    user.keyPress(int(key));
  }
}
void keyReleased() {
  if (key == CODED) {    
    user.keyRelease(int(keyCode));
  } else {    
    user.keyRelease(key);
  }
}


void setGradient(int x, int y, float w, float h, color c1, color c2, int axis) {
  noFill();
  noStroke();
  if (axis == 1) {  // Left to right gradient
    for (int i = x; i <= x+w-3; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      fill(c);
      rect(i, y, 1, h);
    }
  } else if (axis == 2) {  // right to left gradient
    for (int i = x; i <= x+w-3; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c2, c1, inter);
      fill(c);
      rect(i, y, 1, h);
    }
  } else if (axis == 3) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  } else if (axis == 4) {  // bottom to Top gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c2, c1, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }
}

void mouseCheckDrag() {
  if (clickedOverACaret) {
    if (mouseIsDragging) {
      writerDraged.x = mouseX;
      writerDraged.y = mouseY;
    } else {
      int safe = 20;
      if ( (mouseX < mousePressX-safe || mouseX > mousePressX+safe) ||
        (mouseY < mousePressY-safe || mouseY > mousePressY+safe)) {
        mouseIsDragging = true;
      }
    }
  }
}

void mousePressed() {
  mousePressX = mouseX;
  mousePressY = mouseY;

  for (Writer w : writers) {
    if (w.isOver()) {
      if (mouseButton == LEFT) {
        clickedOverACaret = true; //HACK      
        writerDraged = w;
        writerDraged.isBeingDraged = true;      
        writerDraged.startX = mouseX;
        writerDraged.startY = mouseY;
      } else {


        w.delete();
      }
    }
  }

  for (int i = writers.size() - 1; i >= 0; i--) {
    Writer w = writers.get(i);
    if (w.toRemove) {
      writers.remove(i);
    }
  }
}
void showSubMenu(String _menu) {    
  mainShow = false;    
  for (Button b : buttons) {
    if (b.menu.equals("main")) b.out();
    //else if (menu.equals(_menu)) b.in();
    else b.in();
  }
} 
void mouseReleased() {
  clickedOverACaret = false;

  if (mouseX > width - uiZone) {
    for (Button b : buttons) {
      b.checkClick();
    }
    if (releasedLoadJson) {
      releasedLoadJson = false;

      for (int i=buttons.size()-1; i > 0; i--) {    
        Button b = buttons.get(i);
        if (b.menu.equals("streams")) buttons.remove(i);
      }

      createUIStreams();

      showSubMenu("streams");
    }
  } else if (mouseX < 100) recorder.checkClick();
  else if (mouseIsDragging == true) {
    mouseIsDragging = false;
    writerDraged.stopDrag();
  } else if (mouseButton == LEFT && user.canTeleport) {
    user.addChar(". ", false);
    user.stream = user.stream + pilcrow;               
    user.teleport(mouseX, mouseY, true);
  }
}
void mouseMoved() {
  mouseInactive = false;

  if (!firstBlood) {
    if (mouseX > width - uiZone) {     
      if (mainShow) {

        int longestName = 0;
        for (Button b : buttons) {
          if (b.menu.equals("main")) {
            b.in();
            if (b.name.length() > longestName) longestName = b.name.length();
          }
        }
        uiZone = longestName * 15;
      }
    } else {
      mainShow = true;
      uiZone = uiZoneNormal;
      for (Button b : buttons) {
        b.out();
      }
    }
  }
}






void saveTxt(String _saveName) {

  String saveName = _saveName;     
  if (_saveName.equals("")) saveName = "vomito_"+day()+"-"+month()+"-"+year();

  String[] list = split(writers.get(0).stream, pilcrow);
  saveStrings(savePath + "/"+ saveName +".txt", list);

  messager.show("txt saved", 1);
}
void savePix(String _saveName) {
  String saveName = _saveName;     
  if (_saveName.equals("")) {
    saveName = "vomito_"+day()+"-"+month()+"-"+year();
    save(savePath + saveName +"."+pixFormat);
  } else save(savePath + saveName);

  messager.show("pix saved", 1);
}
void checkPath(File selection) {
  if (selection == null) {
    println("Window was closed or the user hit cancel.");
  } else {
    savePath = selection.getAbsolutePath();
  }
}

//Triggers
void setMaxMinTriggers(int _charsNum) {
  if (_charsNum > charsTriggerMax) charsTriggerMax = _charsNum;
  if (_charsNum < charsTriggerMin) charsTriggerMin = _charsNum;
}



void changeStars(String _txt) {
  for (Star s : stars) {
    s.change(_txt);
  }
}
void triggerDEAD() {
  changeStars("†");
}
void triggerLOVE() {
  changeStars("<3");
}
void triggerGLITCH() {
  tweenGlitch = new Ani(this, 10, "bgAlpha", 1, Ani.EXPO_IN_OUT);
  tweenGlitch.setPlayMode(Ani.YOYO);
  tweenGlitch.repeat(2);
}
void triggerSCALE() {
  tweenScale = new Ani(this, 10, "scaleAll", 2, Ani.EXPO_IN_OUT);
  tweenScale.setPlayMode(Ani.YOYO);
  tweenScale.repeat(2);
}
void triggerBLOOD() {
  tweenBlood = new Ani(this, 10, "blood", height, Ani.EXPO_IN_OUT);
  tweenBlood.setPlayMode(Ani.YOYO);
  tweenBlood.repeat(2);
}
void triggerPANIC() {
  tweenLetterGlicth = new Ani(this, 10, "letterGlitch", 0.5, Ani.EXPO_IN_OUT);
  tweenLetterGlicth.setPlayMode(Ani.YOYO);
  tweenLetterGlicth.repeat(2);
}
void triggerPICADO() {
  tweenPicado = new Ani(this, 20, "picado", 60, Ani.EXPO_IN_OUT);
  tweenPicado.setPlayMode(Ani.YOYO);
  tweenPicado.repeat(2);
}
void triggerRAIN() {
  isRaining = true;
}

// NET
void startServer() {
  try {
    String[] ip = loadStrings("http://icanhazip.com/");

    InetAddress me = InetAddress.getLocalHost();
    String dottedQuad = me.getHostAddress();
    messager.show("server started. Your IPs are -> LOCAL: "+dottedQuad +" - PUBLIC: " + ip[0]);

    server = new Server(this, port);

    conectedServer = true;
  } 
  catch (UnknownHostException e) {
    messager.show("FAIL", 1);
  }
}
void triggerCLIENT() {
}
void startClient(String _ip) {
  try {
    client = new Client(this, _ip, port);
    messager.show("conected!", 1);  

    conectedClient = true;
  } 
  catch (Error e) {
    messager.show("FAIL", 1);
  }
}

void checkNetInput() {
  input = client.readString();
}

void printDebug(String txt) {
  debugLog = debugLog + " // " + txt;
}
//------------
void writeInput(String _type, int _key, Boolean wasReleased, int _x, int _y) {  
  JSONObject input = new JSONObject();

  input.setInt("time", millis() - recordStartTime);
  input.setString("type", _type);
  input.setInt("key", _key); 
  input.setBoolean("release", wasReleased);
  input.setInt("x", _x);
  input.setInt("y", _y); 

  inputs.setJSONObject(inputNum, input);

  inputNum++;
}

void wavesUp() {
  wavesY -= wavesStep;
  int tope = height/2 + height/8;

  if (wavesY < tope) wavesY = tope;
}
void wavesDown() {
  wavesY += wavesStep;
  int tope = height + (picado*2);

  if (wavesY > tope) wavesY = tope;
}





//=======================
class LoadedInput { 
  String type;
  int t;
  int k;
  Boolean r;
  int x;
  int y;

  LoadedInput(String _type, int _t, int _k, boolean _r, int _x, int _y ) {
    type = _type; 
    t = _t;
    k = _k;
    r = _r;
    x = _x;
    y = _y;
  }
} 


// Save stuff
void saveJson(String _saveName, Boolean _wasTriggered) {
  if (_wasTriggered && recording) {         
    int len = inputs.size() - 1;
    for (int i = len; i > len - (_saveName.length() + ".sav".length()) *2; i--) {
      inputs.remove(i);
    }
    recordOFF();
  }


  String saveName = _saveName;

  if (_saveName.equals("")) {
    saveName = user.lastWord + "_" + day()+"-"+month()+"-"+year();
  }  

  saveJSONArray(inputs, savePath + "/streams/"+ saveName + ".sav");   

  messager.show("saved", 1);

  //instaload!
  loadJson(saveName+".sav");
}
void loadJson(String _filename) {

  messager.show(_filename + " loaded", 1);

  JSONArray inputValues = loadJSONArray("E:/Proyects/inanis/streams/"+ _filename);

  Writer w = new Writer(ROBOT);
  writers.add(w);

  w.loadedInputs.clear();  

  for (int i = 0; i < inputValues.size(); i++) { 


    JSONObject in = inputValues.getJSONObject(i); 

    w.loadedInputs.add(new LoadedInput(
      in.getString("type"), 
      in.getInt("time"), 
      in.getInt("key"), 
      in.getBoolean("release"), 
      in.getInt("x"), 
      in.getInt("y") ));
  }

  w.loadedTimeOffset = millis();
  w.readingLoadedInputs = true;
  w.loadedInputNum = 0;  
  w.loadedInputTime = w.loadedInputs.get(0).t;
}

void createUIStreams() {
  int uiBlank = 0;
  File dataFolder = new File("E:/Proyects/inanis/streams");
  String[] fileList = dataFolder.list();
  int longestName = 0; 
  for (int i = 0; i < fileList.length; i++) {
    buttons.add(new Button("streams", fileList[i], i, uiBlank));
    if (fileList[i].length() > longestName) longestName = fileList[i].length();
  }
  uiZone = longestName * 15;
}

void changeTheme() {
  if (themeSelected == 1) {
    themeSelected++;

    colorTxt = color(187, 214, 181);
    colorTrigger = color(238, 247, 225, 255);
    colorBg = color(19, 82, 90);
    colorGradient = color(30, 66, 86, 255);
    colorGradientAlpha = color(colorGradient, 0);
    colorExtra = color(68, 139, 135);
  } else if (themeSelected == 2) {
    themeSelected++;

    colorTxt = color(255, 255, 250);
    colorTrigger = color(242, 76, 39);
    colorBg = color(2, 73, 89);
    colorGradient = color(3, 126, 140, 50);
    colorGradientAlpha = color(colorGradient, 0);
    colorExtra = color(255, 255, 250);
  } else { //default
    themeSelected = 1;

    colorTxt = color(230, 255);
    colorTrigger = color(136, 200, 200, 255);
    colorBg = color(20, 22, 23, 255);
    colorGradient = color(20, 25, 25, 255);
    colorGradientAlpha = color(colorGradient, 0);      
    colorExtra = color(255, 255, 250);
  }
}
void changeFont() {
  if (fontSelected == 1) {
    fontSelected++;
    fontOptions = loadFont("anonymous-15.vlw");
  } else if (fontSelected == 2) {
    fontSelected++;
    fontOptions = loadFont("MonospaceTypewriter-13.vlw");
  } else if (fontSelected == 3) {
    fontSelected++;
    fontOptions = loadFont("Jauria-15.vlw");
  } else if (fontSelected == 4) {
    fontSelected++;
    fontOptions = loadFont("Terminus-14.vlw");
  } else {
    fontSelected = 1;
    fontOptions = createFont("fonts/Consolas.ttf", 20); //loadFont("courier-15.vlw");
  }
}

void recordON() {

  inputs = new JSONArray();
  inputNum = 0;

  recordStartTime = millis();
  recordingStarted = true;   

  messager.show("inputs are being recorded");
}

void recordOFF() { 
  user.lastWord = "";
  user.addChar(" ", true);

  recordingStarted = false;
  recording = false;
  messager.show("recording stop", 2);
}