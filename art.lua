
arts = {}
sheets = {}
animations = {}
images = {}

function loadArt (artSection)


  logFile:write("Starting to add art!\n")

  for line in artSection:lines() do			
    local words = line:split(" ")
    for i, word in ipairs(words)  do
      --first word should be new
      --logFile:write(word .. "\n")
      word = word:strip()
      if word == "new" then
        addingNew = true
        word = nil

      end

      if word == "spritesheet" and addingNew == true then
        setupNewSpritesheet()
        word = nil
        addingNew = false
        addingSpriteSheet = true
      end

      if word == "gridsheet" and addingNew == true then
        setupNewGridSheet()
        word = nil
        addingNew = false
        addingGridSheet = true
      end      

      if word == "animation" and addingNew == true then
        setupNewAnimation()
        word = nil
        addingNew = false
        addingAnimation = true
      end      
      if word == "image" and addingNew == true then
        setupNewImage()
        word = nil
        addingNew = false
        addingImage = true
      end      


      if word ~= nil then
        word = word:strip()
        --print(word)
        if word:startsWith("spritesheet.") then
          --print(word)
          word = word:gsub("%.", "|")
          artWords = split(word, "|")
          -- print (entityWords[2])
          if artWords[2] == "name" then
            spritesheet.name = words[i + 2]
          end
          if artWords[2] == "file" then
            spritesheet.file = love.graphics.newImage(words[i + 2])
          end
          if artWords[2] == "xml" then
            spritesheet.xml = words[i + 2]
          end
        end
        if word:startsWith("gridsheet.") then
          --print(word)
          word = word:gsub("%.", "|")
          artWords = split(word, "|")
          -- print (entityWords[2])
          if artWords[2] == "name" then
            gridsheet.name = words[i + 2]
          end
          if artWords[2] == "file" then
            gridsheet.file = love.graphics.newImage(words[i + 2])
          end
          if artWords[2] == "framewidth" then
            gridsheet.framewidth =tonumber(words[i + 2])
          end				
          if artWords[2] == "frameheight" then
            gridsheet.frameheight = tonumber(words[i + 2])
          end						
          if artWords[2] == "left" then
            gridsheet.left= tonumber(words[i + 2])
          end					
          if artWords[2] == "top" then
            gridsheet.top = tonumber(words[i + 2])
          end					
          if artWords[2] == "xoffset" then
            gridsheet.xoffset = tonumber(words[i + 2])
          end			
          if artWords[2] == "yoffset" then
            gridsheet.yoffset = tonumber(words[i + 2])
          end			
--          if artWords[2] == "border" then
--						gridsheet.file = tonumber(words[i + 2])
--					end
        end
        if word:startsWith("animation.") then
          --print(word)
          word = word:gsub("%.", "|")
          artWords = split(word, "|")
          -- print (entityWords[2])
          if artWords[2] == "name" then
            animation.name = words[i + 2]
          end
          if artWords[2] == "sheet" then
            animation.sheet = words[i + 2]
          end
          if artWords[2] == "x1" then
            animation.x1 =words[i + 2]
          end				
          if artWords[2] == "y1" then
            animation.y1 = words[i + 2]
          end									
          if artWords[2] == "rate" then
            animation.rate = tonumber(words[i + 2])
          end		
          if artWords[2] == "border" then
            animation.border = tonumber(words[i + 2])
          end								
          if artWords[2] == "flip" then
            animation.flip = words[i + 2]
          end								

--          if artWords[2] == "border" then
--						gridsheet.file = tonumber(words[i + 2])
--					end
        end
        if word:startsWith("image.") then
          --print(word)
          word = word:gsub("%.", "|")
          imageWords = split(word, "|")
          -- print (entityWords[2])
          if imageWords[2] == "name" then
            image.name = words[i + 2]
          end
          if imageWords[2] == "sheet" then
            image.sheet = words[i + 2]
          end
          if imageWords[2] == "id" then
            image.id = words[i + 2]
          end
        end
      end
      if word == "add" then
        if addingSpriteSheet then
          addSpriteSheet()
          addingSpriteSheet = false
        end
        if addingImage then
          addImage()
          addingImage = false
        end
        if addingGridSheet then
          addGridSheet()
          addingGridSheet = false

        end
        if addingAnimation then
          addAnimation()
          addingAnimation = false
        end
        logFile:flush()
      end
    end
  end

