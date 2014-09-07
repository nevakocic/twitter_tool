Tags tag = new Tags();
int tags_x;
color blue = #00969D;
color yellow = #FFCF01;
color mag = #DB156F;
int margine = 35; 

class Article {
  int articleH;
  int deltax, starty; //coef. for translation
  int h1 = 17; //font size
  int p = 13;  //paragh font size
  int s = 11; //link font size
  int white = 12; //padding
  int imagex, imagey, summary_x, summary_y, tags_y;
  int imageH, imageW, summaryW; 
  int maxpix = 200;    //max width or height of an image
  String title, url, webImage, summary, counter;
  String bang, areaTitle, areaSummary;
  PImage image;
  int titleH = 50; //title height textARea
  int titleW = 4*width/6;
  int tagsW = width/6 - 2*margine;
  int articleW;
  int x;
  int y;
  int leftBorder = x+ margine;

  ArrayList<String> pairs = new ArrayList();
  /////////////
  boolean rollover = false;
  boolean click = false;
  boolean preClick = false; 


  Article(String _areaTitle, String _areaSummary, 
  int _deltax, int _starty, String _title, String _url, String _webImage, String _summary, String _counter) {
    //Article(String _title, String _url, String _image, String _summary, String _tags ) {
    deltax = _deltax;  //not using now
    starty = _starty;
    title = _title;
    url = _url;
    webImage = _webImage;  
    summary = _summary;
    counter = _counter;
    areaTitle = _areaTitle;
    areaSummary = _areaSummary;
  }

  int getHeight() {
    return articleH = margine + titleH + imageH + margine;
  }

  void setAll() {
    checkImSize();  

    //position 
    articleH = margine + titleH + imageH + margine;
    articleW = margine + titleW + margine;
    y = starty + header.h;
    x = 0;


    /************** title *****************/

    title_area = cp5.addTextarea(areaTitle)
      .setPosition(leftBorder, y+margine+ wheel)
        .setSize(titleH, titleW)
          .setHeight(titleH)
            .setWidth(titleW)
              .setFont(createFont("sansserif bold", h1))
                .setLineHeight(h1)
                  //  .setColor(color(#FF0ABA))
                  .setColor(color(#552E22))
                    .setColorBackground(color(255, 100))
                      //  .setColorForeground(color(55, 100))
                      .setColorActive(255)
                        .hideScrollbar()
                          //      .isMoveable()
                          //       .setUpdate(true)
                          ;
    title_area.setText(title);
    title_area.isMoveable();

    /***************** image ******************/
    showImage();

    /************** summary *****************/
    summary_x = imagex + imageW + white;
    summary_y = imagey;
    summaryW = titleW - imageW - white;
//    if (imageH < 400) {
//      summaryH = 400;
//    } else {
//      summaryH = imageH;
//    }
    summary_area = cp5.addTextarea(areaSummary)
      .setPosition(summary_x, summary_y)
        //  .setSize(imageH, summaryW)
        .setHeight(imageH)
          .setWidth(summaryW)
            .setFont(createFont("arial", p))
              .setLineHeight(p+4)
                .setColor(color(0))
                  ;
    summary_area.setText("\n " + summary);

    /***************** tags ***********/
    getTags();
    println(" num of matches in a counter: " + tag.numOfMatches + " --> " + tag.allMatches);

    tags_x = leftBorder + titleW + 2*margine;
    tags_y = y+margine;
    tagsW = titleW - imageW - white;
    tags_area = cp5.addTextarea(counter+deltax)
      .setPosition(tags_x, tags_y)
        //  .setSize(imageH, summaryW)
        .setHeight(imageH)
          .setWidth(tagsW)
            .setFont(createFont("arial", p))
              .setLineHeight(p+4)
                .setColor(color(0))
   
                  ;
    tags_area.setText(".\n.\n.\n\n"
      + tag.pairsColumn

      ) ;
  } //end setAll()


  void updateAll() {

    /***************** title ************************/
    pushStyle();
    //click in between x, x + width, y, Y+ height  -->watch on wheel when questioning mouseY
    visitLink(leftBorder, titleW, y + margine, titleH, blue, yellow);

    rect(leftBorder, y+margine, titleW, titleH);
    popStyle();


    /***************** image ******************/
    showImage();

    /********* url ************/
    float urlW = textWidth(trim(url));
    visitLink(leftBorder, int(urlW), y + articleH -13 - s, 2*s, mag, blue);
    // rect(leftBorder, y + articleH -13 - s, urlW, 2*s); //tunning
    showUrl(); 
    //
  }// end updateAll()

  void showUrl() {
    // pushStyle();
    textAlign(LEFT);
    //  fill(40);
    textSize(s);
    text(url, leftBorder, y + articleH -10);        //url
    //  popStyle();
  }
  void showImage() {
    imagex = leftBorder;
    imagey = y + margine + titleH;
    // println("image x : " + imagex + "  image y: " + imagey);  
    image(image, imagex, imagey, imageW, imageH);
  }

  void checkImSize() {
    // try loading and check if the image is to big 
    try {
      image = loadImage(webImage);
      rrsize();
    } 
    catch (Exception e) {
      println("can't load image. \nerror: " + e);
      println(" .. loading gas ... ");
      image = loadImage("data/gas.jpg");
      rrsize();
    }
  }


  void rrsize() {    //lets keep all images 200px width
    imageW = image.width;
    // if (imageW > maxpix) { //yeah, all
    imageW = maxpix;
    image.resize(maxpix, 0);
    //  }
    //get new heigt now
    imageH = image.height;
    //   println(" now im w: :" + image.width + " im h: " + image.height);
  }

  void getTags() {
    tag.parseOne(counter);
    pairs = tag.allMatches;
    for (int i=0; i<tag.allMatches.size(); i++) {
      println( " pair : " + tag.allMatches.get(i));
    }
    // println( " pairs : " + tag.allMatches);
  }

  void  visitLink(int _leftBorderX, int _width, float _upperBorderY, int _height, color _over, color _not) {
    //rollover
    if (mouseX > _leftBorderX && mouseX < _leftBorderX + _width && mouseY -wheel > _upperBorderY && mouseY -wheel < _upperBorderY + _height) {

      rollover = true;
      fill(_over, 220);
      stroke(100);
    } else {
      rollover = false;
      fill(_not);
      stroke(200);
    }

    //click
    if (rollover && mousePressed) {
      click = true;
    } else {
      click = false;
    }

    //do on release
    if (click == true && preClick == false) {
      //   ellipse(50, 50, 50, 50);  //ok
      link(url);
      preClick = click;
    }
  }
  //////////////
}// end of class

