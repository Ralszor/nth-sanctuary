---@enum DarkShardID
Mod.DarkShardID = {
    SecondSanctuary = 0,
    FourthSanctuary = 1,
    BookShard = 2,
    LeafRoomShard = 3,
}

Mod.DarkShardName = {
    [Mod.DarkShardID.SecondSanctuary] = "Imbued",
    [Mod.DarkShardID.FourthSanctuary] = "Apathetic Encounter",
    [Mod.DarkShardID.BookShard] = "All Caught Up",
    [Mod.DarkShardID.LeafRoomShard] = "DeltaLeaf",
}

function Mod:createDarkInventory(inventory)
  inventory.storages["ammo"] = {id = "ammo", max = 48, name = "AMMO"}
  
  inventory.storage_for_type["ammo"] = "ammo"
end

---@param plugin TypeGenPlugin.MainScript
function Mod:onTiledTypegen(plugin)
    plugin:addEnumType({
        values = TableUtils.getKeys(self.DarkShardID),
        type = "enum",
        id = 0,
        valuesAsFlags = false,
        name = "DarkShardID",
        storageType = "int",
    })
end

function Mod:isWeird()
    return (Game:getFlag("route") == 3)
end

function Mod:shouldGoToHell()
    return Game:getFlag("unlock_travel")
end

function Mod:increaseIndoct(amt)
    local amount = amt or 1
    local flag = Game:getFlag("indoct-con")
    Game:setFlag("indoct-con", flag + amount)

    Assets.playSound("indoct_up", 1, 1 - (Game:getFlag("indoct-con") / 20))
end

function Mod:checkIndoct(amt)
    return Game:getFlag("indoct-con") >= amt
end

function Mod:registerDebugOptions(debug)
    debug:registerMenu("nth_sanctumdebug", "#th Sanctuary Debug","menu")
    
    debug:registerOption("main", "#th Sanctuary Options", "Enter the  Funky  Menu.", function () debug:enterMenu("nth_sanctumdebug", 1) end)
    
    debug:registerOption(
        "nth_sanctumdebug", 
        "Set Dark Shards to somthign big", 
        "Ease of Access.",
        function()
        for i=1,100 do
            Mod.dark_shards[i]=-1
        end
    end)
    
    debug:registerOption(
    "nth_sanctumdebug", 
    "Set Dark Shards to 1", 
    "Set them to 1.",
    function()
        for g, shard in ipairs(Mod.dark_shards) do
            Mod.dark_shards[g] = 0
        end
    end)

    debug:registerOption(
    "nth_sanctumdebug", 
    "Force mod finish", 
    function()
        local b = (Game:getFlag("finished")==false and "OFF") or "ON"
        return "Probably of good use? ("..b      ..")"
    end,
    function()
        Game:setFlag("finished", not Game:getFlag("finished"))
    end)

    debug:registerOption(
    "nth_sanctumdebug", 
    "The Cooler 'Give Money'", 
    "fre mony genrtr",
    function()
        Game.money = Game.money + 1000
    end)    
    
    debug:registerOption(
    "nth_sanctumdebug", 
    "Toggle 3D Mode", 
    "Enables first person view & 3D graphics. (Not actually dont do this please)",
    function()
        love.graphics.setCanvas(4)
    end)

end

