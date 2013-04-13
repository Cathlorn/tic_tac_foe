// Generated by CoffeeScript 1.4.0
(function() {
  var CellDimension, Game, GameScheduler, GameState, PaperRockScissors, TicTacToe, WinnerStatus, getElementPositionFromEvent, tic_tac_foe,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  if (typeof module !== "undefined" && module.exports) {
    PaperRockScissors = require("paper_rock_scissors.coffee").PaperRockScissors;
  } else {
    PaperRockScissors = window.PaperRockScissors;
  }

  Array.prototype.remove = function(e) {
    var t, _ref;
    if ((t = this.indexOf(e)) > -1) {
      return ([].splice.apply(this, [t, t - t + 1].concat(_ref = [])), _ref);
    }
  };

  getElementPositionFromEvent = function(element, event) {
    var mx, my, offsetX, offsetY;
    offsetX = 0;
    offsetY = 0;
    if (element.offsetParent !== void 0) {
      offsetX += element.offsetLeft;
      offsetY += element.offsetTop;
      while ((element = element.offsetParent)) {
        offsetX += element.offsetLeft;
        offsetY += element.offsetTop;
      }
    }
    mx = event.pageX - offsetX;
    my = event.pageY - offsetY;
    return {
      x: mx,
      y: my
    };
  };

  tic_tac_foe = (function() {

    function tic_tac_foe(inits) {
      var _this = this;
      this.setupCanvas = function(element) {
        console.log("Setting Up Canvas");
        _this.canvasElement = E.canvas(tic_tac_foe.CANVAS_HEIGHT, tic_tac_foe.CANVAS_WIDTH);
        _this.canvas = new Canvas(_this.canvasElement);
        return element.appendChild(_this.canvasElement);
      };
      this.setupGame = function(element) {
        _this.setupCanvas(element);
        return _this.ticTacToe.initialize(element, _this.canvas, tic_tac_foe.CANVAS_HEIGHT, tic_tac_foe.CANVAS_WIDTH);
      };
      this.gameScheduler = new GameScheduler();
      this.ticTacToe = new TicTacToe(this.gameScheduler);
      this.gameScheduler.addGame(this.ticTacToe);
    }

    tic_tac_foe.CANVAS_HEIGHT = 300;

    tic_tac_foe.CANVAS_WIDTH = 300;

    return tic_tac_foe;

  })();

  GameState = {
    GAME_UNSTARTED: 0,
    GAME_IN_PROGRESS: 1,
    GAME_SUSPENDED: 2,
    GAME_TERMINATED: 3
  };

  WinnerStatus = {
    UNDETERMINED: 0,
    WINNER: 1,
    LOSER: 2
  };

  Game = (function() {

    function Game(gameScheduler) {
      var _this = this;
      this.gameSchedulerReference = gameScheduler;
      this.getGameState = function() {
        return console.log("Retrieving game state");
      };
      this.getGameResult = function() {
        return console.log("Retrieving game result");
      };
      this.getCurrentPlayer = function() {
        return console.log("Retrieving current player");
      };
      this.resume = function(previousWinnerState, previousPlayerId) {
        return console.log("Resuming game");
      };
      this.initialize = function(canvasArg, height, width) {
        return console.log("Initializing game");
      };
      this.suspend = function() {
        return console.log("Suspending game");
      };
      this.terminate = function() {
        return console.log("Terminating game");
      };
      this.registerSuspendEvents = function(callback) {
        return console.log("Register callback for suspend events");
      };
      this.unregisterSuspendEvents = function(callback) {
        return console.log("Unregister callback for suspend events");
      };
      this.registerTerminateEvents = function(callback) {
        return console.log("Register callback for terminate events");
      };
      this.unregisterTerminateEvents = function(callback) {
        return console.log("Register callback for terminate events");
      };
    }

    return Game;

  })();

  CellDimension = (function() {

    function CellDimension(inits) {
      this.xstart = 0;
      this.xend = 0;
      this.ystart = 0;
      this.yend = 0;
    }

    return CellDimension;

  })();

  TicTacToe = (function(_super) {

    __extends(TicTacToe, _super);

    function TicTacToe(gameScheduler) {
      var _this = this;
      this.gameScheduler = gameScheduler;
      this.gameDivision = null;
      this.currentPlayer = 1;
      this.gameWinner = 0;
      this.currentGameState = GameState.GAME_UNSTARTED;
      this.registeredSuspendCallbacks = new Array();
      this.registeredTerminationCallbacks = new Array();
      this.registerSuspendEvents = function(callback) {
        console.log("Register callback for suspend events");
        return _this.registeredSuspendCallbacks.push(callback);
      };
      this.unregisterSuspendEvents = function(callback) {
        console.log("Unregister callback for suspend events");
        return _this.registeredSuspendCallbacks.remove(callback);
      };
      this.registerTerminateEvents = function(callback) {
        console.log("Register callback for terminate events");
        return _this.registeredTerminationCallbacks.push(callback);
      };
      this.unregisterTerminateEvents = function(callback) {
        console.log("Register callback for terminate events");
        return _this.registeredTerminationCallbacks.remove(callback);
      };
      this.getGameResult = function() {
        var winnerStatus;
        console.log("Retrieving game result");
        winnerStatus = WinnerStatus.UNDETERMINED;
        if (_this.currentGameState === GameState.GAME_TERMINATED) {
          winnerStatus = WinnerStatus.WINNER;
        }
        return winnerStatus;
      };
      this.getCurrentPlayer = function() {
        return _this.currentPlayer;
      };
      this.touchEventHandler = function(touchevent) {
        var cellId, playerId, touchPosInCanvas, winner;
        console.log("Touch Event Start Called");
        if (_this.getGameState() === GameState.GAME_IN_PROGRESS) {
          touchPosInCanvas = getElementPositionFromEvent(_this.canvas.canvas, touchevent.targetTouches[0]);
          cellId = _this.determineCellSelected(touchPosInCanvas.x, touchPosInCanvas.y);
          console.log("CellId: " + cellId);
          playerId = _this.getCurrentPlayer();
          if (playerId === 1) {
            _this.drawX(_this.canvas, cellId);
          } else {
            _this.drawO(_this.canvas, cellId);
          }
          winner = _this.updateWinner(cellId, playerId);
          if (winner > 0) {
            return _this.announceWinner(winner);
          } else {
            return _this.decideTurn();
          }
        }
      };
      this.drawGrid = function(canvas) {
        var heightIncrement, i, lookup, rect, scale, widthIncrement, xStart, yStart, _i, _j, _k, _results;
        console.log("Drawing Grid");
        widthIncrement = this.CANVAS_WIDTH / 3;
        heightIncrement = this.CANVAS_HEIGHT / 3;
        this.cellLookup = [];
        this.claimedCells = [];
        yStart = 0;
        xStart = 0;
        for (scale = _i = 1; _i <= 2; scale = ++_i) {
          rect = new Rectangle(this.GRID_LINE_THICKNESS, this.CANVAS_WIDTH);
          xStart += widthIncrement;
          rect.x = xStart;
          rect.y = yStart;
          rect.fill = true;
          rect.fillStyle = 'green';
          canvas.append(rect);
        }
        xStart = 0;
        yStart = 0;
        for (scale = _j = 1; _j <= 2; scale = ++_j) {
          yStart += heightIncrement;
          rect = new Rectangle(this.CANVAS_HEIGHT, this.GRID_LINE_THICKNESS);
          rect.x = xStart;
          rect.y = yStart;
          rect.fill = true;
          rect.fillStyle = 'green';
          canvas.append(rect);
        }
        xStart = 0;
        yStart = 0;
        _results = [];
        for (i = _k = 1; _k <= 9; i = ++_k) {
          xStart = widthIncrement * ((i - 1) % 3);
          yStart = heightIncrement * (Math.floor((i - 1) / 3));
          lookup = new CellDimension();
          lookup.xstart = xStart + this.GRID_LINE_THICKNESS;
          lookup.xend = xStart + widthIncrement;
          lookup.ystart = yStart + this.GRID_LINE_THICKNESS;
          lookup.yend = yStart + heightIncrement;
          this.cellLookup.push(lookup);
          _results.push(this.claimedCells.push(0));
        }
        return _results;
      };
      this.initialize = function(element, canvasArg, height, width) {
        var temp;
        _this.gameDivision = element;
        _this.canvas = canvasArg;
        _this.CANVAS_HEIGHT = height;
        _this.CANVAS_WIDTH = width;
        _this.GRID_LINE_THICKNESS = Math.floor(_this.CANVAS_HEIGHT / 50);
        temp = Math.floor(width / 50);
        if (temp < _this.GRID_LINE_THICKNESS) {
          _this.GRID_LINE_THICKNESS = temp;
        }
        _this.drawGrid(_this.canvas);
        _this.canvasElement = _this.canvas.canvas;
        _this.canvasElement.addEventListener('touchstart', _this.touchEventHandler, false);
        _this.currentGameState = GameState.GAME_IN_PROGRESS;
        return _this.gameWinner = 0;
      };
      this.drawX = function(canvas, cellId) {
        var heightIncrement, heightOffset, player, rect, widthIncrement, widthOffset, xLegLength, xPos, xStart, yPos, yStart;
        console.log("Drawing X");
        player = _this.claimedCells[cellId];
        if (player <= 0) {
          widthIncrement = _this.CANVAS_WIDTH / 3;
          heightIncrement = _this.CANVAS_HEIGHT / 3;
          widthOffset = Math.floor(1.5 * _this.GRID_LINE_THICKNESS);
          heightOffset = Math.floor(1.5 * _this.GRID_LINE_THICKNESS);
          xPos = cellId % 3;
          yPos = Math.floor(cellId / 3);
          xStart = (xPos * widthIncrement) + widthOffset;
          yStart = (yPos * heightIncrement) + heightOffset;
          if (yPos > 0) {
            yStart += _this.GRID_LINE_THICKNESS;
          }
          xLegLength = heightIncrement - heightOffset;
          rect = new Rectangle(_this.GRID_LINE_THICKNESS, xLegLength);
          rect.x = xStart;
          rect.y = yStart;
          rect.fill = true;
          rect.fillStyle = 'green';
          rect.rotation = -(Math.PI / 4);
          canvas.append(rect);
          rect = new Rectangle(_this.GRID_LINE_THICKNESS, xLegLength);
          rect.x = xStart + (xLegLength / Math.sqrt(2));
          rect.y = yStart - (_this.GRID_LINE_THICKNESS / Math.sqrt(2));
          rect.fill = true;
          rect.fillStyle = 'green';
          rect.rotation = Math.PI / 4;
          canvas.append(rect);
          return _this.claimedCells[cellId] = _this.getCurrentPlayer();
        } else {
          return alert("Cannot pick square");
        }
      };
      this.drawO = function(canvas, cellId) {
        var circle, circleRadius, heightIncrement, heightOffset, player, widthIncrement, widthOffset, xPos, xStart, yPos, yStart;
        console.log("Drawing O");
        player = _this.claimedCells[cellId];
        if (player <= 0) {
          widthIncrement = _this.CANVAS_WIDTH / 3;
          heightIncrement = _this.CANVAS_HEIGHT / 3;
          widthOffset = widthIncrement / 2 + Math.floor(_this.GRID_LINE_THICKNESS / 2);
          circleRadius = (heightIncrement - (2 * _this.GRID_LINE_THICKNESS)) / 2;
          heightOffset = heightIncrement / 2 + Math.floor(_this.GRID_LINE_THICKNESS / 2);
          xPos = cellId % 3;
          yPos = Math.floor(cellId / 3);
          if (yPos > 0) {
            yStart += _this.GRID_LINE_THICKNESS;
          }
          xStart = (xPos * widthIncrement) + widthOffset;
          yStart = (yPos * heightIncrement) + heightOffset;
          circle = new Circle(circleRadius);
          circle.x = xStart;
          circle.y = yStart;
          circle.strokeWidth = _this.GRID_LINE_THICKNESS / 2;
          circle.stroke = 'black';
          circle.strokeOpacity = 1;
          canvas.append(circle);
          return _this.claimedCells[cellId] = _this.getCurrentPlayer();
        } else {
          return alert("Cannot pick square");
        }
      };
      this.drawAnimation = function(canvas, animationType) {
        return console.log("Drawing Animation");
      };
      this.determineCellSelected = function(x, y) {
        var cellId, lookup, _i, _ref;
        console.log("Determining Cell Selected");
        for (cellId = _i = 0, _ref = _this.cellLookup.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; cellId = 0 <= _ref ? ++_i : --_i) {
          lookup = _this.cellLookup[cellId];
          if ((x >= lookup.xstart) && (x <= lookup.xend) && (y >= lookup.ystart) && (y <= lookup.yend)) {
            return cellId;
          }
        }
        return -1;
      };
      this.decideTurn = function() {
        console.log("Determining Next Player Turn");
        if (this.currentPlayer === 1) {
          this.currentPlayer = 2;
        } else {
          this.currentPlayer = 1;
        }
        return this.currentPlayer;
      };
      this.checkColumn = function(col) {
        var match, player;
        console.log("Checking Column");
        player = _this.claimedCells[col];
        match = player > 0;
        if (player !== _this.claimedCells[col + 3]) {
          match = false;
        }
        if (player !== _this.claimedCells[col + 6]) {
          match = false;
        }
        return match;
      };
      this.checkRow = function(row) {
        var match, player;
        console.log("Checking Rows");
        player = _this.claimedCells[row * 3];
        match = player > 0;
        if (player !== _this.claimedCells[row * 3 + 1]) {
          match = false;
        }
        if (player !== _this.claimedCells[row * 3 + 2]) {
          match = false;
        }
        return match;
      };
      this.checkDiagonals = function() {
        var Diag1Match, Diag2Match, player;
        console.log("Checking Diagonals");
        player = _this.claimedCells[0];
        Diag1Match = player > 0;
        if (player !== _this.claimedCells[4]) {
          Diag1Match = false;
        }
        if (player !== _this.claimedCells[8]) {
          Diag1Match = false;
        }
        player = _this.claimedCells[2];
        Diag2Match = player > 0;
        if (player !== _this.claimedCells[4]) {
          Diag2Match = false;
        }
        if (player !== _this.claimedCells[6]) {
          Diag2Match = false;
        }
        return Diag1Match || Diag2Match;
      };
      this.allCellsOccupied = function() {
        var cellId, exhausted, _i;
        console.log("Checking if all cells are occupied");
        exhausted = true;
        for (cellId = _i = 0; _i <= 8; cellId = ++_i) {
          if (_this.claimedCells[cellId] === 0) {
            exhausted = false;
          }
        }
        return exhausted;
      };
      this.updateWinner = function(cellId, playerId) {
        var matchFound, winnerFound;
        console.log("Updaing Winner Status");
        if (_this.gameWinner === 0) {
          winnerFound = -1;
          matchFound = _this.checkColumn(cellId % 3) || _this.checkDiagonals() || _this.checkRow(Math.floor(cellId / 3));
          if (matchFound) {
            winnerFound = playerId;
            _this.gameWinner = playerId;
            _this.terminate();
          }
          if (_this.allCellsOccupied()) {
            alert("Tie reached!");
            _this.addMiniGameToScheduler();
            _this.suspend();
          }
        }
        return _this.gameWinner;
      };
      this.checkForWinner = function(cellId, playerId) {
        console.log("Checking for Winner");
        return _this.gameWinner;
      };
      this.announceWinner = function(playerId) {
        console.log("Announcing Winner");
        return alert("Player " + playerId + " wins!");
      };
      this.addMiniGameToScheduler = function() {
        var paperRockScissors;
        console.log("Adding Mini-Game");
        paperRockScissors = new PaperRockScissors(this.gameScheduler, this.gameDivision);
        return this.gameScheduler.addGame(paperRockScissors);
      };
      this.getGameState = function() {
        console.log("Retrieving game state");
        return this.currentGameState;
      };
      this.resume = function(previousWinnerState, previousPlayerId) {
        var winnerFound;
        if (_this.currentGameState !== GameState.GAME_TERMINATED) {
          console.log("Resuming game");
          if (_this.allCellsOccupied()) {
            if (previousWinnerState === WinnerStatus.WINNER) {
              winnerFound = previousPlayerId;
              _this.gameWinner = previousPlayerId;
              _this.canvasElement.style.display = _this.prevCanvasVisibility;
              _this.terminate();
              return _this.announceWinner(previousPlayerId);
            } else if (previousWinnerState === WinnerStatus.LOSER) {
              _this.decideTurn();
              _this.addMiniGameToScheduler();
              return _this.suspend();
            } else {
              _this.addMiniGameToScheduler();
              return _this.suspend();
            }
          } else {
            if (previousWinnerState === WinnerStatus.WINNER) {
              console.log("TODO: Add support for player to claim requested cell when winning mini-game.");
            } else if (previousWinnerState === WinnerStatus.LOSER) {
              _this.decideTurn();
            }
            _this.canvasElement.style.display = _this.prevCanvasVisibility;
            return _this.currentGameState = GameState.GAME_IN_PROGRESS;
          }
        } else {
          return console.log("Error: Resuming a terminated game.");
        }
      };
      this.suspend = function() {
        var callback, idx, _i, _ref, _results;
        if (_this.currentGameState !== GameState.GAME_TERMINATED) {
          console.log("Suspending game");
          _this.prevCanvasVisibility = _this.canvasElement.style.display;
          _this.canvasElement.style.display = 'none';
          _this.currentGameState = GameState.GAME_SUSPENDED;
          _results = [];
          for (idx = _i = 0, _ref = _this.registeredSuspendCallbacks.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; idx = 0 <= _ref ? ++_i : --_i) {
            callback = _this.registeredSuspendCallbacks[idx];
            _results.push(callback(_this));
          }
          return _results;
        } else {
          return console.log("Error: Suspending a terminated game.");
        }
      };
      this.terminate = function() {
        var callback, idx, _i, _ref, _results;
        console.log("Terminating game");
        _this.currentGameState = GameState.GAME_TERMINATED;
        _results = [];
        for (idx = _i = 0, _ref = _this.registeredTerminationCallbacks.length - 1; 0 <= _ref ? _i <= _ref : _i >= _ref; idx = 0 <= _ref ? ++_i : --_i) {
          callback = _this.registeredTerminationCallbacks[idx];
          _results.push(callback(_this));
        }
        return _results;
      };
    }

    return TicTacToe;

  })(Game);

  GameScheduler = (function() {

    function GameScheduler(inits) {
      var _this = this;
      this.gameStack = new Array();
      this.currentRunningGame = null;
      this.addGame = function(game) {
        console.log("Adding Game");
        game.registerSuspendEvents(_this.suspendEventHandler);
        game.registerTerminateEvents(_this.terminateEventHandler);
        return _this.gameStack.push(game);
      };
      this.suspendEventHandler = function(game) {
        console.log("Handling suspend event");
        return _this.determineNextRunningGame();
      };
      this.terminateEventHandler = function(game) {
        console.log("Handling terminate event");
        _this.gameStack.pop();
        return _this.determineNextRunningGame();
      };
      this.determineNextRunningGame = function() {
        var previousRunningGame;
        console.log("Determining the next running game");
        if (_this.gameStack.length > 0) {
          previousRunningGame = _this.currentRunningGame;
          _this.currentRunningGame = _this.gameStack[_this.gameStack.length - 1];
          if (previousRunningGame === null) {
            return _this.currentRunningGame.resume(_this.currentRunningGame.getGameResult(), _this.currentRunningGame.getCurrentPlayer());
          } else {
            return _this.currentRunningGame.resume(previousRunningGame.getGameResult(), previousRunningGame.getCurrentPlayer());
          }
        }
      };
    }

    return GameScheduler;

  })();

  if (typeof module !== "undefined" && module.exports) {
    exports.tic_tac_foe = tic_tac_foe;
  } else {
    window.tic_tac_foe = tic_tac_foe;
  }

}).call(this);
