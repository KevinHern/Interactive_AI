class Rocket implements Comparable<Rocket> {
  float fitness, angle, speed, radius, density;
  FBox body;
  
  Rocket(float angle, float speed, float density, float radius) {
    this.angle = angle;
    this.speed = speed;
    this.radius = radius;
    this.density = density;
  }
  
  void setProperties(String name, Target target){
    this.body.setPosition(this.radius*cos(this.angle), this.radius*sin(this.angle));
    this.body.setRotation(this.angle);
    this.body.setVelocity(this.speed*cos(this.angle), this.speed*sin(this.angle));
    this.body.setDamping(0);
    this.body.setDensity(this.density);
    
    this.body.setStatic(false);
    this.body.setRotatable(true);
    this.body.setGrabbable(false);
    this.body.setName(name);
    
    // Formatting
    this.body.setFill(random(0, 255), random(0, 255), random(0, 255));
    this.body.setStroke(255, 255, 255);
    
    // Fitness
    this.fitness = new PVector(target.location.x - this.body.getX(), target.location.y - this.body.getY()).mag();
  }
  
  void fitness(Target target) {
    PVector distance = new PVector(target.location.x - this.body.getX(), target.location.y - this.body.getY());
    if(distance.mag() < 0) this.fitness = distance.mag();
  }
  
  void mutate(){
    this.speed *= random(0.85, 1.15);
    this.angle *= random(0.85, 1.15);
  }
  
  void restart(Target target) {
    this.body.setPosition(this.radius*cos(this.angle), this.radius*sin(this.angle));
    this.body.setRotation(this.angle);
    this.body.setVelocity(this.speed*cos(this.angle), this.speed*sin(this.angle));
    
    this.fitness = new PVector(target.location.x - this.body.getX(), target.location.y - this.body.getY()).mag();
  }
  
  void setNewValues(float[] newValues) {
    this.angle = newValues[0];
    this.speed = newValues[1];
  }
  
  void applyNetForce(float G, Planet[] planets){
    for(int i = 0; i < planets.length; i++) {
      PVector direction = new PVector(planets[i].body.getX() - this.body.getX(), planets[i].body.getY() - this.body.getY());
      //print("Planet Mass: " + planets[i].body.getMass() + " : Rocket Mass: " + this.body.getMass());
      float product1 = G * planets[i].body.getMass() * this.body.getMass();
      float product2 = (direction.mag() * direction.mag());
      //print(" : Product1: " + product1 + " : Product2: " + product2);
      PVector force = direction.normalize().mult(product1 / product2);
      //print("Mag: " + force.mag() + " : Force X: " + force.x + " : Force Y: " + force.y + "\n");
      this.body.addForce(force.x, force.y);
    }
  }
  
  @Override
  public int compareTo(Rocket fanSystem) {
    return (int)this.fitness - (int)fanSystem.fitness;
  }
}
