////////////////*************************************************************////////////////
//A physics based system to compare mapping behaviours of documents when constrained by various comparative techniques
//made possible by the authors of the many fantastic libraries listed below. With thanks

//cc. non commercial share alike Tom Schofield 2011
////////////////*************************************************************////////////////



////////////////*********************TODO*****************************////////////////

////check if dropped file is pdf or txt
//text search re-implement

////////////////*************************************************************////////////////




////////////////***********IMPORT STATEMENTS ****************************////////////////
//GUI library
import controlP5.*;
//pos tagging and word stemming from wordnet 
import rita.wordnet.*;
//xml writing
import proxml.*;
import proxml.XMLElement;
import proxml.XMLInOut;
//physics from toxi
import toxi.geom.*;
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
//java libraries fro drag and drop
import java.awt.dnd.*;
import java.awt.datatransfer.*;
//java maths for log
import java.lang.Math;
import java.util.Set;

////////////////******************GLOBAL VARIABLES *********************************////////////////
PFont font;
//variable defining how many different analyses there are available this count will be incremented if another analysis is introduced
int NUM_SYSTEMS;
//String APIKey="AIzaSyAtOf1n2bUYvR_k7HGTNrWsXA57-H6ttW4";
//String YahooKey="cCwTbTjV34G4z1D.P82mb9.rPaq5Efph.M8X1ecLqO9CNzoY8iCDc4_fsBDKUaWe.Nsuqpqiwtg-";
///////CONTROL P5 VARIABLES/////////
String currentSearch="";
int messageSwitch=0;
int corpusSwitch=-1;
int destRelOpen=-1;
int widthOfFrame;
float timer=0;
boolean toggleValue = false;
boolean dropped = true;
boolean show=false;
boolean showS=false;
boolean openDocIsOn=false;
ArrayList myContext;
boolean newParticle=false;

String newPathDrop="";
///////////////////////////////////

////////////////******************OBJECTS *********************************////////////////


XMLInOut IO; 
Textfield myTextfield;
ControlP5 controlP5;
RiWordnet wordnet; 
PdfExtractor pdfExtractor;
DocMap[] docMap;
VerletPhysics2D[] physics;
Message message;

ScrollList l;
ScrollList la;
////////////////*************************************************************////////////////
void setup() {
  size(1300,700);
  smooth();
  //set font
  pdfExtractor=new PdfExtractor();  

  ////this array should contain the exact folder names of the corpera you want to use - make sure they are within
  String[] corpusNames= {
    "architecture", "art", "critical"
  };
  int num_docs=10;
  boolean start_from_scratch=false;
  
  
  NUM_SYSTEMS=corpusNames.length;

  font =loadFont("Helvetica-14.vlw");
  textFont(font,14);
  // make new in out object
  IO = new XMLInOut(this);
  //wordnet is used for POS tagging in analysis to disregard non content words
  wordnet = new RiWordnet(this);

  //each map has its own physics system because i want the ability to clear some maps completely  but not others

    physics =new VerletPhysics2D[NUM_SYSTEMS];
  docMap = new DocMap[NUM_SYSTEMS];
  message=new Message(50,height-50);

  for(int i =0;i<NUM_SYSTEMS;i++) {

    /////SETUP PHYSICS
    physics[i]=new VerletPhysics2D();
    widthOfFrame=width/(NUM_SYSTEMS);
    int centreX=i*(width/(NUM_SYSTEMS+1));
    int centreY=height/2;
    //devide the stage into even sections, 1 for each simultation
    physics[i].setWorldBounds(new Rect(centreX-(0.5*widthOfFrame), centreY-(0.5*widthOfFrame),centreX+(0.5*widthOfFrame), centreY+(0.5*widthOfFrame)));
  }

  //array of corpus names is passed in here
  setupMaps(corpusNames, start_from_scratch, num_docs);

  //tidies up control p5 stuff
  setupControls();
}


////////////////*************************************************************////////////////
void draw() {
  background(0);

   //SET UP CORPUS TO ACTIVE OR DORMANT
  if(corpusSwitch>=0) {
    docMap[corpusSwitch].corpusActive=true;
    //  println("docMap[corpusSwitch].corpusActive "+docMap[corpusSwitch].corpusActive);
    for(int i=0;i<docMap.length;i++) {
      if(i!=corpusSwitch) {
        //  println("corpusSwitch "+corpusSwitch+" "+i);
        docMap[i].corpusActive=false;
      }
    }
  }
  
  
  for(int i=0;i<NUM_SYSTEMS;i++) {
    //dropped indicated analysis etc is finished to prevent threading issues
    if(dropped) {
      physics[i].update();

      docMap[i].updateParticles();
      docMap[i].showCentre();
    }
  }
  message.messageSwitcher(messageSwitch, myContext);
}
////////////////*************************************************************////////////////
//CONTROL P5 SETUP
void setupControls() {
  controlP5 = new ControlP5(this);
  //controlP5.addToggle("destroy_relocate",false,50,50,20,20);
  //controlP5.addButton("start_over",10,50,100,80,20).setId(1);
  controlP5.addToggle("show_titles",false,50,150,20,20);
  controlP5.addToggle("show_words",false,50,250,20,20);
  myTextfield = controlP5.addTextfield("search_for",50,200,200,20);
  l = controlP5.addScrollList("myCorpus",50,320,120,280);
  l.setLabel("select active corpus");
  for(int i=0;i<NUM_SYSTEMS;i++) {
    controlP5.Button b = l.addItem("a"+i,i);
    b.setId(100 + i);
  }
  la = controlP5.addScrollList("myChooser",50,380,120,280);
  la.setLabel("destroy/relocate/open");
  String[] labels = {
    "relocate","destroy","open"
  };
  for(int i=0;i<NUM_SYSTEMS;i++) {
    controlP5.Button c = la.addItem(labels[i],i);
    c.setId(100 + i);
  }
}
////////////////*************************************************************////////////////

