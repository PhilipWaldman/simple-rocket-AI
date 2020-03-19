class Fleet {

  Rocket[] rockets;

  Fleet(int numRockets) {
    rockets = new Rocket[numRockets];

    for (int i=0; i<numRockets; i++)
      rockets[i] = new Rocket(width/2, 0);

    for (Rocket r : rockets)
      r.loadFromFile();
    //r.saveToFile();
  }

  void naturalSelection() {
    Rocket best = new Rocket(0, 0);
    float bestFitness = 0;
    for (int i=0; i<rockets.length; i++)
      if (rockets[i].fitness()>bestFitness) {
        bestFitness = rockets[i].fitness();
        best = rockets[i];
      }

    rockets = new Rocket[rockets.length];
    for (int i=0; i<rockets.length; i++)
      rockets[i] = best.clone();

    mutate();
  }

  void mutate() {
    for (int i=1; i<rockets.length; i++)
      rockets[i].fComp.mutate();
  }

  boolean allDone() {
    for (Rocket r : rockets)
      if (!r.landed)
        return false;
    return true;
  }

  void update() {
    for (Rocket r : rockets)
      r.update();
  }

  void show() {
    rockets[0].show();
    rockets[0].showFuel();
    rockets[0].showDebug();
    /*
    for (int i=0; i<3; i++)
     rockets[i].show();
     rockets[0].showFuel();
     rockets[0].showDebug();
     */
  }
  
  void showAll() {
    for (Rocket r : rockets)
     r.show();
  }
}
