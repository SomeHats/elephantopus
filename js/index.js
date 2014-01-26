// Generated by LiveScript 1.2.0
(function(){
  var $, $$, neededInteractions, stage, view, renderer, seaContainer, bg, soundBubbleEvil, soundBubbleFriendly, soundDeath, playSound, elephantopus, elscale, healthIndicator, tentacles, trunk, pointer, blurFilter, backgroundShader, bubbles, clearingVision, visionIndicator, visionIndicatorBar, mouse, keys, npcs, acc, damp, maxSpeed, world, velocity, animate;
  $ = function(s){
    return document.querySelector(s);
  };
  $$ = function(s){
    return document.querySelectorAll(s);
  };
  neededInteractions = 6;
  window.random = function(min, max){
    return min + Math.random() * (max - min);
  };
  stage = new PIXI.Stage(0x333333);
  view = $('#main');
  renderer = new PIXI.WebGLRenderer(1080, 720, view);
  seaContainer = new PIXI.DisplayObjectContainer();
  stage.addChild(seaContainer);
  bg = PIXI.Sprite.fromImage('assets/img/bg-blur.png');
  seaContainer.addChild(bg);
  bg.scale.x = bg.scale.y = 1;
  soundBubbleEvil = $('#bubble-evil');
  soundBubbleFriendly = $('#bubble-friendly');
  soundDeath = $('#death');
  playSound = function(s){
    s.currentTime = 0;
    return s.play();
  };
  window.sounds = {
    bubbleEvil: function(){
      return playSound(soundBubbleEvil);
    },
    bubbleFriendly: function(){
      return playSound(soundBubbleFriendly);
    },
    death: function(){
      return playSound(soundDeath);
    }
  };
  elephantopus = PIXI.Sprite.fromImage('assets/img/elephantopus.png');
  seaContainer.addChild(elephantopus);
  elephantopus.pivot.x = 100;
  elephantopus.pivot.y = 100;
  elephantopus.position.x = 1080 / 2;
  elephantopus.position.y = 720 / 2;
  elscale = 0.8;
  elephantopus.scale.x = elephantopus.scale.y = elscale;
  window.elephantopus = elephantopus;
  elephantopus.health = 100;
  healthIndicator = $('#health-indicator .inner');
  elephantopus.hurt = function(amt){
    if (amt >= elephantopus.health) {
      elephantopus.health = 0;
      elephantopus.kill();
    } else {
      elephantopus.health -= amt;
    }
    return healthIndicator.style.width = elephantopus.health + "%";
  };
  elephantopus.heal = function(amt){
    elephantopus.health += amt;
    if (elephantopus.health > 100) {
      elephantopus.health = 100;
    }
    return healthIndicator.style.width = elephantopus.health + "%";
  };
  elephantopus.killed = false;
  elephantopus.kill = function(){
    sounds.death();
    $('#health-indicator').classList.remove('active');
    elephantopus.killed = true;
    return elephantopus.killedFrames = 0;
  };
  tentacles = new TentacleSet(6, 6, 20);
  tentacles.scale.x = tentacles.scale.y = 0.5;
  tentacles.position.x = 55;
  tentacles.position.y = 100;
  trunk = new Tentacle(4);
  trunk.rotation = -Math.PI / 5;
  trunk.position.x = 57;
  trunk.position.y = 83;
  trunk.scale.x = trunk.scale.y = 1.1;
  elephantopus.addChild(tentacles);
  elephantopus.addChild(trunk);
  pointer = PIXI.Sprite.fromImage('assets/img/pointer.png');
  pointer.pivot = {
    x: 50,
    y: 300
  };
  pointer.position = {
    x: 540,
    y: 360
  };
  stage.addChild(pointer);
  pointer.alpha = 0;
  blurFilter = new BlurVignetteFilter();
  blurFilter.blur = 50;
  blurFilter.outerRadius = 0.3;
  backgroundShader = new BackgroundShader();
  backgroundShader.time = Date.now();
  bg.filters = [backgroundShader];
  seaContainer.filters = [blurFilter];
  bubbles = new BubbleField(0.3);
  seaContainer.addChild(bubbles);
  clearingVision = false;
  visionIndicator = $('#vision-indicator');
  visionIndicatorBar = $('#vision-indicator .inner');
  window.clearVision = function(){
    if (!elephantopus.killed) {
      sounds.bubbleFriendly();
      visionIndicator.classList.add('active');
      bubbles.burst(100);
      return clearingVision = true;
    }
  };
  window.hurt = function(amt){
    if (!elephantopus.killed) {
      sounds.bubbleEvil();
      bubbles.burst(100);
      return elephantopus.hurt(amt);
    }
  };
  window.heal = function(amt){
    if (!elephantopus.killed) {
      sounds.bubbleFriendly();
      bubbles.burst(100);
      return elephantopus.heal(amt);
    }
  };
  mouse = getMouse(view);
  keys = getKeys();
  npcs = new NPCController(30);
  seaContainer.addChild(npcs);
  elephantopus.interactions = 0;
  elephantopus.interact = function(){
    elephantopus.interactions += 1;
    if (neededInteractions <= elephantopus.interactions) {
      return npcs.spawnRhinopus();
    }
  };
  acc = 0.1;
  damp = 0.01;
  maxSpeed = 3.5;
  world = {
    x: 0,
    y: 0
  };
  velocity = {
    x: 0,
    y: 0
  };
  animate = function(time){
    if (elephantopus.killed) {
      keys.left = false;
      keys.right = false;
      keys.up = false;
      keys.down = false;
    }
    if (keys.right) {
      if (velocity.x > maxSpeed) {
        velocity.x = maxSpeed;
      } else {
        velocity.x += acc;
      }
    } else if (keys.left) {
      if (velocity.x < -maxSpeed) {
        velocity.x = -maxSpeed;
      } else {
        velocity.x -= acc;
      }
    } else {
      if (velocity.x > 0) {
        velocity.x -= damp;
        if (velocity.x < 0) {
          velocity.x = 0;
        }
      } else if (velocity.x < 0) {
        velocity.x += damp;
        if (velocity.x > 0) {
          velocity.x = 0;
        }
      }
    }
    if (keys.down) {
      if (velocity.y > maxSpeed) {
        velocity.y = maxSpeed;
      } else {
        velocity.y += acc;
      }
    } else if (keys.up) {
      if (velocity.y < -maxSpeed) {
        velocity.y = -maxSpeed;
      } else {
        velocity.y -= acc;
      }
    } else {
      if (velocity.y > 0) {
        velocity.y -= damp;
        if (velocity.y < 0) {
          velocity.y = 0;
        }
      } else if (velocity.y < 0) {
        velocity.y += damp;
        if (velocity.y > 0) {
          velocity.y = 0;
        }
      }
    }
    world.x += velocity.x;
    world.y += velocity.y;
    elephantopus.scale.x = (function(){
      switch (false) {
      case !(velocity.x < -0.1):
        return -elscale;
      case !(velocity.x > 0.1):
        return elscale;
      default:
        return elephantopus.scale.x;
      }
    }());
    tentacles.update(time);
    trunk.update(time);
    bubbles.update(time, velocity);
    npcs.update(time, velocity);
    backgroundShader.time = time;
    backgroundShader.position = world;
    if (clearingVision) {
      blurFilter.outerRadius += 0.004;
      blurFilter.blur -= 0.3;
      if (blurFilter.outerRadius > 2) {
        clearingVision = false;
      }
    } else {
      if (blurFilter.outerRadius > 0.3) {
        blurFilter.outerRadius -= 0.002;
      }
      if (blurFilter.blur < 50) {
        blurFilter.blur += 0.1;
      }
    }
    if (blurFilter.outerRadius > 0.3) {
      visionIndicatorBar.style.width = 100 * (blurFilter.outerRadius - 0.3) / 1.7 + "%";
    } else {
      visionIndicator.classList.remove('active');
    }
    if (elephantopus.killed && elephantopus.killedFrames < 400) {
      elephantopus.rotation += 0.01;
      elephantopus.position.y += 1;
      elephantopus.alpha -= 0.002;
      if (elephantopus.killedFrames < 200) {
        bubbles.burst(1, 580, elephantopus.position.y);
      }
      elephantopus.killedFrames += 1;
    }
    if (npcs.spawnedRhinopus) {
      pointer.alpha = 1;
      pointer.rotation = Math.atan2(360 - rhinopus.position.y, 540 - rhinopus.position.x) - Math.PI / 2;
    }
    renderer.render(stage);
    return window.requestAnimationFrame(animate);
  };
  window.requestAnimationFrame = window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame;
  window.requestAnimationFrame(animate);
}).call(this);
