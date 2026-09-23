---@class DarkEquipMenu : Object
---@overload fun(...) : DarkEquipMenu
local DarkEquipMenu, super = HookSystem.hookScript(DarkEquipMenu)

function DarkEquipMenu:init()
    super.init(self)

    self.caption_sprites["ammo"] = Assets.getTexture("ui/menu/caption_ammo")

    self.armor_icons = {
        Assets.getTexture("ui/menu/equip/armor_1"),
        Assets.getTexture("ui/menu/equip/armor_2"),
    }
	
	self.ammo_icon = Assets.getTexture("ui/menu/equip/ammo")

    self.selected_item = {
        ["weapons"] = 1,
        ["ammo"] = 1,
        ["armors"] = 1
    }
    self.item_scroll = {
        ["weapons"] = 1,
        ["ammo"] = 1,
        ["armors"] = 1
    }
end

function DarkEquipMenu:getAbilityPreview()
    local party = self.party:getSelected()
	if party.id == "jamm" then
		local current_abilities = {}
		local weapon = party.equipped.weapon
		if weapon and weapon:getBonusName() then
			current_abilities[1] = { name = weapon:getBonusName(), icon = weapon:getBonusIcon(), color = weapon:getBonusColor() }
		end
		local ammo = party.equipped.ammo
		if ammo and ammo:getBonusName() then
			current_abilities[2] = { name = ammo:getBonusName(), icon = ammo:getBonusIcon(), color = ammo:getBonusColor() }
		end
		local armor = party.equipped.armor[1]
		if armor and armor:getBonusName() then
			current_abilities[3] = { name = armor:getBonusName(), icon = armor:getBonusIcon(), color = armor:getBonusColor() }
		end
		if self.state == "ITEMS" and self:canEquipSelected() then
			local preview_abilities = {}
			local equipment = self:getEquipPreview()
			for i = 1, 3 do
				if equipment[i] and equipment[i]:getBonusName() then
					preview_abilities[i] = {
						name = equipment[i]:getBonusName(),
						icon = equipment[i]:getBonusIcon(),
						color = equipment[i]:getBonusColor()
					}
				end
			end
			return preview_abilities, current_abilities
		else
			return current_abilities, current_abilities
		end
	end
	
	return super.getAbilityPreview(self)
end

function DarkEquipMenu:getCurrentItemType()
    if self.selected_slot == 1 then
        return "weapons"
    elseif self.selected_slot == 2 and self.party:getSelected().id == "jamm" then
		return "ammo"
	else
        return "armors"
    end
end

function DarkEquipMenu:getEquipPreview()
    local party = self.party:getSelected()
    local equipped = {}
    local item = self:getSelectedItem()
    if self.selected_slot == 1 then
        equipped[1] = item
    else
        equipped[1] = party.equipped.weapon
    end
	if party.id == "jamm" then
		if self.selected_slot == 2 then
			equipped[2] = item
		else
			equipped[2] = party.equipped.ammo
		end
		if self.selected_slot == 3 then
			equipped[3] = item
		else
			equipped[3] = party.equipped.armor[1]
		end
	else
		for i = 1, 2 do
			if self.selected_slot == i + 1 then
				equipped[i + 1] = item
			else
				equipped[i + 1] = party.equipped.armor[i]
			end
		end
	end
    return equipped
end

function DarkEquipMenu:draw()
    love.graphics.setFont(self.font)

    Draw.setColor(PALETTE["world_border"])
    love.graphics.rectangle("fill", 188, -24, 6, 139)
    love.graphics.rectangle("fill", -24, 109, 58, 6)
    love.graphics.rectangle("fill", 130, 109, 160, 6)
    love.graphics.rectangle("fill", 422, 109, 79, 6)
    love.graphics.rectangle("fill", 241, 109, 6, 192)

    Draw.setColor(1, 1, 1, 1)
    Draw.draw(self.caption_sprites["char"], 36, -26, 0, 2, 2)
    Draw.draw(self.caption_sprites["equipped"], 294, -26, 0, 2, 2)
    Draw.draw(self.caption_sprites["stats"], 34, 104, 0, 2, 2)
    if self.selected_slot == 1 then
        Draw.draw(self.caption_sprites["weapons"], 290, 104, 0, 2, 2)
    elseif self.selected_slot == 2 and self.party:getSelected().id == "jamm" then
		Draw.draw(self.caption_sprites["ammo"], 290, 104, 0, 2, 2)
	else
        Draw.draw(self.caption_sprites["armors"], 290, 104, 0, 2, 2)
    end

    self:drawChar()
    self:drawEquipped()
    self:drawItems()
    self:drawStats()
	
    Object.draw(self)
