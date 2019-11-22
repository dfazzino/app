
function showButtons(show)


	for i, b in ipairs(entities) do	
		if b.action ~= nil then
			if show == true then
				b.visible = "true"
				moveEntityDirect(nil, b, UI.mousex .. "," .. UI.mousey)

			else
				b.visible = "false"
			end
		end
		
	end
end



function loadButtons (buttonsSection)

	logFile:write("Starting to add buttons!\n")
	
	for line in buttonsSection:lines() do
		words = line:split(" ")
		for i, word in ipairs(words)  do
			--first word should be new
			--logFile:write(word .. "\n")
			word = word:strip()

			if word == "new" then
				setupNewEntity()
				word = nil
			end
			
			if word ~= nil then
				word = word:strip()
				--debug.debug()
				if word:startsWith("button.") then
					word = word:gsub("%.", "|")
					entityWords = split(word, "|")
					-- print (entityWords[2])

					if entityWords[2] == "action" then
						entity.action = words[i + 2]
					end
					if entityWords[2] == "drawType" then
						entity.drawType = words[i + 2]
					end
					if entityWords[2] == "xy" then
						entity.xy = words[i + 2]
					end
					if entityWords[2] == "text" then
						entity.text = words[i + 2]
					end
          
					if entityWords[2] == "visible" then
						entity.visible = words[i + 2]
					end
          
					if entityWords[2] == "boxes" then
						boxWords = words[i + 2]:split(",")
						
						box = {}
						box.relativexy = boxWords[1] .. "," .. boxWords[2]

						local entityxy = split(entity.xy, ",")

						box.xy = boxWords[1] + entityxy[1] .. "," .. boxWords[2]+ entityxy[2] 

						box.box = boxWords[3] .. "," .. boxWords[4]
						table.insert(entity.boxes, box)
					end
					
				end
			end
			if word == "add" then
				addButton()
				logFile:flush()
			end
		end
	end				
end

function addButton()
  entity.z = 9999
	table.insert(entities, entity)
	logFile:write("~~~button" .. table.getn(entities))
	if entity.name ~= nil then logFile:write("  " .. entity.name) end
	logFile:write("~~\n")
	logFile:write("\tdraw type: " .. entity.drawType .. "\n")
	for i, box in ipairs(entity.boxes) do
		local bxy = box.xy:split(",")
		local bwh = box.box:split(",")
		logFile:write("\tbox " .. i .. ": " .. "x " .. bxy[1] .. " y ".. bxy[2]  .. " w ".. bwh[1]  .. " h ".. bwh[2] .. "\n")
	end	
	
	logFile:write("\n------------------------------------------------------------------\n")			

  end

function doButtonPress()

	for i, b in ipairs(entities) do
		if getPointingAt("action") == b.action and b.action ~= nil then 
			-- print(acteeName)
			acteeEntity = getEntity(acteeName)
			-- print(acteeEntity.name)
			local thisPath = moveToEntity(actorEntity, acteeEntity, b.action)
			action = actorEntity.name .. ' ' .. b.action .. ' ' .. acteeEntity.name	
			checkEvents(action, thisPath)
      
			return true
		end		
	end
	return false
end
