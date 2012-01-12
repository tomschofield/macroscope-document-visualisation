////a class to implement term frequency inverse document frequency.
//class will also return an attraction score over complete documents
//cc. non commercial share alike Tom Schofield 2011
//requires ritaWordnet

//don't forget to include word net pos tagging.
//google docs/wiki
//larger questions of approach eg tfidf / co-occurance /  
//foucault discursive formations
//linking institutional y
//our corpus
//technological determinism in these algorithms
//nature of interactivity for the searches? 
//visibly time based system - can we see the process. 
//short term goals - what can we achieve 
//research practice - we need to weight a particular word / constraints within algorithm 
//DISCURSIVE FORMATION ENGINE - can we make these things explicit
//api for google scholar? 


//To DO NEXT
//stemming

class Tfidf {
  String fileName;
  String delimiters = " ,.?!;\\\":[]()-";
  int wordCount;
  HashMap hm;
  HashMap newMap;
  int NUM_OF_DOCS;
  //comp num is the number of significant words which we compare with other docs
  int COMP_NUM;
  //the final map that contains the tfidf results in a key word and value structure
  HashMap tfidfMap;
  String [] words;
  String[] lines;
  String[] signifWords;
  float[] attractionForces;
  int thisIndex;


  Tfidf(String file, int comp) {
    fileName=file;
    println("file "+file);
    COMP_NUM=comp;
    signifWords=new String[COMP_NUM];
  }
  void setup() {

    // hm=new HashMap(1);
  }
  void loadFile() {
    lines=loadStrings(fileName);
    // println("lines "+lines.length);
    //println(lines.length);
  }

  void stripFormatting() {
    String[] strippedExploded;
    String stripped="";
    //for each line of the document
    for(int i=0;i<lines.length;i++) {
      // println("oneLine[j] "+lines[i]);
      //split it by formatting
      lines[i]=lines[i].replaceAll("[^A-Za-z]", " ");
      String[] oneLine=splitTokens(lines[i],delimiters);

      for(int j=0;j<oneLine.length;j++) {
        // println("oneLine[j] "+oneLine[j]);
        //eliminate excess white space and make lowercase then put back in a line seperated only by spaces
        String currentString =trim(oneLine[j].toLowerCase());
        try {
          String[] pos= wordnet.getPos(currentString);
          for(int k=0;k<pos.length;k++) {
            if(pos[k].equals("a")||pos[k].equals("n")||pos[k].equals("r")||pos[k].equals("v")) {
              //  println("Current String "+currentString+" "+pos[k]);
              stripped+=" "+currentString;
            }
          }
        }
        catch(Exception e) {
        }
      }
    }

    words=splitTokens(stripped," ");
    wordCount=words.length;
  }

  void makeStringsUnique() {
    //this function gives me a list of unique words so i can compare them to the original doc for counting
    hm=new HashMap();

    for(int i=0;i<words.length;i++) {
      //for each word check if it already exists in the map
      boolean inTable=false;
      try {

        if( hm.get(words[i]) ==null) {//||hm.get(words[i])==0) {
          inTable=false;
        }
        else {
          inTable=true;
        }
      }
      catch(NullPointerException e) {
      }

      //if its not in the table
      if(!inTable) {

        ArrayList values;
        values = new ArrayList(); 
        //  values.add(0);
        hm.put(words[i], null);
        //move on to the next row
      }
    }

 
  }

  void countWordFreq() {
    //declare a temporary map

    newMap=new HashMap();
    Iterator i = hm.entrySet().iterator();  // Get an iterator

      while (i.hasNext()) {
      Map.Entry me = (Map.Entry)i.next();
      //UNCOMMENT TO DUMP KEYS AND VALUES

      //get each word
      String word =(String)me.getKey();
      // println(word);
      //  print(me.getKey() + " co-occurres with ");
      // println(me.getValue());

      //a count for this word
      int wordFreq=0;
      //for all of the words in the original document
      for(int j=0;j<words.length;j++) {
        //if they match
        if(word.equals(words[j])) {
          //bump up the count
          wordFreq++;
          //  println(word+ " "+wordFreq);
        }
      }
      //when you have gone through all of them store the word and its associated count in the new map

      //TODO devide by length of document
      newMap.put(word,wordFreq);
    }
    // println(newMap.size()+" "+hm.size());
    Iterator k = newMap.entrySet().iterator();  // Get an iterator

      while (k.hasNext()) {
      Map.Entry me = (Map.Entry)k.next();
      //UNCOMMENT TO DUMP KEYS AND VALUES
      // print(me.getKey() + " occurs this many times: ");
      // println(me.getValue());
    }
  }
  //pass in a 2 d array of texts (the corpus) and their individual words.
  void calculateTfidf(String[][] otherTexts) {
    tfidfMap=new HashMap();
    Iterator i = newMap.entrySet().iterator();  // Get an iterator
    while (i.hasNext()) {
      Map.Entry me = (Map.Entry)i.next();
      //UNCOMMENT TO DUMP KEYS AND VALUES
      //get each word
      String word =(String)me.getKey();
      //for each of the other texts
      int occurances=0;
      for(int j=0;j<otherTexts.length;j++) {
        //for each word in the other text
        boolean inText=false;
        //check each of those words
        for(int k=0;k<otherTexts[j].length;k++) {
          //if you find the word raise a flag
          if(word.equals(otherTexts[j][k]) ) {
            inText=true;
          }
        }
        //if by the end you have raised a flag increment the count
        if(inText) occurances++;
      }
      //calculate tfidf score
      //term frequency is the number of occurances devided by lenght of document
      try {
        // println(me.getValue());


        // println(me.getValue().getClass().toString() );
        Integer in=(Integer)me.getValue();
        int my=(int)in;
        //  println(tempString);
        // float tf=int(tempString)/words.length;
        float tf=my;
        //inverse document frequency is log of number of docs it occurs in devided by total number of docs
        float idf= (float)Math.log10(otherTexts.length/(occurances+0.00001));
        float tfidfValue=tf*idf;
        tfidfMap.put(word, tfidfValue);
      }
      catch(NullPointerException e) {
      }
    }

    Iterator j = tfidfMap.entrySet().iterator();  // Get an iterator
    while (j.hasNext()) {
      Map.Entry me = (Map.Entry)j.next();
      //  println(me.getValue()+ " " +me.getKey());
    }
  }

