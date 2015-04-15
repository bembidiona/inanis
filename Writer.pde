class Writer{
   
  String stream = "Type something";
  String lastWord = "";
  
  boolean isPressed_Ctrl = false;
  boolean isPressed_Alt = false;
  boolean wasPressed_Tilde = false;
  
   Caret caret;
   ArrayList<Letter> letters = new ArrayList<Letter>(); 
   Boolean readingLoadedInputs = false;
   ArrayList<LoadedInput> loadedInputs = new ArrayList<LoadedInput>();
   int loadedInputNum = 1;
   int loadedInputTime = 0;
   int loadedTimeOffset;  
   int type; 
    
   Writer(int _type){
      type = _type;
      
      if(type == USER) caret = new Caret(this, width/2, height/2);
      else caret = new Caret(this, width/2, height/2 - 200 + floor(random(100)));       
      writersNum++;
      
      loadedInputs.add(new LoadedInput("skip", 0, 0, false, 0, 0 ));
   }

   void display(){


      caret.display();

      
      for (int i=letters.size()-1; i >= 0; i--) {
        Letter l = letters.get(i);
        if (l.isOut) letters.remove(i);
        else l.display();
      }  
      
      
       // Loaded automation
      if(readingLoadedInputs) checkLoadedInputs();
   }


   void addChar(String _char, Boolean space){               
      for (Letter l : letters) {
        l.stepForward();
      }
      for (Star s : stars) {
        s.stepForward();
      }       
      letters.add(new Letter(_char, caret));
      
      stream = stream + _char;
      if(!space) lastWord = lastWord + _char;
      
      caret.x += step/2;
   }
   
   void removeChar(){ 
      stream = stream.substring(0, stream.length()-1); 
      if(lastWord.length() > 0)lastWord = lastWord.substring(0, lastWord.length()-1);
      
      letters.remove(letters.size()-1);      
      for (Letter l : letters) {
        l.stepBack();
      }
      
      caret.x -= step/2;
   }
   
   
   
   
   void checkLoadedInputs(){
    if(millis() > loadedInputTime + loadedTimeOffset){
      
        
      if(loadedInputs.size() > loadedInputNum){
       
        LoadedInput in = loadedInputs.get(loadedInputNum);    //start at 0
        
        if(in.type.equals("mouse")){
          caret.teleport(in.x, in.y);
        }
        else if (in.type.equals("key")){
          if(in.r) keyRelease(in.k);
          else keyPress(in.k);
        }
        
              
        loadedInputTime = in.t;
        loadedInputNum++;
      }
      else{
        if(streamLoopOn){
          loadedInputNum = 0;        
          loadedTimeOffset = millis();
  
          loadedInputTime = loadedInputs.get(0).t; 
          caret.teleport(width/2,caret.startY);        
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
void keyPress(int _key) {
  
  if (_key == UP){
    wavesUp();
  }
  else if (_key == DOWN){
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
     addChar(breaker, false);
     caret.jump();
  }
  else if (_key == BACKSPACE) {
    if (stream.length() > 0) {
      removeChar();      
    }
  } else if (_key != SHIFT) {
    
    if(isPressed_Ctrl){
      if(_key == 83) saveTxt(); //s
      else if(_key == 69) savePix(); //e      
    }
    else if(isPressed_Alt){
      altKeys = altKeys + str(key);
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
        
        char c=(char)_key; // TODO : las letras se transformas en mayusculas
        String s = str(c);
        
        addChar(s, false); 
      }
    }
  }
}
void keyRelease(int _key) {
  writeInput("key", _key, true, 0, 0);
  
  if (_key == CONTROL){
    isPressed_Ctrl = false;
  }
  if (_key == ALT){
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
}
void paintWord(){
  int lNum = letters.size();  
   
  for (int i=0; i < lastWord.length(); i++){    
   Letter l = letters.get(lNum - 1 - i);
   l.isTrigger = true;
  } 
}


}
     
