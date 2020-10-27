require '/scripts/fupower.lua'

function init()
	power.init()
	onInputNodeChange()
	setObjectOn(0)
end

function setObjectOn(iterations)
	storage.on=not object.isInputNodeConnected(1) or object.getInputNodeLevel(1)
	--doAnims()
	return storage.on, iterations
end

function isPower(iterations)
	return setObjectOn(iterations)
end

function onNodeConnectionChange()
	setObjectOn(0)
	power.onNodeConnectionChange(nil,0)
	onInputNodeChange()
end

function onInputNodeChange(args)
	setObjectOn(0)
	for i=0,object.inputNodeCount()-1 do
		for value in pairs(object.getInputNodeIds(i)) do
			if world.callScriptedEntity(value,'isPower',0) then
				world.callScriptedEntity(value,'power.onNodeConnectionChange',nil,0)
			end
		end
	end
	for i=0,object.outputNodeCount()-1 do
		for value in pairs(object.getOutputNodeIds(i)) do
			if world.callScriptedEntity(value,'isPower',0) then
				world.callScriptedEntity(value,'power.onNodeConnectionChange',nil,0)
			end
		end
	end
end

--[[
function doAnims()
	animator.setAnimationState("switchState", ((storage.on and ((power and power.getTotalEnergy and power.getTotalEnergy() or 0) > 0)) and "on") or "off")
end]]