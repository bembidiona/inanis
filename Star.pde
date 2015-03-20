class Star{
  
   private int x = 0;
   private int y = 0;   
   private float speed = 3;
   private float paralaje;
   
   String txt = "*";
   
   Boolean isOut = false;
         
   Star(){
     x = width + 20;
     y = floor(random(height - 40)) + 20;     
     paralaje = random(2);     
   }
   
   void display(){
     
     text(txt,x,y); 
     
     if(x < 0) isOut = true;
   }
   
   void stepForward(){
     x -= speed*paralaje;
   }
   void stepBack(){
     x += speed*paralaje;
   } 
}   
