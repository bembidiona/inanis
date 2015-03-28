import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.net.*;
import java.net.InetAddress;
import java.net.UnknownHostException;

JSONObject json;
JSONArray inputs = new JSONArray();
int inputNum = 0; 


final private String appName = "Inanis";
final private String version = "v0.1";

final private Boolean DEBUG = true;
String debugLog = "LOG: ";

String allText = "";
String stream = "Type something";
String altKeys = "";
int colorBg = 0;
int colorTxt = 255;

int step = 10;

String breaker = "./ ";
String savePath = "";
PFont fontOptions;
String pixFormat = "png"; 

String[] buttonsNames = {"saveJson", "loadJson", "-", ".txt", ".img","-", "img", "folder", "-","day/night","-","start server","start client","-","keys","?","-","exit"};
ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<Letter> letters = new ArrayList<Letter>();
ArrayList<Star> stars = new ArrayList<Star>();

Boolean firstBlood = true;

int timerMouseInactive = 0;
int timeMouseInactive = 2000;
boolean mouseInactive = false;

int timerKeysInactive = 0;
int timeKeysInactive = 2000;
boolean keysInactive = true;

Boolean cursorHand = false;

boolean isPressed_Ctrl = false;
boolean isPressed_Alt = false;

String lastWord = "";
//don't forget to add new TRIGGERS in the setup section!!!
String[] triggerLOVE = {"amor", "love", "amar", "shrimp"};
String[] triggerDEAD = {"muerte", "dead", "fetal"};
String[] triggerGLITCH = {"glitch", "bakun", "art"};
String[] triggerCLIENT = {"connect", "conectar"};
private int charsTriggerMax;
private int charsTriggerMin;

String mode = "stars";

Message messager;
Caret caret;

int bgAlpha = 255;
Ani tweenGlitch;


//net
Boolean conectedServer = false;
Boolean conectedClient = false;
Server server;
Client client;
private final int port = 12345;
String input;
 
void setup() {
  frame.setTitle(appName + " " + version);
  PImage iconImg = loadImage("icon.png");
  PGraphics icon = createGraphics(256, 256, JAVA2D);
  icon.beginDraw();
  icon.image(iconImg, 0, 0, 256, 256); 
  icon.endDraw();
  frame.setIconImage(icon.image);
  
 
  
  //---------------
  
  size(displayWidth, displayHeight); 
  json = new JSONObject();
  timerMouseInactive = millis();
  
  Ani.init(this);
   
  
  fontOptions = loadFont("courier_15.vlw");  
  
  textAlign(RIGHT, CENTER);
  textSize(30);
  fill(50);
  cursor(CROSS);
  
  int uiBlank = 0;
  for (int i = 0; i < buttonsNames.length; i++){
    if (buttonsNames[i] != "-"){
      buttons.add(new Button(buttonsNames[i],i,uiBlank));
    }
    else uiBlank++;
  }
  
  messager = new Message();
  caret = new Caret();
  
  //----------
  for (int i = 0; i < triggerLOVE.length; i++){    
    setMaxMinTriggers(triggerLOVE[i].length());
  }
  for (int i = 0; i < triggerDEAD.length; i++){    
    setMaxMinTriggers(triggerDEAD[i].length());
  }
  for (int i = 0; i < triggerGLITCH.length; i++){    
    setMaxMinTriggers(triggerGLITCH[i].length());
  }
  for (int i = 0; i < triggerCLIENT.length; i++){    
    setMaxMinTriggers(triggerCLIENT[i].length());
  }
}
 
