//cc. non commercial share alike Tom Schofield 2011
//requires VerletPhyics2D available from toxiclibs


class Particle {

  float xPos;
  float yPos;
  float xVel=0;
  float yVel=0;
  //an array to hold all the other particle words
  String [] keys;
  String delimiters = " ,.?!;\\\":[]()-";
  //TODO this doesn't belong here - it should be in the cooccurance class
  //all the words that this particle co-occurs with
  String [] coOccs;
  //how many times each of those words co-occurs 
  int [] coOccValues;
  ArrayList attractorIndices;
  String word;
  String [] signifWords;
  int numOfParticles;
  float[] attractionForces;
  int thisIndex;
  float maxAttraction;
  float minAttraction;
  boolean alive=true;
  boolean glow=false;
  float transparency=1.;
  int textLength=0;
  //this is the physics particle object
  VerletParticle2D pi;
  String docName;
  int startPos=0;
  float glowTimer=0;
  String[] lines;
  int SYS_SELECTOR;


  Particle(float x, float y, int num, float[]att, int ind, String name, String[]sw, String[] lns, int SYS_S) {
    xPos =x;
    yPos =y;
    numOfParticles=num;
    attractionForces=att;
    thisIndex=ind;
    signifWords=sw;
    lines=lns;
    pi=new VerletParticle2D(xPos,yPos);
    SYS_SELECTOR=SYS_S;
    //TODO this name is passed in from the tfidf function it comes hence the weird stripping stuff
    try {
      String temp[]=splitTokens(name,"/.");
      docName=temp[1];
    }
    catch (ArrayIndexOutOfBoundsException e) {
      docName=name;
    }
  }

  void addForces(Particle[] otherParticles) {
    checkRange();
    float radius=(height/3)/(0.1+maxAttraction);



    for(int i =0;i<numOfParticles;i++) {
      //float spring=attractionForces[i]*30;

      //don't try and add attradction forces to yourself!
      if(i!=thisIndex) {
        // println(attractionForces[i]+" attractionForces[i]");

        float spring=(height/2) -(radius*attractionForces[i]);
        //   println("attractions "+spring);
        physics[SYS_SELECTOR].addSpring(new VerletSpring2D(pi,otherParticles[i].pi,spring,0.001));
      }
    }
  }

  void checkRange() {
    maxAttraction = max(attractionForces);
    minAttraction = min(attractionForces);
    //  println("  maxAttraction "+  maxAttraction+" " + minAttraction);
  }

  void makeUnique() {
    //this function counts how many times each word co-occurs and puts the results into 2 arrays (coOccs and coOccValues)

    //the array list is temporary to hold the un
    ArrayList Unique;
    Unique = new ArrayList(); 

    //for each coOcc word
    for(int i=0;i<coOccs.length;i++) {

      boolean inArray=false;
      //check the list to see if its already there
      for(int j=0;j<Unique.size();j++) {

        //println("i + j "+i+" "+j);
        try {
          if(coOccs[i].equals((String)Unique.get(j))) {
            inArray=true;
            //    println("in array");
          }
        }
        catch(NullPointerException e) {
        }
      }
      if(!inArray) {
        //  println("not in array");
        Unique.add(coOccs[i]);
      }
    }
    //if it is eliminating words then these should be different sometimes!
    //println(coOccs.length+" "+notUnique.size());

    //myOccs is a temporary array to hold the unique coOccs from the array list
    String[] myOccs=new String[Unique.size()];
    coOccValues=new int[Unique.size()];

    for(int i=0;i<Unique.size();i++) {

      //copy from array list for convenience sake
      myOccs[i]=(String)Unique.get(i);

      for(int j=0;j<coOccs.length;j++) {
        try {
          //each time you get a match with the original coOccs array (which contains repeated words) increment the coOccValue for that position
          if(coOccs[j].equals((String)Unique.get(i))) {
            coOccValues[i]++;
          }
        }
        catch(NullPointerException e) {
        }
      }
    }
    //  println("coOccs.length "+coOccs.length);
    coOccs=myOccs;
    //println("new coOccs.length "+coOccs.length);
    //println(coOccs[0]+" "+coOccValues[0]);
    //println("new first index "+coOccs[0]);
  }

