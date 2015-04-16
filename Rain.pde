class Rain{
  
   private float x = 0;
   private float y = 0;   
   private float speed = 4;  
   final private int alpha = floor(random (100) + 100);
   Boolean isOut = false; 
        
   String txt = "\\";     
        
   Rain(){          
	 x = floor(random(width+width/3)-width/3);
     y = - 20;

     speed += random(speed/3);
   }
   void display(){
     
     fill(colorExtra, alpha);
     text(txt,x,y); 
     
     if(y > height + 20 || x > width + 20) isOut = true; 
     else{
       x += speed/2;
       y += speed;
     }    
     
   }
   
}
