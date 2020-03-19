Fleet fleet;
PVector target;
int gen = 0;

void setup() {
  size(1000, 500);
  frameRate(30);
  fleet = new Fleet(100);
  target = new PVector(width/2+250, height);
}

void draw() {
  background(200, 200, 255);
  if(showAll){
    strokeWeight(1);
    stroke(0);
    fill(255, 0, 0);
    ellipseMode(CENTER);
    float rw = fleet.rockets[0].size.x;
    ellipse(target.x+rw/2, target.y, rw+10, rw);
  }

  boolean allDone = true;
  fleet.update();
  if(showAll){
    fleet.showAll();
  }
  if (!fleet.allDone())
    allDone = false;

  if (allDone) {
    fleet.rockets[0].saveToFile();
    fleet.naturalSelection();
    gen++;
  }

  fill(0);
  text((int)frameRate+" FPS\nGeneration: "+gen, 3, 12);

  //if (gen%5==0)
  //saveFrame("frames/frame-#####.png");
}

boolean slow = true;
boolean showAll = true;
void keyPressed() {
  switch(key) {
  case '0':
    showAll=!showAll;
    break;
  case ' ':
    slow=!slow;
    if (slow)
      frameRate(10000);
    else
      frameRate(30);
    break;
  default:
    break;
  }
}
