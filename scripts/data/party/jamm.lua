local character, super = Class(PartyMember, "jamm")

function character:init()
    super.init(self)

    self.name = "Jamm"
	
	self.assist_name = "Marcy"
	self.assist_path = "battle/assist/marcy"

    self:setActor("jamm")
    self:setLightActor("jamm_lw")
    self:setDarkTransitionActor("jamm_dark_transition")

    self.level = Game.chapter
    self.title = "Slingshotter\nTakes aim, then\nfires."

    self.soul_priority = 1
    self.soul_color = {1, 106/255, 0}

    self.has_act = false
    self.has_spells = true

    self.has_xact = true
    self.xact_name = "J-Action"
	
    self.lw_portrait = "face/jamm/neutral"

    self:addSpell("darksling")
    self:addSpell("numbshot")

    self.health = 215
	self.assist_health = 50
    self.stats = {
        health = 215,
		assist_health = 50,
        attack = 15,
        defense = 4,
        magic = 7
    }

    self.max_stats = {
        health = 315,
		assist_health = 100,
        attack = 18,
        defense = 6,
        magic = 10
    }

    self.weapon_icon = "ui/menu/equip/sling"
	
	self.equipped["ammo"] = nil

    self:setWeapon("basic_sling")
    self:setAmmo("rubber_pellet")

    self.lw_weapon_default = "light/rope_sling"
    self.lw_armor_default = "light/bandage"

    self.color = {1, 0.625, 0.25}
    self.dmg_color = ColorUtils.hexToRGB("#FFB366")
    self.attack_bar_color = ColorUtils.hexToRGB("#DB9F11FF")
    self.attack_box_color = {0.5, 0.5, 0}
    self.xact_color = ColorUtils.hexToRGB("#FFBF7FFF")
	-- highlight color A
    self.highlight_color = ColorUtils.hexToRGB("#DB9F11FF")
		-- highlight color B
    self.highlight_color_alt = ColorUtils.hexToRGB("#D6184DFF")
	self.assist_color = {0, 1, 1}

    self.menu_icon = "party/jamm/head"
    self.head_icons = "party/jamm/icon"
    self.name_sprite = "party/jamm/name"
	
	if Game:getFlag("marcy_joined") then
		self:setActor("jammarcy")
		self:setLightActor("jammarcy_light")
		self:setDarkTransitionActor("jammarcy_dark_transition")
		self.menu_icon = "party/jamm/withmarcy/head"
	end

    self.attack_sprite = "effects/attack/sling"
    self.attack_sound = "sling"
    self.attack_pitch = 1

    self.battle_offset = {2, 1}
    self.head_icon_offset = {0, -3}
    self.menu_icon_offset = nil
	
	self.flee_text = {
		"[voice:jamm][facec:jamm/nervous]Nope! I'm out!"
	}
end

function PartyMember:saveEquipment()
    local result = { weapon = nil, ammo = nil, armor = {} }
    if self.equipped.weapon then
        result.weapon = self.equipped.weapon:save()
    end
    if self.equipped.ammo then
        result.ammo = self.equipped.ammo:save()
    end
    for i = 1, 2 do
        if self.equipped.armor[i] then
            result.armor[tostring(i)] = self.equipped.armor[i]:save()
        end
    end
    return result
end

function character:loadEquipment(data)
    self:setWeapon(nil)
    if data.weapon then
        if type(data.weapon) == "table" then
            if Registry.getItem(data.weapon.id) then
                local weapon = Registry.createItem(data.weapon.id)
                if weapon then
                    weapon:load(data.weapon)
                    self:setWeapon(weapon)
                else
                    Logging.errorNotify("Could not load weapon \"" .. data.weapon.id .. "\"")
                end
            else
                Logging.errorNotify("Could not load weapon \"" .. data.weapon.id .. "\"")
            end
        else
            if Registry.getItem(data.weapon) then
                self:setWeapon(data.weapon)
            else
                Logging.errorNotify("Could not load weapon \"" .. (data.weapon or "nil") .. "\"")
            end
        end
    end
    self:setAmmo(nil)
    if data.ammo then
        if type(data.ammo) == "table" then
            if Registry.getItem(data.ammo.id) then
                local ammo = Registry.createItem(data.ammo.id)
                if ammo then
                    ammo:load(data.ammo)
                    self:setAmmo(ammo)
                else
                    Logging.errorNotify("Could not load ammo \"" .. data.ammo.id .. "\"")
                end
            else
                Logging.errorNotify("Could not load ammo \"" .. data.ammo.id .. "\"")
            end
        else
            if Registry.getItem(data.ammo) then
                self:setAmmo(data.ammo)
            else
                Logging.errorNotify("Could not load ammo \"" .. (data.ammo or "nil") .. "\"")
            end
        end
    end
    for i = 1, 2 do
        self:setArmor(i, nil)
    end
    if data.armor then
        for k, v in pairs(data.armor) do
            if type(v) == "table" then
                if Registry.getItem(v.id) then
                    local armor = Registry.createItem(v.id)
                    if armor then
                        armor:load(v)
                        self:setArmor(tonumber(k), armor)
                    else
                        Logging.errorNotify("Could not load armor \"" .. v.id .. "\"")
                    end
                else
                    Logging.errorNotify("Could not load armor \"" .. v.id .. "\"")
                end
            else
                if Registry.getItem(v) then
                    self:setArmor(tonumber(k), v)
                else
                    Logging.errorNotify("Could not load armor \"" .. (v or "nil") .. "\"")
                end
            end
        end
    end
