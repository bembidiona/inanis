final private String appName = "Inanis";
final private String version = "v0.2";
final Boolean DEBUG = true;

import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;
import processing.net.*;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.awt.Robot;
import java.awt.AWTException;
import java.awt.event.KeyEvent;

JSONObject json;
JSONArray inputs = new JSONArray();
int inputNum = 0;



Robot robot;
Boolean streamLoopOn = true;




String debugLog = "LOG: ";

String stream = "Type something";
String altKeys = "";
color colorBg = color(20,22,23,255);
color colorTxt = color(230,255);
color colorTrigger = color(136,255,100,255);

int step = 10;

String breaker = "./ ";
String savePath = "";
PFont fontOptions;
String pixFormat = "png"; 

Boolean filterInvert = false;

boolean mainShow = true;
String[] buttonsNames = {"saveJson", "loadJson", "-", ".txt", ".img","-", "img", "folder", "-","day/night","seaUp","seaDown","-","start server","start client","-","keys","?","-","exit"};
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

int timerKeysInactive = 0;
int timeKeysInactive = 2000;
Boolean keysInactive = true;

Boolean cursorHand = false;

boolean isPressed_Ctrl = false;
boolean isPressed_Alt = false;
boolean wasPressed_Tilde = false;

String lastWord = "";
//don't forget to add new TRIGGERS in the setup section!!!
String[] triggerLOVE = {"amor", "love", "amar", "shrimp"};
String[] triggerDEAD = {"muerte", "dead", "fetal"};
String[] triggerGLITCH = {"glitch", "bakun", "art"};
String[] triggerCLIENT = {"connect", "conectar"};
String[] triggerSCALE = {"encerrado", "grande", "big", "close", "cerca"};
String[] triggerBLOOD = {"sangre", "blood", "pelo", "hair"};
String[] triggerPANIC = {"panic", "ansiedad", "attack", "panico", "pánico"};
String[] triggerPICADO = {"odio", "mar", "ocean", "hate", "water", "tormenta"};
String[] triggerRAIN = {"lluvia", "rain", "llorar", "cry"};
private int charsTriggerMax;
private int charsTriggerMin;

String mode = "stars";

Message messager;
Caret caret;

int bgAlpha = 255;
Ani tweenGlitch;
Ani tweenScale;
Ani tweenBlood;
Ani tweenLetterGlicth;
Ani tweenPicado;

float scaleAll = 1;
int blood = 0;

float letterGlitch = 0;


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
int picado = 20;

 
void setup() {
  frame.setTitle(appName + " " + version);
  PImage iconImg = loadImage("icon.png");
  PGraphics icon = createGraphics(256, 256, JAVA2D);
  icon.beginDraw();
  icon.image(iconImg, 0, 0, 256, 256); 
  icon.endDraw();
  frame.setIconImage(icon.image);
  //---------------
  
  try{
    robot = new Robot();  
  }
  catch(AWTException e){
    println(e);
  }
  
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
      buttons.add(new Button("main", buttonsNames[i],i,uiBlank));
    }
    else uiBlank++;
  }

  createUIStreams();


  writers.add(new Writer());  

  
  messager = new Message();
  
  
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
  for (int i = 0; i < triggerSCALE.length; i++){    
    setMaxMinTriggers(triggerSCALE[i].length());
  }
  for (int i = 0; i < triggerPANIC.length; i++){    
    setMaxMinTriggers(triggerPANIC[i].length());
  }
  for (int i = 0; i < triggerBLOOD.length; i++){    
    setMaxMinTriggers(triggerBLOOD[i].length());
  }
  for (int i = 0; i < triggerPICADO.length; i++){    
    setMaxMinTriggers(triggerPICADO[i].length());
  }
  for (int i = 0; i < triggerRAIN.length; i++){    
    setMaxMinTriggers(triggerRAIN[i].length());
  }

  wavesY = height - height/10;
}
 