function Mod:init()
    self.sound_timer = 0
    Mod.logger = Logger("#th Sanctuary", ConsoleFormats.BLUE)
    Mod.logger:info("Loaded " .. self.info.name .. "!")
    Game:registerEvent("squeak", function(data)
        return Squeak(data.x, data.y, {data.width, data.height, data.polygon})
    end)
    Game:registerEvent("bookshelf_destructable", function(data)
        return BookshelfDestructable(data)
    end)
    Game:registerEvent("glowy", function(data)
        return Glowy(data)
    end)
    Game:registerEvent("hellglow", function(data)
        return HellGlow(data)
    end)
    Game:registerEvent("vaporsun", function(data)
        return VaporSun(data.center_x, data.center_y)
    end)
    Game:registerEvent("pathclimbenemy", function(data)
        return PathClimbEnemy(data.x, data.y, data.properties)
    end)
    Game:registerEvent("chaselooper", function(data)
        return ChaseLooper(data.x, data.y, data.width, data.height, data.properties)
    end)
    Game:registerEvent("pathingenemy", function(data)
        return PathingEnemy(data.center_x, data.center_y, data.properties)
    end)
    TableUtils.copyInto(MUSIC_VOLUMES, {
        second_church = 0.8
    })
    self.DT_MULT = 1
    Utils.hook(love.timer, "step", function (orig, ...)
        local dt = orig(...)
        return dt * math.max(0.05, self.DT_MULT)
    end)
    self.legacy_base_music = Kristal.Config["nthSanctuary/legacyBaseMusic"] or false

    HookSystem.hook(Registry, "createMap", function(orig, id, ...)
        local ok, result = pcall(orig, id, ...)
        if ok then
           return result
        elseif id ~= "dogcheck/dogcheck" then
			Mod.logger:warn("Dogcheck triggered due to following error:\n" .. result)
			return Registry.createMap("dogcheck", ...)
        else
           error("Attempt to create non existent map \"" .. tostring(id) .. "\"")
       end
    end)
end

function Mod:onFootstep(chara, num)
    if chara:includes(Player) then
        for i, w in ipairs(Game.stage:getObjects(LightRainEffect)) do
			local make_steps = true
			for _,dryzone in ipairs(Game.world.map:getEvents("dryzone")) do
				if Game.world.player:collidesWith(dryzone.collider) then
					make_steps = false
				end
			end
			if w.rainsplash and not Game.world.map.inside and not Game.world.map.data.properties["inside"] and make_steps then
				if num == 1 then
					Assets.playSound("stepsplash1")
				elseif num == 2 then				
					Assets.playSound("stepsplash2")
				end
			end
        end
    end
end

