neutral = (npc, t) ->
  unless npc.neutral-coefs?
    npc.neutral-coefs = {
      a: random 700 2000
      b: random 700 2000
      c: random 700 2000
      d: random 700 2000
    }

  coefs = npc.neutral-coefs

  npc.direction = (Math.sin t / coefs.a) * (Math.sin t / coefs.b) * (Math.cos t / coefs.c)
  npc.speed = 0.3 + 2.7 * ( 1 + 0.5 * Math.sin t / coefs.d)

aggressive = (npc, t) ->
  unless npc.aggressive-coefs?
    npc.aggressive-coefs = {
      a: random 700 2000
      b: random 700 2000
      c: random 700 2000
      d: random 700 2000
    }

  coefs = npc.aggressive-coefs
  px = npc.position.x - 540
  py = npc.position.y - 360

  dist = Math.sqrt px * px + py * py

  if (dist < 300) and ((npc.extra.directionless) or (px > 0 and npc.dir is 'left') or (px < 0 and npc.dir is 'right'))
    target-speed = npc.max-speed
    target-direction = Math.atan2 -py, -px
    if npc.dir is 'left' and px > 0
      if py < 0
        target-direction = target-direction - Math.PI
      else
        target-direction = target-direction + Math.PI

  else
    target-direction = (Math.sin t / coefs.a) * (Math.sin t / coefs.b) * (Math.cos t / coefs.c)
    target-speed = 0.3 + 2.7 * ( 1 + 0.5 * Math.sin t / coefs.d)

  npc.speed = npc.speed + (target-speed - npc.speed) / 20
  ddiff = (target-direction - npc.direction) / 20
  if ddiff > 0.1 then ddiff = 0.1
  if ddiff < -0.1 then ddiff = -0.1
  npc.direction += (target-direction - npc.direction) / 20

shy = (npc, t) -> neutral npc, t

window.NPC = class NPC extends PIXI.Sprite
  ({sprite, ai, pivot, max-speed = 3, extra = {}, collide = -> null}, x, y) ->
    texture = PIXI.Texture.from-image "assets/img/#{sprite}.png"

    super texture

    @ai-fn = ai
    @collide-fn = collide

    @position.x = x
    @position.y = y

    @scale.x = @scale.y = 0.3
    @pivot <<< pivot
    @max-speed = max-speed
    @extra = extra

    if Math.random! <= 0.5
      @dir = 'left'
      @scale.x *= -1
    else
      @dir = 'right'

    @direction = 0
    @speed = 2

  update: (time, v) ~>
    @position.x -= v.x
    @position.y -= v.y

    @ai-fn this, time

    @rotation = @direction

    direction = @direction
    if @dir is 'left' then direction = Math.PI + direction
    sd = Math.sin direction
    cd = Math.cos direction

    @position.x += cd * @speed
    @position.y += sd * @speed

    px = @position.x - 540
    py = @position.y - 360

    dist-sq = px * px + py * py
    if dist-sq < 8100 and not @collided
      @collided = true
      @collide-fn!
    else if dist-sq > 8100 and @collided
      @collided = false


random-npc = ->
  npcs = [
    * sprite: 'npcs/cow-fish'
      ai: shy
      pivot: x: 350 y: 300
      collide: -> window.clear-vision!

    * sprite: 'npcs/electro-fish'
      ai: neutral
      pivot: x: 300 y: 200
      collide: -> window.hurt 30

    * sprite: 'npcs/eye-thing'
      ai: neutral
      pivot: x: 230 y: 170
      collide: ->
        window.hurt 10
        window.clear-vision!

    * sprite: 'npcs/flowerhead'
      ai: shy
      pivot: x: 250 y: 250
      collide: -> window.heal 10

    * sprite: 'npcs/googlie-eyes'
      ai: aggressive
      pivot: x: 250 y: 225
      max-speed: 4
      extra: directionless: true
      collide: -> window.hurt 10

    * sprite: 'npcs/heart-fish'
      ai: neutral
      pivot: x: 300 y: 200
      collide: -> window.heal 30

    * sprite: 'npcs/monkey-fish'
      ai: shy
      pivot: x: 270 y: 300
      collide: -> window.heal 11

    * sprite: 'npcs/squid'
      ai: aggressive
      pivot: x: 320 y: 170
      collide: -> window.hurt 15

    * sprite: 'npcs/ufo-fish'
      ai: aggressive
      pivot: x: 500 y: 400
      collide: -> window.hurt 15

  ]

  npcs[Math.floor npcs.length * Math.random!]

window.NPCController = class NPCController extends PIXI.DisplayObjectContainer
  (n) ->
    super!

    @npcs = []
    @pad = 100

    for i til n
      @add-npc -400

    @max-x = 1080 * 3.5
    @min-x = -1080 * 2.5
    @max-y = 1080 * 3.5
    @min-y = -1080 * 2.5

  add-npc: (pad = @pad) ~>
    # 1: Get random coords:
    px = random -1080, 1080
    py = random -1080, 1080

    # 2: Push coords away from center:
    s = Math.random!
    switch
    | s < 0.4 =>
      x = yes
      y = no

    | s < 0.8 =>
      x = no
      y = yes

    | otherwise =>
      x = yes
      y = yes

    if x
      if px > 0
        px += 1080 + @pad
      else
        px -= 1080 + @pad

    if y
      if py > 0
        py += 1080 + @pad
      else
        py -= 1080 + @pad

    # 3: Center the thing:
    px += 1080 / 2
    py += 720 / 2

    console.log 'Create NPC:' px, py

    npc = new NPC random-npc!, px, py
    @add-child npc
    @npcs[*] = npc

  update: (t, v) ~>
    new-npcs = []
    console.log @npcs.length
    for npc in @npcs
      npc.update t, v

      if npc.position.x < @min-x or npc.position.x > @max-x or npc.position.y < @min-y or npc.position.y > @max-y
        @remove-child npc
        new-npcs[*] = @add-npc!
        console.log 'Replace NPC!'
      else
        new-npcs[*] = npc

    @npcs = new-npcs
