import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

final private String appName = "Inanis";
final private String version = "v0.1";

final private Boolean startFullscreen = true;

String allText = "";
String stream = "Type something";
int colorBg = 0;
int colorTxt = 255;

int step = 10;

String breaker = "./ ";
String savePath = "";
PFont fontOptions;
String pixFormat = "png"; 

String[] buttonsNames = {".txt", ".img","-", "img", "folder", "-","day/night", "-","keys","?","-","exit"};
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

String lastWord;
String[] triggerLOVE = {"amor", "love", "amar", "shrimp"};
String[] triggerDEAD = {"muerte", "dead", "fetal"};
String[] triggerGLITCH = {"glitch", "bakun", "art"};
private int charsTriggerMax;
private int charsTriggerMin;

String mode = "stars";

Message messager;
Caret caret;

int bgAlpha = 255;
 
void setup() {
  frame.setTitle(appName + " " + version);
  PImage iconImg = loadImage("icon.png");
  PGraphics icon = createGraphics(100, 100, JAVA2D);
  icon.beginDraw();
  icon.image(iconImg, 0, 0, 100, 100); 
  icon.endDraw();
  frame.setIconImage(icon.image);
  
  
  size(displayWidth, displayHeight); 
  
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
}
 
void keyPressed() {
  keysInactive = false;
  
  if (firstBlood){
    for (Button b : buttons) {
      b.out();
    }
    stream = "";    
    firstBlood = false;
  }
  
  if (keyCode == CONTROL){
     isPressed_Ctrl = true;
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
}


boolean sketchFullScreen() {
  return startFullscreen;
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
  if(charsTriggerMin <= lastWordSize && lastWordSize <= charsTriggerMax){
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
}
void triggerDEAD(){
  for (Star s : stars) {
    s.txt = "@";
  } 
}
void triggerLOVE(){
  for (Star s : stars) {
    s.txt = "<3";
  } 
}
void triggerGLITCH(){
  bgAlpha = 5;
}

 


