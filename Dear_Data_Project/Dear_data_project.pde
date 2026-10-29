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

//Stores episodes from my CSV file
ArrayList<Episode> episodes = new ArrayList<Episode>();

// controlls which screen is displayed
boolean showAllPage = false;

// rotation and zoom in of 3d data display
float rotationX = 0.3;
float rotationY = 0;
float zoom = 1.0;

//stores the episode the mouse is hovering over
Episode hoveredEpisode =null;

//stores the episode title image
PImage currentImage;

float lastMouseX;
float lastMouseY;
boolean rotatingScene = false;

void setup() {
  fullScreen(P3D);
  frameRate(30);
  //makes shapes and lines more smooth
  smooth(8);
  
  titleFont = createFont("MatchaStyle.ttf", 50);
  textFont(titleFont);
  
  //loads episodes from spreadsheet
  loadEpisodeData();
  

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
    if (showAllPage) {
  draw3DScene();
} else if (!genresPage) {
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
   
   // GENRES button
  float buttonW = width * 0.18;
  float buttonH = height * 0.085;
  float buttonX = width * 0.5;
  float genresY = height * 0.55;

  rectMode(CENTER);
  fill(40, 35, 80);
  stroke(255, 248, 166);
  strokeWeight(2);
  rect(buttonX, genresY, buttonW, buttonH, 15);

  fill(255);
  noStroke();
  textSize(height * 0.032);
  text("GENRES", buttonX, genresY);

  // SHOW ALL button
  float showAllY = height * 0.68;

  fill(40, 35, 80);
  stroke(255, 248, 166);
  strokeWeight(2);
  rect(buttonX, showAllY, buttonW, buttonH, 15);

  fill(255);
  noStroke();
  text("SHOW ALL", buttonX, showAllY);

  popMatrix(); 
   
}

// makes the genres page

void drawGenresPage() {
  // Circle positions across the landscape screen
  float[] genreX = {
    width * 0.10, width * 0.26, width * 0.42,
    width * 0.58, width * 0.74, width * 0.90
  };

  // Vertical positions of circles
  float[] genreY = {
    height * 0.48, height * 0.35, height * 0.53,
    height * 0.36, height * 0.53, height * 0.40
  };

  // Genre names
  String[] genreNames = {
    "Fantasy", "Historical", "Psychological",
    "Sci-Fi", "Mystery", "Action"
  };

  // Symbols for each genre
  String[] genreSymbols = {
    "F", "H", "P", "S", "M", "A"
  };

  // Circle size and radius
  float circleSize = min(width * 0.115, height * 0.25);
  float circleRadius = circleSize / 2;

  // Draw connecting constellation lines first
  stroke(190, 190, 210, 180);
  strokeWeight(2);

  for (int i = 0; i < genreX.length - 1; i++) {
    float x1 = genreX[i];
    float y1 = genreY[i];
    float x2 = genreX[i + 1];
    float y2 = genreY[i + 1];

    // Direction between the circles
    float dx = x2 - x1;
    float dy = y2 - y1;
    float distanceBetween = dist(x1, y1, x2, y2);

    // Shorten the line so it stops at the circle edges
    float shortenX = dx / distanceBetween * circleRadius;
    float shortenY = dy / distanceBetween * circleRadius;

    line(
      x1 + shortenX, y1 + shortenY,
      x2 - shortenX, y2 - shortenY
    );
  }

  // Heading
  textAlign(CENTER, CENTER);
  textFont(titleFont);
  textSize(height * 0.055);
  fill(255, 248, 166);
  text("CHOOSE A GENRE", width / 2, height * 0.14);

  // Draw the circular genre buttons over the lines
  for (int i = 0; i < genreNames.length; i++) {
    fill(40, 35, 80);
    stroke(255, 248, 166);
    strokeWeight(2);

    ellipse(
      genreX[i], genreY[i],
      circleSize, circleSize
    );

    // Symbol inside each circle
    fill(255, 248, 166);
    noStroke();
    textSize(circleSize * 0.35);
    text(
      genreSymbols[i],
      genreX[i], genreY[i] - circleSize * 0.12
    );

    // Genre name underneath the symbol
    fill(255);
    textSize(height * 0.022);
    text(
      genreNames[i],
      genreX[i], genreY[i] + circleSize * 0.22
    );
  }
}

// activates when begin buttopn is pressed with a mouse, 
void mousePressed() {
  
  
  lastMouseX = mouseX;
  lastMouseY = mouseY;
  // If the 3D page is open, allow the Back button
  if (showAllPage) {
    if (mouseX < 130 && mouseY < 70) {
      showAllPage = false;
      return;
    }

    // Start rotating the 3D scene
    return;
  }

  // Main menu buttons
  if (!transitioning && !genresPage) {
    float buttonW = width * 0.18;
    float buttonH = height * 0.085;
    float buttonX = width * 0.5;

    float genresY = height * 0.55 + menuOffsetY;
    float showAllY = height * 0.68 + menuOffsetY;

    // Click GENRES
    if (mouseX > buttonX - buttonW / 2 &&
        mouseX < buttonX + buttonW / 2 &&
        mouseY > genresY - buttonH / 2 &&
        mouseY < genresY + buttonH / 2) {
      transitioning = true;
    }

    // Click SHOW ALL
    else if (mouseX > buttonX - buttonW / 2 &&
             mouseX < buttonX + buttonW / 2 &&
             mouseY > showAllY - buttonH / 2 &&
             mouseY < showAllY + buttonH / 2) {
      showAllPage = true;
    }
  }
}

void mouseDragged() {
  if (showAllPage) {
    rotationY += (mouseX - lastMouseX) * 0.01;
    rotationX += (mouseY - lastMouseY) * 0.01;
  }

  lastMouseX = mouseX;
  lastMouseY = mouseY;
}

void mouseReleased() {
  rotatingScene = false;
}


void mouseWheel(processing.event.MouseEvent event) {
  float scroll = event.getCount();

  // Scroll up to zoom in and down to zoom out
  zoom -= scroll * 0.1;

  // Prevent the scene from becoming too tiny or too large
  zoom = constrain(zoom, 0.4, 3.0);
}


void loadEpisodeData() {
  Table data = loadTable("anime_data.csv", "header");

  if (data == null) {
    println("ERROR: can't load anime_data.csv");
    return;
  }

  println("Rows found: " + data.getRowCount());

  for (TableRow row : data.rows()) {
    String title = row.getString("Title");

    // Ignore empty rows
    if (title == null || title.trim().isEmpty()) {
      continue;
    }

    String genre = row.getString("Genre");
    String episodeNumber = row.getString("episode number");
    String durationText = row.getString("length of episode");
    String feeling = row.getString("How did the episode make me feel?");
    String rankingText = row.getString("Episode ranking out of 10");
    String memory = row.getString("How memorable was the episode ");
    String date = row.getString("Date watched");
    String watchedBefore = row.getString("Watched before");
    String imageName = row.getString("Image");

    // Convert text into numbers
    int duration = parseNumber(durationText);
    int ranking = parseNumber(rankingText);

    // Create one episode from this spreadsheet row
    Episode episode = new Episode(
      title, genre, episodeNumber, feeling, ranking,
      duration, memory, date, watchedBefore, imageName
    );

    episodes.add(episode);
  } // Ends the for loop

  println("Episodes loaded: " + episodes.size());
} // Ends loadEpisodeData()
  
// removes non numeric characters 
int ParseNumber(String value) {
  if (value == null){
    return 0;
  }
  // keep only the digits
  String digits = value.replaceAll("[^0-9","");
  
  if (digits.isEmpty()) {
    return 0;
  }
  
    return int(digits);
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
    
class Episode {
  String title;
  String genre;
   String episodeNumber;
  String feeling;
  String memory;
  String dateWatched;
  String watchedBefore;

  int ranking;
  int duration;

  float angle;
  float distance;
  float bubbleSize;

  float xScreen;
  float yScreen;
  float zScreen;
  float verticalPosition;
  color genreColour;
  color glowColour;

  PImage animeImage;
  
  Episode(
    String title, String genre, String episodeNumber,
    String feeling, int ranking, int duration,
    String memory, String dateWatched,
    String watchedBefore, String imageName
  ) {
    this.title = title;
    this.genre = genre;
    this.episodeNumber = episodeNumber;
    this.feeling = feeling;
    this.ranking = ranking;
    this.duration = duration;
    this.memory = memory;
    this.dateWatched = dateWatched;
    this.watchedBefore = watchedBefore;

     // Spread episodes around the centre in a spiral
  angle = episodes.size() * 2.399963f;
  
  // Increase the distance from the centre for each new episode
  distance = 65 + 34 * sqrt(episodes.size());
  
  // Give each episode a stable vertical position
  verticalPosition = random(-100, 100);
  
  // Ranking determines the circle size
  bubbleSize = map(constrain(ranking, 1, 10), 1, 10, 10, 32);

    // Choose colours from the spreadsheet values
    genreColour = getGenreColour(genre);
    glowColour = getFeelingColour(feeling);

    // Load the optional image from data/images
    if (imageName != null && !imageName.trim().isEmpty()) {
      animeImage = loadImage("images/" + imageName.trim());

     if (animeImage == null) {
        println("Image not found: " + imageName);
      }
    }
  } // Ends the Episode constructor

  void display() {
    // Duration controls distance from centre
    float x = cos(angle) * distance;
    float z = sin(angle) * distance;

    float y = verticalPosition;

    pushMatrix();
    translate(x, y, z);

    // Decide how strong the glow should be
    float glowStrength = getMemoryScore(memory) * 12;

    noStroke();

    // Draw three transparent layers around the sphere
    for (int i = 3; i >= 1; i--) {
      fill(
        red(glowColour),
        green(glowColour),
        blue(glowColour),
        glowStrength / i
      );

      sphere(bubbleSize + i * 5);
    }

    // Main sphere uses the genre colour
      // Main sphere is fully solid
    noStroke();
    fill(
      red(genreColour),
      green(genreColour),
      blue(genreColour),
      255
    );
    sphere(bubbleSize);

    // Add a ring if the episode was watched before
    if (watchedBefore != null &&
        watchedBefore.trim().equalsIgnoreCase("Y")) {
      noFill();
      stroke(255, 245, 180);
      strokeWeight(2);
      sphere(bubbleSize + 3);
      noStroke();
    }

    // Record the sphere's screen position for hovering
    xScreen = screenX(0, 0, 0);
    yScreen = screenY(0, 0, 0);
    zScreen = screenZ(0, 0, 0);

    float screenRadius = bubbleSize * zoom;

    if (dist(mouseX, mouseY, xScreen, yScreen)
        < screenRadius + 6 && zScreen < 1) {
      hoveredEpisode = this;
    }

    popMatrix();

    // Slowly rotate the sphere's position around the centre
    angle += 0.002;
  }
}

int getMemoryScore(String memory) {
  if (memory == null) return 5;

  String value = memory.toLowerCase().trim();

  if (value.equals("slightly")) return 3;
  if (value.equals("moderate")) return 5;
  if (value.equals("very")) return 8;
  if (value.equals("unforgettable")) return 10;

  return 5;
}
   
color getGenreColour(String genre) {
  if (genre == null) return color(175, 170, 190);
  
  String g = genre.toLowerCase();
  
  if (g.contains("dark fantasy")) return color(90, 45, 130);
  if (g.contains("fantasy")) return color(175, 110, 225);
   if (g.contains("historical")) return color(235, 185, 80);
  if (g.contains("action")) return color(245, 90, 100);
  if (g.contains("drama")) return color(90, 150, 255);
  if (g.contains("sci-fi") || g.contains("sci fi")) return color(70, 220, 220);
  if (g.contains("mystery")) return color(255, 140, 100);

  return color(170, 170, 190);







}

color getFeelingColour(String feeling) {
  if (feeling == null) return color(170, 175, 195);

  String f = feeling.toLowerCase();

  if (f.contains("tense") && f.contains("excited")) {
    return lerpColor(
      color(255, 55, 75),
      color(255, 135, 35),
      0.5
    );
  }

  if (f.contains("tense") && f.contains("amazed")) {
    return lerpColor(
      color(255, 55, 75),
      color(50, 235, 255),
      0.5
    );
  }

  if (f.contains("happy") && f.contains("tense")) {
    return lerpColor(
      color(255, 225, 60),
      color(255, 55, 75),
      0.5
    );
  }

  if (f.contains("excited")) return color(255, 135, 35);
  if (f.contains("sad")) return color(65, 120, 255);
  if (f.contains("tense")) return color(255, 55, 75);
  if (f.contains("happy")) return color(255, 225, 60);
  if (f.contains("fascinated")) return color(185, 75, 255);
  if (f.contains("amazed")) return color(50, 235, 255);

  return color(170, 175, 195);
}

int parseNumber(String value) {
  if (value == null) {
    return 0;
  }

  // Remove words and symbols, leaving only digits
  String digits = value.replaceAll("[^0-9]", "");

  if (digits.isEmpty()) {
    return 0;
  }

  return int(digits);
}


void draw3DScene() {
  background(12, 15, 30);

  camera();
  lights();

  // Draw stars first, behind the episode spheres
  hint(DISABLE_DEPTH_TEST);
  for (Star star : stars) {
    star.create(star.x, star.y);
  }
  hint(ENABLE_DEPTH_TEST);

  // Draw the 3D episode scene afterwards
  pushMatrix();
  translate(width / 2, height / 2, 0);
  scale(zoom);
  rotateX(rotationX);
  rotateY(rotationY);

  // Centre and rotate the episode arrangement
  pushMatrix();
  translate(width / 2, height / 2, 0);
  scale(zoom);
  rotateX(rotationX);
  rotateY(rotationY);

  // Draw a placeholder for the central character
  noStroke();
  fill(240, 205, 235);
  sphere(45);

  // Draw every episode loaded from the CSV
  hoveredEpisode = null;

  for (Episode e : episodes) {
    e.display();
  }

  popMatrix();

  drawEpisodeInfo();
  drawBackButton();
}

void drawEpisodeInfo() {
  if (hoveredEpisode == null) return;

  Episode e = hoveredEpisode;

  // Switch back to screen-based drawing for the panel
  camera();
  hint(DISABLE_DEPTH_TEST);

  float panelX = width - 340;
  float panelY = 35;
  float panelW = 305;
  float panelH = 390;

  rectMode(CORNER);
  noStroke();
  fill(35, 35, 65, 235);
  rect(panelX, panelY, panelW, panelH, 15);

  fill(255, 248, 166);
  textAlign(LEFT, TOP);
  textFont(titleFont);
  textSize(22);
  text(e.title, panelX + 15, panelY + 15, panelW - 30, 50);

  // Display the anime image, if one was loaded
  float imageX = panelX + 15;
  float imageY = panelY + 75;
  float imageW = panelW - 30;
  float imageH = 120;

  if (e.animeImage != null) {
    float ratio = min(
      imageW / e.animeImage.width,
      imageH / e.animeImage.height
    );

    imageMode(CENTER);
    image(
      e.animeImage,
      imageX + imageW / 2,
      imageY + imageH / 2,
      e.animeImage.width * ratio,
      e.animeImage.height * ratio
    );
    imageMode(CORNER);
  } else {
    fill(180, 180, 205);
    textFont(createFont("SansSerif", 14));
    text("No image loaded", imageX, imageY + 50);
  }

  fill(255);
  textFont(createFont("SansSerif", 14));
  text(
    "Episode: " + e.episodeNumber +
    "\nGenre: " + e.genre +
    "\nDuration: " + e.duration + " minutes" +
    "\nRanking: " + e.ranking + "/10" +
    "\nFeeling: " + e.feeling +
    "\nMemorability: " + e.memory +
    "\nDate watched: " + e.dateWatched +
    "\nWatched before: " + e.watchedBefore,
    panelX + 15, panelY + 210
  );

  hint(ENABLE_DEPTH_TEST);
  
}

void drawBackButton() {
  camera();
  hint(DISABLE_DEPTH_TEST);

  rectMode(CORNER);
  fill(40, 35, 80);
  stroke(255, 248, 166);
  strokeWeight(2);
  rect(20, 20, 100, 40, 10);

  fill(255);
  noStroke();
  textAlign(CENTER, CENTER);
  textFont(createFont("SansSerif", 16));
  text("BACK", 70, 40);

  hint(ENABLE_DEPTH_TEST);
}