void draw() {
  fill(colorBg, bgAlpha);
  rect(0,0,width,height); 
   
  cursorHand = false;
  
  noStroke();  
  fill(colorTxt);
  caret.display();
  for (int i=letters.size()-1; i >= 0; i--) {
    Letter l = letters.get(i);
    if (l.isOut) letters.remove(i);
    else l.display();
  }  
  for (int i=stars.size()-1; i >= 0; i--) {
    Star s = stars.get(i);
    if (s.isOut) stars.remove(i);
    else s.display();
  }
    
  //tapon  
  fill(colorBg);
  rect(0, 0, width/6, height);  
  noFill();  
  setGradient(width/6, 0, width/4, height, color(colorBg, colorBg, colorBg), color(colorBg, colorBg, colorBg, 0), true);
  
  for (Button b : buttons) {
    b.display();
  } 
  messager.display();
  
  if(!mouseInactive){
    if (cursorHand) cursor(HAND);
    else cursor(CROSS);
  }
  
  //Timers
  if(millis() - timerMouseInactive >= timeMouseInactive && !cursorHand){
    timerMouseInactive = millis();
    mouseInactive = true;
    noCursor();
  }  
  if(millis() - timerKeysInactive >= timeKeysInactive){
    timerKeysInactive = millis();
    keysInactive = true;    
  }
  
  //net
  if (conectedServer || conectedClient){
    text("m8 say: "+input, width/2 , height/2+50);
    
    
    if(conectedServer){
       server.write(lastWord);
      
       client = server.available();
       if (client != null){         
         checkNetInput(); 
       }
    }
    else if(conectedClient){
      client.write(lastWord);
      
      if (client.available() > 0) {        
        checkNetInput();        
      }
    }
    
    
  }
  //debug
  if (DEBUG) {
    text(debugLog, width/2,height/2-150);
  }
  
}
 
void keyPressed() {
  keysInactive = false;
  messager.itsEnded();
  
  if (firstBlood){
    for (Button b : buttons) {
      b.out();
    }
    stream = "";    
    firstBlood = false;
  }
  
  
  writeKeyJson(keyCode, false);
    
  if (keyCode == CONTROL){
     isPressed_Ctrl = true;
  }
  if (keyCode == ALT){
     isPressed_Alt = true;
  }
  if (keyCode == DELETE){
     debugLog = "";
  }
  
  
  
  if (keyCode == ENTER){
     caret.addChar(breaker, false);
     caret.jump();
  }
  if (keyCode == BACKSPACE) {
    if (stream.length() > 0) {
      caret.removeChar();      
    }
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && keyCode != ENTER) {
    
    if(isPressed_Ctrl){
      if(keyCode == 83) saveTxt(); //s
      else if(keyCode == 69) savePix(); //e      
    }
    else if(isPressed_Alt){
      altKeys = altKeys + str(key);
    }
    else{
      if(keyCode == 32){ // space
        stars.add(new Star());
        
        checkTriggers();        
        lastWord = "";
        
        caret.addChar(str(key), true);
      }
      else caret.addChar(str(key), false);      
    }
  }
}
void keyReleased() {
  if (keyCode == CONTROL){
    isPressed_Ctrl = false;
  }
  if (keyCode == ALT){
    isPressed_Alt = false;
    
    // TODO
    // for some reason the conversion to chars is using the second table: http://www.irongeek.com/alt-numpad-ascii-key-combos-and-chart.html
    // so, hardcodie los acentos y la ñ por ahora
    
    int i = int(altKeys);
    String hackedChar = Character.toString((char)i); 
    
    if(i == 164) hackedChar = "ñ";
    else if(i == 160) hackedChar = "á";
    else if(i == 161) hackedChar = "í";
    else if(i == 162) hackedChar = "ó";
    else if(i == 163) hackedChar = "ú";
    else if(i == 130) hackedChar = "é";    
    
    caret.addChar(hackedChar, false); 
     
    altKeys = "";
  }
}


boolean sketchFullScreen() {
  return !DEBUG;
}

void setGradient(int x, int y, float w, float h, color c1, color c2, boolean axisX ) {
  noFill();
  noStroke();
  if (axisX == true) {  // Left to right gradient
    for (int i = x; i <= x+w-3; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c1, c2, inter);
      fill(c);
      rect(i, y, 1, h);
    }
  }  
}

void mousePressed(){
  for (Button b : buttons) {
    b.checkClick();
  }  
}

