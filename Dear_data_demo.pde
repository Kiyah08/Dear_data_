
// store 
PFont titleFont;

void setup() {
  size(900, 650);
  smooth();

  // Loading free to use font I downloaded from Dafont
  titleFont = createFont("game_over.ttf",500 );
}

void draw() {
  background(12, 13, 38);

  // creating animated stars for my menu background
  noStroke();

  for (int i = 0; i < 55; i++) {
    float x = (i * 137 + 31) % width;
    float y = (i * 83 + 17) % height;

    // Each star animates at a different speed to creaate a more realistic effect
    float twinkle = sin(frameCount * 0.05 + i * 2.0);

    // Change the size and brightness as the star twinkles.
    float starSize = map(twinkle, -1, 1, 2, 6);
    float brightness = map(twinkle, -1, 1, 100, 255);

    fill(255, 240, brightness);

    // make star 4 pointed
    pushMatrix();
    translate(x, y);
    rotate(frameCount * 0.01 + i);

    beginShape();
    vertex(0, -starSize * 1.5);
    vertex(starSize * 0.3, -starSize * 0.3);
    vertex(starSize * 1.5, 0);
    vertex(starSize * 0.3, starSize * 0.3);
    vertex(0, starSize * 1.5);
    vertex(-starSize * 0.3, starSize * 0.3);
    vertex(-starSize * 1.5, 0);
    vertex(-starSize * 0.3, -starSize * 0.3);
    endShape(CLOSE);

    popMatrix();
  }

  
// Project title.
  fill(255);
  textAlign(CENTER, CENTER);
  textFont(titleFont);
  textSize(70);
  text("Kiyah's Dear Data", width/2, 200);    

  // Subtitle 
  textFont(createFont("SansSerif", 18));
  fill(190, 195, 230);
  text("Anime Data Vizualisation", width/2, 250);
}