function Mod:afmGetMusic()
    local data = Kristal.getSaveFile(1)
	local flags = {}
	for i=1,3 do
		local path = "saves/nth_sanctum/file_"..i..".json"
		if love.filesystem.getInfo(path) then
			local data = JSON.decode(love.filesystem.read(path))
			table.insert(flags, data.flags["prog"])
		end
	end
	table.sort(flags)
	local flag = flags[#flags]
    if flag == 0 or not flag then
		return "afm/preview"
	else
		return "afm/prev2"
	end
end

function Mod:getActionButtons(battler, buttons)
    if StringUtils.contains(battler.chara.id, "cuptain") then
        return {"fight", "magic", "defend"}
    end
    return 
end
        
function Mod:afmGetStyle()
    return "normal"
end

function Mod:unload()
    if DISCORD_RPC_AVAILABLE and Kristal.Config["discordRPC"] then
        DiscordRPC.shutdown()
        DiscordRPC.initialize(DISCORD_RPC_ID, true)
    end
end

function Mod:registerTextCommands(text)
    text:registerCommand("float", function(self,node, dry)
        self.state.float_dist = tonumber(node.arguments[1]) or 5
        self.state.float_speed = 2*math.pi * (tonumber(node.arguments[2]) or 1)
        self.state.float_phase = math.rad(tonumber(node.arguments[3]) or 20)
        
        self.draw_every_frame = true
        return true
    end)
    text:registerCommand("friend", function(self, node, dry)
        self.state.friendly = (node.arguments[1] ~= "unfriend")
    end, {dry = true})
    text:registerCommand("static", function(self, node, dry)
        self.state.static = (node.arguments[1] ~= "unstatic")
        self.state.static_brightness = node.arguments[2] or 1
        self.draw_every_frame = true
    end, {dry = true})
    text:registerCommand("imbuedstatic", function(self, node, dry)
        self.state.imbued_static = (node.arguments[1] ~= "unstatic")
        self.state.static_brightness = node.arguments[2] or 1
        self.draw_every_frame = true
    end, {dry = true})
    text:registerCommand("dualcol", function(self, node, dry)
        self.state.dualcol = (node.arguments[1] ~= "stop")
        if node.arguments[1] == "stop" then return end
        self.state.col1 = ColorUtils.hexToRGB(node.arguments[1])
        self.state.col2 = ColorUtils.hexToRGB(node.arguments[2])
    end, {dry = true})
    text:registerCommand("gold", function(self, node, dry)
        self.state.golden = (node.arguments[1] ~= "ungold")
    end, {dry = true})
    text:registerCommand("rainbow", function(self, node, dry)
        self.state.rainbow = (node.arguments[1] ~= "unrainbow")
        self.draw_every_frame = true
    end, {dry = true})
end

function Mod:onDrawText(text, node, state, x, y, scale, font, use_color)
    
    if state.friendly then
        local shader = Kristal.Shaders["GradientV"]
        local last_shader = love.graphics.getShader()
        local w, h = text:getNodeSize(node, state)
        local canvas = Draw.pushCanvas(w, h, { stencil = false })
        love.graphics.print(node.character, 0, 0, 0, scale, scale)
        Draw.popCanvas()
        love.graphics.setShader(shader)
		if state.style == "dark" then
			shader:sendColor("from", {0.3, 0.12, 0.3, 1})
			shader:sendColor("to", {0.3,0.3,0,1})
			Draw.draw(canvas, x + 1, y + 1)
		end
        shader:sendColor("from", {1, 0.4, 1, 1})
        shader:sendColor("to", {1,1,0,1})
        Draw.draw(canvas, x, y)
        love.graphics.setShader(last_shader)
        return true    
    elseif state.static or state.imbued_static then
        local last_shader = love.graphics.getShader()
        local w, h = text:getNodeSize(node, state)
        local canvas = Draw.pushCanvas(w, h, { stencil = false })
        love.graphics.print(node.character, 0, 0, 0, scale, scale)
        Draw.popCanvas()
		local static_shader = Assets.getShader("static_bullet")
		static_shader:send("time", Kristal.getTime())
		love.graphics.setShader(static_shader)
		static_shader:send("brightness", state.static_brightness or 1)
        Draw.draw(canvas, x, y)
		if state.imbued_static then
			for i = 0, 5 do
				Draw.setColor(1,1,1,0.7 - (i * 0.1))
				Draw.draw(canvas, x - (i * 1) + MathUtils.random(i * 2), y - (i * 1) + MathUtils.random(i * 2))
			end
		end
        love.graphics.setShader(last_shader)
        return true
    elseif state.golden then
        local shader = Kristal.Shaders["GradientV"]
        local last_shader = love.graphics.getShader()
        local w, h = text:getNodeSize(node, state)
        local canvas = Draw.pushCanvas(w, h, { stencil = false })
        love.graphics.print(node.character, 0, 0, 0, scale, scale)
        Draw.popCanvas()
		if state.style == "dark" then
			Draw.setColor(0.3, (178/255) * 0.3, (77/255) * 0.3)
			Draw.draw(canvas, x + 1, y + 1)
		end
		Draw.setColor(1,1,1,1)
        love.graphics.setShader(shader)
        shader:sendColor("from", {1, 217/255, 89/255, 1})
        shader:sendColor("to", {1,178/255,77/255,1})
        Draw.draw(canvas, x, y)
        love.graphics.setShader(last_shader)
        return true
    elseif state.rainbow then
		local shader = Kristal.Shaders["GradientV"]
        local last_shader = love.graphics.getShader()
        local w, h = text:getNodeSize(node, state)
        local canvas = Draw.pushCanvas(w, h, { stencil = false })
        love.graphics.print(node.character, 0, 0, 0, scale, scale)
        Draw.popCanvas()
		local color = {ColorUtils.HSVToRGB((((state.typed_characters * 20) + (text.timer * 3)) / 255) % 1, 1, 1)}
		if state.style == "dark" then
			Draw.setColor(color[1] * 0.3, color[2] * 0.3, color[3] * 0.3, 1)
			Draw.draw(canvas, x + 1, y + 1)
		end
		Draw.setColor(1,1,1,1)
        love.graphics.setShader(shader)
        shader:sendColor("from", COLORS.white)
        shader:sendColor("to", color)
        Draw.draw(canvas, x, y)
        love.graphics.setShader(last_shader)
        return true
    elseif state.dualcol then
        local shader = Kristal.Shaders["GradientV"]
        local last_shader = love.graphics.getShader()
        local w, h = text:getNodeSize(node, state)
        local canvas = Draw.pushCanvas(w, h, { stencil = false })
        love.graphics.print(node.character, 0, 0, 0, scale, scale)
        Draw.popCanvas()
        love.graphics.setShader(shader)
		if state.style == "dark" then
			shader:sendColor("from", ColorUtils.mergeColor(COLORS.black, state.col1, 0.3))
			shader:sendColor("to", ColorUtils.mergeColor(COLORS.black, state.col2, 0.3))
			Draw.draw(canvas, x + 1, y + 1)
		end
        shader:sendColor("from", state.col1)
        shader:sendColor("to", state.col2)
        Draw.draw(canvas, x, y)
        love.graphics.setShader(last_shader)
        return true
    end
end

Utils.hook(Text,"drawChar", function(orig, self, node, state, use_color)
    if(state.float_dist and state.float_dist > 0) then
        state.offset_y = state.float_dist * math.sin( (state.float_speed * Kristal.getTime()) + (state.float_phase * state.typed_characters) )
    else
        state.offset_y = 0
    end
    orig(self, node, state, use_color)
end)

function Mod:c4lCreateFilterFX(type, properties)
    local fxtype = (type or "hsv"):lower()
    if fxtype == "hsv" then
        return HSVShiftFX()
    elseif fxtype == "hsv2" then
		local hsv = HSVShiftFX()
		hsv.hue_start = 60;
		hsv.sat_start = 0.4;
		hsv.val_start = 1;
		hsv.hue_target = 80;
		hsv.sat_target = 0.4;
		hsv.val_target = 1;
		hsv.hue = hsv.hue_start;
		hsv.sat = hsv.sat_start;
		hsv.val = hsv.val_start;
		hsv.wave_time = 1;
        return hsv
    elseif fxtype == "hsv3" then
		local hsv = HSVShiftFX()
		hsv.hue_start = -100;
		hsv.sat_start = 0.6;
		hsv.val_start = 1;
		hsv.hue_target = -140;
		hsv.sat_target = 0.6;
		hsv.val_target = 1.5;
		hsv.hue = hsv.hue_start;
		hsv.sat = hsv.sat_start;
		hsv.val = hsv.val_start;
		hsv.wave_time = 2;
        return hsv
    elseif fxtype == "fractured" then
        return FracturedHSVFX()
    elseif fxtype == "custom" then --FINALLY
		local hsv = HSVShiftFX()
		hsv.hue_start = properties["hue_start"] or 0; --NO
		hsv.sat_start = properties["sat_start"] or 0.6; --MORE
		hsv.val_start = properties["val_start"] or 1; --DUPLICATE
		hsv.hue_target = properties["hue_target"] or -140; --HUE
		hsv.sat_target = properties["sat_target"] or 1; --SHIFT
		hsv.val_target = properties["val_target"] or 1.5; --TYPES
		hsv.hue = hsv.hue_start;
		hsv.sat = hsv.sat_start;
		hsv.val = hsv.val_start;
		hsv.wave_time = properties["speed"] or 2;
        return hsv
    elseif fxtype == "prophecyscroll" then
        return ProphecyScrollFX()
    end
end

function Mod:afmPostInit(new_file)
    Game:setFlag("apkpure", false)
    if new_file then
        Game.money = 100 + math.random(1, 100)
        Game:setFlag("indoct-con", 0)
        Game:setFlag("fun", love.math.random(1, 170))
        Game.world:startCutscene("light.intro")
        -- Game.world:startCutscene("primary.intro")
		Game:setFlag("ft_last_map", "base_center")
		Game:setFlag("hometown_time", "night")
        if (Game:getFlag("route") == 2 or Game:getFlag("route") == 3) then
            if Game:hasPartyMember("kris") then
                Game:getPartyMember("kris").health = 240
                Game:getPartyMember("kris").stats.health = 240
                Game:getPartyMember("kris").stats.attack = 19
            end
            if Game:hasPartyMember("susie") then
                Game:getPartyMember("susie").health = 290
                Game:getPartyMember("susie").stats.health = 290
                Game:getPartyMember("susie").stats.attack = 25
            end
            if Game:hasPartyMember("ralsei") then
                Game:getPartyMember("ralsei").health = 210
                Game:getPartyMember("ralsei").stats.health = 210
                Game:getPartyMember("ralsei").stats.attack = 16
            end
        end
    else
        Game:setFlag("shards", nil) -- Clean up old save files
        if not Game:getFlag("hometown_time", nil) then
			Game:setFlag("hometown_time", "night")
		end
        if Game:getFlag("apkpure", true) then
            Game.world:startCutscene(function(cutscene)
                cutscene:setSpeaker("susie")
                cutscene:text("* hey,[wait:5] "..Game.save_name.. ".[wait:5] this is [color:red]fucking[color:reset] susie.", "bangs_smile")
                cutscene:text("* you seem to be playing an unofficial build of [color:blue]#th sanctuary.", "bangs_neutral")
                cutscene:text("* that's called [color:red]PIRACY,[wait:5][color:reset] buddy.[wait:5] that's right.", "bangs_teeth")
                cutscene:text("* so now,[wait:5] i wanted to say something you should know really well...", "bangs_smile")
                Game.world.music:pause()
                cutscene:text("* [speed:0.1]HYPERBOID.", "bangs_teeth")
                Game.world.music:resume()
                cutscene:text("* okay thanks now go get the game on [color:green]gamejolt.", "bangs_smile")
                cutscene:text("* btw your [color:#ff00ff]FRI[color:#eaff00]END is on [color:#353535]the funnyfeline youtube channel.[color:reset]", "bangs_smile")
                cutscene:text("* AND president donald trump has your ip now in [color:red]t[color:reset]h[color:blue]e [color:red]u[color:blue]s", "bangs_neutral")
                cutscene:text("* ok bye im behind you because im your [color:#ff00ff]FRI[color:#eaff00]END~~", "bangs_smile")
            end)
        end
    end
	Mod.titan_dissolve_shader = love.graphics.newShader[[
    extern float amount;
    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
        if (Texel(tex, texture_coords).a < amount) {
            // a discarded pixel wont be applied as the stencil.
            discard;
        }
        return vec4(1.0);
    }
 ]]
