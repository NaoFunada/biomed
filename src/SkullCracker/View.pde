//Organ Data Class
public class OrganData
{
  String urlprefix = "http://alaromana.com/images/", organName, filename, id, tagfile;
  ArrayList<String> tags;
  ArrayList<String> imgList;
  JSONArray mesh;
  APRadioButton radio;
  public OrganData(String id_, String organ_name, JSONArray omesh, JSONArray files)
  {
    imgList = new ArrayList<String>();
    id = id_;
    organName = organ_name;
//    filenames = f_names;
//    filename = f_names.get(0);
//    filename = f_name;
    mesh = omesh;
    radio = new APRadioButton(organName);
    tagfile = "p"+id+organName + ".txt";
    loadTags();
    for(int i = 0; i<files.size();i++)
    {
      String curr = files.getString(i);
      imgList.add(curr);
    }
  } 
 
 //get the radio button for a given organ
 public APRadioButton getOrganButton()
 {
    return radio; 
 }
 
 public void downloadAllImages()
 {
   try
   {
      for (int i = 0; i< imgList.size();i++)
      {
         String imageloc = urlprefix+"patients/"+id+"/"+organName+"/"+imgList.get(i);
         PImage currimg = loadImage(imageloc);
         String objectfile =  "p"+id+organName +imgList.get(i);
         print("Saving file: "+ objectfile);
         currimg.save(objectfile);
       }     
   }
   catch (Exception e) 
   {
      print("error dlin");
   }
 }
 
 //check if the given organ is checked
 public boolean isChecked()
 {
    if(radio.isChecked())
     {
        return true;
     }
    return false; 
 }
 
 //get organ's file
 public String getImagefile(int index)
 {
    if (index>=imgList.size())
      index = imgList.size()-1;
    else if (index < 0)
      index = 0;
    String objectfile = "p"+id+organName +imgList.get(index);
    return objectfile; 
 }
 
 //get organ's mesh
 public JSONArray getMesh()
 {
    return mesh; 
 }
 
 //load organ's tags from file
 public void loadTags()
 {
    File sketchDir = getFilesDir();
    tags = new ArrayList<String>();
  
    // read strings from file into tags
    try 
    {
      print(tagfile);
      FileReader input = new FileReader(sketchDir.getAbsolutePath() + "/" + tagfile);
      BufferedReader bInput = new BufferedReader(input);
      String ns = bInput.readLine();
      while (ns != null) 
      {
        tags.add(ns);
        ns = bInput.readLine();
      }
    }
    catch (Exception e) 
    {
    }
 }
 
 //save organs tags to file
  public void saveTags()
  {
    
    File sketchDir = getFilesDir();
    java.io.File outFile;
    try 
    {
      outFile = new java.io.File(sketchDir.getAbsolutePath() + "/"+tagfile);
      if (!outFile.exists())
        outFile.createNewFile();
      FileWriter outWriter = new FileWriter(sketchDir.getAbsolutePath() + "/"+tagfile);
      for (int i=0; i<tags.size (); i++) 
      {
        outWriter.write(tags.get(i) + "\n");
      }
      outWriter.flush();
      
    }
    catch (Exception e) 
    {
    }
  }
 
  
  //get tag string
  public String getTagString()
  {
    String tagString = "";
    for (int i = 0; i< tags.size(); i++)
    {
       tagString = tagString + tags.get(i) + ", "; 
    } 
    if (tagString != "")
      tagString = tagString.substring(0, tagString.length()-2);
    return tagString;
  }
  
  public void addTag(String tag)
  {
     tags.add(tag); 
  }
}

//data for each patient
public class PatientData
{
  private String id, name;
  PImage img;
  APButton button;
  APRadioGroup radioGroup;
  ArrayList<OrganData> organs;
  
   public PatientData(String id_, String name_, ArrayList<OrganData> organList)
  {
     radioGroup = new APRadioGroup(width-400, 200);
     radioGroup.setOrientation(APRadioGroup.VERTICAL);
     id = id_;
     name = name_;
     organs = organList;
     for (int i = 0; i < organList.size(); i++)
     { 
       radioGroup.addRadioButton(organList.get(i).getOrganButton());
     }
     organList.get(0).getOrganButton().setChecked(true);
  }
  
  //place the button representing a patient
  public void placePatientButton(int offset)
  {
      String buttonlabel = id+ ": "+name;
      button = new APButton(200, 300+(offset*200), width-400, 200, buttonlabel); 
   }
   
   //get the radio buttons for a patient
   public APRadioGroup getOrganButtons()
   {
      return radioGroup; 
   }
   
   //return the buttom for the patient
   public APButton getPatientButton()
   {
      return button; 
   }
   
   //download each organs image
   public void downloadImgs()
   {
      for(int i = 0; i< organs.size();i++)
      {
         organs.get(i).downloadAllImages(); 
      }
   }
   
   //get patients id
   public String getId()
   {
      return id; 
   }
   
   //get patient name
   public String getpName()
   {
      return name; 
   }
   
   //get the organs index
   public int getActiveOrgan()
   {
      for(int i = 0; i<organs.size(); i++)
      {
          if (organs.get(i).isChecked())
          {
            return i;
          }
      }
      return 0;
   }
   
   //get the organs mesh
   public JSONArray getOrganMesh(int index)
   {
     if (index<organs.size())
     {
         return organs.get(index).getMesh();
     }
     else
     {
       print ("outof bounds!");
       return null;
     }
   }
   
   //return the active organs image
   public PImage getActiveOrganImage(int index)
   {
      for(int i = 0; i<organs.size(); i++)
      {
          if (organs.get(i).isChecked())
          {
            
            return loadImage(organs.get(i).getImagefile(index));
          }
      }
      return null;
   }
   
   public OrganData getOrganData(int index)
   {
      return organs.get(index);
   }
}
