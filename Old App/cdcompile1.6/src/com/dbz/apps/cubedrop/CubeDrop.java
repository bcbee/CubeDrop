package com.dbz.apps.cubedrop;

import processing.core.*; 
import processing.xml.*; 

import android.view.MotionEvent; 
import android.view.KeyEvent; 
import android.graphics.Bitmap; 
import java.io.*; 
import java.util.*; 

public class CubeDrop extends PApplet {



//Sets up fonts
PFont font;

//Starts Variables
//Spawn Rare
int csi;
//Fall Rate
float fallRate;

int halfWidth;
int halfCubeWidth;
int pHeight;
int leftBound;
int rightBound;
int cubeBound;
int xop;
int ctk;
int arrayPopulation;
int score;
int lt;
int leftColl;
int rightColl;
int halfHeight;
//1 Start
//2 Info
//3 State
int menu;
//0 = Nothing
//1 = Win
//2 = Loss
int state;
float heightColl;

//Starts boolean
boolean mp;
boolean cubepresent;
boolean gameon;
boolean alive;

//Starts arrays
int[] player;
int[] cubesX;
float[] cubesY;
int[] cubeWidth;

int[] pa = {0, 0};
int[] xa = {-50};
float[] ya = {-50};
int[] wa = {0};

String url;

public void setVars() {
  csi = 70;
  fallRate = 1.3f;
  player = pa;
  cubesX = xa;
  cubesY = ya;
  cubeWidth = wa;
  xop = 0;
  ctk = 0;
  arrayPopulation = 0;
  score = 0;
  lt = 0;
  menu = 1;
  state = 0;
  mp = false;
  cubepresent = false;
  gameon = false;
  alive = true;
}
//Runs the onCreate()
public void setup() { 
  setVars();
  font = loadFont("Font.vlw"); 
  textFont(font); 
  leftBound = 20;
  rightBound = screenWidth-20;
  pHeight = screenHeight-60;
  halfWidth = screenWidth/2;
  halfHeight = screenHeight/2;
  player[0] = halfWidth;
  player[1] = pHeight;
  smooth();
  fill(0,0,0);
 
  background(255,255,255);
  rectMode(CENTER);
}

//Run loop
public void draw() {
  if (gameon) {
  //Prevents Ghosting
  background(255,255,255);
  
  //Applies the X modifier to the player X location
  player[0] = player[0]+xop;
  
  //Draws the player
  fill(255,0,0);
  rect(player[0],player[1],25,25);
  fill(0,0,0);
  
  //Left and Right Limits
  if (player[0] < leftBound) {
    xop = 0;
    player[0] = leftBound;
  }
  if (player[0] > rightBound) {
    xop = 0;
    player[0] = rightBound;
  }
  
  //Mouse Code
  if (mp) {
    if (mouseX > halfWidth) {
    xop = 7;
  } else {
    xop = -7;
  }
  } else {
    xop = 0;
  }
  
  //Cube Code
  
  //Cube Spawning
  
  //Adds one the the iterative spawn token
  ctk = ctk+1;
  
  //If the token is greater than the cube spawing timer spawn a cube
  if (ctk > csi) {
    spawnCube();
  }
  
  //Draws the cube
  if (cubepresent) {
    for (int i=0; i < arrayPopulation; i=i+1) {
      cubesY[i] = cubesY[i] + fallRate;
      rect(cubesX[i],cubesY[i],cubeWidth[i],25);
    }
  }
  
  //Scoreing
  score = score+1;
  text(score, 10,40);
  
  //Levels
  lt = lt+1;
  if (lt>1000) {
    csi = csi-8;
    fallRate = fallRate+.4f;
    lt = 0;
  }
  
  //Cube Collision Voloumes
  for (int i=0; i < arrayPopulation; i=i+1) {
    halfCubeWidth = cubeWidth[i]/2;
    leftColl = cubesX[i]-halfCubeWidth;
    rightColl = cubesX[i]+halfCubeWidth;
    heightColl = cubesY[i]+PApplet.parseFloat(80);
    if (leftColl < player[0]+12.5f) {
      if (rightColl > player[0]-12.5f) {
        if (heightColl > screenHeight) {
      if(heightColl < screenHeight+20) {
          gameon = false;
          alive = false;
          state = 2;
      } else {
      }
    }
      }
    }
  }
  
  
  if (csi < 5) {
    state = 1;
    gameon = false;
    alive = false;
  }
  
  } else {
    drawMenu();
  }
}

public void spawnCube() {
  //Spawns the cubes
  arrayPopulation = arrayPopulation + 1;
  cubeWidth = append(cubeWidth, PApplet.parseInt(random(50,150)));
  cubeBound = screenWidth;
  cubesX = append(cubesX, PApplet.parseInt(random(20,cubeBound)));
  cubesY = append(cubesY, 50);
  cubepresent = true;
  ctk = 0;
}

public void drawMenu() {
  background(255,255,255);
  if (alive) {
    menu = 1;
  } else {
    if (state == 0) {
      menu = 2;
    }
    if (state == 1) {
      menu = 3;
    }
    if (state == 2) {
      menu = 3;
    }
  }
  if (menu == 1) {
    fill(150,150,150);
    rect(halfWidth,halfHeight, 150, 50);
    fill(0,0,0);
    text("Start",halfWidth-70,halfHeight+15);
    fill(150,150,150);
    rect(halfWidth,halfHeight-250, 175, 50);
    fill(0,0,0);
    text("Scores",halfWidth-83,halfHeight-235);
  }
  if (menu == 2) {
    //Display High Scores
  }
  if (menu == 3) {
    if (state == 1) {
      fill(150,150,150);
      rect(halfWidth,halfHeight-250, 175, 50);
    fill(0,0,0);
    text("Submit",halfWidth-83,halfHeight-235);
      text("You Won!",halfWidth-100,halfHeight+100);
      fill(150,150,150);
    rect(halfWidth,halfHeight, 150, 50);
    fill(0,0,0);
    text("Retry",halfWidth-70,halfHeight+15);
    }
    if (state == 2) {
      fill(150,150,150);
      rect(halfWidth,halfHeight-250, 175, 50);
    fill(0,0,0);
    text("Submit",halfWidth-83,halfHeight-235);
      text("You Lost",halfWidth-100,halfHeight+100);
      fill(150,150,150);
    rect(halfWidth,halfHeight, 150, 50);
    fill(0,0,0);
    text("Retry",halfWidth-70,halfHeight+15);
    }
  }
}

//Called on mouse clicked
public void mousePressed() {
  if (menu == 1) {
    if (mouseX > halfWidth-75) {
      if (mouseX < halfWidth+75) {
        if (mouseY < halfHeight + 25) {
          if (mouseY > halfHeight - 25) {
        gameon = true;
          }
        }
        if (mouseY < halfHeight - 225) {
          if (mouseY > halfHeight - 275) {
            link("http://dbztech.com/CubeDrop");
          }
        }
        
      }
    }
  }
  if (menu > 1) {
    if (mouseX > halfWidth-75) {
      if (mouseX < halfWidth+75) {
        if (mouseY < halfHeight + 25) {
          if (mouseY > halfHeight - 25) {
        setVars();
          }
        }
        if (mouseY < halfHeight - 225) {
          if (mouseY > halfHeight - 275) {
            println("Yes");
            url = "http://dbztech.com/CubeDrop/redirect.php?input="+score;
            link(url);
          }
        }
      }
    }
  }
  mp = true;
}

//Called on mouse released
public void mouseReleased() {
  mp = false;
}


  public int sketchWidth() { return screenWidth; }
  public int sketchHeight() { return screenHeight; }
  public String sketchRenderer() { return OPENGL; }
}
