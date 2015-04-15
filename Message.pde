class Message{
  
   int x = width/2;
   final private int moveDistance = 30;
   int y = moveDistance*-1;
   
         
   Ani tweenIn;
   Ani tweenOut;
   
   String message = " ";
   float duration;   
   
   Boolean hide = true;
      
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
     
     hide = false;
   }
   
   void show(String _message){
     message = "- "+_message+" -";
     duration = 0;
     
     Ani.to(this, 1, "y", moveDistance, Ani.EXPO_IN_OUT);
     
     hide = false;
   }
   
   
   
   void itsStarted() {
   }
   void itsEnded() {
     if(!hide){
       hide = true;
       Ani.to(this, 1, duration, "y", moveDistance*-1, Ani.EXPO_IN_OUT);
     }
   }      
   
   
}
