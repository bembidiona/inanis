class Caret{
  
   int x = 0;
   int y = 0;
   
   private int blinkTimer = 0;
   int blinkTimerMax = 20;
   
   Ani animationX;
   Ani animationY;
   
   PImage sprite;
   
   private final int xMin = width/2-width/3;
   private final int xMax = width/2+width/3;
   
   private final float stepBack = step/2;

   Boolean canTeleport = true;
      
   Caret(){
     
     x = width/2;
     y = height/2;
     
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
      
      
   }
   
   void drawIt(int _alpha){
     tint(colorTxt, _alpha);
     
     if (x < xMin) x = xMin;
     else if (x > xMax) x = xMax;
     
     image(sprite,x-sprite.width/1.5,y-sprite.height/1.5);
   }
   
   
   
   void jump(){
      teleport(x, floor(height/2 - 100 + random(200)) );           
   }

   void teleport(int _x, int _y){
    writeInput("mouse", 0, false, _x, _y);

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
   
   
}