void mouseMoved(){
  mouseInactive = false;
  
  if(!firstBlood){
    if(mouseX > width - 100){     
        for (Button b : buttons) {
          b.in();
        }
    }
    else{
        for (Button b : buttons) {
          b.out();
        }
    }
  }
}


// Save stuff
void saveJson(){
  
   json = new JSONObject();
   json.setJSONArray("inputs", inputs);
      
   saveJSONObject(json, savePath + "/stream.json");
 
   messager.show("json saved", 1);
}
void loadJson(){
  
   JSONObject jsonL = loadJSONObject( savePath + "/stream.json");
  
   messager.show("work in progress", 1);
}

void saveTxt(){
   String[] list = split(stream, breaker);
   saveStrings(savePath + "/vomito_"+day()+"-"+month()+"-"+year()+".txt", list);
 
   messager.show("txt saved", 1);
}
void savePix(){
  save(savePath +second()+"-"+hour()+"-"+day()+"."+pixFormat); 
  
  messager.show("pix saved", 1);
}
void checkPath(File selection){
if (selection == null) {
   println("Window was closed or the user hit cancel.");
   } else {
      savePath = selection.getAbsolutePath();     
   }   
}

//Triggers
void setMaxMinTriggers(int _charsNum){
  if(_charsNum > charsTriggerMax) charsTriggerMax = _charsNum;
  if(_charsNum < charsTriggerMin) charsTriggerMin = _charsNum;
}

void checkTriggers(){
  
  int lastWordSize = lastWord.length();
  
  if(lastWordSize < charsTriggerMin) return;
  if(lastWordSize <= charsTriggerMax){
    lastWord = lastWord.toLowerCase();
    
    for (int i = 0; i < triggerLOVE.length; i++){    
      if(lastWord.equals(triggerLOVE[i])) triggerLOVE();
    }
    for (int i = 0; i < triggerDEAD.length; i++){    
      if(lastWord.equals(triggerDEAD[i])) triggerDEAD();
    }
    for (int i = 0; i < triggerGLITCH.length; i++){    
      if(lastWord.equals(triggerGLITCH[i])) triggerGLITCH();
    }    
  }
  else{ //lastWord is bigger than charsTriggerMax    
    for (int i = 0; i < triggerCLIENT.length; i++){       
      String lt = lastWord.substring(0, triggerCLIENT[i].length()); 
      String ltIp = lastWord.substring(triggerCLIENT[i].length() + 1);
      
      if(lt.equals(triggerCLIENT[i])) startClient(ltIp);    
    }
  }
}
void triggerDEAD(){
  for (Star s : stars) {
    s.txt = "†";
  } 
}
void triggerLOVE(){
  for (Star s : stars) {      
    s.txt = "<3";
  } 
}
void triggerGLITCH(){
  tweenGlitch = new Ani(this, 5, "bgAlpha", 1, Ani.EXPO_IN_OUT);  
}

// NET
void startServer(){
  try {
    String[] ip = loadStrings("http://icanhazip.com/");
    
    InetAddress me = InetAddress.getLocalHost();
    String dottedQuad = me.getHostAddress();
    messager.show("server started. Your IPs are -> LOCAL: "+dottedQuad +" - PUBLIC: " + ip[0]);
    
    server = new Server(this, port);
    
    conectedServer = true;
    
  } catch (UnknownHostException e) {
    messager.show("FAIL", 1);
  } 
}
void triggerCLIENT(){    
}
void startClient(String _ip){
  try {
    client = new Client(this, _ip, port);
    messager.show("conected!", 1);  
  
    conectedClient = true;  
  } catch (Error e) {
    messager.show("FAIL", 1);
  } 
}

void checkNetInput(){
  input = client.readString();
}

void printDebug(String txt){
  debugLog = debugLog + " // " + txt;
}
//------------
void writeKeyJson(int _key, Boolean wasReleased){
  
  JSONObject input = new JSONObject();
  
  input.setInt("time", millis());
  input.setInt("key", _key); 
  input.setBoolean("release", wasReleased);
  
  inputs.setJSONObject(inputNum, input);
  
  inputNum++;
}
 


