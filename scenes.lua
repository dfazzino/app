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
            door = {}
            door.name = doorWords[1]
            door.xy = doorWords[2] .. "," .. doorWords[3]
            door.lw = doorWords[4] .. "," .. doorWords[5]
            door.image = doorWords[6]
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
  
  scenes[scene.name] = scene
  
end


function loadScene(name)
  
  collisionBoxes = {}
  currentScene = scenes[name]

		for i, sceneEntity in ipairs(currentScene.entities) do
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
    for i, button in ipairs(entities) do
        if button.action ~= nil then
            table.insert(currentScene.entities, button)
        end
    end
    for i, sceneEntity in ipairs(scenes["all"].entities) do
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
    for i, event in ipairs(scenes["all"].events) do
       table.insert(currentScene.events, event) 
    end
end