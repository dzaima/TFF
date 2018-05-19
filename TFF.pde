  import java.io.Serializable;
Cell[][] map;
int zm = 30;
void setup() {
  size(displayWidth, 860, P2D);
  map = new Cell[width/zm+1][height/zm+1];
  for (int x = 0; x < map.length; x++) {
    for (int y = 0; y < map[x].length; y++) map[x][y] = new Cell(x, y, BLANK);
  }
  println(map.length, map[0].length);
}
int sx, sy, ex, ey, mx, my;
boolean pmp, pkp;
boolean shift, ctrl, alt;
boolean selecting, pasting;
boolean ms;
boolean showBoxes = true;
int mode = 0; // 0 - play; 1 - save; 2 - load
String text = "";
int[][] copied;
int fungiSpeed = 65536;
int fungiRange = 9;
void keyPressed() {
  if (mode == 0) return;
  if (key >= ' ' && key <= '~') text+= key;
  else if (key == 8 && text.length() > 0) text = text.substring(0, text.length()-1);
  else if (key == 10) {
    if (mode == 1) save(text);
    else load(text);
    mode = 0;
  }
}
String qwertyuio = "qwertyuio";
String QWERTYUIO = "QWERTYUIO";
void draw() {
  if (mode != 0) {
    background(255);
    fill(0);
    textSize(width/40);
    text(text, width/2, height/2);
    return;
  }
  // println(keyCode);
  mx = mouseX/zm;
  my = mouseY/zm;
  int paint = -1;
  if (keyPressed) {
    if (key >= '1' && key <= '8') paint = key-'1';
    if (key == ' ') paint = 0;
    for (int i = 0; i < 8; i++) if (qwertyuio.indexOf(key) != -1) paint = 10+qwertyuio.indexOf(key);
    if (key == 'f') paint = FOOD;
    if (key == '`') paint = FUNGUS;
    if (key == 's') {
      mode = 1;
    }
    if (key == 'l') {
      mode = 2;
    }
    if (paint != -1) {
      if (!selecting) map[mx][my].type = paint;
      else {
        for (int x = max(0, sx); x < min(ex+1, map.length); x++) {
          for (int y = max(0, sy); y < min(ey+1, map[0].length); y++) {
            map[x][y].type = paint;
          }
        }
      }
    }
    if (!pkp && key == 'b') showBoxes ^= true;
    if (key == 'c' && !pkp) {
      sx = max(0, sx);
      ex = min(ex, map.length-1);
      sy = max(0, sy);
      ey = min(ey, map[0].length-1);
      copied = new int[ex-sx+1][ey-sy+1];
      for (int x = sx; x < ex+1; x++) {
        for (int y = sy; y < ey+1; y++) {
          copied[x-sx][y-sy] = map[x][y].type;
        }
      }
    }
    if (key == 'v' && !pkp) {
      pasting^= true;
      selecting = false;
    }
    if (key == '=' && !pkp) {
      int totalCtr = 0;
      int fungiCount = 0;
      int foodCount = 0;
      for (Cell[] ln : map) for (Cell c : ln) {
        if (c.type == FUNGUS) {
          fungiCount++;
          totalCtr+= c.extras(true);
        } else if (c.type == FOOD) foodCount++;
      }
      println("total fungi:", fungiCount);
      println("total food:", foodCount);
      println("total fungi effectors:", totalCtr);
      println("frames per food:", fungiSpeed*1f / totalCtr);
      println("no intrusion frames required:", foodCount * fungiSpeed*1f / totalCtr);
      
    }
  }
  if (pasting) {
    if (mousePressed) {
      for (int x = 0; x < copied.length; x++) {
        for (int y = 0; y < copied[0].length; y++) {
          try {
            map[x+mx][y+my].type = copied[x][y];
          } catch (ArrayIndexOutOfBoundsException e) {}
        }
      }
      pasting = false;
      
    } else if (copied != null && copied.length > 0) {
      sx = mx;
      sy = my;
      ex = mx + copied.length-1;
      ey = my + copied[0].length-1;
    }
  } else if (mousePressed && !pmp) selecting = true;
  if (!mousePressed && sx == ex && sy == ey) selecting = false;
  shift = keyPressed && key==CODED && keyCode==16;
  ctrl = keyPressed && key==CODED && keyCode==17;
  alt = keyPressed && key==CODED && keyCode==18;
  if (shift && keyPressed && !pkp) selecting^=true;
  
  
  background(255);
  noStroke();
  for (Cell[] ln : map) for (Cell c : ln) c.render();
  stroke(0,40);
  strokeWeight(1);
  for (Cell[] ln : map) for (Cell c : ln) c.border();
  if (showBoxes) for (Cell[] ln : map) for (Cell c : ln) c.antS();
  if (!selecting && !pasting) map[mx][my].extras(false);
  fill(120, 120, 240, 70);
  rect(sx*zm, sy*zm, zm*(ex-sx+1), zm*(ey-sy+1));
  
  
  if (!pmp && mousePressed && selecting) {
    ms = true;
    sx = mx;
    sy = my;
  }
  if (pmp && selecting && ms) {
    ex = mx;
    ey = my;
    if (!mousePressed) ms = false;
  }
  pmp = mousePressed;
  pkp = keyPressed;
}
