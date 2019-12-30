events = {}

function initPlayerEventsListeners()

	local event = {}

	event.id = 1
	event.onClick = true
	event.onKeyPress = false
	event.always = false
	event.time = nil
	event.logic = loadLogic("pointing at talkTo")
	event.action = loadActions("event ")
	
	addEvent(event)

	local event = {}

	event.id = 1
	event.onClick = true
	event.onKeyPress = false
	event.always = false
	event.time = nil
	event.logic = loadLogic("pointing at talkTo")
	event.action = loadActions("start chat hasItem")
	
	addEvent(event)

	
	
end


function loadEvents(eventsSection)
	
	logFile:write("Starting to add events!\n")
	
	for line in eventsSection:lines() do			
					
		local words = line:split(" ")

		for i, word in ipairs(words)  do
			--first word should be new
			--logFile:write(word .. "\n")
			word = word:strip()

			if word == "new" then
				setupNewEvent()
				word = nil
			end
			if word == "as" then
				local asWords = words[i + 1]:split(",")
				asWord = word:strip()
				for j, asWord in ipairs(asWords) do
					if asWord:upper() == "ONCLICK" then
						event.onClick = true
					end
					if asWord:upper() == "ONKEYPRESS" then
						event.onKeyPress = true
					end
					if asWord:upper() == "ALWAYS" then
						event.always = true
					end
					if asWord:upper():startsWith("PLAYERACTION") then
						local playerAction = line:split("(", true)
						event.playerAction = string.sub(playerAction[2], 1, -2)
						
					end
					if asWord:upper() == "TIMER" then
						--event.time = true
					end
					if asWord:upper() == "CHATEVENT" then
						local chatID = line:split("(", true)
						event.chatID = string.sub(chatID[2], 1, -2)
					end					
				end

			end

			if word ~= nil then
				word = word:strip()
				--debug.debug()
				if word:startsWith("event.") then
					word = word:gsub("%.", "|")
					eventWords = split(word, "|")

					if eventWords[2] == "name" then
						event.name = words[i + 2]
					end
					if eventWords[2] == "deleteAfterRun" then
						event.delete = words[i + 2]
					end
					if eventWords[2] == "resetAfterRun" then
						event.reset = words[i + 2]
					end
					if eventWords[2] == "time" then
						event.time = words[i + 2]
						event.timeStart = timer.getTime()
					end
					if eventWords[2] == "logic" then
						event.logic = tostring(loadLogic(line))
					end
					if eventWords[2] == "actions" then
						local trueactions = line:split("=")
						event.trueactions = trueactions[2]
					end
					if eventWords[2] == "falseactions" then
						local falseactions = line:split("=")
						event.falseactions = falseactions[2]
					end

				end
			end
			if word == "add" then
				addEvent()
				logFile:flush()
			end
			if word == "hide" then
				event.hidden = true
				addEvent()
				logFile:flush()
			end

		end
	end
end


function loadEvent(line)
	
	local words = line:split(" ")

	for i, word in ipairs(words)  do
		--first word should be new
		--logFile:write(word .. "\n")
		word = word:strip()

		if word == "new" then
			setupNewEvent()
			word = nil
		end
		if word == "as" then
			local asWords = words[i + 1]:split(",")
			asWord = word:strip()
			for j, asWord in ipairs(asWords) do
				if asWord:upper() == "ONCLICK" then
					event.onClick = true
				end
				if asWord:upper() == "ONKEYPRESS" then
					event.onKeyPress = true
				end
				if asWord:upper() == "ALWAYS" then
					event.always = true
				end
				if asWord:upper():startsWith("PLAYERACTION") then
					local playerAction = line:split("(", true)
					event.playerAction = string.sub(playerAction[2], 1, -2)
					
				end

				if asWord:upper() == "TIMER" then
					--event.time = true
				end
				if asWord:upper() == "CHATEVENT" then
					local chatID = line:split("(", true)
					event.chatID = string.sub(chatID[2], 1, -2)
				end				
			end

		end
		
		if word ~= nil then
			word = word:strip()
			--debug.debug()
			if word:startsWith("event.") then
				word = word:gsub("%.", "|")
				eventWords = split(word, "|")

				if eventWords[2] == "name" then
					event.name = words[i + 2]
				end
				if eventWords[2] == "deleteAfterRun" then
					event.delete = words[i + 2]
				end
				if eventWords[2] == "resetAfterRun" then
					event.reset = words[i + 2]
				end
				if eventWords[2] == "time" then
					event.time = words[i + 2]
					event.timeStart = timer.getTime()
				end
				if eventWords[2] == "logic" then
					event.logic = tostring(loadLogic(line))
				end
				if eventWords[2] == "actions" then
					local trueactions = line:split("=")
					event.trueactions = trueactions[2]
				end
				if eventWords[2] == "falseactions" then
					local falseactions = line:split("=")
					event.falseactions = falseactions[2]
				end

			end
		end
		if word == "add" then
			addEvent()
			logFile:flush()
			return true
			
		end
		if word == "new" then
			return true
		end
	end
	return false
	
end


