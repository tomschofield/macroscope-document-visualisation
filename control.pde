
////////////////A TAB WHICH CONTAINS ALL THE CONTROL P5 STUFF /////////////////////
void controlEvent(ControlEvent theEvent) {
  // println(theEvent.controller().id());
  //   println(theEvent.controller().value()+" from "+theEvent.controller());
  if (theEvent.isGroup()) {
    // println(theEvent.group().value()+" from "+theEvent.group());
    // corpusSwitch=int(theEvent.group().value());
    //println(corpusSwitch);
    // println("theEvent.group().id() "+  theEvent.group().name()     );
    //if corpus chooser
    if(theEvent.group().name().equals("myCorpus") ) {
      println(theEvent.group().value()+" from "+theEvent.group());
      
      
      corpusSwitch=int(theEvent.group().value());
      println(corpusSwitch);
      messageSwitch=corpusSwitch+8;
      timer=0;
      
      
    }

    else {
      println(theEvent.group().value()+" from "+theEvent.group());
      destRelOpen=int(theEvent.group().value());



      // corpusSwitch=int(theEvent.controller().value());
      //destroy
      if(destRelOpen==1) {
        // myColorBackground = color(100);
        toggleValue=true;
        openDocIsOn=false;
        messageSwitch=1;
        timer=0;
      } 
      
      //relocate
      if(destRelOpen==0) {
        toggleValue=false;
        openDocIsOn=false;
        messageSwitch=0;
        timer=0;
      }
      //open
      if(destRelOpen==2) {
         toggleValue=false;
         openDocIsOn=true;
          messageSwitch=2;
        //activate open mode here
      }
      
      println(messageSwitch);
    }
  }
}


public void search_for(String theText) {
  // receiving text from controller texting
  println("a textfield event for controller 'texting': "+theText);
  currentSearch=theText;
  messageSwitch=6;
  timer=0;
  //for(int i=0;i<docMap.length;i++){
 // docMap[0].findWords(theText);
 // }
   if(corpusSwitch>0){
    myContext = docMap[corpusSwitch].findWords(theText);
    messageSwitch=14;
   }
}


void start_over(float theValue) {
  // println("a button event. "+theValue);
  messageSwitch=4;
  timer=0;
//  resetAll();
}

/*void destroy_relocate(boolean theFlag) {
  if(theFlag==true) {
    // myColorBackground = color(100);
    toggleValue=true;
    messageSwitch=1;
    timer=0;
  } 
  else {
    toggleValue=false;
    messageSwitch=2;
    timer=0;
  }
  println(messageSwitch);
}*/

void show_titles(boolean theFlag) {
  show=theFlag;
  messageSwitch=5;
  timer=0;
  println(messageSwitch);
}

void show_words (boolean theFlag) {
  showS=theFlag;
  messageSwitch=7;
  timer=0;
  println(messageSwitch);
}
/////////////////////////////////////////////////////////////////////////////////////////

//
