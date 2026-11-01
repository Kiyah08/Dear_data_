ArrayList<Star> stars = new ArrayList<Star>();
int tick = 0;

// Menu and page controls these variables allow the pages to switch between themselves
boolean transitioning = false;
boolean genresPage = false;
boolean showAllPage = false;
float menuOffsetY = 0;

// Font used for title
PFont titleFont;

// stores data from my CSV file
ArrayList<Episode> episodes = new ArrayList<Episode>();
Episode hoveredEpisode = null;

// this is used to control the rotation and zoom of my data on the show all page
float rotationX = 0.3;
float rotationY = 0;
float zoom = 1.0;
float lastMouseX;
float lastMouseY;

void setup() {
  fullScreen(P3D);
  frameRate(30);
  smooth(8);
// loads the font for my heading
  titleFont = createFont("MatchaStyle.ttf", 50);
  textFont(titleFont);
// loads my episode datat when the sketch begins
  loadEpisodeData();
}

void draw() {
  // show all button has its own background and 3D scene seperate from menu
  if (showAllPage) {
    draw3DScene();
    return;
  }

  // Night-sky background for the menu and genre page.
  background(30, 35, 55);

  // Create a new star every 8 frames for background effect
  if (tick % 8 == 0) {
    stars.add(new Star());
  }

  // moves the stars down the screen and removes them when they have gone off screen
  for (int i = stars.size() - 1; i >= 0; i--) {
    Star star = stars.get(i);
    star.update();

    if (star.y > height + 50) {
      stars.remove(i);
    }
  }

  tick++;

  // Move the menu upwards when the genres button is pressed
  if (transitioning) {
    menuOffsetY -= 8;

    if (menuOffsetY < -height) {
      genresPage = true;
      transitioning = false;
    }
  }

  // shows the genres page after the menu has moved off screen
  if (genresPage) {
    drawGenresPage();
  } else {
    drawMenu();
  }
}


// main menu screen

