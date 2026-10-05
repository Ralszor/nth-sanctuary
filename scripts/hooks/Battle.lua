local Battle, super = HookSystem.hookScript(Battle)

function Battle:init()
    super.init(self)
	self.state_extra_type = nil
end

function Battle:createUI()
	super.createUI(self)
    self.battle_ui_above = self:addChild(BattleUIDrawAbove())
end

function Battle:createPartyBattlers()
    for i = 1, #Game.party do
        local party_member = Game.party[i]

        if Game.world.player and Game.world.player.visible and Game.world.player.actor.id == party_member:getActor().id then
            -- Create the player battler
            local player_x, player_y = Game.world.player:getScreenPos()
            local player_battler = PartyBattler(party_member, player_x, player_y)
            player_battler:setAnimation("battle/transition")
			if Game:getFlag("imbued_battle_fading", false) then
				player_battler:addFX(AlphaFX(0), "battle_transition_fade")
			end
            self:addChild(player_battler)
            table.insert(self.party, player_battler)
            table.insert(self.party_beginning_positions, { player_x, player_y })
            self.party_world_characters[party_member.id] = Game.world.player

            Game.world.player.visible = false
        else
            local found = false
            for _, follower in ipairs(Game.world.followers) do
                if follower.visible and follower.actor.id == party_member:getActor().id then
                    local chara_x, chara_y = follower:getScreenPos()
                    local chara_battler = PartyBattler(party_member, chara_x, chara_y)
                    chara_battler:setAnimation("battle/transition")
					if Game:getFlag("imbued_battle_fading", false) then
						chara_battler:addFX(AlphaFX(0), "battle_transition_fade")
					end
                    self:addChild(chara_battler)
                    table.insert(self.party, chara_battler)
                    table.insert(self.party_beginning_positions, { chara_x, chara_y })
                    self.party_world_characters[party_member.id] = follower

                    follower.visible = false

                    found = true
                    break
                end
            end
            if not found then
                local chara_battler = PartyBattler(party_member, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
                chara_battler:setAnimation("battle/transition")
				if Game:getFlag("imbued_battle_fading", false) then
					chara_battler:addFX(AlphaFX(0), "battle_transition_fade")
                end
				self:addChild(chara_battler)
                table.insert(self.party, chara_battler)
                table.insert(self.party_beginning_positions, { chara_battler.x, chara_battler.y })
            end
        end
    end
end

function Battle:updateTransition()
    while self.afterimage_count < math.floor(self.transition_timer) do
        for index, battler in ipairs(self.party) do
            local target_x, target_y = unpack(self.battler_targets[index])

            local battler_x = battler.x
            local battler_y = battler.y

            battler.x = MathUtils.lerp(self.party_beginning_positions[index][1], target_x, (self.afterimage_count + 1) / 10)
            battler.y = MathUtils.lerp(self.party_beginning_positions[index][2], target_y, (self.afterimage_count + 1) / 10)

			if Game:getFlag("imbued_battle_fading", false) then
				local afterimage = AfterImage(battler, self.transition_timer/20)
				self:addChild(afterimage)
			else
				local afterimage = AfterImage(battler, 0.5)
				self:addChild(afterimage)			
			end

            battler.x = battler_x
            battler.y = battler_y
			if Game:getFlag("imbued_battle_fading", false) then
				local fade = battler:getFX("battle_transition_fade")
				fade.alpha = self.transition_timer/10
			end
        end
        self.afterimage_count = self.afterimage_count + 1
    end

    self.transition_timer = self.transition_timer + 1 * DTMULT

    if self.transition_timer >= 10 then
        self.transition_timer = 10
        self:setState("INTRO")
    end

    for index, battler in ipairs(self.party) do
        local target_x, target_y = unpack(self.battler_targets[index])

        battler.x = MathUtils.lerp(self.party_beginning_positions[index][1], target_x, self.transition_timer / 10)
        battler.y = MathUtils.lerp(self.party_beginning_positions[index][2], target_y, self.transition_timer / 10)
    end
    for _, enemy in ipairs(self.enemies) do
		if Game:getFlag("imbued_battle_fading", false) then
			local fade = enemy:getFX("battle_transition_fade")
            if not fade then
                fade = enemy:addFX(AlphaFX(1), "battle_transition_fade")
            end
			fade.alpha = self.transition_timer/10
			enemy.x = enemy.target_x
			enemy.y = enemy.target_y
		else
			enemy.x = MathUtils.lerp(self.enemy_beginning_positions[enemy][1], enemy.target_x, self.transition_timer / 10)
			enemy.y = MathUtils.lerp(self.enemy_beginning_positions[enemy][2], enemy.target_y, self.transition_timer / 10)
		end
    end
end

function Battle:updateIntro()
    for index, battler in ipairs(self.party) do
		if Game:getFlag("imbued_battle_fading", false) then
			local fade = battler:getFX("battle_transition_fade")
			fade.alpha = 1
		end
	end
    for _, enemy in ipairs(self.enemies) do
		if Game:getFlag("imbued_battle_fading", false) then
			local fade = enemy:getFX("battle_transition_fade")
			fade.alpha = 1
		end
	end
    super.updateIntro(self)
end

function Battle:updateTransitionOut()
    if not self.battle_ui.animation_done then
        return
    end

    if self.background ~= nil and not self.background:isFading() then
        self.background:fadeOut()
    end

    local all_enemies = {}
    TableUtils.merge(all_enemies, self.enemies)
    TableUtils.merge(all_enemies, self.defeated_enemies)

    self.transition_timer = self.transition_timer - DTMULT

    if self.transition_timer <= 0 then--or not self.transitioned then
        local enemies = {}
        for k, v in pairs(self.enemy_world_characters) do
            table.insert(enemies, v)
        end
        self.encounter:onReturnToWorld(enemies)
        self:returnToWorld()
        return
    end

    for index, battler in ipairs(self.party) do
        battler:setAnimation("battle/transition_out")

        local target_x, target_y = unpack(self.battler_targets[index])

        battler.x = MathUtils.lerp(self.party_beginning_positions[index][1], target_x, self.transition_timer / 10)
        battler.y = MathUtils.lerp(self.party_beginning_positions[index][2], target_y, self.transition_timer / 10)
		--[[if Game:getFlag("imbued_battle_fading", false) then
			local fade = battler:getFX("battle_transition_fade")
			fade.alpha = self.transition_timer/10
		end]]
    end

    for _, enemy in ipairs(all_enemies) do
        local world_chara = self.enemy_world_characters[enemy]
        if enemy.target_x and enemy.target_y and not enemy.exit_on_defeat and world_chara and world_chara.parent then
            enemy.x = MathUtils.lerp(self.enemy_beginning_positions[enemy][1], enemy.target_x, self.transition_timer / 10)
            enemy.y = MathUtils.lerp(self.enemy_beginning_positions[enemy][2], enemy.target_y, self.transition_timer / 10)
        else
            local fade = enemy:getFX("battle_end")
            if not fade then
                fade = enemy:addFX(AlphaFX(1), "battle_end")
            end
            fade.alpha = self.transition_timer / 10
        end
    end
end

function Battle:nextTurn()
	super.nextTurn(self)
	
	for _, battler in ipairs(self.party) do
        if battler.chara:hasAssist() and (battler.chara:getAssistHealth() <= 0) and battler.chara:canAutoHeal() and self.encounter:isAutoHealingEnabled(battler) then
            battler:healAssist(battler.chara:autoHealAssistAmount(), nil, true)
        end
    end
end

--- Changes the state of the battle and calls [onStateChange()](lua://Battle.onStateChange)
---@param state  BattleState
---@param reason string?
function Battle:setState(state, reason, extra_type)
    local old = self.state

    local result = self.encounter:beforeStateChange(old, state, reason)
    if result or self.state ~= old then
        return
    end

    self.state = state
    self.state_reason = reason
	self.state_extra_type = extra_type or nil
    self:onStateChange(old, self.state, reason)
end

--- An internal function responsible for adding spells to the battle menu.
function Battle:addSpellMenuItems(battler)
    for _, spell in ipairs(battler.chara:getSpells()) do
        ---@type table|function
        local color = spell.color or { 1, 1, 1, 1 }
        if spell:hasTag("spare_tired") then
            local has_tired = false
            for _, enemy in ipairs(Game.battle:getActiveEnemies()) do
                if enemy.tired then
                    has_tired = true
                    break
                end
            end
            if has_tired then
                color = { 0, 178 / 255, 1, 1 }
                if Game:getConfig("pacifyGlow") then
                    color = function()
                        return ColorUtils.mergeColor({ 0, 0.7, 1, 1 }, COLORS.white, 0.5 + math.sin(Game.battle.pacify_glow_timer / 4) * 0.5)
                    end
                end
            end
        end

        Game.battle:addMenuItem({
            ["name"] = spell:getName(),
            ["tp"] = spell:getTPCost(battler.chara),
            ["unusable"] = not spell:isUsable(battler.chara),
            ["description"] = spell:getBattleDescription(),
            ["party"] = spell.party,
            ["color"] = color,
            ["data"] = spell,
            ["callback"] = function(menu_item)
                Game.battle.selected_spell = menu_item

                if not spell:getTarget() or spell:getTarget() == "none" then
                    Game.battle:pushAction("SPELL", nil, menu_item)
                elseif spell:getTarget() == "ally" then
                    Game.battle:setState("PARTYSELECT", "SPELL", spell.target_state_type or nil)
                elseif spell:getTarget() == "enemy" then
                    Game.battle:setState("ENEMYSELECT", "SPELL", spell.target_state_type or nil)
                elseif spell:getTarget() == "party" then
                    Game.battle:pushAction("SPELL", Game.battle.party, menu_item)
                elseif spell:getTarget() == "enemies" then
                    Game.battle:pushAction("SPELL", Game.battle:getActiveEnemies(), menu_item)
                end
            end
        })
    end
end

function Battle:processAction(action)
    local battler = self.party[action.character_id]
    local party_member = battler.chara
    local enemy = action.target

    self.current_processing_action = action

    local next_enemy = self:retargetEnemy()
    if not next_enemy then
        return true
    end

    if enemy and enemy.done_state then
        enemy = next_enemy
        action.target = next_enemy
    end

    -- Call mod callbacks for onBattleAction to either add new behaviour for an action or override existing behaviour
    -- Note: non-immediate actions require explicit "return false"!
    local callback_result = Kristal.modCall("onBattleAction", action, action.action, battler, enemy)
    if callback_result ~= nil then
        return callback_result
    end
    for lib_id, _ in Kristal.iterLibraries() do
        callback_result = Kristal.libCall(lib_id, "onBattleAction", action, action.action, battler, enemy)
        if callback_result ~= nil then
            return callback_result
        end
    end

    if action.action == "SPARE" then
        local worked = enemy:canSpare()

        local text = enemy:getSpareText(battler, worked)
        if text then
            self:battleText(text)
        end

        battler:setAnimation("battle/spare", function()
            enemy:onMercy(battler)
            if not worked then
                enemy:mercyFlash()
            end
            self:finishAction(action)
        end)

        return false

    elseif action.action == "ATTACK" or action.action == "AUTOATTACK" then
        local attacksound = battler.chara:getWeapon() and battler.chara:getWeapon():getAttackSound(battler, enemy, action.points) or battler.chara:getAttackSound()
        local attackpitch  = battler.chara:getWeapon() and battler.chara:getWeapon():getAttackPitch(battler, enemy, action.points) or battler.chara:getAttackPitch()
        local src = Assets.stopAndPlaySound(attacksound or "laz_c")
        assert(src, "Attempted to play non-existent attack sound \"" .. (attacksound or "laz_c") .. "\" for " .. battler.chara:getName())
        src:setPitch(attackpitch or 1)

        self.actions_done_timer = 1.2

        local crit = action.points == 150 and action.action ~= "AUTOATTACK"
        if crit then
            Assets.stopAndPlaySound("criticalswing")

            for i = 1, 3 do
                local sx, sy = battler:getRelativePos(battler.width, 0)
                local sparkle = Sprite("effects/criticalswing/sparkle", sx + MathUtils.random(50), sy + 30 + MathUtils.random(30))
                sparkle:play(4 / 30, true)
                sparkle:setScale(2)
                sparkle.layer = BATTLE_LAYERS["above_battlers"]
                sparkle.physics.speed_x = MathUtils.random(2, 6)
                sparkle.physics.friction = -0.25
                sparkle:fadeOutSpeedAndRemove()
                self:addChild(sparkle)
            end
        end

        battler:setAnimation("battle/attack")

        self.timer:after(10 / 30, function()
            action.icon = nil

            if action.target and action.target.done_state then
                enemy = self:retargetEnemy()
                action.target = enemy
                if not enemy then
                    self.cancel_attack = true
                    self:finishAction(action)
                    return
                end
            end

            local damage = MathUtils.round(enemy:getAttackDamage(action.damage or 0, battler, action.points or 0))
            if damage < 0 then
                damage = 0
            end

			if (enemy.id == "mad_dummy") and enemy.the_true_fight and action.points > 0 then
                local attacksprite = battler.chara:getWeapon() and battler.chara:getWeapon():getAttackSprite(battler, enemy, action.points) or battler.chara:getAttackSprite()
                local dmg_sprite = Sprite(attacksprite or "effects/attack/cut")
                dmg_sprite:setOrigin(0.5, 0.5)
                if crit then
                    dmg_sprite:setScale(2.5, 2.5)
                else
                    dmg_sprite:setScale(2, 2)
                end
                local relative_pos_x, relative_pos_y = enemy:getRelativePos(enemy.width / 2, enemy.height / 2)
                dmg_sprite:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
                dmg_sprite.layer = enemy.layer + 0.01
                dmg_sprite.battler_id = action.character_id or nil
                table.insert(enemy.dmg_sprites, dmg_sprite)
                local dmg_anim_speed = 1 / 15
                if attacksprite == "effects/attack/shard" then
                    -- Ugly hardcoding BlackShard animation speed accuracy for now
                    dmg_anim_speed = 1 / 10
                end
                dmg_sprite:play(dmg_anim_speed, false, function(s) s:remove(); TableUtils.removeValue(enemy.dmg_sprites, dmg_sprite) end) -- Remove itself and Remove the dmg_sprite from the enemy's dmg_sprite table when its removed
                enemy.parent:addChild(dmg_sprite)

                local sound = enemy:getDamageSound() or "damage"
                if sound and type(sound) == "string" then
                    Assets.stopAndPlaySound(sound)
                end
                enemy:hurt("INEFFECTIVE", battler)

                -- TODO: Call this even if damage is 0, will be a breaking change
                battler.chara:onAttackHit(enemy, 0)
			elseif damage > 0 then
                Game:giveTension(MathUtils.round(enemy:getAttackTension(action.points or 100)))

                local attacksprite = battler.chara:getWeapon() and battler.chara:getWeapon():getAttackSprite(battler, enemy, action.points) or battler.chara:getAttackSprite()
                local dmg_sprite = Sprite(attacksprite or "effects/attack/cut")
                dmg_sprite:setOrigin(0.5, 0.5)
                if crit then
                    dmg_sprite:setScale(2.5, 2.5)
                else
                    dmg_sprite:setScale(2, 2)
                end
                local relative_pos_x, relative_pos_y = enemy:getRelativePos(enemy.width / 2, enemy.height / 2)
                dmg_sprite:setPosition(relative_pos_x + enemy.dmg_sprite_offset[1], relative_pos_y + enemy.dmg_sprite_offset[2])
                dmg_sprite.layer = enemy.layer + 0.01
                dmg_sprite.battler_id = action.character_id or nil
                table.insert(enemy.dmg_sprites, dmg_sprite)
                local dmg_anim_speed = 1 / 15
                if attacksprite == "effects/attack/shard" then
                    -- Ugly hardcoding BlackShard animation speed accuracy for now
                    dmg_anim_speed = 1 / 10
                end
                dmg_sprite:play(dmg_anim_speed, false, function(s) s:remove(); TableUtils.removeValue(enemy.dmg_sprites, dmg_sprite) end) -- Remove itself and Remove the dmg_sprite from the enemy's dmg_sprite table when its removed
                enemy.parent:addChild(dmg_sprite)

                local sound = enemy:getDamageSound() or "damage"
                if sound and type(sound) == "string" then
                    Assets.stopAndPlaySound(sound)
                end
                enemy:hurt(damage, battler)

                -- TODO: Call this even if damage is 0, will be a breaking change
                battler.chara:onAttackHit(enemy, damage)
            else
                enemy:hurt(0, battler, nil, nil, nil, action.points ~= 0)
            end

            for _, item in ipairs(battler.chara:getEquipment()) do
                item:onAttackHit(battler, enemy, damage)
            end

            self:finishAction(action)

            TableUtils.removeValue(self.normal_attackers, battler)
            TableUtils.removeValue(self.auto_attackers, battler)

            if not self:retargetEnemy() then
                self.cancel_attack = true
            elseif #self.normal_attackers == 0 and #self.auto_attackers > 0 then
                local next_attacker = self.auto_attackers[1]

                local next_action = self:getActionBy(next_attacker, true)
                if next_action then
                    self:beginAction(next_action)
                    self:processAction(next_action)
                end
            end
        end)

        return false

    elseif action.action == "ACT" then
        -- fun fact: this would have only been a single function call
        -- if stupid multi-acts didn't exist

        -- Check for other short acts
        local self_short = false
        self.short_actions = {}
        for _, iaction in ipairs(self.current_actions) do
            if iaction.action == "ACT" then
                local ibattler = self.party[iaction.character_id]
                local ienemy = iaction.target

                if ienemy then
                    local act = ienemy and ienemy:getAct(iaction.name)

                    if (act and act.short) or (ienemy:getXAction(ibattler) == iaction.name and ienemy:isXActionShort(ibattler)) then
                        table.insert(self.short_actions, iaction)
                        if ibattler == battler then
                            self_short = true
                        end
                    end
                end
            end
        end

        if self_short and #self.short_actions > 1 then
            local short_text = {}
            for _, iaction in ipairs(self.short_actions) do
                local ibattler = self.party[iaction.character_id]
                local ienemy = iaction.target

                local act_text = ienemy:onShortAct(ibattler, iaction.name)
                if act_text then
                    table.insert(short_text, act_text)
                end
            end

            self:shortActText(short_text)
        else
            local text = enemy:onAct(battler, action.name)
            if text then
                self:setActText(text)
            end
        end

        return false

    elseif action.action == "SKIP" then
        return true

    elseif action.action == "SPELL" then
        self.battle_ui:clearEncounterText()

        -- The spell itself handles the animation and finishing
        action.data:onStart(battler, action.target)

        return false

    elseif action.action == "ITEM" then
        local item = action.data
        if item.instant then
            self:finishAction(action)
        else
            local text = item:getBattleText(battler, action.target)
            if text then
                self:battleText(text)
            end
            battler:setAnimation("battle/item", function()
                local result = item:onBattleUse(battler, action.target)
                if result or result == nil then
                    self:finishAction(action)
                end
            end)
        end
        return false

    elseif action.action == "DEFEND" then
        battler:setAnimation("battle/defend")
        battler.defending = true
        return false

    else
        -- we don't know how to handle this...
        Logging.warnNotify("Unhandled battle action: " .. tostring(action.action))
        return true
    end
end

function Battle:hurt(amount, exact, target, swoon)
	if self.powder_mist and (love.math.random() <= 0.3) then
		target = target or "ANY"

		if type(target) == "number" then
			target = self.party[target]
		end

		if isClass(target) and target:includes(PartyBattler) then
			if (not target) or (target.chara:getHealth() <= 0) then
				target = self:randomTargetOld()
			end
		end

		if target == "ANY" then
			target = self:randomTargetOld()

			if isClass(target) and target:includes(PartyBattler) then

				local party_average_hp = 1

				for _, battler in ipairs(self.party) do
					if battler.chara:getHealth() ~= battler.chara:getStat("health") then
						party_average_hp = 0
						break
					end
				end

				if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
					target = self:randomTargetOld()
				end
				if target.chara:getHealth() / target.chara:getStat("health") < (party_average_hp / 2) then
					target = self:randomTargetOld()
				end

				if (target == self.party[1]) and ((target.chara:getHealth() / target.chara:getStat("health")) < 0.35) then
					target = self:randomTargetOld()
				end

				target.should_darken = false
				target.targeted = true
			end
		end

		-- Now it's time to actually damage them!
		if isClass(target) and target:includes(PartyBattler) then
			target:statusMessage("msg", "miss")
			return { target }
		end

		if target == "ALL" then
			Assets.playSound("hurt")
			local alive_battlers = TableUtils.filter(self.party, function(battler) return not battler.is_down end)
			for _, battler in ipairs(alive_battlers) do
				battler:statusMessage("msg", "miss")
			end
			-- Return the battlers who aren't down, aka the ones we hit.
			return alive_battlers
		end
		
		return
	end
	
	return super.hurt(self, amount, exact, target, swoon)
end

function Battle:nextTurn()
	super.nextTurn(self)
	
	self.powder_mist = false
end

---@private
---@return PartyBattler?
function Battle:_getPartyByIndex(index)
    local partybattler = self.party[index]
    if not partybattler then return nil end
    ---@cast partybattler PartyBattler
    return partybattler
end

---@private
function Battle:_isPartyByIndexSelectable(index)
    local partybattler = self:_getPartyByIndex(index)
    if not partybattler then return false end
    return not partybattler.smitten
end

function Battle:onPartySelectState()
    self.battle_ui:clearEncounterText()
    self.current_menu_y = 1

    if #self.party > 0 and not self:_isPartyByIndexSelectable(self.current_menu_y) then
        local attempts = 0
        repeat
            attempts = attempts + 1
            if attempts > #self.party then
                -- No selectable party battlers found (somehow????); bail out
                return
            end

            self.current_menu_y = self.current_menu_y + 1
            if self.current_menu_y > #self.party then
                self.current_menu_y = 1
            end
        until self:_isPartyByIndexSelectable(self.current_menu_y)
    end
end

function Battle:onKeyPressed(key)
	if self.state == "PARTYSELECT" then
        if Input.isConfirm(key) and self.party[self.current_menu_y].smitten then
            Assets.playSound("ui_cant_select")
            return
        end
	end
	
	super.onKeyPressed(self, key)
end

return Battle