// wait a second before resetting essentially
// dimentions of the whole canvas
int H = 1000;
int W = 1450;
void setup() {
  //size(1450,1000);
  fullScreen();
  //H = displayHeight;
  //W = displayWidth;
  frameRate(30);
}

// diff digits 1,5,7 8 is the theoretical max
Simulation s1 = new Simulation(W/2,H/3,0,0,1,-2);
Simulation s2 = new Simulation(W/2,H/3,0,H/3,5,-2);
Simulation s3 = new Simulation(W/2,H/3,0,H - H/3,8,-2);
// diff speed
Simulation s4 = new Simulation(W/2,H/3,W/2,0,1,-5);
Simulation s5 = new Simulation(W/2,H/3,W/2,H/3,5,-5);
Simulation s6 = new Simulation(W/2,H/3,W/2,H - H/3,8,-5);

// when all the clanks are done, we want to let it run for a few seconds before reset
int cooldown = -1;
Simulation[] allSim = {s1,s2,s3,s4,s5,s6};
void draw() {
  //print(cooldown + "\n");
  background(0);
  int allTrueCount = 0;
  for (Simulation s : allSim) {
    s.update();
    // it would only ever reach 0 if all the clanks happened and we wait 100 frames
    if (cooldown == 0) {
      s.reset();
    }
    if (s.isDone && cooldown == -1) {
      allTrueCount++;
    }
  }
  // -1 indicates that the simulations happen
  cooldown = max(-1, cooldown - 1);
  // give 150 frames to finish off before resetting
  if (allTrueCount == allSim.length) {
    cooldown = 150;
    allTrueCount = 0;
  }  
}

class Floor {
  float x;
  float y;
  float depth;
  color col;
  public Floor(float x, float y, float depth, color col) {
    this.x = x;
    this.y = y;
    this.depth = depth;
    this.col = col;
  }
  
  public float getY() {
    return y;
  }
  
  public void display(float simWidth) {
    fill(col);
    rect(x,y,simWidth,depth);
  }
}

class TextStat {
  float size;
  float x;
  float y;
  color col;
  
  public TextStat(float size, float x, float y, color col) {
    this.size = size;
    this.x = x;
    this.y = y + size;
    this.col = col;
  }
  
  void showText(String s) {
    fill(col);
    textSize(size);
    text(s, x, y);
  }
  
  public void display(long clanks) {
    showText((String.valueOf(clanks)));
  }
}

class Block {
  // we need double for the position,mass and speed since we work with 100^n
  double x;
  double y;
  double mass;
  double velocity;
  color col;
  // adjust the mass on screen so it fits on screen but natural
  float displaySize;
  
  public Block(float x, float mass, float velocity, color col, float tall) {
    this.x = x;
    this.mass = mass;
    this.velocity = velocity;
    this.col = col;
    // want to show bigger size but have diminishing returns. also doing log(100)
    float scaleFactor = log(mass) / log(100);
    if (mass == 1) {
      scaleFactor = 1;
     // accouns for double the mass
    } else if (mass == 100) {
      scaleFactor = 1.5;
    }
    displaySize = tall/8 * sqrt(scaleFactor);
  }
  
  // update check if outside of screen
  void display(float floorPos, float simWidth) {
    boolean partOffScreen = false;
    // tells us how many x units are off screen
    float cutoff = 0;
    fill(col);
    // y pos should always be above floor
    y = floorPos - displaySize;
    if (x + displaySize > simWidth) {
      // exists so we can seemlessly move off screen if needed
      cutoff = min(displaySize,(float)x + displaySize -  simWidth);
      partOffScreen = true;
    }
    // accounts for some parts looking off 
    if(partOffScreen) {
      rect((float)x,(float)y,displaySize - cutoff,displaySize);
    } else {
      rect((float)x,(float)y,displaySize,displaySize);
    }
  }
  
  // so we only move if it guarantees it does not overlap and deltatime slows it down
  void move(double deltaTime) {
    this.x += velocity * deltaTime;
  }
  
  // the bounce formula is the same except the masses slightly differ
  double bounce(Block other) {
    double ourNewVel = 0;
    double sumMass = this.mass + other.mass;
    double diffMass = this.mass - other.mass;
    // find new speed of both
    ourNewVel = (diffMass / sumMass) * this.velocity;
    ourNewVel += (2*other.mass / sumMass) * other.velocity;
    return ourNewVel;
  }
  
