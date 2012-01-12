//cc. non commercial share alike Tom Schofield 2011

//message CLASS PROVIDES FEEDBACK FROM INTERACTIO
class Message {
  float xPos;
  int yPos;

  Message(float x, int y) {
    xPos=x;
    yPos=y;
  }

  ////////////////******************main analysis *********************************////////////////

  void messageSwitcher(int num, ArrayList myContext) {

    switch(num) {

    case 0: 
      displayMessage("relocate mode active", xPos,yPos);
      break;
    case 1: 
      displayMessage("destroy mode active", xPos,yPos);
      break;
    case 2: 
      displayMessage("open mode active", xPos,yPos);
      break;
    case 3: 
      displayMessage("particle dropped and analysed", xPos,yPos);
      break;
    case 4: 
      displayMessage("start over", xPos,yPos);
      break;
    case 5: 
      displayMessage("document titles toggled", xPos,yPos);
      break;
    case 6: 
      displayMessage("search completed - glowing particles indicate a hit", xPos,yPos);
      break;
    case 7: 
      displayMessage("signifcant words are shown in descending order", xPos,yPos);
      break;
    case 8: 
      displayMessage("active corpus selected", xPos,yPos);
      break;
    case 9: 
      displayMessage("active corpus selected", xPos,yPos);
      break;
    case 10: 
      displayMessage("active corpus selected", xPos,yPos);
      break;
    case 11: 
      displayMessage("particle not added, source file is too big or has spaces in file name", xPos,yPos);
      break;
    case 12: 
      displayMessage("original pdf is not in folder", xPos,yPos);
      break;
      case 13: 
      displayMessage("pdf opening", xPos,yPos);
      break;
      case 14: 
      scrollMessage(myContext, xPos,yPos);
      break;
    }
  }


  void displayMessage(String message, float tx, int ty) {
    float timeLimit=100;
    float fillVal=0;
    if(timer<=timeLimit) {
      pushStyle();
      fillVal=122+(123*sin((timer*.1)));
      fill(255,fillVal);//,sin(timer));
      text(message,tx,ty);
      popStyle();

      timer++;
    }
    else {
      messageSwitch=0;
    }
    //println(fillVal+" " +timer);
  }
  
    void scrollMessage(ArrayList message, float tx, int ty) {
     // println("Scrolling message "+message);
     try{
     float speed=3.;
    String allContext="";
    for(int i=0;i<message.size();i++){
     allContext+=" SEARCH RESULT NUMBER "+str(i+1)+" OF "+ str(message.size())+" "+(String) message.get(i);
    }
     float timeLimit=(textWidth(allContext))+textWidth((String)message.get(message.size()-1))/speed;
    if(timer<=timeLimit) {
    
      pushStyle();
      
      fill(255);
      text(allContext,tx-timer,ty);
      popStyle();

      timer+=speed;
      println(timeLimit+" "+timer);
    }
    else {
      messageSwitch=0;
    }
    //println(fillVal+" " +timer);
  
     }
     catch(Exception e){
      println("no message yet"); 
      messageSwitch=0;
      timer=0;
     }
}
}

