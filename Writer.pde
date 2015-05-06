class Writer{
   
  String stream = "Type something";
  String lastWord = "";
  
  boolean isPressed_Ctrl = false;
  boolean isPressed_Alt = false;
  boolean isPressed_Shift = false;
  boolean wasPressed_Tilde = false;
  
   
   ArrayList<Letter> letters = new ArrayList<Letter>(); 
   Boolean readingLoadedInputs = false;
   ArrayList<LoadedInput> loadedInputs = new ArrayList<LoadedInput>();
   int loadedInputNum = 1;
   int loadedInputTime = 0;
   int loadedTimeOffset;  
   int type; 
   
   //CaretStuff
   int x = 0;
   int y = 0;
   
   int startX;
   int startY;
   
   private int blinkTimer = 0;
   int blinkTimerMax = 20;
   
   Ani animationX;
   Ani animationY;
   
   PImage sprite;
   PImage ring;
   
   private final int xMin = width/2-width/3;
   private final int xMax = width/2+width/3;
   
   private final float stepBack = step/2;

   Boolean canTeleport = true;
   
   private String exponent = "";
   
   int hitbox = 30;
   Boolean isBeingDraged = false; 
   
   int exaleS;
   int exaleA;
   Boolean exaling = false;

   Boolean toRemove = false;
    
   Writer(int _type){
      type = _type;
      
      if(type == USER){
        x = width/2;
        y = height/2;
      }
      else{
        x = width/2;
        y = height/2 - 200 + floor(random(100));        
      }       
      writersNum++;
      
      loadedInputs.add(new LoadedInput("skip", 0, 0, false, 0, 0 ));
      
      //caret
     startX = x;
     startY = y;
           
     for (int i = 1; i <= writersNum; i++){
       exponent = exponent + ".";
     }
     
     x = width/2;
     y = startY;
     
     sprite = loadImage("caret.png");
     
     
     /*animationY = new Ani(this, 10, "y", height/2 + 50, Ani.EXPO_IN_OUT);
     animationY.setPlayMode(Ani.YOYO);
     animationY.repeat();*/
   }

   void display(){
if (keysInactive){
        if (blinkTimer < blinkTimerMax){
          drawIt(255);
          blinkTimer++; 
        }
        else if (blinkTimer < blinkTimerMax*2){
          drawIt(100);
          blinkTimer++;
        }
        else { 
           blinkTimer = 0;
           
           if(!firstBlood) x -= stepBack;
        }   

                
      }
      else { 
        drawIt(255);
        blinkTimer = 0;
      }
      
      if(isOver()){
       fill(colorTxt, 25);
       rect(x-hitbox/2,y-hitbox/2, hitbox,hitbox);
       
       cursorHand = true;
      } 
      
      for (int i=letters.size()-1; i >= 0; i--) {
        Letter l = letters.get(i);
        if (l.isOut) letters.remove(i);
        else l.display();
      }  
      
      
       // Loaded automation
      if(readingLoadedInputs) checkLoadedInputs();
      
      if(exaling){
        noFill();
        stroke(colorTxt, exaleA);
        rect(x-exaleS/2, y-exaleS/2, exaleS,exaleS);
        
        if(exaleA < 1) exaling = false;
      }
   }


   void addChar(String _char, Boolean space){               
      for (Letter l : letters) {
        l.stepForward();
      }
      for (Star s : stars) {
        s.stepForward();
      }       
      letters.add(new Letter(_char, x, y));
      
      stream = stream + _char;
      if(!space) lastWord = lastWord + _char;
      
      x += step/2;
   }
   
   void removeChar(){ 
      stream = stream.substring(0, stream.length()-1); 
      if(lastWord.length() > 0){
        lastWord = lastWord.substring(0, lastWord.length()-1);
      }
      
      if(letters.size() >= 1){
        Letter l = letters.get(letters.size()-1);      
        teleport(l.x, l.y);
        letters.remove(letters.size()-1);
      }
      
      
      
     
      for (Letter l : letters) {
        l.stepBack();
      }
      
      x -= step/2;
   }
   
   
   
   
   void checkLoadedInputs(){
    if(millis() > loadedInputTime + loadedTimeOffset){
      
        
      if(loadedInputs.size() > loadedInputNum){
       
        LoadedInput in = loadedInputs.get(loadedInputNum);    //start at 0
        
        if(in.type.equals("mouse")){
          teleport(in.x, in.y);
        }
        else if (in.type.equals("key")){
          if(in.r) keyRelease(in.k);
          else keyPress(in.k);
        }
        
              
        loadedInputTime = in.t;
        loadedInputNum++;
      }
      else{
        startBlink();
        
        if(streamLoopOn){
          loadedInputNum = 0;        
          loadedTimeOffset = millis();
  
          loadedInputTime = loadedInputs.get(0).t; 
          teleport(startX,startY);        
        }
        else{
          messager.show("end of stream", 3);
        
          loadedInputs.clear();
          loadedInputNum = 0;
          loadedInputTime = 0;
          readingLoadedInputs = false;
        }
      }
    }  
}
void startBlink(){
  exaling = true;
  
  float t = 1;
  exaleS = 10;
  exaleA = 255;
  Ani.to(this, t, "exaleS", 100, Ani.EXPO_OUT);
  Ani.to(this, t, "exaleA", 0, Ani.EXPO_OUT);
  
}
void keyPress(int _key) {
  
  if (_key == SHIFT){
    isPressed_Shift = true;
  }
  else if (_key == UP){
    wavesUp();
  }
  else if (_key == DOWN && !isPressed_Shift){
    wavesDown();
  }
  else if (_key == CONTROL){
     isPressed_Ctrl = true;
  }
  else if (_key == ALT){
     isPressed_Alt = true;
  }
  else if (_key == DELETE){
     debugLog = "";
  }
  else if (_key == 180){ //tilde
     if (wasPressed_Tilde == true){
       addChar("'", false);
       wasPressed_Tilde = false; 
     }
     else wasPressed_Tilde = true;
  }  
  else if (_key == ENTER){     
     stream = stream + pilcrow;
     jump();
  }
  else if (_key == BACKSPACE) {
    if (stream.length() > 0) {       
      removeChar();      
    }
  } else if (_key != SHIFT) {
    
    if(isPressed_Ctrl){
      
      if(_key == 19) saveTxt(); //s
      else if(_key == 5) savePix(); //e      
    }    
    else{
      if(_key == 32){ // SPACE
        stars.add(new Star());
        
        checkTriggers();        
        lastWord = "";
        
        addChar(" ", true);
      }
      else if (wasPressed_Tilde){
        wasPressed_Tilde = false;
        
        String c = "´";
        if(_key == 97) c = "á";
        else if(_key == 101) c = "é";
        else if(_key == 105) c = "í";
        else if(_key == 111) c = "ó";
        else if(_key == 117) c = "ú";
        
        addChar(c, false);
      }
      else{
        char c=(char)_key;
        String s = str(c);
        
        if(isPressed_Alt) altKeys = altKeys + s;
        else addChar(s, false); 
      }
    }
  }
}
void keyRelease(int _key) {
    
  if (_key == SHIFT){
    isPressed_Shift = false;
  }
  else if (_key == CONTROL){
    isPressed_Ctrl = false;
  }
  else if (_key == ALT){
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
    
    addChar(hackedChar, false); 
     
    altKeys = "";
  }
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
  
  for (int i = 0; i < triggerSAVE.length; i++){     
    if(triggerSAVE[i].length() < lastWord.length()){  
      String lt = lastWord.substring(0, triggerSAVE[i].length()); 
      String ltSaveName = lastWord.substring(triggerSAVE[i].length());
      
            
      if(lt.equals(triggerSAVE[i])) {saveJson(ltSaveName); paintWord();}  
    }  
  } 
}
void paintWord(){
  int lNum = letters.size();  
   
  for (int i=0; i < lastWord.length(); i++){    
   Letter l = letters.get(lNum - 1 - i);
   l.isTrigger = true;
  } 
}

void drawIt(int _alpha){
     tint(colorTxt, _alpha);
     
     if (x < xMin) x = xMin;
     else if (x > xMax) x = xMax;
     
     image(sprite,x-sprite.width/2,y-sprite.height/2);
     text(exponent, x+sprite.width, y);
     
     noTint();
   }
   
   
   
   void jump(){
      teleport(x, floor(height/2 - 100 + random(200)) );           
   }

   void teleport(int _x, int _y){
    if(isBeingDraged) return; 
     
    if(type == USER && recording) writeInput("mouse", 0, false, _x, _y);

    checkTriggers();        
    lastWord = ""; 
     
    canTeleport = false;
    
    animationX = new Ani(this, 0.5, "x", _x, Ani.EXPO_IN_OUT,"onStart:blank, onEnd:startIdle");
    animationY = new Ani(this, 0.5, "y", _y, Ani.EXPO_IN_OUT);    
   }

   void startIdle(){
    canTeleport = true;
    /*animationY = new Ani(this, 10, "y", y + 20, Ani.EXPO_IN_OUT);       
    animationY.start();
    animationY.setPlayMode(Ani.YOYO);
    animationY.repeat();*/
   }

   private void blank(){

   }
   
   boolean isOver(){
     
     if ((mouseX > x - hitbox/2 && mouseX < x + hitbox/2) && (mouseY > y - hitbox/2 && mouseY < y + hitbox/2)){
       return true;
     }
     else{
       return false; 
     }
   }
   
   void stopDrag(){
     isBeingDraged = false;
     startX = x;
     startY = y; 
     
   }
   
   void delete(){
     if(type != USER){
       toRemove = true; 
     }
   }


}
     
