function init()
  modes = {
    primaryA = "/interface/scripted/mmutility/mmutility",
    altA = "/zb/questList/questList",
    primaryB = "/interface/scripted/statWindow/statWindow",
    altB = "/zb/researchTree/researchTree"
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