  void findAttractors(Particle[] particleArray) {

    //gives an array list of index values for related particles - the point fo this is so that we know exactly which other particles this one is affected by
    attractorIndices= new ArrayList();
    for(int i=0;i<particleArray.length;i++) {
      for(int j=0;j<coOccs.length;j++) {

        if(particleArray[i].word.equals(coOccs[j])) {
          attractorIndices.add(i);
        }
      }
    }
    //   println("attractor indices "+attractorIndices);
  }


  void update(Particle[] otherParticles) {
    xPos=pi.x;
    yPos=pi.y;
  }


  void drawParticle(boolean textOn) {
    float glowLimit=100;
    //float glowLimit=textLength;
    if(alive) {
      fill(0, 255/transparency);
      stroke(120,255/transparency);


      ellipse(xPos,yPos,20,20);
      if(glow) {

        pushStyle();
        if(glowTimer<=glowLimit) {

          float fillVal=22+(123*sin((glowTimer*.1)));
          fill(0,100,100,fillVal/transparency);


          ellipse(xPos,yPos,25,25);
          popStyle();
          glowTimer+=.5 ;
        }
      }
      if(glowTimer>glowLimit) glow=false;
      if(textOn) {
        fill(220,255/transparency);

        text(docName,xPos,yPos);
      }
    }
    // ellipse(xVel,yVel,20,20);
    // text(str(thisIndex),xVel,yVel);
  }
  void displaySignifWords(boolean showSig) {
    if(alive) {
      //TODO reset to strart of array
      int numToDisplay=10;
      int alphaShift=200;
      if(showSig) {
        int yShift=10;
        for(int i=startPos;i<startPos+numToDisplay;i++) {
          fill(220,alphaShift/transparency);
          try {
            text(signifWords[i],xPos,yPos+yShift);
          }
          catch(Exception e) {
            println("problem with text display");
          }
          yShift+=10;

          alphaShift-=255/numToDisplay;
        }
      }
      if(frameCount%20==0) {
        startPos++;
      }
      if(startPos>=signifWords.length-(1+numToDisplay)) {
        startPos=0;
      }
    }
  }

  void drawConnections(Particle[] otherParticles) {
    pushStyle();
    for(int i=0;i<numOfParticles;i++) {
      if(i!=thisIndex) {

        if(otherParticles[i].alive&&alive) {
          stroke(150,map(attractionForces[i],0,maxAttraction,10,105)/transparency);
          strokeWeight(map(attractionForces[i],0,maxAttraction,1,5));
          float otherX=otherParticles[i].xPos;
          float otherY=otherParticles[i].yPos;
          line(xPos,yPos, otherX,otherY);
        }
      }
    }
    popStyle();
  }

  void searchWord(String term) {
    if(alive) {
      for(int i=0;i<signifWords.length;i++) {
        try {
          if(signifWords[i].equals(term)) glow=true;
          // println("found match");
        }
        catch(Exception e) {

          // println("dodgy string here");
        }
      }
    }
  }
  int displayContext(String term, int textPos) {
    textLength=0;
    ArrayList theContext=new ArrayList();
    if(glow) {

      pushStyle();
      fill(255,0/transparency);
      //  println(getContext(term));
      theContext=getContext(term);
      for(int i=0;i<theContext.size();i++) {
        text((String)theContext.get(i),textLength-(2*glowTimer),50+textPos);
        textLength+=textWidth((String)theContext.get(i));
      }
      popStyle();
    }
    return theContext.size();
  }


