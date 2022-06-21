require "/scripts/util.lua"

local oldInit = init
local oldUpdate = update
local oldUnInit = uninit

function init()
  oldInit()
  status.setPersistentEffects("drain", { "drain" })
end

function update(dt, fireMode, shiftHeld)
  oldUpdate(dt, fireMode, shiftHeld)
end

function uninit()
  oldUnInit()
  status.clearPersistentEffects("drain")
end
