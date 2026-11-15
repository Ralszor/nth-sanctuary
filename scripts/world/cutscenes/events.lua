return {
	egg = function (cutscene)
		--local get = Game:getFlag("egg")
		local rand = love.math.random(1,50)
		if rand == 50 then
			Game.world:mapTransition("fractured_sanctuary/fractured_egg_room", "spawn")
		else
			if Game.world.map.id == "fractured_sanctuary/fractured_2" then
				Game.world:mapTransition("fractured_sanctuary/fractured_3", "entry")
			elseif Game.world.map.id == "fractured_sanctuary/fractured_3" then
				Game.world:mapTransition("fractured_sanctuary/fractured_2", "entry2")
			end
		end
	end,
	secretsanctum1 = function (cutscene)
		--local get = Game:getFlag("egg")
		local rand = love.math.random(1,50)
		if rand == 50 then
			Game.world:mapTransition("secrets/secret_sanctuary", "spawn")
		else
			if Game.world.map.id == "sanctum_hell/hell_unknown" then
				Game.world:mapTransition("sanctum_hell/hell_unknown", "10")
			end
		end
	end,
	secretsanctum2 = function (cutscene)
		--local get = Game:getFlag("egg")
		local rand = love.math.random(1,50)
		if rand == 50 then
			Game.world:mapTransition("secrets/secret_sanctuary", "spawn")
		else
			if Game.world.map.id == "sanctum_hell/hell_unknown" then
				Game.world:mapTransition("sanctum_hell/hell_unknown", "4")
			end
		end
	end,
	scarlet_tree = function (cutscene)
		--local get = Game:getFlag("egg")
		local rand = love.math.random(1,10)
		if rand == 10 then
			Game.world:mapTransition("secrets/citadel_room/tree", "spawn")
		else
			if Game.world.map.id == "secrets/citadel_room/citadel_room_3" then
				Game.world:mapTransition("secrets/citadel_room/edge", "entry")
			elseif Game.world.map.id == "secrets/citadel_room/edge" then
				Game.world:mapTransition("secrets/citadel_room/citadel_room_3", "entry2")
			end
		end
	end,
	egg_tree = function(cutscene)
		if not Game:getFlag("egg") then
			cutscene:text("* (He is behind the tree.)")
		else
			cutscene:text("* (It is a tree.)")
		end
	end,
	egggive = function (cutscene)
		if not Game:getFlag("egg") then
			Game:setFlag("egg", true)
			--Game.inventory:addItem("egg")
			cutscene:text("* (Well,[wait:5] there is a man here.)")
			cutscene:text("* (He has been waiting for you.)")
			cutscene:text("* (He whispers something to your ear,)")
			Assets.playSound("egg")
			cutscene:text("* (And he gives you an Egg.)")
		else
			cutscene:text("* (Well,[wait:5] there is not a man here.)")
		end
	end,
    moss1 = function (cutscene)
        local get = Game:getFlag("moss1")
        if not get then
            Game.world.music.volume = 0
            Assets.playSound("moss_fanfare")
            cutscene:text("* You found the [color:green]Moss!")
            Game.inventory:addItem("moss")
            Game.world.timer:tween(1, Game.world.music, {volume = 1})
            Game:setFlag("moss1", true)
        elseif get == true then
            cutscene:text("* (You already got the moss.)")
        end
    end,
	moss3 = function (cutscene)
        local get = Game:getFlag("moss3")
        if not get then
            Game.world.music.volume = 0
            Assets.playSound("moss_fanfare")
            cutscene:text("* You found the [color:green]Moss!")
            Game.inventory:addItem("moss")
            Game.world.timer:tween(1, Game.world.music, {volume = 1})
            Game:setFlag("moss3", true)
        elseif get == true then
            cutscene:text("* (You already got the moss.)")
        end
    end,

    moss2 = function (cutscene)
        local get = Game:getFlag("moss2")
        if not get then
            Game.world.music.volume = 0
            Assets.playSound("moss_fanfare")
            cutscene:text("* You found the [color:9999ff]DuskMoss!")
            Game.inventory:addItem("duskmoss")
            Game.world.timer:tween(1, Game.world.music, {volume = 1})
            Game:setFlag("moss2", true)
        elseif get == true then
            cutscene:text("* (You already got the moss.)")
        end
    end,

    shard = function(cutscene)
        cutscene:wait(2)
        local this = BurstObj(Game.world.player.x, Game.world.player.y, {0.2, 0.2, 0.2}, "darkshard")
        this:setScale(2)
        Game.world:spawnObject(this)
    end,

    tobykillsyou = function (cutscene)
        local toby = Sprite("npcs/dogcar")
        toby:play()
        toby.x, toby.y = Game.world.player.x+400, Game.world.player.y - 80
        toby:setScale(2)
        Game.world:spawnObject(toby)
        cutscene:wait(1/4)
        					Assets.playSound("drive")
        toby:slideTo(toby.x - 400, toby.y, 1/2)
        cutscene:wait(1/2)
        local a = Game.world:getEvent("pianobig")
        a.con = 4
        Game.lock_movement = true
        cutscene:fadeOut(0, {music = true})
        Assets.playSound("hurt")
        cutscene:wait(1)
        toby:remove()
        cutscene:fadeIn(1, {music = true})
        cutscene:wait(1)
        Game.lock_movement = false
    end,
    prism = function (cutscene)
        local dd = cutscene:getCharacter("ddelta")
        cutscene:setSpeaker(dd)
		if Game:getFlag("won_prism_1") then
			cutscene:text("* what?[wait:5]\n* you want to fight the prism again?")
			cutscene:text("* uh,[wait:5] too bad![wait:5]\n* i'm never doing that again!")
			cutscene:text("* (after all,[wait:5] this is just a placeholder cutscene!)")
			return
		end
		local dd_y = dd.y
        if Game:getFlag("prism_quick") ~= true then
			cutscene:text("* delta warriors...[wait:5]\n* you finally arrived")
			cutscene:text("* this is the one and only \"Your Sanctuary\" location")
			cutscene:text("* very unfortunate timing though cuz it's mine now")
			cutscene:wait(0.5)
			cutscene:text("* but i can tell you really want it!!![wait:5]\n* i can tell...")
			cutscene:text("* so take it from me...")
			Game.world.music:pause()
			Assets.playSound("3dprism_appear")
			local wave_mag = 0
			local function getFXWaveMag()
				return wave_mag
			end
			dd:addFX(ShaderFX("wave_interlace", {
				["wave_sine"] = function () return Kristal.getTime() * 100 end,
				["wave_mag"] = function () return getFXWaveMag() end,
				["wave_height"] = 2,
				["texsize"] = { SCREEN_WIDTH, SCREEN_HEIGHT }
			}), "funky_mode")
			Game.world.timer:during(15/30, function()
				dd.y = MathUtils.lerp(dd.y, dd_y - 40, 0.125)
				wave_mag = MathUtils.lerp(wave_mag, 120, 0.125)
			end)
			cutscene:wait(15/30)
			wave_mag = 60
			prism_sprite = Sprite("enemies/3d/idle", dd.x, dd_y)
			prism_sprite:setLayer(dd.layer)
			prism_sprite:play(1/30, true)
			prism_sprite:setOrigin(0.5, 1)
			prism_sprite:setScale(2, 2)
			prism_sprite:addFX(ShaderFX("wave_interlace", {
				["wave_sine"] = function () return Kristal.getTime() * 100 end,
				["wave_mag"] = function () return getFXWaveMag() end,
				["wave_height"] = 2,
				["texsize"] = { SCREEN_WIDTH, SCREEN_HEIGHT }
			}), "funky_mode")
			Game.world:addChild(prism_sprite)
			dd.visible = false
			Game.world.timer:during(15/30, function()
				wave_mag = MathUtils.lerp(wave_mag, 0, 0.25)
			end)
			cutscene:wait(15/30)
			wave_mag = 0
			cutscene:wait(1)
			cutscene:text("* IF YOU DARE!!!")
            Game:setFlag("prism_quick", true)
			Game:saveQuick()
		else
			cutscene:text("* let's just cut to the chase.")
			Game.world.music:pause()
			Assets.playSound("3dprism_appear")
			local wave_mag = 0
			local function getFXWaveMag()
				return wave_mag
			end
			dd:addFX(ShaderFX("wave_interlace", {
				["wave_sine"] = function () return Kristal.getTime() * 100 end,
				["wave_mag"] = function () return getFXWaveMag() end,
				["wave_height"] = 2,
				["texsize"] = { SCREEN_WIDTH, SCREEN_HEIGHT }
			}), "funky_mode")
			Game.world.timer:during(15/30, function()
				dd.y = MathUtils.lerp(dd.y, dd_y - 40, 0.125)
				wave_mag = MathUtils.lerp(wave_mag, 120, 0.125)
			end)
			cutscene:wait(15/30)
			wave_mag = 60
			prism_sprite = Sprite("enemies/3d/idle", dd.x, dd_y)
			prism_sprite:setLayer(dd.layer)
			prism_sprite:play(1/30, true)
			prism_sprite:setOrigin(0.5, 1)
			prism_sprite:setScale(2, 2)
			prism_sprite:addFX(ShaderFX("wave_interlace", {
				["wave_sine"] = function () return Kristal.getTime() * 100 end,
				["wave_mag"] = function () return getFXWaveMag() end,
				["wave_height"] = 2,
				["texsize"] = { SCREEN_WIDTH, SCREEN_HEIGHT }
			}), "funky_mode")
			Game.world:addChild(prism_sprite)
			dd.visible = false
			Game.world.timer:during(15/30, function()
				wave_mag = MathUtils.lerp(wave_mag, 0, 0.25)
			end)
			cutscene:wait(15/30)
			wave_mag = 0
			cutscene:wait(1)
		end
        cutscene:startEncounter("3d")
		prism_sprite:remove()
		dd.y = dd_y
		dd.visible = true
        cutscene:text("* ok you win this is unfinished so have the item")
		Assets.playSound("eb_keyitem")
        cutscene:text("* You got the [color:blue]Sound Stone[color:reset]!")
		Assets.stopSound("eb_keyitem")
        Game.inventory:addItem("sound_stone")
        Game.world.music:play()
		Game:setFlag("won_prism_1", true)
    end,
	obscenepath = function (cutscene)
		cutscene:text("* Oh[wait:5], this treacherous, [wait:5]crystalline path...")
		cutscene:text("* It seduced my soul with LIES!")
		cutscene:text("* CURSES![wait:5] A thousand CURSES upon this fractured vanity and the shadow it has cast!")
	end,
	seenThisMan = function (cutscene, event)
		local flag = Game:getFlag("interacted_with_random_guy")
		if flag==1 then
			cutscene:text("* The man... [wait:10]He told me...")
			cutscene:text("* He told me he wants to speak with you...")
			cutscene:text("* Have you [style:none][color:yellow][sound:creepyJingle]looked between the rooms?")
			Game:setFlag("interacted_with_random_guy", 2)
			return
		elseif flag == 2 then
			cutscene:text("* Heed my advice.")
			return
		elseif flag == 5 then
			cutscene:text("* Guess I'm just crazy.")
			return
		end

		cutscene:text({"* Have you seen this man?",
		"* The others swear I'm crazy, [wait:5]but I know I've seen him!",
		"* (The man gives you a flyer.)",
		"* (The man in the flyer looks all the familiar, [wait:5]yet forgettable.)",
		"* Have you seen him?"})
		local ch = cutscene:choicer({"Yes", "No"})
		if ch == 1 then
			cutscene:text("* You've seen him!? [wait:10]Alas, [wait:5]I speak the truth!")
			Game:setFlag("interacted_with_random_guy", 1)
		else
			cutscene:text("* No? [wait:10]Oh, [wait:5]well, [wait:5]that's a shame.")
			cutscene:text("* If you see him, [wait:5]please let me know.")
			Game:setFlag("interacted_with_random_guy", 5)
		end
	end,
	chase = function(cutscene)
		Game.world.music:fade(0, 2)
		local kris = cutscene:getCharacter("kris")
		local susie = cutscene:getCharacter("susie")
		local ralsei = cutscene:getCharacter("ralsei")
		local jamm = cutscene:getCharacter("jamm")

		cutscene:text("* Hey, [wait:5]wait.", "neutral_side", susie)
		cutscene:text("* I'm starting to think this is more than just another Dark World.", "neutral_side", susie)
		cutscene:text("* What do you mean?", "small_smile", ralsei)
		cutscene:text("* Like, [wait:5]it feels.. [wait:10]More???[wait:10][face:sus_nervous] Like a big Dark World?", "neutral", susie)
		--
		--
		if jamm then
			cutscene:text("* I don't really know about this [wait:5]\"Dark World\" [wait:5]stuff.", "neutral", jamm)
			cutscene:text("* But you're right, [wait:5]this place [wait:3]IS[wait:3] pretty expansive...", "look_left", jamm)
		end
		cutscene:text("* It appears so...", "pensive", ralsei)
		cutscene:text("* I am more worried of the prophec", "pensive", ralsei, {auto = true})
		Assets.playSound("sussurprise")
		susie:shake()
		susie:setSprite("exasperated_right")
		cutscene:text("* SCREW the prophecy, [wait:5]Ralsei!", "teeth_b", susie)
		cutscene:text("* I just wanna get out of here!", "teeth_b", susie)
		cutscene:text("* I don't want to sit here, [wait:5]and do nothing!", "teeth_b", susie, {auto = true})
		Assets.playSound("ghostappear")
		cutscene:wait(2)
		susie:resetSprite()
		susie:setFacing("down")
		cutscene:text("* ...Did you guys hear that?", "sus_nervous", susie)
		susie:setSprite("surprise_step")
		cutscene:text("* Wait, [wait:5]what is THAT?", "sad", susie)
		local h = cutscene:spawnNPC("cultist1",1000, 880)
		h:setAnimation("idle")
		h.layer = 99999999999
		local t = Game.world.timer:every(1/7, function()
			local image = AfterImage(h.sprite, 0.5, 0.02)
			image.physics.speed = 2
			Game.world:addChild(image)
		end)
		local ox, oy = Game.world.camera.x, Game.world.camera.y 
		cutscene:wait(cutscene:panTo(1000, Game.world.camera.y, 1.5, 'out-circ'))
		h:slideTo(1720, h.y, 2, 'in-back')
		cutscene:wait(2)
		cutscene:panTo(ox, oy, 2, 'out-cubic')
		cutscene:detachFollowers()
		susie:setSprite("point_right")
		Game.world.music:play("cultchase", 1)
		cutscene:text("* HEY, [wait:5]GET BACK HERE!", "angry_e", susie)
		susie:resetSprite()
		cutscene:walkTo(susie, 1720, 880, 3)
		cutscene:wait(1)
		cutscene:text("* S-[wait:5]Susie, [wait:5]wait!", "concern", ralsei)
		cutscene:walkTo(ralsei, 1720, 880, 3)
		cutscene:wait(1)
		if jamm then
			cutscene:text("* Well, [wait:5]guess we're doing this.", "stern", jamm)
			
			jamm:walkTo(1720, 880, 3)
		end
		cutscene:attachCamera()
		Game.world.map:doBullets()
		Game.world.timer:cancel(t)
		Game:setFlag("chase_cutscene_prog", 1)
	end,
	postchase = function (cutscene)
		local kris = cutscene:getCharacter("kris")
		local susie = cutscene:getCharacter("susie")
		local ralsei = cutscene:getCharacter("ralsei")
		local jamm = cutscene:getCharacter("jamm")
		ralsei.y = 340
		cutscene:detachFollowers()
		if jamm then jamm.y = 380 end
		susie.x = 90
		susie:setSprite("point_right")
		cutscene:text("* HEY, [wait:5]YOU!", "angry_c", susie)
		cutscene:text("* YOU CAN'T RUN! [wait:10]GET BACK HERE!", "angry_d", susie)
		susie:resetSprite()
		cutscene:panTo(800, Game.world.camera.y, 2, 'in-out-cubic')
		cutscene:wait(cutscene:walkTo(susie, 520, susie.y, 1))
		cutscene:wait(cutscene:walkTo(susie, 780, 280, 1))
		
		Game.world.music:pause()
		local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
		rect:setColor(COLORS.black)
		rect:setParallax(0)
		rect.layer = WORLD_LAYERS["ui"] - 2
		Game.world:addChild(rect)
		Kristal.hideBorder(0)
		local g = cutscene:getCharacter("guei")
		local origlayer = g.layer
		g:setLayer(rect.layer + 1)
		g:addFX(ColorMaskFX(COLORS.white))
		cutscene:wait(20/30)
		local slash_delay = 12/30
		local total_damage = 0
		local waw = DamageNumber("damage", total_damage, g.x, g.y - 20)
		waw.font = Assets.getFont("damage-cult")
		waw.layer = g.layer + 3
		Game.world:addChild(waw)
		for i = 1, 30 do
			local spr = Sprite("effects/attack/red_slash")
			spr:setOrigin(0, 0.5)
			spr:setPosition(g.x, g.y - g.height)
			Game.world:addChild(spr)
			spr.layer = g.layer + 1
			spr.rotation = math.rad(i * 78)
			spr:play(1/15, false, function() spr:remove() g:shake() end)
			local damage_scale = 1 + ((i - 1) / 14) * 4
			total_damage = total_damage + love.math.random(
				math.floor(50 * damage_scale),
				math.floor(100 * damage_scale)
			)
			waw.amount = total_damage
			waw.text = tostring(total_damage)
			waw.width = waw.font:getWidth(waw.text)
			waw.kill_timer = 0
			waw.killing = false
			waw.kill = 0
			Assets.playSound("bigcut", 1, 2 - (i / 30))
			cutscene:wait(slash_delay)
			slash_delay = math.max(1/60, slash_delay * 0.82)
		end

		cutscene:wait(2)
		rect:remove()
		g:removeFX(ColorMaskFX())
		Assets.playSound("snd_closet_impact", 1, 1)
		Assets.playSound("imbue_hit", 1, 1)
		
		local sm = SmokeFx(g.x-10, g.y - g.height/2, 2, 1.5)
		Game.world:spawnObject(sm)
		g.layer = origlayer
		sm:setLayer(g.layer + 1)
		Game.world.camera:shake(10, 0, 0.5, 10, 10) 
		        local static_fx = ShaderFX("static_bullet", {
            ["time"] = function() return Kristal.getTime() end,
            ["brightness"] = 2
        })
		
        local waw = DamageNumber("msg", "imbued", g.x + g.width/2, g.y)
        waw.layer = 99999999
        Game.world:addChild(waw)
        waw:addFX(static_fx, "static_fx")
		g:addFX(static_fx, "static_fx")
		local spr = Sprite("enemies/creature_a/eye", 1016, 285)
		spr:setOrigin(0.5, 0.5)
		spr:setScale(2)
		spr.graphics.spin = 0.01
		spr:setLayer(g.layer + 10)
		spr.alpha = 1
		Game.world:addChild(spr)
		Game.world.timer:tween(2, spr.graphics, {spin = 0.2}, 'out-circ', function()
		end)

		Game.world.timer:tween(2, spr, {scale_x = 20, scale_y = 20, alpha = 0}, 'out-circ', function()
			spr:remove()
		end)


		susie:setSprite("surprise_step")
		susie:shake()
		--cutscene:("")
		cutscene:wait(2)
		cutscene:text("* [speed:0.5]What... [wait:5]Is that...?", "sad", susie)
		Game.world.music:play("GALLERY", 0.5, 1)
		cutscene:wait(cutscene:walkTo(ralsei, 520, ralsei.y, 2))
		cutscene:wait(cutscene:walkTo(ralsei, 780, 320, 1))
		ralsei:shake()
		ralsei:setSprite("shocked_right")
		cutscene:text("* N-","terrified_up", ralsei)
		cutscene:text("[shake:0.62][speed:0.5]* No... [speed:1]No, [wait:5]No, [wait:5][shake:1]NO...!", "terrified_up", ralsei)
		cutscene:walkTo(kris, 780, kris.y, 2)
		local a = cutscene:walkTo(jamm, 780, jamm.y, 2)
		cutscene:text("[shake:0.62][speed:0.5]* Has the roaring already begun...?![wait:10]\nThe prophecy is-", "terrified_up", ralsei, {auto = true})
		cutscene:wait(a)
		cutscene:text("* Ralsei, [wait:5]the prophecy doesn't matter right now!", "stern", jamm)
		cutscene:text("* [shake:0.4]This thing looks like it's in pain!", "worried", jamm)
		cutscene:text("[shake:0.62][speed:0.5]* But how...?", "terrified_up", ralsei)
		cutscene:text("[shake:0.62][speed:0.5]* I don't think- [wait:10]Did-", "terrified_up", ralsei, {auto = true})
		Assets.playSound("weaponpull_fast")
		susie:setSprite("point_right")
		cutscene:slideTo(susie, susie.x+30, susie.y, 1, 'out-expo')
		cutscene:text("* They made a fountain INSIDE this thing!", "angry_unsure", susie)
		cutscene:text("* Kris, [wait:5]Ralsei, [wait:5]Jamm, [wait:5]let's do this.", "angry_teeth", susie)
		g.layer = Game.world.fader.layer + 1
		sm:fadeOutAndRemove(2)
		Game.world.music:fade(0, 1.5)
		Game.world.timer:tween(1, Game.world.fader, {alpha = 0.5})
		cutscene:wait(cutscene:panTo(1000, Game.world.camera.y, 2, 'linear'))
		local spr = Sprite("enemies/creature_a/eye", 1016, 285)
		spr:setOrigin(0.5, 0.5)
		spr:setScale(2)
		spr.graphics.spin = 0.01
		spr:setLayer(g.layer + 1)
		spr.alpha = 0
		Game.world:addChild(spr)
		Game.world.timer:tween(1, spr.graphics, {spin = 0.15}, 'in-cubic', function()
			Game.world.timer:tween(2, spr.graphics, {spin = 0.05}, 'out-cubic')
		end)
		local function circleAura()
			local aura = Sprite("effects/darksmoke")
			aura:addFX(ColorMaskFX(COLORS.white), "color")
			Game.world:addChild(aura)
			aura.layer = spr.layer - 0.1
			aura:setOrigin(0.5, 0.5)
			aura:setPosition(spr.x, spr.y)
			aura:setScale(1)
			for i = 1, 5 do
				local image = AfterImage(aura, 0.7, 1/30)
				image:addFX(ColorMaskFX(COLORS.white), "color")
				image.graphics.grow_x = i / 5
				image.graphics.grow_y = i / 5
				Game.world:addChild(image)
			end
			Game.world.timer:tween(3, aura, {scale_x = 30, scale_y = 30, alpha = 0}, 'out-expo', function() 
				aura:remove() 
			end)
		end
		Game.world.timer:tween(1, spr, {scale_x = 6, scale_y = 6, alpha = 1}, 'in-cubic', function()
			circleAura()
			Game.world.timer:tween(1, Game.world.fader, {alpha = 0}, 'out-expo')
			Game.world.timer:tween(2, spr, {scale_x = 2, scale_y = 2}, 'out-cubic')
		end)
		cutscene:wait(1/3)
		Assets.playSound("great_shine",1, 0.75)
		Assets.playSound("eye_telegraph",1, 0.75)
		
		cutscene:wait(3)
		g.layer = origlayer
		cutscene:wait(cutscene:fadeOut(1, {music = true}))
		cutscene:wait(cutscene:slideTo(spr, 1231, 197, 2, 'in-out-cubic'))
		Game:setFlag("chase_cutscene_prog", 2)
		Game:setFlag("imbued_battle_fading", true)
		Game:getPartyMember("susie"):setFlag("serious", true)
		Game:getPartyMember("jamm"):setFlag("serious", true)
		cutscene:startEncounter("creature_a", nil)
		Game:setFlag("creature_a_defeat", true)
		jamm:setPosition(jamm.x, jamm.y + 40)
		g:remove()
		spr:remove()
		cutscene:fadeIn(0.01, {music = false})

		----Post battle
		Game:getPartyMember("susie"):setFlag("serious", false)
		Game:getPartyMember("jamm"):setFlag("serious", false)
		kris:setSprite("battle/defeat")
		jamm:setSprite("battle/defeat")
		susie:setSprite("battle/defeat")
		cutscene:wait(1)
		Assets.playSound("damage", 0.7, 1)
		ralsei:setSprite("shocked_right_landed_2")

		cutscene:slideTo(ralsei, ralsei.x - 25, ralsei.y, 0.5, 'out-expo')
		cutscene:wait(0.2)
		ralsei:setSprite("fall_wince")
		cutscene:wait(1.8)
		susie:shake() Assets.playSound("wing") 
		cutscene:text("[shake:0.52]* Ralsei...", "bangs/down", susie)
		cutscene:text("[shake:0.52]* ...[wait:5]What was that?", "concerned", susie)
		cutscene:text("[shake:0.52]* You haven't used that one before.", "concerned", susie)
		ralsei:shake() Assets.playSound("wing")
		cutscene:text("[noskip]* Susie, [wait:5]I...", "shock", ralsei, {auto = true})
		cutscene:text("[noskip]* Ralsei, [wait:5]Didn't we just go over this.", "bangs/down", susie)
		
		cutscene:text("[noskip]* I-", "shock", ralsei)
		cutscene:text("[noskip]* Susie, [wait:5]I-", "shock", ralsei)

		cutscene:text("[noskip]* I didn't-", "shock", ralsei, {auto = true})
		cutscene:text("[noskip][speed:1.05]* I-", "shock", ralsei, {auto = true})
		cutscene:text("[noskip][speed:1.10]* Susie I-", "shock", ralsei, {auto = true})
		cutscene:text("[noskip][speed:1.2]* I didn't-", "shock", ralsei, {auto = true})
		cutscene:text("[noskip][speed:1.3]* Susie, [wait:5]I can explain-", "shock", ralsei, {auto = true})
		cutscene:text("[noskip][speed:1.5]* It was on instinct and-", "shock", ralsei, {auto = true})
		cutscene:text("[noskip][speed:1.7]* I didn't-", "shock", ralsei, {auto = true})
		
		cutscene:wait(1)
		ralsei:setSprite("fall_back_stare")
		ralsei:shake() Assets.playSound("wing")
		cutscene:text("* Susie. [wait:10]You saw the ending of the prophecy, [wait:5]did you not.", "down", ralsei)
		
		cutscene:text("* I see now that...", "down", ralsei)
		ralsei:setSprite("fall_cry")
		cutscene:text("* Holding back puts us all in danger.", "down_alt", ralsei)
		ralsei:setSprite("fall_crycover")
		cutscene:text("* If the prophecy isn't going as planned then-", "down_smile", ralsei)
		cutscene:text("* Maybe it's okay.", "down_eyes_tears", ralsei)
		cutscene:text("* Maybe we can change things.", "down_eyes_tears", ralsei)

		cutscene:text("* We better...", "shaded_neutral", jamm)
		cutscene:wait(1)
		cutscene:text("[shake:0.52]* Jamm, [wait:5]are you okay?", "disappointed_side", ralsei)

		cutscene:wait(1) jamm:shake() Assets.playSound("wing") jamm:resetSprite()
		cutscene:wait(1)
		cutscene:wait(cutscene:walkTo(jamm, 980, 365, 2.5))
		cutscene:text("* If there are more of those things out there, [wait:5]and they find her, [wait:5]I...", "dejected", jamm)
		cutscene:text("[shake:0.7]* I- [wait:5]I-", "dejected_frown", jamm)
		susie:resetSprite() Assets.playSound("wing") susie:shake()
		cutscene:text("* Jamm...", "disappointed_side", ralsei)
		cutscene:wait(1)
		ralsei.actor.default = "walk_unhappy"
		ralsei:resetSprite() Assets.playSound("wing") ralsei:shake(2)
		cutscene:wait(1)
		cutscene:text("* Jamm, [wait:5]we'll get there before that.", "disappointed_smile", ralsei)
		kris:resetSprite() Assets.playSound("wing") kris:shake()
		jamm:setFacing("left")
		cutscene:text("[speed:0.7]* Will we?", "dejected", jamm)
		cutscene:text("[speed:0.7]* Because your [wait:5]\"prophecy\" [wait:5]seems pretty useless right now.", "dejected_front", jamm)
		cutscene:walkTo(susie, 885, 345, 1)
		cutscene:text("* Hey man, [wait:5]I also have someone I'm looking for.", "annoyed_down_alt", susie)
		cutscene:text("* If you stay this worked up, [wait:5]things are only gonna get worse.", "annoyed_down_alt", susie)
		cutscene:text("* We'll find Noelle and your daughter.", "annoyed_smile", susie)
		
		cutscene:text("* ...", "dejected", jamm)
		cutscene:text("* Thank you, [wait:5]Susie.", "stern", jamm)
		cutscene:text("* Let's keep moving.", "stern", jamm)
		cutscene:wait(cutscene:walkTo(ralsei, 885, 390, 1))
		cutscene:walkTo(ralsei, 1400, ralsei.y, 2)
		cutscene:wait(ralsei.x == jamm.x)
		jamm:setFacing("down")
		cutscene:wait(1)
		jamm:setFacing("right")
		cutscene:wait(2)
		jamm:setFacing("left")
		cutscene:wait(1)
		
		cutscene:walkTo(jamm, 1400, jamm.y, 2)

		local spr = Sprite("effects/shine_white")
		spr:setOrigin(0.5)
		spr:setScale(2)
		Game.world:spawnObject(spr)
		spr:setPosition(kris.x + 200, kris.y)
		spr.alpha = 0
		cutscene:wait(cutscene:walkTo(susie, 1400, susie.y, 2))
		cutscene:wait(cutscene:walkTo(kris, kris.x + 100, kris.y, 1))
		spr:fadeToSpeed(1, 2)
		cutscene:wait(1)
		cutscene:wait(cutscene:walkTo(
			kris,
			spr.x - 20,
			spr.y,
			1
		))

		spr:play(1/3, true)
		cutscene:wait(1)
		cutscene:text("* (Nobody has noticed that the enemy dropped something.)")
		cutscene:text("* (Instinctively, [wait:5]you pick it up.)")
		cutscene:text("* (This object was black in color. [wait:10]Like tinted glass.)")
		cutscene:text("* (You can't help but feel the urge to keep it.)")
		spr:remove()
		Mod:setDarkShard(Mod.DarkShardID.SecondSanctuary, true)
		Game.stage:addChild(ShardGetController(Mod.DarkShardID.SecondSanctuary))
		cutscene:wait(1)
		cutscene:wait(cutscene:walkTo(kris, 1400, kris.y, 2))
		cutscene:wait(cutscene:mapTransition("1_2nd_sanctuary/second_sanctum_11_exit", "entry"))
		Game.party[1].health = 1

		for i = 2, 4 do
			Game.party[i].health = Game.party[i]:getStat("health")
		end
		

	end,
	jamm_book = function (cutscene, event)
		Game:setFlag("jamm_has_glasses", true)
		if not event.talked_to then
			cutscene:text("* Hey Kris, [wait:5]take a look at this.", "neutral", "jamm")
			cutscene:text("* ...You got any ideas on what that means?", "look_left", "jamm")
			event.talked_to = true
		else
			cutscene:text("* Why are you looking at me like a confused dog?", "neutral", "jamm")
			cutscene:text("* Are you...[wait:10] not reading the same thing as I am?", "nervous_left", "jamm")
		end
		Game:setFlag("jamm_has_glasses", false)
	end,
	travel_unlock = function (cutscene, event)
		Game:setFlag("unlock_travel", true)
		local kris = cutscene:getCharacter("kris")
		local susie = cutscene:getCharacter("susie")
		local ralsei = cutscene:getCharacter("ralsei")
		local jamm = cutscene:getCharacter("jamm")
		
		cutscene:wait(function() return jamm.state_manager.state == "WALK" end)
		cutscene:detachFollowers()
		cutscene:walkTo(kris, "kristo", 0.5, "down")
		cutscene:walkTo(susie, "susieto", 0.5, "down")
		cutscene:walkTo(ralsei, "ralseito", 0.5, "down")
		cutscene:wait(cutscene:walkTo(jamm, "jammto", 0.5, "down"))
		cutscene:text("* ...", "sus_nervous", "susie")
		cutscene:look(susie, "left")
		cutscene:look(ralsei, "left")
		cutscene:look(jamm, "right")
		susie.flip_x = true
		susie.x = susie.x - 10
		cutscene:setSprite(susie, "turn_around")
		Assets.playSound("whip_hard")
		susie:shake(4)
		cutscene:wait(0.6)
		cutscene:text("* Damn it,[wait:5] Kris![wait:10]\n* You got us trapped!", "teeth_b", "susie")
		cutscene:text("* I'm not so sure about that,[wait:5] Susie...", "look_left", "jamm")
		susie:resetSprite()
		susie.flip_x = false
		susie.x = susie.x + 10
		cutscene:text("* ...Huh?", "nervous", "susie")
		cutscene:wait(cutscene:walkTo(jamm, jamm.x, jamm.y + 40, 0.5, "right"))
		cutscene:look(kris, "left")
		cutscene:text("* Kris,[wait:5] when I was reading those books,[wait:5] I found something...", "look_left", "jamm")
		cutscene:text("* Maybe it could be used to help get us out of here?", "neutral", "jamm")
		cutscene:text("* Jamm gave you the [color:yellow]TRAVEL BUTTON[color:white].")
		Assets.playSound("egg")
		cutscene:text("* [color:yellow]TRAVEL BUTTON[color:white] has been added to your [color:yellow]MENU[color:white].")
		cutscene:look(kris, "down")
		cutscene:interpolateFollowers()
		cutscene:attachFollowersImmediate()
	end,
	jamm_lore = function (cutscene)
		local susie = cutscene:getCharacter("susie")
		local ralsei = cutscene:getCharacter("ralsei")
		local jamm = cutscene:getCharacter("jamm")
		cutscene:enableMovement()
		Game.world.player.force_walk = true
		cutscene:text("[noskip]* So, uh, [wait:5]Jamm, [wait:5]right?[wait:60]", "nervous", susie, {auto = true})
		cutscene:text("[noskip]* Yeah.[wait:30]", "neutral", jamm, {auto = true})
		cutscene:text("[noskip]* Where exactly did you, [wait:5]uh... [wait:10]Come from?[wait:20]", "nervous", susie, {auto = true})
		cutscene:text("[noskip]* Kris and I haven't seen you at all in Hometown.[wait:60]", "nervous_side", susie, {auto = true})
		cutscene:text("[noskip]* Well, [wait:5]we come from Frivatown, [wait:5]actually.[react:1][react:2][wait:60]", "look_left", jamm, {auto = true,
		reactions = {
			{"\"We\"?", "leftmid", "bottom", "surprise_neutral", "ralsei"},
			{"His daughter, dumbass.", "rightmid", "bottom", "neutral", "susie"},
		}})
		cutscene:text("[noskip]* Haven't heard of it.[wait:25]", "nervous", susie, {auto = true})
		cutscene:text("[noskip]* I mean, [wait:5]it's not exactly the most popular town.[wait:10]", "neutral", jamm, {auto = true})
		cutscene:text("[noskip]* It's quite small, [wait:5]too. [wait:10][face:look_left]But I think that's good.[wait:20]", "neutral", jamm, {auto = true})
		cutscene:text("[noskip]* Anyways, [wait:5]We were on the way to visit some relatives...[wait:20]", "neutral", jamm, {auto = true})
		Game.world.music:fade(0, 2)
		cutscene:wait(3)
		Game.lock_movement = true
		Game.world:getEvent("stairlooper"):remove()	
		local side = 1
		if Game.world.player.moving_x > 0 or Game.world.player:getFacing() == "right" then
			side = -1
		end
		if Game.world.camera.x + 400*side >= 1840 then
			Game.world.player.x = Game.world.player.x - 400
			for _, follower in ipairs(Game.world.followers) do
				follower.x = follower.x - 400
				for _,point in ipairs(follower.history) do
					point.x = point.x - 400
				end
			end
			for _, fog in ipairs(Game.world:getEvents("churchfog")) do
				fog.xx = fog.xx + 400 / 2
			end
			Game.world.camera.x = Game.world.camera.x - 400
		elseif Game.world.camera.x + 400*side <= 960 then
			Game.world.player.x = Game.world.player.x + 400
			for _, follower in ipairs(Game.world.followers) do
				follower.x = follower.x + 400
				for _,point in ipairs(follower.history) do
					point.x = point.x + 400
				end
			end
			for _, fog in ipairs(Game.world:getEvents("churchfog")) do
				fog.xx = fog.xx - 400 / 2
			end
			Game.world.camera.x = Game.world.camera.x + 400
		end
		cutscene:text("[noskip]* We needed to stop for the night, [wait:5]so we ended up in Hometown.[wait:30]", "neutral", jamm, {auto = true})
		cutscene:text("[noskip]* I noticed Marcy was gone, [wait:5]so I followed her trail of crackers...[wait:30]", "look_left", jamm, {auto = true})
		cutscene:text("[noskip]* [wait:3].[wait:2].[wait:1].and it led to this church.[wait:30]", "stern", jamm, {auto = true})
		cutscene:panTo(Game.world.camera.x + 200*side, Game.world.camera.y, 2)
		jamm:setFacing("up")
		cutscene:text("[noskip]* What was odd to me, [wait:5]and in hindsight, [wait:5]maybe not to you...[wait:25]", "stern", jamm, {auto = true})
		cutscene:text("[noskip]* Was that when I opened the doors, [wait:5]I couldn't see... [wait:10][speed:0.65]anything.[wait:25]", "stern", jamm, {auto = true})
		cutscene:text("[noskip]* But Marcy was in there, [wait:5]so I figured I should follow.[wait:40]", "stern", jamm, {auto = true})
		cutscene:wait(cutscene:attachCamera())
		Game.lock_movement = false
		Game.world.player.force_walk = false
		Game:setFlag("jamm_lore_done", true)
	end,
	secondsanctuary_ripple = function (cutscene)
		local a = Game.world.player
		Game:setFlag("ripple2nd", false)
		cutscene:wait(cutscene:walkTo(a, a.x, a.y-20, 1, nil, true))
		Game.world.music:fade(0, 2)
		cutscene:wait(3)
		Assets.playSound("jump")
		a:setSprite("ball")
		a.sprite:play(1/7, true)
		a.physics.speed_y = -12
		a.physics.gravity = 1
		a.collidable = false
		cutscene:wait(1.5)
		a.collidable = true
		a.physics.speed_y = 0
		a.physics.gravity = 0
		Game.world.map:doIntro()
		Game.lock_movement = false
		cutscene:wait(function () return (Game:getFlag("ripple2nd") == true) end)
		cutscene:text("G")
	end
}