function setupNewEvent ()

	event = {}

	event.id = nil
	event.onClick = false
	event.onKeyPress = false
	event.always = false
	event.time = nil
	event.active = false
	event.logic = nil
	event.inventoryClick = false
	event.trueactions = nil
	event.falseactions = nil

end
	
function addEvent()

	table.insert(events, event)
	logFile:write("~~~event" .. table.getn(events))
	if event.name ~= nil then logFile:write("  " .. event.name) end
	logFile:write("~~\n")
	if event.onClick == true then logFile:write("\ton click \n") end
	if event.onKeyPress == true then logFile:write("\ton key press\n") end		
	if event.always == true then logFile:write("\talways\n") end		
	if event.logic ~= nil then 
		local logics = split(event.logic, ",") 
		for j, logicID in ipairs(logics) do
			logicString = logic[tonumber(logicID)].ifString
			if j == 1 then logFile:write("\t\tif  ") else logFile:write("\t\t\tand ") end
		
			logFile:write(logicString ..  " [" .. logicID .. "]\n")			
		
		end
	end
	if event.trueactions ~= nil then
		logFile:write("\t\t")
		logFile:write(event.trueactions)
		logFile:write("\n")
	end
	
	if event.falseactions ~= nil then
		local actionIDs	= split(event.falseactions, ",")
		for j, actionID in ipairs(actionIDs) do
			logFile:write("\t\t")	
			logFile:write(event.falseactions)
			logFile:write("\n")

		end			
	end
	logFile:write("------------------------------------------------------------------\n")			

end

function checkEvents (eventType, thisPath)

	for i, event in ipairs(currentScene.events) do

		--if event.hidden ~= true then
			if event.onClick == true and eventType == "click" then
				if event.logic ~= nil then
						checkLogic(event.logic, event.trueactions, nil, event.delete)
--				checkLogic(event.logic, event.trueactions, event.falseactions, event.delete)
					
				else
          
          print("click event " .. event.trueactions )
					doAction(event.trueactions)
					if event.delete == true then event.deleted = true end
				end
			end
			
			if event.onKeyPress == true and eventType == "keyreleased" then
				
				
				if event.logic ~= nil and  event.logic ~= "" then
					checkLogic(event.logic, event.trueactions, nil, event.delete)
--					checkLogic(event.logic, event.trueactions, event.falseactions, event.delete)
				
				else
					doAction(event.trueactions)
					if event.delete == true then event.deleted = true end
					end			
			end
			if event.always == true and eventType == "always" then
			
				if event.logic ~= nil then
					checkLogic(event.logic, event.trueactions, nil, event.delete)
--					checkLogic(event.logic, event.trueactions, event.falseactions, event.delete)

				else
					doAction(event.trueactions)
					if event.delete == true then event.deleted = true end

				end			
			end
			
			if event.playerAction == eventType and eventType ~= nil then
				if event.logic ~= nil then
          if thisPath == nil then
            checkLogic(event.logic, event.trueactions, nil, event.delete)
          else
            checkLogic(event.logic, thisPath .. event.trueactions, nil, event.delete)
          end
--					checkLogic(event.logic, thisPath .. event.trueactions, thisPath .. event.falseactions, event.delete)
      else
          print("playeraction " .. event.trueactions)
					doAction(thisPath .. event.trueactions)
					if event.delete == true then event.deleted = true end

				end			
					
			end
			if event.chatID == eventType then
				if event.logic ~= nil then
					checkLogic(event.logic, thisPath or "" .. event.trueactions,nil, event.delete)
--					checkLogic(event.logic, thisPath .. event.trueactions,event.falseactions, event.delete)
				else
          print("chat action " .. event.trueactions)
					chatnode = doAction(thisPath or "" .. event.trueactions)
					if event.delete == true then event.deleted = true end

				end			
				break			
			end
		--end
		
	end
	deleteEvents()
end


function deleteEvents()

	i = 1
	while i <= #currentScene.events do
		if currentScene.events[i].deleted == true then
			table.remove(currentScene.events, i)
		else
			i=i+1
		end
	end


end

function checkTimers()

	for i, event in ipairs(currentScene.events) do
	
		if event.time ~= nil and event.timeStart ~= nil then
			if timer.getTime() > (event.timeStart + event.time) then
				if event.logic ~= nil and event.logic ~= "" then
					checkLogic(event.logic, event.trueactions, event.falseactions)
					
						if event.delete == "true" then event.remove = true  end
						if event.reset == "true" then event.timeStart = timer.getTime() end

					else
						doAction(event.trueactions)
						if event.delete == "true" then event.remove = true end
						if event.reset == "true" then event.timeStart = timer.getTime() end
				end	
			end
		
		end
	
	end
	for i, event in ipairs(currentScene.events) do
		if event.remove == true then table.remove(currentScene.events, i) end
	end
	
end

function getEvent(name)

	for i, event in ipairs (events) do
	
		if event.name == name then
			return event
		end
	end
	
	return "none"

end

function checkChatEvent(eventID)

	event = events[eventID]
	if event.logic ~= nil and event.logic ~= "" then
		
		checkLogic(event.logic, event.trueactions, event.falseactions)
		
  else
			doAction(event.trueactions)
	end	

end