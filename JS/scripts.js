var mouseX = 0;
var mouseY = 0;
var dropHeight = 200;
var platform = "PC";

function view () {
    this.currentView = "launcher";
    this.pushView = function(view) {
        this.currentView = view;
        document.getElementById('launcher').style.display = 'none';
        document.getElementById('game').style.display = 'none';
        document.getElementById('scores').style.display = 'none';
        document.getElementById(view).style.display = 'block';
    };
}

var View = new view();

function player () {
    this.x = 0;
    this.y = 0;
    this.drawPlayer = function() {
        if (View.currentView == "game") {
            //console.log(mouseX);
            Player.x = mouseX;
            Player.y = mouseY;
            document.getElementById('player').style.left = String(mouseX-25)+"px";
            document.getElementById('player').style.top = String(mouseY-25)+"px";
        }
    };
}

var Player = new player();

function blocks () {
    this.id = 1;
    this.position = [
        [50],
        [200],
        [1]
    ]
    this.newBlock = function() {
        var newdiv = document.createElement('div');
        newdiv.setAttribute('id',Blocks.id);
        newdiv.setAttribute('class', 'block');
        document.getElementById('game').appendChild(newdiv);
        var size = getRandomInt(screen.width/22,screen.width/7);
        document.getElementById(Blocks.id).style.width = String(size)+"px";
        var position = getRandomInt(25, screen.width-size);
        Blocks.position[0].push(0);
        Blocks.position[1].push(0);
        Blocks.position[2].push(getRandomInt(1,5));
        Blocks.updatePosition(Blocks.id, position, dropHeight);
        this.id = this.id+1;
    };
    this.updatePosition = function(id, x, y) {
        Blocks.position[0][id] = x;
        Blocks.position[1][id] = y;
        document.getElementById(id).style.left = String(x)+"px";
        document.getElementById(id).style.top = String(y)+"px";
    };
}

var Blocks = new blocks();

function load() {
    document.body.addEventListener('touchmove', function(e) { e.preventDefault(); }, false);
    if (platform == "PC") {
        document.captureEvents(Event.MOUSEMOVE);
        document.onmousemove = getMouseXY;
    }
    console.log("Application Started!");
}

function getMouseXY(e) {
  mouseX = e.pageX
  mouseY = e.pageY 
  // catch possible negative values in NS4
  if (mouseX < 0){mouseX = 0}
  if (mouseY < 0){mouseY = 0}  
  // show the position values in the form named Show
  // in the text fields named MouseX and MouseY
  //document.Show.MouseX.value = tempX
  //document.Show.MouseY.value = tempY
    Player.drawPlayer();
  return true
}

function getRandomInt(min, max) {
  return Math.floor(Math.random() * (max - min + 1)) + min;
}