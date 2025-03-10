import de.bezier.guido.*;
private static int NUM_ROWS =20;
private static int NUM_COLS = 20;
private MSButton[][] buttons = new MSButton[NUM_ROWS][NUM_COLS]; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
int numOfMines = 70;

void setup ()
{
    size(800, 800);
    textAlign(CENTER,CENTER);
   
    // make the manager
    Interactive.make( this );
   
    for(int r = 0; r < NUM_ROWS; r++) {
      for(int c = 0; c < NUM_COLS; c++) {
         buttons[r][c] = new MSButton(r, c);  
      }  
    }
   
   
    setMines(0);
}
public void setMines(int n)
{
    if(n < numOfMines) {
      int randomROW = (int)(Math.random() * NUM_ROWS);
      int randomCOL = (int)(Math.random() * NUM_COLS);
      if(!mines.contains(buttons[randomROW][randomCOL])) {
        mines.add(buttons[randomROW][randomCOL]);
      } else {
        randomROW = (int)(Math.random() * NUM_ROWS);
        randomCOL = (int)(Math.random() * NUM_COLS);
        mines.add(buttons[randomROW][randomCOL]);
      }  
      setMines(n + 1);
    }  
}

public void draw ()
{
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
  int flagCount = 0;
  int clickCount = 0;
  for(int i = 0; i < mines.size(); i++) {
    if(mines.get(i).isFlagged()) {
       flagCount++;
    }  
  }  
  if(flagCount == mines.size()) {
    return true;
  } 
  for(int i = 0; i < buttons.length; i++) {
    for(int j = 0; j < buttons[i].length; j++) {
      if(buttons[i][j].isClicked() && !mines.contains(buttons[i][j])) {
        clickCount++;
      }  
    }  
  }
  if(clickCount == ((NUM_ROWS * NUM_COLS) - mines.size())) {
    return true;
  }  
  return false;
}
public void displayLosingMessage()
{
    for(int i = 0; i < buttons.length; i++) {
      for(int j = 0; j < buttons[i].length; j++) {
        if(!buttons[i][j].isClicked()) {
          buttons[i][j].setLabel("L");
        }  
      }  
    }  
    for(int j = 0; j < mines.size(); j++) {
      mines.get(j).setFlagged(false);
    }  
    for(int j = 0; j < mines.size(); j++) {
      mines.get(j).setClicked(true);
    }  
}
public void displayWinningMessage()
{
    for(int i = 0; i < buttons.length; i++) {
      for(int j = 0; j < buttons[i].length; j++) {
        buttons[i][j].setLabel("W");
      }  
    }  
}
public boolean isValid(int r, int c)
{
    if(r < NUM_ROWS && r > -1) {
      if(c < NUM_COLS && c > -1) {
        return true;
      }
    }
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row - 1; r < row + 2; r++) {
      for(int c = col - 1; c < col + 2; c++) {
        if(isValid(r, c)) {
          if(mines.contains(buttons[r][c])) {
            numMines++;
          }  
        }
      }
    }  
    if(mines.contains(buttons[row][col])) {
      numMines--;
    }  
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
   
    public MSButton ( int row, int col )
    {
        width = 800/NUM_COLS;
        height = 800/NUM_ROWS;
        myRow = row;
        myCol = col;
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed ()
    {
        clicked = true;
        if(mouseButton == RIGHT) {
          flagged = !flagged;
          if(!flagged) {
            clicked = false;
          }  
        } else if(mines.contains(this)) {
          displayLosingMessage();
        } else if(countMines(myRow, myCol) > 0) {
          setLabel(countMines(myRow, myCol));
        } else {
          for(int r = myRow - 1; r < myRow + 2; r++) {
            for(int c = myCol - 1; c < myCol + 2; c++) {
              if(isValid(r, c) && buttons[r][c] != buttons[myRow][myCol] && buttons[r][c].clicked == false) {
                buttons[r][c].mousePressed();
              }
            }
          }  
        }  
    }
    public void draw ()
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) )
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public void setFlagged(boolean n) {
      flagged = n;
    }  
    public void setClicked(boolean n) {
      clicked = n;
    }  
    public boolean isClicked() {
      return clicked;
    }
}
