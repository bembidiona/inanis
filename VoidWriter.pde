
String allText = "";
String myText = "Type something";
int bgColor = 0; 

String breaker = "./ ";

String savePath = "";

PFont fontOptions;


Button buttonExport;
 
void setup() {
  size(displayWidth, displayHeight); 
 
  fontOptions = loadFont("courier_15.vlw");
  
  textAlign(RIGHT, CENTER);
  textSize(30);
  fill(50);
  
  
  buttonExport = new Button("save");
}
 
void draw() {
  background(bgColor);  
  noStroke();
  
  fill(255);
  text(myText, width/2, height/2);
  
  
  //tapon  
  fill(0);
  rect(0, 0, width/6, height);  
  noFill();  
  setGradient(width/6, 0, width/4, height, color(bgColor, bgColor, bgColor), color(bgColor, bgColor, bgColor, 0), true);
  
  buttonExport.display();
}
 
void keyPressed() {
  if (keyCode == ENTER){
     myText = myText + breaker;
  }
  if (keyCode == BACKSPACE) {
    if (myText.length() > 0) {
      myText = myText.substring(0, myText.length()-1);
    }
  } else if (keyCode == DELETE) {
    myText = "";
  } else if (keyCode != SHIFT && keyCode != CONTROL && keyCode != ALT && keyCode != ENTER) {
    myText = myText +  str(key);
  }  
  
  
}

/*boolean sketchFullScreen() {
  return true;
}*/

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
  buttonExport.checkClick();
  
}

void checkPath(File selection){
if (selection == null) {
   println("Window was closed or the user hit cancel.");
   } else {
      savePath = selection.getAbsolutePath();     
   }   
    
   exportTxt();
}



void exportTxt(){
   String[] list = split(myText, breaker);
   saveStrings(savePath + "/vomito_"+day()+"-"+month()+"-"+year()+".txt", list);  
}
 