void draw() {  
  fill(colorBg, bgAlpha);
  rect(0,0,width,height); 
   
  cursorHand = false;
  
  if(scaleAll != 1){
    translate( width/2, height/2);  
    scale(scaleAll);      
    translate( -(width/2), -(height/2));  
  }



  noStroke();  
  fill(colorTxt);
   
  for (Writer w : writers) {
    w.display();
  }     
  
  
  for (Button b : buttons) {
    b.display();
  }  
  messager.display();
  
  if(!mouseInactive){
    if (cursorHand) cursor(HAND);
    else cursor(CROSS);
  }

  //stars
  for (int i=stars.size()-1; i >= 0; i--) {
    Star s = stars.get(i);
    if (s.isOut) stars.remove(i);
    else s.display();
  }

  // RAIN
  if(isRaining){
    rain.add(new Rain());  
  }
  for (int i=rain.size()-1; i >= 0; i--) {
    Rain r = rain.get(i);
    if (r.isOut) rain.remove(i);
    else r.display();
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


  // -------------------
  // perlin ocean
  // --------------------
  fill(colorTxt);
  beginShape();  
  float xoff = 0;  
  for (float x = 0; x <= width; x += 10) {
    float y = map(noise(xoff, yoff), 0, 1, wavesY, wavesY + picado);
    
    vertex(x, y); 
    
    xoff += 0.05;
  }
  yoff += 0.01;
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);
  //-------------------------
  
  
  //details
  int cosito = 5;  
  noFill();  
  for(int i = 1; i <= 5; i++){
    stroke(colorTxt, 100 - cosito*i*5);
    rect(cosito*i, cosito*i, width-cosito*2*i, height - cosito*2*i); 
  }  
  noStroke();
  //----------
  
  if (filterInvert) filter(INVERT);
  //filter(THRESHOLD);
  
 
  
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
  
  writeInput("key", keyCode, false, 0, 0);
  
  if (keyCode == UP){
    wavesUp();
  }
  else if (keyCode == DOWN){
    wavesDown();
  }
  else if (keyCode == CONTROL){
     isPressed_Ctrl = true;
  }
  else if (keyCode == ALT){
     isPressed_Alt = true;
  }
  else if (keyCode == DELETE){
     debugLog = "";
  }
  else if (keyCode == 129){ //tilde
     if (wasPressed_Tilde == true){
       writers.get(0).addChar("'", false);
       wasPressed_Tilde = false; 
     }
     else wasPressed_Tilde = true;
  }  
  else if (keyCode == ENTER){
     writers.get(0).addChar(breaker, false);
     writers.get(0).caret.jump();
  }
  else if (keyCode == BACKSPACE) {
    if (stream.length() > 0) {
      writers.get(0).removeChar();      
    }
  } else if (keyCode != SHIFT) {
    
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
        
        writers.get(0).addChar(str(key), true);
      }
      else if (wasPressed_Tilde){
        wasPressed_Tilde = false;
        
        String c = "´";
        if(keyCode == 65) c = "á";
        else if(keyCode == 69) c = "é";
        else if(keyCode == 65) c = "í";
        else if(keyCode == 79) c = "ó";
        else if(keyCode == 85) c = "ú";
        
        writers.get(0).addChar(c, false);
      }
      else writers.get(0).addChar(str(key), false);
    }
  }
}
void keyReleased() {
  writeInput("key", keyCode, true, 0, 0);
  
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
    
    writers.get(0).addChar(hackedChar, false); 
     
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
  if (mouseX > width/2+width/3){
    for (Button b : buttons) {
      b.checkClick();
    }
  }
  else{
    if(writers.get(0).caret.canTeleport){
      writers.get(0).addChar(breaker, false);
      writers.get(0).caret.teleport(mouseX,mouseY);
    }  
  }
  
}


