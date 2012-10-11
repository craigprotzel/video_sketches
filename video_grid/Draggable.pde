// Click and Drag an object
// Daniel Shiffman 

// A class for a draggable thing

class Draggable {
  boolean dragging = false; // Is the object being dragged?
  boolean rollover = false; // Is the mouse over the ellipse?

  float x, y, w, h;          // Location and size
  float offsetX, offsetY; // Mouseclick offset

  Draggable(float tempX, float tempY, float tempW, float tempH) {
    x = tempX;
    y = tempY;
    w = tempW;
    h = tempH;
    offsetX = 0;
    offsetY = 0;
  }

  // Method to display
  void display(PImage myvideo) {
    stroke(0);
    if (dragging) fill (50);
    else if (rollover) fill(100);
    else fill(175, 200);
    rect(x, y, w, h);

    image (myvideo, x, y, w, h);
  }

  // Is a point inside the rectangle (for click)?
  boolean clicked(int mx, int my) {
    if (mx > x && mx < x + w && my > y && my < y + h) {
      dragging = true;
      // If so, keep track of relative location of click to corner of rectangle
      offsetX = x-mx;
      offsetY = y-my;
    }

    // if I have been dragged then tell the calling program that I am the chosen one
    if (dragging == true)
    {
      return (true);
    }
    else
    {
      return (false);
    }
  }


  // Is a point inside the rectangle (for rollover)
  void rollover(float mx, float my) {
    if (mx > x && mx < x + w && my > y && my < y + h) {
      rollover = true;
      //println("Rolledover!!!!");
    } 
    else {
      rollover = false;
      //println("Not Rolledover");
    }
  }

  // Stop dragging
  void stopDragging() {
    dragging = false;
  }

  // Drag the rectangle
  void drag(float mx, float my) {
    if (dragging) {
      x = mx + offsetX;
      y = my + offsetY;
    }
  }
}

