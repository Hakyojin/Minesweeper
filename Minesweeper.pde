

import de.bezier.guido.*;
private int NUM_ROWS = 20;
private int NUM_COLS = 20;//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    noFill();
    size(400, 500);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to declare and initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for(int r=0;r<NUM_ROWS;r++)
        for(int c=0;c<NUM_COLS;c++)
            buttons[r][c] = new MSButton(r, c);    
    setBombs();
}
public void setBombs()
{
    bombs = new ArrayList<MSButton>();
    int bRow = 0;
    int bCol = 0;
    for(int b=0;b<40;b++)
    {
        bRow = (int)(Math.random()*20);
        bCol = (int)(Math.random()*20);
        if(!bombs.contains(buttons[bRow][bCol]))
            bombs.add(buttons[bRow][bCol]);
        System.out.print(bRow+1 + " ");
        System.out.println(bCol+1);
    }
}

public void draw ()
{
    background( 0 );
    if(isWon()||true)
        displayWinningMessage();

}
public boolean isWon()
{
    int countM = 0;
    int countC = 0;
    for(int r = 0; r < NUM_ROWS; r++){
        for(int c = 0; c < NUM_COLS; c++){
            if(buttons[r][c].isMarked())
                countM++;
            else if(buttons[r][c].isClicked())
                countC++;
        }
    }
    int countB = 0;
    for(int i = 0; i < bombs.size(); i++){
        if((bombs.get(i)).isMarked())
            countB++;
    }
    if((countB == bombs.size() && countM + countC == NUM_ROWS*NUM_COLS && countB == countM) && bombs.size() == (NUM_ROWS*NUM_COLS)-countC){
        return true;
    }
    //your code here
    return false;
}
public void displayLosingMessage()
{
        fill(255,0,0);
        stroke(10);
        textAlign(CENTER,CENTER);
        textSize(80);
        text("YOU LOSE", width/2,450);
        noLoop();
    //your code here
}
public void displayWinningMessage()
{
        fill(102,255,102);
        stroke(10);
        textAlign(CENTER,CENTER);
        textSize(80);
        text("YOU WIN", width/2,450);
        noLoop();
}
public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    private int bombsAround = 0;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager 
    public void mousePressed () 
    {
        if(mouseButton == LEFT)
        {
            click();
        } else if(mouseButton == RIGHT)
        {
            mark();
        }
    }
    public void click()
    {
        if(!marked && !clicked)
        {
            if(bombs.contains(this))
            {
                clicked = true;
                displayLosingMessage();
            } else {
                clicked = true;
                if(countBombs() == 0)
                {
                    clickButton(r-1,c-1);
                    clickButton(r,c-1);
                    clickButton(r+1,c-1);
                    clickButton(r+1,c);
                    clickButton(r+1,c+1);
                    clickButton(r,c+1);
                    clickButton(r-1,c+1);
                    clickButton(r-1,c);
                } else {
                    bombsAround = countBombs();
                    label = "" + bombsAround;
                }
            }
        }
    }
    public void clickButton(int r, int c)
    {
        if(!isValid(r, c))
            return;
        buttons[r][c].click();
    }
    public void mark()
    {
        if(!clicked)
        {
            marked = !marked;
        }
    }
    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);
        rect(x, y, width, height);
        fill(0);
        textSize(10);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        return !(r < 0 || r >= NUM_ROWS || c < 0 || c >= NUM_COLS);
    }
    public int countBombs()
    {
        int numBombs = 0;
        numBombs += isBomb(r-1,c-1) ? 1 : 0;
        numBombs += isBomb(r,c-1) ? 1 : 0;
        numBombs += isBomb(r+1,c-1) ? 1 : 0;
        numBombs += isBomb(r+1,c) ? 1 : 0;
        numBombs += isBomb(r+1,c+1) ? 1 : 0;
        numBombs += isBomb(r,c+1) ? 1 : 0;
        numBombs += isBomb(r-1,c+1) ? 1 : 0;
        numBombs += isBomb(r-1,c) ? 1 : 0;
        return numBombs;
    }
    public boolean isBomb(int r, int c)
    {
        if(!isValid(r, c))
            return false;
        return bombs.contains(buttons[r][c]);
    }
}