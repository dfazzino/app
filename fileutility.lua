function OpenLogFile()    
	
	mydir = love.filesystem.getAppdataDirectory( )
    logFile = io.open("logfile.txt", "w")
    logFile:write("Opening LogFile\n")

end

function OpenScriptFile()    

	scriptData = ""
    logFile:write("Opening ScriptFile\n")	
    scriptFile = io.open("scriptfile.txt", "r")
	repeat
		line = scriptFile:read()
		if line ~= nil then scriptData = scriptData .. line .. "\n" end
	until line == nil
--	print(scriptData)
end

function loadScriptURL(url)

--    if string.find(url, "raw/") == nil then
--        url = string.gsub(url, "pastebin.com/", "pastebin.com/raw/")
--        url = string.gsub(url, "pastebin.com/raw.php?i=", "pastebin.com/raw/")
--    end
--    scriptFile = io.open("urlscriptfile.txt", "w")
    --print(url)
	i = 0
	repeat
		scriptData, a, b = http.request("http://pastebin.com/raw/hM9P7UhF")
		print("script!",scriptData , a, b )

		if scriptData == "" then
			sleep(5)
			i = i + 1
		end
	until scriptData ~= "" or i > 5
	--	print(scriptData)
end


function sleep(n)
  local t = os.clock()
    while os.clock() - t <= n do
    -- nothing
  end
end