import processing.serial.*;
import java.util.LinkedList;
import java.util.Collections;
import java.util.Arrays;

Serial myPort;
final int MENUSCREEN = 0;
final int GAMESCREEN = 1;
int score = 0;
int screenState = 0; 
PImage menuBg, whiteBg;
Button menuButton, backButton, getQButton;
int SelectedAnswer;
//boolean
boolean questionOn = false;
boolean scoreAdded = false;
boolean answerTaken = false;

//timer
int duration = 10;
int time = 10;
int beginTime;

QuestionAPI APIQuestion = new QuestionAPI();
String Response = APIQuestion.request();
PFont font;
String question = "Questions";
String correctA = "Answers";
String incorrectA[] = {" "," "," "};
String Answers[] = {" "," "," ", " "};
void setup() {
  
  size (1600,900);
  menuBg = loadImage ("menuBackground.jpeg");
  menuButton = new Button(width/2.3, height/2, 200, 100, "Test", 30);
  whiteBg = loadImage ("gameBackground.png");
  backButton = new Button(width/1.2, height/15, 200, 100, "Back", 30);
  getQButton = new Button(width/1.5, height/15, 200, 100, "Get Question", 30);
  font = createFont("Arial", 7);
  
  //serial
  myPort = new Serial (this, "/dev/cu.usbmodem11201", 9600);
  
}
// setup() and other global variables
void draw() {
  if (screenState == MENUSCREEN) {
    drawMenu();
  } else if (screenState == GAMESCREEN) {
    drawGame();
  } else {
    println("Something went wrong!");
  }
}

void drawMenu() {
  background(menuBg);
 
   if (myPort.available() > 0){
     if (Character.toString(myPort.readChar()).equals("4")) {
        screenState = 1;
     }
   }
  
}

void drawGame() {
  String read = "";
  background(whiteBg);
  if (myPort.available() > 0){
     // System.out.println(Character.toString(myPort.readChar()));
      read = Character.toString(myPort.readChar());
      if (read.equals("5")) {
      screenState = 0; 
      }
      else if (read.equals("6")) {
        Response = APIQuestion.request();
        question = APIQuestion.getQuestion(Response);
        correctA = APIQuestion.getCorrectAnswer(Response);
        incorrectA = APIQuestion.getIncorrectAnswers(Response);
        Answers = new String[]{correctA, incorrectA[0], incorrectA[1], incorrectA[2]};
        Collections.shuffle(Arrays.asList(Answers));
        beginTime = millis();
        questionOn = true;
      }
  }
  fill(0);
  textAlign(LEFT);
  fittedText(question, font, 130, 340, width/1.2, height/10);
  fittedText("A. " + Answers[0], font, 130, 550, width/2.7, height/20);
  fittedText("B. " + Answers[1], font, 903, 550, width/2.7, height/20);
  fittedText("C. " + Answers[2], font, 130, 788, width/2.7, height/20);
  fittedText("D. " + Answers[3], font, 903, 788, width/2.7, height/20);
  textAlign(CENTER);
  textSize(60);
  text(score, 180, 85);
  if(questionOn)
  {
  checkAnswer(beginTime, read);
  answerTaken = false;
  }
}

private void checkAnswer(int StartTime, String SensorInput)
{
  //text(""+SelectedAnswer, 900, 500);
  time = duration - (millis() - StartTime)/1000;
  textSize(60);
  textAlign(CENTER);
  text(time,820,85);
  if (!SensorInput.equals("")) {
    SelectedAnswer = Integer.parseInt(SensorInput);
    System.out.println(SelectedAnswer);
    scoreAdded = false;
  }
      if (time <= 0) {
        if(SelectedAnswer >= 4 )
        {
          myPort.write('8');
          scoreAdded = true;
          println("False");
        }
        else if(Answers[SelectedAnswer].equals(correctA) && !scoreAdded){
        score += 5;
        println("True");
        scoreAdded = true;
        myPort.write('7');
        }
        else if (!Answers[SelectedAnswer].equals(correctA) && !scoreAdded){
        myPort.write('8');
        scoreAdded = true;
        println("False");
      }
      questionOn = false;
      }
      
}
public void fittedText(String text, PFont font, 
    float posX, float posY, 
    float fitX, float fitY)
{
  textFont(font);
  textSize(min(font.getSize()*fitX/textWidth(text), fitY));
  text(text, posX, posY);
}
