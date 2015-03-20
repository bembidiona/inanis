class Caret{
  
   int x = 0;
   int y = 0;
   
   private int blinkTimer = 0;
   int blinkTimerMax = 20;
   
   Ani animation;
      
   Caret(){
     
     x = width/2 + width/6;
     y = height/2 - 50;
     
     animation = new Ani(this, 10, "y", height/2 + 50, Ani.EXPO_IN_OUT);
    
     // FORWARD, BACKWARD, YOYO
     animation.setPlayMode(Ani.YOYO);
     animation.repeat();
     
   }   
   
   void display(){
      
      if (blinkTimer < blinkTimerMax){
        text("^",x,y);
        blinkTimer++; 
      }
      else if (blinkTimer < blinkTimerMax*2){
        blinkTimer++;
      }
      else blinkTimer = 0;
   }
   
   
}
