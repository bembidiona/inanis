class SoundPlayer {
  
  AudioSample[] sKeys;  
  Boolean sfxON = true;    
  AudioSample sKey_1; 
  int sKeyNum = 0;
  AudioOutput out;
  
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
    
  }
  
  void playKey(int _key){    
    int sNum = _key % sKeyNum;
    if (sfxON) sKeys[sNum].trigger(); 
    
    float duration = 1;
    //out.playNote( 0, duration, new SineInstrument( _key + 100 +_key*5) );
    if(sNum == 0)       out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "E3" ).asHz() ) );
    else if (sNum == 1) out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "G3" ).asHz() ) );
    else if (sNum == 2) out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "A3" ).asHz() ) );
    else if (sNum == 3) out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "B3" ).asHz() ) );
    else if (sNum == 4) out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "D3" ).asHz() ) );
    else if (sNum == 5) out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "E3" ).asHz() ) );
    else if (sNum == 6) out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "F3" ).asHz() ) );
    else if (sNum == 7) out.playNote( 0, duration, new SineInstrument( Frequency.ofPitch( "G3" ).asHz() ) );
       
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

// INSTRUMENTS
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

