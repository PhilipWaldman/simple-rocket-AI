class Rocket {
  PVector pos, vel, acc, size;
  float fuel, maxFuel = 75, gravity = 0.2, impactSpeed, maxImpactSpeed=0.5, horSpeed, maxHorSpeed=0.5, distFromTarget, maxDistFromTarget=5;
  boolean exploded = false, landed=false, boost = false, boostRight = false, boostLeft = false;
  FlightComputer fComp;

  Rocket(float startX, float startY) {
    fComp = new FlightComputer(150);
    size = new PVector(44, 123);
    pos = new PVector(startX, startY);
    vel = new PVector(0, 0);
    acc = new PVector(0, gravity);
    loadImages();
    fuel = maxFuel;
  }

  //Images
  PImage flame, body, puffRight, puffLeft, explosion;
  int legPic = 0;
  PImage[] legPics;
  void loadImages() {
    flame = loadImage("resources/flame.png");
    body = loadImage("resources/body.png");
    puffRight = loadImage("resources/puff_right.png");
    puffLeft = loadImage("resources/puff_left.png");
    explosion = loadImage("resources/explosion/test.png");
    legPics = new PImage[18];
    for (int i=0; i<legPics.length; i++)
      legPics[i] = loadImage("resources/legs/legs_"+i+".png");
  }

  void update() {
    if (!landed) {
      execute();
      updateFuel();

      if (boost)
        acc.y = -0.5;
      else
        acc = new PVector();
      acc.y += gravity;

      acc.x = 0;
      if (boostRight)
        acc.x -= 0.1;
      if (boostLeft)
        acc.x += 0.1;

      move();
    } else
      distFromTarget = dist(pos.x, pos.y+size.y-16, target.x, target.y);

    int dist = (int)((pos.y+size.y-16 - height*0.7)*((float)legPics.length/(height*0.2)));
    int num = dist <0 ? 0 : dist;
    legPic = num>=legPics.length ? legPics.length-1 : num;
  }

  void execute() {
    if (fComp.step<fComp.boostSteps.length) {
      int step = fComp.step;

      if (fComp.boostSteps[step]==0)
        boost=false;
      else
        boost=true;

      if (fComp.turnSteps[step]==0) {
        boostLeft=true;
        boostRight=false;
      } else if (fComp.turnSteps[step]==2) {
        boostLeft=false;
        boostRight=true;
      } else {
        boostLeft=false;
        boostRight=false;
      }

      fComp.step++;
    } else {
      boost = false;
      boostLeft=false;
      boostRight=false;
    }
  }

  void move() {
    if (pos.y+size.y-16>height) {
      if (vel.y>maxImpactSpeed || abs(vel.x)>maxHorSpeed)
        exploded = true;
      impactSpeed = vel.y<0 ? 0 : vel.y;
      horSpeed = abs(vel.x);
      acc = new PVector();
      vel = new PVector();
      pos.y = height-size.y+16;
      landed=true;
    }

    pos.add(vel);
    vel.add(acc);
  }

  void updateFuel() {
    if (fuel>0) {
      if (boost)
        fuel--;
      if (boostLeft)
        fuel-=0.1;
      if (boostRight)
        fuel-=0.1;
    } else {
      boost=false;
      boostLeft=false;
      boostRight=false;
      acc.x = 0;
      fuel = 0;
    }
  }

  void show() {
    showRocket();
  }

  void showRocket() {
    if (!exploded) {
      image(body, pos.x, pos.y, size.x, size.y);
      image(legPics[legPic], pos.x, pos.y, size.x, size.y);
      if (boost)
        image(flame, pos.x, pos.y, size.x, size.y);
      if (boostLeft)
        image(puffLeft, pos.x, pos.y, size.x, size.y);
      if (boostRight)
        image(puffRight, pos.x, pos.y, size.x, size.y);
    } else
      image(explosion, pos.x, pos.y, size.x, size.y);
  }

  void showFuel() {
    fill(0, 200, 0);
    noStroke();
    rect(width/50 + width/20, height*0.3 + height*0.4, -width/20, -height*0.4 * (fuel/maxFuel));

    noFill();
    stroke(0);
    strokeWeight(3);
    rect(width/50, height*0.3, width/20, height*0.4);
    strokeWeight(1);
  }

  void showDebug() {
    /*
    strokeWeight(5);
     stroke(255, 0, 0); // vel
     line(pos.x-size.x, pos.y-size.y, pos.x-size.x+vel.x*10, pos.y-size.y+vel.y*10);
     stroke(0, 255, 0); // acc
     line(pos.x+size.x, pos.y-size.y, pos.x+size.x+acc.x*100, pos.y-size.y+acc.y*100);
     */
    /*
    noFill();
     strokeWeight(3);
     stroke(0);
     rect(pos.x, pos.y, size.x, size.y);
     */
    text(this.toString(), 100, 50);
  }

  String toString() {
    fill(0);
    String str = "step: "+fComp.step
      + "\npos: "+pos
      + "\nvel: "+vel
      + "\nacc: "+acc
      + "\nsize: "+size
      + "\nmaxFuel: "+maxFuel
      + "\nfuel: "+fuel
      + "\nlegPic: "+legPic
      + "\nexploded: "+exploded
      + "\nimpactSpeed: "+impactSpeed
      + "\nmaxImpactSpeed: "+maxImpactSpeed
      + "\nhorSpeed: "+horSpeed
      + "\nmaxHorSpeed: "+maxHorSpeed
      + "\ndistFromTarget: "+distFromTarget
      + "\nmaxDistFromTarget: "+maxDistFromTarget
      + "\nfitness: "+fitness()
      + "\nlanding fitness: "+(100.0 / pow(10, impactSpeed/5))
      + "\ntarget fitness: "+(100.0 / pow(10, distFromTarget/50) + 100)
      + "\nfuel fitness: "+(maxFuel*log(fuel+1) + 200);
    return str;
  }

  float fitness() {
    if (exploded) // when impactSpeed > 0.5 || horSpeed > 0.5, optimize impactSpeed
      return 100.0 / pow(10, impactSpeed/5);
    else if (distFromTarget>maxDistFromTarget) // when > 5 from target, optimize landing spot
      return 100.0 / pow(10, distFromTarget/50) + 100;
    else // optimize fuel usage
    return maxFuel*log(fuel+1) + 200;
  }

  Rocket clone() {
    Rocket r = new Rocket(width/2, 0);
    r.fComp = fComp.clone();
    return r;
  }

  void saveToFile() {
    fComp.saveToFile();

    Table stats = new Table();
    stats.addColumn("Generation"); // 0
    stats.addColumn("Steps"); // 1
    stats.addColumn("Exploded"); // 2
    stats.addColumn("Max Fuel"); // 3
    stats.addColumn("Fuel"); // 4
    stats.addColumn("Max Impact Speed"); // 5
    stats.addColumn("Impact Speed"); // 6
    stats.addColumn("Max Hor Speed"); // 7
    stats.addColumn("Hor Speed"); // 8
    stats.addColumn("Max Dist From Target"); // 9
    stats.addColumn("Dist From Target"); // 10
    stats.addColumn("Fitness"); // 11

    TableRow tr = stats.addRow();
    tr.setInt(0, gen);
    tr.setInt(1, fComp.step);
    tr.setString(2, Boolean.toString(exploded));
    tr.setFloat(3, maxFuel);
    tr.setFloat(4, fuel);
    tr.setFloat(5, maxImpactSpeed);
    tr.setFloat(6, impactSpeed);
    tr.setFloat(7, maxHorSpeed);
    tr.setFloat(8, horSpeed);
    tr.setFloat(9, maxDistFromTarget);
    tr.setFloat(10, distFromTarget);
    tr.setFloat(11, fitness());

    saveTable(stats, "data/RocketStats.csv");
  }

  void loadFromFile() {
    fComp.loadFromFile();
  }
}