end

function DarkEquipMenu:drawItems()
    local type = self:getCurrentItemType()
    local party = self.party:getSelected()
    local items = Game.inventory:getStorage(type)
	
	if party.id == "jamm" then
		local x, y = 282, 124

		local scroll = self.item_scroll[type]
		for i = scroll, math.min(items.max, scroll + 5) do
			local item = items[i]
			local offset = i - scroll

			if item then
				local usable = false
				if self.selected_slot == 1 then
					usable = party:canEquip(item, "weapon", self.selected_slot)
				elseif self.selected_slot == 2 then
					usable = party:canEquip(item, "ammo", 2)
				else
					usable = party:canEquip(item, "armor", 1)
				end
				if usable then
					Draw.setColor(1, 1, 1)
				else
					Draw.setColor(0.5, 0.5, 0.5)
				end
				if item:getEquipIcon() and Assets.getTexture(item:getEquipIcon()) then
					Draw.draw(Assets.getTexture(item:getEquipIcon()), x, y + (offset * 27), 0, 2, 2)
				end
				love.graphics.print(item:getName(), x + 20, y + (offset * 27) - 6)
			else
				Draw.setColor(0.25, 0.25, 0.25)
				love.graphics.print("---------", x + 20, y + (offset * 27) - 6)
			end
		end

		if self.state == "ITEMS" then
			Draw.setColor(Game:getSoulColor())
			Draw.draw(self.heart_sprite, x - 20, y + 4 + ((self.selected_item[type] - scroll) * 27))

			if items.max > 6 then
				Draw.setColor(1, 1, 1)
				local sine_off = math.sin((Kristal.getTime() * 30) / 12) * 3
				if scroll + 6 <= items.max then
					Draw.draw(self.arrow_sprite, x + 187, y + 149 + sine_off)
				end
				if scroll > 1 then
					Draw.draw(self.arrow_sprite, x + 187, y + 14 - sine_off, 0, 1, -1)
				end
			end
			if items.max <= 12 then
				Draw.setColor(1, 1, 1)
				for i = 1, items.max do
					local item = items[i]
					local percentage = (i - 1) / (items.max - 1)
					if self.selected_item[type] == i and item then
						love.graphics.rectangle("fill", x + 188, y + 21 + percentage * 110, 10, 10)
					elseif self.selected_item[type] == i then
						love.graphics.rectangle("fill", x + 189, y + 22 + percentage * 110, 8, 8)
					elseif item then
						love.graphics.rectangle("fill", x + 191, y + 24 + percentage * 110, 4, 4)
					else
						love.graphics.rectangle("fill", x + 192, y + 25 + percentage * 110, 2, 2)
					end
				end
			else
				Draw.setColor(0.25, 0.25, 0.25)
				love.graphics.rectangle("fill", x + 191, y + 24, 6, 119)
				local percent = (scroll - 1) / (items.max - 6)
				Draw.setColor(1, 1, 1)
				love.graphics.rectangle("fill", x + 191, y + 24 + math.floor(percent * (119 - 6)), 6, 6)
			end
		end
		return
	end
	
	super.drawItems(self)
end

function DarkEquipMenu:drawEquipped()
    local party = self.party:getSelected()
    Draw.setColor(1, 1, 1, 1)

    if self.state ~= "SLOTS" or self.selected_slot ~= 1 then
        local weapon_icon = Assets.getTexture(party:getWeaponIcon())
        if weapon_icon then
            Draw.draw(weapon_icon, 220, -4, 0, 2, 2)
        end
    end
	
	if party.id == "jamm" then
		if self.state ~= "SLOTS" or self.selected_slot ~= 2 then Draw.draw(self.ammo_icon, 220, 30, 0, 2, 2) end
		if self.state ~= "SLOTS" or self.selected_slot ~= 3 then Draw.draw(self.armor_icons[1], 220, 60, 0, 2, 2) end
	else
		if self.state ~= "SLOTS" or self.selected_slot ~= 2 then Draw.draw(self.armor_icons[1], 220, 30, 0, 2, 2) end
		if self.state ~= "SLOTS" or self.selected_slot ~= 3 then Draw.draw(self.armor_icons[2], 220, 60, 0, 2, 2) end
	end

    if self.state == "SLOTS" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, 226, 10 + ((self.selected_slot - 1) * 30))
    end

    for i = 1, 3 do
        self:drawEquippedItem(i, 261, 6 + ((i - 1) * 30))
    end
