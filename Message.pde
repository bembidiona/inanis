class Message{
  
   int x = width/2;
   final private int moveDistance = 20;
   int y = moveDistance*-1;
   
         
   Ani tweenIn;
   Ani tweenOut;
   
   String message = " ";
   float duration;   
      
   Message(){          
   }
   
   void display(){
     textAlign(CENTER);
     text(message, x, y); 
   }
   
   void show(String _message, float seconds){
     message = "- "+_message+" -";
     duration = seconds;
     
     Ani.to(this, 1, "y", moveDistance, Ani.EXPO_IN_OUT, "onStart:itsStarted, onEnd:itsEnded");
   }
   
   void itsStarted() {
   }
   void itsEnded() {
     Ani.to(this, 1, duration, "y", moveDistance*-1, Ani.EXPO_IN_OUT);
   }   
   
}
