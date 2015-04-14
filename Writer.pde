class Writer{
  
   Caret caret;
   ArrayList<Letter> letters = new ArrayList<Letter>();

   Writer(){
      caret = new Caret();
   }

   void display(){


      caret.display();

      
      for (int i=letters.size()-1; i >= 0; i--) {
        Letter l = letters.get(i);
        if (l.isOut) letters.remove(i);
        else l.display();
      }  
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
}
     