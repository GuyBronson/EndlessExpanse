require "/scripts/kheAA/transferUtil.lua"
local deltaTime = 0

function init()
	object.setInteractive(true)
end

function update(dt)
	if not transferUtilDeltaTime or (transferUtilDeltaTime > 1) then
		transferUtilDeltaTime=0
		transferUtil.loadSelfContainer()
	else
		transferUtilDeltaTime=transferUtilDeltaTime+dt
	end
end