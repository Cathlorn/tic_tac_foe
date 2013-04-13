#TicTacFoe
#Corey Sanders
#Ramon Ortiz
#Main script file where game drawing and logic is handled.

if typeof module != "undefined" && module.exports
  #On a server
  PaperRockScissors = require("paper_rock_scissors.coffee").PaperRockScissors
  Media = require("index.html").Media
else
  #On a client
  PaperRockScissors = window.PaperRockScissors
  Media = window.Media
  
#Adding array method to remove elements cleanly from an array
#Courtesy of Stack Overflow
#http://stackoverflow.com/questions/4825812/clean-way-to-remove-element-from-javascript-array-with-jquery-coffeescript
Array::remove = (e) -> @[t..t] = [] if (t = @indexOf(e)) > -1

getElementPositionFromEvent = (element, event) ->
    offsetX = 0
    offsetY = 0

    # Compute the total offset
    if (element.offsetParent != undefined)
        offsetX += element.offsetLeft;
        offsetY += element.offsetTop;
        while ((element = element.offsetParent))
            offsetX += element.offsetLeft;
            offsetY += element.offsetTop; 


    # Add padding and border style widths to offset
    # Also add the <html> offsets in case there's a position:fixed bar
    #offsetX += stylePaddingLeft + styleBorderLeft + htmlLeft
    #offsetY += stylePaddingTop + styleBorderTop + htmlTop

    mx = event.pageX - offsetX
    my = event.pageY - offsetY

    # We return a simple javascript object (a hash) with x and y defined
    return {
        x: mx,
        y: my
    };


#Describes the current run status of the game
GameState =
  GAME_UNSTARTED: 0
  GAME_IN_PROGRESS: 1
  GAME_SUSPENDED: 2
  GAME_TERMINATED: 3

#Describes the outcome of a given game
WinnerStatus =
  UNDETERMINED: 0
  WINNER: 1
  LOSER: 2
      
#Class keeps track of the dimensions of a given cell in the tic tac toe game
class CellDimension
  #Constructor. Creates new instances of the class.
  constructor: (inits)->
    @xstart = 0
    @xend = 0
    @ystart = 0
    @yend = 0
      
#Class reports the result from playing a given instance of a game
class GameResult
  #Constructor. Creates new instances of the class.
  constructor: (inits)->
    #Field reports whether the player associated with this result won or lost.
    @winnerStatus = WinnerStatus.UNDETERMINED
    
    #Field references the player ID of the player tied to the game result.
    @associatedPlayer = 0
    
#Class runs the Tic Tac Foe game within a DOM element.
class tic_tac_foe
  #Constructor. Creates new instances of the class.
  constructor: (inits) ->
    
    #Initializes the canvas for drawing
    @setupCanvas = (element) =>
      console.log "Setting Up Canvas"
      #@canvasElement = document.getElementById('gameCanvas')
      canvasHeight = element.offsetHeight
      canvasWidth = element.offsetWidth
      @canvasElement = E.canvas canvasWidth, canvasHeight
      @canvas = new Canvas @canvasElement
      element.appendChild @canvasElement
    
    #Method prepares a DOM element for displaying Tic Tac Foe within it. 
    #Params: element - DOM element Tic Tac Foe will be placed inside.
    @setupGame = (element) =>
      @setupCanvas element
      @ticTacToe.initialize(element, @canvas)
    
    #Figures out which game is next to play (probably round robin)
    #Each game decides when to terminate or yield. A status of the game is reported each time it exits
    @gameScheduler = new GameScheduler()
    
    #Stores the primary tic tac toe game being played
    #Scheduler will always have at least tic tac toe present to play.
    @ticTacToe = new TicTacToe(@gameScheduler)
    
    @gameScheduler.addGame(@ticTacToe)

