class Recorder{
  
   int x = 25;
   int y = 25;
   int w = 20;
   int h = 20;
      
   Recorder(){

   }

   void display(){
      if(isOver()){
         stroke(225, 0, 0,200);
         noFill();
         rect(x-5, y-5, w+9, h+9);

         cursorHand = true;
      }

      //recorder
      if(recording){
        noStroke();
        fill(255,0,0, 255);
        rect(x, y, w, h); 
      }
      else{
        noStroke();
        fill(255,0,0, 100);
        rect(x, y, w, h); 
      } 
   }

  void checkClick(){
    if(isOver()){
      if(recording) recordOFF();
      else recordON();
    }
  }

  boolean isOver(){
    if (( mouseX > x &&  mouseX < x+w ) && ( mouseY > y &&  mouseY < y+h ) ){
      return true;
    }
    else{
      return false; 
    }
  }

}