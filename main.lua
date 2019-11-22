require 'actions'
require 'events'
require 'logic'
require 'variables'
require 'entities'
require 'art'
require 'utility'
require 'fileutility'	
require 'scenes'	
require 'strong'
anim8 = require 'anim8'
nk = require 'nuklear'
flux = require 'flux'
require 'ui'
require 'chats'
require 'buttons'
xml2lua = require ('xml2lua')


function love.load()

  if arg and arg[#arg] == "-debug" then require("mobdebug").start() end
	initScenes()

--	scriptData = http.get("http://pastebin.com/raw/hM9P7UhF")
	require("love.screen") -- load the love.module
	love.screen.init() -- Mandatory : it create the main screen.
    screen = love.screen.getScreen()
	OpenLogFile()   
	OpenScriptFile()   
--	loadScriptURL()
	initLove2D()
	initDraw()
	initChat()
--	initChats()
	testChatNodes()
----	 initLogic()
----	initEvents()
	initUIObject()	
--	 initVariables()
	initEntities()
	logFile:flush()	
	nk.init()
	loadScript()
	initActions()
	setupChat()
  tempfile = io.open("genericItems_spritesheet_colored.xml", "r")
  xmldata = ""
 	repeat
		line = tempfile:read()
		if line ~= nil then xmldata = xmldata .. line .. "\n" end
	until line == nil
img = love.graphics.newImage("genericItems_spritesheet_colored.png")
--	local xml = require("slaxml").newParser()
	
--	xml:loadFile('genericItems_spritesheet_colored.xml', base)	
--	print(xml.test["@name"])
  loadScene("firstscene")
end


function loadScript ()

	local variablesSection = ""
	local entitiesSection = ""
	local buttonsSection = ""
	local eventsSection = ""
	local chatNodeSection = ""
	local sceneSection = ""
	local artNodeSection = ""
	
	for line in scriptData:lines() do
		
		line = line:strip()	
		if line == "VARIABLES SECTION." then
			section = "variables"
		end
		if line== "ENTITIES SECTION." then
			section = "entities"
		end
		if line == "PLAYER ACTION BUTTONS SECTION." then
			section = "buttons"
		end
		if line == "EVENTS SECTION." then
			section = "events"
		end		
		if line == "CHAT SECTION." then
			section = "chat"
		end		
		if line == "ART SECTION." then
			section = "art"
		end					
    if line == "SCENE SECTION." then
			section = "scenes"
		end					
    
    if line == "END VARIABLES." or
			line == "END ENTITIES." or 
			line == "END PLAYER ACTION BUTTONS." or
			line == "END CHAT." or
      line == "END ART." or
			line == "END EVENTS." or
			line == "END SCENES." then
			section = ""
		end
		if section == "events" then
			eventsSection = eventsSection .. line .. "\n"
		end
		if section == "buttons" then
			buttonsSection = buttonsSection.. line .. "\n"
		end
		if section == "entities" then
			entitiesSection = entitiesSection .. line .. "\n"
		end
		if section == "variables" then
			variablesSection = variablesSection .. line .. "\n"
		end
		if section == "chat" then
			chatNodeSection = chatNodeSection .. line .. "\n"
		end
		if section == "art" then
			artNodeSection = artNodeSection .. line .. "\n"
		end		
    if section == "scenes" then
			sceneSection = sceneSection .. line .. "\n"
		end		
	end
	loadArt(artNodeSection.. "END ART.")
	loadVariables(variablesSection .. "END VARIABLES.") 
	loadEvents(eventsSection .. "END EVENTS.")
	loadEntities(entitiesSection .. "END ENTITIES.")
	loadButtons(buttonsSection .. "END BUTTONS.")
	loadChatNodes(chatNodeSection.. "END CHAT.")
	loadScenes(sceneSection.. "END SCENES.")

end



function love.keypressed(key,scancode, isrepeat)
	absord = nk.keypressed(key, scancode, isrepeat)
	if absord ~= true then
		UI.keypressed = key
        -- Pass event to the game
    end
end


function love.keyreleased(key,scancode, isrepeat)
 nk.keyreleased(key, scancode)
    	UI.keyreleased = key
		checkEvents("keyreleased")
--	if key == "f12" then love.system.openURL( "http://localhost:8000" ) end
	if key == "f4" then loadScriptURL() end
    
end

function love.wheelmoved(x, y)
	nk.wheelmoved(x, y)
    end

function love.textinput(t)
nk.textinput(text)
end

function love.mousereleased(x, y, button, istouch)
absorb = nk.mousereleased(x, y, button, istouch)
	
	if absorb ~= true then
	end
end

function love.mousemoved(x, y, dx, dy, istouch)
nk.mousemoved(x, y, dx, dy, istouch)
end
 
function love.mousepressed(x, y, button, istouch)
absorb = nk.mousepressed(x, y, button, istouch)
	if absorb ~= true then
		if button == 1 then
			absorbed = doButtonPress()
				if not absorbed then
					analyzemap()
					pathFinding(nil, "_" .. actorEntity.name .. "_", nil)	
				end
			showButtons(false)
		end
		if button == 2  then
		
			acteeName = getPointingAt("name")
			if acteeName ~= "" then
				showButtons(true)
			else
				showButtons(false)
			end
		end
	
	end
end

function love.update(dt)
--	 require("lovebird").update()
	nk.frameBegin()
	flux.update(dt)
	UI.mousex = love.mouse.getX()
	UI.mousey = love.mouse.getY()
	checkEvents("always")
	checkTimers()
	updateAnimate(dt)
	drawChat()
	updateXYtoFlux()
	nk.frameEnd()
	for i, animation in pairs(animations)  do
    animation.animation:update(dt)
  end
end

function love.draw()
	nk.draw()
  drawBackground()
	drawUI()
	drawEntities()
	drawBubbles()
	drawInformation()
--  drawImages()

end