void mouseMoved(){
  mouseInactive = false;
  
  if(!firstBlood){
    if(mouseX > width - 100){     
        if(mainShow){
          for (Button b : buttons) {
            if(b.menu.equals("main")){
              b.in();
            }
          }
        } 
        
    }    
    else{
        mainShow = true;
        for (Button b : buttons) {
          b.out();
        }     
    }
  }
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
      if(lastWord.equals(triggerLOVE[i])) { triggerLOVE(); paintWord();}
    }
    for (int i = 0; i < triggerDEAD.length; i++){    
      if(lastWord.equals(triggerDEAD[i])) { triggerDEAD();  paintWord();}
    }
    for (int i = 0; i < triggerGLITCH.length; i++){    
      if(lastWord.equals(triggerGLITCH[i])) { triggerGLITCH(); paintWord();}
    }
    for (int i = 0; i < triggerSCALE.length; i++){    
      if(lastWord.equals(triggerSCALE[i])) {triggerSCALE(); paintWord();}
    }
    for (int i = 0; i < triggerBLOOD.length; i++){    
      if(lastWord.equals(triggerBLOOD[i])) {triggerBLOOD(); paintWord();}
    }
    for (int i = 0; i < triggerPANIC.length; i++){    
      if(lastWord.equals(triggerPANIC[i])) {triggerPANIC(); paintWord();}
    }
    for (int i = 0; i < triggerPICADO.length; i++){    
      if(lastWord.equals(triggerPICADO[i])) {triggerPICADO(); paintWord();}
    }
    for (int i = 0; i < triggerRAIN.length; i++){    
      if(lastWord.equals(triggerRAIN[i])) {triggerRAIN(); paintWord();}
    }           
  }
  else{ //lastWord is bigger than charsTriggerMax    
    for (int i = 0; i < triggerCLIENT.length; i++){       
      String lt = lastWord.substring(0, triggerCLIENT[i].length()); 
      String ltIp = lastWord.substring(triggerCLIENT[i].length() + 1);
      
      if(lt.equals(triggerCLIENT[i])) {startClient(ltIp); paintWord();}    
    }
  }
}
void paintWord(){
  Writer w = writers.get(0);
  int lNum = w.letters.size();  
   
  for (int i=0; i < lastWord.length(); i++){    
   Letter l = w.letters.get(lNum - 1 - i);
   l.isTrigger = true;
  } 
}

void changeStars(String _txt){
  for (Star s : stars) {
    s.change(_txt);
  }
}
void triggerDEAD(){
  changeStars("†");
}
void triggerLOVE(){
  changeStars("<3");
}
void triggerGLITCH(){
  tweenGlitch = new Ani(this, 10, "bgAlpha", 1, Ani.EXPO_IN_OUT);
  tweenGlitch.setPlayMode(Ani.YOYO);
  tweenGlitch.repeat(2);
}
void triggerSCALE(){
  tweenScale = new Ani(this, 10, "scaleAll", 2, Ani.EXPO_IN_OUT);
  tweenScale.setPlayMode(Ani.YOYO);
  tweenScale.repeat(2);
}
void triggerBLOOD(){
  tweenBlood = new Ani(this, 10, "blood", height, Ani.EXPO_IN_OUT);
  tweenBlood.setPlayMode(Ani.YOYO);
  tweenBlood.repeat(2);
}
void triggerPANIC(){
  tweenLetterGlicth = new Ani(this, 10, "letterGlitch", 0.5, Ani.EXPO_IN_OUT);
  tweenLetterGlicth.setPlayMode(Ani.YOYO);
  tweenLetterGlicth.repeat(2);  
}
void triggerPICADO(){
  tweenPicado = new Ani(this, 20, "picado", 60, Ani.EXPO_IN_OUT);
  tweenPicado.setPlayMode(Ani.YOYO);
  tweenPicado.repeat(2);  
}
void triggerRAIN(){
  isRaining = true; 
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
void writeInput(String _type, int _key, Boolean wasReleased, int _x, int _y){  
  JSONObject input = new JSONObject();
  
  input.setInt("time", millis());
  input.setString("type", _type);
  input.setInt("key", _key); 
  input.setBoolean("release", wasReleased);
  input.setInt("x", _x);
  input.setInt("y", _y); 
  
  inputs.setJSONObject(inputNum, input);
  
  inputNum++;
}
 
void wavesUp(){
  wavesY -= wavesStep;
  int tope = height/2 + height/8;

  if(wavesY < tope) wavesY = tope;
}
void wavesDown(){
  wavesY += wavesStep;
  int tope = height + (picado*2);

  if(wavesY > tope) wavesY = tope;
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
void saveJson(){      
   saveJSONArray(inputs, savePath + "/streams/"+
                                      lastWord +
                                      "_"+day()+"-"+month()+"-"+year() +
                                      ".json"); 
   messager.show("json saved", 1);
}
void loadJson(String _filename){
  
  messager.show(_filename + " loaded", 1);
   
  JSONArray inputValues = loadJSONArray(savePath + "/streams/"+ _filename);
  
  Writer w = new Writer();
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

void createUIStreams(){
 int uiBlank = 0;
 File dataFolder = new File(sketchPath + "/streams");
 String[] fileList = dataFolder.list();  
 for (int i = 0; i < fileList.length;i++){
   buttons.add(new Button("streams", fileList[i],i,uiBlank));
 }  
}

