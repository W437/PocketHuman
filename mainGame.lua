local loadsave = require "loadsave"
local widget = require "widget"
local sqlite = require "sqlite3"
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
--TODO: fix main update function. Decreases in stats should NOT be flat and instead should adjust according to other features
--REMINDERS: money is a percentage of threshold. Determine which percentage means happiness
--local _keyboard = audio.loadSound("Assets\\keyboard.wav")
local path = system.pathForFile("jobs.db", system.DocumentsDirectory)
JOBSDATA = sqlite.open(path)
USERDATA = loadsave.loadTable("USERDATA.json")
BOBPROPS = loadsave.loadTable("BOBPROPS.json")
SOCIETYPROPS = loadsave.loadTable("SOCIETYPROPS.json")
local buttonColor = {default = {209/255,206/255,48/255}, over = {0,0,0,.5}}
local hungerIcons = {}
local satisIcons = {}

function updateJob(tier, jobName, field, newVal)
    local tierLevel = tier or "T1Jobs"
    if(field == nil) then print("No field provided for change") return false end
    local updateQuery = JOBSDATA:prepare([[UPDATE ]] .. tierLevel .. [[ SET ]] .. field .. [[ = :newVal WHERE name = :jobname]])
    updateQuery:bind_values(newVal, jobName)
    updateQuery:step()
    updateQuery:finalize()
end


function getJob(tier, jobName)
    local tierLevel = tier or "T1Jobs"
    local tbl
    for row in JOBSDATA:nrows("SELECT * FROM " .. tierLevel) do
        if(row.name == jobName) then
            tbl = {name = row.name, density = row.density, basepay = row.basepay, iq = row.iq, degree = row.degree, desc = row.desc}
            break
        end
    end
    return tbl
end

function getSatisfactions()
    --change to for-loop
    if not BOBPROPS or not SOCIETYPROPS then return end
    local bob = 0
    local society = 0
    if(BOBPROPS.money < SOCIETYPROPS.money) then
        society = society + 1
    else
        bob = bob + 1
    end

    if(BOBPROPS.iq < SOCIETYPROPS.iq - 10) then
        society = society + 1
    else
        bob = bob + 1
    end

    if(BOBPROPS.thirst < SOCIETYPROPS.thirst - 10) then
        society = society + 1
    else
        bob = bob + 1
    end

    if(BOBPROPS.hunger < SOCIETYPROPS.hunger - 10) then
        society = society + 1
    else
        bob = bob + 1
    end

    if(BOBPROPS.job < SOCIETYPROPS.job) then
        society = society + 1
    else
        bob = bob + 1
    end

    if(BOBPROPS.jobSatis < 50 and SOCIETYPROPS.jobSatis < 50) then
        bob = bob - 1
        society = society - 1
    elseif(BOBPROPS.jobSatis >= 50 and SOCIETYPROPS.jobSatis < 50) then
        bob = bob + 1
        society = society - 1
    elseif(BOBPROPS.jobSatis < 50 and SOCIETYPROPS.jobSatis >= 50) then
        bob = bob - 1
        society = society + 1
    else
        bob = bob + 1
        society = society + 1
    end
    return bob,society
end


function colorTransitions(self, b, g, r, speed)
    local transTimer
    function gotoColor()
        if(self.fill.b == b/255 and self.fill.g == g/255 and self.fill.r == r/255) then timer.cancel( transTimer ) transTimer = nil end
        if(self.fill.b < b/255) then
            self.fill.b = self.fill.b + 1/255
        elseif(self.fill.b > b/255) then
            self.fill.b = self.fill.b - 1/255
        end
        if(self.fill.g < g/255) then
            self.fill.g = self.fill.g + 1/255
        elseif(self.fill.g > g/255) then
            self.fill.g = self.fill.g - 1/255
        end
        if(self.fill.r < r/255) then
            self.fill.r = self.fill.r + 1/255
        elseif(self.fill.r > r/255) then
            self.fill.r = self.fill.r - 1/255
        end
    end
    transTimer = timer.performWithDelay(speed, gotoColor, -1)
end

