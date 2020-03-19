class FlightComputer {

  int[] turnSteps, boostSteps;
  int step=0;

  FlightComputer(int numSteps) {
    turnSteps = new int[numSteps];
    boostSteps = new int[numSteps];

    for (int i=0; i<turnSteps.length; i++)
      turnSteps[i] = 1;

    for (int i=0; i<boostSteps.length; i++)
      boostSteps[i] = 0;
  }

  void mutate() {
    float mutationRate = 0.1;

    for (int i=0; i<boostSteps.length; i++)
      if (random(1)<mutationRate)
        boostSteps[i] = (int)random(0, 2);

    for (int i=0; i<turnSteps.length; i++)
      if (random(1)<mutationRate)
        turnSteps[i] = (int)random(0, 3);
  }

  FlightComputer clone() {
    FlightComputer f = new FlightComputer(turnSteps.length);
    f.boostSteps = boostSteps.clone();
    f.turnSteps = turnSteps.clone();
    return f;
  }

  void saveToFile() {
    Table t = new Table();

    for (int i=0; i<boostSteps.length; i++)
      t.addColumn();

    TableRow row = t.addRow();
    for (int i=0; i<boostSteps.length; i++)
      row.setInt(i, boostSteps[i]);

    row = t.addRow();
    for (int i=0; i<turnSteps.length; i++)
      row.setInt(i, turnSteps[i]);

    saveTable(t, "data/fComp.csv");
  }

  void loadFromFile() {
    Table t = loadTable("data/fComp.csv");

    TableRow row = t.getRow(0);
    for (int i=0; i<boostSteps.length; i++)
      boostSteps[i] = row.getInt(i);

    row = t.getRow(1);
    for (int i=0; i<turnSteps.length; i++)
      turnSteps[i] = row.getInt(i);
  }
}
