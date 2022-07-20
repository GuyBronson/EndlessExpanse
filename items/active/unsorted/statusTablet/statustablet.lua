function init()
  modes = {
    primaryA = "/interface/scripted/statWindow/statWindow",
    primaryB = "/zb/researchTree/researchTree",
    altA = "/interface/scripted/mmutility/mmutility",
    altB = "/zb/questList/questList"
  }
  sfx = {
    primaryA = "",
    primaryB = "3",
    altA = "",
    altB = "2"
  }
end

function activate(fireMode, shiftHeld)
  key = string.format("%s%s",fireMode, shiftHeld and "A" or "B")

	activeItem.interact("ScriptPane", modes[key]..".config", player.id())
	animator.playSound("activate"..sfx[key])
end

function update()
    activeItem.setArmAngle(mcontroller.crouching() and -0.15 or -0.5)
end