  void reverseVel() {
    this.velocity *= -1;
  }
  
  // d = vt => d/v = t
  double timeToWallHit(float wallPos) {
    return (wallPos + -this.x) / this.velocity;
  }
  
  // same formula but find difference of position and speed first
  double timeToBlockHit(Block other) {
   double deltaX = other.x - (this.x + this.displaySize);
   double deltaV = this.velocity - other.velocity;
   return deltaX/deltaV;
  }
}

// only thing that changes is the height/width of the window and x and y pos
// of top left corner
class Simulation {
  // establish the window the simulation takes place
  float wide;
  float tall;
  float wideOffset;
  float tallOffset;
  float frameTime = 2;
  // Count how many hits there are
  long clanks = 0;
  
  // When a collision happens, it alternates a block vs wall hit
  boolean isBlockNextHit = true;
  
  // the number of digits relies on how many extra digits
  // 6 is pretty reliable. Might need to be closer though
  float digits;
  // account for powers of 100
  float sigFigs;
  // so each frame we just keep as is
  float initialSpeed;
  
  // Objects drawn on screen
  Block block1;
  Block block2;
  Floor floor1;
  TextStat txt;
  
  boolean isDone = false;
  public Simulation(float w, float h, float wOffset, float hOffset, int digits, float speed) {
    this.wide = w;
    this.tall = h;
    this.wideOffset = wOffset;
    this.tallOffset = hOffset;
    this.digits = digits;
    this.sigFigs = pow(100,digits - 1);
    this.initialSpeed = speed;
    
      // draw a red block 1/3 screen across
    block1 = new Block(wide/3 + wideOffset,1,0,color(255,0,0),h);
    // draw a blue block 1/2 screen across
    block2 = new Block(wide/2 + wideOffset,sigFigs,initialSpeed,color(0,0,255),h);
    floor1 = new Floor(wOffset, tall + tallOffset - 60, tall/20, color(255,255,255));
    txt = new TextStat(tall/8, wOffset, tallOffset, color(255,255,255));
  }
  
  void reset() {
    isBlockNextHit = true;
    clanks = 0;
    txt.col = color(255,255,255);
    block1.x = wide/3 + wideOffset;
    block2.x = wide/2 + wideOffset;
    block2.velocity = initialSpeed;
    block1.velocity = 0;
    isDone = false;
  }
  
  void update() {
      floor1.display(wide);
      txt.display(clanks);
      // draw the wall
      fill(255);
      rect(wideOffset, tallOffset,1,tall);
      // Main idea is to count the collisions but don't draw and create overlap
      double remainingFrameTime = frameTime;
      // repeat while a collision happens
      while(true) {
        double timeToNextHit = 0;
        // detect see if hitting wall or block is coming next
        if (isBlockNextHit) {
          // we check if the next "move" ends in an overlap but not draw the overlap
          timeToNextHit = block1.timeToBlockHit(block2);
        } else {
          timeToNextHit = block1.timeToWallHit(wideOffset);
        }
        
        // means that there won't ever be another hit
        if(timeToNextHit < 0) {
          isDone = true;
          txt.col = color(0,255,0);
          break;
        }
        
        // can safely move to next frame since the clanks in a frame have passed by
        if (remainingFrameTime < timeToNextHit) {
          break;
        }
        
        // adjust velocity so they are not overlapping
        block1.move(timeToNextHit);
        block2.move(timeToNextHit);
        
        // check what type of hit it is  
        if (isBlockNextHit) {
            double tempvel = block1.bounce(block2);
            double tempvel2 = block2.bounce(block1);
            block1.velocity = tempvel;
            block2.velocity = tempvel2;
            clanks++;
        } else {
          block1.reverseVel();
          clanks++;
        }
        // in this case they always alternate
        isBlockNextHit = !isBlockNextHit;
        // check if another clank happens in same frame
        remainingFrameTime -= timeToNextHit;
      }
      // move to the final position (should expect 0 collisions here)
      block1.move(remainingFrameTime);
      block2.move(remainingFrameTime);
      
      // give where the floor and end of the screen is 
      block1.display(floor1.getY(), wide + wideOffset);
      block2.display(floor1.getY(), wide + wideOffset);
  }
}