#Class handles the operations of the main tic tac toe game.
#It also schedules minigames to be played
class TicTacToe
  #Constructor. Creates new instances of the class.
  constructor: (gameScheduler) ->
    
    #Field stores reference to game scheduler
    @gameScheduler = gameScheduler
    
    #Field stores the division that the game is being played from.
    @gameDivision = null
    
    #Field keeps track of the current player playing.
    @currentPlayer = 1
    
    #Field represents the winner of the current game in progress.
    @gameWinner = 0
    
    #Field represents the state the game is presently running under.
    @currentGameState = GameState.GAME_UNSTARTED
    
    #Field keeps track of the functions registered to be calledback when suspending
    @registeredSuspendCallbacks = new Array()
    
    #Field keeps track of the functions registered to be calledback when terminating
    @registeredTerminationCallbacks = new Array()
    
    #Method registers an callback function for when a game suspends
    @registerSuspendEvents = (callback) =>
      console.log "Register callback for suspend events"
      @registeredSuspendCallbacks.push callback
    
    #Method unregisters an callback function for when a game suspends
    @unregisterSuspendEvents = (callback) =>
      console.log "Unregister callback for suspend events"
      @registeredSuspendCallbacks.remove callback
    
    #Method registers an callback function for when a game terminates
    @registerTerminateEvents = (callback) =>
      console.log "Register callback for terminate events"
      @registeredTerminationCallbacks.push callback
    
    #Method unregisters an callback function for when a game terminates
    @unregisterTerminateEvents = (callback) =>
      console.log "Register callback for terminate events"
      @registeredTerminationCallbacks.remove callback

    #Method reports the outcome of the game
    @getGameResult = () =>
      console.log "Retrieving game result"
      winnerStatus = WinnerStatus.UNDETERMINED
      
      if(@currentGameState == GameState.GAME_TERMINATED)
        winnerStatus = WinnerStatus.WINNER
        
      gameResult = new GameResult()
      gameResult.winnerStatus = winnerStatus
      gameResult.associatedPlayer = @gameWinner
        
      return gameResult
    
    #Method returns the current player that is player
    @getCurrentPlayer = () => 
      return @currentPlayer

    #Method triggers when touchstart events are fired
    #Params - touchevent - Event object describing the touch event that occurred
    @touchEventHandler = (touchevent) =>
      console.log("Touch Event Start Called")
      
      #Checks that the game is still running
      if(@getGameState() == GameState.GAME_IN_PROGRESS)
        touchPosInCanvas=getElementPositionFromEvent(@canvas.canvas, touchevent.targetTouches[0])
        cellId=@determineCellSelected touchPosInCanvas.x, touchPosInCanvas.y
        console.log("CellId: " + cellId)
        if(cellId >= 0)
          playerId = @getCurrentPlayer()
          if(playerId == 1)
            success=@drawX(@canvas, cellId)
          else
            success=@drawO(@canvas, cellId)
        
          if(success)
            winner = @updateWinner(cellId, playerId)
            if(winner > 0)
              @announceWinner(winner)
            else if (winner == 0)
              @resolveTie()
            else if(winner < 0)
              @decideTurn()
              
    #Method playsback an audio file using phonegap.
    #Source modified from:
    #http://docs.phonegap.com/en/1.2.0/phonegap_media_media.md.html#media.play
    @playSound = (filename, successCallback, failCallback) ->
      if(Media != null && Media != undefined)
        #Create Media object from filename
        my_media = new Media(filename, successCallback, failCallback);
        #Play audio
        my_media.play();
      
    #Method triggers when the main music finishes playing
    @mainMusicSuccess = ()=>
      @playSound('sounds/main.aac', @mainMusicSuccess, @mainMusicFail)

    #Method triggers when the main music fails to play
    @mainMusicFail = ()=>
      @playSound('sounds/main.aac', @mainMusicSuccess, @mainMusicFail)

    #Method draws the tic tac toe grid onto the canvas.
    #Params: canvas - Canvas the grid will be drawn on.
    @drawGrid = (canvas) ->
      console.log "Drawing Grid"
      widthIncrement = Math.floor(@CANVAS_WIDTH / 3)
      heightIncrement = Math.floor(@CANVAS_HEIGHT / 3)

      @cellLookup = []
      @claimedCells = []

      yStart = 0
      xStart = 0
      for scale in [1..2]
        rect = new Rectangle @GRID_LINE_THICKNESS, @CANVAS_HEIGHT
        xStart += widthIncrement
        rect.x = xStart
        rect.y = yStart
        rect.fill = true
        rect.fillStyle = 'green' 
        canvas.append rect
      
      xStart = 0
      yStart = 0
      for scale in [1..2]
        yStart += heightIncrement
        rect = new Rectangle @CANVAS_WIDTH, @GRID_LINE_THICKNESS
        rect.x = xStart
        rect.y = yStart
        rect.fill = true
        rect.fillStyle = 'green'
        canvas.append rect

      xStart = 0        
      yStart = 0
      for i in [1..9]
          xStart = (widthIncrement) * ((i-1) % 3)
          yStart = (heightIncrement * (Math.floor (i-1)/3))
          lookup = new CellDimension()
          lookup.xstart = xStart + @GRID_LINE_THICKNESS
          lookup.xend = xStart + widthIncrement
          lookup.ystart = yStart + @GRID_LINE_THICKNESS
          lookup.yend = yStart + heightIncrement
          @cellLookup.push lookup
          @claimedCells.push 0

    #Method prepares the game for launch.
    @initialize = (element, canvasArg) =>
      @gameDivision = element
      @canvas = canvasArg
      @CANVAS_HEIGHT = canvasArg.canvas.clientHeight
      @CANVAS_WIDTH = canvasArg.canvas.clientWidth
      @GRID_LINE_THICKNESS=Math.floor(@CANVAS_HEIGHT/50)
      temp = Math.floor(@CANVAS_WIDTH/50)
      if(temp < @GRID_LINE_THICKNESS)
        @GRID_LINE_THICKNESS=temp
      @drawGrid(@canvas)
      @canvasElement = @canvas.canvas
      @canvasElement.addEventListener('touchstart', @touchEventHandler, false);
      @currentGameState = GameState.GAME_IN_PROGRESS
      @gameWinner = 0
      @playSound('sounds/main.aac', @mainMusicSuccess, @mainMusicFail)
      @playerStatusLabel = document.getElementById('playerStatusLabel')
      $('#playerStatusLabel').text('Current Player: Player 1');
      
    #Method draws X onto the tic tac toe grid at cellId location.
    #Params: canvas - Canvas the X will be drawn on.
    #cellId - Id indicates which cell of the grid the X should be drawn. 
    @drawX = (canvas, cellId) =>
      console.log "Drawing X"
      player = @claimedCells[cellId]
      success = false
      if(player <= 0)
        widthIncrement = @CANVAS_WIDTH/3
        heightIncrement = @CANVAS_HEIGHT/3
        widthOffset = Math.floor(2*@GRID_LINE_THICKNESS)
        heightOffset = Math.floor(2*@GRID_LINE_THICKNESS)
        xPos = cellId % 3
        yPos = Math.floor (cellId / 3)
        xStart = (xPos*widthIncrement) + widthOffset
        yStart = (yPos*heightIncrement) + heightOffset
      
        if(yPos > 0)
          yStart += @GRID_LINE_THICKNESS
      
        xLegLength = heightIncrement
        rect = new Rectangle @GRID_LINE_THICKNESS, xLegLength
        rect.x = xStart
        rect.y = yStart
        rect.fill = true
        rect.fillStyle = 'green'
        rect.rotation =  -(Math.PI / 4)
        canvas.append rect
        #Starting position of next grid (top, left corner) minus the width offset and thickness of the line
        rect = new Rectangle @GRID_LINE_THICKNESS, xLegLength
        rect.x = xStart + (xLegLength / Math.sqrt(2))
        rect.y = yStart - (@GRID_LINE_THICKNESS/ Math.sqrt(2))
        rect.fill = true
        rect.fillStyle = 'green'
        rect.rotation =  (Math.PI / 4)
        canvas.append rect
        @claimedCells[cellId] = @getCurrentPlayer()
        success = true
      else
        alert "Cannot pick square"
        
      return success
      
    #Method draws O onto the tic tac toe grid at cellId location.
    #Params: canvas - Canvas the O will be drawn on.
    #cellId - Id indicates which cell of the grid the O should be drawn.
    @drawO = (canvas, cellId) =>
      console.log "Drawing O"
      player = @claimedCells[cellId]
      
      success = false
      if(player <= 0)
        widthIncrement = @CANVAS_WIDTH/3
        heightIncrement = @CANVAS_HEIGHT/3
        widthOffset = widthIncrement/2 + Math.floor(@GRID_LINE_THICKNESS/2)
        circleRadius = (heightIncrement - (2*@GRID_LINE_THICKNESS))/2
        heightOffset = heightIncrement/2 + Math.floor(@GRID_LINE_THICKNESS/2)
        xPos = cellId % 3
        yPos = Math.floor (cellId / 3)

        if(yPos > 0)
          yStart += @GRID_LINE_THICKNESS
      
        xStart = (xPos*widthIncrement) + widthOffset
        yStart = (yPos*heightIncrement) + heightOffset
        circle = new Circle circleRadius
        circle.x = xStart
        circle.y = yStart
        circle.strokeWidth = (@GRID_LINE_THICKNESS/2)
        circle.stroke = 'black'
        circle.strokeOpacity = 1
        #circle.fill = true
        canvas.append circle
        @claimedCells[cellId] = @getCurrentPlayer()
        success = true
      else
        alert "Cannot pick square"
        
      return success
      
    #Method draws an animation sequence onto the canvas.
    #Params: canvas - Canvas the animation will be drawn on.
    #animationType - Identifier used to select which animation sequence is drawn. 
    @drawAnimation = (canvas, animationType) ->
      console.log "Drawing Animation"
    
    #Method determines which cell has bee selected from a touch event.
    #Returns -1, if no Cell was selected. Otherwise, the cell id is returned.
    #The cell id is the unique identifier for each cell in the tic tac toe grid going from 0 to 8 assigned
    #from the top, left cell, then incrementing right, then downward.
    #Param - x - horizontal offset within the canvas of a touch event
    #Param - y- vertical offset within the canvas of a touch event
    @determineCellSelected = (x,y) =>
      console.log "Determining Cell Selected"
      for cellId in [0..(@cellLookup.length - 1)]
        lookup = @cellLookup[cellId]
        if((x >= lookup.xstart)&&(x <= lookup.xend)&&(y >= lookup.ystart)&&(y <= lookup.yend))
          return cellId
      return -1      
   
    #Method decides which player gets to play at the next turn.
    #Returns the playerId associated with the player that will be playing next turn.
    @decideTurn = () ->
      console.log "Determining Next Player Turn"
      
      if(@currentPlayer == 1)
        @currentPlayer = 2
        $('#playerStatusLabel').text('Current Player: Player 2');
        $("#xImageGlow").css("display", "none");
        $("#oImage").css("display", "none");
        $("#xImage").css("display", "block");
        $("#oImageGlow").css("display", "block");
      else
        @currentPlayer = 1
        $('#playerStatusLabel').text('Current Player: Player 1');
        $("#oImageGlow").css("display", "none");
        $("#xImage").css("display", "none");
        $("#oImage").css("display", "block");
        $("#xImageGlow").css("display", "block");
        
      return @currentPlayer
      
    #Method determines if there is a winner at the specified column
    @checkColumn = (col) =>
      console.log "Checking Column"

      player = @claimedCells[col]
      match = (player > 0)
      if(player != @claimedCells[col + 3])
        match = false
        
      if(player != @claimedCells[col + 6])
        match = false
        
      return match

    #Method determines if there is a winner at the specified row
    @checkRow = (row) =>
      console.log "Checking Rows"
      
      player = @claimedCells[row*3]
      match = (player > 0)
      if(player != @claimedCells[row*3 + 1])
        match = false
        
      if(player != @claimedCells[row*3 + 2])
        match = false
        
      return match
      
    #Method determines if there is a winner along the two diagonal
    #possibilities.
    @checkDiagonals = () =>
      console.log "Checking Diagonals"

      player = @claimedCells[0]
      Diag1Match = (player > 0)
      if(player != @claimedCells[4])
        Diag1Match = false
        
      if(player != @claimedCells[8])
        Diag1Match = false
        
      player = @claimedCells[2]
      Diag2Match = (player > 0)
      if(player != @claimedCells[4])
        Diag2Match = false
        
      if(player != @claimedCells[6])
        Diag2Match = false
        
      return Diag1Match || Diag2Match
 
    #Method determines all cells of the board
    #are already occupied.
    @allCellsOccupied = () =>
      console.log "Checking if all cells are occupied"
       
      exhausted = true
      for cellId in [0..8]
          if(@claimedCells[cellId] == 0)
            exhausted = false

      return exhausted

    #Method checks to see if a winner has been reached with the last claimed cell
    #Returns -1 if no winner is found. 0 if a tie. 1 if a winner was found.
    @updateWinner = (cellId, playerId) =>
      console.log "Updaing Winner Status"
      
      if(@gameWinner == 0)
        winnerFound = -1
      
        matchFound = @checkColumn(cellId%3) || @checkDiagonals() || @checkRow(Math.floor cellId/3)
        if(matchFound)
          winnerFound = 1
          @gameWinner = playerId
          @terminate()
        else if(@allCellsOccupied())
          winnerFound = 0
      
      return winnerFound

    #Method sends of notification that a winner of the game has been found.
    #Params: playerId - Unique identifier for players used to report which player won. 
    @announceWinner = (playerId) ->
      console.log "Announcing Winner"
      alert "Player " + playerId + " wins!"
      
    #Method is responsible for breaking ties in the game 
    @resolveTie = () ->
      console.log "Resolving Tie"
      #Resolves a Tie
      alert "Tie reached!"
      @addMiniGameToScheduler()
      @suspend()

    #Method chooses the mini-game that will play this game yields. 
    @addMiniGameToScheduler = () ->
      console.log "Adding Mini-Game"
      paperRockScissors = new PaperRockScissors(@gameScheduler, @gameDivision)
      @gameScheduler.addGame(paperRockScissors)
      
    #Method reports the current state of the game
    @getGameState = () ->
      console.log "Retrieving game state"
      return @currentGameState
      
    #Method gets a game to resume playing from where it was when it was suspended.
    #Params: previousGameState - returns the game state of the game that finished
    #        before this game was resumed.
    #        previousPlayerId - returns the Id of the last player to place the
    #        previous game launched.
    #Remarks: Method can use the outcome of the previously launched game to
    #         influence how the game resumes.
    @resume = (prevGameResult, previousPlayerId) =>
      if(@currentGameState != GameState.GAME_TERMINATED)
        console.log "Resuming game"
        
        #Mini Games must determine a winner if grid is full
        if(@allCellsOccupied())
          if(prevGameResult.winnerStatus == WinnerStatus.WINNER)
            winnerFound = prevGameResult.associatedPlayer
            @gameWinner = prevGameResult.associatedPlayer
            @canvasElement.style.display = @prevCanvasVisibility
            @terminate()
            @announceWinner(prevGameResult.associatedPlayer)
          else if(prevGameResult.winnerStatus == WinnerStatus.LOSER)
            #Another player needs to be chosen since current one lost.
            @decideTurn()

            #force another mini game to find winner
            @addMiniGameToScheduler()
            @suspend()
          else
            #force another mini game to find winner. Keep current player since result was undetermined
            @addMiniGameToScheduler()
            @suspend()
        else
        #Mini Games determine next moves of players in Tic Tac Toe Game
          if(prevGameResult.winnerStatus == WinnerStatus.WINNER)
            console.log "TODO: Add support for player to claim requested cell when winning mini-game."
          else if(prevGameResult.winnerStatus == WinnerStatus.LOSER)
            #Another player needs to be chosen since current one lost.
            @decideTurn()
          @canvasElement.style.display = @prevCanvasVisibility
          @currentGameState = GameState.GAME_IN_PROGRESS        
      else
        console.log "Error: Resuming a terminated game."

    #Method suspends game and prepares for another game to launch
    @suspend = () =>
      if(@currentGameState != GameState.GAME_TERMINATED)
        console.log "Suspending game"
        @prevCanvasVisibility = @canvasElement.style.display
        @canvasElement.style.display = 'none'
        @currentGameState = GameState.GAME_SUSPENDED
        for idx in [0..(@registeredSuspendCallbacks.length - 1)]
          callback = @registeredSuspendCallbacks[idx]
          callback(@)
      else
        console.log "Error: Suspending a terminated game."
        
    #Method terminates game
    @terminate = () =>
      console.log "Terminating game"
      @currentGameState = GameState.GAME_TERMINATED
      for idx in [0..(@registeredTerminationCallbacks.length - 1)]
        callback = @registeredTerminationCallbacks[idx]
        callback(@)
      
