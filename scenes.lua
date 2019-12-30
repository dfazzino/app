function initScenes()

scenes = {}
currentScene = {}
doors = {}
end




function loadScenes (sceneSection)

	logFile:write("Starting to add scenes!\n")

	for line in sceneSection:lines() do
			
		line = line:strip()

		local words = line:split(" ")

		for i, word in ipairs(words)  do
			--first word should be new
			--logFile:write(word .. "\n")
			word = word:strip()

			if word == "new" then
				setupNewScene()
				word = nil
			end
			
			if word ~= nil then
				sceneWord = word:strip()
				--debug.debug()
				if word:startsWith("scene.") then
					word = word:gsub("%.", "|")
					sceneWords = split(word, "|")
					-- print (entityWords[2])

					if sceneWords[2] == "name" then
						scene.name = words[i + 2]
					end
          if sceneWords[2] == "background" then
						scene.background = love.graphics.newImage(words[i + 2])
					end
					if sceneWords[2] == "entities" then
            sceneEntity = {}
            sceneEntity.entity =  getEntity(words[i + 2])
            xywords = line:split("(", true)
            sceneEntity.xy = string.sub(xywords[2], 1, -2)
						table.insert(scene.entities, sceneEntity)
					end				
          if sceneWords[2] == "events" then
            eventWords = split(words[i + 2], ",")
            for i, eventword in ipairs(eventWords) do
              table.insert(scene.events, getEvent(eventword))
            end
					end		
          if sceneWords[2] == "door" then
            doorWords = split(words[i + 2], ",")
            entity = {}
            sceneEntity = {}
            entity.name = "doorFrom" .. doorWords[5] .. "To" .. doorWords[6]
            entity.static = "true"
            entity.hiddenbutton = "true"
            doorWords[9] = doorWords[9] or 0
            doorWords[10] = doorWords[10] or 0
            entity.action = "loadScene "  .. doorWords[6] 
            entity.xy = "0,0"
            
            entity.interactLocations = {}
						interactLocation = {}
						interactLocation.action = "To"
						interactLocation.xy = doorWords[7] .. "," .. doorWords[8]

            table.insert(entity.interactLocations, interactLocation)
            
            entity.boxes = {}
            box = {}
            box.relativexy = doorWords[1] .. "," .. doorWords[2]
            box.box= doorWords[3] .. "," .. doorWords[4]
            sceneEntity.entity = entity
            sceneEntity.xy = "0,0"
            table.insert(entity.boxes, box)
            table.insert(entities, entity)
            table.insert(scene.entities, sceneEntity)
            
            event = {}
            event.name = "doorFrom" .. doorWords[5] .. "To" .. doorWords[6]
            event.playerAction = "loadScene " .. doorWords[6]
            event.trueactions = "loadScene " .. doorWords[6] .. " " .. doorWords[9] .. "," .. doorWords[10]
            table.insert(events, event)
            table.insert(scene.events, event)
            
					end        
				end
			end
			if word == "add" then
				addScene()
				logFile:flush()
			end	
		end
	end
end



function setupNewScene()
    scene = {}
    scene.entities = {}
    scene.actions = {}
    scene.events = {}
    scene.chats = {}
    scene.doors = {}

end


function addScene()
    for i, button in ipairs(entities) do
        if button.action ~= nil then
            sceneEntity = {}
            sceneEntity.entity = button
            table.insert(scene.entities, sceneEntity)
        end
    end    
  scenes[scene.name] = scene
  
end


function loadScene(name, actionXY)
  
  currChatNode = nil
  collisionBoxes = {}
  currentScene = scenes[name]

		for i, sceneEntity in ipairs(currentScene.entities)  do
      if sceneEntity.entity.action == nil then
        if actionXY ~= "0,0"  and actionXY ~= nil and actionXY ~= ""  and sceneEntity.entity.actor == "true"  then
          sceneEntity.xy = actionXY
        end
        sceneEntity.entity.xy = sceneEntity.xy
        local entity = sceneEntity.entity
        
        xy = split(sceneEntity.xy, ",")
        for i, box in ipairs(entity.boxes) do
	
          local xy2 = split(box.relativexy, ",")
          box.xy = tonumber(xy2[1]) + tonumber(xy[1]) .."," ..  tonumber(xy2[2]) + tonumber(xy[2])

          if box.collision == true then
            table.insert(collisionBoxes, box)
          end 
        end
      end
    end

    for i, sceneEntity in ipairs(scenes["all"].entities) do
      if sceneEntity.entity.action == nil then
        sceneEntity.entity.xy = sceneEntity.xy
        local entity = sceneEntity.entity
        xy = split(sceneEntity.xy, ",")
        for i, box in ipairs(entity.boxes) do
	
          local xy2 = split(box.relativexy, ",")
          box.xy = tonumber(xy2[1]) + tonumber(xy[1]) .."," ..  tonumber(xy2[2]) + tonumber(xy[2])

          if box.collision == true then
            table.insert(collisionBoxes, box)
          end 
        end
			end
    end

    for i, event in ipairs(scenes["all"].events) do
       table.insert(currentScene.events, event) 
    end
end


