class Target {
  PVector location;
  float r1, r2, r3, r4;
  
  Target(float x, float y){
    this.location = new PVector(x, y);
    this.r4 = 100;
    this.r3 = 50;
    this.r2 = 25;
    this.r1 = 10;
  }
  
  void display() {
    pushMatrix();
    stroke(0);
    fill(200);
    ellipse(this.location.x, this.location.y, this.r4, this.r4);
    
    stroke(0);
    fill(150);
    ellipse(this.location.x, this.location.y, this.r3, this.r3);
    
    stroke(0);
    fill(100);
    ellipse(this.location.x, this.location.y, this.r2, this.r2);
    
    stroke(0);
    fill(100);
    ellipse(this.location.x, this.location.y, this.r1, this.r1);
    
    popMatrix();
  }
}
