class Letter{
  
   int x = 2;
   int y = 1;
      
   String letter = " ";   
   
   float windX = 0.01; 
   private int windTimer = 0;
   int windTimerMax = 1;
   
   Boolean isOut = false;

   private int alpha = 255;
   
   Boolean isTrigger = false;
         
   Letter(String _letter, int _x, int _y){
      letter = _letter; 
  
      x = _x - floor(textWidth(letter));//step;
      y = _y;
   }
   
   void display(){    
      noStroke();
      if(x > -10){
        int margen = 500;
        if(x < margen) alpha = floor((((x*100)/margen) * 255 ) / 100);
        else alpha = 255;
        
        
        
        if (isTrigger) fill(colorTrigger,alpha);
        else fill(colorTxt,alpha);      

        text(letter, x, y + glitch() );
        
        for (int i = 0; i < 2; i++){  
          if (isTrigger) fill(colorTrigger,alpha/2.5);
          else fill(colorTxt, alpha/5);
          //text(letter, x+random(2), y + glitch() +random(2));
        }
        if(blood > 0 && !letter.equals(" ")){
          for (int i = 0; i < 2; i++){  
            if (isTrigger) fill(colorTrigger,alpha);
            else fill(colorTxt);
            rect(x-8/2 + random(8) ,y, 1, random(blood));
          }  
        }
      }

      
      
      
      

      /*if (windTimer > windTimerMax){
        x -= windX;
        
        windTimer = 0; 
      }
      else windTimer++;*/
      
      x -= 0.00001;
      
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