end

function setupNewSpritesheet ()

  spritesheet = {}

  spritesheet.name = "tempName"
  spritesheet.file = ""
  spritesheet.xml = ""

end

function setupNewGridSheet ()

  gridsheet = {}

  gridsheet.name = "tempName"
  gridsheet.file = ""
  gridsheet.xoffset = 0
  gridsheet.yoffset = 0

end

function setupNewAnimation ()

  animation = {}

  animation.name = "tempName"
  animation.file = ""

end


function setupNewImage()

  image = {}

  image.name = "tempName"
  image.sheet = ""

end

function addSpriteSheet ()
  local handler = require('xmlhandler.tree')

  tempfile = io.open(spritesheet.xml, "r")
  xmldata = ""
  repeat
    line = tempfile:read()
    if line ~= nil then xmldata = xmldata .. line .. "\n" end
  until line == nil
--  tempthing = xml2lua.parse(handler)	
  local parser = xml2lua.parser(handler)
  parser:parse(xmldata)
  spritesheet.subtexture = handler.root.TextureAtlas.SubTexture
  sheets[spritesheet.name] = spritesheet

  addingSpriteSheet = false
--  spritesheet.splitxml = 

end

function addImage()

  for i, p in pairs(sheets[image.sheet].subtexture) do
    if p._attr.name == image.id then 
      image.quad = love.graphics.newQuad(p._attr.x, p._attr.y, p._attr.width, p._attr.height,sheets[image.sheet].file:getWidth(), sheets[image.sheet].file:getHeight())
      table.insert(images, image)
    end
  end
end

function addGridSheet ()
  gridsheet.g = anim8.newGrid(gridsheet.framewidth, gridsheet.frameheight, gridsheet.file:getWidth(), gridsheet.file:getHeight(), gridsheet.border  )
  sheets[gridsheet.name] = gridsheet
  addingGridSheet = false
end

function addAnimation ()

  animation.animation = anim8.newAnimation(sheets[animation.sheet].g(animation.x1,animation.y1), animation.rate)
  if animation.flip == "flipV" then
    animation.animation:flipV()
  elseif animation.flip  == "flipH" then
    animation.animation:flipH()          
  end
  animations[animation.name] = animation 
  
  addingAnimation = false
end

function addArt(s)

  table.insert(arts, art)

end

function initDraw()

  animateload()

end

function animateload()
  image30 = love.graphics.newImage('genericItems_spritesheet_colored.png')
  g = anim8.newGrid(27,27, image30:getWidth(), image30:getHeight())
  testdraw = anim8.newAnimation(g('2-7',4), 0.10)
end


function updateAnimate(dt)
  for i, entity in ipairs(entities) do
    if entity.animate ~= nil then
      entity.animate:update(dt)
    end
  end

end

function drawEntities()


  -- do we need to sort for z?
  local currentZ = 0
  for i, sceneEntity in ipairs(currentScene.entities) do
    if sceneEntity.entity ~= nil then 
      entity = sceneEntity.entity
    else
      entity = sceneEntity
    end
    entity.drawn = false
  end

  repeat
    local lowestNextZ = 99999
    for i, sceneEntity in ipairs(currentScene.entities) do
      local entity
      if sceneEntity.entity ~= nil then 
        entity = sceneEntity.entity
      else
        entity = sceneEntity
      end
      if entity.drawn == false and #entity.boxes > 0 and entity.visible ~= "false" then
        xy = split(entity.boxes[1].xy, ",")
        x = tonumber(xy[1])
        y = tonumber(xy[2])
        if entity.zCalc == "true" then entity.z = y  end
        if entity.z == currentZ  or entity.z == nil then

          if entity.drawType == "lovedraw" or entity.drawType == "both" then drawASquare(entity) end
          if entity.drawType == "anim8" or entity.drawType == "both" then drawAnimation(entity) end	
          entity.drawn = true
        else
          if entity.z < lowestNextZ then
            lowestNextZ = entity.z

          end
        end
      end
    end
    if lowestNextZ == currentZ then break else currentZ = lowestNextZ 	end
  until true ==	 false	
