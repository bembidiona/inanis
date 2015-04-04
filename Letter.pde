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
      text(letter, x, y + glitch() );
      
      fill(colorTxt, 100);
      text(letter, x+random(3), y + glitch() +random(3));
      
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
     if(_x > width/2) _x = width/2;
     
     float num = (width/2 - _x) * 0.2;
     return random(num);
   }
}
