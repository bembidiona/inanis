class Letter{
  
   int x = 2;
   int y = 1;
      
   String letter = " ";   
   
   float windX = 0.001; 
   private int windTimer = 0;
   int windTimerMax = 3;
   
   Boolean isOut = false;
         
   Letter(String _letter){
      letter = _letter; 
  
      x = caret.x - step;
      y = caret.y;
   }
   
   void display(){
      noStroke();  
      fill(colorTxt);

      //y = int( noise(millis())*height );

      text(letter, x, y + glitch() );
      
      for (int i = 0; i < 2; i++){  
        fill(colorTxt, 100);
        text(letter, x+random(3), y + glitch() +random(3));
      }
      if(blood > 0){
        for (int i = 0; i < 2; i++){  
          fill(colorTxt);
          rect(x-8/2 + random(8) ,y, 1, random(blood));
        }  
      }
      
      
      

      if (windTimer > windTimerMax){
        x -= windX;
        
        windTimer = 0; 
      }
      else windTimer++;
      
      if(x < - width/2) isOut = true;
   }
   
   void stepForward(){
     x -= step;
   }
   void stepBack(){
     x += step;
   }
   
   float glitch(){
     int _x = x;
     int threshold = floor(width/1.1);

     if(_x > threshold) _x = threshold;
     
     float num = (threshold - _x) * letterGlitch;
     return random(num);
   }
}
