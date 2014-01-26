// Generated by LiveScript 1.2.0
(function(){
  var neutral, aggressive, shy, NPC, randomNpc, NPCController;
  neutral = function(npc, t){
    var coefs;
    if (npc.neutralCoefs == null) {
      npc.neutralCoefs = {
        a: random(700, 2000),
        b: random(700, 2000),
        c: random(700, 2000),
        d: random(700, 2000)
      };
    }
    coefs = npc.neutralCoefs;
    npc.direction = Math.sin(t / coefs.a) * Math.sin(t / coefs.b) * Math.cos(t / coefs.c);
    return npc.speed = 0.3 + 2.7 * (1 + 0.5 * Math.sin(t / coefs.d));
  };
  aggressive = function(npc, t){
    var coefs, px, py, dist, targetSpeed, targetDirection, ddiff;
    if (npc.aggressiveCoefs == null) {
      npc.aggressiveCoefs = {
        a: random(700, 2000),
        b: random(700, 2000),
        c: random(700, 2000),
        d: random(700, 2000)
      };
    }
    coefs = npc.aggressiveCoefs;
    px = npc.position.x - 540;
    py = npc.position.y - 360;
    dist = Math.sqrt(px * px + py * py);
    if (dist < 300 && (npc.extra.directionless || (px > 0 && npc.dir === 'left') || (px < 0 && npc.dir === 'right'))) {
      targetSpeed = npc.maxSpeed;
      targetDirection = Math.atan2(-py, -px);
      if (npc.dir === 'left' && px > 0) {
        if (py < 0) {
          targetDirection = targetDirection - Math.PI;
        } else {
          targetDirection = targetDirection + Math.PI;
        }
      }
    } else {
      targetDirection = Math.sin(t / coefs.a) * Math.sin(t / coefs.b) * Math.cos(t / coefs.c);
      targetSpeed = 0.3 + 2.7 * (1 + 0.5 * Math.sin(t / coefs.d));
    }
    npc.speed = npc.speed + (targetSpeed - npc.speed) / 20;
    ddiff = (targetDirection - npc.direction) / 20;
    if (ddiff > 0.1) {
      ddiff = 0.1;
    }
    if (ddiff < -0.1) {
      ddiff = -0.1;
    }
    return npc.direction += (targetDirection - npc.direction) / 20;
  };
  shy = function(npc, t){
    return neutral(npc, t);
  };
  window.NPC = NPC = (function(superclass){
    var prototype = extend$((import$(NPC, superclass).displayName = 'NPC', NPC), superclass).prototype, constructor = NPC;
    function NPC(arg$, x, y){
      var sprite, ai, pivot, maxSpeed, ref$, extra, collide, texture;
      sprite = arg$.sprite, ai = arg$.ai, pivot = arg$.pivot, maxSpeed = (ref$ = arg$.maxSpeed) != null ? ref$ : 3, extra = (ref$ = arg$.extra) != null
        ? ref$
        : {}, collide = (ref$ = arg$.collide) != null
        ? ref$
        : function(){
          return null;
        };
      this.update = bind$(this, 'update', prototype);
      texture = PIXI.Texture.fromImage("assets/img/" + sprite + ".png");
      NPC.superclass.call(this, texture);
      this.aiFn = ai;
      this.collideFn = collide;
      this.position.x = x;
      this.position.y = y;
      this.scale.x = this.scale.y = 0.3;
      import$(this.pivot, pivot);
      this.maxSpeed = maxSpeed;
      this.extra = extra;
      if (Math.random() <= 0.5) {
        this.dir = 'left';
        this.scale.x *= -1;
      } else {
        this.dir = 'right';
      }
      this.direction = 0;
      this.speed = 2;
    }
    prototype.update = function(time, v){
      var direction, sd, cd, px, py, distSq;
      this.position.x -= v.x;
      this.position.y -= v.y;
      this.aiFn(this, time);
      this.rotation = this.direction;
      direction = this.direction;
      if (this.dir === 'left') {
        direction = Math.PI + direction;
      }
      sd = Math.sin(direction);
      cd = Math.cos(direction);
      this.position.x += cd * this.speed;
      this.position.y += sd * this.speed;
      px = this.position.x - 540;
      py = this.position.y - 360;
      distSq = px * px + py * py;
      if (distSq < 8100 && !this.collided) {
        this.collided = true;
        return this.collideFn();
      } else if (distSq > 8100 && this.collided) {
        return this.collided = false;
      }
    };
    return NPC;
  }(PIXI.Sprite));
  randomNpc = function(){
    var npcs;
    npcs = [
      {
        sprite: 'npcs/cow-fish',
        ai: shy,
        pivot: {
          x: 350,
          y: 300
        },
        collide: function(){
          return window.clearVision();
        }
      }, {
        sprite: 'npcs/electro-fish',
        ai: neutral,
        pivot: {
          x: 300,
          y: 200
        },
        collide: function(){
          return window.hurt(30);
        }
      }, {
        sprite: 'npcs/eye-thing',
        ai: neutral,
        pivot: {
          x: 230,
          y: 170
        },
        collide: function(){
          window.hurt(10);
          return window.clearVision();
        }
      }, {
        sprite: 'npcs/flowerhead',
        ai: shy,
        pivot: {
          x: 250,
          y: 250
        },
        collide: function(){
          return window.heal(10);
        }
      }, {
        sprite: 'npcs/googlie-eyes',
        ai: aggressive,
        pivot: {
          x: 250,
          y: 225
        },
        maxSpeed: 4,
        extra: {
          directionless: true
        },
        collide: function(){
          return window.hurt(10);
        }
      }, {
        sprite: 'npcs/heart-fish',
        ai: neutral,
        pivot: {
          x: 300,
          y: 200
        },
        collide: function(){
          return window.heal(30);
        }
      }, {
        sprite: 'npcs/monkey-fish',
        ai: shy,
        pivot: {
          x: 270,
          y: 300
        },
        collide: function(){
          return window.heal(11);
        }
      }, {
        sprite: 'npcs/squid',
        ai: aggressive,
        pivot: {
          x: 320,
          y: 170
        },
        collide: function(){
          return window.heal(15);
        }
      }, {
        sprite: 'npcs/ufo-fish',
        ai: aggressive,
        pivot: {
          x: 500,
          y: 400
        },
        collide: function(){
          return window.hurt(15);
        }
      }
    ];
    return npcs[Math.floor(npcs.length * Math.random())];
  };
  window.NPCController = NPCController = (function(superclass){
    var prototype = extend$((import$(NPCController, superclass).displayName = 'NPCController', NPCController), superclass).prototype, constructor = NPCController;
    function NPCController(n){
      var i$, i;
      this.update = bind$(this, 'update', prototype);
      this.addNpc = bind$(this, 'addNpc', prototype);
      NPCController.superclass.call(this);
      this.npcs = [];
      this.pad = 100;
      for (i$ = 0; i$ < n; ++i$) {
        i = i$;
        this.addNpc(-400);
      }
      this.maxX = 1080 * 3.5;
      this.minX = -1080 * 2.5;
      this.maxY = 1080 * 3.5;
      this.minY = -1080 * 2.5;
    }
    prototype.addNpc = function(pad){
      var px, py, s, x, y, npc, ref$;
      pad == null && (pad = this.pad);
      px = random(-1080, 1080);
      py = random(-1080, 1080);
      s = Math.random();
      switch (false) {
      case !(s < 0.4):
        x = true;
        y = false;
        break;
      case !(s < 0.8):
        x = false;
        y = true;
        break;
      default:
        x = true;
        y = true;
      }
      if (x) {
        if (px > 0) {
          px += 1080 + this.pad;
        } else {
          px -= 1080 + this.pad;
        }
      }
      if (y) {
        if (py > 0) {
          py += 1080 + this.pad;
        } else {
          py -= 1080 + this.pad;
        }
      }
      px += 1080 / 2;
      py += 720 / 2;
      console.log('Create NPC:', px, py);
      npc = new NPC(randomNpc(), px, py);
      this.addChild(npc);
      return (ref$ = this.npcs)[ref$.length] = npc;
    };
    prototype.update = function(t, v){
      var newNpcs, i$, ref$, len$, npc;
      newNpcs = [];
      console.log(this.npcs.length);
      for (i$ = 0, len$ = (ref$ = this.npcs).length; i$ < len$; ++i$) {
        npc = ref$[i$];
        npc.update(t, v);
        if (npc.position.x < this.minX || npc.position.x > this.maxX || npc.position.y < this.minY || npc.position.y > this.maxY) {
          this.removeChild(npc);
          newNpcs[newNpcs.length] = this.addNpc();
          console.log('Replace NPC!');
        } else {
          newNpcs[newNpcs.length] = npc;
        }
      }
      return this.npcs = newNpcs;
    };
    return NPCController;
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