end

function character:getAmmo()
    return self.equipped.ammo
end

function character:setAmmo(item)
    if type(item) == "string" then
        item = Registry.createItem(item)
    end
    self.equipped.ammo = item
end

function character:checkAmmo(id)
    return self:getAmmo() and self:getAmmo().id == id or false
end

function character:canEquip(item, slot_type, slot_index)
    if item then
        return item:canEquip(self, slot_type, slot_index)
    else
        return (slot_type ~= "weapon") and (slot_type ~= "ammo")
    end
end

function character:getEquipment()
    local result = {}
    if self.equipped.weapon then
        table.insert(result, self.equipped.weapon)
    end
    if self.equipped.ammo then
        table.insert(result, self.equipped.ammo)
    end
    if self.equipped.armor[1] then
        table.insert(result, self.equipped.armor[1])
    end
    return result
end

function character:onTurnStart(battler)
	if self.stun then
		Game.battle:pushForcedAction(battler, "SKIP")
	end
end

function character:onLevelUp(level)
    self:increaseStat("health", 2)
    self:increaseStat("assist_health", 1)
    if level % 10 == 0 then
        self:increaseStat("attack", 1)
    end
end

function character:drawPowerStat(index, x, y, menu)
    if index == 1  then
        local icon = Assets.getTexture("ui/menu/icon/demon")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Skills", x, y, 0, 0.7, 1)
        love.graphics.print("Yes", x+130, y)
        return true
    elseif index == 2 then
        local icon = Assets.getTexture("ui/menu/icon/magic")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Father", x, y)
        love.graphics.print("Yes", x+130, y, 0)
        return true
    elseif index == 3 then
        local icon = Assets.getTexture("ui/menu/icon/fire")
        love.graphics.draw(icon, x-26, y+6, 0, 2, 2)
        love.graphics.print("Guts:", x, y)

        love.graphics.draw(icon, x+90, y+6, 0, 2, 2)
        love.graphics.print("x", x+111, y)
        love.graphics.print("∞", x+122, y+3)
        
        return true
    end
end

function character:getFleeText()
	if Game:getFlag("marcy_joined") then
		return {
			"[voice:jamm][facec:jamm/nervous]Nope! I'm out!",
			"[voice:marcy][facec:marcy/frown_open]Marcy thinks we should go!"
		}
	end
	return self.flee_text
end

function character:hasAssist() return Game:getFlag("marcy_joined") end

-- function character:getMinimemberID()
    -- if Game:getFlag("marcy_joined") then
        -- return "marcy"
    -- end
    -- return super.getMinimemberID(self)
-- end

function character:getGameOverMessage(main)
    return {
        "Hey, I believe we\ncan do this.",
        main:getName()..",[wait:5]\nlet's try again!"
    }
end

function character:heal(amount, playsound)
    if not self:hasAssist() then return super.heal(self, amount, playsound) end
	if self.health <= 0 then return super.heal(self, amount, playsound) end
	
	if self.assist_health < self:getStat("assist_health") then
		local missing = self:getStat("assist_health") - self:getAssistHealth()
		
		if missing == amount then
			if playsound == nil or playsound then
				Assets.stopAndPlaySound("power")
			end
			self:setAssistHealth(math.min(math.max(self:getStat("assist_health"), self:getAssistHealth()), self:getAssistHealth() + amount))
			return (self:getStat("health") <= self:getHealth()) and (self:getStat("assist_health") <= self:getAssistHealth())
		elseif missing ~= 0 then
			amount = amount - missing
			self:setAssistHealth(self:getStat("assist_health"))
		end
	end
	return super.heal(self, amount, playsound)
end

function character:drawHealth(ui, index)
    super.drawHealth(self, ui, index)
    if self:hasAssist() then
            local col = math.floor((index - 4) / 11)
        local row = (index - 4) % 11

        local x_head  = MathUtils.rangeMap(ui.y, -80, 0, -100, 20  + col * 150)
        local x_bar   = MathUtils.rangeMap(ui.y, -80, 0, -100, 60  + col * 150)
        local x_text  = MathUtils.rangeMap(ui.y, -80, 0, -100, 60  + col * 150)
        local y_pos   = 90 + 30 * row

        local health = (self:getAssistHealth() / self:getStat("assist_health")) * 50
        Draw.setColor(PALETTE["action_health_bg"])
        Draw.rectangle("fill", x_bar+50, y_pos + 17, 50, 10)
        
        Draw.setColor(self.assist_color)
        Draw.rectangle("fill", x_bar+50, y_pos + 17, math.ceil(health), 10)
            local color
        
            Draw.setColor(COLORS.black)
            for x = -1, 1 do
                for y = -1, 1 do
                    love.graphics.print(self:getAssistHealth().."/"..self:getStat("assist_health"), x_text + x, y_pos + y+17)
                end
            end
            if (self:getAssistHealth() <= (self:getStat("assist_health") / 4)) then
                color = PALETTE["action_health_text_low"]
            else
                color = PALETTE["action_health_text"]
            end
            love.graphics.print(self:getAssistHealth().."/"..self:getStat("assist_health"), x_text, y_pos + 17)
            Draw.setColor(color)
            love.graphics.print(self:getAssistHealth().."/"..self:getStat("assist_health"), x_text, y_pos+17)
        return
    end
end

return character
