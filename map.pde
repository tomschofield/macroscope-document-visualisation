//cc. non commercial share alike Tom Schofield 2011
//a super class to handle management of different particle systems

class DocMap {
  //each map has its own system of particles, its own physics and its own analysis

  Particle[] particles;

  Analysis analysis;
  String corpusName;
  String mapName;
  int NUM_PARTICLES, centreX, centreY;
  //the main xml element
  proxml.XMLElement logFile;
  int NUM_COMP=120;
  int index;
  boolean corpusActive=false;
  int alphaDivider=1;
  // Constructor
  DocMap(int NUM_P,String cN, String mN, int cX, int cY, int ind) {

    corpusName=cN;
    mapName=mN;
    NUM_PARTICLES=NUM_P;
    centreX=cX;
    centreY=cY;
    index=ind;
    analysis=new Analysis();
  }

  void setupMap(boolean fromFile) {
    if(fromFile) {
      analyse();
      setParticlesFromFile();
      saveLog();
    }
    else {
      
      setParticlesFromLog();
      trickAnalysis();
      saveLog();
    }
  }
  
  
  void analyse() {
    analysis.runTfidfComparison(corpusName, "docs", 10, 150, index);
  }
  
  ///////get all the necessary info from the log file
  void trickAnalysis(){
    analysis.getAllWordsFromFile(corpusName);
  }
  
  void testOurAnalysis() {
    
    println(analysis.allSignifWords[0].length +" "+analysis.attractionForces[0].length);
    
    //compare documents
    
    //calculate forces
    
    
   // analysis.runTfidfComparison(corpusName, "docs", 10, 150, index);
  }
  void analyseOne(String droppedPath){
    analysis.runTfidfComparisonOnce( droppedPath, corpusName, "docs", 11, 150, index);

  }
  void addParticleFromDrop(){
    //update forces arrays for all particles
    
    
    
    //update NUM_PARTICLES for all particles
  }

  void addAttractions(){
    //for all existing particles append an extra attraction force onto the end of its array from the new analysis. the new analysis already has a full set so dont include this
     for(int i=0;i<NUM_PARTICLES;i++) {
     //  println(" particles[i].attractionForces.length "+particles[i].attractionForces.length);
       particles[i].attractionForces=append(particles[i].attractionForces, analysis.oneTfidf.attractionForces[i]);
      //  println(" particles[i].attractionForces.length "+particles[i].attractionForces.length);
     }
    
  }
  void addParticle(){
    println(" NUM_PARTICLES "+particles.length);
   Particle newParticle=new Particle( (0.5*centreX)+(int)random(0,(0.5*centreX)),(int)random(0,height),NUM_PARTICLES, analysis.oneTfidf.attractionForces,NUM_PARTICLES, analysis.oneTfidf.fileName, analysis.oneTfidf.signifWords, analysis.oneTfidf.lines, index) ;
  particles=(Particle[])append(particles,newParticle );
  
   NUM_PARTICLES=particles.length;
   for(int i=0;i<NUM_PARTICLES;i++) {
     particles[i].numOfParticles=NUM_PARTICLES;
     
   }
     println(" NUM_PARTICLES "+particles.length);
     physics[index].clear();
      physics[index].setWorldBounds(new Rect(centreX-(0.5*widthOfFrame), centreY-(0.5*widthOfFrame),centreX+(0.5*widthOfFrame), centreY+(0.5*widthOfFrame)));
     for(int i=0;i<NUM_PARTICLES;i++) {
       particles[i].addForces(particles);
     }
    
  }
  
  void setParticlesFromFile() {
    particles= new Particle[NUM_PARTICLES];

    for(int i=0;i<NUM_PARTICLES;i++) {
      println("analysis.attractionForces[i] "+analysis.attractionForces[i]);
      println("analysis.fileNames[i] "+analysis.fileNames[i]);
      println("analysis.significantWords[i] "+analysis.significantWords[i]);
      println("analysis.lines[i] "+analysis.lines[i]);
      particles[i]=new Particle( (0.5*centreX)+(int)random(0,(0.5*centreX)),(int)random(0,height),NUM_PARTICLES, analysis.attractionForces[i],i,  analysis.fileNames[i], analysis.significantWords[i], analysis.lines[i], index) ;
      
  
      }
    for(int i=0;i<NUM_PARTICLES;i++) {
      particles[i].addForces(particles);
    }
  }

