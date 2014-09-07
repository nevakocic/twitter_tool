/*  ********* wish i know python magic for this  ***********

 will parse key words
 and them to Article to display
 and to Sort class to sort them 
*/
class Tags {
  //ArrayList<String> counters = new ArrayList(); // this will arrive
  ArrayList<String> allWordsFound = new ArrayList(); // appending allWords
  IntList allTimesFound = new IntList(); // appending

  ArrayList<String> wordsFound = new ArrayList(); // use for each counter
  IntList timesFound = new IntList(); // use for each counter

  String [] matches;  //now get each pair
  ArrayList<String> allMatches = new ArrayList(); //matched pairs just list
  String pairsColumn, wordsColumn, timesColumn;
  boolean hasMatches;
  int numOfMatches;              //how many pairs


/*******************not using this now!*******/
/*
    void getAllValues(ArrayList<String> _counters) {
    //for every counter in list we got
    for (String counter : _counters) {
      //check if should be parsed
      if (hasKeyWords(counter) == true) {
        println("ok"); //ok
        parse(counter);
      } else {
        allWordsFound.add("zero matches");    // have zero values for non-matches
        allTimesFound.append(0);
        pairsColumn = "none";
      }
      //check result after all adding and appending
    }
    //println(" after appendig zero mathes: "  );
    // println(" allWordsFound: " + allWordsFound + ",  times : " + allTimesFound + ", item 1 has value: " + allTimesFound.get(1));
  }*/

  void parseOne(String _oneCounter) {
    // clear lists before parsing next counter
    wordsFound.clear();
    timesFound.clear();
    
    //check if should be parsed
    if (hasKeyWords(_oneCounter) == true) {
      println(" will parse now .. "); //ok
      parse(_oneCounter);
      hasMatches = true;
    } else {
      wordsFound.add(" zero matches ");    // have zero values for non-matches
      timesFound.append(0);
      pairsColumn = "-";
      hasMatches = false;
    }
    //check result after all adding and appending
    println(" parsed tag looks like this:  "  );
    println(" wordsFound: " + wordsFound + ",  times : " + timesFound + ", #check if item 0 has value: " + timesFound.get(0));
  }


  void parse(String _counterValue) {
    String tag01 = "Counter({";  //Counter({'but': 5, 'art': 2, 'age': 1})
    String tag02 = "})";
    String counterValue = getTextBetween(_counterValue, tag01, tag02);
    println(counterValue + "   <--- counter value"); 
    matches = split(counterValue, ",");  //now get each pair
    pairsColumn = " " +join(matches, "\n");
    println(" words column: " + pairsColumn);
    for (String match : matches) {  //put array in list - maybe not
      allMatches.add(match);
    }
    println(" matched pairs: " + allMatches);
    numOfMatches = allMatches.size();              //how many pairs
    String tagw1 = "'";
    String tagw2 = "':";
    String tagv1 = ": ";
    String tagv2 = "&";
    for (String one : allMatches) {              //for every pair 
      one = one + "&";        //make ending tag
      //  println(one);      //ok
      wordsFound.add(getTextBetween(one, tagw1, tagw2));  // get word and append to list for one
      allWordsFound.add(getTextBetween(one, tagw1, tagw2));  // get word and append to list for all
      String timesFoundString = getTextBetween(one, tagv1, tagv2);
      timesFound.append(int(timesFoundString));            //get number and append for one 
      allTimesFound.append(int(timesFoundString));            //get number and append for all
    }
    println(" end of parsing() " );
    //  println(" allWordsFound: " + allWordsFound + ",  times : " + allTimesFound + ", item 1 has value: " + allTimesFound.get(1));
  }//end parse()


  //see if there is any matches or counter is empty
  boolean hasKeyWords(String checkCounter) {
    //look between these tags if counter is empty
    String tagc1 = "Counter(";
    String tagc2 = ")";
    String isItEmpty = getTextBetween(checkCounter, tagc1, tagc2);
    // if (isItEmpty == "") {
    if (isItEmpty.equals("")) {
      println("no matchin words here: " + checkCounter);
    //  hasMatches = false;
      return false;  //meaning no key words
    } else {
      println("yeah! found some words: " );
      println(checkCounter); // print non empty string
   //   hasMatches = true;
      return true;
    }
  } // end hasKeyWords = ok


  String getTextBetween(String s, String startTag, String endTag) {
    //String found = "" ;
    // find the index of the beginning tag
    int startIndex = s.indexOf(startTag);
    if (startIndex == -1) {
      println("couldn't find start tag");
      return "";
    }
    // move to the end of the beginning tag
    startIndex += startTag.length();
    //index of the end tag
    int endIndex = s.indexOf(endTag, startIndex);
    //println("endIndex is at " + endIndex);
    if (endIndex == -1) {
      println("couldn't find end tag");
      return "" ;
    }
    //text in between
    //  println(s.substring(startIndex, endIndex));  // ok ok ok 
    return s.substring(startIndex, endIndex);
  }
}//end class