function slowText(self, text, cancel)
    if(cancel) then
        timer.cancel(currTimer)
    end
    local output = ""
    local slowText_index = 0
    local print = function() char = text:sub(slowText_index,slowText_index) output = output .. char self.text = output slowText_index = slowText_index + 1 end
    currTimer = timer.performWithDelay(25,print,#text+1)
end
-- -------------------------------------------------------------------------------



function scene:create( event )
    local sceneGroup = self.view
    function Update_Main(event)
        BOBPROPS.hunger = BOBPROPS.hunger - .1
        local foodAmt = math.ceil(BOBPROPS.hunger / 25)
        for i=1,#hungerIcons,1 do
            hungerIcons[i].alpha = 0
        end
        for i=1,foodAmt,1 do
            hungerIcons[i].alpha = 1
        end
        local bobS, societyS = getSatisfactions()
        local satisAmt = bobS
        local overage
        if(satisAmt > 4) then
            overage = satisAmt - 4
            satisAmt = 4
        end
        for i=1,#satisIcons,1 do
            satisIcons[i].alpha = 0
        end
        for i=1,satisAmt,1 do
            satisIcons[i].alpha = 1
        end
        if(overage ~= nil) then
            disp_extraHearts.text = "x" .. overage
        end 

    end

    function onSystemEvent(event)
        if(event.type == "applicationExit" or event.type == "applicationSuspend") then
            --call save function
            BOBPROPS = nil
            SOCIETYPROPS = nil
            USERDATA = nil
            if(currTimer) then timer.cancel(currTimer) currTimer = nil end
            if(autoSave) then timer.cancel(autoSave) autoSave = nil end
            if(update_main_timer) then timer.cancel(update_main_timer) update_main_timer = nil end
            composer.removeHidden(false)
        elseif(event.type == "applicationResume") then
            composer.removeScene("mainGame")
            composer.gotoScene("mainGame")
        end
    end

    function Summary(event)
        audio.play(_CLICK)
        composer.showOverlay("summary", {isModal = true, effect = "fromTop"})
    end

    function JobListings(event)
        audio.play(_CLICK)
        composer.showOverlay("jobs", {isModal = true, effect = "fromRight"})
    end

    function Activities(event)

    end

    function Schooling(event)

    end

    function Options(event)
        audio.play(_CLICK)
        composer.showOverlay("options", {isModal = true, effect = "fromRight"})
    end

    function saveGame(event)

    end

    --local hungerIcon = display.newImage(sceneGroup, "Assets\\2dham.png")
    --local heartIcon = display.newImage(sceneGroup, "Assets\\royalHeart.png")
    local backGround = display.newRect(sceneGroup, centerX, centerY, screenWidth, screenHeight)
    backGround:setFillColor(219/255,113/255,0/255)
    backGround.alpha = .3
    backGround.trans = colorTransitions
    local statsButton = widget.newButton{id = "stats", onPress = Summary, label = "STATS", fontSize = screenHeight / 28, labelColor = buttonColor, textOnly = true, font = _FONT}
    sceneGroup:insert(statsButton)
    statsButton.x = screenRight - 33
    statsButton.y = 40
    local jobButton =  widget.newButton{id = "job", onPress = JobListings, label = "JOBS", fontSize = screenHeight / 28, labelColor = buttonColor, textOnly = true, font = _FONT}
    sceneGroup:insert(jobButton)
    jobButton.x = screenRight - 28
    jobButton.y = statsButton.y + 80
    local activityButton = widget.newButton{id = "activity", onPress = Activities, label = "ACTIVITIES", fontSize = screenHeight / 28, labelColor = buttonColor, textOnly = true, font = _FONT}
    sceneGroup:insert(activityButton)
    activityButton.x = screenRight - 54
    activityButton.y = jobButton.y + 80
    local schoolButton = widget.newButton{id = "school", onPress = Schooling, label = "SCHOOL", fontSize = screenHeight / 28, labelColor = buttonColor, textOnly = true, font = _FONT}
    sceneGroup:insert(schoolButton)
    schoolButton.x = screenRight - 42
    schoolButton.y = activityButton.y + 80
    local optionsButton = widget.newButton{id = "options", onPress = Options, label = "OPTIONS", fontSize = screenHeight / 28, labelColor = buttonColor, textOnly = true, font = _FONT}
    sceneGroup:insert(optionsButton)
    optionsButton.x = screenRight - 45
    optionsButton.y = schoolButton.y + 80
    local saveButton = widget.newButton{id = "save", onPress = saveGame, label = "SAVE", fontSize = screenHeight / 28, labelColor = {default = {222/255,64/255,11/255}, over = {0,0,0,.5}}, textOnly = true, font = _FONT}
    sceneGroup:insert(saveButton)
    saveButton.x = screenRight - 27
    saveButton.y = optionsButton.y + 80
    local disp_extraHearts = display.newText(sceneGroup, " ", screenLeft + 160, 30, _FONT, 18)
    sceneGroup:insert(disp_extraHearts)
    Runtime:addEventListener("system", onSystemEvent)
end


-- "scene:show()"
function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        if(USERDATA.playSounds == false) then 
            audio.setVolume(0)
        else
            audio.setVolume(.8)
        end
        local extra_heart
        local _heartAmt = getSatisfactions()
        if(_heartAmt > 4) then
            extra_heart = _heartAmt - 4
            _heartAmt = 4
        end
        local _hungerAmt = math.floor(BOBPROPS.hunger / 25)
        for i = 1,_heartAmt,1 do
            satisIcons[i] = display.newImage(sceneGroup, "Assets\\royalHeart.png")
            satisIcons[i].x = screenLeft + (i * 30 + 2)
            satisIcons[i].y = 30
            satisIcons[i]:scale(1.2,1.2)
        end
        if(extra_heart ~= nil) then
            disp_extraHearts.text = "x"..extra_heart
        end
        for i = 1,_hungerAmt,1 do
            hungerIcons[i] = display.newImage(sceneGroup, "Assets\\2dham.png")
            hungerIcons[i].x = screenLeft + (i * 30)
            hungerIcons[i].y = 80
            hungerIcons[i]:scale(.6,.6)
            hungerIcons[i]:rotate(90)
        end

    elseif ( phase == "did" ) then
        update_main_timer = timer.performWithDelay(1000, Update_Main, -1)
        autoSave = timer.performWithDelay(30000, saveGame, -1)
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