end

function Mod:onTextSound(sound, node)
    if sound == "3d" then
        local ranNum = love.math.random(1, 7)
        if ranNum == 1 then
            Assets.playSound("voice/chops/t1")
        elseif ranNum == 2 then
            Assets.playSound("voice/chops/t2")
        elseif ranNum == 3 then
            Assets.playSound("voice/chops/t3")
        elseif ranNum == 4 then
            Assets.playSound("voice/chops/t4")
        elseif ranNum == 5 then
            Assets.playSound("voice/chops/t5")
        elseif ranNum == 6 then
            Assets.playSound("voice/chops/t6")
        elseif ranNum == 7 then
            Assets.playSound("voice/chops/t7")
        end
        return true
    elseif sound == "jack" then
        if self.sound_timer == 0 then
            local snd = Assets.stopAndPlaySound("voice/jack")
            snd:setPitch(0.75 + MathUtils.random(0.5))
            self.sound_timer = 3
        end
        return true
    elseif sound == "sans" then
        if self.sound_timer == 0 then
			Assets.stopAndPlaySound("voice/sans")
            self.sound_timer = 2
        end
        return true
    elseif sound == "spam" then
        if self.sound_timer == 0 then
			Assets.stopAndPlaySound("voice/spam", 0.8, 1.2)
            self.sound_timer = 2
        end
        return true
    elseif sound == "ddelta" then
		Assets.stopAndPlaySound("voice/ddelta")
        return true
    end
