---@class DarkMenu : Object
---@overload fun(...) : DarkMenu
local DarkMenu, super = HookSystem.hookScript(DarkMenu)

function DarkMenu:init()
    super.init(self, 0, -80)
	self.shard_sprite = Assets.getTexture("ui/menu/icon/shard")
end

function DarkMenu:draw()
    Draw.setColor(PALETTE["world_fill"])
    love.graphics.rectangle("fill", 0, 0, 640, 80)

    Draw.setColor(1, 1, 1, 1)
    if self.buttons[self.selected_submenu].desc_sprite then
        Draw.draw(self.buttons[self.selected_submenu].desc_sprite, 20, 24, 0, 2, 2)
    end

    for i = 1, #self.buttons do
        self:drawButton(i, 120 + ((i - 1) * self:getButtonSpacing()), 20)
    end
    Draw.setColor(1, 1, 1)
	
    love.graphics.setFont(self.font)
    love.graphics.print(Game:getConfig("darkCurrencyShort") .. " " .. Game.money, 520, 10)
    Draw.draw(self.shard_sprite, 520, 46, 0, 2, 2)
	local shards = tostring(Mod:getDarkShardCount())
    love.graphics.print(shards, 554, 41)
	
    super.super.draw(self)
	
    if self.box then return end --scary
end

function DarkMenu:onKeyPressed(key)
    if self.state == "MAIN" then
		if self.box then
			if self.box.onKeyPressed then
				self.box:onKeyPressed(key)
			end
		end

		if (Input.isMenu(key) or Input.isCancel(key)) then
			Game.world:closeMenu()
			return
		end

		if not self.animation_done then return end

        local old_selected = self.selected_submenu
		local select_direction = 0
        if Input.is("left", key)  then select_direction = -1 end
        if Input.is("right", key) then select_direction = 1 end
		self.selected_submenu = self.selected_submenu + select_direction
        if self.selected_submenu < 1             then self.selected_submenu = #self.buttons end
        if self.selected_submenu > #self.buttons then self.selected_submenu = 1             end
		local button_disabled = false
		if (type(self.buttons[self.selected_submenu].disabled) == "function") then
			button_disabled = self.buttons[self.selected_submenu].disabled()
		else
			button_disabled = self.buttons[self.selected_submenu].disabled
		end
		while (self.buttons[self.selected_submenu] and button_disabled) do
			self.selected_submenu = self.selected_submenu + select_direction
			if self.selected_submenu < 1             then self.selected_submenu = #self.buttons end
			if self.selected_submenu > #self.buttons then self.selected_submenu = 1             end
			button_disabled = false
			if (type(self.buttons[self.selected_submenu].disabled) == "function") then
				button_disabled = self.buttons[self.selected_submenu].disabled()
			else
				button_disabled = self.buttons[self.selected_submenu].disabled
			end
		end
        if old_selected ~= self.selected_submenu then
            self.ui_move:stop()
            self.ui_move:play()
        end
        if Input.isConfirm(key) then
            self:onButtonSelect(self.selected_submenu)
        end
    else
		super.onKeyPressed(self, key)
    end
end

function DarkMenu:getButtonSpacing()
    if #self.buttons <= 4 then
        return 105
    else
        return 105 - (#self.buttons * #self.buttons)
    end
end

function DarkMenu:drawButton(index, x, y)
    local button = self.buttons[index]
    local sprite = button.sprite
    if index == self.selected_submenu then
        sprite = button.hovered_sprite
    end	
	local button_disabled = false
	if (type(button.disabled) == "function") then
		button_disabled = button.disabled()
	else
		button_disabled = button.disabled
	end
    if button_disabled then
        sprite = button.disabled_sprite
    end
    Draw.setColor(1, 1, 1)
    Draw.draw(sprite, x, y, 0, 2, 2)
    if index == self.selected_submenu and self.state == "MAIN" then
        Draw.setColor(Game:getSoulColor())
        Draw.draw(self.heart_sprite, x + 15, y + 25, 0, 2, 2, self.heart_sprite:getWidth() / 2, self.heart_sprite:getHeight() / 2)
    end
end

function DarkMenu:addButtons()
    -- ITEM
    self:addButton({
        ["state"]          = "ITEMMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/item"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/item_h"),
        ["disabled_sprite"]= Assets.getTexture("ui/menu/btn/item"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/item"),
        ["callback"]       = function()
            self.box = DarkItemMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end,
		["disabled"]       = false
    })

    -- EQUIP
    self:addButton({
        ["state"]          = "EQUIPMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/equip"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/equip_h"),
        ["disabled_sprite"]= Assets.getTexture("ui/menu/btn/equip"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/equip"),
        ["callback"]       = function()
            self.box = DarkEquipMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end,
		["disabled"]       = false
    })

    -- POWER
    self:addButton({
        ["state"]          = "POWERMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/power"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/power_h"),
        ["disabled_sprite"]= Assets.getTexture("ui/menu/btn/power"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/power"),
        ["callback"]       = function()
            self.box = DarkPowerMenu()
            self.box.layer = 1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end,
		["disabled"]       = false
    })
    
    -- TRAVEL
	if Game:getFlag("unlock_travel") then
		self:addButton({
			["state"]          = "TRAVEL",
			["sprite"]         = Assets.getTexture("ui/menu/btn/sanctum"),
			["hovered_sprite"] = Assets.getTexture("ui/menu/btn/sanctum_h"),
			["disabled_sprite"]= Assets.getTexture("ui/menu/btn/sanctum_d"),
			["desc_sprite"]    = Assets.getTexture("ui/menu/desc/sanctum"),
			["callback"]       = function()
				Input.clear("confirm")
				Game.world:closeMenu()

				self.ui_select:stop()
				self.ui_select:play()

				Game.world:startCutscene("travel_button")
			end,
			["disabled"]       = function() 
				if Game.world.map.id == "sanctum_hell/hell_1" or 
				Game.world.map.id == "sanctum_hell/hell_unknown" or 
				Game.world.map.id == "secrets/frisk_room" or
                Game:getFlag("disable_travel", false) or
				StringUtils.contains(Game.world.map.id, "final_sanctuary") then
					return true
				end
				return false
			end
		})
	end

    -- CONFIG
    self:addButton({
        ["state"]          = "CONFIGMENU",
        ["sprite"]         = Assets.getTexture("ui/menu/btn/config"),
        ["hovered_sprite"] = Assets.getTexture("ui/menu/btn/config_h"),
        ["disabled_sprite"]= Assets.getTexture("ui/menu/btn/config"),
        ["desc_sprite"]    = Assets.getTexture("ui/menu/desc/config"),
        ["callback"]       = function()
            self.box = DarkConfigMenu()
            self.box.layer = -1
            self:addChild(self.box)

            self.ui_select:stop()
            self.ui_select:play()
        end,
		["disabled"]       = false
    })
end

return DarkMenu
