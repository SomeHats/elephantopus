window.get-mouse = (el) ->
  mouse = x: 0 y: 0

  el.onmousemove = (e) ->
    mouse.x = e.layer-x
    mouse.y = e.layer-y

  mouse

window.get-keys = ->
  keys = {
    up: false
    down: false
    left: false
    right: false
  }

  document.add-event-listener 'keydown', (e) ->
    switch e.which
    | 37, 65 =>
      keys.left = true
      keys.right = false
    | 38, 87 =>
      keys.up = true
      keys.down = false
    | 39, 68 =>
      keys.right = true
      keys.left = false
    | 40, 83 =>
      keys.down = true
      keys.up = false

  document.add-event-listener 'keyup', (e) ->
    switch e.which
    | 37, 65 => keys.left = false
    | 38, 87 => keys.up = false
    | 39, 68 => keys.right = false
    | 40, 83 => keys.down = false

  keys
