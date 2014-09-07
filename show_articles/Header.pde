//PFont h0;
class Header {
  // color c = #07AFBC;
  int h = 70; //height

  //PFont h0 = createFont("arial", 17);


  Header() {
  }


  void display() {
    pushMatrix();
    translate (0, -wheel); //cheap I know
    pushStyle(); 
    stroke(180);
    line(0, h, width, h);
    noStroke();
    fill(blue, 125);
    // fill(#02C1C0);
    rect(0, 0, width, h);

    //text
    fill(40);
    textSize(12);
    // textFont(h0);
    textAlign(CENTER);
    text("scrool. \t hit SPACE if lost \n click on link to see article online", width/2, h/2);
    //
    textAlign(LEFT);
    text("\n  +/- to zoom ", margine*2, h/2); 
    //
    text("\nMatched words:", tags_x, h/2);

    popStyle();
    popMatrix();
  }
}//end class

