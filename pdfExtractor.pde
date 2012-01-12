class PdfExtractor {

  // Constructor
  PdfExtractor() {
  }
  //counts the numnber of pdfs in the data folder
  int countPDFs() {
    int count=0;
    File dir = new File(dataPath(""));
    String[] children = dir.list();
    if (children == null) {
      println("not there");
      // Either dir does not exist or is not a directory
    } 
    else {
      //for each file name
      for (int i=0; i<children.length; i++) {
        //break it by any fullstops
        String [] pdfName=splitTokens(children[i],".");
        //check that array is longer than 1 place to avoid null
        if(pdfName.length>1) {
          //check that the last index reads "pdf"
          if( pdfName[pdfName.length-1].equals("pdf")) {
            //if it does we have a pdf so increment
            count++;
          }
        }
      }
    }
    return count;
  }

  //finds all files in data folder with a .pdf extension
  String[] pdfNames (int pdfNum) {
    //an array of strings to hold pdf names
    String pdfNames[]=new String[pdfNum];
    //an incrementer for the array
    int count=0;
    File dir = new File(dataPath(""));
    String[] children = dir.list();

    if (children == null) {
      println("not there");
      // Either dir does not exist or is not a directory
    } 
    else {
      //for each file name
      for (int i=0; i<children.length; i++) {
        //break it by any fullstops
        String [] pdfName=splitTokens(children[i],".");
        //check that array is longer than 1 place to avoid null
        if(pdfName.length>1) {
          //check that the last index reads "pdf"
          if( pdfName[pdfName.length-1].equals("pdf")) {
            //if it does we have a pdf so add to string array
            pdfNames[count]=children[i];
            // println( pdfNames[count]);
            count++;
          }
        }
      }
    }
    return pdfNames;
  }
  //////////////////////////////////////////////////
    void ripPDFs(String filenames[]) { 

    //for each of the filenames given
    for(int i=0;i<filenames.length;i++) {


      try
      {
        //runtime is the java interface to other process
        Runtime rt = Runtime.getRuntime();

        //execute a terminal command - the terminal command calls a jar which can rip pdfs - this needs to be changed to use the actual java file

          // Process pr = rt.exec("java -cp /Users/tom/Documents/Processing/loadPDF/data/pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText /Users/tom/Documents/Processing/loadPDF/data/"+filenames[i]+" /Users/tom/Documents/Processing/loadPDF/data/txtPapers/"+filenames[i]+".txt");
        Process pr = rt.exec("java -cp "+dataPath("")+"pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText "+dataPath("")+filenames[i]+" " +dataPath("")+"/txtPapers/"+filenames[i]+".txt");
        //wait till process is finished before you do anything else
        int exitVal = pr.waitFor();

        println("Exited with error code "+exitVal);
        
       
      }
      catch (Exception e)
      {
        println(e.toString());
        e.printStackTrace();
      }
    }
  }

  void ripOnePDF(String filename) { 

    //for each of the filenames given
   // for(int i=0;i<filenames.length;i++) {


      try
      {
        //runtime is the java interface to other process
        Runtime rt = Runtime.getRuntime();

        //execute a terminal command - the terminal command calls a jar which can rip pdfs - this needs to be changed to use the actual java file

          // Process pr = rt.exec("java -cp /Users/tom/Documents/Processing/loadPDF/data/pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText /Users/tom/Documents/Processing/loadPDF/data/"+filenames[i]+" /Users/tom/Documents/Processing/loadPDF/data/txtPapers/"+filenames[i]+".txt");
        Process pr = rt.exec("java -cp "+dataPath("")+"pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText "+dataPath("")+filename+" " +dataPath("")+"/txtPapers/"+filename+".txt");
        //wait till process is finished before you do anything else
        int exitVal = pr.waitFor();

        println("Exited with error code "+exitVal);
      }
      catch (Exception e)
      {
        println(e.toString());
        e.printStackTrace();
      }
   // }
  }
//////////////////////////////////////////////////
  void ripPDFfromDrop(String dropPath) { 
 // String myPDFasText="";
     try
      {
        //runtime is the java interface to other process
        Runtime rt = Runtime.getRuntime();

        //execute a terminal command - the terminal command calls a jar which can rip pdfs - this needs to be changed to use the actual java file
        println(dropPath);
        
       // String command= "java -cp "+dataPath("")+"pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText "+dropPath+" " +dataPath("")+"txtPapers/MYFILE.txt";
        String[] droppedFile=splitTokens(dropPath, "/");
        String[] justName=splitTokens(droppedFile[droppedFile.length-1],"."); 
        
        String command="java -cp "+dataPath("")+"pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText "+dropPath+" "+dataPath("")+"dropped/"+justName[0]+".txt";
        println(command);
          // Process pr = rt.exec("java -cp /Users/tom/Documents/Processing/loadPDF/data/pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText /Users/tom/Documents/Processing/loadPDF/data/"+filenames[i]+" /Users/tom/Documents/Processing/loadPDF/data/txtPapers/"+filenames[i]+".txt");
     //   Process pr = rt.exec("java -cp "+dataPath("")+"pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText "+dataPath("")+filename+" " +dataPath("")+"/txtPapers/"+filename+".txt");
     Process pr = rt.exec(command);
        //wait till process is finished before you do anything else
        int exitVal = pr.waitFor();

        println("Exited with error code "+exitVal);
        if(exitVal!=0){
          dropped=true;
          messageSwitch=11;
          timer=0;
        }
        else{
         moveFile(dropPath) ;
        }
      
      }
      catch (Exception e)
      {
        println(e.toString());
        e.printStackTrace();
      }
  //  return myPDFasText;
  }
  
  void moveFile(String drop){
   try
      {
        //runtime is the java interface to other process
        Runtime rt = Runtime.getRuntime();


        String command="cp "+drop+" "+dataPath("")+"pdfs/";
        println(command);
          // Process pr = rt.exec("java -cp /Users/tom/Documents/Processing/loadPDF/data/pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText /Users/tom/Documents/Processing/loadPDF/data/"+filenames[i]+" /Users/tom/Documents/Processing/loadPDF/data/txtPapers/"+filenames[i]+".txt");
     //   Process pr = rt.exec("java -cp "+dataPath("")+"pdfbox-app-1.4.0.jar org.apache.pdfbox.ExtractText "+dataPath("")+filename+" " +dataPath("")+"/txtPapers/"+filename+".txt");
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
    
  }
}

