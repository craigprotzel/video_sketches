class Board {

  //variables for loaction and size
  float x, y, w, h;
  boolean used = false;
  
  Board(float tempX, float tempY, float tempW, float tempH){
  
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
  }
  
  //Display the board
  void displayBoard(){
  
    stroke (0);
    fill (255);
    rect (x, y, w, h);
  }
  
  //Logic to determine if a board spot is occupied 
  boolean isUsed() {
    return used;
  }

  
  void spotUsed() {
    used = true;
  }
  
}
