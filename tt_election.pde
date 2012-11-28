/** MAS S60 Election Visualization
 *  Tiffany Tseng
 *  Description: Each state is represented by a colored ball, whose color value is scaled based on how red/blue the state voted
 *  The size of the ball represents the total number of voters
 *  Mouse over a ball to see more information about the state
 *  Based on this code: http://processing.org/learning/topics/bouncybubbles.html
 *  Last Updated: 11/27/12
 */

final int screenWidth = 800;
final int screenHeight = 800;
final int numStates = 43;
color Red, Blue;
int gradientWidth = 20;
int gradientHeight = 300;

boolean ballSelected = false;
String selectedState;

//bounciness variables
float spring = 0.5;
float gravity = 0;
float friction = -0.6;
Ball[] balls = new Ball[numStates];

final int minTotal = 212930; //minimum number of voters
final int maxTotal = 10288172; //maximum number of voters

PFont font;
ElectionData data;
String[] statePostalCodes;  // holds a list of state postal codes

void setup() {
  background(255);
  size(screenWidth, screenHeight);
  font = createFont("Arial",36,true);
  
  //load data
  data = new ElectionData(loadStrings("data/2012_US_election_state.csv"));
  statePostalCodes = data.getAllStatePostalCodes();

  Red = color(255, 0, 0);
  Blue = color(0, 10, 255);
  
  //initiate all balls
  for (int i = 0; i<numStates; i++){
    String currentPostalCode = statePostalCodes[i];
    StateData state = data.getState(currentPostalCode);
    
    //draw ball in random location
    int stateTotal = state.total;
    float ballSize = map(stateTotal, minTotal, maxTotal, 25, 100); //scale ball size based on total # of votes
    float colorCode = map(Math.round(state.pctForObama), 0, 100, 0, 1); //map color based on # of votes for obama
    color stateFill = lerpColor(Red, Blue, colorCode); 
    balls[i] = new Ball(random(0, screenWidth), random(0, screenHeight), ballSize, i, balls, stateFill, currentPostalCode);
  }  
}


void draw() {
  background(0);
  
  for (int i =0; i<numStates; i++){
    balls[i].collide();
    balls[i].move();
    balls[i].display();
  }
  
  //draw rectangle containing state information
  rectMode(CENTER);
  fill(100, 128);
  noStroke();
  rect(width-200, height/2, 300, 200);
  
  if(ballSelected){
     textFont(font, 36);
     textAlign(CENTER);
     fill(255);
     
     //draw state name
     text(selectedState, width-200, height/2-20);
     
     StateData state = data.getState(selectedState);
     
     //draw state obama percentage
     fill(Blue);
     textSize(20);
     text(nf(Math.round(state.pctForObama),1,1)+ "%", width-200-40, height/2+20);
     fill(Red);
     text(nf(Math.round(state.pctForRomney),1,1)+ "%", width-200+40, height/2+20); 
  }
  else{
    fill(255);
    textSize(25);
    textAlign(CENTER);
    text("mouse over a ball", width-200, height/2);
  }
    
}
