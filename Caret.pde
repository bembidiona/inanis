class Caret{
  
   int x = 0;
   int y = 0;
   
   private int blinkTimer = 0;
   int blinkTimerMax = 20;
   
   Ani animation;
   
   PImage sprite;
      
   Caret(){
     
     x = width/2 + width/6;
     y = height/2 - 50;
     
     animation = new Ani(this, 10, "y", height/2 + 50, Ani.EXPO_IN_OUT);
     
     sprite = loadImage("caret.png");
     
     // FORWARD, BACKWARD, YOYO
     animation.setPlayMode(Ani.YOYO);
     animation.repeat();
     
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
        else blinkTimer = 0;        
      }
      else { 
        drawIt(255);
        blinkTimer = 0;
      }
      
   }
   
   void drawIt(int _alpha){
     tint(colorTxt, _alpha);
     image(sprite,x-sprite.width/1.5,y-sprite.height/1.5);
   }
   
   
}
