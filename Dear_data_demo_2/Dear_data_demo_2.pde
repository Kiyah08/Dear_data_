ArrayList<Star> stars = new ArrayList<Star>();
// this list is because there is not a fixed number of stars
int tick =0;
//variable to count how many times the animation has progressed through it loop this is used so the program knows when to make another star




void setup() {
  fullScreen();
  frameRate(30);
  smooth();
  

}
// background
void draw() {
  //Night sky colour for background
  background(30, 35, 55);
  
  // Creating a new star for every 8 frames if stars were not redraw it would leave trails and make the animation look unclean
  if (tick % 8 ==0) {
    stars.add(new Star());



}

// allow stars to update and remove them when they fall off screen

 // Update stars and remove those that leave the screen
  for (int i = stars.size() - 1; i >= 0; i--) {
    Star star = stars.get(i);

    star.update();

    // Remove stars that move offscreen
    if (star.y > height + 50) {
      stars.remove(i);
    }
  }

  tick++;
    
    
}

//  Star Class
  class Star {
    float x;
    float y;
    float time;
    float acceleration;
    float angle;
    float size;
    
    int starColour;
    boolean filled;
    /*class describes what each star should contain and how it behaves, this will give eaach star variables when its created
     such as the stars positions, angles, speed, colour and rotation */
 
//Constructor to setup new stars, runs automatically whenevever new star is made
Star(){
  x = random(width);
  y = random(-200,-20);
  time = 1;
  angle = 0;
  size = random(5, 12);
  float spin = random (-5, 5);
  
  //star roatation
  if (abs(spin) < 1) {  /* checks if spin value is less than 1 and abs makes sure negative numbers are turned into positives 
  this makes sure no stars spin value is really low */
    spin = 1;
  
  
  }
  
  acceleration = spin;
  
      // Random colour palette for the stars
    int[] starColours = {
      color(255, 248, 166), // yellow
      color(255, 200, 100), //  orange
      color(255, 170, 190), // pink
      color(220, 180, 255), // Lavender
      color(160, 210, 255), // blue
      color(180, 255, 240), // Mint
      color(255, 255, 255)  // White
    };
  
    starColour = starColours[int(random(starColours.length))];
    
// this makes every star pick a random color when its made and makes it so the colour is consistant when the star is spinning and falling


filled = random(1) > 0.5;
//makes star randomly filled or outlined

}


  
// making star shape
void create(float cx, float cy) {
  strokeWeight(3);
  stroke(starColour);
  strokeJoin(ROUND);
  
  if (filled) {
    fill(starColour);
  } else {
    noFill();
}
  
float rotation = -HALF_PI;
float step = TWO_PI / 10;

float outerRadius = 20;
float innerRadius = 10;
  
beginShape();  
  
// Alternating between outer and inner points
for (int i = 0; i < 10; i++){
  float radius;
  
  if (i % 2== 0) {
    radius = outerRadius;
  }else{
    radius = innerRadius;
  }
  
  float sx = cx + cos(rotation) * radius;
  float sy= cy + sin(rotation) * radius;
  
  vertex(sx, sy);
  
  rotation += step;
  }

  endShape(CLOSE);
}

// Animating stars
void update() {
  pushMatrix();
  
  //Move to the stars positiom
  translate(x,y);
  
  //roatate stars
  rotate(radians(angle));
  
  //Change the size smoothly to create twinkling 
  float starScale = map(
  noise(time * 0.01),
  0, 1,
  0.2, 1.0
);

  scale(starScale);

// draw the star around its centere
   create(0, 0);
   popMatrix();
   
   // allow star to move down the screen
   y += time * 0.01;

// increase speed over time
  time += abs(acceleration);
  
  //rotate
  angle += acceleration;

  }
}
    
    
    