void setupMaps(String[] titles, boolean fromScratch, int num_of_docs) {
  docMap=new DocMap[NUM_SYSTEMS];

  for(int i=0;i<NUM_SYSTEMS;i++) {
    docMap[i]=new DocMap(num_of_docs, titles[i], titles[i], (i+1)*width/(NUM_SYSTEMS+1), height/2,i);
    //docMap[1]=new DocMap(10,"art", "art",2*(width/(NUM_SYSTEMS+1)), height/2,1);
    //docMap[2]=new DocMap(10,"critical", "critical",3*(width/(NUM_SYSTEMS+1)), height/2,2);
  }
  for(int i=0;i<NUM_SYSTEMS;i++) {
    //toggle bool to loadfrom file/log
    docMap[i].setupMap(fromScratch);
  }
}
////////////////*************************************************************////////////////
//SWITCHES BETWEEN DIFFERENT SIMULATIONS AND PASSES CURRENT PARTICLE POSITIONS FROM ONE TO ANOTHER IF SO CHOSEN
void switchSystem(int selector) {
}
////////////////*************************************************************////////////////
//SAVES SEPERATE LOG FILES FOR ALL THE CURRENT ANALYSES
void saveLog() {
}

////////////////*************************************************************////////////////
//SWITCHES BETWEEN DIFFERENT MESSAGES AS FEEDBACK FROM GUI
void switchMessages(int selector) {
}

////////////////*************************************************************////////////////
//FIND CLOSEST PARTICLE TO MOUSE
void findClosest() {

  float minDistance=2000;
  int closestIndex=-20;
  int closestMap=-20;
  PVector  v1 = new PVector(mouseX,mouseY, 0);

  //check all the maps

  int j;
  //for(int j=0;j<docMap.length;j++) {
  if(corpusSwitch>=0) {
    j=corpusSwitch;
  }
  else {
    j=0;
  }

  //for(int j=0;j<docMap.length;j++) {
  //and each particle for that map
  for(int i=0;i<docMap[j].NUM_PARTICLES;i++) {

    PVector  v2 = new PVector(docMap[j].particles[i].xPos,docMap[j].particles[i].yPos, 0); 
    if(PVector.dist(v1,v2) <minDistance) {
      minDistance=PVector.dist(v1,v2);
      closestIndex=i;
      closestMap=j;
    }
  }
  //}



  if(minDistance<50) {

    docMap[ closestMap].particles[ closestIndex].pi.x=mouseX;
    docMap[ closestMap].particles[ closestIndex].pi.y=mouseY;

    // closestIndex=-20;
    // closestMap=-20;
  }
}

////////////////**************HANDLES MOUSE INTERACTION INCLUDING RELOCATE KILL AND OPEN***************************////////////////

void mousePressed() {
  int j;
  //for(int j=0;j<docMap.length;j++) {
  if(corpusSwitch>=0) {
    j=corpusSwitch;
  }
  else {
    j=0;
  }


  for(int i=0;i<docMap[j].particles.length;i++) {

    if(toggleValue) {
      docMap[j].particles[i].kill(docMap[j].particles);
      int tol=20;
      if(mouseX>docMap[j].particles[i].pi.x-tol&&mouseX<docMap[j].particles[i].pi.x+tol&& mouseY>docMap[j].particles[i].pi.y-tol&&mouseY<docMap[j].particles[i].pi.y+tol&&mousePressed) {
        docMap[j].particles[i].alive=false;
      }
    }
  }

  if(openDocIsOn) {
    for(int i=0;i<docMap[j].particles.length;i++) {
      int tol=20;
      if(mouseX>docMap[j].particles[i].pi.x-tol&&mouseX<docMap[j].particles[i].pi.x+tol&& mouseY>docMap[j].particles[i].pi.y-tol&&mouseY<docMap[j].particles[i].pi.y+tol&&mousePressed) {
        docMap[j].particles[i].openDoc();
      }
    }
  }


  // }
}


void mouseDragged() {
  findClosest();
}