void drawMenu() {
  pushMatrix();
  // applies the vertical movement for the menu transition
  translate(0, menuOffsetY);

  textAlign(CENTER, CENTER);
  textFont(titleFont);
  textSize(height * 0.075);
  fill(255, 248, 166);
// main title
  text("KIYAH'S DEAR DATA", width * 0.5, height * 0.32);

  // Subtitle
  textSize(height * 0.027);
  fill(255);
  text("Anime Episode Visualisation", width * 0.5, height * 0.40);
// button dimensions change with screen size
  float buttonW = width * 0.18;
  float buttonH = height * 0.085;
  float buttonX = width * 0.5;

  // genres button
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

  // show all button
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


// genres selection page

void drawGenresPage() {
  // postion for six genre options
  float[] genreX = {
    width * 0.10, width * 0.26, width * 0.42,
    width * 0.58, width * 0.74, width * 0.90
  };

  float[] genreY = {
    height * 0.48, height * 0.35, height * 0.53,
    height * 0.36, height * 0.53, height * 0.40
  };
// names shown underneath symbol
  String[] genreNames = {
    "Fantasy", "Historical", "Psychological",
    "Sci-Fi", "Mystery", "Action"
  };
// place holder for genre symbols for now i just put letters
  String[] genreSymbols = {
    "F", "H", "P", "S", "M", "A"
  };
// keeps circles proportinal to screens dimensions
  float circleSize = min(width * 0.115, height * 0.25);
  float circleRadius = circleSize / 2;

  // Draw connecting lines before drawing the circlesso the lines don't overlap with buttons
  stroke(190, 190, 210, 180);
  strokeWeight(2);

  for (int i = 0; i < genreX.length - 1; i++) {
    float x1 = genreX[i];
    float y1 = genreY[i];
    float x2 = genreX[i + 1];
    float y2 = genreY[i + 1];
// finds distance and direction between circles
    float dx = x2 - x1;
    float dy = y2 - y1;
    float distanceBetween = dist(x1, y1, x2, y2);
// shortens line so it meets edge of circle
    float shortenX = dx / distanceBetween * circleRadius;
    float shortenY = dy / distanceBetween * circleRadius;

    line(
      x1 + shortenX, y1 + shortenY,
      x2 - shortenX, y2 - shortenY
    );
  }

  // Page heading
  textAlign(CENTER, CENTER);
  textFont(titleFont);
  textSize(height * 0.055);
  fill(255, 248, 166);
  text("CHOOSE A GENRE", width / 2, height * 0.14);

  // draws genre circles, letters and genre names
  for (int i = 0; i < genreNames.length; i++) {
    fill(40, 35, 80);
    stroke(255, 248, 166);
    strokeWeight(2);

    ellipse(
      genreX[i], genreY[i],
      circleSize, circleSize
    );

    // Symbol
    fill(255, 248, 166);
    noStroke();
    textSize(circleSize * 0.35);
    text(
      genreSymbols[i],
      genreX[i], genreY[i] - circleSize * 0.12
    );

    // Genre name
    fill(255);
    textSize(height * 0.022);
    text(
      genreNames[i],
      genreX[i], genreY[i] + circleSize * 0.22
    );
  }
}


// mouse and the page controls

void mousePressed() {
  // remembers where the mouse has clickded so the dragging controls can figure out how far its moved
  lastMouseX = mouseX;
  lastMouseY = mouseY;

  // checks for a click on the back button when in the show all page
  if (showAllPage) {
    // coordinates match the position of back button
    if (mouseX >= 20 && mouseX <= 120 &&
        mouseY >= 20 && mouseY <= 60) {
      showAllPage = false;
      return;
    }
// ignore the rest of the menu buttons on the page
    return;
  }

  // Only allows the menu buttons to be clicked when the menu is showing and no transition is happening
  if (!transitioning && !genresPage) {
    // use the same button sizes and positions is the drawMenu() method
    float buttonW = width * 0.18;
    float buttonH = height * 0.085;
    float buttonX = width * 0.5;
// inclues the menus movement when checking the button position
    float genresY = height * 0.55 + menuOffsetY;
    float showAllY = height * 0.68 + menuOffsetY;

    // checks if mouse is clicked within the genres button
    if (mouseX > buttonX - buttonW / 2 &&
        mouseX < buttonX + buttonW / 2 &&
        mouseY > genresY - buttonH / 2 &&
        mouseY < genresY + buttonH / 2) {
      transitioning = true;
    }// if true the animation that moves the menu up starts playing

    // if not check is the show all button was pressed
    else if (mouseX > buttonX - buttonW / 2 &&
             mouseX < buttonX + buttonW / 2 &&
             mouseY > showAllY - buttonH / 2 &&
             mouseY < showAllY + buttonH / 2) {
      showAllPage = true;
      stars.clear();
    }// if yes open the 3d data visulisation and remove the star background
  }
}

void mouseDragged() {
  // Dragging the mouse rotates the 3d visulisation
  if (showAllPage) {
    // vertical movement changes the rotation around x axis and horizontal moves around y axis
    rotationY += (mouseX - lastMouseX) * 0.01;
    rotationX += (mouseY - lastMouseY) * 0.01;
  }
// saves the current position so the next movement is mesures from there insteadoif the original click
  lastMouseX = mouseX;
  lastMouseY = mouseY;
}

void mouseWheel(processing.event.MouseEvent event) {
  // gets the direction and amous on the mouse wheel movement
  float scroll = event.getCount();
// adjusts the zoom depending on how far the wheel moves
  zoom -= scroll * 0.1;
  // keeos the zoom between 0.4 and 3 so the scene is not too big or small
  zoom = constrain(zoom, 0.4, 3.0);
}


// 

void loadEpisodeData() {
  //loads the CVS file and uses the first row as the column headings
  Table data = loadTable("anime_data.csv", "header");
// stop here if file can't be loaded
  if (data == null) {
    println("ERROR: Can't load anime_data.csv");
    return;
  }
// print the number of rows found to checkthat the file has loaded
  println("Rows found: " + data.getRowCount());
// go through each row to get the information for an episode
  for (TableRow row : data.rows()) {
    String title = row.getString("Title");

    // Ignore empty rows.
    if (title == null || title.trim().isEmpty()) {
      continue;
    }
// gets the episode details using these column names in the CVS file
    String genre = row.getString("Genre");
    String episodeNumber = row.getString("episode number");
    String durationText = row.getString("length of episode");
    String feeling = row.getString("How did the episode make me feel?");
    String rankingText = row.getString("Episode ranking out of 10");
    String memory = row.getString("How memorable was the episode ");
    String date = row.getString("Date watched");
    String watchedBefore = row.getString("Watched before");
    String imageName = row.getString("Image");
// converts duration and ranking colums into numbers
    int duration = parseNumber(durationText);
    int ranking = parseNumber(rankingText);
// creates an eppisode object using the information from this row
    Episode episode = new Episode(
      title, genre, episodeNumber, feeling, ranking,
      duration, memory, date, watchedBefore, imageName
    );
// add the new episode to the list used in the visualisation
    episodes.add(episode);
  }
// print how many episodes were sucsessfully added
  println("Episodes loaded: " + episodes.size());
}


// converts text into numbers so its easier for java to understand

int parseNumber(String value) {
  if (value == null) {
    return 0;
  }// returns zero if there is no value to convert
// removes letters/ symbols only leaving digits
  String digits = value.replaceAll("[^0-9]", "");
// checks if there are digits left to convert
  if (digits.isEmpty()) {
    return 0;
  }
// converts renmaining digits into a integer
  return int(digits);
}


// STAR CLASS

class Star {
  // position, movement and rotation of star animation
  float x;
  float y;
  float time;
  float acceleration;
  float angle;
  float size;
// eacxh star has its owm colour and fill style
  int starColour;
  boolean filled;

  Star() {
    // starts each star at a random posiy=tion above the screen
    x = random(width);
    y = random(-200, -20);
    time = 1;
    angle = 0;
    size = random(5, 12);
// gives the star a random spinning speed
    float spin = random(-5, 5);
// makes sure star dosen't spin too slowly
    if (abs(spin) < 1) {
      spin = 1;
    }

    acceleration = spin;
// selection of colours for the stars to randomly choose
    int[] starColours = {
      color(255, 248, 166),
      color(255, 200, 100),
      color(255, 170, 190),
      color(220, 180, 255),
      color(160, 210, 255),
      color(180, 255, 240),
      color(255, 255, 255)
    };
// picks colour at random
    starColour = starColours[int(random(starColours.length))];
    // randomly chooses if star is filled or only has a outline
    filled = random(1) > 0.5;
  }

  // Draw the star shape using 10 alternating points
  void create(float cx, float cy) {
    strokeWeight(3);
    stroke(starColour);
    strokeJoin(ROUND);

    if (filled) {
      fill(starColour);
    } else {
      noFill();
    }
// alternate between the outer and inner points to create the five points stars have
    float rotation = -HALF_PI;
    float step = TWO_PI / 10;
    float outerRadius = 20;
    float innerRadius = 10;

    beginShape();

    for (int i = 0; i < 10; i++) {
      float radius;
// every other point uses the smaller radius
      if (i % 2 == 0) {
        radius = outerRadius;
      } else {
        radius = innerRadius;
      }
// calculates were next point shouldbe drawn
      float sx = cx + cos(rotation) * radius;
      float sy = cy + sin(rotation) * radius;

      vertex(sx, sy);
      rotation += step;
    }

    endShape(CLOSE);
  }

  // updates the stars apperance and movement for each frame
  void update() {
    pushMatrix();
// moves to the stars position before rotating it
    translate(x, y);
    rotate(radians(angle));
// use noise to make the star grown and shrink smoothly
    float starScale = map(
      noise(time * 0.01),
      0, 1,
      0.2, 1.0
    );

    scale(starScale);
    create(0, 0);

    popMatrix();
// moves the star down and updates it rotation
    y += time * 0.01;
    time += abs(acceleration);
    angle += acceleration;
  }
}


// Episode class
// information about each episode from my CVS file
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
// values used to arrange the episodes in 3D
  float angle;
  float distance;
  float bubbleSize;
// screen position of the spere used when checking the mouse
  float xScreen;
  float yScreen;
  float zScreen;
  float verticalPosition;
// colours are based on the genre and the recorded fellings are the glow
  color genreColour;
  color glowColour;
// stores the episode image
  PImage animeImage;

  Episode(
    String title, String genre, String episodeNumber,
    String feeling, int ranking, int duration,
    String memory, String dateWatched,
    String watchedBefore, String imageName
  ) {
    //save the information passed into the constructor
    this.title = title;
    this.genre = genre;
    this.episodeNumber = episodeNumber;
    this.feeling = feeling;
    this.ranking = ranking;
    this.duration = duration;
    this.memory = memory;
    this.dateWatched = dateWatched;
    this.watchedBefore = watchedBefore;

    // Arrange episodes in a spiral.
    angle = episodes.size() * 2.399963f;
    distance = 65 + 34 * sqrt(episodes.size());
    // adds vertical variation so the sheres aren't all level
    verticalPosition = random(-100, 100);

    // uses ranking to determain size of the sphere from 1-10
    bubbleSize = map(
      constrain(ranking, 1, 10),
      1, 10,
      10, 32
    );
// choses colours using episodes genre and feeliing
    genreColour = getGenreColour(genre);
    glowColour = getFeelingColour(feeling);

    // Load an image from data/images.
    if (imageName != null && !imageName.trim().isEmpty()) {
      animeImage = loadImage("images/" + imageName.trim());
// prints a message if the image couldn't be found
      if (animeImage == null) {
        println("Image not found: " + imageName);
      }
    }
  }
// 
  void display() {
    // calculates sheres position using its angle and distance
    float x = cos(angle) * distance;
    float z = sin(angle) * distance;
    float y = verticalPosition;

    pushMatrix();
    translate(x, y, z);
// memrobility effects strength of glow
    float glowStrength = getMemoryScore(memory) * 12;

    noStroke();

    // Transparent glow layers.
    for (int i = 3; i >= 1; i--) {
      fill(
        red(glowColour),
        green(glowColour),
        blue(glowColour),
        glowStrength / i
      );

      sphere(bubbleSize + i * 5);
    }

    // draw main shere using genre colours
    noStroke();
    fill(
      red(genreColour),
      green(genreColour),
      blue(genreColour),
      255
    );
    sphere(bubbleSize);

    // Add a ring if the episode was watched before.
    if (watchedBefore != null &&
        watchedBefore.trim().equalsIgnoreCase("Y")) {
      noFill();
      stroke(255, 245, 180);
      strokeWeight(12);
      sphere(bubbleSize + 3);
      noStroke();
    }

    // Store the sphere's screen position so the program can detect when the mouse is hovering over it
    xScreen = screenX(0, 0, 0);
    yScreen = screenY(0, 0, 0);
    zScreen = screenZ(0, 0, 0);
// estimate the sphers size on screen and takes zoom into account
    float screenRadius = bubbleSize * zoom;
// checks if mouse is close enought to the sphere and if the shere is withing the visable depth range
    if (dist(mouseX, mouseY, xScreen, yScreen) < screenRadius + 6
        && zScreen < 1) {
          // saves this episode so its information can be displayes
      hoveredEpisode = this;
    }
// restore the previous drawing settings
    popMatrix();

    // Slowly rotate each episode around the centre.
    angle += 0.002;
  }
}


