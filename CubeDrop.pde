//import processing.opengl.*;

// Imports required for sensor usage:
import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorManager;
import android.hardware.SensorEventListener;

// Setup variables for the SensorManager, the SensorEventListeners,
// the Sensors, and the arrays to hold the resultant sensor values:
SensorManager mSensorManager;
MySensorEventListener accSensorEventListener;
MySensorEventListener magSensorEventListener;
Sensor acc_sensor;
float[] acc_values;
Sensor mag_sensor;
float[] mag_values;

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
float devicePosition;

//Starts boolean
boolean mp;
boolean cubepresent;
boolean gameon;
boolean alive;
boolean tilted;

//Starts arrays
int[] player;
int[] cubesX;
float[] cubesY;
int[] cubeWidth;

int[] pa = {
  0, 0
};
int[] xa = {
  -50
};
float[] ya = {
  -50
};
int[] wa = {
  0
};

String url;

void setVars() {
  csi = 70;
  fallRate = 1.3;
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
void setup() { 
  setVars();
  orientation(PORTRAIT);
  frameRate(50);
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
  fill(0, 0, 0);
  size(screenWidth, screenHeight);
  background(255, 255, 255);
  rectMode(CENTER);
}

//Run loop
void draw() {

  if (gameon) {
    //Prevents Ghosting
    background(255, 255, 255);

    //Applies the X modifier to the player X location
    player[0] = player[0]+xop;

    //Draws the player
    fill(255, 0, 0);
    rect(player[0], player[1], 25, 25);
    fill(0, 0, 0);

    //Left and Right Limits
    if (player[0] < leftBound) {
      xop = 0;
      player[0] = leftBound;
    }
    if (player[0] > rightBound) {
      xop = 0;
      player[0] = rightBound;
    }

    /*
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
     */

    //Sensor Code
    devicePosition = acc_values[0] * -1;
    tilted = true;
    if (devicePosition < 1.5) {
      if (devicePosition > -1.5) {
        tilted = false;
      }
    }

    if (tilted) {
      if (devicePosition > 1) {
        xop = 6;
      } 
      else {
        xop = -6;
      }
    } 
    else {
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
        rect(cubesX[i], cubesY[i], cubeWidth[i], 25);
      }
    }

    //Scoreing
    score = score+1;
    text(score, 10, 40);

    //Levels
    lt = lt+1;
    if (lt>1000) {
      csi = csi-8;
      fallRate = fallRate+.4;
      lt = 0;
    }

    //Cube Collision Voloumes
    for (int i=0; i < arrayPopulation; i=i+1) {
      halfCubeWidth = cubeWidth[i]/2;
      leftColl = cubesX[i]-halfCubeWidth;
      rightColl = cubesX[i]+halfCubeWidth;
      heightColl = cubesY[i]+float(80);
      if (leftColl < player[0]+12.5) {
        if (rightColl > player[0]-12.5) {
          if (heightColl > screenHeight) {
            if (heightColl < screenHeight+20) {
              gameon = false;
              alive = false;
              state = 2;
            } 
            else {
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
  } 
  else {
    drawMenu();
  }
}

void spawnCube() {
  //Spawns the cubes
  arrayPopulation = arrayPopulation + 1;
  cubeWidth = append(cubeWidth, int(random(50, 150)));
  cubeBound = screenWidth;
  cubesX = append(cubesX, int(random(20, cubeBound)));
  cubesY = append(cubesY, 50);
  cubepresent = true;
  ctk = 0;
}

void drawMenu() {
  background(255, 255, 255);
  if (alive) {
    menu = 1;
  } 
  else {
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
    fill(150, 150, 150);
    rect(halfWidth, halfHeight, 150, 50);
    fill(0, 0, 0);
    text("Start", halfWidth-70, halfHeight+15);
    fill(150, 150, 150);
    rect(halfWidth, halfHeight-250, 175, 50);
    fill(0, 0, 0);
    text("Scores", halfWidth-83, halfHeight-235);
  }
  if (menu == 2) {
    //Display High Scores
  }
  if (menu == 3) {
    if (state == 1) {
      fill(150, 150, 150);
      rect(halfWidth, halfHeight-250, 175, 50);
      fill(0, 0, 0);
      text("Submit", halfWidth-83, halfHeight-235);
      text("You Won!", halfWidth-100, halfHeight+100);
      fill(150, 150, 150);
      rect(halfWidth, halfHeight, 150, 50);
      fill(0, 0, 0);
      text("Retry", halfWidth-70, halfHeight+15);
    }
    if (state == 2) {
      fill(150, 150, 150);
      rect(halfWidth, halfHeight-250, 175, 50);
      fill(0, 0, 0);
      text("Submit", halfWidth-83, halfHeight-235);
      text("You Lost", halfWidth-100, halfHeight+100);
      fill(150, 150, 150);
      rect(halfWidth, halfHeight, 150, 50);
      fill(0, 0, 0);
      text("Retry", halfWidth-70, halfHeight+15);
    }
  }
}

//Called on mouse clicked
void mousePressed() {
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
void mouseReleased() {
  mp = false;
}


//Sensor Stuff
void onResume() {
  super.onResume();
  println("RESUMED! (Sketch Entered...)");
  // Build our SensorManager:
  mSensorManager = (SensorManager)getSystemService(Context.SENSOR_SERVICE);
  // Build a SensorEventListener for each type of sensor:
  magSensorEventListener = new MySensorEventListener();
  accSensorEventListener = new MySensorEventListener();
  // Get each of our Sensors:
  acc_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);
  mag_sensor = mSensorManager.getDefaultSensor(Sensor.TYPE_MAGNETIC_FIELD);
  // Register the SensorEventListeners with their Sensor, and their SensorManager:
  mSensorManager.registerListener(accSensorEventListener, acc_sensor, SensorManager.SENSOR_DELAY_GAME);
  mSensorManager.registerListener(magSensorEventListener, mag_sensor, SensorManager.SENSOR_DELAY_GAME);
}

void onPause() {
  // Unregister all of our SensorEventListeners upon exit:
  mSensorManager.unregisterListener(accSensorEventListener);
  mSensorManager.unregisterListener(magSensorEventListener);
  println("PAUSED! (Sketch Exited...)");
  super.onPause();
} 

//-----------------------------------------------------------------------------------------

// Setup our SensorEventListener
class MySensorEventListener implements SensorEventListener {
  void onSensorChanged(SensorEvent event) {
    int eventType = event.sensor.getType();
    if (eventType == Sensor.TYPE_ACCELEROMETER) {
      acc_values = event.values;
    }
    else if (eventType == Sensor.TYPE_MAGNETIC_FIELD) {
      mag_values = event.values;
    }
  }
  void onAccuracyChanged(Sensor sensor, int accuracy) {
    // do nuthin'...
  }
}

