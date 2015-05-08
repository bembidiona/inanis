class SoundPlayer {

  
  AudioSample[] sKeys;  
  Boolean sfxON = true;    
  AudioSample sKey_1; 
  int sKeyNum = 0;
  
  SoundPlayer() {
    
    File dataFolder = new File( sketchPath + "/data/sfx/");
    File[] listFolder = dataFolder.listFiles();  
    
    for (File f : listFolder) {
      if (f.isFile()) {     
        sKeyNum++;
      }
    } 
  
    sKeys = new AudioSample[sKeyNum];
  
    for (int l=0; l < sKeyNum; l++) {
      sKeys[l] = minim.loadSample( "/sfx/key_"+ str(l+1) + ".wav", 512);
    }
    
  }
  
  void playKey(int _key){
    
    int sNum = _key % sKeyNum;
    
    println(sNum);
    if (sfxON) sKeys[sNum].trigger();           
  }
}

