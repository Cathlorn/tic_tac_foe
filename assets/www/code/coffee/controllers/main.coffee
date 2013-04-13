Templates =
  HOME: 'home_page'
  SETTINGS: 'settings_page'

if typeof module != "undefined" && module.exports
  #On a server
  tic_tac_foe = require("tic_tac_foe.coffee").tic_tac_foe
else
  #On a client
  tic_tac_foe = window.tic_tac_foe

class Main_Controller_VM
  constructor: (inits) ->
    @template_name = ko.observable Templates.HOME
    @display_page = => 
      return @template_name()
    @game = new tic_tac_foe()
    @title = ko.observable "Tic Tac Foe"
    
    #Method computes the total offset position of an element
    @computeTotalOffset = (element)->
      # Compute the total offset
      offsetX = 0
      offsetY = 0
      if (element.offsetParent != undefined)
        offsetX += element.offsetLeft;
        offsetY += element.offsetTop;
        while ((element = element.offsetParent))
          offsetX += element.offsetLeft;
          offsetY += element.offsetTop;
      offset = {}
      offset.offsetX = offsetX
      offset.offsetY = offsetY
      return offset
    
    windowWidth=$(window).width()
    windowHeight=$(window).height()
    @gameWorkArea = document.getElementById('gameWorkArea')
    @testDivision = document.getElementById('testDivision')

    #Size and Place Game Board    
    gameDivHeight = Math.floor(windowHeight * 0.65)
    gameDivWidth = Math.floor(windowWidth * 0.60)
    $("#testDivision").css("height", gameDivHeight);
    $("#testDivision").css("width", gameDivWidth);
    $("#testDivision").css("top", 0.415*gameDivHeight);
    $("#testDivision").css("left", 0.33*gameDivWidth);
    
    #Size and Place X & O pictures
    xoHeight = Math.floor(windowHeight * 0.10)
    xoWidth = Math.floor(windowWidth * 0.10)
    if(xoWidth > xoHeight)
      xoHeight = xoWidth
    else
      xoWidth = xoHeight
    
    offset = @computeTotalOffset(@testDivision)
    testDivOffsetX = offset.offsetX
    testDivOffsetY = offset.offsetY
    xImageTop = Math.floor(0.60*windowHeight)
    xImageLeft = Math.floor(0.05*windowWidth)
    $("#xImage").css("height", xoHeight);
    $("#xImage").css("width", xoWidth);
    $("#xImage").css("top", xImageTop);
    $("#xImage").css("left", xImageLeft);
    $("#xImageGlow").css("height", xoHeight);
    $("#xImageGlow").css("width", xoWidth);
    $("#xImageGlow").css("top", xImageTop);
    $("#xImageGlow").css("left", xImageLeft);

    oImageTop = Math.floor(0.60*windowHeight)
    oImageLeft = Math.floor(0.85*windowWidth)
    $("#oImage").css("height", xoHeight);
    $("#oImage").css("width", xoWidth);
    $("#oImage").css("top", oImageTop);
    $("#oImage").css("left", oImageLeft);
    $("#oImageGlow").css("height", xoHeight);
    $("#oImageGlow").css("width", xoWidth);
    $("#oImageGlow").css("top", oImageTop);
    $("#oImageGlow").css("left", oImageLeft);
     
    #Size and Place Player Label
    @playerStatusLabel = document.getElementById('playerStatusLabel')
    #$("#playerStatusLabel").css("height", xoHeight);
    #$("#playerStatusLabel").css("width", xoWidth);
    $("#playerStatusLabel").css("top", 0);
    $("#playerStatusLabel").css("left", (windowWidth/2 - @playerStatusLabel.offsetWidth/2));
    
    @game.setupGame @testDivision
 
  ##Event Bindings
  Tap_Home: (d, e) =>
    @template_name Templates.HOME
  Tap_Settings: (d, e) =>
    @template_name Templates.SETTINGS
  ##Other Bindings
  Refresh_JQM: (d) =>
    for element in d
      console.log element.id
      if element.id == 'testDivision'
        @game.setupGame element
        @testDivision = element
      else if element.id == 'dojoPic'
        @dojoPic = element
    $(d).trigger("create")
    #v = $(d).find("ul")
    #v.listview 'refresh'
    return
  
$(document).one 'app_init', (e, d) ->
  console.log "Loading Main VM"
  model = new Main_Controller_VM()
  ko.applyBindings model
  return