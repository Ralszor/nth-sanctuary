---@class Map.dark_place : Map
local map, super = Class(Map, "1_2nd_sanctuary/ripple1")

function map:init(world, data)
    super.init(self, world, data)
    self.ripindex = 0
    self.con = 0
    self.finished = false
    self.fakefader = Rectangle(0,0,999,999)
    self.fakefader.alpha = 0
end

function map:onEnter()
    self.world.color = COLORS.black
    self.tiles = Game.world.map:getTileLayer("tiles")
    self.tiles.alpha = 0
    self.tiles_osc = Game.world.map:getTileLayer("tiles_osc_optimize")
    self.tiles_osc.alpha = 0
    for _, event in ipairs(self.events) do
        if event.layer == self.layers["objects_tile_oscillate"] then
             event.visible = false
        end
        if event.layer == self.layers["objects_parallax"] then
             event.parallax_x = 0.5
             event.parallax_y = 0.9
             event.visible = false
        end
        if event.layer == self.layers["objects_parallax2"] then
             event.parallax_x = 0.4
             event.parallax_y = 0.85
             event.visible = false
        end
        if event.layer == self.layers["objects_parallax3"] then
             event.parallax_x = 0.3
             event.parallax_y = 0.82
             event.visible = false
        end
    end
    for _, filter in ipairs(Game.world.map:getEvents("filter")) do
        filter.visible = false
    end
    for _, window in ipairs(Game.world.map:getEvents("window_glow")) do
        window.alpha = 0
        window.sprite.alpha = 0
    end
    
    self.ripple_fx = RippleEffect()
    self.ripple_fx.layer = WORLD_LAYERS["bottom"]
    Game.world:addChild(self.ripple_fx)
    self.ripple_fx_alt = RippleEffect()
    self.ripple_fx_alt.layer = WORLD_LAYERS["above_events"]
    Game.world:addChild(self.ripple_fx_alt)

    Game.world.map.timer:script(function(wait)
        wait(10/30)
        self.con = 1
        Game.world.music:play("second_church")

        local beat_times = {0, 95.25, 190.5, 285.75, 381, 476.25, 571.5, 666.75}
        local current_beat = 1

        for i = 1, #beat_times do
            self:spawnRippleBurst()
            
            if i == 5 then 
                for _, window in ipairs(Game.world.map:getEvents("window_glow")) do
                    Game.world.timer:tween(300/30, window, {alpha = 1}, "linear")
                end
            end

            if beat_times[i+1] then
                wait((beat_times[i+1] - beat_times[i]) / 30)
            end
        end

        wait((720 - 666.75) / 30)
        Game.stage:addChild(self.fakefader)
        Game.world.timer:tween(1, self.fakefader, {alpha = 1}, nil, function() 
            self.finished = true
            Game.world.color = COLORS.white
            self.world:loadMap("1_2nd_sanctuary/second_sanctum_0_ripple_post", "spawn")
            Game:setFlag("ripple2nd", true)
            self.fakefader:fadeOutAndRemove(0.5)
            self.tiles.alpha = 1
            self.tiles_osc.alpha = 1
            self.con = 2
            for _, event in ipairs(self.events) do
                if event.layer == self.layers["objects_parallax"] or 
                   event.layer == self.layers["objects_parallax2"] or 
                   event.layer == self.layers["objects_parallax3"] or 
                   event.layer == self.layers["objects_tile_oscillate"] then
                    event.visible = true
                end
            end
            for _, filter in ipairs(Game.world.map:getEvents("filter")) do
                filter.visible = true
            end
        end)

        -- wait(60/30)
        -- self:transitionMap()
    end)
end

function map:spawnRippleBurst()
    local seqtime = 0.17647
    for i = 0, 8 do
        Game.world.timer:after(seqtime * i, function()
            self:makeRippleLogic()
        end)
    end
end

function map:makeRippleLogic()
    local cx,cy = Game.world.camera.x-SCREEN_WIDTH/2, Game.world.camera.y-SCREEN_HEIGHT/2
    local loc = {}
    local border = 80
    table.insert(loc, {x = cx + 0 + border, y = cy + 0 + border})
    table.insert(loc, {x = cx + SCREEN_WIDTH - border, y = cy + 0 + border})
    table.insert(loc, {x = cx + 0 + border, y = cy + SCREEN_HEIGHT - border})
    table.insert(loc, {x = cx + SCREEN_WIDTH - border, y = cy + SCREEN_HEIGHT - border})
    border = 120
    table.insert(loc, {x = cx + SCREEN_WIDTH/2, y = cy + SCREEN_HEIGHT/2 + border})
    table.insert(loc, {x = cx + SCREEN_WIDTH/2, y = cy + SCREEN_HEIGHT/2 - border})
    border = 160
    table.insert(loc, {x = cx + SCREEN_WIDTH/2 + border, y = cy + SCREEN_HEIGHT/2})
    table.insert(loc, {x = cx + SCREEN_WIDTH/2 - border, y = cy + SCREEN_HEIGHT/2})
    
    local masterdir = 0
    if Game.world.player then
        masterdir = MathUtils.angle(Game.world.player.x, Game.world.player.y, Game.world.player.x + Game.world.player.moving_x, Game.world.player.y + Game.world.player.moving_y)
    end
    local hhsp = -math.cos(masterdir) * 2
    local vvsp = -math.sin(masterdir) * 2
    
    self.ripple_fx_alt:makeRipple(loc[self.ripindex+1].x, loc[self.ripindex+1].y, 60, COLORS.white, 200, 1, 14, -5, hhsp, vvsp, 0.25)
    self.ripindex = (self.ripindex + 1) % #loc
end

function map:onExit()
	Game:setFlag("ripple2nd", false)
    self.world.color = COLORS.white
	if not self.finished and not Game:getFlag("noellefall", false) then
		Game:setFlag("lastJammWeapon", Game:getPartyMember("jamm"):getWeapon())
		Game:getPartyMember("jamm"):setWeapon(nil)
	end
end

function map:onFootstep(char, num)
    if not char.is_player or num ~= 1 or self.finished then return end
    local x, y = char:getRelativePos(18/2, 72/2)
    local px = Game.world.player.moving_x
    local py = Game.world.player.moving_y
    if Game.world.player.last_collided_x then px = 0 end
    if Game.world.player.last_collided_y then py = 0 end
    
    self.ripple_fx:makeRipple(x, y, 60, ColorUtils.hexToRGB("#4A91F6"), 220, 1, 18, 1999000, px * 1.05, py * 1.05, nil, nil, false)
    self.ripple_fx:makeRipple(x, y, 60, ColorUtils.hexToRGB("#4A91F6"), 140, 1, 15, 1999000, px * 1.05, py * 1.05, nil, nil, false)
end

return map