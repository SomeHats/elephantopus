window.Tentacle = class Tentacle extends PIXI.DisplayObjectContainer
  (segments = 6) ->
    super!
    parent = @

    @rotation = Math.PI / 2

    @segments = for i til segments
      segment = new PIXI.Sprite.from-image 'assets/img/tentacle.png'

      segment.position.x = 65
      segment.position.y = 15
      segment.scale.y = segment.scale.x = 0.8
      segment.pivot.y = 15
      parent.add-child segment
      parent = segment

    @speed = random 1000 2500
    @initial = random 0 Math.PI
    @speed-scale = random 0.3 0.6
    @wiggle = random 1.3 1.7

  update: (t) ~>
    t = t / @speed
    t += @initial

    for segment in @segments
      segment.rotation = @speed-scale * Math.cos t
      t *= @wiggle

window.TentacleSet = class TentacleSet extends PIXI.DisplayObjectContainer
  (n = 8, segments = 6, offset = 17) ->
    super!

    total-rotate = Math.PI / 2
    rotate-step = total-rotate / n
    rotate = Math.PI / 4

    @tentacles = for i til n
      tentacle = new Tentacle segments
      tentacle.position.x = offset * i
      # tentacle.rotation = rotate
      rotate += rotate-step
      @add-child tentacle
      tentacle

  update: (t) ->
    for tentacle in @tentacles => tentacle.update t
