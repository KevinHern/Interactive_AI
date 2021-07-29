class FanSystem implements Comparable<FanSystem> {
  Fan[] fans;
  Ball ball;
  
  float fitness, angle, ballSpeed;
  int numFans = 4;
  
  FanSystem(float ballAngle, float ballSpeed, float ballDiameter, float ballHeight, float ballDensity, float[] fanPositions, Target target){
    this.angle = ballAngle;
    this.ballSpeed = ballSpeed;
    
    // Ball
    this.ball = new Ball(ballDiameter, this.angle, this.ballSpeed, ballDensity, 0 + ballDiameter, ballHeight);
    
    // Fans
    this.fans = new Fan[this.numFans];
    for(int i = 0; i < this.numFans; i++) {
      this.fans[i] = new Fan(-PI/2, random(300, 1000), 150, height*7/8, (2*i + 1)*width/8 + fanPositions[i], height-10);
    }
    
    // Fitness
    this.initialFitness(target);
  }
  
  void initialFitness(Target target) {
    PVector distance = new PVector(target.location.x - this.ball.location.x, target.location.y - this.ball.location.y);
    this.fitness = distance.mag();
  }
  
  void fitness(Target target) {
    PVector distance = new PVector(target.location.x - this.ball.body.getX(), target.location.y - this.ball.body.getY());
    if(distance.mag() < this.fitness) this.fitness = distance.mag();
  }
  
  void display() {
    for(int i = 0; i < 4; i++) {
      this.fans[i].display();
    }
  }
  
  void setWindForces(float[] windForces){
    for(int i = 0; i < this.numFans; i++) this.fans[i].windForce = windForces[i];
  }
  
  void mutate(){
    for(int i = 0; i < this.numFans; i++) this.fans[i].windForce *= random(0.85, 1.15);
  }
  
  @Override
  public int compareTo(FanSystem fanSystem) {
    return (int)this.fitness - (int)fanSystem.fitness;
  }
}
