import controlP5.*;   
ControlP5 cp5;   // controlP5 object
Textarea title_area, summary_area, tags_area;

int pageH; //hight of the page and startY for each article 
boolean showAll = false; //toggle articles/ALL
String file = "output.csv"; //file to load
//String file = "output190.csv"; //smaller one to test <--
int rows; //when load the file
int cols = 5;
String del = "|>>"; // delimiter for oneLine

ArrayList<String> titles = new ArrayList();
ArrayList<String> urls = new ArrayList();
ArrayList<String> summaries = new ArrayList();
ArrayList<String> images = new ArrayList();
ArrayList<String> words = new ArrayList();
ArrayList<String> list = new ArrayList();
ArrayList<Article> allArticles = new ArrayList();
ArrayList<Article> articles = new ArrayList();
int numOfArticles;
//////////////scroll
float wheel = 0 ;
int constrainH;
float zoom = 1;
Header header = new Header();

void setup() {
  size(960, 720);
  if (frame != null) {
    frame.setResizable(true);
  }
  cp5 = new ControlP5(this);

  //mind that table, parsing ..
  String [] alllines = loadStrings(file);
  String [] lines = new String [alllines.length-1];        //lose header
  for (int i = 0; i < lines.length; i++) {
    lines[i] = alllines[i+1];
  }
  // println("\nthere are " + lines.length + " lines"); //that aint rows
  // println(lines); 
  String [] trimedLines = trim(lines);
  //println(trimedLines); ok
  //make one line and lose spaces
  String oneLine = join(trimedLines, " ");
  //println(oneLine);
  String [] prefields = split(oneLine, del);
  //println(fields); //still have garbage
  String [] fields = trim(prefields); //trim trim
  //remove garbage, put good strings in a list
  for (String field : fields) {
    //if (field.length() < 4) println(" \n garbage : \n" + field);
    if (field.length() >3) {
      //println(field); //ok
      list.add(field);
    }
  }

  for (int i=0; i<list.size(); i++) {
    //  println(list.get(i));    //ok
    //get only titles, 1st ones
    if (i% 5 == 0) titles.add(list.get(i));
    if (i% 5 == 1) urls.add(list.get(i));
    if (i% 5 == 2) summaries.add(list.get(i));
    if (i% 5 == 3) images.add(list.get(i));
    if (i% 5 == 4) words.add(list.get(i));
  }
  println(titles + "\n\n" + urls + "\n\n" + summaries + "\n\n" + images + "\n\n" + words); //ok

  //make only articles w/ matched words
  makeArticles();
  // makeAll();
  //
}  // setup end

void draw() {
  background(254);
  translate (0, wheel);   // scrolling
  scale(zoom);

  //updateAll();
  updateArticles();

  //header   
  header.display();    //cp5 buttons are always on top agrr
}//end draw

void controlEvent(ControlEvent theEvent) {
  if (theEvent.isController()) { 

    if (theEvent.controller().name()=="bang1") {
      print("control event from : "+theEvent.controller().name());

      ellipse(50, 50, 50, 50);
      link("https://www.google.rs/?gws_rd=ssl");
    }
    if (theEvent.controller().name()=="bang1") {
      link(allArticles.get(1).url);
    }
  }
}// controlEvent


/****************scrolling*************/
void mouseWheel(MouseEvent event) { 
  float e = event.getAmount();
  wheel += e *10 ;
  wheel = constrain(int(wheel), -constrainH, 0);
}

void keyPressed() {
  if (key == '+') zoom += 0.05;
  if (key == '-') zoom -= 0.05;
  //  if (keyCode == SHIFT) wheel *=1.2;
  if (key == ' ') {
    wheel =0; 
    zoom = 1;
  }
}

//make Allarticles
void makeAll() {
  pageH = 0; // 
  for (int w=0; w<titles.size() ; w++) {
    String areaTN = "areaTN" + w;
    String areaSN = "areaSN" + w;
    allArticles.add(new Article(areaTN, areaSN, w, pageH, titles.get(w), urls.get(w), images.get(w), summaries.get(w), words.get(w)));
    allArticles.get(w).setAll();
    pageH += articles.get(w).getHeight();
  }
  numOfArticles = allArticles.size(); //number of ALL articles
  constrainH = pageH + header.h -height; //page height
} //end make Allarticles


void makeArticles() {     //make articles w/ mathced words
  pageH = 0; // 
  int q = 0; //counter for non empty ones. pass for position
  for (int w=0; w<words.size() ; w++) {
    if (tag.hasKeyWords(words.get(w)) == true) {
      String areaTN = "areaTN" + w;
      String areaSN = "areaSN" + w;
      articles.add(new Article(areaTN, areaSN, q, pageH, titles.get(w), urls.get(w), images.get(w), summaries.get(w), words.get(w)));
      articles.get(q).setAll();
      pageH += articles.get(q).getHeight();
      q++;
    }
    println(" page is now: " + pageH + " px long");
  }
  numOfArticles = articles.size(); //number of articles with mathces
  constrainH = pageH + 2*header.h -height; //page height
}//end make articles


void updateArticles() {
  for (int i=0; i<articles.size(); i++) {
    articles.get(i).updateAll();   //update
  }
}//end updateArt

void updateAll() {
  for (int i=0; i<allArticles.size(); i++) {
    allArticles.get(i).updateAll();   //update
  }
}//end updateArt

