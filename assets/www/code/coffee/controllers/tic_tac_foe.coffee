#TicTacFoe
#Corey Sanders
#Ramon Ortiz
#Main script file where game drawing and logic is handled.


#Class runs the Tic Tac Foe game within a DOM element.
class tic_tac_foe
  #Constructor. Creates new instances of the class.
  constructor: (inits) ->
    #Initializes the canvas for drawing
    @setupCanvas = (element) =>
      console.log "Setting Up Canvas"
      c = E.canvas 500, 500
      @canvas = new Canvas c
      element.appendChild c
    
    #Method prepares a DOM element for displaying Tic Tac Foe within it. 
    #Params: element - DOM element Tic Tac Foe will be placed inside.
    @setupScreen = (element) =>
      @setupCanvas element
    
    #Method kicks off the game.
    @runGame = () =>
      gameScheduler.run

    #Stores the primary tic tac toe game being played
    #Scheduler will always have at least tic tac toe present to play.
    @ticTacToe = new TicTacToe()

    #Figures out which game is next to play (probably round robin)
    #Each game decides when to terminate or yield. A status of the game is reported each time it exits
    @gameScheduler = new GameScheduler()


#Class handles the operations of the main tic tac toe game.
#It also schedules minigames to be played
class TicTacToe extends Game
  #Constructor. Creates new instances of the class.
  constructor: (inits) ->  
    #Method draws the tic tac toe grid onto the canvas.
    #Params: canvas - Canvas the grid will be drawn on.
    @drawGrid = (canvas) ->
      console.log "Drawing Grid"
      rect = new Rectangle 100, 100
      rect.x = 250
      rect.y = 250
      rect.fill = true
      rect.fillStyle = 'green'
      rect.addFrameListener (t)->
        this.rotation = ((t / 3000) % 1) * Math.PI * 2
      canvas.append rect
      
    #Method draws X onto the tic tac toe grid at cellId location.
    #Params: canvas - Canvas the X will be drawn on.
    #cellId - Id indicates which cell of the grid the X should be drawn. 
    @drawX = (canvas, cellId) ->
      console.log "Drawing X"    
      
    #Method draws O onto the tic tac toe grid at cellId location.
    #Params: canvas - Canvas the O will be drawn on.
    #cellId - Id indicates which cell of the grid the O should be drawn.
    @drawO = (canvas, cellId) ->
      console.log "Drawing O"
      
    #Method draws an animation sequence onto the canvas.
    #Params: canvas - Canvas the animation will be drawn on.
    #animationType - Identifier used to select which animation sequence is drawn. 
    @drawAnimation = (canvas, animationType) ->
      console.log "Drawing Animation"
    
    #Method determines which cell has bee selected from a touch event.
    #Returns -1, if no Cell was selected. Otherwise, the cell id is returned.
    #The cell id is the unique identifier for each cell in the tic tac toe grid going from 0 to 8 assigned
    #from the top, left cell, then incrementing right, then downward.
    @determineCellSelected = () ->
      console.log "Determining Cell Selected"
   
    #Method decides which player gets to play at the next turn.
    #Returns the playerId associated with the player that will be playing next turn.
    @decideTurn = () ->
      console.log "Determining Next Player Turn"

    #Method triggers when new touch events are triggered on the canvas.
    @touchEventHandler = () ->
      console.log "New Touch Event Received"
    
    #Method looks at the current placement of items and determines if there is a winner.
    #Returns -1 if no winner is found. Otherwise, the playerId of the winner is returned.
    @checkForWinner = () ->
      console.log "Checking for Winner"

    #Method sends of notification that a winner of the game has been found.
    #Params: playerId - Unique identifier for players used to report which player won. 
    @announceWinner = (playerId) ->
      console.log "Announcing Winner"
      
    #Method chooses the mini-game that will play this game yields. 
    @addMiniGameToScheduler = () ->
      console.log "Adding Mini-Game"

if typeof module != "undefined" && module.exports
  #On a server
  exports.tic_tac_foe = tic_tac_foe
else
  #On a client
  window.tic_tac_foe = tic_tac_foe
