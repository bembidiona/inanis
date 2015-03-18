class Button{
  
   int x = 0;
   int y = 0;
   int w = 0;
   int h = 0;
   int cX;
   int cY;
   PImage sprite;  
 
   String name;
   int buttonNum;
   
   int margen = 5;
   
   Ani tweenIn;
   Ani tweenOut;   
   
   boolean hiden = true;
   
   Button(String _name, int _buttonNum){    
     name = _name;     
     buttonNum = _buttonNum;
     
     int separation = 20;
     int safe = 5;
     w = name.length() * 11;
     h = 15;
     
     x = width - name.length() - margen;
     y = h + safe + separation*buttonNum;
     
     cX = x - w + 5;
     cY = y-h+5;
     
     hiden = false;
   }
   
   
   void display(){   
     textFont(fontOptions);                 
     fill(255);  
     textAlign(RIGHT);     
     
     String txt = name;     
     if (isOver()){ txt = "-" + txt;}          
     text(txt, x, y);    
     
     /*noFill();
     stroke(255,0,0);
     rect(cX, cY, w, h);*/
   }
   
   
   void checkClick(){
     if(isOver()){
        if(name == "save") exportTxt();
        else if (name == "folder") selectFolder("On exit Save to this folder", "checkPath");
        else if (name == "exit") exit(); 
     }
   }
   
   boolean isOver(){
     if ((mouseX > cX && mouseX < cX + w) && (mouseY > cY && mouseY < cY+h)){
       return true;
     }
     else{
       return false; 
     }
   }
   
  void in() {
    if(hiden){
      hiden = false;
      Ani.to(this, 1, 0.05*buttonNum, "x", width - margen, Ani.EXPO_IN_OUT, "onStart:itsStarted, onEnd:itsEnded");
    }    
  }
  
  void out() {
    if(!hiden){
      hiden = true;
      Ani.to(this, 1, 0.05*buttonNum, "x", width + 60,  Ani.EXPO_IN_OUT, "onStart:itsStarted, onEnd:itsEnded");
    }      
  }
  
  void itsStarted(){  
  }
  void itsEnded(){    
  }
   
}   