end

function Mod:onMapMusic(map, music)
	if music == "homebase" and self.legacy_base_music then
		return "homebase_old"
    elseif music == "grand_bells" then
		return {"bell_ambience", 0.5, 0.5}
	elseif music == "church_study_slower" then
		return {"church_dark_study", 1, 0.75}
	elseif music == "hometown" then
		if Game:getFlag("hometown_time", "day") == "day" then
			return "town_day"
		elseif Game:getFlag("hometown_time", "day") == "sunset" then
			return "town"
		elseif Game:getFlag("hometown_time", "day") == "night" then
			return "night_ambience"
		end
	elseif music == "church" then
		if Game:getFlag("hometown_time", "day") == "night" then
			return "church_lw_night"
		else
			return "church_lw"
		end
	elseif music == "mus_birdnoise" and Game:getFlag("hometown_time", "day") == "night" then
		return "night_ambience"
	end
end

function Mod:onMapBorder(map, border)
	if border == "leaves" and Game:getFlag("hometown_time", "day") == "night" then
		return "leaves_night"
	end
end


function Mod:onShadowCrystal(item, light)
    if light then return end
	if Game.world:getEvent("prophecy") then
		Game.world:startCutscene(function(cutscene)
			cutscene:text("* You held the crystal up to your eye.")
			cutscene:text("* For some strange reason,[wait:5] no matter how you look...")
			cutscene:text("* The prophecy's text does not warp in the crystal's lens.")
		end)
		return true
	elseif not item:getFlag("used_none", false) then
        item:setFlag("used_none", true)
		local extra_sanctum_maps = {
			"base_east",
			"base_east2",
		}
        Game.world:startCutscene(function(cutscene)
			if Game.world.map.id and StringUtils.contains(Game.world.map.id, "hell") then
				cutscene:text("* You held the crystal up to your eye.")
				cutscene:text("* For some strange reason,[wait:5] for just a brief moment...")
				cutscene:text("* You thought you saw the church burning down.")
			elseif Game.world.map.id and StringUtils.contains(Game.world.map.id, "sanctum")
			or StringUtils.contains(Game.world.map.id, "sanctuary")
			or TableUtils.contains(extra_sanctum_maps, Game.world.map.id) then
				cutscene:text("* You held the crystal up to your eye.")
				cutscene:text("* For some strange reason,[wait:5] for just a brief moment...")
				cutscene:text("* You thought you saw the lobby of the church.")
			else
				cutscene:text("* You looked through the glass.")
				cutscene:text("* ...[wait:5] but nothing happened.")
			end
        end)
        return true
    end
