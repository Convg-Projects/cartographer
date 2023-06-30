//Lag machi- i mean map maker
//Created by Convg

float[][] Matrix;
int MatrixSize = 250;
int NodeSize = 1;
float SandHeight = 90;
float GrassHeight = 95;
float StoneHeight = 110;
float SnowHeight = 120;
int NumberOfIterations = 50;
float Falloff = 1f;

slider SandSlider = new slider(210, 10, 0, 255, 520, 20, 90, "Sand Base:", #fce98d, #8dfce9, color(252, 209, 169), 0, true);
slider GrassSlider = new slider(210, 10, 0, 255, 520, 50, 95, "Grass Base:", #fce98d, #8dfce9, color(96, 165, 46), 0, true);
slider StoneSlider = new slider(210, 10, 0, 255, 520, 80, 110, "Stone Base:", #fce98d, #8dfce9, color(112, 112, 112), 0, true);
slider SnowSlider = new slider(210, 10, 0, 255, 520, 110, 120, "Snow Base:", #fce98d, #8dfce9, color(255, 255, 255), 0, true);
slider SmoothnessSlider = new slider(210, 10, 10, 15, 520, 140, 15, "Smoothing Iterations(Requires New Map):", #fce98d, #8dfce9, color(80, 80, 80), 0, true);
slider FalloffSlider = new slider(210, 10, 0.8f, 3f, 520, 170, 1f, "Distance Falloff(Requires New Map):", #fce98d, #8dfce9, color(80, 80, 80), 0, true);

slider LoadingSlider = new slider(210, 10, 0.8f, 3f, 520, 200, 1f, "GeneratingMap...", 0, 0, 0, 0, false);

PImage fai_iconi;
PGraphics fai_icong;
String fai_filename;

void setup() {
  size(750, 250);
  background(255);
  frameRate(1000);
  noStroke();

  CreateMap();
}

boolean MapCompleted = true;
int iteration;

void CreateMap() {
  //Initialise and Randomise Matrix
  Matrix = new float[MatrixSize][MatrixSize];

  for (int i = 0; i < Matrix.length; i++) {
    for (int j = 0; j < Matrix.length; j++) {
      //Matrix[i][j] = (int)random(0, 255);
      int r = (int)random(0, 2);
      Matrix[i][j] = 0;
      if (r == 1) {
        Matrix[i][j] = 255;
      }
    }
  }

  //Reset Values
  MapCompleted = false;
  iteration = 0;
}

void UpdateMap() {
  //Cellular Automata
  if (iteration < NumberOfIterations) {
    float[][] TempMatrix = new float[MatrixSize][MatrixSize];
    for (int row = 0; row < Matrix.length; row++) {
      for (int column = 0; column < Matrix[row].length; column++) {
        /*float Average = 0;
         int k = 1;
         float m = random(0, 4);
         if (m >= 0 && m < 1 && row != Matrix.length - 1) {
         Average += Matrix[row + 1][column];
         k++;
         }
         if (m >= 1 && m < 2 && row != 0) {
         Average += Matrix[row - 1][column];
         k++;
         }
         if (m >= 2 && m < 3 && column != Matrix[row].length - 1) {
         Average += Matrix[row][column + 1];
         k++;
         }
         if (m >= 3 && m <= 4 && column != 0) {
         Average += Matrix[row][column - 1];
         k++;
         }
         Average += Matrix[row][column];
         Average /= k;
         Matrix[row][column] = (int)Average;*/
        float Average = 0;
        int k = 1;
        float m = random(0, 4);
        if (row != Matrix.length - 1) {
          Average += Matrix[row + 1][column];
          k++;
        }
        if (row != 0) {
          Average += Matrix[row - 1][column];
          k++;
        }
        if (column != Matrix[row].length - 1) {
          Average += Matrix[row][column + 1];
          k++;
        }
        if (column != 0) {
          Average += Matrix[row][column - 1];
          k++;
        }
        if (row != Matrix.length - 1 && column != Matrix[row].length - 1) {
          Average += Matrix[row + 1][column + 1];
          k++;
        }
        if (row != 0 && column != 0) {
          Average += Matrix[row - 1][column - 1];
          k++;
        }
        if (row != 0 && column != Matrix[row].length - 1) {
          Average += Matrix[row - 1][column + 1];
          k++;
        }
        if (row != Matrix.length - 1 && column != 0) {
          Average += Matrix[row + 1][column - 1];
          k++;
        }
        Average += Matrix[row][column];
        Average /= k;
        TempMatrix[row][column] = (int)Average;
      }
    }

    Matrix = TempMatrix;
    ++iteration;
  }

  if (iteration >= NumberOfIterations) {
    //Apply Distance Modifier
    for (int i = 0; i < Matrix.length; i++) {
      for (int j = 0; j < Matrix[i].length; j++) {
        int PointCoordX;
        int PointCoordY;

        PointCoordX = i - (MatrixSize / (2 * NodeSize));
        PointCoordY = j - (MatrixSize / (2 * NodeSize));

        float DistanceFromCentre = sqrt((PointCoordX * PointCoordX) + (PointCoordY * PointCoordY));  

        Matrix[i][j] -= ((DistanceFromCentre * Falloff) * (DistanceFromCentre * Falloff) / MatrixSize);
      }
    }

    MapCompleted = true;
    DrawMap(true);
  }
}

void draw() {
  if (!MapCompleted) {
    UpdateMap();
  }

  if (SandSlider.HoveringHandle || GrassSlider.HoveringHandle || StoneSlider.HoveringHandle || SnowSlider.HoveringHandle) {
    DrawMap(false);
  }
  RunUI();

  fill(255);
  rect(0, 0, 55, 15);
  rect(0, height - 12, 90, 30);
  fill(0);
  text((int) frameRate + "fps", 0, 10);
  textSize(10);
  text("Created by Convg", 0, height - 2);
}

void DrawMap(boolean DrawHeight) {
  if (!DrawHeight) {
    for (int i = 0; i < Matrix.length; i++) {
      for (int j = 0; j < Matrix[i].length; j++) {
        fill(40, 78, 226);
        if (Matrix[i][j] >= SandHeight) {
          fill(252, 209, 169);
        }
        if (Matrix[i][j] >= GrassHeight) {
          fill(96, 165, 46);
        }
        if (Matrix[i][j] >= StoneHeight) {
          fill(112, 112, 112);
        }
        if (Matrix[i][j] >= SnowHeight) {
          fill(255, 255, 255);
        }
        rect(i * NodeSize, j * NodeSize, NodeSize, NodeSize);
      }
    }
  } else {
    for (int i = 0; i < Matrix.length; i++) {
      for (int j = 0; j < Matrix[i].length; j++) {
        fill(40, 78, 226);
        if (Matrix[i][j] >= SandHeight) {
          fill(252, 209, 169);
        }
        if (Matrix[i][j] >= GrassHeight) {
          fill(96, 165, 46);
        }
        if (Matrix[i][j] >= StoneHeight) {
          fill(112, 112, 112);
        }
        if (Matrix[i][j] >= SnowHeight) {
          fill(255, 255, 255);
        }
        rect(i * NodeSize, j * NodeSize, NodeSize, NodeSize);
        fill(((Matrix[i][j]) * 2) - SandHeight);
        rect(i * NodeSize + width / 2 - 125, j * NodeSize, NodeSize, NodeSize);
      }
    }
  }
}

void RunUI() {
  //Clear UI
  fill(100, 20, 20);
  rect(width - 250, 0, width, height);

  SandSlider.Run();
  GrassSlider.Run();
  StoneSlider.Run();
  SnowSlider.Run();
  SmoothnessSlider.Run();
  FalloffSlider.Run();

  if (!MapCompleted) {
    LoadingSlider.maxValue = NumberOfIterations;
    LoadingSlider.currentValue = iteration / (LoadingSlider.maxValue / LoadingSlider.sliderWidth);
    LoadingSlider.Run();
  }

  SandHeight = SandSlider.currentValue * (SandSlider.maxValue / SandSlider.sliderWidth);
  GrassHeight = GrassSlider.currentValue * (GrassSlider.maxValue / GrassSlider.sliderWidth);
  StoneHeight = StoneSlider.currentValue * (StoneSlider.maxValue / StoneSlider.sliderWidth);
  SnowHeight = SnowSlider.currentValue * (SnowSlider.maxValue / SnowSlider.sliderWidth);
  NumberOfIterations = (int) (SmoothnessSlider.currentValue * (SmoothnessSlider.maxValue / SmoothnessSlider.sliderWidth) + SmoothnessSlider.minValue);
  Falloff = FalloffSlider.currentValue * (FalloffSlider.maxValue / FalloffSlider.sliderWidth);

  fill(255);
  textSize(12);
  text("Press 'G' to Generate New Map", 520, 230);
}

void mouseReleased() {
  SandSlider.HoveringHandle = false;
  GrassSlider.HoveringHandle = false;
  StoneSlider.HoveringHandle = false;
  SnowSlider.HoveringHandle = false;
  SmoothnessSlider.HoveringHandle = false;
  FalloffSlider.HoveringHandle = false;

  //CreateMap();
}

void mousePressed() {
  SandSlider.OnClickEvent();
  GrassSlider.OnClickEvent();
  StoneSlider.OnClickEvent();
  SnowSlider.OnClickEvent();
  SmoothnessSlider.OnClickEvent();
  FalloffSlider.OnClickEvent();
}

void keyReleased() {
  if ((key == 'G' || key == 'g') && MapCompleted) {
    CreateMap();
  }
}
