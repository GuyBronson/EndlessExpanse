function init()
  modes = {
    primaryNoShift = "/interface/scripted/statWindow/statWindow",
    primaryShiftHeld = "/interface/scripted/mmutility/mmutility",
    altNoShift = "/zb/researchTree/researchTree",
    altShiftHeld = "/zb/questList/questList"
  }
  sfx = {
    primaryNoShift = "",
    primaryShiftHeld = "3",
    altNoShift = "",
    altShiftHeld = "2"
  }
end

function activate(fireMode, shiftHeld)
  key = string.format("%s%s",fireMode, shiftHeld and "ShiftHeld" or "NoShift")

  activeItem.interact("ScriptPane", modes[key]..".config", player.id())
  animator.playSound("activate"..sfx[key])
end

function update()
    activeItem.setArmAngle(mcontroller.crouching() and -0.15 or -0.5)
end