end

function Mod:load(data, new_file, index)
    ---@type [int, int, int, int, int, int, int]
    self.dark_shards = {
        0, 0, 0, 0,
        0, 0, 0, 0,
    } -- 8 words * 32 bits per word = 256 bits
    if data.dark_shards then
        for i = 1, #data.dark_shards do
            Mod.dark_shards[i] = data.dark_shards[i]
        end
    end
end

function Mod:save(data)
    data.dark_shards = TableUtils.copy(self.dark_shards)
end

---@return int
function Mod:getDarkShardCount(dark_shard_bits)
    dark_shard_bits = dark_shard_bits or self.dark_shards
    local count = 0 -- (Because of the starting dark shard)
    for id = 0, #dark_shard_bits * 32 do
        local word = bit.rshift(id, 5) + 1
        local subid = bit.band(id, 0b00011111)
        if bit.band(dark_shard_bits[word] or 0, bit.lshift(1, subid)) ~= 0 then
            count = count + 1
        end
    end
    return count
end

---@param id DarkShardID
---@param collected boolean
function Mod:setDarkShard(id, collected)
    local word = bit.rshift(id, 5) + 1
    local subid = bit.band(id, 0b00011111)
    assert(self.dark_shards[word], "ID out of range")
    if collected then
        self.dark_shards[word] = bit.bor(self.dark_shards[word], bit.lshift(1, subid))
    else
        self.dark_shards[word] = bit.band(self.dark_shards[word], bit.bnot(bit.lshift(1, subid)))
    end
end


---@param id DarkShardID
---@return boolean
function Mod:getDarkShard(id)
    local word = bit.rshift(id, 5) + 1
    local subid = bit.band(id, 0b00011111)
    return bit.band(self.dark_shards[word] or 0, bit.lshift(1, subid)) ~= 0
end

function Mod:preUpdate()
    self.sound_timer = MathUtils.approach(self.sound_timer, 0, DTMULT)
end

