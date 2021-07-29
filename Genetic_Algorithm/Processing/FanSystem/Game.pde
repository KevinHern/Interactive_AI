import fisica.*;
import java.util.Random;
import java.util.Arrays;
import java.util.Comparator;

float maxLifeSpan = 500;
float lifespan = maxLifeSpan, mutationRate = 0.5;
int population = 20, generation = 1;
PFont f;
Random random = new Random();

FWorld[] worlds;
FanSystem[] fanSystems;
float[] fanPositions;
Target target;

float ballAngle, ballSpeed, ballHeight, ballDiameter, ballDensity;
float worldGravity;

void settings() {
  size(1500, 1000);
}

void setup() {
  // Basic Setups
  Fisica.init(this);
  this.worlds = new FWorld[this.population];
  this.fanSystems = new FanSystem[this.population];
  this.ballAngle = -PI/8;
  this.ballSpeed = 300;
  this.ballDiameter = 30;
  this.ballHeight = random(0, height*5/8);
  this.ballDensity = random(1, 1.5);
  this.worldGravity = 150;
  
  // Font Displays
  f = createFont("Arial" , 16, true);
  
  // Target
  this.target = new Target(width*31/32-10, random(height/16, height*3/4));
  
  // Setting up systems
  this.fanPositions = new float[4];
  for(int i = 0; i < 4; i++) {
    this.fanPositions[i] = random(-100, 100);
  }
  
  for(int i = 0 ; i < this.population; i++) {
    // Setting up World
    this.worlds[i] = new FWorld();
    this.worlds[i].setEdges();
    this.worlds[i].remove(this.worlds[i].top);
    this.worlds[i].setGravity(0, this.worldGravity);
    this.worlds[i].setGrabbable(true);
    
    // Setting up Fan System
    this.fanSystems[i] = new FanSystem(this.ballAngle, this.ballSpeed, this.ballDiameter, this.ballHeight, this.ballDensity, fanPositions, this.target);
    
    // Ball
    this.fanSystems[i].ball.body = new FCircle(this.ballDiameter);
    this.fanSystems[i].ball.setProperties();
    
    // Setting up Winds
    for(int j = 0; j < 4; j++) {
      this.fanSystems[i].fans[j].wind = new FBox(this.fanSystems[i].fans[j].fanWidth, this.fanSystems[i].fans[j].fanHeight);
      this.fanSystems[i].fans[j].setProperties("wind-" + i + "-" + j);
      
      // Adding to the world
      this.worlds[i].add(this.fanSystems[i].fans[j].wind);
    }
    
    // Add ball to the world
    this.worlds[i].add(this.fanSystems[i].ball.body);
  }
}

void draw() {
  background(255);
  textFont(f,16);
  fill(0);
  text("Lifespan: " + this.lifespan 
      + "\nGeneration: " + this.generation
      + "\nPopulation: " + this.population
      + "\nMutation Rate: " + (this.mutationRate * 100) + "%"
  , width/16,height/32);
  this.target.display();
  for(int i = 0; i < this.population; i++) {
    this.worlds[i].step();
    this.worlds[i].draw();
    this.fanSystems[i].fitness(this.target);
    this.fanSystems[i].display();
  }
  this.lifespan--;
  if(this.lifespan < 0) {
    // Sort Fan Systems
    Arrays.sort(fanSystems);
    
    println("Best Cannon: " + fanSystems[0].fitness);
    println("Second Best Cannon: " + fanSystems[1].fitness);
    println("Second Worst Cannon: " + fanSystems[this.population-2].fitness);
    println("Worst Cannon: " + fanSystems[this.population-1].fitness);
    
    //Selecting Parents: The 50% of the top cannons are selected for mating
    float[][] newWindForces = new float[this.population][4];
    for(int i = 0; i < this.population; i++) {
      FanSystem parentA = fanSystems[(int)(random(this.population * 0.5))];
      FanSystem parentB = fanSystems[(int)(random(this.population * 0.5))];
      
      newWindForces[i][0] = random.nextBoolean()? parentA.fans[0].windForce : parentB.fans[0].windForce;
      newWindForces[i][1] = random.nextBoolean()? parentA.fans[1].windForce : parentB.fans[1].windForce;
      newWindForces[i][2] = random.nextBoolean()? parentA.fans[2].windForce : parentB.fans[2].windForce;
      newWindForces[i][3] = random.nextBoolean()? parentA.fans[3].windForce : parentB.fans[3].windForce;
    }
    
    for(int i = 0; i < this.population; i++) {
      this.fanSystems[i].setWindForces(newWindForces[i]);
      if(random.nextBoolean()) this.fanSystems[i].mutate();
      this.fanSystems[i].ball.restart();
      this.fanSystems[i].initialFitness(this.target);
    }
    this.lifespan = maxLifeSpan;
    this.generation++;
  }
}

void contactStarted(FContact contact) { 
  if(contact.getBody1().getName() != null) {
    if(contact.getBody1().getName().contains("wind")) {
      String[] tokenized = contact.getBody1().getName().split("-");
      contact.getBody2().addForce(0, -this.fanSystems[Integer.parseInt(tokenized[1])].fans[Integer.parseInt(tokenized[2])].windForce);
    }
  }
}

void contactPersisted(FContact contact) { 
  //println(contact.getBody1().getName());
  if(contact.getBody1().getName() != null) {
    if(contact.getBody1().getName().contains("wind")) {
      String[] tokenized = contact.getBody1().getName().split("-");
      contact.getBody2().addForce(0, -this.fanSystems[Integer.parseInt(tokenized[1])].fans[Integer.parseInt(tokenized[2])].windForce);
    }
  }
  else {
    contact.getBody2().setVelocity(0, 0);
  }
}

void contactEnded(FContact contact) {
  if(contact.getBody1().getName() != null) {
    if(contact.getBody1().getName().equals("wind")) {
    contact.getBody2().addForce(0, 0);
    }
  }
}
