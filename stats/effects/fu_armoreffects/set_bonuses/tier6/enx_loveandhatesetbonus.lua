require "/stats/effects/fu_armoreffects/setbonuses_common.lua"
setName="enx_loveandhateset"

weaponBonus={
	{stat = "critChance", amount = 5}
}

armorBonus={
	{stat = "insanityImmunity", amount = 1},
	{stat = "aetherImmunity", amount = 1},
	{stat = "energyRegenPercentageRate", baseMultiplier = 1.15},
	{stat = "energyRegenBlockTime", baseMultiplier = 0.85}
}

function init()
	setSEBonusInit(setName)
	effectHandlerList.weaponBonusHandle=effect.addStatModifierGroup({})

	checkWeapons()

	effectHandlerList.armorBonusHandle=effect.addStatModifierGroup(armorBonus)
end

function update(dt)
	if not checkSetWorn(self.setBonusCheck) then
		effect.expire()
	else
		checkWeapons()
	end
end

function checkWeapons()
	local weapons=weaponCheck({"staff"})

	if weapons["either"] then
		effect.setStatModifierGroup(effectHandlerList.weaponBonusHandle,weaponBonus)
	else
		effect.setStatModifierGroup(effectHandlerList.weaponBonusHandle,{})
	end
end