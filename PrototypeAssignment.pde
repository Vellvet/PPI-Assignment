final int MENUSCREEN = 0;
final int GAMESCREEN = 1;
int screenState = 0; 
PImage menuBg, whiteBg;
Button menuButton, backButton, getQButton;
import java.util.LinkedList;
QuestionAPI APIQuestion = new QuestionAPI();
PFont font;
String question = "Questions";
String correctA = "Answers";
String incorrectA[] = {" "," "," "};
void setup() {
  
  size (1600,900);
  menuBg = loadImage ("menuBackground.jpeg");
  menuButton = new Button(width/2.3, height/2, 200, 100, "Test", 30);
  whiteBg = loadImage ("whiteBackground.jpeg");
  backButton = new Button(width/1.2, height/15, 200, 100, "Back", 30);
  getQButton = new Button(width/7.8, height/1.5, 200, 100, "Get Question", 30);
  font = createFont("Arial", 7);
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
  menuButton.Draw();
  if (menuButton.IsPressed()) {
    screenState = 1;
  }
  
}

void drawGame() {
  background(whiteBg);
  backButton.Draw();
  getQButton.Draw();
  if (backButton.IsPressed()) {
    screenState = 0;
  }
  if (getQButton.IsPressed()) {
    String Response = APIQuestion.request();
    question = APIQuestion.getQuestion(Response);
    correctA = APIQuestion.getCorrectAnswer(Response);
    incorrectA = APIQuestion.getIncorrectAnswers(Response);
  }
  textAlign(LEFT);
  fittedText(question, font, 50, 100, width/1.5, height/30);
  fittedText(correctA, font, 50, 200, width/1.5, height/30);
  fittedText(incorrectA[0], font, 50, 300, width/1.5, height/30);
  fittedText(incorrectA[1], font, 50, 400, width/1.5, height/30);
  fittedText(incorrectA[2], font, 50, 500, width/1.5, height/30);
  //text(correctA, 50, 300);
  //text(incorrectA, 50, 400);
  
}
public void fittedText(String text, PFont font, 
    float posX, float posY, 
    float fitX, float fitY)
{
  textFont(font);
  textSize(min(font.getSize()*fitX/textWidth(text), fitY));
  text(text, posX, posY);
}