// MEMORABILITY SCORE

int getMemoryScore(String memory) {
  // uses a middle score if no memrobility value is provided
  if (memory == null) {
    return 5;
  }
// converts awner to lowercase and removes extra spaces
  String value = memory.toLowerCase().trim();

  if (value.equals("slightly")) return 3;
  if (value.equals("moderate")) return 5;
  if (value.equals("very")) return 8;
  if (value.equals("unforgettable")) return 10;
// return defult score if the awwnser does not match any option
  return 5;
}


// GENRE COLOURS

color getGenreColour(String genre) {
  // returns a netural colour if genre is missing
  if (genre == null) {
    return color(175, 170, 190);
  }
// converts the genre into lowercase
  String g = genre.toLowerCase();
// assign diffrent colours baseed on genre, alternate versions of a specific genre like dark fantasy will be a darker or lighter colour then the broader genre
  if (g.contains("dark fantasy")) return color(90, 45, 130);
  if (g.contains("fantasy")) return color(175, 110, 225);
  if (g.contains("historical")) return color(235, 185, 80);
  if (g.contains("action")) return color(245, 90, 100);
  if (g.contains("drama")) return color(90, 150, 255);
  if (g.contains("sci-fi") || g.contains("sci fi")) {
    return color(70, 220, 220);
  }
  // allows two diffrent ways to write sci fi
  if (g.contains("mystery")) return color(255, 140, 100);
// uses netural colour if genre is not recognised
  return color(170, 170, 190);
}


