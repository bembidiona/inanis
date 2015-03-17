class Button{
  
   int x = 0;
   int y = 0;
   int w = 0;
   int h = 0;
   PImage sprite;  
 
   String name;
   
   int margen = 5;
   
   Button(String _name, int buttonNum){    
     name = _name;     
     
     int separation = 20;
     int safe = 5;
     w = width - name.length() - margen;
     h = 0 + margen;
     
     x = width - name.length() - margen;
     y = h + safe + separation*buttonNum;
   }
   
   void display(){   
     textFont(fontOptions);                 
     fill(255);  
     //textAlign(center);     
     drawIt((mouseX > x && mouseX < x+w) && (mouseY > y && mouseY < y+h));    
        
   }
   
   void drawIt(boolean over){
     String txt = name;
     if (over) txt = "-" + txt ;
     
     text(txt, x, y);
   }   
   
   void checkClick(){
     if(mouseX > x && mouseX < x+w){
       if(mouseY > y && mouseY < y+h){
          selectFolder("On exit Save to this folder", "checkPath");         
       }    
     }
   }   
}   
