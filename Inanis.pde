final private String appName = "Inanis";
final private String version = "v0.3";
final Boolean DEBUG = true;

final int USER = 0;
final int ROBOT = 1;

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
String[] buttonsNames = {"saveJson", "loadJson", "-", ".txt", ".img","-", "img", "folder", "-","font","theme","day/night","seaUp","seaDown","-","start server","start client","-","keys","?","-","exit"};
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

//don't forget to also add the new TRIGGERS in the setup section!!!
String[] triggerLOVE = {"amor", "love", "amar", "shrimp", "afecto"};
String[] triggerDEAD = {"muerte", "mori", "dead", "fetal"};
String[] triggerGLITCH = {"glitch", "bakun", "art", "arte"};
String[] triggerCLIENT = {"connect", "conectar"};
String[] triggerSCALE = {"encerrado", "grande", "big", "close", "cerca"};
String[] triggerBLOOD = {"sangre", "blood", "pelo", "hair"};
String[] triggerPANIC = {"panic", "ansiedad", "attack", "panico", "pánico", "manija"};
String[] triggerPICADO = {"odio", "mar", "ocean", "hate", "water", "tormenta"};
String[] triggerRAIN = {"lluvia", "llover", "llueve", "lloviendo","rain", "llorar", "cry", "tormenta"};
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
  
  changeTheme();
  changeFont();
  size(displayWidth, displayHeight);   
  json = new JSONObject();
  timerMouseInactive = millis();
  
  Ani.init(this);
   
  
  
   
  
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

  user = new Writer(USER);
  writers.add(user);  
  

  
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
  textFont(fontOptions);
  
  fill(colorBg, bgAlpha);
  rect(0,0,width,height); 
   
  
  
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
  
  
    
  
  mouseCheckDrag();
  if(!mouseInactive){
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
       server.write(user.lastWord);
      
       client = server.available();
       if (client != null){         
         checkNetInput(); 
       }
    }
    else if(conectedClient){
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
  for(int i = 1; i <= 5; i++){
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
  for(int i = 0; i <= 2; i++){
    if(true) fill(colorTxt, 255 - 100*i);
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
  
  //debug
  if (DEBUG) {
    
    tint(colorTxt);
    
    text(debugLog, width/2,height/2-150);
  }

  textAlign(LEFT, CENTER);
  text("FPS:"+str(ceil(frameRate)), 25, 30);
  
}
 
void keyPressed() {
  keysInactive = false;
  messager.itsEnded();
  
  if (firstBlood){
    for (Button b : buttons) {
      b.out();
    }
    user.stream = "";    
    firstBlood = false;
  }
  
    
  if(key == CODED){
    writeInput("key", int(keyCode), false, 0, 0);
    user.keyPress(int(keyCode));
  }
  else{
    writeInput("key", int(key), false, 0, 0);
    user.keyPress(int(key));    
  }
}
void keyReleased() {
  if(key == CODED){
    writeInput("key", int(keyCode), true, 0, 0);
    user.keyRelease(int(keyCode));
  }
  else{
    writeInput("key", int(key), true, 0, 0);
    user.keyRelease(key);
  }
}


boolean sketchFullScreen() {
  return !DEBUG;
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
  }
  else if (axis == 2) {  // right to left gradient
    for (int i = x; i <= x+w-3; i++) {
      float inter = map(i, x, x+w, 0, 1);
      color c = lerpColor(c2, c1, inter);
      fill(c);
      rect(i, y, 1, h);
    }
  }
  else if (axis == 3) {  // Top to bottom gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c1, c2, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }
  else if (axis == 4) {  // bottom to Top gradient
    for (int i = y; i <= y+h; i++) {
      float inter = map(i, y, y+h, 0, 1);
      color c = lerpColor(c2, c1, inter);
      stroke(c);
      line(x, i, x+w, i);
    }
  }  
}

void mouseCheckDrag(){
  if(clickedOverACaret){
    if(mouseIsDragging){
      writerDraged.x = mouseX;
      writerDraged.y = mouseY;
    }
    else {
      int safe = 20;
      if ( (mouseX < mousePressX-safe || mouseX > mousePressX+safe) ||
           (mouseY < mousePressY-safe || mouseY > mousePressY+safe)){
         mouseIsDragging = true;
      }       
    }    
  }
}

void mousePressed(){
  mousePressX = mouseX;
  mousePressY = mouseY;

  for (Writer w : writers) {
    if(w.isOver()){
      clickedOverACaret = true; //HACK
      
      writerDraged = w;
      writerDraged.isBeingDraged = true;      
      writerDraged.startX = mouseX;
      writerDraged.startY = mouseY; 
    }
  }  
}
void mouseReleased(){
  clickedOverACaret = false;
  
  if (mouseX > width/2+width/3){
    for (Button b : buttons) {
      b.checkClick();
    }
  }
  else if(mouseIsDragging == true){
    mouseIsDragging = false;
    
    writerDraged.isBeingDraged = false;    
  }
  else if (user.canTeleport){
    user.addChar(". ", false);
    user.stream = user.stream + pilcrow;               
    user.teleport(mouseX,mouseY);
  }    
}
void mouseMoved(){
  mouseInactive = false;
  
  if(!firstBlood){
    if(mouseX > width - uiZone){     
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
        uiZone = uiZoneNormal;
        for (Button b : buttons) {
          b.out();
        }     
    }
  }
}






void saveTxt(){
   String[] list = split(writers.get(0).stream, pilcrow);
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
                                      user.lastWord +
                                      "_"+day()+"-"+month()+"-"+year() +
                                      ".json"); 
   messager.show("json saved", 1);
}
void loadJson(String _filename){
  
  messager.show(_filename + " loaded", 1);
   
  JSONArray inputValues = loadJSONArray(savePath + "/streams/"+ _filename);
  
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

void createUIStreams(){
 int uiBlank = 0;
 File dataFolder = new File(sketchPath + "/streams");
 String[] fileList = dataFolder.list();
 int longestName = 0; 
 for (int i = 0; i < fileList.length;i++){
   buttons.add(new Button("streams", fileList[i],i,uiBlank));
   if(fileList[i].length() > longestName) longestName = fileList[i].length();
 }
 uiZone = longestName * 12; 
}

void changeTheme(){
  if(themeSelected == 1){
      themeSelected++;
    
      colorTxt = color(187,214,181);
      colorTrigger = color(238,247,225,255);
      colorBg = color(19,82,90);
      colorGradient = color(30,66,86,255);
      colorGradientAlpha = color(colorGradient,0);
      colorExtra = color(68,139,135);      
  }
  else if(themeSelected == 2){
      themeSelected++;
    
      colorTxt = color(255,255,250);
      colorTrigger = color(242,76,39);
      colorBg = color(2,73,89);
      colorGradient = color(3,126,140,50);
      colorGradientAlpha = color(colorGradient,0);
      colorExtra = color(255,255,250);      
  }
  else { //default
      themeSelected = 1;
    
      colorTxt = color(230,255);
      colorTrigger = color(136,200,200,255);
      colorBg = color(20,22,23,255);
      colorGradient = color(20,25,25,255);
      colorGradientAlpha = color(colorGradient,0);      
      colorExtra = color(255,255,250);
  }
}
void changeFont(){
 if(fontSelected == 1){
   fontSelected++;
   fontOptions = loadFont("anonymous-15.vlw");
 }
 else if(fontSelected == 2){
   fontSelected++;
   fontOptions = loadFont("MonospaceTypewriter-13.vlw");
 }
 else if(fontSelected == 3){
   fontSelected++;
   fontOptions = loadFont("Jauria-15.vlw");
 }
 else if(fontSelected == 4){
   fontSelected++;
   fontOptions = loadFont("Terminus-14.vlw");
 }
 else{
   fontSelected = 1;
   fontOptions = loadFont("courier-15.vlw");
 }
  
}