#Class controls which game is playing within TicTacFoe
class GameScheduler
  constructor: (inits) ->
    #Field stores the game stack
    @gameStack = new Array() 
    
    #Field references current game running in scheduler
    @currentRunningGame = null
    
    #Method adds a game for scheduling
    #Params: game - Reference to game that is being added to run
    @addGame = (game) =>
      console.log "Adding Game"
      game.registerSuspendEvents(@suspendEventHandler)
      game.registerTerminateEvents(@terminateEventHandler)
      @gameStack.push game
    
    #Method triggers when a running game suspends control
    #Params: game - Reference to game that suspended
    @suspendEventHandler = (game) =>
      console.log "Handling suspend event"
      @determineNextRunningGame()
      
    #Method triggers when a running game terminates
    #Params: game - Reference to game that terminated
    @terminateEventHandler = (game) =>
      console.log "Handling terminate event"
      #Remove the current game from the stack
      @gameStack.pop()
      @determineNextRunningGame()
      
    #Method determines the next running game
    @determineNextRunningGame = () =>
      console.log "Determining the next running game"
      
      if(@gameStack.length > 0)
        previousRunningGame = @currentRunningGame
        #Peek to see what is currently at top of stack
        @currentRunningGame = @gameStack[(@gameStack.length - 1)]
        if(previousRunningGame == null)
          @currentRunningGame.resume(@currentRunningGame.getGameResult(), @currentRunningGame.getCurrentPlayer())
        else
          @currentRunningGame.resume(previousRunningGame.getGameResult(), previousRunningGame.getCurrentPlayer())

if typeof module != "undefined" && module.exports
  #On a server
  exports.tic_tac_foe = tic_tac_foe
else
  #On a client
  window.tic_tac_foe = tic_tac_foe
