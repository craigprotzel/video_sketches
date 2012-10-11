import processing.video.*;

//Declare a capture object
Capture cam;

//Set the grid size - deterines the numner of pieces
int grid_w = 3;
int grid_h = 3;
int cell_w;
int cell_h;

int paddingX;
int paddingY;

//Declare a double image array to hold all of the video pieces
PImage splitimages[][];
//Declare a double array for draggable videopieces
Draggable videopieces [][];
//Declare a double array for boardpieces
Board boardpieces [][];


void setup() {

  size(1280, 840);
  smooth();

  //for the intial positioning of the video
  paddingX = width/4;
  paddingY = height/4;

  //////////////////////////////
  //ALL TO GET THE CAMERA WORKING
  String[] cameras = Capture.list();
  //Check if/which cameras are available
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } 
  else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i] + " Array Value: " + i);
    }  
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    // USING 320 x 240
    cam = new Capture(this, cameras[0]);
    cam.start();
  }
  //////////////////////////////


  //Initialize the length of the splitimages double array 
  splitimages = new PImage[grid_w][grid_h];
  //Initialize the length of the boardpieces double array
  boardpieces = new Board[grid_w][grid_h];
  //Initialize the length of the videopieces double array
  videopieces = new Draggable[grid_w][grid_h];

  //Initialize the size of each piece, based on grid and and cam size
  cell_w = int (640 / grid_w);
  cell_h = int (480 / grid_h);

  //Initialize the actual values for the double arrays
  for (int x = 0; x < grid_w; x++) {
    for (int y = 0; y < grid_h; y++) {

      //create our holder PImage
      splitimages[x][y] = new PImage(cell_w, cell_h);

      //create the boardpieces
      boardpieces[x][y] = new Board(paddingX + (x * cell_w), paddingY + (y * cell_h), cell_w, cell_h);

      //create the videopieces
      videopieces[x][y] = new Draggable(paddingX + (x * cell_w), paddingY + (y * cell_h), cell_w, cell_h);
    }
  }
}

void draw() {



  //Check to see if a new frame is available
  if (cam.available()) {
    background(0);
    cam.read();

    cam.loadPixels();

    //cycle through the camera pixel array
    //split up the pizels into the grid size
    //store the new grid pieces in the PImage array
    for (int x = 0; x < grid_w; x++) {
      for (int y = 0; y < grid_h; y++) {

        //determine the top left pixel for each grid piece
        int xpos = x * cell_w;
        int ypos = y * cell_h;

        //display the board pieces
        boardpieces[x][y].displayBoard();

        splitimages[x][y].copy(cam, xpos, ypos, cell_w, cell_h, 0, 0, cell_w, cell_h);
      }
    }

    //display all the PImages at the correct location
    for (int x = 0; x < grid_w; x++) {
      for (int y = 0; y < grid_h; y++) {

        //this will display the video in pieces
        //image(splitimages[x][y], paddingX + (x * cell_w), paddingY + (y * cell_h));

        //this will display the video as draggable pieces 
        videopieces[x][y].rollover(mouseX, mouseY);
        //videopieces[x][y].clicked(mouseX, mouseY);        
        videopieces[x][y].drag(mouseX, mouseY);
        videopieces[x][y].display(splitimages[x][y]);
      }
    }
  }
  //image(cam, paddingX, paddingY);
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
}


void mousePressed() {

  int x_ = 0;
  int y_ = 0;

  for (int i = 0; i < grid_w; i++) {
    for (int j = 0; j < grid_h; j++) {

      boolean clicktest = videopieces[i][j].clicked(mouseX, mouseY);
      
      if (clicktest == true) {
        //we found our piece
        x_ = i;
        y_ = j;
        //break out of the loop
        i = grid_w;
        j = grid_h;
      }
    }
  }

  //determine which piece is being dragged
  //make the current spacewhere that piece is available for the time being
  if (videopieces[x_][y_].clicked(mouseX, mouseY) == true) {
    println (x_ + "," + y_ + " is clicked!");

    for (int bx = 0; bx < grid_w; bx++) {
      for (int by = 0; by < grid_h; by++) {
        if (boardpieces[bx][by].isUsed() && dist(videopieces[x_][y_].x, videopieces[x_][y_].y, boardpieces[bx][by].x, boardpieces[bx][by].y) == 0) {
          boardpieces[bx][by].used = false;
        }
      }
    }
  }
}

void mouseReleased() {

  for (int x = 0; x < grid_w; x++) {
    for (int y = 0; y < grid_h; y++) {

      //see which piece was dragging last
      if (videopieces[x][y].dragging == true) {
        println (x + "," + y + " was dragging!");

        //assume a really high number for our distance
        float boarddistrecord = 100;
        int boarddistrecord_x = 0;
        int boarddistrecord_y = 0;
        boolean spotfound = false;

        //find the closest grid cell and snap to it
        for (int bx = 0; bx < grid_w; bx++) {
          for (int by = 0; by < grid_h; by++) {

            //check all the boardpieces
            //see which is closest to our dragging piece
            //also see if the board piece already a puzzle piece in it
            if (!boardpieces[bx][by].isUsed() && dist(videopieces[x][y].x, videopieces[x][y].y, boardpieces[bx][by].x, boardpieces[bx][by].y) < boarddistrecord)
            {
              //store this board as our record holder
              boarddistrecord = dist(videopieces[x][y].x, videopieces[x][y].y, boardpieces[bx][by].x, boardpieces[bx][by].y);
              boarddistrecord_x = bx;
              boarddistrecord_y = by;
              spotfound = true;
            }
          }
        }

        //after we've evaluated every spot, see if we should snap
        if (spotfound) {
          println("snapping to: " + boarddistrecord_x + "," + boarddistrecord_y);

          //snap it to correct spot
          videopieces[x][y].x = boardpieces[boarddistrecord_x][boarddistrecord_y].x;
          videopieces[x][y].y = boardpieces[boarddistrecord_x][boarddistrecord_y].y;
          //set this boarpiece to being used by calling spotUsed()
          boardpieces[boarddistrecord_x][boarddistrecord_y].spotUsed();
        }
      }
      videopieces[x][y].stopDragging();
    }
  }
}