--  print("test")
end

function drawASquare(myEntity)

  for i, box in ipairs(myEntity.boxes) do
    if box.color ~= nil then 
      rgb = box.color:split(",")
      love.graphics.setColor(rgb[1] or 255,rgb[2] or 255 ,rgb[3] or 255,rgb[4] or 255, 150 )			
    end

    xy = {}
    size = {}
    local xy = split(box.xy, ",")
    box = split(box.box, ",")
    if getPointingAt("action") == myEntity.action and myEntity.action ~= nil then 
      love.graphics.setColor(255,0, 0, 255)
    end
    draw.rectangle("fill", tonumber(xy[1]), tonumber(xy[2]), tonumber(box[1]), tonumber(box[2]))
    love.graphics.setColor(0,0, 0, 255 )
    draw.rectangle("line", tonumber(xy[1]), tonumber(xy[2]), tonumber(box[1]), tonumber(box[2]))
    love.graphics.setColor(255,255, 255, 255 )
    if myEntity.text ~= nil then
      love.graphics.setColor(0,0, 0, 255 )
      love.graphics.print(myEntity.text, xy[1] + 5, xy[2] + 5)
      love.graphics.setColor(255,255, 255, 255)
    end

  end
end


function drawAnimation (entity)

  xy = split(entity.boxes[1].xy, ",")
--	for i, animation in ipairs(animations)  do
--  scalearea = love.graphics.getHeight() * .40
--  if tonumber(xy[2]) < scalearea then
--    size = xy[2] / scalearea
--  else
--    size = 1
--  end
--  if size < .30 then 
--    size = .30 end
  love.graphics.getHeight()
  if entity.standing ~= nil  and entity.noAnimationOverride ~= true then
  entity.animation = animations[entity.standing]
  end
  if entity.flux ~= nil and entity.noAnimationOverride ~= true then
    if type(entity.flux.vars.x) ~= "number" then
      
      if entity.flux.vars.x.diff < 0 then
          entity.animation = entity.walkLeft
      elseif entity.flux.vars.x.diff > 0  then
          entity.animation = entity.walkRight
      elseif entity.flux.vars.y.diff > 0 or entity.flux.vars.y.diff < 0 then
        entity.animation = entity.walkRight
      end
    else    
    
      if entity.flux.vars.x < entity.x then
          entity.animation = entity.walkLeft
      elseif entity.flux.vars.x  > entity.x   then
          entity.animation = entity.walkRight
      elseif entity.flux.vars.y > entity.y or entity.flux.vars.y < entity.y then
        entity.animation = entity.walkRight
      end
    end

  end 
  --All animations properties should now refer to the animation itself, not the animation name.

  entity.animation.animation:draw(sheets[entity.animation.sheet].file, tonumber(xy[1]) + sheets[entity.animation.sheet].xoffset, tonumber(xy[2]) + sheets[entity.animation.sheet].yoffset, 0, 1 , 1 )
--  end

--  entity.animate:draw(image30, tonumber(xy[1]), tonumber(xy[2]), nil, 1,1)

end

function drawImages() 
  for i, image in pairs(images) do
    love.graphics.draw(sheets[image.sheet].file, image.quad, 100, 100, 0)
  end
end

function drawBackground()
    
    if currentScene.background ~= nil then
      love.graphics.draw(currentScene.background, 0, 0)
    end
  
end