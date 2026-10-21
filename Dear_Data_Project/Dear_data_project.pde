ArrayList<Star> stars = new ArrayList<Star>();
// this list is because there is not a fixed number of stars
int tick =0;
//variable to count how many times the animation has progressed through it loop this is used so the program knows when to make another star

//Recording whether the menu is currently moving up
boolean transitioning = false;
// recods weather the genres p[age should be displayed false is mainmenu and true is the genrespage
boolean genresPage = false;
//controls how far the main menu moves up
float menuOffsetY = 0;







// Downloaded font from DaFont
PFont titleFont;


void setup() {
  fullScreen();
  frameRate(30);
  //makes shapes and lines more smooth
  smooth();
  
  titleFont = createFont("MatchaStyle.ttf", 50);
  textFont(titleFont);
  

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
    //checks which screen should be displayed 
   if (!genresPage) {
     drawMenu();
   } else {
     drawGenresPage();
   }
   
// makes text float upwards when transitioning is true 8 is subtracted
//from the programs vetruicle offset each frame moving the screen upwards
  if (transitioning) {
    menuOffsetY -= 8;
    
  if (menuOffsetY < -height) {
    genresPage = true;
    transitioning = false;
  }
}  
  
    
    
    
}
// draws the main menu title, subtitle and begin button
void drawMenu() {
   pushMatrix();
   //saves drawings transformation
   // shifts down vertically
   translate(0, menuOffsetY);
   
   //Title and its position
   textAlign(CENTER, CENTER);
   textFont(titleFont);
   textSize(height * 0.075);
   fill(255, 248, 166);
   
   text("KIYAH'S DEAR DATA", width * 0.5, height * 0.32);
   
   //subtitle
   textSize(height * 0.027);
   fill(255);
   text("Anime Episode Visualisation", width * 0.5, height * 0.40);
   
   //Begin button width and height and position
   float buttonW = width * 0.18;
   float buttonH = height * 0.085;
   float buttonX = width * 0.5;
   float buttonY = height * 0.55;

   rectMode(CENTER);
   fill(40, 35, 80);
   stroke(255, 248, 166);
   strokeWeight(2);

   rect(buttonX, buttonY, buttonW, buttonH, 15);

   fill(255);
   noStroke();
   textSize(height * 0.032);
  
   text("BEGIN", buttonX, buttonY);
  
   popMatrix();
   
}

// makes the genres page
void drawGenresPage() {
  // Circle positions across the landscape screen, array stores horizontal position
  float[] genreX = {
    width * 0.10, width * 0.26, width * 0.42,
    width * 0.58, width * 0.74, width * 0.90
  };
// array stores vertical position of circles
  float[] genreY = {
    height * 0.48, height * 0.35, height * 0.53,
    height * 0.36, height * 0.53, height * 0.40
  };
// Arrays store matching positions, names and symbols
// so each genre can be drawn using a loop.
  String[] genreNames = {
    "Fantasy", "Historical", "Psychological",
    "Sci-Fi", "Mystery", "Action"
  };

  // Simple symbols for each genre placeholder letters for now, array is used to match symbol, name and position
  String[] genreSymbols = {
    "F", "H", "P", "S", "M", "A"
  };

  float circleSize = min(width * 0.115, height * 0.25);

  // Draw connecting constellation lines first 
  stroke(190, 190, 210, 180);
  strokeWeight(2);
// Tells code how many x positions exisrtt so the loop stops at the second to last circle 
  for (int i = 0; i < genreX.length - 1; i++) {
    line(genreX[i], genreY[i],
         genreX[i + 1], genreY[i + 1]);
  }

  // Heading
  textAlign(CENTER, CENTER);
  textFont(titleFont);
  textSize(height * 0.055);
  fill(255, 248, 166);
  text("CHOOSE A GENRE", width/2, height * 0.14);

  // Draw the circular genre buttons
  for (int i = 0; i < genreNames.length; i++) {
    fill(40, 35, 80);
    stroke(255, 248, 166);
    strokeWeight(2);
// drawing circles,
    ellipse(genreX[i], genreY[i],
            circleSize, circleSize);

    // Symbol inside each circle
    fill(255, 248, 166);
    noStroke();
    textSize(circleSize * 0.35);
    text(genreSymbols[i],
         genreX[i], genreY[i] - circleSize * 0.12);

    // Genre name underneath the symbol
    fill(255);
    textSize(height * 0.022);
    text(genreNames[i],
         genreX[i], genreY[i] + circleSize * 0.22);
  }
}
// activates when begin buttopn is pressed with a mouse, 
void mousePressed() {
 if (!transitioning && !genresPage) {
// checks that the menu isn't moving and the genres page ism't open already

   float buttonW = width * 0.18;
    float buttonH = height * 0.085;
    float buttonX = width * 0.5;
    float buttonY = height * 0.55 + menuOffsetY;

    // Check whether the mouse is inside the button
    if (mouseX > buttonX - buttonW/2 &&
        mouseX < buttonX + buttonW/2 &&
        mouseY > buttonY - buttonH/2 &&
        mouseY < buttonY + buttonH/2) {

      transitioning = true;
    }
  }
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
    /*star class describes what each star should contain and how it behaves, this will give eaach star variables when its created
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
// two pi is a full circles radians so dividing it by ten places each point evenly around a circle 
float outerRadius = 20;
float innerRadius = 10;
beginShape();  
  
// Alternating between outer and inner points
for (int i = 0; i < 10; i++){
  float radius;
  
  // even points use the outer radius and odd use the inner radius which creates the star shape
  if (i % 2== 0) {
    radius = outerRadius;
  }else{
    radius = innerRadius;
  }
  
  float sx = cx + cos(rotation) * radius;
  float sy= cy + sin(rotation) * radius;
  //adds each point to shape
  vertex(sx, sy);
  
  rotation += step;
  }
// connects last point back to first
  endShape(CLOSE);
}

// Animating stars
void update() {
  pushMatrix();
  
  //Move to the stars positiom
  translate(x,y);
  
  //roatate stars. radians convers angle from degrees into radians it needs to be converted to allow starts to rotate while falling
  rotate(radians(angle));
  
  //Change the size smoothly to create twinkling 
  float starScale = map( //map conversts noise values into a scale between 0.2 and 1.0
  noise(time * 0.01),
  //  noise makes smoothly changing values instead of having the values jump randomly
  0, 1,
  0.2, 1.0
);
// makes star smaller or larger depending on value generated
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
    
    
    
