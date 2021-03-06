// Generated by LiveScript 1.2.0
(function(){
  var Bubble, BubbleField;
  window.Bubble = Bubble = (function(superclass){
    var prototype = extend$((import$(Bubble, superclass).displayName = 'Bubble', Bubble), superclass).prototype, constructor = Bubble;
    function Bubble(place, x, y){
      var texture;
      place == null && (place = 'top');
      x == null && (x = 0);
      y == null && (y = 0);
      this.update = bind$(this, 'update', prototype);
      texture = PIXI.Texture.fromImage('assets/img/bubble.png');
      Bubble.superclass.call(this, texture);
      this.scale.x = this.scale.y = random(0.1, 0.4);
      this.alpha = random(0.2, 0.6);
      this.speedX = random(200, 700);
      this.speedY = random(2, 5);
      this.ampX = random(10, 60);
      switch (place) {
      case 'top':
        this.startX = random(0, 1080);
        this.position.y = 780;
        break;
      case 'left':
        this.startX = -100;
        this.position.y = random(0, 780);
        break;
      case 'right':
        this.startX = 1080 + 100;
        this.position.y = random(0, 780);
        break;
      case 'custom':
        this.startX = x;
        this.position.y = y;
      }
    }
    prototype.update = function(t, v){
      this.position.y -= v.y;
      this.startX -= v.x;
      this.position.y -= this.speedY;
      this.position.x = this.startX + this.ampX * Math.sin(t / this.speedX);
      if (this.position.y < -50) {
        return this.dead = true;
      }
    };
    return Bubble;
  }(PIXI.Sprite));
  window.BubbleField = BubbleField = (function(superclass){
    var prototype = extend$((import$(BubbleField, superclass).displayName = 'BubbleField', BubbleField), superclass).prototype, constructor = BubbleField;
    function BubbleField(freq){
      freq == null && (freq = 1);
      this.burst = bind$(this, 'burst', prototype);
      this.update = bind$(this, 'update', prototype);
      BubbleField.superclass.call(this);
      this.freq = freq;
      this.bubbles = [];
      this.stage = new PIXI.DisplayObjectContainer();
    }
    prototype.update = function(t, v){
      var newBubbles, i$, ref$, len$, bubble;
      newBubbles = [];
      for (i$ = 0, len$ = (ref$ = this.bubbles).length; i$ < len$; ++i$) {
        bubble = ref$[i$];
        bubble.update(t, v);
        if (bubble.dead) {
          this.removeChild(bubble);
        } else {
          newBubbles[newBubbles.length] = bubble;
        }
      }
      if (Math.random() <= this.freq) {
        bubble = new Bubble();
        this.addChild(bubble);
        newBubbles[newBubbles.length] = bubble;
        bubble = new Bubble('left');
        this.addChild(bubble);
        newBubbles[newBubbles.length] = bubble;
        bubble = new Bubble('right');
        this.addChild(bubble);
        newBubbles[newBubbles.length] = bubble;
      }
      return this.bubbles = newBubbles;
    };
    prototype.burst = function(n, x, y){
      var i$, i, bubble, ref$, results$ = [];
      n == null && (n = 30);
      x == null && (x = 540);
      y == null && (y = 360);
      for (i$ = 0; i$ < n; ++i$) {
        i = i$;
        bubble = new Bubble('custom', random(x - 40, x + 40), random(y - 40, y + 40));
        this.addChild(bubble);
        results$.push((ref$ = this.bubbles)[ref$.length] = bubble);
      }
      return results$;
    };
    return BubbleField;
  }(PIXI.DisplayObjectContainer));
  function bind$(obj, key, target){
    return function(){ return (target || obj)[key].apply(obj, arguments) };
  }
  function extend$(sub, sup){
    function fun(){} fun.prototype = (sub.superclass = sup).prototype;
    (sub.prototype = new fun).constructor = sub;
    if (typeof sup.extended == 'function') sup.extended(sub);
    return sub;
  }
  function import$(obj, src){
    var own = {}.hasOwnProperty;
    for (var key in src) if (own.call(src, key)) obj[key] = src[key];
    return obj;
  }
}).call(this);