// FEELING COLOURS

color getFeelingColour(String feeling) {
  // return netural colour if no feeling is recorded
  if (feeling == null) {
    return color(170, 175, 195);
  }
// convert into lowercase
  String f = feeling.toLowerCase();
// if two feelings are mentioned blend the colours
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
// assign colours when one feeling is found
  if (f.contains("excited")) return color(255, 135, 35);
  if (f.contains("sad")) return color(65, 120, 255);
  if (f.contains("tense")) return color(255, 55, 75);
  if (f.contains("happy")) return color(255, 225, 60);
  if (f.contains("fascinated")) return color(185, 75, 255);
  if (f.contains("amazed")) return color(50, 235, 255);

  return color(170, 175, 195);
}


// Show 3d data page

void draw3DScene() {
  // Plain background: no animated stars on this page.
  background(12, 15, 30);

  camera();
  lights();

  // Position and rotate the episode arrangement.
  pushMatrix();
  translate(width / 2, height / 2, 0);
  scale(zoom);
  rotateX(rotationX);
  rotateY(rotationY);

 
  noStroke();
  fill(240, 205, 235);
  sphere(45);

  // Draw all episodes from the CSV.
  hoveredEpisode = null;

  for (Episode e : episodes) {
    e.display();
  }

  popMatrix();

  // Draw the information panel and Back button over the 3D scene.
  drawEpisodeInfo();
  drawBackButton();
}


