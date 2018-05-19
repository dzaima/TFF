final int FOOD = 8;
final int FUNGUS = 9;
final int BLANK = 0;
class Cell {
  int type;
  int x, y;
  Cell (int xi, int yi, int ti) {
    x = xi;
    y = yi;
    type = ti;
  }
  void render() {
    int fx = x*zm;
    int fy = y*zm;
    int h = zm/2;
    if (type < 8 && type > 0) {
      fill(colors[type]);
      rect(fx, fy, zm, zm);
    } else if (type > 9) {
      textAlign(CENTER, CENTER);
      fill(0);
      textSize(zm*.6);
      text(QWERTYUIO.charAt(type-10)+"", fx+h, fy+h);
    } else if (type == FOOD) {
      fill(0);
      fx+= h;
      fy+= h;
      int sz = (int)(h*.7);
      quad(fx-sz, fy, fx, fy+sz, fx+sz, fy, fx, fy-sz);
    } else if (type == FUNGUS) {
      fill(130, 20, 70);
      fx+= h;
      fy+= h;
      int sz = (int)(h*.3);
      rect(fx-sz, fy-sz, sz*2, sz*2);
    }
  }
  int extras(boolean forceFR) {
    int ctr = 0;
    //fill(120, 120, 240, 70);
    //int sz = ((type==FOOD||type==FUNGUS) ^ ctrl?9:5)*zm/2;
    //rect(fx-sz, fy-sz, sz*2, sz*2);
    int sz = (forceFR? fungiRange : alt? 3 : ((type==FOOD||type==FUNGUS) ^ ctrl)? fungiRange : 5)/2;
    sx = x-sz;
    sy = y-sz;
    ex = x+sz;
    ey = y+sz;
    if (type == FOOD || type == FUNGUS) {
      //int fx = x*zm + zm/2;
      //int fy = y*zm + zm/2;
      for (int cx = max(0, sx); cx < min(ex+1, map.length); cx++) {
        for (int cy = max(0, sy); cy < min(ey+1, map[0].length); cy++) {
          if (map[cx][cy].type == (type==FUNGUS? FOOD : FUNGUS)) ctr++;
        }
      }
      textAlign(LEFT, TOP);
      
      //fill(255);
      //textSize(zm*.7);
      //text(ctr, fx, fy);
      //textSize(zm*.5);
      //text(ctr, fx, fy);
      
      fill(0);
      textSize(zm*.6);
      text(ctr, 0, 0);
    }
    return ctr;
  }
  void antS() {
    if (type > 9) {
      int fx = x*zm + zm/2;
      int fy = y*zm + zm/2;
      fill(200, 120, 240, 30);
      int sz = 5*zm/2;
      rect(fx-sz, fy-sz, sz*2, sz*2);
    }
  }
  void border() {
    int fx = x*zm;
    int fy = y*zm;
    line(fx, fy, fx+zm-1, fy);
    line(fx, fy, fx, fy+zm-1);
  }
}
color[] colors = new color[]{#FFFFFF, #FFFF00, #FF00FF, #00FFFF, #FF0000, #00FF00, #0000FF, #000000};
