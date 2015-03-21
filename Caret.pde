class Caret{
  
   int x = 0;
   int y = 0;
   
   private int blinkTimer = 0;
   int blinkTimerMax = 20;
   
   Ani animation;
   
   PImage sprite;
   
   private final int xMin = width/2;
   private final int xMax = width/2+width/4;
   
   private final float stepBack = step/2;
      
   Caret(){
     
     x = width/2;
     y = height/2;
     
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
        else { 
           blinkTimer = 0;
           
           x -= stepBack;
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
      
      x += step/2;
   }
   
   void removeChar(){ 
      stream = stream.substring(0, stream.length()-1); 
      if(lastWord.length() > 0)lastWord = lastWord.substring(0, lastWord.length()-1);
      
      letters.remove(letters.size()-1);      
      for (Letter l : letters) {
        l.stepBack();
      }
      
      x -= step/2;
   }
   
   void jump(){
      y = floor(height/2 - 100 + random(200));
      animation = new Ani(this, 10, "y", y + 50, Ani.EXPO_IN_OUT); 
      
      animation.start();
      print("yay");
   }
   
   
}