function Mod:loadObject(world, name, data)
    if Game.event_registry:has(name) then
        return Game.event_registry:create(name, data)
    end
    loaded = world.map:legacyLoadObject(name, data)
    if loaded ~= nil then
        return loaded
    end
    if Game.builtin_event_registry:has(name) then
        return Game.builtin_event_registry:create(name, data)
    end
    if data.gid then
		local tobj = world.map:createTileObject(data)
		tobj.day_mode = data.properties["day"] or nil
		tobj.night_mode = data.properties["night"] or nil
		tobj.rain_mode = data.properties["rain"] or nil
		return tobj
    end
	return nil
end

--[==[
function Mod:preInit()
    ---@return string|number[][]
    local function parseCSV(str)
        local lines = StringUtils.splitFast(str, "\n")
        local dat = {}
        for index, line in ipairs(lines) do
            dat[index] = StringUtils.split(line, ";")
            for l_index, value in ipairs(dat[index]) do
                dat[index][l_index] = tonumber(value) or value
            end
        end
        return dat
    end
    local dat = parseCSV(love.filesystem.read(Mod.info.path .. "/glyphs_fnt_legend.csv"))
    local img = love.graphics.newImage(Mod.info.path .. "/fnt_legend.png")
    ---@type (string|number)[]
    local header = table.remove(dat, 1)
    local glyphs = {}
    local total_width = 0
    local max_height = 0
    for index, line in ipairs(dat) do
        local quad = Assets.getQuad(line[2], line[3], line[4], line[5], img:getDimensions())

        local this_width = line[6] + 0
        this_width = math.floor(this_width)
        glyphs[line[1]] = love.graphics.newCanvas(this_width, line[5] )
        Draw.pushCanvas(glyphs[line[1]])
        love.graphics.draw(img, quad)
        Draw.popCanvas()

        total_width = total_width + 1 + this_width
        max_height = math.max(max_height, line[5])
    end

    local font_config = {
        ["glyphs"] = ""
    }

    local canvas = love.graphics.newCanvas(total_width, max_height)
    Draw.pushCanvas(canvas)
    for key, value in Utils.orderedPairs(glyphs) do
        local ok, char = pcall(string.char, key)
        if not ok then goto continue end
        font_config["glyphs"] = font_config["glyphs"] .. char
        Draw.setColor(0,0,1)
        love.graphics.rectangle("fill", 0,0,1,max_height)
        love.graphics.translate(1, 0)
        Draw.setColor(COLORS.white)
        Draw.draw(value)
        love.graphics.translate(value:getWidth(), 0)
        ::continue::
    end
    Draw.popCanvas()
    canvas:newImageData():encode("png", Mod.info.path .. "/libraries/chapter4lib/assets/fonts/legend.png")
    print(JSON.encode(font_config))
end
--]==]


function Mod:postInit()
    if DISCORD_RPC_AVAILABLE and Kristal.Config["discordRPC"] then
        DiscordRPC.shutdown()
        DiscordRPC.initialize("1235713537322651648", true)
    end

end

--[[
function Mod:postDraw()
    local points = {}
    for index, value in ipairs(self.thingy or {}) do
        table.insert(points, index*6)
        table.insert(points, (SCREEN_HEIGHT) - (value * (SCREEN_HEIGHT/2)))
    end
    love.graphics.line(points)
    love.graphics.setColor(1,0,0,1)
    points = {}
    for index, value in ipairs(self.thingy2 or {}) do
        table.insert(points, index*4)
        table.insert(points, (SCREEN_HEIGHT) - (value * (SCREEN_HEIGHT/2)))
    end
    love.graphics.line(points)
end
]]

function Mod:postLoad(new_file)
	local jamm = Game:getPartyMember("jamm")
	
	if not jamm:getAmmo() then jamm:setAmmo("rubber_pellet") end
	
	if not new_file then
		if Game.playtime > 5 and (not Game:getFlag("version_info")) then
			Game.world:startCutscene("incompatible.legacy")
		end
		
		if jamm:getArmor(2) then
			Game.inventory:addItem(jamm:getArmor(2))
			jamm:getArmor(2):unequip(false, nil)
			jamm:setArmor(2, nil)
		end
    else
        Game:setFlag("version_info", Mod.info.version_info)
	end
end