// Episode info panels

void drawEpisodeInfo() {
  //checks if the mouse is hovering over an episode sphere if its not the infromation won't be displayed
  if (hoveredEpisode == null) {
    return;
  }
// stores the episode being hovered over in a short variable so information can be accessed more easily
  Episode e = hoveredEpisode;
// resets the camera so the information stays in the smae place instead of moving with the 3D scene
  camera();
  // disabes depth testing so panel is on top of 3d scene
  hint(DISABLE_DEPTH_TEST);
// sets position and size of info panel
  float panelX = width - 340;
  float panelY = 35;
  float panelW = 305;
  float panelH = 390;
// makes the panel drawn fromm the top left corner
  rectMode(CORNER);
  // panel information appearance
  noStroke();
  fill(35, 35, 65, 235);
  rect(panelX, panelY, panelW, panelH, 15);

  fill(255, 248, 166);
  textAlign(LEFT, TOP);
  textFont(titleFont);
  textSize(22);
  text(e.title, panelX + 15, panelY + 15, panelW - 30, 50);

  // Display the anime image if one was loaded and sets its position and size
  float imageX = panelX + 15;
  float imageY = panelY + 75;
  float imageW = panelW - 30;
  float imageH = 120;
// checks if image was sucessfully loaded for anime
  if (e.animeImage != null) {
    // works out how much the image needs to be resized so it fits within the panel space without stretching
    float ratio = min(
      imageW / e.animeImage.width,
      imageH / e.animeImage.height
    );
// places image using its centre to make it easier to position the image in the middle of the panel
    imageMode(CENTER);
    image(
      e.animeImage,
      imageX + imageW / 2,
      imageY + imageH / 2,
      e.animeImage.width * ratio,
      e.animeImage.height * ratio
    );
    // changes the image position back to defult so other images are not affected
    imageMode(CORNER);
  } else {
    // if no image is available display message instead
    fill(180, 180, 205);
    textFont(createFont("SansSerif", 14));
    text("No image loaded", imageX, imageY + 50);
  }
// text colour and font for information
  fill(255);
  textFont(createFont("SansSerif", 14));
// displays all the episode infromation in the info panel
//+ joins the labels with the values from the CSV and  \n moves each piece of information onto a new line.
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
// depth testing is turn3d back on to not effect the 3d scene
  hint(ENABLE_DEPTH_TEST);
}


// Back button

void drawBackButton() {
  // resets camera so the button stays in one position 
  camera();
  // disables depth testing so button is ontop of 3D scene
  hint(DISABLE_DEPTH_TEST);
// shape and position of button
  rectMode(CORNER);
  fill(40, 35, 80);
  stroke(255, 248, 166);
  strokeWeight(2);
  rect(20, 20, 100, 40, 10);
// adds BACK text in centre of button
  fill(255);
  noStroke();
  textAlign(CENTER, CENTER);
  textFont(createFont("SansSerif", 16));
  text("BACK", 70, 40);
// re enables depth testing after button is drawn
  hint(ENABLE_DEPTH_TEST);
}
