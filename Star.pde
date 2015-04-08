class Star{
  
   private int x = 0;
   private int y = 0;   
   private float speed = 3;
   private float paralaje;
   private Boolean virgen = true;
   
   final private int alpha = floor(random (100) + 100);
   
   String txt = "*";
   
   Boolean isOut = false;
         
   Star(){
     x = width + 20;
     y = floor(random(height - 40)) + 20;     
     paralaje = random(2);     
   }
   
   void display(){
     
     fill(colorTxt, alpha);
     text(txt,x,y); 
     
     if(x < 0) isOut = true;     
     
   }
   
   void stepForward(){
     x -= speed*paralaje;
   }
   void stepBack(){
     x += speed*paralaje;
   } 

   void change(String newTxt){
    if(virgen){
      virgen = false;
      txt = newTxt;
    }    
   }
}   
