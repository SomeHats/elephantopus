$ = (s) -> document.query-selector s
$$ = (s) -> document.query-selector-all s

window.random = (min, max) -> min + (Math.random! * (max - min))

needed-interactions = random 15 25

stage = new PIXI.Stage 0x333333
view = $ '#main'
renderer = new PIXI.WebGLRenderer 1080, 720, view

sea-container = new PIXI.DisplayObjectContainer!
stage.add-child sea-container

# BACKGROUND #
bg = PIXI.Sprite.from-image 'assets/img/bg-blur.png'
sea-container.add-child bg
bg.scale.x = bg.scale.y = 1

# SOUNDS #
sound-bubble-evil = $ '#bubble-evil'
sound-bubble-friendly = $ '#bubble-friendly'
sound-death = $ '#death'

play-sound = (s) ->
  s.current-time = 0
  s.play!

window.sounds = {
  bubble-evil: -> play-sound sound-bubble-evil
  bubble-friendly: -> play-sound sound-bubble-friendly
  death: -> play-sound sound-death
}

# ELEPHANTOPUS #
elephantopus = PIXI.Sprite.from-image 'assets/img/elephantopus.png'
sea-container.add-child elephantopus
elephantopus.pivot.x = 100
elephantopus.pivot.y = 100
elephantopus.position.x = 1080 / 2
elephantopus.position.y = 720 / 2
elscale = 0.8
elephantopus.scale.x = elephantopus.scale.y = elscale

window.elephantopus = elephantopus

elephantopus.health = 100
health-indicator = $ '#health-indicator .inner'
elephantopus.hurt = (amt) ->
  if amt >= elephantopus.health
    elephantopus.health = 0
    elephantopus.kill!

  else
    elephantopus.health -= amt

  health-indicator.style.width = "#{elephantopus.health}%"

elephantopus.heal = (amt) ->
  elephantopus.health += amt
  if elephantopus.health > 100 then elephantopus.health = 100

  health-indicator.style.width = "#{elephantopus.health}%"

elephantopus.killed = false
elephantopus.kill = ->
  sounds.death!
  $ '#health-indicator' .class-list.remove 'active'
  elephantopus.killed = true
  elephantopus.killed-frames = 0

# RHINOPUS #
# elephantopus = PIXI.Sprite.from-image 'assets/img/rhinopus.png'
# sea-container.add-child elephantopus
# elephantopus.pivot.x = 100
# elephantopus.pivot.y = 100
# elephantopus.position.x = 1080 / 2
# elephantopus.position.y = 720 / 2
# elscale = 0.8
# elephantopus.scale.x = elephantopus.scale.y = elscale

# TENTACLES/TRUNK #
tentacles = new TentacleSet 6 6 20
tentacles.scale.x = tentacles.scale.y = 0.5
tentacles.position.x = 55
tentacles.position.y = 100
trunk = new Tentacle 4
trunk.rotation = -Math.PI / 5
trunk.position.x = 57
trunk.position.y = 83
trunk.scale.x = trunk.scale.y = 1.1
elephantopus.add-child tentacles
elephantopus.add-child trunk

# POINTER #
pointer = PIXI.Sprite.from-image 'assets/img/pointer.png'
pointer.pivot = x: 50 y: 300
pointer.position = x: 540 y: 360
stage.add-child pointer
pointer.alpha = 0

# FILTERS #
blur-filter = new BlurVignetteFilter!
blur-filter.blur = 50
blur-filter.outer-radius = 0.3

background-shader = new BackgroundShader!
background-shader.time = Date.now!
bg.filters = [background-shader]

sea-container.filters = [blur-filter]

debugging = false

window.add-event-listener 'keypress' (e) ->
  if e.which is 98 and debugging is false
    sea-container.filters = null
    sea-container.position = x: 1080 * 0.45 y: 720 * 0.45
    sea-container.scale = x: 0.15 y: 0.15
    debugging := true

  else if e.which is 98 and debugging is true
    sea-container.filters = [blur-filter]
    sea-container.position = x: 0 y: 0
    sea-container.scale = x: 1 y: 1
    debugging := false

# BUBBLES! #
bubbles = new BubbleField 0.3
sea-container.add-child bubbles

