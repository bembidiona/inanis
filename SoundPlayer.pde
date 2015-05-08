class SoundPlayer {
  
  AudioSample[] sKeys;  
  Boolean sfxON = true;    
  AudioSample sKey_1; 
  int sKeyNum = 0;
  AudioOutput out;
  
  int octava = 3;
  final int octavaMIN = 1;
  final int octavaMAX = 4;
  float duration = 0.7; 
  
  ArrayList<Scale> scales = new ArrayList<Scale>();
  
  int currentScaleNum = 0;
  String[] currentScale;
  
  int lastNoteTime;
  
  SoundPlayer() {
    
    out = minim.getLineOut();
    
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
    
    //scales
    String[] notes1 = {"E0", "G0", "A0", "B0", "D0"};
    scales.add(new Scale(notes1));
    String[] notes2 = {"C0", "D0", "E0", "F0", "G0", "A0", "B0"};
    scales.add(new Scale(notes2));
    String[] notes3 = {"C0", "B0"};
    scales.add(new Scale(notes3));
    
    currentScale = scales.get(currentScaleNum).scale;
  }
  
  void playKey(int _key){    
    
    if (sfxON)
    {
      int sNum = _key % sKeyNum;
      sKeys[sNum].trigger(); 
    
       
      sNum = _key % currentScale.length;
      String note = currentScale[sNum].substring(0,1);
      String oct = str(     int(currentScale[sNum].substring(1,2)) + octava  );
      
      out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch(  note + oct ) .asHz()  ));
      
      
      if(millis() < lastNoteTime + 150){
        octava++;
        if(octava > octavaMAX) octava = octavaMAX;
      } 
      else if(millis() > lastNoteTime + 800){
        octava--;
        if(octava < octavaMIN) octava = octavaMIN;
      } 
         
      lastNoteTime = millis();
    }
  }
  
  void changeScale(){
    currentScaleNum++;
    if(currentScaleNum > scales.size()-1) currentScaleNum = 0;
    
    currentScale = scales.get(currentScaleNum).scale;    
  }
  
  
  void display(){
   stroke(colorTxt, 100);
    
   int waveStep = 5;
   int waveAmp = 20;
    
    for(int i = 0; i < out.bufferSize() - 1; i++){
      line(i*waveStep, user.y + out.left.get(i)*waveAmp, i*waveStep, user.y + out.left.get(i+1)*waveAmp );      
    }    
    noStroke();
  }
  
}

// CLASSSSSSSS
class Scale{  
  String[] scale;  
  Scale(String[] _scale){
    scale = _scale;
  } 
}


class SineInstrument implements Instrument
{
  Oscil wave;
  Line  ampEnv;
  
  SineInstrument( float frequency )
  {
    // make a sine wave oscillator
    // the amplitude is zero because 
    // we are going to patch a Line to it anyway
    wave   = new Oscil( frequency, 0, Waves.SINE );
    ampEnv = new Line();
    ampEnv.patch( wave.amplitude );
  }
  
  // this is called by the sequencer when this instrument
  // should start making sound. the duration is expressed in seconds.
  void noteOn( float duration )
  {
    // start the amplitude envelope
    ampEnv.activate( duration, 0.5f, 0 );
    // attach the oscil to the output so it makes sound
    wave.patch( soundPlayer.out );
  }
  
  // this is called by the sequencer when the instrument should
  // stop making sound
  void noteOff()
  {
    wave.unpatch( soundPlayer.out );
  }
}

