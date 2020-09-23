# Inanis
Word processor for vapor people.\
Intended for stream of consciousness sessions and dynamic poetry.\
It's main features revolve around net arty visuals and relaxing sounds that evolve from your typing 
and words, and the possibility of recording your sessions or phrases and play them back live all at once.\
Online multiwriter has been truncated for now.

<p align="center">
  <img width="600" height="375" src="https://raw.githubusercontent.com/bembidiona/inanis/master/_readme/inanis_3.jpg">
</p>


## Instructions
#### Triggers
There are some especial words that created different visual effect and trigger functions.\
Just type them in the stream, but is important that they get separated by spaces.\
A bunch of keywords are listed below. Others await to be discovered.\
Example with trigger "rain"\
`"... i think it's going to rain tonight ..."` WORKS\
`"... i think it's going to rainntonight ..."` DON´T WORK

#### Save and load sessions
Click the upper-left red rectangle to start recording your inputs.\
To save the recording, just write your desired file name followed by ".sav"\
Examples:\
`"exampleName.sav"`\
`"todaySession.sav"`\
Then you can load this and other older save files from the right menu.

#### Controlling loaded streams
Click 'n drag carets to move them around.\
Right click to delete a loaded caret and its stream of letters.\

#### Visual Themes and usability
Change the font size with [+] and [-] keys\
Change the font with the trigger **"font"**\
Change the color theme with the trigger **"color"**\
When writing in the dark, it´s useful to set the sea position with [↑] and [↓] keys. Gives a soft low light that illuminates the keyboard.

#### Music Scales
You can change the musical scale used in the typing sounds\
Type "**scale:**" followed by the intervals.\
Examples:\
`"scale:0-2-4-6-8-10-12"` for a whole-tone scale\
`"scale:0-2-4-5-7-9-11-12"` for a major scale\
`"scale:0-12"` for a just using a root and the first octave

#### Exporting raw text and images
You can save a .txt file of all the text wrote since Inanis started, writing your desired file name followed by ".txt"\
Examples:\
`"textDump.txt"`\
`"dream_4-12.txt"`\
You can save a capture of the screen writing your desired file name followed by ".png", ".jpg", or ".bmp"\
Examples:\
`"screenshot.png"`\
`"inanisIsLookingCute.jpg"`\
`"suchraw.bmp"`


### MISCELLANEOUS WORD TRIGGERS
- triggerLOVE = {"amor", "love", "amar", "shrimp", "afecto"};
- triggerDEAD = {"muerte", "mori", "dead", "fetal"};
- triggerGLITCH = {"glitch", "bakun", "art", "arte"};
- triggerCLIENT = {"connect", "conectar"};
- triggerMUSICSCALE = {"scale", "escala"};
- triggerSAVE = {".sav"};
- triggerTXT = {".txt"};
- triggerDEBUG = {"debug"};
- triggerCOLOR = {"color", "colour"};
- triggerFONT = {"font", "letra"};
- triggerPIX = {".png", ".bmp", ".jpg", ".jpeg", ".tiff"};
- triggerSCALE = {"encerrado", "grande", "big", "close", "cerca"};
- triggerBLOOD = {"sangre", "blood", "pelo", "hair"};
- triggerPANIC = {"panic", "ansiedad", "attack", "panico", "pánico", "manija"};
- triggerPICADO = {"odio", "mar", "ocean", "hate", "water", "tormenta"};
- triggerRAIN = {"lluvia", "llover", "llueve", "lloviendo", "rain", "llorar", "cry", "tormenta"};


### KEYBOARD SHORTCUTS
- [-] Decrease font size
- [+] Increase font size
- [↑] Move up the sea
- [↓] Move down the sea
- [Ctrl]+[Space] Start recording
- [Ctrl]+[S] Save all writings to a .txt file 
- [Ctrl]+[E] Export an image file of the screen
- [Esc] Exit to desktop
