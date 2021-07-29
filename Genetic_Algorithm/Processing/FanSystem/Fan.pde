import fisica.*;

enum Direction {
  NORTH,
  WEST,
  SOUTH,
  EAST
}

class Fan {
  float angle, fanWidth, fanHeight, windLength, windForce;
  PVector location;
  int cycles = 0;
  FBox wind;
  
  Fan(float angle, float windForce, float fanWidth, float fanHeight, float x, float y) {
    this.angle = angle;
    this.fanWidth = fanWidth;
    this.fanHeight = fanHeight;
    this.windLength = this.fanHeight*0.10;
    this.windForce = windForce;
    this.location = new PVector(x, y);
  }
  
  void setProperties(String name){
    this.wind.setPosition(this.location.x, this.location.y - fanHeight/2 - 10);
    this.wind.setStatic(true);
    //this.wind.setRotation(this.angle);
    this.wind.setRotatable(false);
    this.wind.setSensor(true);
    this.wind.setGrabbable(false);
    this.wind.setName(name);
    
    // Formatting
    this.wind.setStroke(255, 255, 255);
  }
  
  void display() {
    pushMatrix();
    stroke(0);
    fill(175);
    translate(this.location.x, this.location.y);
    rotate(-this.angle + PI/2);
    rect(-this.fanWidth/2, -10, this.fanWidth, 20);
    line(-this.fanWidth/2, (this.fanHeight*0.20) + this.cycles, -this.fanWidth/2, (this.fanHeight*0.20) + this.cycles + this.windLength);
    line(-this.fanWidth/4, (this.fanHeight*0.15) + this.cycles, -this.fanWidth/4, (this.fanHeight*0.15) + this.cycles + this.windLength);
    line(0, (this.fanHeight*0.10) + this.cycles, 0, (this.fanHeight*0.10) + this.cycles + this.windLength);
    line(this.fanWidth/4, (this.fanHeight*0.05) + this.cycles, this.fanWidth/4, (this.fanHeight*0.05) + this.cycles + this.windLength);
    line(this.fanWidth/2, this.cycles, this.fanWidth/2, this.cycles + this.windLength);
    popMatrix();
    this.cycles += (this.cycles > this.fanHeight) ? -this.cycles : 2;
  }
}
