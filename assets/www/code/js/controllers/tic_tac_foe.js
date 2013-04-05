// Generated by CoffeeScript 1.4.0
(function() {
  var CellDimension, Game, GameScheduler, GameState, TicTacToe, WinnerStatus, getElementPositionFromEvent, tic_tac_foe,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

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
        return _this.ticTacToe.initialize(_this.canvas, tic_tac_foe.CANVAS_HEIGHT, tic_tac_foe.CANVAS_WIDTH);
      };
      this.ticTacToe = new TicTacToe();
      this.gameScheduler = new GameScheduler();
    }

    tic_tac_foe.CANVAS_HEIGHT = 500;

    tic_tac_foe.CANVAS_WIDTH = 500;

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
      this.resume = function(previousGameState, previousPlayerId) {
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

    function TicTacToe(inits) {
      var _this = this;
      this.currentPlayer = 1;
      this.getCurrentPlayer = function() {
        return _this.currentPlayer;
      };
      this.touchEventHandler = function(touchevent) {
        var cellId, playerId, touchPosInCanvas, winner;
        console.log("Touch Event Start Called");
        touchPosInCanvas = getElementPositionFromEvent(_this.canvas.canvas, touchevent.targetTouches[0]);
        cellId = _this.determineCellSelected(touchPosInCanvas.x, touchPosInCanvas.y);
        console.log("CellId: " + cellId);
        playerId = _this.getCurrentPlayer();
        if (playerId === 1) {
          _this.drawX(_this.canvas, cellId);
        } else {
          _this.drawO(_this.canvas, cellId);
        }
        winner = _this.checkForWinner(cellId, playerId);
        if (winner > 0) {
          return _this.announceWinner(winner);
        } else {
          return _this.decideTurn();
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
      this.GRID_LINE_THICKNESS = 20;
      this.initialize = function(canvasArg, height, width) {
        _this.canvas = canvasArg;
        _this.CANVAS_HEIGHT = height;
        _this.CANVAS_WIDTH = width;
        _this.drawGrid(_this.canvas);
        _this.canvasElement = _this.canvas.canvas;
        return _this.canvasElement.addEventListener('touchstart', _this.touchEventHandler, false);
      };
      this.drawX = function(canvas, cellId) {
        var heightIncrement, heightOffset, player, rect, widthIncrement, widthOffset, xLegLength, xPos, xStart, yPos, yStart;
        console.log("Drawing X");
        player = _this.claimedCells[cellId];
        if (player <= 0) {
          widthIncrement = 500 / 3;
          heightIncrement = 500 / 3;
          widthOffset = 30;
          heightOffset = 30;
          xPos = cellId % 3;
          yPos = Math.floor(cellId / 3);
          xStart = (xPos * widthIncrement) + widthOffset;
          yStart = (yPos * heightIncrement) + heightOffset;
          if (yPos > 0) {
            yStart += _this.GRID_LINE_THICKNESS;
          }
          xLegLength = heightIncrement - heightOffset;
          rect = new Rectangle(20, xLegLength);
          rect.x = xStart;
          rect.y = yStart;
          rect.fill = true;
          rect.fillStyle = 'green';
          rect.rotation = -(Math.PI / 4);
          canvas.append(rect);
          rect = new Rectangle(20, xLegLength);
          rect.x = xStart + (xLegLength / Math.sqrt(2));
          rect.y = yStart - (20 / Math.sqrt(2));
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
          widthIncrement = 500 / 3;
          heightIncrement = 500 / 3;
          widthOffset = widthIncrement / 2 + 10;
          circleRadius = (heightIncrement - 40) / 2;
          heightOffset = heightIncrement / 2 + 10;
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
          circle.strokeWidth = 10;
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
      this.decideTurn = function() {
        console.log("Determining Next Player Turn");
        if (this.currentPlayer === 1) {
          this.currentPlayer = 2;
        } else {
          this.currentPlayer = 1;
        }
        return this.currentPlayer;
      };
      this.checkForWinner = function(cellId, playerId) {
        var matchFound, winnerFound;
        console.log("Checking for Winner");
        winnerFound = -1;
        matchFound = _this.checkColumn(cellId % 3) || _this.checkDiagonals() || _this.checkRow(Math.floor(cellId / 3));
        if (matchFound) {
          winnerFound = playerId;
        }
        return winnerFound;
      };
      this.announceWinner = function(playerId) {
        console.log("Announcing Winner");
        return alert("Player " + playerId + " wins!");
      };
      this.addMiniGameToScheduler = function() {
        return console.log("Adding Mini-Game");
      };
    }

    return TicTacToe;

  })(Game);

  GameScheduler = (function() {

    function GameScheduler(inits) {
      this.addGame = function(game) {
        return console.log("Adding Game");
      };
      this.removeGame = function(game) {
        return console.log("Removing Game");
      };
      this.suspendEventHandler = function(game) {
        return console.log("Handling suspend event");
      };
      this.terminateEventHandler = function(game) {
        return console.log("Handling terminate event");
      };
      this.determineNextRunningGame = function() {
        return console.log("Determining the next running game");
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