# ACTIONS #
clearing-vision = false
vision-indicator = $ '#vision-indicator'
vision-indicator-bar = $ '#vision-indicator .inner'
window.clear-vision = ->
  unless elephantopus.killed
    sounds.bubble-friendly!
    vision-indicator.class-list.add 'active'
    bubbles.burst 100
    clearing-vision := true

window.hurt = (amt) ->
  unless elephantopus.killed
    sounds.bubble-evil!
    bubbles.burst 100
    elephantopus.hurt amt

window.heal = (amt) ->
  unless elephantopus.killed
    sounds.bubble-friendly!
    bubbles.burst 100
    elephantopus.heal amt

# INPUT #
mouse = get-mouse view
keys = get-keys!

# NPCs! #
npcs = new NPCController 30
sea-container.add-child npcs

elephantopus.interactions = 0
elephantopus.interact = ->
  elephantopus.interactions += 1

  if needed-interactions <= elephantopus.interactions
    npcs.spawn-rhinopus!

# Test:
# test = PIXI.Sprite.from-image 'assets/img/npcs/squid.png'
# test.pivot = x: 320 y: 170
# sea-container.add-child test
# npcs.spawn-rhinopus!

# CONST #
acc = 0.1
damp = 0.01
max-speed = 3.5

world = x: 0 y: 0
velocity = x: 0 y: 0

animate = (time) ->

  if elephantopus.killed
    keys <<< left: false right: false up: false down: false

  if keys.right
    if velocity.x > max-speed
      velocity.x = max-speed
    else
      velocity.x += acc

  else if keys.left
    if velocity.x < -max-speed
      velocity.x = -max-speed
    else
      velocity.x -= acc

  else
    if velocity.x > 0
      velocity.x -= damp
      if velocity.x < 0 then velocity.x = 0
    else if velocity.x < 0
      velocity.x += damp
      if velocity.x > 0 then velocity.x = 0

  if keys.down
    if velocity.y > max-speed
      velocity.y = max-speed
    else
      velocity.y += acc

  else if keys.up
    if velocity.y < -max-speed
      velocity.y = -max-speed
    else
      velocity.y -= acc

  else
    if velocity.y > 0
      velocity.y -= damp
      if velocity.y < 0 then velocity.y = 0
    else if velocity.y < 0
      velocity.y += damp
      if velocity.y > 0 then velocity.y = 0

  world.x += velocity.x
  world.y += velocity.y

  elephantopus.scale.x =
    | velocity.x < -0.1 => - elscale
    | velocity.x > 0.1 => elscale
    | otherwise elephantopus.scale.x

  tentacles.update time
  trunk.update time
  bubbles.update time, velocity
  npcs.update time, velocity

  background-shader.time = time
  background-shader.position = world


  # Clear Vision:
  if clearing-vision
    blur-filter.outer-radius += 0.004
    blur-filter.blur -= 0.3
    if blur-filter.outer-radius > 2 then clearing-vision := false
  else
    if blur-filter.outer-radius > 0.3
      blur-filter.outer-radius -= 0.002

    if blur-filter.blur < 50
      blur-filter.blur += 0.1

  if blur-filter.outer-radius > 0.3
    vision-indicator-bar.style.width = "#{100 * (blur-filter.outer-radius - 0.3) / 1.7}%"
  else vision-indicator.class-list.remove 'active'

  # rhinopus.position <<< mouse

  if elephantopus.killed and elephantopus.killed-frames < 400
    elephantopus.rotation += 0.01
    elephantopus.position.y += 1
    elephantopus.alpha -= 0.002
    if elephantopus.killed-frames < 200 then bubbles.burst 1, 580, elephantopus.position.y
    elephantopus.killed-frames += 1

  if npcs.spawned-rhinopus
    pointer.alpha = 1
    pointer.rotation = (Math.atan2 360 - rhinopus.position.y, 540 - rhinopus.position.x) - Math.PI / 2

  renderer.render stage
  window.request-animation-frame animate

window.request-animation-frame = window.request-animation-frame or
                                 window.moz-request-animation-frame or
                                 window.webkit-request-animation-frame
window.request-animation-frame animate

