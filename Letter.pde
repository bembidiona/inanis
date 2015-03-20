class Letter{
  
   int x = 2;
   int y = 1;
      
   String letter = " ";
   
   private final int step = 10;
   
   float windX = 0.001; 
   private int windTimer = 0;
   int windTimerMax = 1;
         
   Letter(String _letter){
      letter = _letter; 
  
      x = caret.x - step;
      y = caret.y;
   }
   
   void display(){
      noStroke();  
      fill(colorTxt);
      text(letter, x, y + glitch() );
      
      if (windTimer > windTimerMax){
        x -= windX;
        
        windTimer = 0; 
      }
      else windTimer++;
      
   }
   
   void stepForward(){
     x -= step;
   }
   void stepBack(){
     x += step;
   }
   
   float glitch(){
     float num = (width - x)/(1000 - random(1000));
     return random(num)-num/2;
   }
}
