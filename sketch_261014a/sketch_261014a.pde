void setup () {
  size(1400, 20);
  stroke(32);
  textSize(20);
  textAlign(RIGHT,CENTER);
  fill(32,200);
}


void draw() {
  int mm = minute();
  int ss = second();
  
  if (mm<40) {
    background(220);
  } else if (mm<45) {
    background(255, 255, 64);
  } else if (mm<50) {
    background(255, 128, 64);
  } else {
    background(255, 0, 0);
  }
  
  float mmEnd = map(mm, 0,60, 0,width); 
  float ssEnd = map(ss, 0,60, 0,width); 
  
  strokeWeight(4);
  line(0,6,mmEnd,6);
  
  strokeWeight(1);
  line(0,14,ssEnd,14);
  
  text(nf(mm,2)+":"+nf(ss,2),width-5,height/2);
  
  // -- 50 min line:
  line(map(50, 0,60, 0,width), 0, map(50, 0,60, 0,width), height);
}
