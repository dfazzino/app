
	variables = {}
	
function initUIObject ()

	UI = {}

	UI.keyreleased = nil
	UI.keypressed = nil
	UI.mouseup = nil
	UI.mousedown = nil
	UI.mousex = nil
	UI.mousey = nil

end

function initVariables ()

	
	variable = {}
	variable.name = "testvar"
	variable.value = ""
	table.insert(variables, variable)

	variable = {}
	variable.name = "move"
	variable.value = "true"
	table.insert(variables, variable)
	
end


function loadVariables (variableSection)


	logFile:write("Starting to add variables!\n")

	for line in variableSection:lines() do			
		local words = line:split(" ")
		for i, word in ipairs(words)  do
			--first word should be new
			--logFile:write(word .. "\n")
			word = word:strip()
			if word == "new" then
				setupNewVariable()
				word = nil
			end
			
			if word ~= nil then
				word = word:strip()
				--print(word)
				if word:startsWith("variable.") then
					--print(word)
					word = word:gsub("%.", "|")
					variableWords = split(word, "|")
					-- print (entityWords[2])
					if variableWords[2] == "name" then
						variable.name = words[i + 2]
					end
					if variableWords[2] == "value" then
						variable.value = words[i + 2]
					end
				end
			end
			if word == "add" then
				addVariable()
				logFile:flush()
			end
		end
	end

end


function addVariable()

	table.insert(variables, variable)

end


function setupNewVariable ()

	variable = {}
	
	variable.name = "tempName"
	variable.value = ""
	
end


function SystemValues(word)
	if word == "mousePos" then print (word) end
	if word == "mouseX" then word = UI.mousex end
	if word == "mouseY" then word = UI.mousey end
	if word == "mousePos" then word = UI.mousex .. "," .. UI.mousey end
	if word == "keypressed" then word = UI.keypressed end
	if word == "keyreleased" then word = UI.keyreleased end
	
	return word
end

function UserValues(word)

	for i, var in ipairs(variables) do
		if var.name == word then
			word =  var.value
		end
	end
	return word
end

function UserValues2(word)

	local words = split(word,"|")

	if words[1] == "var" then
		for i, var in ipairs(variables) do
			if var.name == words[2] then
				word =  var.value
			end
		end
	end
	return word
end

