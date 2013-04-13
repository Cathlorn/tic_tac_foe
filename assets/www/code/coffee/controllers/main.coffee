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
    @gameWorkArea = document.getElementById('gameWorkArea')
    @testDivision = document.getElementById('testDivision')
    gameDivHeight = Math.floor(@gameWorkArea.offsetHeight * 0.65)
    gameDivWidth = Math.floor(@gameWorkArea.offsetWidth * 0.55)
    $("#testDivision").css("height", gameDivHeight);
    $("#testDivision").css("width", gameDivWidth);
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