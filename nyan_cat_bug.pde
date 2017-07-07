import processing.serial.*;
import gifAnimation.*;

float h = 100;
PImage bg, tail;
Gif catbug, nyan, pinkdonut, flan, donutcat;
float [] arrayH;
int initVal;
int bgPos;

int score;

NyanCat nyanCat;
final int nyanCatWidth = 40;
final int nyanCatHeight = 35;

ArrayList<Gif> dessertGifs = new ArrayList();

boolean gameOver = false;

ArrayList<CatBug> catBugs = new ArrayList();
ArrayList<Dessert> desserts = new ArrayList();

void setup() 
{
  // create canvas
  size(800, 400);
  smooth();
  noStroke();
  
  initVal = 0;
  bgPos = 0;
  score = 0;
  
  // load images
  bg = loadImage("nyan-cat-bg.png");
  tail = loadImage("nyan-cat-tail.png");
  
  nyan = new Gif(this, "nyancat.gif");
  nyan.play();
  catbug = new Gif(this, "catbug.gif");
  catbug.play();
  pinkdonut = new Gif(this, "pinkdonut.gif");
  pinkdonut.play();
  donutcat = new Gif(this, "donutcat.gif");
  donutcat.play();
  flan = new Gif(this, "flan.gif");
  flan.play();
  
  dessertGifs.add(flan);
  dessertGifs.add(pinkdonut);
  dessertGifs.add(donutcat);
  
  arrayH = new float[163];
  
  nyanCat = new NyanCat(100);
}

void draw()
{ 
  // background
  if ( bgPos > 400 ) bgPos = 0;
  image(bg, -bgPos, 0);
  image(bg, 400 - bgPos, 0);
  image(bg, 800 - bgPos, 0);
  
  if(!gameOver) {
    nyanCat.display(); 
    
    if (initVal % 70 == 0) {
      catBugs.add(new CatBug(800, random(25, 325)));
    }
    
    if (initVal % 50 == 0) {
      desserts.add(new Dessert(800, random(25, 325)));
    }
    
    for(CatBug catBug: catBugs) {
      catBug.display();
    }
    
    for (Dessert dessert: desserts) {
      dessert.display();
    }
    
    fill(255, 255, 255);
    textSize(30);
    textAlign(LEFT);
    text(String.format("Score: %s", score), 30, 40);
    
  } else if (gameOver) {
    fill(255, 255, 255);
    textSize(50);
    textAlign(CENTER);
    text(String.format("Game Over!\n Final Score: %s\n Press any key to start over.", score), 400, 125);
  }
}

class CatBug {
  float x;
  float y;
  boolean collided;
  
  CatBug(float x, float y) {
    this.x = x;
    this.y = y;
    this.collided = false;
  }
  
  void display() {
    x -= 5;
    if (!collided) {
      collided = x >= nyanCat.x - nyanCatWidth && x <= nyanCat.x + nyanCatWidth && y >= nyanCat.y - nyanCatHeight && y <= nyanCat.y + nyanCatHeight;
      
      if (collided) {
        gameOver = true;
      }
      
      image(catbug, x, y);
    }
  }
}

class Dessert {
  float x;
  float y;
  boolean collided;
  int dessertIndex = round(random(0,2));
  
  Dessert(float x, float y) {
    this.x = x;
    this.y = y;
    this.collided = false;
  }
  
  void display() {
    x -= 5;
    if (!collided) {
      collided = x >= nyanCat.x - nyanCatWidth && x <= nyanCat.x + nyanCatWidth && y >= nyanCat.y - nyanCatHeight && y <= nyanCat.y + nyanCatHeight;
      
      if (collided) {
        score += 1;
      }
      
      image(dessertGifs.get(dessertIndex), x, y);
    }
  }
}


boolean key = true;
void keyPressed() {
  key = true;
  if (gameOver) {
    setup();
    gameOver = false;
  }
};
void keyReleased() { key = false; };
void mouseClicked() {
  if (gameOver) {
    setup();
    gameOver = false;
  }
}

class NyanCat {
  float x = 140;
  float y;
  
  NyanCat(int initialHeight) {
    y = initialHeight;
  }
  
  void display() {
    // draw the tail
    for ( int i = 0; i < 165; i += 5 ) {
      image(tail, i, arrayH[i] + y + 10 + sin(i - initVal % 25), 5, 62);
    }
  
    // draw the nyan cat
    image(nyan, x, y); 
    initVal++;
    bgPos++;
    
    if ((mousePressed || keyPressed) && y > 0) {
      y -= 7;
    } else if (y < 320) {
      y += 6;
    }
  }
}

void shiftAndAdd(float a[], float val){
  int a_length = a.length;
  System.arraycopy(a, 1, a, 0, a_length-1);
  a[a_length-1] = val;
}