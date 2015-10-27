local loadsave = require "loadsave"
local widget = require "widget"
local composer = require "composer"
--local sqlite = require "sqlite3"
--local lfs = require "lfs"
_FONT = "Assets\\Righteous-Regular"
_CLICK = audio.loadSound("Assets\\click.wav")
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
local userData = loadsave.loadTable("userData.json")
if userData == nil then
	local userDat = {}
    userDat.moneyThresh = 100000
	userDat.playSounds = true
	userDat.hasProgress = false
	loadsave.saveTable(userDat, "userData.json", system.DocumentsDirectory)
end
local bobProps = loadsave.loadTable("bobProps.json")
if bobProps == nil then
	local bobProp = {}
	bobProp.hunger = 100
	bobProp.money = .10
	bobProp.thirst = 100
	bobProp.iq = 90
    bobProp.jobSatis = 0
	bobProp.job = 0
	loadsave.saveTable(bobProp, "bobProps.json", system.DocumentsDirectory)
end
local societyProps = loadsave.loadTable("societyProps.json")
if societyProps == nil then
    local socProps = {}
    socProps.thirst = 100
    socProps.hunger = 100
    socProps.money = .34
    socProps.jobSatis = 100
    socProps.job = 5
    socProps.iq = 80
    loadsave.saveTable(socProps, "societyProps.json", system.DocumentsDirectory)
end
local _keyboard = audio.loadSound("Assets\\keyboard.wav")
local welcomeIndex = 0
userData = loadsave.loadTable("userData.json")


function slowText(self, text, cancel)
    if(cancel) then
        timer.cancel(currTimer)
    end
    local playsound = 0
    local output = ""
    slowText_index = 0
    local print = function() if(playsound == 2) then audio.play(_keyboard) playsound = 0 else playsound = playsound + 1 end char = text:sub(slowText_index,slowText_index) output = output .. char self.text = output slowText_index = slowText_index + 1 end
    currTimer = timer.performWithDelay(25,print,#text+1)
end

function setup(event)
    if(event.count == 1 and event.source == beginSetup) then
        welcome_message = display.newText("", centerX, centerY, _FONT, 18)
        welcome_message.align = "center"
        welcome_message.print = slowText
        welcome_message:print("Hello my friend.\nThank you for your\ndecision to take\ncare of Bob for us\n\nTap the screen\nto continue")
        welcomeIndex = welcomeIndex + 1
    elseif(event.name == "tap" and welcomeIndex <= 4) then
        if(welcomeIndex == 1) then 
            welcomeIndex = welcomeIndex + 1
            welcome_message:print("We understand that\nit is a huge\nundertaking for someone\nsuch as yourself\n\nTap the screen\nto continue", true)
        elseif(welcomeIndex == 2) then
            welcomeIndex = welcomeIndex + 1
            welcome_message:print("Be sure to take\ncare of him every day\n\nTap the screen\nto continue", true)
        elseif(welcomeIndex == 3) then
            welcomeIndex = welcomeIndex + 1
            welcome_message:print("Bob is a simple guy\nwith simple requests.\nJust do your best\nand the rest will follow\n\nTap the screen\nto continue", true)
        elseif(welcomeIndex == 4) then
            welcomeIndex = welcomeIndex + 1
            welcome_message:print("I wish you the best of luck with him\n\nTap the screen\nto continue", true)
        end
    elseif(welcomeIndex > 4) then
        welcome_message:removeSelf()
        welcome_message = nil
        welcomeIndex = nil
        Runtime:removeEventListener("tap", setup)
        userData.hasProgress = true
        loadsave.saveTable(userData,"userData.json")
        audio.dispose(_keyboard)
        _keyboard = nil
        composer.gotoScene("dbSetup")
    end
end

if userData.hasProgress == false then
    Runtime:addEventListener("tap", setup)
    beginSetup = timer.performWithDelay(100, setup, 1)
else
    audio.dispose(_keyboard)
    _keyboard = nil
    Runtime:removeEventListener("tap", setup)
	composer.gotoScene("dbSetup")
end
