import de.looksgood.ani.*;
import de.looksgood.ani.easing.*;

final private String appName = "Void Writer";
final private String version = "v0.1";

final private Boolean startFullscreen = true;

String allText = "";
String stream = "Type something";
int colorBg = 0;
int colorTxt = 255;

String breaker = "./ ";
String savePath = "";
PFont fontOptions;


String[] buttonsNames = {"save", "folder", "day/night", "exit"};
ArrayList<Button> buttons = new ArrayList<Button>();
ArrayList<Letter> letters = new ArrayList<Letter>();

Boolean firstBlood = false;

int timerMouseInactive = 0;
int timeMouseInactive = 2000;
boolean mouseInactive = false;

Boolean cursorHand = false;

Message messager;

Caret caret;
 
void setup() {
  frame.setTitle(appName + " " + version);
  size(displayWidth, displayHeight); 
  
  timerMouseInactive = millis();
  
  Ani.init(this);
 
  fontOptions = loadFont("courier_15.vlw");
  
  textAlign(RIGHT, CENTER);
  textSize(30);
  fill(50);
  cursor(CROSS);
  
  
  for (int i = 0; i < buttonsNames.length; i++){
    buttons.add(new Button(buttonsNames[i],i));
  }
  
  messager = new Message();
  caret = new Caret();
}
 
void draw() {
  background(colorBg);  
  cursorHand = false;
  
  noStroke();  
  fill(colorTxt);
  for (Letter l : letters) {
    l.display();
  }
  caret.display();
    
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
}
 
void keyPressed() {
  if (!firstBlood){
    for (Button b : buttons) {
      b.out();
    }
    stream = "";
    
    firstBlood = true;
  }
  
  if (keyCode == ENTER){
     stream = stream + breaker;
  }
  if (keyCode == BACKSPACE) {
    if (stream.length() > 0) {
      stream = stream.substring(0, stream.length()-1);
      
      letters.remove(letters.size()-1);
      
      for (Letter l : letters) {
        l.stepBack();
      }
      
    }
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && keyCode != ENTER) {
    stream = stream +  str(key);
    
    for (Letter l : letters) {
      l.stepForward();
    }
    
    letters.add(new Letter(str(key)  ));
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
  
  if(firstBlood){
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

void checkPath(File selection){
if (selection == null) {
   println("Window was closed or the user hit cancel.");
   } else {
      savePath = selection.getAbsolutePath();     
   }   
}



void exportTxt(){
   String[] list = split(stream, breaker);
   saveStrings(savePath + "/vomito_"+day()+"-"+month()+"-"+year()+".txt", list);
 
   messager.show("-file saved-", 1);
}
 


