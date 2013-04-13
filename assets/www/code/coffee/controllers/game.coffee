#Class handles functionality common to all games and mini-games
class Game
  #Constructor. Creates new instances of the class.
  #Params: gameScheduler - reference to the game scheduler a game instance is assigned to.
  constructor: (gameScheduler) ->
    #Reference to the game scheduler game belongs to
    #Reference available for games to add other games into 
    @gameSchedulerReference = gameScheduler
    
    #Method reports the current state of the game
    @getGameState = () ->
      console.log "Retrieving game state"
      
    #Method reports the outcome of the game
    @getGameResult = () ->
      console.log "Retrieving game result"
      
    #Method reports the current player playing the game
    @getCurrentPlayer = () =>
      console.log "Retrieving current player"
      
    #Method gets a game to resume playing from where it was when it was suspended.
    #Params: previousGameState - returns the game state of the game that finished
    #        before this game was resumed.
    #        previousPlayerId - returns the Id of the last player to place the
    #        previous game launched.
    #Remarks: Method can use the outcome of the previously launched game to
    #         influence how the game resumes.
    @resume = (previousWinnerState, previousPlayerId) ->
      console.log "Resuming game"
      
    #Method prepares the game for launch.
    @initialize = (canvasArg, height, width) =>
      console.log "Initializing game"
    
    #Method suspends game and prepares for another game to launch
    @suspend = () ->
      console.log "Suspending game"
    
    #Method prepares a game to stop running
    @terminate = () ->
      console.log "Terminating game"
      
    #Method registers an callback function for when a game suspends
    @registerSuspendEvents = (callback) =>
      console.log "Register callback for suspend events"
    
    #Method unregisters an callback function for when a game suspends
    @unregisterSuspendEvents = (callback) =>
      console.log "Unregister callback for suspend events"
    
    #Method registers an callback function for when a game terminates
    @registerTerminateEvents = (callback) =>
      console.log "Register callback for terminate events"
    
    #Method unregisters an callback function for when a game terminates
    @unregisterTerminateEvents = (callback) =>
      console.log "Register callback for terminate events"
