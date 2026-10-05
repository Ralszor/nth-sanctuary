local PartyBattler, super = HookSystem.hookScript(PartyBattler)

function PartyBattler:hurt(amount, exact, color, options)
    local success, amount_armor = self.chara:checkArmor("master_medallion")
	
	if success then
		amount = 99999
		
		if amount_armor == 2 then
			options["swoon"] = true
		end
	end
	
	if self.chara:hasAssist() then
		if self.chara:getHealth() > 0 and self.chara:getAssistHealth() > 0 then
			local assist_amount = math.floor(amount/3)
			
			self:hurtAssist(assist_amount, exact, color, options)
		elseif self.chara:getAssistHealth() > 0 then
			self:hurtAssist(amount, exact, color, options)
			return
		end
	end
	
	super.hurt(self, amount, exact, color, options)

    if StringUtils.contains(self.chara.id, "cuptain") and self.chara.health < 0 then
        Game.battle.timer:script(function (wait)
            for k, enemies in ipairs(Game.battle.enemies) do
                if enemies.current_target == self.chara.id then
                    enemies.current_target = Game.party[1].id
                end
            end

            for i, battler in ipairs(Game.party) do
                if Game.party[i] == self.chara.id then
                    table.remove(Game.world.followers, i-1)
                    break
                end
            end

            Assets.playSound("smallcar_yelp")
            Assets.playSound("bump", 2, 1)
            self.chara:addFlag("recruited", 1)
            self.physics.gravity = 0.8
            self.physics.speed_x = -6
            self.physics.speed_y = -1
            
            self.graphics.spin = -0.1
        end)
    end
end

function PartyBattler:update()
    super.update(self)
    for i, battler in ipairs(Game.party) do
        if battler.id == self.chara.id and self.y > SCREEN_HEIGHT and StringUtils.contains(self.chara.id, "cuptain") and self.chara.health < 0 then
            Mod.libs["midbattleparty"]:removePartyBattler(i)
            table.remove(Game.party, i)
            self.chara.health = self.chara:getStat("health")
            self:remove()
        end
    end
end

function PartyBattler:removeAssistHealth(amount, swoon)
    if (self.chara:getAssistHealth() <= 0) then
        amount = MathUtils.round(amount / 4)
        self.chara:setAssistHealth(self.chara:getAssistHealth() - amount)
    else
        self.chara:setAssistHealth(self.chara:getAssistHealth() - amount)
        if (self.chara:getAssistHealth() <= 0) then
            if swoon then
                self.chara:setAssistHealth(-999)
            else
                amount = math.abs((self.chara:getAssistHealth() - (self.chara:getStat("assist_health") / 2)))
                self.chara:setAssistHealth(MathUtils.round(((-self.chara:getStat("assist_health")) / 2)))
            end
        end
    end
    self:checkHealth(swoon)
end

function PartyBattler:removeHealthBroken(amount, swoon)
    self.chara:setAssistHealth(self.chara:getAssistHealth() - amount)
    if (self.chara:getAssistHealth() <= 0) then
        if swoon then
            self.chara:setAssistHealth(-999)
        else
            -- BUG: Use Kris' max health...
            self.chara:setAssistHealth(MathUtils.round(((-Game.party[1]:getStat("assist_health")) / 2)))
        end
    end
    self:checkHealth(swoon)
end

function PartyBattler:hurtAssist(amount, exact, color, options)
    options = options or {}

    local swoon = options["swoon"]

    if not options["all"] then
        Assets.playSound("hurt")
        if not exact then
            amount = self:calculateDamage(amount)
            -- don't bother with elements or armor
			if self.defending then
                amount = math.ceil((2 * amount) / 3)
            end
        end
        for _, item in ipairs(self.chara:getEquipment()) do
            amount = item:onBattleDamage(amount, swoon, false) or amount
        end

        self:removeAssistHealth(amount, swoon)
    else
        -- We're targeting everyone.
        if not exact then
            amount = self:calculateDamage(amount)
            -- don't bother with elements or armor
			if self.defending then
                amount = math.ceil((3 * amount) / 4) -- Slightly different than the above
            end
        end
        for _, item in ipairs(self.chara:getEquipment()) do
            amount = item:onBattleDamage(amount, swoon, false) or amount
        end

        self:removeAssistHealthBroken(amount, swoon) -- Use a separate function for cleanliness
    end

	local s
    if (self.chara:getHealth() <= 0) then
        s = self:statusMessage("msg", swoon and "swoon" or "down", color, true)
    else
        s = self:statusMessage("damage", amount, color, true)
    end
	s:setScale(s.scale_x / 2, s.scale_y / 2)
	s.y = s.y - 32

    -- self.hurt_timer = 0
    Game.battle:shakeCamera(4)

    -- if (not self.defending) and (not self.is_down) then
        -- self.sleeping = false
        -- self.hurting = true
        -- self:toggleOverlay(true)
        -- self.overlay_sprite:setAnimation("battle/hurt", function()
            -- if self.hurting then
                -- self.hurting = false
                -- self:toggleOverlay(false)
            -- end
        -- end)
        -- if not self.overlay_sprite.anim_frames then -- backup if the ID doesn't animate, so it doesn't get stuck with the hurt animation
            -- Game.battle.timer:after(0.5, function()
                -- if self.hurting then
                    -- self.hurting = false
                    -- self:toggleOverlay(false)
                -- end
            -- end)
        -- end
    -- end
end

function PartyBattler:swoonAssist()
    -- self.is_down = true
    -- self.hurting = false
    -- self:toggleOverlay(true)
    -- self.overlay_sprite:setAnimation("battle/swooned")
    -- if self.action then
        -- Game.battle:removeAction(Game.battle:getPartyIndex(self.chara.id), true)
    -- end
end

function PartyBattler:downAssist()
    -- self.is_down = true
    -- self.hurting = false
    -- self:toggleOverlay(true)
    -- self.overlay_sprite:setAnimation("battle/defeat")
    -- if self.action then
        -- Game.battle:removeAction(Game.battle:getPartyIndex(self.chara.id), true)
    -- end
end

function PartyBattler:healAssist(amount, sparkle_color, show_up, playsound)
    amount = math.floor(amount)

    local max_hp = self.chara:healAssist(amount, playsound)

    local was_down = self.is_down
    self:checkHealth(false)

    if max_hp then
        self:statusMessage("msg", "max", nil, nil, 8)
    else
        if show_up and was_down ~= self.is_down then
            self:statusMessage("msg", "up", nil, nil, 1)
        else
            self:statusMessage("heal", amount, { 0, 1, 0 }, nil, show_up and 1 or 8)
        end
    end

    if not show_up then
        self:healEffect(unpack(sparkle_color or {}))
    end
end

function PartyBattler:heal(amount, sparkle_color, show_up, playsound)
	if self.smitten then
		self:statusMessage("msg", "miss")
		return
	end
	
	super.heal(self, amount, sparkle_color, show_up, playsound)
end

function PartyBattler:swoon()
	self.smitten = true
	super.swoon(self)
end

return PartyBattler