  void makeAllGlow() {
    for(int i=0;i<NUM_PARTICLES;i++) {
      particles[i].glow=true;
    }
  }
  void setParticlesFromLog() {
    println("SETTING UP PARTICLES FROM "+mapName+" LOG");
    logFile = IO.loadElementFrom(mapName+".xml");

    //log file is the main element in the xml file
    //println("children "+logFile.countChildren());
    //make as many particles as we have xml elements
    
    NUM_PARTICLES=logFile.countChildren();
    particles=new Particle[NUM_PARTICLES]; 
    proxml.XMLElement[] children=logFile.getChildren();
    
     ////these are passed back into the analysis class
     String[][] allSigWords=new String[NUM_PARTICLES][];
    float[][] allAttractionForces=new float[NUM_PARTICLES][];
    
    
    //for each document
    for(int i=0;i<logFile.countChildren();i++) {

      String title= children[i].getAttribute("docName");

      //we need to know how many
      int NUM_CHILDREN=children[i].countChildren();

      //CHANGED FROM *1
      int NUM_FORCES=logFile.countChildren();
      int NUM_SIGWRDS=NUM_COMP;

      //the sigwords are in an array whose length is set globally
      String[] sigWrds=new String[NUM_COMP];

      for(int j=0;j<NUM_COMP;j++) {
        try {
          sigWrds[j]= children[i].getAttribute("sigWords_"+str(j));
          //    println("children[i].getAttribute(+str(j)) "+children[i].getAttribute("sigWords_"+str(j)));
        }
        catch (Exception e) {
          sigWrds[j]="TESTER";
          //  println("DUD");
        }
      }
      float[] attFrcs=new float[NUM_FORCES];
      for(int j=0;j<NUM_FORCES;j++) {
        try {
          attFrcs[j]=children[i].getFloatAttribute("attractionForce_"+str(j));
        }
        catch (Exception e) {
          attFrcs[j]=0.0;
        }
      }
      //TODO change second sigWrds to Lines and save lines in the xml
      //get lines of original text from document
      String[] lines;
      try{
      lines=loadStrings( "docs/"+title+".txt"); 
      }
      catch (Exception e) {
        println("document \""+title+"\" is missing");
         lines=new String[1];
         lines[0]="no document info";
        }
     //   for(int k=0;k<lines.length;k++){  
      //lines[k]=lines[k].replaceAll("[^A-Za-z]", " ");
       // }
      particles[i]=new Particle((0.5*centreX)+(int)random(0,(0.5*centreX)),(int)random(0,height),NUM_PARTICLES, attFrcs,i, title, sigWrds, lines, index) ;
     // println(lines);
      allSigWords[i]=sigWrds;
      allAttractionForces[i]=attFrcs;
    
      
    }
    
    //populate the analysis arrays with stuff they will need for comparison with any future dropped particle
    analysis.getWordsAndForcesFromLog(allSigWords, allAttractionForces);
   //println("analysis contents "+analysis.attractionForces[0].length+ " "+analysis.significantWords[0].length);
    
    
    for(int i=0;i<NUM_PARTICLES;i++) {
      particles[i].addForces(particles);
    }
    
    
    
    
  }
  void showCentre() {
    pushStyle();

    float cX=0;
    float maxY=1000;
    for(int i=0;i<particles.length;i++) {
      cX+=particles[i].xPos;
      if(particles[i].yPos<maxY)maxY=particles[i].yPos;
      
    }
    cX/=particles.length;


    fill(10,100,150,200);
    text(corpusName+" corpus",cX-(textWidth(corpusName+" corpus")/2),maxY-50);
    popStyle();
  }

  void updateParticles() {

    // int closest=findClosest();
    setAlpha( corpusActive);
    for(int i=0;i<NUM_PARTICLES;i++) {
      particles[i].update(particles); 
      particles[i].drawConnections(particles);
    }
    for(int i=0;i<NUM_PARTICLES;i++) {

      // textPos+=5* particles[i].displayContext(currentSearch, textPos); 
      particles[i].drawParticle(show);
      particles[i].displaySignifWords(showS);


      //particles[i].interact(particles, mouseX, mouseY);
    }
    //    if(closest>=0){
    //   particles[closest].interact();
    //    }
  }
  ArrayList findWords(String search) {
  ArrayList foundPhrases=new ArrayList();

    for(int i=0;i<NUM_PARTICLES;i++) {
      particles[i].glowTimer=0;
      particles[i].searchWord(search);
     // println("find words has been called");
     // println(particles[i].getContext(search));
      
      if(particles[i].getContext(search).size()>0){
       for(int j=0;j< particles[i].getContext(search).size();j++){
         foundPhrases.add(particles[i].getContext(search).get(j));
       }
      }
    }
     //   for(int i=0;i<foundPhrases.size();i++){
      //println("foundPhrases at "+i+" "+foundPhrases.get(i));
      
  //  }
   //println("found phrases "+foundPhrases+ " size "+foundPhrases.size());
   return foundPhrases;
  }


  void saveLog() {
    //we need to save 1) doc title 2) signif words 3) attractionForces

    String[] titles=new String[particles.length]; 
    String[][] sigWrds=new String[particles.length][]; 
    float [][] attFrcs=new float[particles.length][]; 
    for(int i=0;i<particles.length;i++) {
      titles[i]=particles[i].docName;
      sigWrds[i]=particles[i].signifWords;
      attFrcs[i]=particles[i].attractionForces;
    }


    //get main XML element
    logFile = IO.loadElementFrom("outline.xml");

    //should be no kids
    // println("children "+logFile.countChildren());

    for(int i=0;i<titles.length;i++) {
      proxml.XMLElement doc = new XMLElement(titles[i]);
      logFile.addChild(doc);
      //first attribute is the title
      doc.addAttribute("docName", titles[i]);

      //make attributes for all sig words
      for(int j=0;j<sigWrds[i].length;j++) {
        try {
          doc.addAttribute("sigWords_"+str(j), sigWrds[i][j]);
          //  println(titles[i]+ " "+j+" "+sigWrds[i][j]);
        }
        catch(Exception e) {
          doc.addAttribute("sigWords_"+str(j), "TESTER");
          //  println("found blank");
        }
      }

      //same for the forces
      for(int j=0;j<attFrcs[i].length;j++) {

        doc.addAttribute("attractionForce_"+str(j), attFrcs[i][j]);
      }
      // println("children "+logFile.countChildren());
    }

    //save everything to file
    IO.saveElement(logFile, corpusName+".xml");
  }
  void setAlpha(boolean isActive) {
    if(isActive) {
      for(int i=0;i<particles.length;i++) {
        particles[i].transparency=1.;
      }
    }
    else {
      for(int i=0;i<particles.length;i++) {
        particles[i].transparency=6.;
      }
    }
  }
}