  ArrayList getContext(String term) {
    //  println("checking context");
    ArrayList theContext=new ArrayList();
    String allWords="";
    for(int i=0;i<lines.length;i++) {
      allWords+=lines[i];
    }
    String[] exploded = splitTokens(allWords,".");

    for(int i=0;i<exploded.length;i++) {

      //   if(term.equals(exploded[i])) {
      String[] explSentence=splitTokens(exploded[i], delimiters);
      for(int j=0;j<explSentence.length;j++) {
        explSentence[j]=explSentence[j].toLowerCase();
        if(explSentence[j].equals(term.toLowerCase()) ){
          theContext.add(exploded[i]);
        }

      }
    }

  //  println("theContex "+theContext+ " size "+theContext.size());
    for(int i=0;i<theContext.size();i++){
    //  println("theContex "+i+" "+theContext);
      
    }
    return theContext;
  }

  void kill(Particle[] otherParticles) {

    int tol=20;
    if(mouseX>pi.x-tol&&mouseX<pi.x+tol&& mouseY>pi.y-tol&&mouseY<pi.y+tol&&mousePressed) {

      /*   try
       {
       //runtime is the java interface to other process
       Runtime rt = Runtime.getRuntime();
       
       //execute a terminal command - the terminal command calls a jar which can rip pdfs - this needs to be changed to use the actual java file
       
       // Process pr = rt.exec("java -cp /Users/tom/Documents/Processing/loadPDF/data/pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText /Users/tom/Documents/Processing/loadPDF/data/"+filenames[i]+" /Users/tom/Documents/Processing/loadPDF/data/txtPapers/"+filenames[i]+".txt");
       String command="open -a Preview "+dataPath("")+"pdfs/"+docName+".pdf";
       Process pr = rt.exec(command);
       //wait till process is finished before you do anything else
       int exitVal = pr.waitFor();
       
       println("Exited with error code "+exitVal);
       }
       catch (Exception e)
       {
       println(e.toString());
       e.printStackTrace();
       }
       println(docName);*/
      // pi.x=mouseX;
      // pi.y=mouseY;
      for(int i=0;i<otherParticles.length;i++) {
        VerletSpring2D  mySpring =physics[SYS_SELECTOR].getSpring(pi,otherParticles[i].pi);
        physics[SYS_SELECTOR].removeSpring(mySpring);
        physics[SYS_SELECTOR].removeParticle(pi);
      }
    }

    //open -a Preview foo.jpg
  }
  void interact() {//Particle[] otherParticles, int x, int y) {
    //  pi.x=mouseX;
    // pi.y=mouseY;
    /* int tol=50;
     if(x>pi.x-tol&&x<pi.x+tol&& y>pi.y-tol&&y<pi.y+tol&&mousePressed) {
     pi.x=x;
     pi.y=y;
     }*/
  }
  //TODO stop this migrating off the screen!
  void shuffle() {
    float switcher=random(0,1);
    //println(switcher);
    if(switcher>=.5) {
      pi.x+=random(0,width/2);
      pi.y+=random(0,height/2);
    }
    else {
      pi.x-=random(0,width/2);
      pi.y-=random(0,height/2);
    }
  }
  void openDoc() {
    try
    {
      //runtime is the java interface to other process
      Runtime rt = Runtime.getRuntime();

      //execute a terminal command - the terminal command calls a jar which can rip pdfs - this needs to be changed to use the actual java file

        // Process pr = rt.exec("java -cp /Users/tom/Documents/Processing/loadPDF/data/pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText /Users/tom/Documents/Processing/loadPDF/data/"+filenames[i]+" /Users/tom/Documents/Processing/loadPDF/data/txtPapers/"+filenames[i]+".txt");
      //String command="open -a Preview "+dataPath("")+"pdfs/"+docName+".pdf";

      String command="open -a Preview "+dataPath("")+"pdfs/"+docName+".pdf";
      Process pr = rt.exec(command);
      //wait till process is finished before you do anything else
      int exitVal = pr.waitFor();

      println("Exited with error code "+exitVal);

      if(exitVal!=0) {
        messageSwitch=12;
        timer=0;
      }
      else {
        messageSwitch=13;
      }
    }
    catch (Exception e)
    {
      println(e.toString());
      e.printStackTrace();
    }
    println(docName);
  }
}

