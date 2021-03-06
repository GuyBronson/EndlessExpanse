require "/scripts/util.lua"
require "/scripts/interp.lua"

function init()
    self.itemList = "scrollArea.itemList"
    self.availableTechs = {}
    self.currentList = {}
    self.selectedItem = nil
    self.category = ""
    self.selectedTech = ""

    self.currentFilter = ""
    self.availableFilter = false
    self.currentSearch = ""
	categories()
    populateItemList()
end

function update(dt)
	if not player.primaryHandItem() or player.primaryHandItem().name ~= "fu_matmodplacer" then
		pane.dismiss()
	end
    updateSearch()
    reloadCraftable()
    populateItemList()
end

function reloadCraftable()
    for _,v in pairs(self.currentList or {}) do
        widget.setVisible(v..".notcraftableoverlay")
    end
end

function updateSearch()
    self.currentSearch = string.lower(widget.getText("filter"))
    self.availableFilter = widget.getChecked("btnFilterHaveMaterials")
end

function populateItemList(forceRepop)
    local shopTechs = config.getParameter("matMods")
    local availableTechs = {}
    for _,v in pairs(shopTechs) do
        local legit = true

        if legit and (self.currentFilter ~= "") then
            legit = v.category == self.currentFilter
        end

        if legit and (self.currentSearch ~= "") then
            -- Search by item name and then by tech name
            legit = (v.name and (string.find(v.name:lower(), self.currentSearch) ~= nil))
        end

        if legit then table.insert(availableTechs, v) end
    end

    if forceRepop or not compare(availableTechs, self.availableTechs) then
        self.availableTechs = availableTechs
        widget.clearListItems(self.itemList)
        widget.setButtonEnabled("btnUpgrade", false)

        self.currentList = {}

        for i, tech in ipairs(self.availableTechs) do

            local listWidget = widget.addListItem(self.itemList)
            local listItem = string.format("%s.%s", self.itemList, listWidget)
            table.insert(self.currentList, listItem)


            widget.setText(listItem..".itemName", tech.name)
            widget.setItemSlotItem(listItem..".itemIcon", tech.icon or "grassy")

            widget.setData(listItem,
            {
                index = i,
                tech = tech.name,
				image = tech.image,
				description = tech.description
            })

            widget.setVisible(listItem..".moneyIcon", false)
            widget.setText(listItem..".priceLabel", "")
            widget.setVisible(string.format("%s.notcraftableoverlay", listItem))

            if tech.name == self.selectedTech then
                widget.setListSelected(self.itemList, listWidget)
            end
        end

        self.selectedItem = nil
        setCanUnlock(nil)
    end
end

function setCanUnlock(recipe)
	if recipe then
		widget.setButtonEnabled("btnCraft", true)
	else
		widget.setButtonEnabled("btnCraft", false)
	end
end

function itemSelected()
    local listItem = widget.getListSelected(self.itemList)
    self.selectedItem = listItem
	local inEssentialSlot=essentialCheck()
    if listItem and not inEssentialSlot then
        local itemData = widget.getData(string.format("%s.%s", self.itemList, listItem))
        setCanUnlock("unlock")
        self.selectedTech = itemData.tech

        widget.setText("techDescription", itemData.description or "A material mod. Replaces any that already exist where you place it.")
        widget.setImage("techIcon", itemData.image or "/items/materials/grassy.png")
	elseif inEssentialSlot then
		widget.setText("techDescription", "^red;ERROR: Matmod Placer is in essential slot. Configuration disabled.^reset;")
    end
end

function essentialCheck()
	for _,v in pairs({ "beamaxe", "wiretool", "painttool", "inspectiontool"}) do
		local test=player.essentialItem(v)
		if test and test.name=="fu_matmodplacer" then
			return true
		end
	end
	return false
end

function doUnlock()
    if self.selectedItem then
        local selectedData = widget.getData(string.format("%s.%s", self.itemList, self.selectedItem))
        local tech = self.availableTechs[selectedData.index]
		local inEssentialSlot=essentialCheck()

        if tech and not inEssentialSlot then
			if player.consumeItem(player.primaryHandItem()) then
				player.giveItem({name = "fu_matmodplacer", count = 1, parameters = {matMod = tech.matMod, fuel = tech.fuel, fuelValue = tech.fuelValue}})
			end
			pane.dismiss()
        end

        populateItemList(true)
    end
end

function categories()
    local data = widget.getSelectedData("categories")
    if data then
        self.currentFilter = data.filter
    end
end
