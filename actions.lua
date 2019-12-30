actions = {}
actionQueue = {}


function initActions()

	local action = {}

	action.command = "start chat hi" 
	addAction(action) 
	 
end
	

 
function addActionToQueue(actions, waitAction) 

	tempAction = {}
	tempAction.actions = actions
	tempAction.waitaction = waitAction
	table.insert(actionQueue, tempAction) 	
	
end	
	

function checkActionQueue(actionWords, cancelActions)
	for i, a in ipairs(actionQueue) do
			
		if a.waitaction == actionWords or (a.waitaction[1] == actionWords[1] and a.waitaction[2] == actionWords[2] and cancelActions == true) then
			if cancelActions ~= true then doAction(a.actions,nil, dt)  end
			a.remove = true
			if cancelActions ~= true then break end
		end
	end
	i = 1
	while i <= #actionQueue do
		if actionQueue[i].remove == true then
			table.remove(actionQueue, i)
		else
			i=i+1
		end
	end

end	
	
	
function loadActions(line)

	thisActions = ""
	actionLines = line:split("=")
	line = actionLines[2]:strip()
	
	if line:includes("/") then
		barList = line:split("/")
	else
		barList = {}
		table.insert(barList, line)
	end
	for h, barLine in ipairs(barList) do 
		actionLines = barLine:split("then")
		for i, actionLine in ipairs(actionLines) do
			localLine = ""
			foundAction = false
			actionLine = actionLine:strip()
			for j, action in ipairs(actions) do
				if action.command == actionLine then
					if localLine == "" then
						localLine = action.id
					else
						localLine = localLine .. "," .. action.id
					end
					foundAction = true
					break
				end
			end
			if foundAction ~= true then
				local action = {}
				
				action.id = table.getn(actions) + 1
				action.command = actionLine
				table.insert(actions, action)
				if localLine == "" then
					localLine = action.id
				else
					localLine = localLine .. "," .. action.id
				end

			end
		end
		thisActions = thisActions .. localLine .. "|"
	end
	return string.sub(thisActions, 1, -2)
	
end


function addAction(action)
	table.insert(actions, action)
	--logFile:write("action " .. table.getn(actions) .." " .. action.command .. "\n")
	
end	
	
function doAction(strActions, barSplit, dt)

	actionList = strActions:split("then")
	for i, action in ipairs(actionList) do
		queueActions = {}
		if action:includes("/") then
			splitActions = action:split("/")
			tempActions = ""
			for i, sA in ipairs(splitActions) do
				if i ~= 1 then	
					tempActions = tempActions .. sA .. "/"
				end
			end
			
			action = trim(splitActions[1])

			queueActions.actions = tempActions
			
		end
    performAction(action)
		
	end
end


function performAction(action)
  addGameOutputLine(action)
	action = trim(action)
		if action ~= nil then
			local actionWords = action:split(" ") 
			local actionWord1 = trim(actionWords[1])
			local actionWord2 =  UserValues2(trim(actionWords[2] or ""))
			local actionWord3 = trim(actionWords[3] or "")
			if queueActions ~= nil then 
			if queueActions.actions ~= nil then 
				addActionToQueue(string.sub(queueActions.actions, 1, -2), actionWords)
			end
			end
			
			if actionWord1 == "start" and actionWord2 == "chat" then
--				if (currChatNode == nil ) then
					initChat(actionWord3)
					setupChat()
--				end
			end
			if string.match(actionWord3, "pointingAt") == "pointingAt" then
				actionWord3 = split(actionWord3, '|')
				actionWord3 = getPointingAt(actionWord3[2])
			else
				actionWord3 = SystemValues(actionWord3)
				actionWord3 = UserValues2	(actionWord3)
			end
			if actionWord1 == "append" or actionWord1 == "set" or actionWord1 == "delete" then
				doCommand(actionWord1, actionWord2, actionWord3, actionWords)
			end
			if (actionWord1 == "move" or actionWord1== "moveTo") and (actionWord2 ~= "" and actionWord2 ~= nil) then
				entityCommand(actionWord1, actionWord2, actionWord3, actionWords, dt)
			end
			if (actionWord1 == "create") then
				eventCreate(actionWord2, actionWord3, actionWords)
			end	
			if (actionWord1:includes("Inv")) then
				inventoryCommand(actionWord1,actionWord2,actionWord3, actionWords)
			end			
      if (actionWord1:includes("loadScene")) then
        sceneCommands(actionWord1,actionWord2,actionWord3)
      end
      if (actionWord1:includes("changeAnimation")) then
        entityCommand(actionWord1,actionWord2,actionWord3)
      end			
      if (actionWord1 == "show") then
          if (actionWord2 == "scene") then 
            showscene(actionWord3)
          end
          if (actionWord2 == "event") then
              showEvent(actionWord3)
          end
      end
      if (actionWord1 == "toggle" and actionWord2 == "console") then
          consolemode = not consolemode
      end
		end	

end

function doCommand(verb, varName, value, actionWords)

	for i, variable in ipairs(variables) do
		if variable.name == varName then
			if verb == "set" then variable.value = ""  end
			variable.value = variable.value .. value
			break
		end
	end	
	if verb == "delete" then

		if varName == "event" then
			for i, event in ipairs(events) do
				if event.name == value then
					table.remove(events, i)
					break
				end
			end
		end
	end	
	
	
end

function entityCommand(verb, varName, value, actionWords, dt)

	if  verb == "moveTo" then
		moveEntityTo(varName, value, actionWords)
	elseif  verb == "move" then
		--local xy = split(entity.boxes[1].xy, ",")
		moveEntity(varName, value, actionWords, dt)
  elseif verb == "changeAnimationHold" then
    local thisEntity = getEntity(varName)
    thisEntity.animation = animations[value]
    thisEntity.noAnimationOverride = true

  elseif verb == "changeAnimation" then
    local thisEntity = getEntity(varName)
    
    thisEntity.animation = animations[value]
	end

end


function inventoryCommand(verb,itemID,entity, actionWords)

	if verb == "addInv" then
		addInventory(itemID, entity)
	end
	if verb == "removeInv" then
		removeInventory(itemID, entity)
	end
	
end

function  sceneCommands(verb, scene, xy)

  loadScene(scene, xy)
  
end

function eventCreate(varName, value, actionWords)

	-- [1] time on the timer.
	-- [2] logic
	-- [3] true actions
	-- [4] false actions
	-- [5] delete/reset

	if varName == "timer" then
	
		local event = {}
			
		values = split(value, "|")
		event.id = 1
		event.onClick = false
		event.onKeyPress = false
		event.always = false
		event.time = values[1]
		event.timeStart = timer.getTime()
		if values[5] == "D" then event.delete = "true" end
		if values[5] == "R" then event.reset = "true" end
		event.logic = values[2]
		event.inventoryClick = false
		event.trueactions = values[3]
		event.falseactions = values[4]
		event.name = "testTimer"
		addEvent(event)
	end

end
