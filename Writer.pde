class Writer{
  
   Caret caret;
   ArrayList<Letter> letters = new ArrayList<Letter>(); 
   Boolean readingLoadedInputs = false;
   ArrayList<LoadedInput> loadedInputs = new ArrayList<LoadedInput>();
   int loadedInputNum = 1;
   int loadedInputTime = 0;
   int loadedTimeOffset;  

   Writer(){
      caret = new Caret(writersNum);      
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
      letters.add(new Letter(_char));
      
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
    println("size(): "+loadedInputs.size() +" /// loadedInputNum: " + loadedInputNum);
      
    if(loadedInputs.size() > loadedInputNum){
     
      LoadedInput in = loadedInputs.get(loadedInputNum);    //start at 0
      println(in.type);
      if(in.type.equals("mouse")){
        writers.get(0).caret.teleport(in.x, in.y);
      }
      else if (in.type.equals("key")){
        if(in.r) robot.keyRelease(in.k);
        else robot.keyPress(in.k);
      }
      
            
      loadedInputTime = in.t;
      loadedInputNum++;
    }
    else{
      if(streamLoopOn){
        loadedInputNum = 0;        
        loadedTimeOffset = millis();

        loadedInputTime = loadedInputs.get(0).t; 
        writers.get(0).caret.teleport(width/2,height/2);        
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
}
     