end

function DarkEquipMenu:drawEquippedItem(index, x, y)
    local party = self.party:getSelected()
    local item
    if index == 1 then
        item = party:getWeapon()
    else
		if party.id == "jamm" then
			if index == 2 then
				item = party:getAmmo()
			else
				item = party:getArmor(1)
			end
		else
			item = party:getArmor(index - 1)
		end
    end
    if item then
        Draw.setColor(1, 1, 1)
        if item:getEquipIcon() and Assets.getTexture(item:getEquipIcon()) then
            Draw.draw(Assets.getTexture(item:getEquipIcon()), x, y, 0, 2, 2)
        end
        love.graphics.print(item:getName(), x + 22, y - 6)
    else
        Draw.setColor(PALETTE["world_dark_gray"])
        love.graphics.print("(Nothing)", x + 22, y - 6)
    end
end

function DarkEquipMenu:updateDescription()
    if self.state == "SLOTS" and self.party:getSelected().id == "jamm" then
        local party = self.party:getSelected()
        local item
        if self.selected_slot == 1 then
            item = party:getWeapon()
        elseif self.selected_slot == 2 then
            item = party:getAmmo()
        else
            item = party:getArmor(1)
        end
        Game.world.menu:setDescription(item and item:getDescription() or "", true)
		return
    end
	
	super.updateDescription(self)
end

function DarkEquipMenu:update()
	if self.state == "ITEMS" and self.party:getSelected().id == "jamm" then
        if Input.pressed("cancel") then
            self.state = "SLOTS"

            self.ui_cancel_small:stop()
            self.ui_cancel_small:play()

            self:updateDescription()
            return
        end
        local type = self:getCurrentItemType()
        local max_items = self:getMaxItems()
        local old_selected = self.selected_item[type]
        if Input.pressed("up", true) then
            self.selected_item[type] = self.selected_item[type] - 1
        end
        if Input.pressed("down", true) then
            self.selected_item[type] = self.selected_item[type] + 1
        end
        self.selected_item[type] = MathUtils.clamp(self.selected_item[type], 1, max_items)
        if self.selected_item[type] ~= old_selected then
            local min_scroll = math.max(1, self.selected_item[type] - 5)
            local max_scroll = math.min(math.max(1, max_items - 5), self.selected_item[type])
            self.item_scroll[type] = MathUtils.clamp(self.item_scroll[type], min_scroll, max_scroll)

            self.ui_move:stop()
            self.ui_move:play()

            self:updateDescription()
        end
        if Input.pressed("confirm") then
            self:react()
            local item, party = self:getSelectedItem(), self.party:getSelected()
            if not self:canEquipSelected() then
                self.ui_cant_select:stop()
                self.ui_cant_select:play()
            else
                local swap_with
				
				if self.selected_slot == 1 then
					swap_with = party:getWeapon()
				elseif self.selected_slot == 2 then
					swap_with = party:getAmmo()
				else
					swap_with = party:getArmor(1)
				end

                local can_continue = true

                if item and (not item:onEquip(party, swap_with)) then can_continue = false end
                if swap_with and (not swap_with:onUnequip(party, item)) then can_continue = false end
                if (not party:onEquip(item, swap_with)) then can_continue = false end
                if (not party:onUnequip(swap_with, item)) then can_continue = false end

                -- If one of the functions returned false, don't continue

                if (not can_continue) then
                    self.ui_cant_select:stop()
                    self.ui_cant_select:play()
                    return
                end

                Assets.playSound("equip")

                if self.selected_slot == 1 then
                    party:setWeapon(item)
                elseif self.selected_slot == 2 then
                    party:setAmmo(item)
                else
                    party:setArmor(1, item)
                end

                Game.inventory:setItem(self:getCurrentStorage(), self.selected_item[type], swap_with)

                self.state = "SLOTS"
                self:updateDescription()
            end
        end
		return
    end
	
	super.update(self)
end

return DarkEquipMenu
