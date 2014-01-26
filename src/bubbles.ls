window.Bubble = class Bubble extends PIXI.Sprite
  (place = 'top', x = 0, y = 0) ->
    texture = PIXI.Texture.from-image 'assets/img/bubble.png'

    super texture

    @scale.x = @scale.y = random 0.1 0.4
    @alpha = random 0.2 0.6

    @speed-x = random 200 700
    @speed-y = random 2 5
    @amp-x = random 10 60

    switch place
    | 'top' =>
      @start-x = random 0 1080
      @position.y = 780

    | 'left' =>
      @start-x = -100
      @position.y = random 0 780

    | 'right' =>
      @start-x = 1080 + 100
      @position.y = random 0 780

    | 'custom' =>
      @start-x = x
      @position.y = y


  update: (t, v) ~>
    @position.y -= v.y
    @start-x -= v.x

    @position.y -= @speed-y
    @position.x = @start-x + ( @amp-x * Math.sin t / @speed-x )


    if @position.y < -50
      @dead = true

window.BubbleField = class BubbleField extends PIXI.DisplayObjectContainer
  (freq = 1) ->
    super!
    @freq = freq
    @bubbles = []

    @stage = new PIXI.DisplayObjectContainer!

  update: (t, v) ~>
    new-bubbles = []
    for bubble in @bubbles
      bubble.update t, v
      if bubble.dead
        @remove-child bubble
      else
        new-bubbles[*] = bubble

    if Math.random! <= @freq
      bubble = new Bubble!
      @add-child bubble
      new-bubbles[*] = bubble

      bubble = new Bubble 'left'
      @add-child bubble
      new-bubbles[*] = bubble

      bubble = new Bubble 'right'
      @add-child bubble
      new-bubbles[*] = bubble

    @bubbles = new-bubbles

  burst: (n = 30, x = 540, y = 360) ~>
    for i til n
      bubble = new Bubble 'custom', (random x - 40, x + 40), (random y - 40, y + 40)
      @add-child bubble
      @bubbles[*] = bubble
