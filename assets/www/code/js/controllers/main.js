// Generated by CoffeeScript 1.4.0
(function() {
  var Main_Controller_VM, Templates, tic_tac_foe,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  Templates = {
    HOME: 'home_page',
    SETTINGS: 'settings_page'
  };

  if (typeof module !== "undefined" && module.exports) {
    tic_tac_foe = require("tic_tac_foe.coffee").tic_tac_foe;
  } else {
    tic_tac_foe = window.tic_tac_foe;
  }

  Main_Controller_VM = (function() {

    function Main_Controller_VM(inits) {
      this.Refresh_JQM = __bind(this.Refresh_JQM, this);

      this.Tap_Settings = __bind(this.Tap_Settings, this);

      this.Tap_Home = __bind(this.Tap_Home, this);

      var gameDivHeight, gameDivWidth, oImageLeft, oImageTop, offset, testDivOffsetX, testDivOffsetY, windowHeight, windowWidth, xImageLeft, xImageTop, xoHeight, xoWidth,
        _this = this;
      this.template_name = ko.observable(Templates.HOME);
      this.display_page = function() {
        return _this.template_name();
      };
      this.game = new tic_tac_foe();
      this.title = ko.observable("Tic Tac Foe");
      this.computeTotalOffset = function(element) {
        var offset, offsetX, offsetY;
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
        offset = {};
        offset.offsetX = offsetX;
        offset.offsetY = offsetY;
        return offset;
      };
      windowWidth = $(window).width();
      windowHeight = $(window).height();
      this.gameWorkArea = document.getElementById('gameWorkArea');
      this.testDivision = document.getElementById('testDivision');
      gameDivHeight = Math.floor(windowHeight * 0.65);
      gameDivWidth = Math.floor(windowWidth * 0.60);
      $("#testDivision").css("height", gameDivHeight);
      $("#testDivision").css("width", gameDivWidth);
      $("#testDivision").css("top", 0.415 * gameDivHeight);
      $("#testDivision").css("left", 0.33 * gameDivWidth);
      xoHeight = Math.floor(windowHeight * 0.10);
      xoWidth = Math.floor(windowWidth * 0.10);
      if (xoWidth > xoHeight) {
        xoHeight = xoWidth;
      } else {
        xoWidth = xoHeight;
      }
      offset = this.computeTotalOffset(this.testDivision);
      testDivOffsetX = offset.offsetX;
      testDivOffsetY = offset.offsetY;
      xImageTop = Math.floor(0.60 * windowHeight);
      xImageLeft = Math.floor(0.05 * windowWidth);
      $("#xImage").css("height", xoHeight);
      $("#xImage").css("width", xoWidth);
      $("#xImage").css("top", xImageTop);
      $("#xImage").css("left", xImageLeft);
      $("#xImageGlow").css("height", xoHeight);
      $("#xImageGlow").css("width", xoWidth);
      $("#xImageGlow").css("top", xImageTop);
      $("#xImageGlow").css("left", xImageLeft);
      oImageTop = Math.floor(0.60 * windowHeight);
      oImageLeft = Math.floor(0.85 * windowWidth);
      $("#oImage").css("height", xoHeight);
      $("#oImage").css("width", xoWidth);
      $("#oImage").css("top", oImageTop);
      $("#oImage").css("left", oImageLeft);
      $("#oImageGlow").css("height", xoHeight);
      $("#oImageGlow").css("width", xoWidth);
      $("#oImageGlow").css("top", oImageTop);
      $("#oImageGlow").css("left", oImageLeft);
      this.playerStatusLabel = document.getElementById('playerStatusLabel');
      $("#playerStatusLabel").css("top", 0);
      $("#playerStatusLabel").css("left", windowWidth / 2 - this.playerStatusLabel.offsetWidth / 2);
      this.game.setupGame(this.testDivision);
    }

    Main_Controller_VM.prototype.Tap_Home = function(d, e) {
      return this.template_name(Templates.HOME);
    };

    Main_Controller_VM.prototype.Tap_Settings = function(d, e) {
      return this.template_name(Templates.SETTINGS);
    };

    Main_Controller_VM.prototype.Refresh_JQM = function(d) {
      var element, _i, _len;
      for (_i = 0, _len = d.length; _i < _len; _i++) {
        element = d[_i];
        console.log(element.id);
        if (element.id === 'testDivision') {
          this.game.setupGame(element);
          this.testDivision = element;
        } else if (element.id === 'dojoPic') {
          this.dojoPic = element;
        }
      }
      $(d).trigger("create");
    };

    return Main_Controller_VM;

  })();

  $(document).one('app_init', function(e, d) {
    var model;
    console.log("Loading Main VM");
    model = new Main_Controller_VM();
    ko.applyBindings(model);
  });

}).call(this);
