local loadsave = require "loadsave"
local widget = require "widget"
--local sqlite = require "sqlite3"
--local lfs = require "lfs"
local composer = require( "composer" )
local scene = composer.newScene()
local centerX = display.contentCenterX
local centerY = display.contentCenterY
local screenLeft = display.screenOriginX
local screenWidth = display.contentWidth - screenLeft * 2
local screenRight = screenLeft + screenWidth
local screenTop = display.screenOriginY
local screenHeight = display.contentHeight - screenTop * 2
local screenBottom = screenTop + screenHeight
display.contentWidth = screenWidth
display.contenHetight = screenHeight


function sounds(event)
    if USERDATA.playSounds == false then 
        audio.play(_CLICK)
        USERDATA.playSounds = true 
        event.target.alpha = 1
        audio.setVolume(.8) 
    else 
        USERDATA.playSounds = false 
        event.target.alpha = 0.4 
        audio.setVolume(0) 
    end 
    loadsave.saveTable(USERDATA,"USERDATA.json", system.DocumentsDirectory) 
end

function gotoMain(event)
    audio.play(_CLICK)
    composer.hideOverlay(false,"fade")
end
function scene:create( event )
    local sceneGroup = self.view
    local bg = display.newRect( sceneGroup, centerX, centerY, screenWidth, screenHeight)
    bg:setFillColor(148/255,114/255,61/255)
    local mainButton = widget.newButton{id = "gotoMain", x = screenLeft + 15, y = 20, onPress = gotoMain, label = "X", labelColor = {default = {0,0,0}, over = {0,0,0,.5}}, font = _FONT, fontSize = 18}
    sceneGroup:insert(mainButton)
    local soundsEnabled = display.newText(sceneGroup, "Sounds", centerX, centerY, _FONT, 18)
    if(USERDATA.playSounds == false) then 
        soundsEnabled.alpha = .4
    else
        soundsEnabled.alpha = 1
    end
    soundsEnabled:addEventListener("tap", sounds)
    
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene
