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



    
function gotoMain(event)
    audio.play(_CLICK)
    timer.cancel(update_summary_timer)
    composer.hideOverlay(false,"fade")
end

function scene:create( event )
    local sceneGroup = self.view
    local bg = display.newRect(sceneGroup, centerX, centerY, screenWidth, screenHeight)
    bg:setFillColor(144/255, 195/255, 212/255)
    local mainButton = widget.newButton{id = "gotoMain", x = screenLeft + 15, y = 20, onPress = gotoMain, label = "X", labelColor = {default = {0,0,0}, over = {0,0,0,.5}}, font = _FONT, fontSize = 18}
    sceneGroup:insert(mainButton)
    local header = display.newText(sceneGroup, "STATS", centerX, 20, _FONT, 25)
    header:setFillColor(1,0,0,1)
    local bobSection = display.newText(sceneGroup, "BOB", (screenLeft + centerX) / 2, 52, _FONT, 25)
    local societySection = display.newText(sceneGroup, "SOCIETY", (screenRight + centerX) / 2, 52, _FONT, 25)
    local dividingLine = display.newLine(sceneGroup, centerX, 35, centerX, screenBottom)
    dividingLine:setStrokeColor( 0, 0, 0, 1 )
    dividingLine.strokeWidth = 6
    local sectionLine = display.newLine(sceneGroup, screenLeft, bobSection.y + 13, screenRight, bobSection.y + 13)
    sectionLine:setStrokeColor(0,0,0,1)
    sectionLine.strokeWidth = 6
    local headingLine = display.newLine(sceneGroup, screenLeft, 39, screenRight, 39)
    headingLine:setStrokeColor(0,0,0,1)
    headingLine.strokeWidth = 6

    local bobHunger = display.newText(sceneGroup, "HUNGER", screenLeft + 37, bobSection.y + 50, _FONT, 18)
    local bobHunger_val = display.newText(sceneGroup, "", bobHunger.x + 65, bobSection.y + 50, _FONT, 16)
    local bobMoney = display.newText(sceneGroup, "MONEY", screenLeft + 33, bobHunger.y + 50, _FONT, 18)
    local bobMoney_val = display.newText(sceneGroup, "", bobMoney.x + 65, bobHunger.y + 50, _FONT, 16)
    local bobThirst = display.newText(sceneGroup, "THIRST", screenLeft + 33, bobMoney.y + 50, _FONT, 18)
    local bobThirst_val = display.newText(sceneGroup, "", bobThirst.x + 65, bobMoney.y + 50, _FONT, 16)
    local bobIq = display.newText(sceneGroup, "IQ", screenLeft + 13, bobThirst.y + 50, _FONT, 18)
    local bobIq_val = display.newText(sceneGroup, "", bobIq.x + 65, bobThirst.y + 50, _FONT, 16)
    local bobJobSatis = display.newText(sceneGroup, "J-SATIS", screenLeft + 35, bobIq.y + 50, _FONT, 18)
    local bobJobSatis_val = display.newText(sceneGroup, "", bobJobSatis.x + 65, bobIq.y + 50, _FONT, 16)
    local bobJob = display.newText(sceneGroup, "JOB#", screenLeft + 24, bobJobSatis.y + 50, _FONT, 18)
    local bobJob_val = display.newText(sceneGroup, "", bobJobSatis.x + 65, bobJobSatis.y + 50, _FONT, 16)
    
    local socHunger = display.newText(sceneGroup, "HUNGER", dividingLine.x + 42, societySection.y + 50, _FONT, 18)
    local socHunger_val = display.newText(sceneGroup, "", socHunger.x + 65, societySection.y + 50, _FONT, 18)
    local socMoney = display.newText(sceneGroup, "MONEY", dividingLine.x + 37, socHunger.y + 50, _FONT, 18)
    local socMoney_val = display.newText(sceneGroup, "", socMoney.x + 65, socHunger.y + 50, _FONT, 16)
    local socThirst = display.newText(sceneGroup, "THIRST", dividingLine.x + 37, socMoney.y + 50, _FONT, 18)
    local socThirst_val = display.newText(sceneGroup, "", socThirst.x + 65, socMoney.y + 50, _FONT, 16)
    local socIq = display.newText(sceneGroup, "IQ", dividingLine.x + 17, socThirst.y + 50, _FONT, 18)
    local socIq_val = display.newText(sceneGroup, "", socIq.x + 65, socThirst.y + 50, _FONT, 16)
    local socJobStatis = display.newText(sceneGroup, "J-SATIS", dividingLine.x + 41, socIq.y + 50, _FONT, 18)
    local socJobStats_val = display.newText(sceneGroup, "", socJobStatis.x + 65, socIq.y + 50, _FONT, 16)
    local socJob = display.newText(sceneGroup, "JOB#", dividingLine.x + 28, socJobStatis.y + 50, _FONT, 18)
    local socJob_val = display.newText(sceneGroup, "", socJobStatis.x + 65, socJobStatis.y + 50, _FONT, 16)
    

    function Update_Summary_Func(event)
        bobHunger_val.text = BOBPROPS.hunger
        bobMoney_val.text = BOBPROPS.money 
        bobThirst_val.text = BOBPROPS.thirst 
        bobIq_val.text = BOBPROPS.iq 
        bobJobSatis_val.text = SOCIETYPROPS.jobSatis 
        bobJob_val.text = SOCIETYPROPS.job 
        socHunger_val.text = SOCIETYPROPS.hunger
        socMoney_val.text = SOCIETYPROPS.money 
        socThirst_val.text = SOCIETYPROPS.thirst 
        socIq_val.text = SOCIETYPROPS.iq 
        socJobStats_val.text = SOCIETYPROPS.jobSatis 
        socJob_val.text = SOCIETYPROPS.job
        update_summary_timer = timer.performWithDelay(5000,Update_Summary_Func,-1 )
    end
    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        Update_Summary_Func()
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