  void calculateTfidfFromScratch(String[][] otherTexts) {
    tfidfMap=new HashMap();
    Iterator i = newMap.entrySet().iterator();  // Get an iterator
    while (i.hasNext()) {
      Map.Entry me = (Map.Entry)i.next();
      //UNCOMMENT TO DUMP KEYS AND VALUES
      //get each word
      String word =(String)me.getKey();
      //for each of the other texts
      int occurances=0;
      for(int j=0;j<otherTexts.length;j++) {
        //for each word in the other text
        boolean inText=false;
        //check each of those words
        for(int k=0;k<otherTexts[j].length;k++) {
          //if you find the word raise a flag
          if(word.equals(otherTexts[j][k]) ) {
            inText=true;
          }
        }
        //if by the end you have raised a flag increment the count
        if(inText) occurances++;
      }
      //calculate tfidf score
      //term frequency is the number of occurances devided by lenght of document
      try {
        // println(me.getValue());


        // println(me.getValue().getClass().toString() );
        Integer in=(Integer)me.getValue();
        int my=(int)in;
        //  println(tempString);
        // float tf=int(tempString)/words.length;
        float tf=my;
        //inverse document frequency is log of number of docs it occurs in devided by total number of docs
        float idf;
        try {
          idf= (float)Math.log10(otherTexts.length/occurances);
        }
        catch(Exception e) {
          idf= (float)Math.log10(otherTexts.length/(occurances+.0001));
        }
        float tfidfValue=tf*idf;
        tfidfMap.put(word, tfidfValue);
      }
      catch(NullPointerException e) {
      }
    }

    Iterator j = tfidfMap.entrySet().iterator();  // Get an iterator
    while (j.hasNext()) {
      Map.Entry me = (Map.Entry)j.next();
      //  println(me.getValue()+ " " +me.getKey());
    }
  }

  void orderByTfidf() {
    //a function to order the list of words by descending tfidf value
    //we can use this to establish document similarity later

    //hashmap sorting by tim ringwood http://www.theserverside.com/discussions/thread.tss?thread_id=29569
    boolean ascending=false;
    List mapKeys = new ArrayList(tfidfMap.keySet());
    List mapValues = new ArrayList(tfidfMap.values());
    Collections.sort(mapValues);	
    Collections.sort(mapKeys);	
    LinkedHashMap someMap = new LinkedHashMap();
    if (!ascending)
      Collections.reverse(mapValues);


    Iterator valueIt = mapValues.iterator();
    while (valueIt.hasNext()) {
      Object val = valueIt.next();
      Iterator keyIt = mapKeys.iterator();
      while (keyIt.hasNext()) {
        Object key = keyIt.next();
        if (tfidfMap.get(key).toString().equals(val.toString())) {
          tfidfMap.remove(key);
          mapKeys.remove(key);
          someMap.put(key, val);
          break;
        }
      }
    }

    Iterator j = someMap.entrySet().iterator();  // Get an iterator
    int k=0;
    while (j.hasNext()) {
      Map.Entry me = (Map.Entry)j.next();
      // println(me.getValue()+ " " +me.getKey());
      if(k<COMP_NUM) {
        signifWords[k]= (String)me.getKey();
        // println(signifWords[k]+" "+k);
        k++;
      }
    }
  }

  void compareDocs(String[][] otherSigWords) {
    NUM_OF_DOCS=otherSigWords.length;
    attractionForces=new float[NUM_OF_DOCS];
    for(int i=0;i<NUM_OF_DOCS;i++) {
      if(i!=thisIndex) {
        for(int j=0;j<otherSigWords[i].length;j++) {
          String wordToCompare=otherSigWords[i][j];
          //  println("current wordToCompare "+wordToCompare);
          for(int k=0;k<COMP_NUM;k++) {
            // println("signifWords[k] "+signifWords[k]);
            //compare the sig words from this doc with those of the other doc
            //and increment attraction forces at this index if theres a match
            try {
              if (wordToCompare.equals( signifWords[k])) {
                attractionForces[i]++;
                //  println("wordToCompare "+wordToCompare+ " "+signifWords[k]+" "+attractionForces[i]+" i "+i);
              }
            }
            catch (Exception e) {
            }
          }
        }
      }
    }
    for(int i=0;i<NUM_OF_DOCS;i++) {
      //    println("particle at position "+ thisIndex+ " is attracted by a factor of "+attractionForces[i]+ " to the particle at "+i);
    }
  }
}

