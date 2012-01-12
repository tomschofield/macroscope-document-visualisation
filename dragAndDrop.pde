///////////JAVA STUFF TO HAND DRAG AND DROP = THE MEAT OF THIS IS IN LOADFILE() AT THE BOTTOM

DropTarget dt = new DropTarget(this, new DropTargetListener() {
  public void dragEnter(DropTargetDragEvent event) {
    // debug messages for diagnostics
    //System.out.println("dragEnter " + event);
    event.acceptDrag(DnDConstants.ACTION_COPY);
  }

  public void dragExit(DropTargetEvent event) {
    //System.out.println("dragExit " + event);
  }

  public void dragOver(DropTargetDragEvent event) {
    //System.out.println("dragOver " + event);
    event.acceptDrag(DnDConstants.ACTION_COPY);
  }

  public void dropActionChanged(DropTargetDragEvent event) {
    //System.out.println("dropActionChanged " + event);
  }

  public void drop(DropTargetDropEvent event) {
    //System.out.println("drop " + event);
    event.acceptDrop(DnDConstants.ACTION_COPY);

    Transferable transferable = event.getTransferable();
    DataFlavor flavors[] = transferable.getTransferDataFlavors();
    int successful = 0;

    for (int i = 0; i < flavors.length; i++) {
      try {
        Object stuff = transferable.getTransferData(flavors[i]);
        if (!(stuff instanceof java.util.List)) continue;
        java.util.List list = (java.util.List) stuff;

        for (int j = 0; j < list.size(); j++) {
          Object item = list.get(j);
          if (item instanceof File) {
            File file = (File) item;


            String filename = file.getPath();
            loadFile(filename);
          }
        }
      } 
      catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
}
);
//currently copies file contents to new file in data folder
void loadFile(String fileName) {
  dropped=false;
  pdfExtractor.ripPDFfromDrop(fileName);
  //if pdf fails to rip global variable dropped will be set back to true
  println("dropped "+dropped);
  if(!dropped){
  for(int i=0;i<docMap.length;i++) {
       docMap[i].analyseOne(fileName);
       docMap[i].addAttractions();
       docMap[i].addParticle();
    }
     messageSwitch=3;
        timer=0; 
  }
 dropped=true;
}
