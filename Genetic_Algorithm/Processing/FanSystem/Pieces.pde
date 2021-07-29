

class Vertex {
  int x, y;
  
  Vertex(int x, int y) {
    this.x = x;
    this.y = y;
  }
}

class Piece {
  float damper, points, angle;
  int hits;
  boolean canGoThrough;
  PVector spawnPoint;
  Vertex[] verteces;
  
  Piece(int numVerteces, float maxDistance, float x, float y) {
    this.angle = random(0, 2*PI);
    this.damper = random(1);
    this.points = (int)random(100, 1000);
    this.spawnPoint = new PVector(x, y);
    
    this.verteces = new Vertex[numVerteces];
  }
  
  void display() {
    pushMatrix();
    stroke(0);
    fill((int)(255 * this.damper));
    translate(this.spawnPoint.x, this.spawnPoint.y);
    rotate(this.angle);
    beginShape();
    vertex(15, 0);
    vertex(-15, 15);
    vertex(-15, -15);
    endShape(CLOSE);
    popMatrix();
  }
}
