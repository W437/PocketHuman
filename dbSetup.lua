local composer = require "composer"
local scene = composer.newScene()
local sq = require "sqlite3"
-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view
    local path = system.pathForFile("jobs.db", system.DocumentsDirectory)
    local db = sq.open(path)
    local t1setup = [[CREATE TABLE IF NOT EXISTS T1Jobs (name STRING, basepay INTEGER, iq INTEGER, desc STRING, density INTEGER, degree STRING);]]
    local t2setup = [[CREATE TABLE IF NOT EXISTS T2Jobs (name STRING, basepay INTEGER, iq INTEGER, desc STRING, density INTEGER, degree STRING);]]
    local t3setup = [[CREATE TABLE IF NOT EXISTS T3Jobs (name STRING, basepay INTEGER, iq INTEGER, desc STRING, density INTEGER, degree STRING);]]
    local t4setup = [[CREATE TABLE IF NOT EXISTS T4Jobs (name STRING, basepay INTEGER, iq INTEGER, desc STRING, density INTEGER, degree STRING);]]
    local t5setup = [[CREATE TABLE IF NOT EXISTS T5Jobs (name STRING, basepay INTEGER, iq INTEGER, desc STRING, density INTEGER, degree STRING);]]
    db:exec(t1setup)
    db:exec(t2setup)
    db:exec(t3setup)
    db:exec(t4setup)
    db:exec(t5setup)
    local t1Prep = {}
    local t2Prep = {}
    local t3Prep = {}
    local t4Prep = {}
    local t5Prep = {}


    local t1Jobs_Table = 
    {
        {
            name = "panhandler",
            basepay = 3
            iq = 1,
            desc = "Probably the lowest of the low. Being a panhandler isn't something to be proud of.",
            density = .4,
            degree = "None"
        }

        {
            name = "garbageman",
            basepay = 7.5,
            iq = 90,
            desc = "Somewhat good pay for real crappy work. Average job with low standards and requirements",
            degree = "None"
        }
    }

    for i=1,#t1Jobs_Table,1 do
        t1Prep[i] = db:prepare([[INSERT INTO T1Jobs(name,basepay,iq,desc,density,degree) VALUES(:name,:basepay,:iq,:desc,:density,:degree);]])
        t1Prep[i]:bind_names(t1Jobs_Table[i])
        t1Prep[i]:step()
        t1Prep[i]:finalize()
    end
    
    --for i=1,#t2Jobs_Table,1 do
    --    t2Prep[i] = db:prepare([[INSERT INTO T2Jobs(name,basepay,iq,desc,density,degree) VALUES(:name,:basepay,:iq,:desc,:density,:degree);]])
    --    t2Prep[i]:bind_names(t2Jobs_Table[i])
    --    t2Prep[i]:step()
    --    t2Prep[i]:finalize()
   -- end

   -- for i=1,#t3Jobs_Table,1 do
   --     t3Prep[i] = db:prepare([[INSERT INTO T3Jobs(name,basepay,iq,desc,density,degree) VALUES(:name,:basepay,:iq,:desc,:density,:degree);]])
    --    t3Prep[i]:bind_names(t3Jobs_Table[i])
    --    t3Prep[i]:step()
    --    t3Prep[i]:finalize()
   --end

    --for i=1,#t4Jobs_Table,1 do
    --    t4Prep[i] = db:prepare([[INSERT INTO T4Jobs(name,basepay,iq,desc,density,degree) VALUES(:name,:basepay,:iq,:desc,:density,:degree);]])
    --    t4Prep[i]:bind_names(t4Jobs_Table[i])
    --    t4Prep[i]:step()
    --    t4Prep[i]:finalize()
   --end

   -- for i=1,#t5Jobs_Table,1 do
    --    t5Prep[i] = db:prepare([[INSERT INTO T5Jobs(name,basepay,iq,desc,density,degree) VALUES(:name,:basepay,:iq,:desc,:density,:degree);]])
   --     t5Prep[i]:bind_names(t5Jobs_Table[i])
    --    t5Prep[i]:step()
   --     t5Prep[i]:finalize()
   -- end
    
    db:close()
    composer.gotoScene("mainGame")
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
