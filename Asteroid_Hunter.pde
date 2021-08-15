PImage foto;//Űrhajó képe
PImage asteroid;
PImage asteroid2;
PImage asteroid3;
PImage asteroid4;//aszteroida
PImage explode;//robbanás
int magas;
int szorzo;
int szeles;
int mozgat_bal =0;
int mozgat_jobb =0;
int mozgat_fel=0;
int mozgat_le=0;
int ido;
int db =0;
int csdb =0;
int r;
int r2;
int idoz;
int vertik;
int cdc;
boolean over = false;
boolean pause;
int count;
int loves;
boolean cd;
int h;
boolean csill = true;
float sp1;
float sp2;
float psp1;
float psp2;
int startmillis = 0;
int pausemillis = 0;
int x_fele;
int keret_bal;
int keret_jobb;
int y_fele;
int laser = 1;
int rekord;
PrintWriter output;
Ship hajo = new Ship();
Akad[] arrayOfAkad = new Akad[900000];
Shot[] shots = new Shot[9000000];
Star[] csillagok = new Star[50];
PImage [] asteroids = new PImage[4];
void setup() {
  fullScreen();
  String [] data = loadStrings("record.txt");
  rekord = int(data[0]);
  output = createWriter("record.txt");
  hajo.y = height-50;
  imageMode(CENTER);
  magas=height;
  szorzo = magas/16;
  szeles = szorzo*9;
  x_fele = width/2;
  keret_bal = x_fele - szeles/2;
  keret_jobb = x_fele + szeles/2;
  y_fele = magas/2;
  background(0);
  fill(255);
  textSize(20);
  text("Klikk a starthoz\nNyilak\nSpace",width/2,height/2);
  frameRate(120);
  over = false;
  loves =0;
  foto = loadImage("ship.png");
  asteroid = loadImage("asteroid.png");
  asteroids[0]  = asteroid;
  asteroid2 = loadImage("asteroid2.png");
  asteroids[1] = asteroid2;
  asteroid3 = loadImage("asteroid3.png");
  asteroids[2] = asteroid3;
  asteroid4 = loadImage("asteroid4.png");
  asteroids[3] = asteroid4;
  explode = loadImage("explode.png");
  for(int i=0;i<50;i++){
    r2 = int(random(keret_bal,keret_jobb));
    csillagok[i] = new Star(r2);
    csdb++;
  }
  hajo.x = x_fele;
  noLoop();
  //("setup_done");
}
void alap(){
  background(0);
  fill(255);
  textSize(20);
  textAlign(CENTER);
  text("Klikk a starthoz",width/2,height/2);
  textAlign(LEFT);
}
void draw() {
  //("draw_started");
  int fps = int(frameRate);
  if ( frameCount > cdc +15){
    cd = false;
  }
  ido = millis()-startmillis;
  sp1 = 2 + ido/8000.0;
  sp2 = 4 + ido/8000.0;
  background(0);
  //("draw_started_2");
  if(szeles<width-2){
    keret();
  }
  r = int(random(keret_bal,keret_jobb));
  idoz = ido%200;
  if (idoz < 8) {
    arrayOfAkad[db] = new Akad(r);
    db++;
  }
  //("draw_started_3");
  for(int i=0;i<csdb;i++){
    if(csillagok[i]==null){
      csillagok[i] = new Star(r2);
    }
  }
  //("draw_started_4");
  if (db>0) {  
    for (int d=0; d<csdb; d++) {
      if (csill ==true) { 
        csillagok[d].display();
        csillagok[d].move();
      }
    }
    for (int i=0; i<db; i++) {
      arrayOfAkad[i].display();
      arrayOfAkad[i].megy();
      arrayOfAkad[i].check();
    }
  }
  //("draw_started_5");
  for (int j=0; j<loves; j++) {
    shots[j].display();
    shots[j].move();
  }
  if(count != 0 && count%20 == 0 && count != laser*10+(laser-2)*10){
    laser++;
  }
  //("draw_started_6");
  fill(0, 255, 255);
  textSize(15);
  text("FPS:"+fps+"  Pontszám:"+count+" Szünet: p   Csillagok: c   X:"+hajo.x+"  Y:"+hajo.y+"\n Irányítás: Nyilak   Lövés: Space\n 20 pontonként fejlődik a lézered, minél fejlettebb, annál több\n aszteroidát tud felrobbantani egy lövedék", 30, 30);
  if (over ==true) {
    textSize(30);
    textAlign(CENTER);
    if(count > rekord){
      rekord = count;
    }
    text("Játék vége\nPontjaid:"+count+"\nRekord:"+rekord+"\nNyomj r-t az újrakezdéshez\n Q a kilépéshez", x_fele, y_fele-y_fele/2);
    noLoop();
  }
  //("draw_started_7");
  hajo.display();
  hajo.move(mozgat_bal,mozgat_jobb,mozgat_fel,mozgat_le);
  hajo.getter();
  if(frameCount == 1){
    alap();
  }
  //("draw_done");
}
class Ship {
  int x;
  int y;
  Ship() {
    x = x_fele;
  }
  void display() {
    fill(255, 0, 0);
    imageMode(CENTER);
    image(foto, x, y);
  }
  void move(int bal,int jobb,int fel,int le) {
    if (jobb == 1 && x<keret_jobb-20) {
      x+=4;
    }
    if (bal == 1 && x>keret_bal+20) {
      x-=4;
    }
    if (le == 1 && y<height){
      y+=4;
    }
    if (fel == 1 && y>30){
      y-=4;
    }
  }
  void getter() {
    vertik = x;
  }
}
void keyPressed() {
  if (keyCode==RIGHT) {
    mozgat_jobb = 1;
  } 
  if (keyCode==LEFT) {
    mozgat_bal = 1;
  }
  if (keyCode==UP){
    mozgat_fel = 1;
  }
  if (keyCode==DOWN){
    mozgat_le = 1;
  }
  if (key=='p') {
    if (pause==false) {
      pausemillis = millis();
      noLoop();
      pause = true;
    } else {
      startmillis = millis() - pausemillis;
      loop();
      pause = false;
      mozgat_le = 0;
      mozgat_fel = 0;
      mozgat_bal = 0;
      mozgat_jobb = 0;
    }
  }
  if (key==' ') {
    if (cd != true) {
      shots[loves] = new Shot(laser);
      loves++;
      cd = true;
      cdc = frameCount;
    }
  }
  if (key=='c') {
    if (csill==true) {
      csill = false;
    } else {
      csill = true;
    }
  }
  if (key=='r') {
    if (over == true) {
      hajo.x = x_fele;
      hajo.y = height-50;
      for (int ez=0; ez<db; ez++) {
        arrayOfAkad[ez] = null;
      }
      db = 0;
      mozgat_fel = 0;
      mozgat_le =0;
      mozgat_bal =0;
      mozgat_jobb=0;
      count = 0;
      sp1 = 1;
      sp2 = 3;
      for (int ez=0; ez<db; ez++) {
        shots[ez] = null;
      }
      loves = 0;
      laser = 1;
      cd = false;
      over=false;
      startmillis = millis();
      textSize(11);
      textAlign(LEFT);
      imageMode(CENTER);
      loop();
    }
  }
  if(key == 'q' && over == true){
    output.println(rekord);
    output.flush();
    output.close();
    exit();
  }
}
void keyReleased() {
  if (keyCode==RIGHT) {
    mozgat_jobb = 0;
  }
  if(keyCode==LEFT){
    mozgat_bal =0;
  }
  if (keyCode==UP) {
    mozgat_fel = 0;
  }
  if (keyCode==DOWN){
    mozgat_le=0;
  }
}
void mousePressed(){
  loop();
}
class Akad {
  int x;
  float y;
  float speed = random(sp1,sp2);
  boolean alive;
  int robb = 10;
  int kep = int(random(4));
  Akad(int get) {
    x = get;
    y = 0;
    alive = true;
  }
  void display() {
    if (alive==true) {
      fill(0, 0, 255);
      imageMode(CENTER);
      image(asteroids[kep],x, y);
    }
    if(alive == false && robb < 10){
      image(explode,x,y);
      robb++;
    }
  }
  void megy() {
    if (y<height+20) {
      y += speed;
    }
  }
  void check() {
    if (y>=hajo.y-30 && y<hajo.y+30 && alive == true) {
      if (x<vertik+35 && x>vertik-35) {
        over = true;
      }
    }
    if (y>height) {
      alive = false;
    }
    for (h=0; h<loves; h++) {
      if (shots[h].x>this.x-15 && shots[h].x<this.x+15) {
        if (shots[h].y>this.y-15 && shots[h].y<this.y+15) {
          if (shots[h].z > 0 && this.alive == true) {
            alive = false;
            shots[h].z -= 1;
            image(explode,x,y);
            robb = 0;
            count++;
          }
        }
      }
    }
  }
}
class Shot {
  int x;
  int y;
  int z;
  color c;
  Shot(int fejl) {
    x = vertik;
    y = hajo.y-30;
    z = fejl;
    switch (fejl){
      case 1: c = color(255,255,0);
      break;
      case 2: c = color(0,255,0);
      break;
      case 3: c = color(0,0,255);
      break;
      case 4: c = color(255,0,255);
      break;
      default: c = color(255,0,0);
      break;
    }
  }
  void display() {
    if (z>0) {
      fill(c);
      rectMode(CENTER);
      rect(x, y, 8, 20, 5);
    }
  }
  void move() {
    y-=8;
    if (y<-11) {
      z = 0;
    }
  }
}
class Star {
  int x;
  float y;
  color c;
  float speed = random(0.3);
  Star(int hely) {
    x = hely;
    y = random(height);
    c = color(255);
  }
  void display() {
    fill(c);
    ellipseMode(CENTER);
    ellipse(x, y, 3, 3);
  }
  void move() {
    if (y<height) {
      y+= speed;
    } else {
      y = 0.0;
    }
  }
}
void keret(){
  //("keret_started");
  for(int i=0;i<3;i++){
    //("keret_kerlek");
    stroke(0,255-i*80,0);
    line(keret_bal - i,0,keret_bal-i,displayHeight);
    noStroke();
  }
  //("keret_1");
  for(int i=0;i<3;i++){
    stroke(0,255-i*80,0);
    line(keret_jobb + i,0,keret_jobb + i,displayHeight);
    noStroke();
  }
  //("keret_done");
}
