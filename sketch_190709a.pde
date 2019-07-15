final int Gwidth = 240;
final int interval = 75;
final int wspace = 30;
PImage undo,redo;
PImage GZol,RZol,GPo,RPo,GCha,RCha,GSang,RSang,GMa,RMa,GSa,RSa,GKing,RKing;
GameStatus gameStatus;
enum GameStatus {
  START,
  START_C,
  GOING,
  PAUSE,
  END
}
enum Team {
  RED,
  BLUE;
}
Team turn = Team.BLUE;
boolean selected = false;
Piece selectedPiece = null;
ArrayList<Piece> pieces = new ArrayList<Piece>();
//int pieces_cnt = 0;
class Location {
  int x,y;
  Piece piece;
  Location(int xx,int yy) {
    this(xx,yy,null);
  }
  Location(int xx,int yy, Piece p) {
    x = xx;
    y = yy;
    piece = p;
  }
}
class Piece {
  Location location;
  PImage ima;
  int size;
  int point;
  Team team;
  boolean live;
  ArrayList<Location> nextLocations;
  Piece(Location l, PImage i, int s,int p, Team t, boolean livee) {
   this(l,i,s,p,t,livee,null);
  }
  Piece(Location l, PImage i, int s,int p, Team t, boolean livee,ArrayList<Location> locations) {
   location = l;
   ima = i;
   size = s;
   point = p;
   team = t;
   live = livee;
   l.piece = this;
   this.nextLocations = locations;
  }
}
Location[][] locations = new Location[10][10];
Location touchArea() {
  float mx = mouseX;
  float my = mouseY;
  float[] xs = new float[4];
  float[] ys = new float[4];
  if(mx > width - Gwidth) return null;
  //else if(!selected) {
  else {
    for(int i = 0; i<10; i++) for(int j = 0; j<10; j++) {
      float e = 60/2; // edge of hexagon
      float h = sqrt(3) * e / 2;
      
      Location location = locations[i][j];
      Piece piece = location.piece;
      if(piece != null) {
        if(piece == null && !selected) continue;
        switch(piece.size) {
        case 0:
          e = 42/2;
          break;
        case 1:
          e = 63/2+1;
          break;
        case 2:
          e = 84/2;
           break;
        }
        h = sqrt(3) * e / 2;
      }
      
      int x,y;
      x = location.x;
      y = location.y;
      
      xs[3] = x+h;
      xs[0] = x-h;
      ys[0] = y-h;
      ys[3] = y+h;
      
      if(xs[0] < mx && xs[3] > mx && ys[0] < my && ys[3] > my) {
        return location;
      } 
    }
    return null;
  }
}
void drawBackground() {
  background(210,180,105); 
  stroke(0);
  strokeWeight(1);
  for(int i = wspace; i < width-Gwidth; i+=interval) {
   line(i,wspace,i,height-wspace);
  }
  for(int i = wspace; i < height; i+=interval) {
   line(wspace,i,width-wspace-Gwidth,i);
  }
  
  option();
  
}
void addPiece(Location l, PImage i, int s,int p, Team t, boolean livee) {
  pieces.add(new Piece(l,i,s,p,t,livee));
}
void setup() {
   size(900/*660+Gwidth*/,/*660*/735);
   background(210,180,105); 
   gameStatus = GameStatus.START;
  strokeWeight(1);
  for(int i = 0; i<10; i++) {
    for(int j = 0; j<10; j++) {
      int x,y;
      x = (i*interval) + wspace;
      y = (j*interval) + wspace;
      locations[i][j] = new Location(x,y);
    }
  }
  for(int i = wspace; i < width-Gwidth; i+=interval) {
   line(i,wspace,i,height-wspace);
  }
  for(int i = wspace; i < height; i+=interval) {
   line(wspace,i,width-wspace-Gwidth,i);
  }
  
  option();
  undo = loadImage("undo.png");
  redo = loadImage("redo.png");
  GZol = loadImage("Green_Zol.png");
  RZol = loadImage("Red_Zol.png");
  GPo = loadImage("Green_Po.png");
  RPo = loadImage("Red_Po.png");
  GCha = loadImage("Green_Cha.png");
  RCha = loadImage("Red_Cha.png");
  GSang = loadImage("Green_Sang.png");
  RSang = loadImage("Red_Sang.png");
  GMa = loadImage("Green_Ma.png");
  RMa = loadImage("Red_Ma.png");
  GSa = loadImage("Green_Sa.png");
  RSa = loadImage("Red_Sa.png");
  GKing = loadImage("Green_King.png");
  RKing = loadImage("Red_King.png");
  
  addPiece (locations[0][0],RCha,1,13,Team.RED,true); 
  addPiece (locations[1][0],RMa,1,5,Team.RED,true);
  addPiece (locations[2][0],RSang,1,3,Team.RED,true);
  addPiece (locations[3][0],RSa,0,3,Team.RED,true);
  addPiece (locations[4][1],RKing,2,0,Team.RED,true);
  addPiece (locations[5][0],RSa,0,3,Team.RED,true);
  addPiece (locations[6][0],RSang,1,3,Team.RED,true);
  addPiece (locations[7][0],RMa,1,5,Team.RED,true);
  addPiece (locations[8][0],RCha,1,13,Team.RED,true);
  addPiece (locations[0][3],RZol,0,2,Team.RED,true);
  addPiece (locations[1][2],RPo,1,7,Team.RED,true);
  addPiece (locations[2][3],RZol,0,2,Team.RED,true);
  addPiece (locations[4][3],RZol,0,2,Team.RED,true);
  addPiece (locations[6][3],RZol,0,2,Team.RED,true);
  addPiece (locations[7][2],RPo,1,7,Team.RED,true);
  addPiece (locations[8][3],RZol,0,2,Team.RED,true);
   
  addPiece (locations[0][9],GCha,1,13,Team.BLUE,true);
  addPiece (locations[1][9],GMa,1,5,Team.BLUE,true);
  addPiece (locations[2][9],GSang,1,3,Team.BLUE,true);
  addPiece (locations[3][9],GSa,0,3,Team.BLUE,true);
  addPiece (locations[4][8],GKing,2,0,Team.BLUE,true);
  addPiece (locations[5][9],GSa,0,3,Team.BLUE,true);
  addPiece (locations[6][9],GSang,1,3,Team.BLUE,true);
  addPiece (locations[7][9],GMa,1,5,Team.BLUE,true);
  addPiece (locations[8][9],GCha,1,13,Team.BLUE,true);
  addPiece (locations[0][6],GZol,0,2,Team.BLUE,true);
  addPiece (locations[1][7],GPo,1,7,Team.BLUE,true);
  addPiece (locations[2][6],GZol,0,2,Team.BLUE,true);
  addPiece (locations[4][6],GZol,0,2,Team.BLUE,true);
  addPiece (locations[6][6],GZol,0,2,Team.BLUE,true);
  addPiece (locations[7][7],GPo,1,7,Team.BLUE,true);
  addPiece (locations[8][6],GZol,0,2,Team.BLUE,true);
}
void option() {
  strokeWeight(1);
  XX(locations[1][2]);
  XX(locations[7][2]); // floating 2
  XX(locations[0][3]);
  XX(locations[2][3]);
  XX(locations[4][3]);
  XX(locations[6][3]);
  XX(locations[8][3]);
  
  XX(locations[1][7]);
  XX(locations[7][7]); // downing 2
  XX(locations[0][6]);
  XX(locations[2][6]);
  XX(locations[4][6]);
  XX(locations[6][6]);
  XX(locations[8][6]);
  
  // 4, 1, 6, 3
  // 4, 3, 6, 1
  line(locations[3][0].x,locations[3][0].y,locations[5][2].x,locations[5][2].y);
  line(locations[3][2].x,locations[3][2].y,locations[5][0].x,locations[5][0].y);
  
  line(locations[3][7].x,locations[3][7].y,locations[5][9].x,locations[5][9].y);
  line(locations[3][9].x,locations[3][9].y,locations[5][7].x,locations[5][7].y);
  
}
void XX(Location location) {
  int x = location.x;
  int y = location.y;
  int x1 = x-4;
  int x2 = x+4;
  int y1 = y-4;
  int y2 = y+4;
  line(x1,y1,x2,y2);
  line(x2,y1,x1,y2);
}
void place(Piece piece,Location location) { //size 0,1,2
  if(!piece.live) return;
  //Location location = piece.location;
  PImage ima = piece.ima;
  int size = piece.size;
  int xlen = 0, ylen = 0,x,y;
  x = location.x;
  y = location.y;
  switch(size) {
    case 0:
     xlen = 42;
     ylen = 42;
     break;
    case 1:
     xlen = 60;
     ylen = 60;
     break;
    case 2:
     xlen = 78;
     ylen = 78;
     break;
    
  }
  strokeWeight(3);
  stroke(0,255,0);
  image(ima,x-xlen/2,y-ylen/2,xlen,ylen);
}
void drawPieces() {
  for(Piece p : pieces)
    place(p,p.location);
}
void drawSide() {
  tint(255,255);
  strokeWeight(2);
  
  rectMode(CORNER);
  fill(255,0,0);
  if(turn == Team.RED) {
    stroke(0,255,0);
  } else {
    stroke(0);
  }
  rect(width-Gwidth,0,Gwidth,height/2);
  fill(0,0,255);
  if(turn == Team.BLUE) {
    stroke(0,255,0);
  } else {
    stroke(0);
  }
  rect(width-Gwidth,height/2,Gwidth,height/2);
  strokeWeight(2);
  stroke(0);
  line(width-Gwidth,height/2,width,height/2);
  
  textSize(16);
  stroke(0);
  fill(255);
  rect(width-Gwidth+wspace,wspace,Gwidth - 2*wspace, height/2 - 2*wspace - 3*wspace);
  fill(255);
  stroke(0);
  text("Score:",width-Gwidth+30,height/2 - 3*wspace);
  text("Time:",width-Gwidth+30,height/2 - 2.5*wspace);
  image(undo,width-Gwidth+30,height/2 - 2.0*wspace,30,30);
  image(redo,width-Gwidth+30+60,height/2 - 2.0*wspace,30,30);
  
  stroke(0);
  fill(255);
  rect(width-Gwidth+wspace,wspace + height/2,Gwidth - 2*wspace, height/2 - 2*wspace - 3*wspace);
  fill(255);
  stroke(0);
  text("Score:",width-Gwidth+30,height/2 - 3*wspace + height/2);
  text("Time:",width-Gwidth+30,height/2 - 2.5*wspace + height/2);
  image(undo,width-Gwidth+30,height/2 - 2.0*wspace + height/2,30,30);
  image(redo,width-Gwidth+30+60,height/2 - 2.0*wspace + height/2,30,30);
  
  // TODO: DEAD pieces
  // rect(width-Gwidth+wspace,wspace,Gwidth - 2*wspace, height/2 - 2*wspace - 3*wspace);
  Pair[][] sides = new Pair[5][5];
  int _winter = (Gwidth-2*wspace)/5;
  int _hinter = (height/2 - 2*wspace - 3*wspace)/5;
  for(int i = 0; i < 5; i++) for(int j = 0; j < 5; j++) {
    int x = width - Gwidth + _winter*i+wspace;
    int y = _hinter*j+wspace;
    sides[i][j] = new Pair(x,y);
  }
  int cnt = 0;
  for(Piece piece : pieces) {
    if(piece.team == Team.BLUE && !piece.live) {
      int i = cnt % 5;
      int j = cnt / 5;
      image(piece.ima,sides[i][j].x,sides[i][j].y,wspace,wspace);
      cnt ++;
    }
  }
  
  sides = new Pair[5][5];
  cnt = 0;
  for(int i = 0; i < 5; i++) for(int j = 0; j < 5; j++) {
    int x = width - Gwidth + _winter*i+wspace;
    int y = height/2 + _hinter*j+wspace;
    sides[i][j] = new Pair(x,y);
  }
  for(Piece piece : pieces) {
    if(piece.team == Team.RED && !piece.live) {
      int i = cnt % 5;
      int j = cnt / 5;
      image(piece.ima,sides[i][j].x,sides[i][j].y,wspace,wspace);
      cnt ++;
    }
  }
}
void selectOne(Location location) {
  int x,y;
  x = location.x;
  y = location.y;
  Piece piece = location.piece;
  //for(Piece p : pieces) {
  //  if(p.location == location) {
  //    piece = p;
  //    break;
  //  }
  //}
  float e = 60/2; // edge of hexagon
  switch(piece.size) {
    case 0:
      e = 42/2;
      break;
    case 1:
      e = 63/2+1;
      break;
    case 2:
      e = 84/2;
       break;
  }
  float h = sqrt(3) * e / 2;
  
  float[] xs = new float[8];
  float[] ys = new float[8];
  xs[0] = x-e/2;
  xs[1] = x+e/2;
  xs[2] = x+h;
  xs[3] = xs[2];
  xs[4] = xs[1];
  xs[5] = xs[0];
  xs[7] = x-h;
  xs[6] = xs[7];
  
  ys[0] = y-h;
  ys[1] = ys[0];
  ys[2] = y-h/2;
  ys[3] = y+h/2;
  ys[4] = y+h;
  ys[5] = ys[4];
  ys[6] = ys[3];
  ys[7] = ys[2];
  
  strokeWeight(5);
  stroke(0,255,0);
  for(int i = 1; i<8; i++) {
    line(xs[i-1],ys[i-1],xs[i],ys[i]);
  }
  line(xs[0],ys[0],xs[7],ys[7]);
  
  /* temp */
  
  location.piece.nextLocations = getNextLocations(location.piece);
  
  /*  */
  
  //next
  tint(255,128);
  if(location.piece.nextLocations != null) {
    for(Location next : location.piece.nextLocations) {
      place(piece,next);
    }
  }
  tint(255,255);
}
class Pair {
  int x;
  int y;
  Pair(int xx, int yy) {
    x = xx;
    y = yy;
  }
}
/* TODO: */
ArrayList<Location> getNextLocations(Piece piece) {
  PImage image = piece.ima;
  int i,j;
  Pair[] qwer = {new Pair(0,-1), new Pair(1,0), new Pair(0,1), new Pair(-1,0)}; // N,E,S,W
  for(i = 0 ; i<10; i++) if(locations[i][0].x == piece.location.x) break;
  for(j = 0 ; j<10; j++) if(locations[0][j].y == piece.location.y) break;
  ArrayList<Location> nextLocations = new ArrayList<Location>();
  ArrayList<Pair> pairs = new ArrayList<Pair>();
 
  if(GZol == image || RZol == image) { // GZol,RZol,
    int direction = turn == Team.RED ? 1 : -1;
    for(int k = 1; k<4; k++) {
      Pair pair = new Pair(i+qwer[k].x,j+qwer[k].y * direction);
      pairs.add(pair);
    }
    
    if(i == 4 && (j == 1 || j == 8)) { // middle
      for(int k = 0; k<3; k+=2) {
        Pair pair = new Pair(i-1,j+qwer[k].y);
        pairs.add(pair);
        
        pair = new Pair(i+1,j+qwer[k].y);
        pairs.add(pair);
      }
    } else if(i == 5 && (j == 0 || j == 7)) { // 1
      Pair pair = new Pair(i-1,j+1);
      pairs.add(pair);
    } else if(i == 3 && (j == 0 || j == 7)) { // 2
      Pair pair = new Pair(i+1,j+1);
      pairs.add(pair);
    } else if(i == 3 && (j == 2 || j == 9)) { // 3
      Pair pair = new Pair(i+1,j-1);
      pairs.add(pair);
    } else if(i == 5 && (j == 2 || j == 9)) { // 4
      Pair pair = new Pair(i-1,j-1);
      pairs.add(pair);
    }
    
  } else if(GPo == image || RPo == image) {//GPo,RPo
    for(int k = 0; k<4; k++) {
      boolean jump = false;
      for(int l = 1; l<10; l++) {
        Pair pair = new Pair(i+qwer[k].x*l,j+qwer[k].y*l);
        if(pair.x < 0|| pair.x > 8 || pair.y > 9 || pair.y < 0) break;
        
        if(jump) {
          if(locations[pair.x][pair.y].piece != null) {
            if(locations[pair.x][pair.y].piece.ima == RPo || locations[pair.x][pair.y].piece.ima == GPo) break;
            pairs.add(pair);
            break;
          } else {
            pairs.add(pair);
          }
        } else if(locations[pair.x][pair.y].piece != null) {
          if(locations[pair.x][pair.y].piece.ima == RPo || locations[pair.x][pair.y].piece.ima == GPo) break;
          jump = true;
        }
      }
    }
    if(i == 5 && (j == 0 || j == 7)) { // 1
        Pair pair = new Pair(i-1,j+1);
        if(locations[pair.x][pair.y].piece != null && locations[pair.x][pair.y].piece.point != 7){
          pair = new Pair(pair.x-1,pair.y+1);
          pairs.add(pair);
        }
      } else if(i == 3 && (j == 0 || j == 7)) { // 2
        Pair pair = new Pair(i+1,j+1);
        if(locations[pair.x][pair.y].piece != null && locations[pair.x][pair.y].piece.point != 7){
          pair = new Pair(pair.x+1,pair.y+1);
          pairs.add(pair);
        }
      } else if(i == 3 && (j == 2 || j == 9)) { // 3
        Pair pair = new Pair(i+1,j-1);
        if(locations[pair.x][pair.y].piece != null && locations[pair.x][pair.y].piece.point != 7){
          pair = new Pair(pair.x+1,pair.y-1);
          pairs.add(pair);
        }
      } else if(i == 5 && (j == 2 || j == 9)) { // 4
        Pair pair = new Pair(i-1,j-1);
        if(locations[pair.x][pair.y].piece != null && locations[pair.x][pair.y].piece.point != 7){
          pair = new Pair(pair.x-1,pair.y-1);
          pairs.add(pair);
        }
      }
  } else if(GCha == image || RCha == image) { // GCha,RCha,
    for(int k = 0; k<4; k++) {
      for(int l = 1; l<10; l++) {
        Pair pair = new Pair(i+qwer[k].x*l,j+qwer[k].y*l);
        if(pair.x < 0|| pair.x > 8 || pair.y > 9 || pair.y < 0) break;
        Piece block;
        
        pairs.add(pair);
        if(locations[pair.x][pair.y].piece != null) break;
      }
    }
    if(i == 4 && (j == 1 || j == 8)) { // middle
      for(int k = 0; k<3; k+=2) {
        Pair pair = new Pair(i-1,j+qwer[k].y);
        pairs.add(pair);
        
        pair = new Pair(i+1,j+qwer[k].y);
        pairs.add(pair);
      }
    } else if(i == 5 && (j == 0 || j == 7)) { // 1
      Pair pair = new Pair(i-1,j+1);
      pairs.add(pair);
      if(locations[pair.x][pair.y].piece == null ){
        pair = new Pair(pair.x-1,pair.y+1);
        pairs.add(pair);
      }
    } else if(i == 3 && (j == 0 || j == 7)) { // 2
      Pair pair = new Pair(i+1,j+1);
      pairs.add(pair);
      if(locations[pair.x][pair.y].piece == null ){
        pair = new Pair(pair.x+1,pair.y+1);
        pairs.add(pair);
      }
    } else if(i == 3 && (j == 2 || j == 9)) { // 3
      Pair pair = new Pair(i+1,j-1);
      pairs.add(pair);
      if(locations[pair.x][pair.y].piece == null ){
        pair = new Pair(pair.x+1,pair.y-1);
        pairs.add(pair);
      }
    } else if(i == 5 && (j == 2 || j == 9)) { // 4
      Pair pair = new Pair(i-1,j-1);
      pairs.add(pair);
      if(locations[pair.x][pair.y].piece == null ){
        pair = new Pair(pair.x-1,pair.y-1);
        pairs.add(pair);
      }
    }
  } else if(GSang == image || RSang == image) { //GSang,RSang,
    for(int k = 0; k<4; k++) {
      Pair block = new Pair(i+qwer[k].x,j+qwer[k].y);
      Pair p1, p2;
      if(block.x < 0|| block.x > 8 || block.y > 9 || block.y < 0) continue;
      if(locations[block.x][block.y].piece != null) continue;
      
      Pair b1,b2;
      b1 = new Pair(block.x+qwer[k].x+qwer[k].y,block.y+qwer[k].y+qwer[k].x);
      if(b1.x >= 0 && b1.x < 9 && b1.y >= 0 && b1.y < 10) {
        if(locations[b1.x][b1.y].piece == null) {
          p1 = new Pair(b1.x+qwer[k].x+qwer[k].y,b1.y+qwer[k].y+qwer[k].x);
          pairs.add(p1);
        }
      }
      
      b2 = new Pair(block.x+qwer[k].x-qwer[k].y,block.y+qwer[k].y-qwer[k].x);
      if(b2.x >= 0 && b2.x < 9 && b2.y >= 0 && b2.y < 10) {
        if(locations[b2.x][b2.y].piece == null) {
          p2 = new Pair(b2.x+qwer[k].x-qwer[k].y,b2.y+qwer[k].y-qwer[k].x);
          pairs.add(p2);
        }
      }
    }
    
  } else if(GMa == image || RMa == image) { //GMa,RMa,
    for(int k = 0; k<4; k++) {
      Pair block = new Pair(i+qwer[k].x,j+qwer[k].y);
      Pair p1, p2;
      if(block.x < 0|| block.x > 8 || block.y > 9 || block.y < 0) continue;
      if(locations[block.x][block.y].piece != null) continue;
      // i+qwer[k].x -> x + 0
      // j+qwer[k].y -> y + 1
      
      p1 = new Pair(block.x+qwer[k].x+qwer[k].y,block.y+qwer[k].y+qwer[k].x);
      p2 = new Pair(block.x+qwer[k].x-qwer[k].y,block.y+qwer[k].y-qwer[k].x);
      
      pairs.add(p1);
      pairs.add(p2);
    }
  
  } else if(GSa == image || RSa == image || GKing == image || RKing == image) { //GSa,RSa,GKing,RKing;
    
    for(int k = 0; k<4; k++) {
      Pair pair = new Pair(i+qwer[k].x,j+qwer[k].y);
      if(pair.x < 3 || pair.x > 5) continue;
      if(Team.RED == turn) {
        if(pair.y < 0 || pair.y > 2) continue;
      } else {
        if(pair.y < 7 || pair.y > 9) continue;
      }
      pairs.add(pair);
    }
    
    // 4,1 ,, 4,8
    if(i == 4 && (j == 1 || j == 8)) { // middle
      for(int k = 0; k<3; k+=2) {
        Pair pair = new Pair(i-1,j+qwer[k].y);
        pairs.add(pair);
        
        pair = new Pair(i+1,j+qwer[k].y);
        pairs.add(pair);
      }
    } else if(i == 5 && (j == 0 || j == 7)) { // 1
      Pair pair = new Pair(i-1,j+1);
      pairs.add(pair);
    } else if(i == 3 && (j == 0 || j == 7)) { // 2
      Pair pair = new Pair(i+1,j+1);
      pairs.add(pair);
    } else if(i == 3 && (j == 2 || j == 9)) { // 3
      Pair pair = new Pair(i+1,j-1);
      pairs.add(pair);
    } else if(i == 5 && (j == 2 || j == 9)) { // 4
      Pair pair = new Pair(i-1,j-1);
      pairs.add(pair);
    }
  }
  
  
  for(Pair pair : pairs) {
    if(pair.x < 0|| pair.x > 8 || pair.y > 9 || pair.y < 0) continue;
    Piece block;
    if((block = locations[pair.x][pair.y].piece) != null) {
      if(block.team ==turn) {
        continue;
      }
    }
    if(piece.point == 2) { // Zol
      if(turn == Team.RED && j > pair.y) continue;
      else if(turn == Team.BLUE && j < pair.y) continue;
    }
    nextLocations.add(locations[pair.x][pair.y]);
  }
  
  return nextLocations;
}

