class Ball {
  float x, y;
  float diameter;
  float vx = 0;
  float vy = 0;
  int id;
  color ballFill;
  String state;
  Ball[] others;

  Ball(float xin, float yin, float din, int idin, Ball[] oin, color Fill, String ballState) {
    x = xin;
    y = yin;
    diameter = din;
    id = idin;
    others = oin;
    ballFill = Fill;
    state = ballState;
    
  } 

  void collide() {
    for (int i = id + 1; i < numStates; i++) {
      float dx = others[i].x - x;
      float dy = others[i].y - y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = others[i].diameter/2 + diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = x + cos(angle) * minDist;
        float targetY = y + sin(angle) * minDist;
        float ax = (targetX - others[i].x) * spring;
        float ay = (targetY - others[i].y) * spring;
        vx -= ax;
        vy -= ay;
        others[i].vx += ax;
        others[i].vy += ay;
      }
    }
  }

  void move() {
    vy += gravity;
    x += vx;
    y += vy;
    if (x + diameter/2 > width) {
      x = width - diameter/2;
      vx *= friction;
    }
    else if (x - diameter/2 < 0) {
      x = diameter/2;
      vx *= friction;
    }
    if (y + diameter/2 > height) {
      y = height - diameter/2;
      vy *= friction;
    } 
    else if (y - diameter/2 < 0) {
      y = diameter/2;
      vy *= friction;
    }
  }

  void display() {
    fill(ballFill);
    if (mouseX > x - diameter/2 && mouseX < x + diameter/2 &&
      mouseY > y - diameter/2 && mouseY < y + diameter/2) {
        ballSelected = true;
        selectedState = state;
      }
    if(state == selectedState){
        stroke(255);
        strokeWeight(5);
      }
    else {
      noStroke();
    }
    ellipse(x, y, diameter, diameter);
  }
  
}

