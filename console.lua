gameOutputCount = 0
gameOutput = "test"
gameOutputLines = {}

function addGameOutputLine(line)
   gameOutputCount = gameOutputCount + 1
   if #gameOutputLines > 30 then
      table.remove(gameOutputLines, 1)
   end
   table.insert(gameOutputLines, line)
   gameOutput = ""

   for i, gameOutputLine in ipairs(gameOutputLines) do
      gameOutput  = gameOutput .. gameOutputLine .. "\n"
   
   end
end


function showscene(showthis)
  if showthis == "entities" or showthis == "" then
    addGameOutputLine("------------ENTITIES------------")  

    for i, entity in pairs (currentScene.entities) do
      if entity.name ~= nil then
      addGameOutputLine(entity.name)
      else
      addGameOutputLine(entity.entity.name)
      end
    end
  end  
  if showthis == "events" or showthis == "" then
      addGameOutputLine("\n------------EVENTS------------")

    for i, event in pairs (currentScene.events) do
      showEventMain(event)
    end
  end
  
end


function showEvent(eventname)
  for i, event in ipairs(events) do
    if event.name == eventname then
      showEventMain(event)
    end
  end
end


function showEventMain(event)
      linetrueactions = ""
      linefalsections = ""
      linelogic= ""

      if(event.logic or "" ~= "") then 
        splitlogic = event.logic:split(",")
        linelogic = "\n\tif " .. logic[tonumber(splitlogic[1])].ifString
        for i, logicnum in ipairs(splitlogic) do
          if i == 1 then
          else
            linelogic = linelogic .. " and " .. logic[tonumber(logicnum)].ifString 
          end
        end
      else 
        linelogic = "" 
      end
      if(event.trueactions or ""  ~= "") then 
        if event.logic or "" ~= "" then
          linetrueactions = "\n\t\tthen"
        else 
          linetrueactions = "\n\t\t"
        end
        linetrueactions = linetrueactions .. event.trueactions  else linetrueactions = "" 
      end
        
      if(event.falseactions or ""  ~= "") then linefalseactions = "\n\t\telse:" .. event.falseactions  else linefalseactions = "" end
      addGameOutputLine(event.name .. ":" .. linelogic .. linetrueactions .. linefalseactions)  
end