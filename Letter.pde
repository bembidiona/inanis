class Letter{
  
   int x = 2;
   int y = 1;
      
   String letter = " ";
   
   private final int step = 10;
         
   Letter(String _letter){
      letter = _letter; 
  
      x = width/2+width/6;
      y = height/2;
   }
   
   void display(){
      noStroke();  
      fill(colorTxt);
      text(letter, x, y + glitch() );
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
