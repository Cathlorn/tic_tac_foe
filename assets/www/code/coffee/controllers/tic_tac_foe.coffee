class tic_tac_foe
  constructor: (inits) ->
    @drawCanvas = (element) =>
      console.log "Calling Draw Canvas"
      testDiv=element
      c = E.canvas 500, 500
      canvas = new Canvas c
      rect = new Rectangle 100, 100
      rect.x = 250
      rect.y = 250
      rect.fill = true
      rect.fillStyle = 'green'
      rect.addFrameListener (t)->
        this.rotation = ((t / 3000) % 1) * Math.PI * 2
      canvas.append rect
      testDiv.appendChild c
    @setup_screen = (element) =>
      @drawCanvas element
