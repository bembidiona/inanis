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
   private String txt;
   
   Button(String _name, int _buttonNum, int _blank){    
     name = _name;     
     buttonNum = _buttonNum;
     
     int separation = 20;
     int safe = 5;
     w = name.length() * 11;
     h = 15;
     
     x = width - name.length() - margen;
     y = h + safe + separation*buttonNum - _blank*10;
     
     cX = x - w + 5;
     cY = y-h+5;
     
     hiden = false;
   }
   
   
   void display(){   
     textFont(fontOptions);                 
     fill(colorTxt);  
     textAlign(RIGHT);     
     
     if (name == ".img") txt = "."+pixFormat;
     else txt = name;     
     if (isOver()){
       txt = "_" + txt;
       
       cursorHand = true;
     }     
     text(txt, x, y);    
     
     /*noFill();
     stroke(255,0,0);
     rect(cX, cY, w, h);*/
   }
   
   
   void checkClick(){
     if(isOver()){
        if(name == "saveJson") saveJson();
        else if(name == "loadJson") loadJson();
        else if(name == ".txt") saveTxt();
        else if(name == ".img") savePix();
        else if (name == "img"){
           if (pixFormat == "bmp") pixFormat = "png";
           else if (pixFormat == "png") pixFormat = "bmp";  
        }
        else if (name == "folder") selectFolder("On exit Save to this folder", "checkPath");
        else if (name == "day/night") {
          if(filterInvert) {
            filterInvert = false;
          }
          else{
            filterInvert = true;
          }
          
        }
        else if (name == "start server") startServer();
        else if (name == "start client") messager.show("type *connect:192.168.0.10* replacing with the server IP and hit SPACE");
        else if (name == "keys") messager.show("Ctrl+S:saveTxt() / Ctrl+E:savePix() / Esc:quit()", 3);
        else if (name == "?") messager.show(appName+" "+version+" by jeRemias Babini", 2);
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
      Ani.to(this, 1, 0.05*buttonNum, "x", width + 150,  Ani.EXPO_IN_OUT, "onStart:itsStarted, onEnd:itsEnded");
    }      
  }
  
  void itsStarted(){  
  }
  void itsEnded(){    
  }
   
}   
