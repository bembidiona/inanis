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
   String menu;
   boolean toRemove = false;
   
   String mutatingName = "recordingOFF";
   
      
   
   Button(String _menu, String _name, int _buttonNum, int _blank){    
     menu = _menu;

     name = _name;     
     buttonNum = _buttonNum;

     
     int separation = 20;
     int safe = 5;
     w = name.length() * 11;
     h = 20;
     
     if (menu == "main") x = width - name.length() - margen*4;
     else x = width + name.length() + 200;
     y = h + safe + separation*buttonNum - _blank*10 + margen + 6;
     
     cX = x - w + 5;
     cY = y-h+5;
     
      if (menu == "main") hiden = false;
      else hiden = true;
   }
   
   
   void display(){ 
    cX = x - w + 5;
    cY = y-h+5;

                     
    fill(colorTxt);  
     
    textAlign(RIGHT);
     
    if (name == ".img") txt = "."+pixFormat;
    else if (name == "record") txt = mutatingName;
    else txt = name;     
    if (isOver()){
      txt = "_" + txt;
       
      cursorHand = true;
    }     
    text(txt, x, y);    
    
    if(DEBUG){ 
      noFill();
      stroke(255,0,0);
      rect(cX, cY, w, h);
    }
   }
   
   
   void checkClick(){
     if(isOver()){
        if (name == "record"){
           if (recording) { mutatingName = "recordingOFF"; recordOFF();}
           else { mutatingName = "recordingON" ; recordON();}  
        }
        else if(name == ".sav") saveJson("", false);
        else if(name == "LOAD") releasedLoadJson = true;
        else if(name == ".txt") saveTxt("");
        else if(name == ".img") savePix("");
        else if (name == "img"){
           if (pixFormat == "bmp") pixFormat = "png";
           else if (pixFormat == "png") pixFormat = "bmp";  
        }
        else if (name == "folder") selectFolder("On exit Save to this folder", "checkPath");
        else if (name == "font") changeFont();
        else if (name == "theme") changeTheme();
        else if (name == "day/night") filterInvert = !filterInvert;
        else if(name == "sound/silence") soundPlayer.sfxON = !soundPlayer.sfxON; 
        else if (name == "seaUp") wavesUp(); 
        else if (name == "seaDown") wavesDown();
        else if (name == "start server") startServer();
        else if (name == "start client") messager.show("type *connect:192.168.0.10* replacing with the server IP and hit SPACE");
        else if (name == "keys") messager.show("Ctrl+S:saveTxt() / Ctrl+E:savePix() / Esc:quit() / ^ or v :moveSea()", 3);
        else if (name == "   ?") messager.show(appName+" "+version+" by jeRemias Babini", 2);
        else if (name == "exit") exit(); 

        if(menu == "streams") loadJson(name);
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
      Ani.to(this, 0.8, 0.03*buttonNum, "x", width - margen*4, Ani.EXPO_IN_OUT, "onStart:itsStarted, onEnd:itsEnded");
    }    
  }
  
  void out() {
    if(!hiden){
      hiden = true;
      Ani.to(this, 0.8, 0.03*buttonNum, "x", width + 1000,  Ani.EXPO_IN_OUT, "onStart:itsStarted, onEnd:itsEnded");
    }      
  }
  
  void itsStarted(){  
  }
  void itsEnded(){    
  }

    
}   