boolean onStart() {
  int x1,y1,w,h;
  x1 = width - Gwidth + wspace;
  y1 = locations[0][3].y;
  w = Gwidth-2*wspace;
  h = 2*interval;
  return mouseX > x1 && mouseX < x1+w && mouseY > y1 && mouseY < y1+h;
}
void drawButton() {
  int x1,y1,w,h;
  x1 = width - Gwidth + wspace;
  y1 = locations[1][4].y;
  w = Gwidth-2*wspace;
  h = 2*interval;
  
  color rectColor = color(255);
  color textColor = color(255,0,0);
  color strokeColor = color(0);
  int strokeWeight = 1;
  
  if(onStart()) {
    rectColor = color(128);
    textColor = color(255,55,55);
    strokeColor = color(0,0,255);
    strokeWeight = 3;
  }
  
  strokeWeight(strokeWeight);
  stroke(strokeColor);
  fill(rectColor);
  rect(x1,y1,w,h);
  textSize(32);
  fill(textColor);
  textAlign(CENTER,CENTER);
  text("Start",x1+w/2,y1+h/2);
}

void drawChange() {
  for(Piece p : pieces) {
    if(p.location == locations[1][0] || p.location == locations[2][0] || p.location == locations[7][0] || p.location == locations[6][0])
      place(p,p.location);
    else if(p.location == locations[1][9] || p.location == locations[2][9] || p.location == locations[7][9] || p.location == locations[6][9]) {
      place(p,p.location);
    }
  }
  
  drawArrow(locations[1][0].x+interval/2,locations[1][0].y+interval/2,true);
  drawArrow(locations[1][0].x+interval/2,locations[1][0].y+interval/2+25,false);
  drawArrow(locations[6][0].x+interval/2,locations[6][0].y+interval/2,true);
  drawArrow(locations[6][0].x+interval/2,locations[6][0].y+interval/2+25,false);
  
  drawArrow(locations[1][8].x+interval/2,locations[1][8].y+interval/2,true);
  drawArrow(locations[1][8].x+interval/2,locations[1][8].y+interval/2-25,false);
  drawArrow(locations[6][8].x+interval/2,locations[6][8].y+interval/2,true);
  drawArrow(locations[6][8].x+interval/2,locations[6][8].y+interval/2-25,false);
  
  stroke(0);
  fill(255);
  rectMode(CORNER);
  rect(locations[2][3].x,locations[2][3].y,4*interval,2*interval);
  
  textSize(50);
  fill(0);
  textAlign(CENTER,CENTER);
  text("Start",locations[2][3].x+2*interval,locations[2][3].y+interval);
  
}
void drawArrow(int x, int y, boolean right) {
  
  rectMode(CENTER);
  stroke(30,255,0);
  fill(30,255,0);
  
  int reverse = right ? 1 : -1;
  
    rect(x-7*reverse,y,28,10);
    triangle(x+3*reverse,y-10,x+3*reverse,y+10,x+20*reverse,y);
}
int onChange() {
  int x,y;
  x = mouseX;
  y = mouseY;
  if(x > locations[6][0].x + 10 && x < locations[7][0].x - 15 && y > locations[6][0].y + interval/2-10 && y < locations[6][1].y) {
    return 1;
  } else if(x > locations[1][0].x + 10 && x < locations[2][0].x - 15 && y > locations[1][0].y + interval/2-10 && y < locations[1][1].y) {
    return 2;
  } else if(x > locations[1][8].x + 10 && x < locations[2][8].x - 15 && y < locations[1][8].y + interval/2+10 && y > locations[1][8].y) {
    return 3;
  } else if(x > locations[6][8].x + 10 && x < locations[7][8].x - 15 && y < locations[6][8].y + interval/2+10 && y > locations[6][8].y) {
    return 4;
  } else if(x > locations[2][3].x && x < locations[2][3].x+4*interval && y > locations[2][3].y && y < locations[2][3].y+2*interval) { 
    //rect(locations[3][4].x,locations[3][4].y,4*interval,2*interval);
    return 0;
  }
  return -1;
}
void swap(Location a, Location b) {
  Piece p1 = null,p2 = null;
  for(Piece p : pieces) {
    if(p.location == a) {
      p1 = p;
    } else if(p.location == b) {
      p2 = p;
    }
  }
  Location t1 = p1.location;
  p1.location = p2.location;
  p2.location = t1;
  
  Piece t2 = p1.location.piece;
  p1.location.piece = p2.location.piece;
  p2.location.piece = t2;
  
}
void mousePressed() {
  switch(gameStatus) {
    case START:
      if(onStart()) gameStatus = GameStatus.START_C;
      print("Hi~!\n");
      break;
      
    case START_C:
      switch(onChange()) {
      case 1:
        swap(locations[6][0],locations[7][0]);
        break;
        
      case 2:
        swap(locations[1][0],locations[2][0]);
        break;
        
       case 3:
        swap(locations[1][9],locations[2][9]);
        break;
        
       case 4:
        swap(locations[6][9],locations[7][9]);
        break;
        
       case 0: //start!
         gameStatus = GameStatus.GOING;
         break;
    }
      break;
      
    case GOING:
      Location location = touchArea();
      if(location == null) return; //bounded out
      
      if(selected) { // move one
        if(selectedPiece.nextLocations.contains(location)) 
          moveOne(selectedPiece,location);
        selected = false;
        
      } else if(location.piece == null) { //empty location
        return;
      } else { // select new one
        if(location.piece.team != turn) return;
        selectedPiece = location.piece; 
        selected = true;
      }
      
      break;
  }
}
void moveOne(Piece piece, Location newLocation) {
  if(newLocation.piece != null && newLocation.piece.team == turn) {
    return;
  }
  piece.location.piece = null; 
  piece.location = newLocation;
  if(newLocation.piece != null) newLocation.piece.live = false;
  newLocation.piece = piece;
  turn = turn == Team.BLUE ? Team.RED : Team.BLUE;
  //TODO: memorizing in stack
  
}
void draw() {
  drawBackground();
  
  switch(gameStatus) {
    case START: //right side, init button
      drawButton();
      break;
    
    case START_C:
      drawSide();
      drawChange();
      break;
      
    case GOING:
      drawPieces();
      drawSide();
      if(selected && selectedPiece != null) selectOne(selectedPiece.location);
      break;
      
    case PAUSE:
      
      break;
      
    case END:
      
      break;
  }
}
