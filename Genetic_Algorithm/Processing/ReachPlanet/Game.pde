import fisica.*;
import java.util.Random;
import java.util.Arrays;
import java.util.Comparator;

float maxLifeSpan = 600;
float lifespan = maxLifeSpan, mutationRate = 0.5;
int population = 30, generation = 1;
PFont f;
Random random = new Random();

FWorld[] worlds;
Rocket[] rockets;
Planet[][] planets;
Target target;

int numPlanets = 5;
float G = 100000;
float ourPlanetRadius, ourPlanetDensity;
float rocketWidth, rocketHeight, rocketDensity;
float[] newRocketValues;
float[] planetDiameters, planetDensities;
float[][] planetPositions;

void settings() {
  size(1800, 1000);
}

void setup() {
  // Basic Setups
  Fisica.init(this);
  this.worlds = new FWorld[this.population];
  this.rockets = new Rocket[this.population];
  this.planets = new Planet[this.population][this.numPlanets];
  this.planetPositions = new float[this.numPlanets][2];
  this.planetDiameters = new float[this.numPlanets];
  this.planetDensities = new float[this.numPlanets];
  this.rocketWidth = 25;
  this.rocketHeight = 25;
  this.rocketDensity = random(0.5, 1.5);
  this.ourPlanetRadius = 50;
  this.ourPlanetDensity = 1;
  
  // Font Displays
  f = createFont("Arial" , 16, true);
  
  // Target
  this.target = new Target(width*31/32-10, random(height/16, height*3/4));
  
  // Setting Planet Positions
  for(int i = 0; i < this.numPlanets; i++) {
    this.planetDiameters[i] = random(50, 200);
    this.planetDensities[i] = random(1, 3);
    this.planetPositions[i][0] = width/2 + random(-600, 600);
    this.planetPositions[i][1] = random(0, height);
  }
  
  for(int i = 0 ; i < this.population; i++) {
    // Setting up World
    this.worlds[i] = new FWorld();
    this.worlds[i].setGravity(0, 0);
    this.worlds[i].setGrabbable(true);
    
    // Setting up Rockets
    this.rockets[i] = new Rocket(random(0, 2*PI), random(100, 200), this.rocketDensity, this.ourPlanetRadius + this.rocketWidth + 1);
    
    // Setting up Rocket bodies
    this.rockets[i].body = new FBox(this.rocketWidth, this.rocketHeight);
    this.rockets[i].setProperties("rocket-" + i, this.target);
    
    // Setting up Planets
    for(int j = 0; j < this.numPlanets; j++) {
      this.planets[i][j] = new Planet(this.planetDensities[j], this.planetDiameters[j], this.planetPositions[j][0], this.planetPositions[j][1]);
      this.planets[i][j].body = new FCircle(this.planetDiameters[j]);
      this.planets[i][j].setProperties("planet-" + i + "-" + j);
      
      // Adding to the world
      this.worlds[i].add(this.planets[i][j].body);
    }
    
    // Add ball to the world
    this.worlds[i].add(rockets[i].body);
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
    this.rockets[i].fitness(this.target);
    //this.rockets[i].body.addForce(0, 2000);
    this.rockets[i].applyNetForce(this.G, this.planets[i]);
  }
  this.lifespan--;
  if(this.lifespan < 0) {
    // Sort Fan Systems
    Arrays.sort(rockets);
    
    println("Best Rocket: " + rockets[0].fitness);
    println("Second Best Rocket: " + rockets[1].fitness);
    println("Second Worst Rocket: " + rockets[this.population-2].fitness);
    println("Worst Rocket: " + rockets[this.population-1].fitness);
    
    //Selecting Parents: The 50% of the top cannons are selected for mating
    float[][] newRocketValues = new float[this.population][2];
    for(int i = 0; i < this.population; i++) {
      Rocket parentA = rockets[(int)(random(this.population * 0.5))];
      Rocket parentB = rockets[(int)(random(this.population * 0.5))];
      
      newRocketValues[i][0] = random.nextBoolean()? parentA.angle : parentB.angle;
      newRocketValues[i][1] = random.nextBoolean()? parentA.speed : parentB.speed;
    }
    
    for(int i = 0; i < this.population; i++) {
      this.rockets[i].setNewValues(newRocketValues[i]);
      if(random.nextBoolean()) this.rockets[i].mutate();
      this.rockets[i].restart(this.target);
    }
    this.lifespan = maxLifeSpan;
    this.generation++;
  }
}

void contactStarted(FContact contact) { 
  if(contact.getBody1().getName() != null) {
    if(contact.getBody1().getName().contains("rocket")) contact.getBody1().setVelocity(0, 0);
  }
}

void contactPersisted(FContact contact) { 
  //println(contact.getBody1().getName());
  if(contact.getBody1().getName() != null) {
    if(contact.getBody1().getName().contains("rocket")) contact.getBody1().setVelocity(0, 0);
  }
  else {
    contact.getBody2().setVelocity(0, 0);
  }
}

void contactEnded(FContact contact) {
  if(contact.getBody1().getName().contains("rocket")) contact.getBody1().setVelocity(0, 0);
}
