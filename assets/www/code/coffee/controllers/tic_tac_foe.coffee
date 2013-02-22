#root = exports ? this
#root.tic_tac_foe = tic_tac_foe

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

if typeof module != "undefined" && module.exports
  #On a server
  exports.tic_tac_foe = tic_tac_foe
else
  #On a client
  window.tic_tac_foe = tic_tac_foe
