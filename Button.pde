class Button{
  
   int x = 0;
   int y = 0;
   int w = 0;
   int h = 0;
   PImage sprite;  
 
   String name;
   
   Button(String _name){    
     name = _name;     
     
     int safe = 5;
     w = 50;
     h = 30;
     
     x = width - w - safe;
     y = h + safe;
   }
   
   void display(){   
     textFont(fontOptions);                 
     fill(255);  
     //textAlign(center);    
     text(name, width, height);    
     
     if((mouseX > x && mouseX < x+w) && (mouseY > y && mouseY < y+h)){
       text("-"+name, width, 0);        
     }
     else {
       text(name, width, 0); 
     }
        
   }
   
   void checkClick(){
     if(mouseX > x && mouseX < x+w){
       if(mouseY > y && mouseY < y+h){
          selectFolder("On exit Save to this folder", "checkPath");         
       }    
     }
   }   
}   
