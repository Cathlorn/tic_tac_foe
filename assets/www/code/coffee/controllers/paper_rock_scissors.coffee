#TicTacFoe
#Corey Sanders
#Ramon Ortiz
#Paper, Rock, Scissors MiniGame

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

#Class runs the Paper Rock Scissors game 
class PaperRockScissors
  #Constructor. Creates new instances of the class.
  constructor: (inits) ->
    
    #Field stores the division that the game is being played from.
    @gameDivision = null
    
    #Field stores organization of elements before the rock paper scissors came is called.
    @previousGameDivisionState = ""
    
    #Field represents the last item chosen by player 1.
    @player1Choice = ""
    
    #Field represents the last item chosen by player 2.
    @player2Choice = ""

    #Field represents the current player playing.       
    @currentPlayer = 1
    
    #Field represents the winner of the current game in progress.
    @gameWinner = 0
    
    #Field represents the state the game is presently running under.
    @currentGameState = GameState.GAME_UNSTARTED
    
    #Method returns the current player that is player
    @getCurrentPlayer = () => 
      return @currentPlayer

    #Method triggers when buttons are clicked
    @clickEventHandler = () =>
      console.log("Click Event Called")
      
      #Checks that the game is still running
      if(@getGameState() == GameState.GAME_IN_PROGRESS)
        touchPosInCanvas=getElementPositionFromEvent(@canvas.canvas, touchevent.targetTouches[0])
        cellId=@determineCellSelected touchPosInCanvas.x, touchPosInCanvas.y
        console.log("CellId: " + cellId)
        playerId = @getCurrentPlayer()
        if(playerId == 1)
          @drawX(@canvas, cellId)
        else
          @drawO(@canvas, cellId)
        
        winner = @updateWinner(cellId, playerId)
        if(winner > 0)
          @announceWinner(winner)
        else
          @decideTurn()

    #Method prepares the game for launch.
    @initialize = (element) =>
      @gameDivision = element

      #Add Rock
      newButton = document.createElement("input")
      newButton.setAttribute("type", "button")
      newButton.setAttribute("value", "Rock")
      newButton.setAttribute("name", "RockButton")
      newButton.addEventListener('click', @onRock, false)
      element.appendChild(newButton)
      @rockButton = newButton
      
      #Add Paper
      newButton = document.createElement("input")
      newButton.setAttribute("type", "button")
      newButton.setAttribute("value", "Paper")
      newButton.setAttribute("name", "PaperButton")
      newButton.addEventListener('click', @onPaper, false)
      element.appendChild(newButton)
      @paperButton = newButton
      
      #Add Scissors
      newButton = document.createElement("input")
      newButton.setAttribute("type", "button")
      newButton.setAttribute("value", "Scissors")
      newButton.setAttribute("name", "ScissorsButton")
      newButton.addEventListener('click', @onScissors, false)
      element.appendChild(newButton)
      @scissorsButton = newButton
      @currentGameState = GameState.GAME_IN_PROGRESS
      @gameWinner = 0
       
    #Method looks at the current placement of items and determines if there is a winner.
    #Returns -1 if no winner is found. Otherwise, the playerId of the winner is returned.
    @checkForWinner = (cellId, playerId) =>
      console.log "Checking for Winner"
       
      return @gameWinner
      
    #Method decides which player gets to play at the next turn.
    #Returns the playerId associated with the player that will be playing next turn.
    @decideTurn = () ->
      console.log "Determining Next Player Turn"
      
      if(@currentPlayer == 1)
        @currentPlayer = 2
      else
        @currentPlayer = 1
        
      return @currentPlayer

    #Method sends of notification that a winner of the game has been found.
    #Params: playerId - Unique identifier for players used to report which player won. 
    @announceWinner = (playerId) ->
      console.log "Announcing Winner"
      alert "Player " + playerId + " wins!"
      
    #Method reports the outcome of the game
    @getGameResult = () =>
      console.log "Retrieving game result"
      winnerStatus = WinnerStatus.UNDETERMINED
      
      if(@currentGameState == GameState.GAME_TERMINATED)
        winnerStatus = WinnerStatus.WINNER
        
      return winnerStatus
      
    #Method chooses the mini-game that will play this game yields. 
    @addMiniGameToScheduler = () ->
      console.log "Adding Mini-Game"
      
    #Method reports the current state of the game
    @getGameState = () ->
      console.log "Retrieving game state"
      return @currentGameState
      
    #Method updates the game as to which item was selected in this round of the game.
    @updatePlayerChoice = (playerId, choice) =>
      if(playerId == 1)
        @player1Choice = choice
        @decideTurn()
      else
        @player2Choice = choice
        @determineWinner(@player1Choice, @player2Choice)

    #Method determines the winner of a given round of the game.
    @determineWinner = (player1Choice, player2Choice) =>
      if(@gameWinner == 0)
        if(player1Choice == player2Choice)
         alert("Tie. " + player1Choice + " chosen by both. " + "New Round!")
         @decideTurn()
        else if(player1Choice == ROCK)
          if(player2Choice == SCISSORS)
            winStatement = "Rock crushes scissors."
            alert(winStatement + " " + "Player 1 wins!")
            @gameWinner = 1
          else
            winStatement = "Paper covers rock."
            alert(winStatement + " " + "Player 2 wins!")
            @gameWinner = 2
          @currentGameState = GameState.GAME_TERMINATED
        else if(player1Choice == PAPER)
          if(player2Choice == ROCK)
            winStatement = "Paper covers rock."
            alert(winStatement + " " + "Player 1 wins!")
            @gameWinner = 1
          else
            winStatement = "Scissors cut paper."
            alert(winStatement + " " + "Player 2 wins!")
            @gameWinner = 2
          @currentGameState = GameState.GAME_TERMINATED
        else if(player1Choice == SCISSORS)
          if(player2Choice == PAPER)
            winStatement = "Scissors cut paper."
            alert(winStatement + " " + "Player 1 wins!")
            @gameWinner = 1
          else
            winStatement = "Rock crushes scissors."
            alert(winStatement + " " + "Player 2 wins!")
            @gameWinner = 2
          @currentGameState = GameState.GAME_TERMINATED
          
    #Method gets a game to resume playing from where it was when it was suspended.
    #Params: previousGameState - returns the game state of the game that finished
    #        before this game was resumed.
    #        previousPlayerId - returns the Id of the last player to place the
    #        previous game launched.
    #Remarks: Method can use the outcome of the previously launched game to
    #         influence how the game resumes.
    @resume = (previousWinnerState, previousPlayerId) =>
      console.log "Resuming game" 
      @rockButton.style.display = @prevButtonVisibility
      @paperButton.style.display = @prevButtonVisibility
      @scissorsButton.style.display = @prevButtonVisibility
      @currentGameState = GameState.GAME_IN_PROGRESS

    #Method suspends game and prepares for another game to launch
    @suspend = () =>
      console.log "Suspending game"
      @prevButtonVisibility = @rockButton.style.display
      @rockButton.style.display = 'none'
      @paperButton.style.display = 'none'
      @scissorsButton.style.display = 'none'
      @currentGameState = GameState.GAME_SUSPENDED
    
    #Method triggers when rock is selected.
    @onRock = () =>
      @updatePlayerChoice(@getCurrentPlayer(),ROCK);

    #Method triggers when paper is selected.
    @onPaper = () =>
      @updatePlayerChoice(@getCurrentPlayer(),PAPER);

    #Method triggers when scissors is selected.
    @onScissors = () =>
      @updatePlayerChoice(@getCurrentPlayer(),SCISSORS);

#Constants
ROCK="Rock"
PAPER="Paper"
SCISSORS="Scissors"

if typeof module != "undefined" && module.exports
  #On a server
  exports.PaperRockScissors = PaperRockScissors
else
  #On a client
  window.PaperRockScissors = PaperRockScissors
