
-- hide the status bar
display.setStatusBar( display.HiddenStatusBar )

-- include the Corona "composer" module
local composer = require "composer"

-- load title screen
composer.gotoScene( "src.pages.home", "fade" )