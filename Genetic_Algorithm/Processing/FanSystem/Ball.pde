class Ball {
  float diameter, speed, angle, density;
  PVector location;
  FCircle body;
  
  Ball(float diameter, float angle, float speed, float density, float x, float y) {
    this.diameter = diameter;
    this.speed = speed;
    this.angle = angle;
    this.density = density;
    this.location = new PVector(x, y);
  }
  
  void setProperties() {
    this.body.setPosition(this.location.x, this.location.y);
    this.body.setVelocity(this.speed*cos(this.angle), this.speed*sin(this.angle));
    this.body.setGrabbable(true);
    this.body.setDensity(this.density);
    this.body.setDamping(0.1);
    this.body.setName("ball");
    
    // Formatting
    this.body.setFill(random(0, 255), random(0, 255), random(0, 255));
    this.body.setStroke(0, 0, 0);
  }
  
  void restart() {
    this.body.setPosition(this.location.x, this.location.y);
    body.setVelocity(this.speed*cos(this.angle), this.speed*sin(this.angle));
  }
}
