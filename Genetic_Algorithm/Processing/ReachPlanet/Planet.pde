class Planet {
  float density, diameter;
  PVector location;
  FCircle body;

  Planet(float density, float diameter, float x, float y) {
    this.diameter = diameter;
    this.density = density;
    this.location = new PVector(x, y);
  }
 
  void setProperties(String name) {
    this.body.setPosition(this.location.x, this.location.y);
    this.body.setVelocity(0, 0);
    this.body.setGrabbable(true);
    this.body.setDensity(this.density);
    this.body.setDamping(0.1);
    
    this.body.setSensor(true);
    this.body.setRotatable(false);
    this.body.setName(name);
    
    // Formatting
    this.body.setFill(random(0, 255), random(0, 255), random(0, 255));
    this.body.setStroke(0, 0, 0);
  }
  
}
