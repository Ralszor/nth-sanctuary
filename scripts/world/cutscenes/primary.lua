return {
    intro = function (cutscene, should_skip_entire_intro, fader)
		local susie, ralsei, kris = cutscene:getCharacter("susie"),cutscene:getCharacter("ralsei"),cutscene:getCharacter("kris")
		if not should_skip_entire_intro then
			Kristal.hideBorder(0)
			local function centerText(str)
				local text = DialogueText(str, 0, 16, 640, 480,
										  { align = "center" })
				text.layer = WORLD_LAYERS["top"] + 100
				text.parallax_x = 0
				text.parallax_y = 0
				Game.world:addChild(text)

				text.advance_callback = function ()
					Game.world.timer:tween(1, text, { alpha = 0 }, "linear", function ()
						text:remove()
					end)
				end

				cutscene:wait(function () return text:isRemoved() end)
			end
		end
        for _, save in ipairs(Game.world.map:getEvents("savepoint")) do
            save.visible = false
        end
		Game.world.music:stop()
		local f = fader
        cutscene:fadeOut(0)
        susie.x = 550
        kris.x = 630
        ralsei.x = 260
        kris.y = 400
        susie.y = 400
		local kris_x = kris.x
		local susie_x = susie.x
		local kris_y = kris.y
		local susie_y = susie.y
		local ralsei_y = ralsei.y
		local kris_layer = kris.layer
		local susie_layer = susie.layer
		local ralsei_layer = ralsei.layer
		local do_ripple = false
		local skip_title = should_skip_entire_intro or false
		cutscene:detachFollowers()
		if not skip_title then
			cutscene:wait(3)
			f:remove()
			Assets.playSound("ch4_first_intro", MUSIC_VOLUME, 1)
			local remove = {}
			local sum = 85
			for i = 1,9 do
				local letter = Sprite("logo_letter_"..i)
				letter:setScale(2)
				letter:setParallax(0)
				letter:setOrigin(0, 1)
				letter.layer = 1000
				letter.alpha = 0
				Game.world:addChild(letter)
				Game.world.timer:tween(0.5, letter, {alpha = 1})
				letter.x = sum
				letter.y = SCREEN_HEIGHT/2
				--Assets.playSound("noise")
				cutscene:wait(1/10)
				sum = sum + (letter.width*2) + 12
				table.insert(remove, letter)
			end
			--ok look i know you might be mad at this code but lucid made it so much fucking harder than it had to be, okay? EDIT: ok jamm thank you for not making me do the terrible numbers. -mason
			for i = 1,9 do
				cutscene:wait(12/38-1/10)
			end
			local heart = Sprite("logo_heart")
			heart:setScale(2)
			heart:setParallax(0)
			heart:setOrigin(0.5, 0.5)
			heart.layer = 1000
			heart.noprop = true
			Game.world:addChild(heart)
			heart.x = 85 + 224
			heart.y = SCREEN_HEIGHT/2 - 34
			local grad = Sprite("logo_gradient")
			grad:setScale(2)
			grad:setParallax(0)
			grad:setOrigin(0.5, 0.5)
			grad:setColor(COLORS.white)
			grad.layer = 1000 + 1
			grad.noprop = true
			grad.alpha = 0
			Game.world:addChild(grad)
			grad.x = 85 + 224
			grad.y = SCREEN_HEIGHT/2 - 34
			table.insert(remove, grad)
			cutscene:wait(54/19) --(no longer) evil
			Game.world.timer:after(1.2, function()
				Game.world.timer:tween(1, grad, {alpha = 1}, "linear")
			end)
			cutscene:wait(1.2)
			local a = Text("#th Sanctuary")
			a.layer = 1000
			a:setOrigin(0, 0)
			a:setScale(2)
			local fake_fade = Rectangle(130, 240, 400, 200)
			fake_fade:setColor(COLORS.black)
			fake_fade:setOrigin(0, 0)
			fake_fade.alpha = 1
			fake_fade.layer = 99999999999
			a.x, a.y = 140, 244
			a:addFX(ProphecyScrollFXAlt(3), "prop")
			Game.stage:addChild(a)
			Game.stage:addChild(fake_fade)
			Game.world.timer:tween(2, fake_fade, {alpha = 0}, 'linear', function() fake_fade:remove() end)
					
			--Assets.playSound("bell_bounce_short")
			for _, sprite in ipairs(remove) do
				if not sprite.noprop then
					Game.world.timer:after(1/30, function()
						sprite:addFX(ProphecyScrollFX(nil, 2), "prop")
						sprite:addFX(AlphaFX(0.7, 1), "alpha")
					end)
				end
			end
			cutscene:wait(9.3)
			for _, trans in ipairs(Game.world.map:getEvents("transition")) do
				trans.collider.collidable = false
			end
			for _, trans in ipairs(Game.world.map:getEvents("ft_transition")) do
				trans.collider.collidable = false
			end
			cutscene:detachCamera()
			kris.layer = a.layer + 1
			susie.layer = a.layer + 1
			kris:setParallax(0)
			susie:setParallax(0)
			kris.x = SCREEN_WIDTH/2 + 60
			susie.x = SCREEN_WIDTH/2 - 20
			kris.y = -40
			susie.y = -40
			local fakehsv = HSVShiftFX()
			fakehsv.hue_start = 60;
			fakehsv.sat_start = 0.4;
			fakehsv.val_start = 1;
			fakehsv.hue_target = 80;
			fakehsv.sat_target = 0.4;
			fakehsv.val_target = 1;
			fakehsv.hue = fakehsv.hue_start;
			fakehsv.sat = fakehsv.sat_start;
			fakehsv.val = fakehsv.val_start;
			fakehsv.wave_time = 1;
			fakehsv.amount = 0;
			local highlight = ChurchHighlightFX(0, ColorUtils.hexToRGB("#42D0FFFF"), {thickness = -1})
			kris:addFX(fakehsv, "fakehsv")
			susie:addFX(fakehsv, "fakehsv")
			ralsei:addFX(fakehsv, "fakehsv")
			kris:addFX(highlight, "fakehighlight")
			susie:addFX(highlight, "fakehighlight")
			ralsei:addFX(highlight, "fakehighlight")
			kris:setAnimation("jump_fall")
			susie:setAnimation("fall_brace")
			local windows = IntroFallingWindows()
			windows.layer = 998
			windows:addFX(fakehsv, "fakehsv")
			Game.world:addChild(windows)
			Game.world.timer:lerpVar(kris, "y", kris.y, SCREEN_HEIGHT/2 - 20, 10)
			Game.world.timer:lerpVar(susie, "y", susie.y, SCREEN_HEIGHT/2 - 20, 10)
			cutscene:slideTo(ralsei, "ralpoint",0.01)
			cutscene:wait(10/30)
			Assets.playSound("break1", 0.95, 1)
			kris.sprite:stop()
			susie.sprite:stop()
			for _, sprite in ipairs(remove) do
				sprite:remove()
			end
			Assets.stopSound("ch4_first_intro")
			heart.layer = 1003
			for i = 1,94 do
				local letter = Sprite("logo_shatter/logo_piece_"..i)
				letter:setScale(2)
				letter:setParallax(0)
				letter:setOrigin(0.5, 0.5)
				letter.layer = a.layer + 2
				letter.physics.speed = 5
				letter.physics.friction = 0.5
				letter.physics.direction = math.rad(90)
				letter.physics.gravity_direction = math.rad(270)
				Game.world.timer:after(10/30, function()
					letter.physics.gravity = 0.25 + MathUtils.random(0.1)
					letter.physics.friction = 0
					letter.physics.direction = math.rad(90 + MathUtils.random(-3, 3))
					if i > 47 then
						letter.physics.speed = 2 + (((94 - i) / 47) * 7)
					else
						letter.physics.speed = 2 + ((i / 47) * 7)
					end
					letter.layer = 1000
				end)
				Game.world:addChild(letter)
				letter.x = 85 + 224
				letter.y = SCREEN_HEIGHT/2 - 34
				table.insert(remove, letter)
			end	
			a.physics.speed = 5
			a.physics.friction = 0.5
			a.physics.direction = math.rad(90)
			a.physics.gravity_direction = math.rad(270)
			heart.physics.speed = 5
			heart.physics.friction = 0.5
			heart.physics.direction = math.rad(90)
			heart.physics.gravity_direction = math.rad(270)
			Game.world.timer:lerpVar(kris, "y", kris.y, kris.y + 15, 10, 2, "out")
			Game.world.timer:lerpVar(susie, "y", susie.y, susie.y + 15, 10, 2, "out")
			cutscene:wait(10/30)
			local heartburst = HeartBurst(heart.x - 224 + 106*2, heart.y - 34 + 20*2, COLORS.red)
			heartburst:setParallax(0)
			heartburst.layer = 1003
			Game.world:addChild(heartburst)
			heart:remove()
			cutscene.windvol = 0
			cutscene.windpitch = 0.01
			cutscene.dronevol = 0
			cutscene.dronepitch = 0.01
			local windsfx = Assets.playSound("strongwind_loop", 0, 1)
			windsfx:setLooping(true)
			windsfx:play()
			local dronesfx = Assets.playSound("dtrans_drone", 0, 1)
			dronesfx:setLooping(true)
			dronesfx:play()
			cutscene:during(function()
				if cutscene.windvol ~= cutscene.lastwindvol then
					windsfx:setVolume(cutscene.windvol)
					cutscene.lastwindvol = cutscene.windvol
				end
				windsfx:setPitch(cutscene.windpitch)
				if cutscene.dronevol ~= cutscene.lastdronevol then
					dronesfx:setVolume(cutscene.dronevol)
					cutscene.lastdronevol = cutscene.dronevol
				end
				dronesfx:setPitch(cutscene.dronepitch)
			end)
			kris:setAnimation("jump_fall")
			susie:setAnimation("jump_fall")
			Game.world.timer:tween(15/30, cutscene, {windvol = 0.5, windpitch = 1}, "linear")
			Game.world.timer:after(2/30, function() Assets.playSound("glassbreak", 0.4, 0.6) end)
			Assets.playSound("punchmed", 0.95, 0.7)
			Assets.playSound("ch4_first_intro_breaking", 0.5, 1)
			Assets.playSound("ch4_first_intro_breaking", 0.5, 0.94)
			Assets.playSound("ch4_first_intro_breaking", 0.25, 0.5)
			Assets.playSound("ch4_first_intro_breaking", 0.25, 0.44)
			a.physics.direction = math.rad(90 + MathUtils.random(-3, 3))
			a.physics.speed = -2
			a.physics.friction = 0
			a.physics.gravity = 0.25 + MathUtils.random(0.1)
			a.graphics.spin = math.rad(Utils.randomSign()/5)
			local shards_remove = {}
			for i = 1,15 do
				local groundshard = ProphecyGroundShard((SCREEN_WIDTH/2-199)+(i*399)/15+MathUtils.random(-30, 30), SCREEN_HEIGHT/2-34+MathUtils.random(60))
				groundshard:setParallax(0)
				groundshard.layer = 1000
				groundshard.ytarg = 10000
				Game.world:addChild(groundshard)
				table.insert(shards_remove, groundshard)
			end
			Game.world.timer:lerpVar(kris, "y", kris.y, kris.y + 50, 90, 3, "out")
			Game.world.timer:lerpVar(susie, "y", susie.y, susie.y + 50, 90, 3, "out")
			cutscene:wait(20/30)
			windows.window_timer = 1
			cutscene:wait(70/30)
			Game.world.timer:tween(15/30, windows, {darken = 1}, "in-cubic")
			Game.world.timer:tween(15/30, highlight, {alpha = 1.05}, "in-cubic")
			Game.world.timer:tween(15/30, cutscene, {dronevol = 0.4, dronepitch = 0.8}, "linear")
			local prophecies = IntroGigaProphecies()
			prophecies.layer = 997
			prophecies:addFX(fakehsv, "fakehsv")
			Game.world:addChild(prophecies)
			cutscene:wait(2)
			Game.world.timer:tween(10/30, cutscene, {dronevol = 0.6, dronepitch = 1}, "linear")
			a:remove()
			for _, sprite in ipairs(remove) do
				sprite:remove()
			end
			for _, shard in ipairs(shards_remove) do
				shard:remove()
			end
			local panel_container = Object(SCREEN_WIDTH/2 + 150/2, 500)
			panel_container:setParallax(0)
			panel_container.layer = 1002
			panel_container:addFX(fakehsv, "fakehsv")
			Game.world:addChild(panel_container)
			local panel = ProphecyPanel("backgrounds/IMAGE_DEPTH_EXTEND_MONO_SEAMLESS", "backgrounds/IMAGE_DEPTH_EXTEND_SEAMLESS", "initial2", "THE LEGEND OF THIS WORLD.\n<DELTARUNE.>", 150, 90)
			panel:setOrigin(0.5, 0.5)
			panel.sprite_offset_x = 49
			panel.sprite_offset_y = 61
			panel.text_offset_x = -160
			panel.text_offset_y = -16
			panel.no_back = true
			panel.fade_edges = true
			panel.ignore_onscreen_rules = true
			panel_container:addChild(panel)
			Game.world.timer:during(10/30, function()
				panel.panel_alpha = MathUtils.lerp(panel.panel_alpha, 1.2, 1 - (1 - 0.1) ^ DTMULT)
			end)
			Game.world.timer:tween(10/30, panel_container, {y = 250}, "linear")
			cutscene:wait(10/30)
			cutscene.windvol = 0
			cutscene.dronevol = 0
			windows.delta = 0.05
			prophecies.delta = 0.05
			panel.panel_alpha = -99
			Assets.playSound("break1", 0.95, 1)
			kris:setSprite("fall_hurt_1")
			susie:setAnimation("fall_brace")
			local broken_container = Object(panel_container.x - 150*2 + 49/2, panel_container.y - 90*2 + 34/2)
			broken_container:setParallax(0)
			broken_container.layer = 1002
			broken_container.draw_children_below = 0
			Game.world:addChild(broken_container)
			local sprites = Assets.getFrames("world/events/prophecy/shatter/prophecy_shatter_fall")
			for i, texture in ipairs(sprites) do
				local s = Sprite(texture)
				s:setScale(2)
				broken_container:addChild(s)
				s.alpha = 0.8
				s.physics.speed = 7
				s.physics.friction = 0.75
				s.physics.direction = math.rad(90 + MathUtils.random(-3, 3))
				s.physics.speed_x, s.physics.speed_y = s:getSpeedXY()
				if i == #sprites - 2 or i == #sprites - 4 then
					s.physics.speed_x = 0.5
				end
				if i == #sprites - 1 or i == #sprites - 3 then
					s.physics.speed_x = -0.5
				end
				s.physics.speed, s.physics.direction = s:getSpeedDir()
				s.physics.gravity_direction = math.rad(270)
				Game.world.timer:after(10/30, function()
					s.physics.gravity = 0.25 + MathUtils.random(0.1)
					s.physics.friction = 0
					s.physics.speed = 2 + (((#sprites - i) / #sprites) * 15)
					if i > (#sprites - 5) or i % 2 == 0 then
						s.layer = -1
					end
				end)
				s:addFX(fakehsv, "fakehsv")
			end
			Game.world.timer:after(10/30, function()
				for i = 1,30 do
					local groundshard = ProphecyGroundShard((panel_container.x - 150/2 - 199) + ((i * 398) / 30) + MathUtils.random(-30, 30), panel_container.y - 90/2 + MathUtils.random(120))
					groundshard.layer = 1000
					groundshard:setParallax(0)
					groundshard.ytarg = 10000
					Game.world.timer:after(280/30, function()
						groundshard:remove()
					end)
					Game.world:addChild(groundshard)
				end
				panel_container:remove()
			end)
			Game.world.timer:lerpVar(kris, "y", kris.y, kris.y + 5, 10, 2, "out")
			Game.world.timer:lerpVar(susie, "y", susie.y, susie.y + 5, 10, 2, "out")
			cutscene:wait(10/30)
			broken_container.layer = 1000
			Game.world.timer:after(2/30, function() Assets.playSound("glassbreak", 0.4, 0.6) end)
			Assets.playSound("sparkle_glock", 0.5, 0.8)
			Assets.playSound("sparkle_glock", 0.5, 0.71)
			Assets.playSound("punchmed", 0.95, 0.7)
			Assets.playSound("ch4_first_intro_breaking", 0.25, 0.25)
			Assets.playSound("ch4_first_intro_breaking", 0.25, 0.14)
			windows.delta = 1
			prophecies.delta = 1
			cutscene.windvol = 0.5
			cutscene.dronevol = 0.4
			Game.world.timer:tween(60/30, cutscene, {windpitch = 1.25}, "linear")
			Game.world.timer:tween(120/30, cutscene, {dronepitch = 1.5}, "linear")
			susie:setAnimation("jump_fall")
			kris:setAnimation("fall_hurt")
			cutscene.fall_hurt_frame = 0
			Game.world.timer:lerpVar(cutscene, "fall_hurt_frame", 0, 16, 70, 3, "out")
			Game.world.timer:tween(3/30, highlight, {thickness = 1}, "linear")
			Game.world.timer:lerpVar(kris, "y", kris.y, kris.y - 100, 90, 3, "out")
			Game.world.timer:lerpVar(susie, "y", susie.y, susie.y + 20, 90, 3, "out")
			Game.world.timer:tween(120/30, fakehsv, {amount = 1}, "in-cubic")
			Game.world.timer:during(60/30, function()
				kris.sprite.frame = (math.floor(cutscene.fall_hurt_frame % 4) + 1)
			end)
			Game.world.timer:during(120/30, function()
				local highlight_color = ColorUtils.mergeColor(ColorUtils.hexToRGB("#42D0FFFF"), ColorUtils.hexToRGB("#96CD6EFF"), fakehsv.amount)
				highlight:setColor(highlight_color[1], highlight_color[2], highlight_color[3], 1)
			end)
			cutscene:wait(60/30)
			kris.sprite.frame = 1
			kris:setAnimation("fall_hurt_wind")
			cutscene:wait(10/30)
			kris.fall_hurt_frame = nil
			cutscene:wait(110/30)
			local arch = Sprite("effects/foreground_arch_blur", 0, 480)
			arch.layer = 1100
			arch:setParallax(0)
			arch:setScale(2)
			arch:setOriginExact(0, 120)
			arch:setColor(COLORS.black)
			Game.world:addChild(arch)
			Game.world.timer:tween(4/30, arch, {y = 0}, "linear")
			Game.world.timer:tween(32/30, cutscene, {windvol = 0, windpitch = 0.5, dronevol = 0, dronepitch = 0.5}, "linear")
			cutscene:wait(16/30)
			do_ripple = true
			windows:remove()
			prophecies:remove()
			broken_container:remove()
			windsfx:stop()
			dronesfx:stop()
			Assets.playSound("snd_closet_impact")
			Assets.stopSound("ch4_first_intro_breaking")
			kris:setParallax(1)
			susie:setParallax(1)
			kris:removeFX("fakehighlight")
			susie:removeFX("fakehighlight")
			ralsei:removeFX("fakehighlight")
			kris:removeFX("fakehsv")
			susie:removeFX("fakehsv")
			ralsei:removeFX("fakehsv")
			for _, sprite in ipairs(remove) do
				sprite:remove()
			end
			for _, trans in ipairs(Game.world.map:getEvents("transition")) do
				trans.collider.collidable = true
			end
			for _, trans in ipairs(Game.world.map:getEvents("ft_transition")) do
				trans.collider.collidable = true
			end
			arch:remove()
		end	
		Game:getPartyMember("jamm"):setAmmo("rubber_pellet")
		kris.x = kris_x + 10
		kris.y = kris_y
		susie.x = susie_x + 10
		susie.y = susie_y
		kris.layer = kris_layer
		susie.layer = susie_layer
		ralsei.layer = ralsei_layer
        Game.world.camera.x = kris_x + 10 + (susie_x - kris_x)/2
		Game.world.camera.y = kris_y
        kris:setSprite("landed")
        susie:setSprite("landed")
		local ripple_fx
		if do_ripple then
			kris.layer = 1110
			susie.layer = 1110
			kris:shake(8)
			susie:shake(8)
			kris:setColor(COLORS.black)
			susie:setColor(COLORS.black)
			ripple_fx = RippleEffect()
			ripple_fx.layer = 1101
			Game.world:addChild(ripple_fx)
			ripple_fx:makeRipple(kris_x, kris_y, 100, COLORS.aqua, 220, 1, 18, 1101, 0, 1.05)
			ripple_fx:makeRipple(susie_x, susie_y, 100, COLORS.fuchsia, 220, 1, 18, 1101, 0, 1.05)
			cutscene:wait(120/30)
			kris.layer = kris_layer
			susie.layer = susie_layer
			ralsei.layer = ralsei_layer
			kris:setColor(COLORS.white)
			susie:setColor(COLORS.white)
			ripple_fx:remove()
		end
		Game:setFlag("version_info", Mod.info.version_info)
        Assets.playSound("him_quick")
        cutscene:fadeIn(1)
		Kristal.showBorder(1)
		cutscene:wait(1)
        susie:shake(4, 0, 1)
        Assets.playSound("wing")
        cutscene:wait(1)
        susie:shake(2, 0, 1)
        Assets.playSound("wing")
        susie:shake(1, 0, 1)
        Assets.playSound("wing")
        cutscene:wait(2)
        cutscene:setSpeaker(susie)
        cutscene:text("[facec:susie_bangs/down]* Ugh...[wait:10]\n* What the hell...")
        cutscene:wait(1)
        kris.sprite:setFrame(2)
        susie.sprite:setFrame(2)
        ralsei.sprite:setFrame(2)
		cutscene:wait(3/30)
        kris.sprite:setFrame(3)
        susie.sprite:setFrame(3)
        ralsei.sprite:setFrame(3)
		cutscene:wait(2/30)
		kris:resetSprite()
		susie:resetSprite()
		ralsei:resetSprite()
        cutscene:wait(0.7)
        susie:setFacing("up")
        cutscene:wait(0.7)
        susie:setFacing("right")
        cutscene:wait(0.7)
        susie:setFacing("down")
        cutscene:wait(1.2)
        susie:setFacing("right")
        cutscene:wait(1)
        cutscene:setSpeaker(susie)
        cutscene:wait(1)
        cutscene:text("* ... Hey,[wait:5] where are we,[wait:5] anyways?[wait:5] It looks like the church again,[wait:5] but...", "annoyed_down")
        		Game.world.music:play()
        cutscene:wait(1) 
        susie:setFacing("up")
        cutscene:wait(1)
        
        if Game:getFlag("route") == 1 or Game:getFlag("route") == 2 then
			cutscene:text("* Kris,[wait:5][func:turn0][wait:5] you're...[wait:10][func:turn] green?[wait:10] And I'm...[wait:10] uh...[wait:5][react:1]", "suspicious", {
				reactions = {
					{"(Hey, Kris!\nHelp me out here!)", "right", "bottom", "blush", "susie"},
				},
				functions = {
					turn0 = function(text)
						kris:setFacing("left")
					end,
					turn = function (text)
						susie:setFacing("right")
					end
				},
			})
			local choice = cutscene:choicer({"Blue", "Pink", "Susie"})
			if choice == 1 then
				cutscene:text("* And I'm blue.[wait:5] Got it.", "nervous_side")
				Game:setFlag("susiecolor", "blue")
			elseif choice == 2 then
				cutscene:text("* And I'm...[wait:5] pink.[wait:5]\n* Got it.", "nervous_side")
				Game:setFlag("susiecolor", "pink")
			else
				cutscene:text("* [face:nervous_side]And I'm Susi", "nervous_side", "susie", {auto = true})
				Assets.playSound("sussurprise")
				susie:shake()
				susie:setSprite("exasperated_right")
				cutscene:text("[speed:1.22]* I didn't mean my name,[wait:5] dumbass!![speed:1]", "teeth")
				Game:setFlag("susiecolor", "susie")
				susie:resetSprite()
				cutscene:setSpeaker(susie)
			end
        elseif Game:getFlag("route") == 3 then
			cutscene:text("* Kris,[wait:5][func:turn0][wait:5] you're...[wait:10][func:turn] green?[wait:10] And I'm...[wait:10] uh...[wait:5]", "suspicious", {
				functions = {
					turn0 = function(text)
						kris:setFacing("left")
					end,
					turn = function (text)
						susie:setFacing("right")
					end
				},
			})
			cutscene:text("* Blue.", "nervous_side")
			cutscene:text("* ... This is pretty weird,[wait:5] huh?", "nervous")
        end
        --uhh i'll commit up to this point dont touch this please :3
        susie:walkTo(susie.x - 40, susie.y, 1)
        cutscene:wait(1)
        susie:setSprite("away_hips")
        cutscene:wait(1)
        susie:setFacing("right")
        susie:resetSprite()
        susie:walkTo(susie.x + 60, susie.y, 1)
        cutscene:wait(1)
        cutscene:text("* Hey,[wait:5] wait a second...[wait:5]\n* Where's Ralsei?", "surprise_frown")
        cutscene:text("* Did the Knight", "sad", {auto = true})
        cutscene:setSpeaker(ralsei)
        cutscene:text("[shake:0.51][speed:0.8]* N-[wait:5]No...[wait:5] this can't be...")
        susie:setSprite("shock_left")
        susie:setFacing("left")
        cutscene:setSpeaker(susie)
        cutscene:text("* R-[wait:5] Ralsei!?", "surprise_frown")
        ralsei:resetSprite()
        ralsei:setFacing("up")
        cutscene:attachCamera()
        Game.world.camera.keep_in_bounds = false
        cutscene:wait(cutscene:panTo(220, 360, 2, "out-cubic"))
        susie:resetSprite()
        cutscene:wait(1)
        cutscene:setSpeaker(ralsei)
        cutscene:text("[shake:0.51][speed:0.8]* You may want to come here...", "horror")
        cutscene:text("[shake:0.51][speed:0.8]* (This is bad... [wait:10]No,[wait:5] this is [shake:0.81]VERY[shake:0.31] bad...)", "horror")
        cutscene:wait(cutscene:panTo(kris.x + (susie.x - kris.x)/2, kris.y, 2, "out-cubic"))
        cutscene:attachCamera()
        cutscene:wait(2)
        susie:setFacing("right")
        cutscene:setSpeaker(susie)
        cutscene:text("* We should see how he's doing...", "nervous")
        cutscene:text("* Ralsei sounds...[wait:10] uh...[wait:10] spooked?[wait:10] Terrified?[wait:10] Whatever...", "nervous_side")
        cutscene:walkTo(susie, susie.x-100, susie.y, 1.5)
        cutscene:wait(cutscene:walkTo(kris, kris.x-40, kris.y, 1.7))
        kris:shake(4, 0, 1)
        cutscene:detachCamera()
        kris.flip_x = true --?
        kris.layer = susie.layer - 0.01
        Assets.playSound("wing")
        susie:setFacing("right")
        kris:shake(6, 0, 1)
        susie:setSprite("surprise_step")
        kris:setSprite("sit")
        cutscene:text("* Kris![wait:10] You okay??", "surprise_frown")
        cutscene:text("* Yeesh,[wait:5] talk about a fall...[wait:10] (Even MY legs hurt a little.)", "dejected")
        susie:resetSprite()
        cutscene:wait(cutscene:walkTo(susie, kris.x-50, susie.y, 1))
        susie:setSprite("heal_kneel")
        cutscene:text("[facec:susie_bangs/down]* Here,[wait:5] hold still.[wait:5]\n* Let me...")
        Assets.playSound("wing")
        susie:setSprite("heal_kneel_arms")
        cutscene:wait(1/2)
        kris:flash()
        susie:flash()
        Game.world.timer:every(1/30, function()
            for i = 1, 2 do
                local x = kris.x + ((love.math.random() * kris.width) - (kris.width / 2)) * 2
                local y = kris.y - (love.math.random() * kris.height) * 2
                local sparkle = HealSparkle(x, y)
                sparkle:setLayer(WORLD_LAYERS["below_ui"])
                sparkle:setColor(COLORS.lime)
                Game.world:addChild(sparkle)
            end
        end, 4)
        Game.world.timer:every(1/30, function()
            for Kristal = 1, 2 do --                    <-- Evil moniey deletr
                local x = susie.x + ((love.math.random() * susie.width) - (susie.width / 2)) * 2
                local y = susie.y - (love.math.random() * susie.height) * 2
                local sparkle = HealSparkle(x, y)
                sparkle:setLayer(WORLD_LAYERS["below_ui"])
                sparkle:setColor(COLORS.lime)
                Game.world:addChild(sparkle)
            end
        end, 4)
        local dmg = DamageNumber("msg", "max",susie.x, susie.y,{COLORS.lime})
        dmg:setLayer(99999999999999999999999999)
        Game.world:addChild(dmg)
        Assets.playSound("power")
        cutscene:wait(1)
        susie:setSprite("heal_kneel")
        cutscene:wait(2)
        cutscene:text("* You,[wait:5] uh...[wait:10] Feel better?", "nervous")
        cutscene:choicer({"Yes", "Definitely", "Of course", "Yuhum"})
        cutscene:text("* Good.[wait:10] Let's see what Ralsei's so spooked about.", "nervous_side")
        kris.flip_x = false
        Game.world.camera.keep_in_bounds = true
        cutscene:attachCamera()
        susie:resetSprite()
        kris:resetSprite()
        kris.layer = susie.layer
        cutscene:walkTo(susie, "suspoint",3)
        cutscene:wait(cutscene:walkTo(kris, "kpoint",3))
        kris:setFacing("up")
        susie:setFacing("up")
        cutscene:wait(1)
        cutscene:setSpeaker(ralsei)
        cutscene:text("[shake:0.51][speed:0.8]* T-This.. [wait:5]shouldn't be happening...", "concern_smile")
        cutscene:text("[shake:0.51][speed:0.8]* This isn't part of the prophecy...", "concern_smile")
        cutscene:text("[shake:0.51][speed:0.8]* Kris, [wait:5]Susie... [wait:10]We need to seal this fountain.[wait:5] Now...", "concern_smile")
        cutscene:text("[shake:0.51][speed:0.8]* It's been the same as I remember it until now because", "concern_smile", {auto = true})
        cutscene:text("[noskip][shake:0.56][speed:1]* First was the King", "concern_smile", {auto = true})
        cutscene:text("[noskip][shake:0.60][speed:1.1]* And then Queen and her chariot", "concern_smile", {auto = true})
        cutscene:text("[noskip][shake:0.70][speed:1.2]* Then Tenna, [shake:0.85][wait:5]a-[wait:5] and the Knight", "concern_smile", {auto = true})
        cutscene:text("[noskip][shake:0.95]* Just before this was the Titan", "concern_smile", {auto = true})
        cutscene:text("[noskip][shake:1][speed:1.3]* And right now it should be", "concern_smile", {auto = true})
        cutscene:setSpeaker(susie)
        cutscene:text("* Hang on a sec,[wait:5] it's not in the prophecy...", "suspicious")
        cutscene:text("* And it says the Knight didn't do it?", "suspicious")
        cutscene:text("* Heh![wait:10] Suuuure.[wait:10]\n* Guess that's just another opportunity to-", "closed_grin", {auto = true})
        cutscene:setSpeaker(ralsei)
        cutscene:text("* Susie,[wait:5] no![wait:5] Please,[wait:5] don't break it!", "concern")
        cutscene:text("* I'd... [wait:5]rather you not get hurt.", "pensive")
        cutscene:wait(1/2)
        susie:setFacing("right")
        cutscene:wait(1/2)
        cutscene:setSpeaker(susie)
        cutscene:text("* ... Fine.", "nervous_side")
        susie:setSprite("walk_back_arm")
        cutscene:walkTo(susie, "suspoint2",2)
		cutscene:wait(1.5)
        cutscene:text("* What a load of junk. [wait:5][face:smile]Are we REALLY gonna fall for this?", "closed_grin")
        cutscene:text("* These panel things aren't THAT important anyways.", "smile")
        cutscene:text("* Let's go.", "nervous")
		
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
        
        cutscene:attachFollowers()
        for _, save in ipairs(Game.world.map:getEvents("savepoint")) do
            save.visible = true
        end
        susie:resetSprite()
        kris:setFacing("down")
    end,
    lobby = function(cutscene)
        local man = cutscene:getCharacter("lobbyman")
        local susie, ralsei, kris = cutscene:getCharacter("susie"),cutscene:getCharacter("ralsei"),cutscene:getCharacter("kris")

        cutscene:setSpeaker(man)
        cutscene:text("* Hello. [wait:5]I am the Lobby Man.")
        local function choicebox()
            local choice = cutscene:choicer({"Where am I?", "What happened?", "Who are you?", "Bye"})
            if choice == 1 then
                cutscene:text("* You are in the Base Sanctum.")
                cutscene:text("* Here, [wait:5]you may explore and discover new sanctuaries.")
                choicebox()
            elseif choice == 2 then
                cutscene:text("* That is beyond my knowledge.")
                cutscene:text("* I can only assume that someone had opened too many fountains...?")
                cutscene:text("* This can probably support your coloring.")
                choicebox()
            elseif choice == 3 then
                cutscene:text("* I am the Lobby Man.")
                choicebox()
            elseif choice == 4 then
                cutscene:text("* bye")
                Assets.playSound("snd_mysterygo")
                Game.world.timer:tween(0.75, man, {alpha = 0, scale_x = 1, scale_y = 3}, 'out-circ')
                cutscene:wait(2)
                cutscene:setSpeaker(susie)
                cutscene:text("* ...", "annoyed_b")
                man:remove()
            end
        end

        choicebox()
    end,
    titan = function (cutscene)
        local sus = Game.world:spawnNPC('titan',1020,390)
        sus:setAnimation("full")
        sus.alpha = 0
        cutscene:wait(1)
        Game.world.timer:tween(2, sus, {alpha = 1})
        cutscene:wait(4)
        Game.world.timer:after(2, function()sus:remove()end)
        cutscene:startEncounter("titan", true, sus)
    end,
	ripple2nd = function(cutscene)
		Game:setFlag("ripple2nd", true)
	end,
    prefall = function (cutscene)
		if Game:getFlag("noellefall", false) then return end
		if Game:getFlag("route") == 3 then
			local no = cutscene:getCharacter("noelle")
			no:setSprite("walk_look_up/left_1")
		end
        if Game:hasPartyMember("jamm") then
			local ral = cutscene:getCharacter("ralsei")
        	local sus = cutscene:getCharacter("susie")
        	local kris = cutscene:getCharacter("kris")
            local jamm = cutscene:getCharacter("jamm")
			cutscene:detachFollowers()
			cutscene:wait(cutscene:walkTo(kris, 640, 480, 0.5, "left", true), cutscene:walkTo(sus, 680, 460, 0.5, "left", true), cutscene:walkTo(ral, 740, 480, 0.5, "left", true))
			cutscene:wait(cutscene:walkTo(jamm, 680, 420, 0.5, "down", true))
			sus:setFacing("up")
			ral:setFacing("up")
			kris:setFacing("right")
            cutscene:setSpeaker(jamm)
            cutscene:text("* Guys wait,[wait:5] I think I dropped my slingshot back there.", "neutral")
            cutscene:text("* You guys can go on ahead,[wait:5] I'll be right behind you guys.", "look_left")
            cutscene:wait(cutscene:walkToSpeed(jamm, "jpointA1", 8))
			cutscene:wait(cutscene:walkToSpeed(jamm, "jpointA2", 8))
			cutscene:wait(cutscene:walkToSpeed(jamm, "jpointA3", 8, "left", true))
			cutscene:walkToSpeed(jamm, 320, 160, 8)
			Game:setFlag("slingCon", 1)
			jamm = jamm:convertToNPC({ cutscene = "events2.jammslingshot" })
            Game.lock_movement = false
            jamm.following = false
			jamm:setPosition(200, 85)
			jamm:setFacing("up")
			local i = Game:getPartyIndex("jamm")
			Game:removePartyMember("jamm")
			Game:setFlag("jammPartyIndex", i)
			cutscene:attachFollowers()
        end
    end,
    fall = function (cutscene)
        local ral = cutscene:getCharacter("ralsei")
        local sus = cutscene:getCharacter("susie")
        local no = cutscene:getCharacter("noelle")
        local kris = cutscene:getCharacter("kris")
        local jamm = cutscene:getCharacter("jamm")
		local g1 = Game.world.map:getEvent(140)
		local g2 = Game.world.map:getEvent(141)
		if Game:getFlag("route") == 3 then
			no:setSprite("walk_look_up/left_1")
		end
		cutscene:detachCamera()
        cutscene:detachFollowers()
        cutscene:setSpeaker("noelle")
		if Game:getFlag("route") == 3 then
			cutscene:text("* What was it that they told me to do...?")
		else
			cutscene:text("* S-someone...[wait:10] Help...")
		end
        cutscene:setSpeaker("susie")
        cutscene:text("* (Kris, [wait:5]did you hear that?[wait:10] That sounded like...)", "blush")
		if Game:getFlag("route") == 3 then
			no:setAnimation({"battle_alt/idle", 1/6, true})
		else
			no:setAnimation({"battle/defeat", 1/6, true})
		end
		cutscene:wait(cutscene:panTo("camto", 1))
		local continuing = false
        cutscene:setSpeaker("noelle")
		if Game:getFlag("route") == 3 then
			cutscene:text("* I believe it was...[wait:10] IceShock...?")
		else
			cutscene:text("* I can't...[wait:10] Move...")
		end
		cutscene:wait(0.6)
		Assets.playSound("rudebuster_swing")
		local rb = Game.world:addChild(RudeBusterBeam(false, sus.x, sus.y - 20, g1.x, g1.y - 40, function(damage_bonus, play_sound)
			Game:setFlag("last_overworld_buster_damage", damage_bonus)
			continuing = true
			g1:setAnimation("hurt")
			g1:shake(4)
		end))
		rb:setLayer(WORLD_LAYERS["above_events"])
		cutscene:wait(function() return continuing end)
        no:shake(2,0)
        cutscene:slideTo(no, "npoint", 1, 'out-circ')
        no:setSprite("scare")
        no:play(1/15, true)
        Assets.playSound("noscared")
        Game.world.music:pause()
		cutscene:wait(1.3)
        cutscene:setSpeaker("susie")
        cutscene:text("* Noelle!", "shock")
		g1:setAnimation("idle")
        no:play(1/15, false)
		cutscene:walkToSpeed(sus, "susto_1", 10, nil, nil, function()
			g1:slideTo(g1.x, g1.y - 40, 1)
			cutscene:walkToSpeed(sus, "susto_2", 10, nil, nil, function()
				sus:setSprite("kneel_left")
			end)
		end)
        cutscene:wait(1)
        no:setSprite("shocked")
        cutscene:wait(0.25)
        Game.world.timer:tween(2, no, {y = no.y + 800, x = no.x - 130 + 130, rotation = math.rad(0)}, 'in-circ')
        cutscene:fadeOut(1, {music = false})
        cutscene:text("* Wait, [wait:5]NOELLE!", "surprise_frown")
        cutscene:wait(1)
        Assets.playSound("snd_closet_fall")
        local img = Sprite("falling-n")
        img:setOrigin(0.5, 0.75)
        img:setParallax(0)
        img.layer = 1000
        img.x, img.y = SCREEN_WIDTH/2, SCREEN_HEIGHT-150
        Game.world:addChild(img)
        img:setScale(0.5)
        Game.world.timer:tween(4, img, {scale_x = 0, scale_y = 0}, "out-circ")
        cutscene:wait(4)
        img:remove()
        --Assets.playSound("snd_closet_impact")
		if Game:getFlag("route") == 3 then
			local pitch = 0.75
			Assets.playSound("snd_closet_impact", 1, pitch)
			Game.world.timer:script(function(wait)
				wait(11/30)
				Assets.playSound("snd_closet_impact", 0.6, pitch)
				wait(12/30)
				Assets.playSound("snd_closet_impact", 0.3, pitch)
				wait(12/30)
				Assets.playSound("snd_closet_impact", 0.1, pitch)
				wait(12/30)
				Assets.playSound("snd_closet_impact", 0.05, pitch)
			end)
			cutscene:wait(5.5)
			cutscene:setSpeaker(nil)
			cutscene:text("[speed:0.78][shake:0.52]* ...")
			cutscene:text("[speed:0.78][shake:0.52]* ...[wait:5] Why?")
			cutscene:text("[speed:0.78][shake:0.52]* Why would you come here?")
			cutscene:wait(2.5)
			
			cutscene:text("[speed:0.78][shake:0.52]* Why me? [wait:5]Why not.. [wait:10]Susie? [wait:5]Or Catti?")
			cutscene:text("[speed:0.78][shake:0.52]* Why exactly me?")
			cutscene:wait(2)
			cutscene:text("[speed:0.78][shake:0.52]* You've changed, [wait:5]Kris.")
			cutscene:text("[speed:0.78][shake:0.52]* Changed... [wait:10]Differently.")
			
			cutscene:wait(4)
			
			Game.world.music:play("findher", 1, .4)
			
			cutscene:text("[speed:0.78][shake:0.52]* Like that night in the kitchen...")
			cutscene:text("[speed:0.78][shake:0.52]* When the lights wouldn't turn on.")
			cutscene:text("[speed:0.78][shake:0.52]* I saw it sitting there.")
			cutscene:text("[speed:0.78][shake:0.52]* That box.")
			cutscene:text("[speed:0.78][shake:0.52]* ...[wait:5]It looked at me.")
			cutscene:text("[speed:0.78][shake:0.52]* It winked.")
			cutscene:text("[speed:0.78][shake:0.52]* And I screamed.")
			cutscene:wait(2.5)
			
			cutscene:text("[speed:0.78][shake:0.52]* Or the heart pillows.")
			cutscene:text("[speed:0.78][shake:0.52]* You remember those,[wait:5] right?")
			cutscene:text("[speed:0.78][shake:0.52]* You'd grab one and run at me.")
			cutscene:text("[speed:0.78][shake:0.52]* Saying you \"ripped your heart out\".")
			cutscene:text("[speed:0.78][shake:0.52]* ...I laughed.")
			cutscene:text("[speed:0.78][shake:0.52]* I think I did.")
			cutscene:text("[speed:0.78][shake:0.52]* But it didn't feel like a joke.")
			cutscene:text("[speed:0.78][shake:0.52]* I didn't feel like I was the one smiling.")
			cutscene:wait(2.5)
			
			cutscene:text("[speed:0.78][shake:0.52]* And that place...")
			cutscene:text("[speed:0.78][shake:0.52]* The quiet one.")
			cutscene:text("[speed:0.78][shake:0.52]* Where everything felt... wrong.")
			cutscene:text("[speed:0.78][shake:0.52]* Like something was...[wait:5] leading us.")
			cutscene:wait(2)
			
			cutscene:text("[speed:0.78][shake:0.52]* You just kept going.")
			cutscene:text("[speed:0.78][shake:0.52]* Looking inside. [wait:10]\n* Proceeding without caring.")
			
			
			cutscene:wait(2)
			local img = Sprite("misc/rose_bloom")
			img:setOrigin(0.5, 0.75)
			img:setParallax(0)
			img.layer = 1000
			img.x, img.y = SCREEN_WIDTH/2, SCREEN_HEIGHT/2
			Game.world:addChild(img)
			Game.world.music:stop()
            cutscene:wait(2)
			
			cutscene:text("[voice:none][speed:0.75][shake:0.52]* ...You've ruined it.")
			cutscene:text("[voice:none][speed:0.75][shake:0.52]* The part where I didn't have to know.")
			cutscene:text("[voice:none][speed:0.63][shake:0.62]* But maybe that's what I needed.")
			cutscene:text("[voice:none][speed:0.63][shake:0.62]* To finally break.")
			cutscene:wait(1)
			cutscene:text("[voice:none][speed:0.51][shake:0.72]* ...Break my loop.")
			cutscene:text("[voice:none][speed:0.51][shake:0.72]* Everything you showed me.")
			cutscene:text("[voice:none][speed:0.45][shake:0.72]* Everything I couldn't ignore anymore.")
			
			cutscene:wait(2)

			cutscene:text("[noskip][voice:noelle][speed:0.05][shake:0.82][spacing:5]* Thank you, Kri", nil, no, {auto = true})
			cutscene:setSpeaker("susie")
			Game.world.music:play("second_church", 1, 1)
			img:remove()
			kris.x = sus.x + 40
			kris.y = sus.y - 40
			kris:setFacing("left")
			ral.x = sus.x + 40
			ral.y = sus.y + 40
			ral:setFacing("left")
			local x = g1.x + 80
			local y = g1.y
			g1:remove()
			g1 = Game.world:spawnNPC("guei", x, y, {animation = "idle"})
			g2.x = g2.x + 80
			g2.y = g2.y + 40
			cutscene:fadeIn(0)
		else
			local pitch = 0.75
			Assets.playSound("splat", 1, pitch)
			Game.world.timer:script(function(wait)
				wait(11/30)
				Assets.playSound("splat", 0.6, pitch)
				wait(12/30)
				Assets.playSound("splat", 0.3, pitch)
				wait(12/30)
				Assets.playSound("splat", 0.1, pitch)
				wait(12/30)
				Assets.playSound("splat", 0.05, pitch)
			end)
			cutscene:wait(3)
			cutscene:text("[voice:echo][speed:0.25][shake:0.52]* Noelle?! [wait:10]Are you okay?!")
			cutscene:text("[voice:echo][speed:0.25][shake:0.52]* Can you hear me?!")
			cutscene:wait(1)
			Game.world.music:play()
			kris.x = sus.x + 40
			kris.y = sus.y - 40
			kris:setFacing("left")
			ral.x = sus.x + 40
			ral.y = sus.y + 40
			ral:setFacing("left")
			local x = g1.x + 80
			local y = g1.y
			g1:remove()
			g1 = Game.world:spawnNPC("guei", x, y, {animation = "idle"})
			g2.x = g2.x + 80
			g2.y = g2.y + 40
			cutscene:fadeIn(1, {music = false})
			cutscene:wait(1)
		end
        cutscene:setSpeaker(sus)
        cutscene:text("* D-Did-", "surprise_frown")
        cutscene:text("* Did Noelle just die?!", "surprise_frown")
		if Game:getFlag("route") == 3 then
			cutscene:text("* DID I KILL NOELLE?!", "shock_nervous")
		end
        cutscene:setSpeaker(ral)
        cutscene:text("* W-Well Susie, [wait:5]um...", "surprise_confused")
        cutscene:text("* I think she's... [wait:5]okay? [wait:10]It doesn't seem like falling here would...", "surprise_neutral_side")
        cutscene:wait(1/2)
        ral:setFacing("down")
        cutscene:text("* ... work normally.", "surprise_confused")
        cutscene:wait(1/2)
        sus:resetSprite()
        sus:setFacing("right")
        ral:setFacing("right")
        kris:setFacing("right")
        cutscene:setSpeaker(sus)
        cutscene:text("* ...", "bangs/neutral")
        cutscene:text("* ...Arright,[wait:5] freaks.[wait:10] Listen up.", "bangs/neutral")
        cutscene:text("* If it's a fight you want...", "bangs/neutral")
		sus:setAnimation("battle/attack")
		Assets.playSound("laz_c")
		cutscene:wait(0.7)
        cutscene:text("* Then you're gonna fight someone your own size!", "bangs/teeth_angry")
		local w, e = cutscene:startEncounter("guei_hurt", true, {g1, g2}, {wait=false})
		g1:remove()
		g2:remove()
		cutscene:wait(w)
		Game:addPartyMember("jamm", Game:getFlag("jammPartyIndex", 4))
        cutscene:wait(1)
        sus:resetSprite()
		sus:shake(2)
		Assets.playSound("wing")
		cutscene:wait(1)
        if Game:hasPartyMember("jamm") then
			jamm = jamm:convertToFollower()
            jamm.x, jamm.y = 680, 480
			jamm.following = true
			local jam = Game:getPartyMember("jamm")
			sus:setFacing("right")
			kris:setFacing("right")
			ral:setFacing("right")
			cutscene:wait(1/2)
			cutscene:wait(cutscene:walkToSpeed(jamm, 600, 460, 8, "left", true))
			cutscene:wait(cutscene:walkToSpeed(jamm, 480, 620, 8, "left", true))
			cutscene:wait(cutscene:walkToSpeed(jamm, "jpoint2", 8, "left", true))
			cutscene:wait(0.75)
			cutscene:setSpeaker(jamm)
        	cutscene:text("* Found my slingshot, [wait:5]did I miss anything?", "neutral")
			cutscene:text("* I could've sworn I heard someone scream down here...", "suspicious")
			cutscene:setSpeaker(sus)
        	cutscene:text("* [sound:voice/susie]", "shock")
			cutscene:text("* [sound:voice/susie]", "shock_down")
			cutscene:text("* (Okay, Susie. [wait:10]You barely know this guy.)", "shock_nervous")
			cutscene:text("* (Let's not tell him.)", "shock_nervous")
			
			cutscene:text("* Uhhhhhhh", "shock_down")
			
			cutscene:text("* No?", "shock")
			cutscene:setSpeaker(jamm)
			cutscene:text("* [wait:30]..Uuh[wait:3]h[wait:3]h huh.", "suspicious")
			cutscene:text("* Alright then.", "look_left")
			Game:setFlag("slingCon", 2)
			jamm.solid = false
			jam:setWeapon(Game:getFlag("lastJammWeapon", "basic_sling"))
        end
		
        cutscene:interpolateFollowers()
        cutscene:attachFollowers()
		cutscene:attachCamera()
        Game:setFlag("noellefall", true)
    end,
    jamm = function (cutscene)
        local j = cutscene:getCharacter("jamm")
        local ral = cutscene:getCharacter("ralsei")
        local sus = cutscene:getCharacter("susie")
        cutscene:detachFollowers()
        cutscene:setSpeaker(sus)
		Assets.playSound("sussurprise")
		sus:shake()
		sus:setSprite("surprise_step")
        cutscene:text("* Ralsei, [wait:5]are you seeing this?", "shock_nervous")
        cutscene:setSpeaker(ral)
        cutscene:text("* Yes Susie, [wait:5]I'm seeing this.[react:1]", "surprise_confused", {
			reactions = {
				{"You think they're a \nDarkner, or something?", "rightmid", "bottom", "shy_b", "susie"}
			}
		})
		cutscene:setSpeaker(sus)
		j:shake()
		Assets.playSound("wing")
		cutscene:wait(1)
		j:shake()
		Assets.playSound("wing")
		cutscene:wait(2)
		j:shake()
		Assets.playSound("wing")
        j:resetSprite()
		cutscene:wait(0.5)
        j:setFacing("left")
        cutscene:wait(0.5)
        cutscene:setSpeaker(j)
        cutscene:text("* I have ears, [wait:5]you kno", "suspicious", {auto = true})
		j:shake()
		j:setSprite("landed_1")
		Assets.playSound("wing")
		cutscene:text("* Agh...!", "ouch")
        cutscene:setSpeaker(ral)
		local rx, ry = ral:getPosition()

		cutscene:walkPath(
			ral,
			{
				{ral.x, sus.y},
				{j.x-50, j.y}
			},
			{speed = 8}
		)
		cutscene:text("* Are you okay?", "concern")
		cutscene:wait(function()
			return ral.x == j.x - 50 end)
		sus:setAnimation("heal_charge")
        cutscene:text("* Here, [wait:5]let me", "surprise_smile", {auto = true})
		sus:setAnimation("heal_end")
		Assets.playSound("wing")
		cutscene:wait(1/10)  --need to add particle later

		local h = Game.world:spawnObject(Sprite("world/heal_small"))
		h:setScale(2)
		h:play(1/8, true)
		h:flash()
		h:setPosition(sus.x+10, sus.y-(sus.height)-6)
		h.layer = WORLD_LAYERS["top"]
		h.physics.speed_x = 0.1
		h.physics.gravity_direction = math.rad(180)
		h.physics.gravity = -1
		--do particle here
		cutscene:wait(function () return h.x > (j.x-10) end)
		h:remove()
		local x, y = j:getScreenPos()
		local dmg = DamageNumber("msg", "max",x-30, y-20,{COLORS.lime})
        Game.stage:addChild(dmg)
		ral:setSprite(ral.sprite.sprite)
		ral:flash()
		j:flash()
		Assets.playSound("power")
		Game.world.timer:every(1/30, function()
            for i = 1, 2 do
                local x = ral.x + ((love.math.random() * ral.width) - (ral.width / 2)) * 2
                local y = ral.y - (love.math.random() * ral.height) * 2
                local sparkle = HealSparkle(x, y)
                sparkle:setLayer(WORLD_LAYERS["below_ui"])
                sparkle:setColor(COLORS.lime)
                Game.world:addChild(sparkle)
            end
        end, 4)
        Game.world.timer:every(1/30, function()
            for Kristal = 1, 2 do --                    <-- Evil moniey deletr
                local x = j.x + ((love.math.random() * j.width) - (j.width / 2)) * 2
                local y = j.y - (love.math.random() * j.height) * 2
                local sparkle = HealSparkle(x, y)
                sparkle:setLayer(WORLD_LAYERS["below_ui"])
                sparkle:setColor(COLORS.lime)
                Game.world:addChild(sparkle)
            end
        end, 4)
		cutscene:wait(2)
		cutscene:text("* [wait:5]...That works too...!", "surprise_neutral")
		cutscene:text("* Are you feeling any better?", "surprise_smile")
		cutscene:wait(1)
		Assets.playSound("wing")
		j:shake()
		j:resetSprite()
		j:setFacing("left")
		cutscene:wait(0.5)
		cutscene:setSpeaker(j)
		cutscene:text("* Yeah, [wait:5]that's a lot better, [wait:5]thanks...", "neutral")
		j:setFacing("right")
		cutscene:text("* Man, [wait:5]where am I?[wait:10]\n* The last thing I remember is...", "look_left")
		j:setFacing("left")
		cutscene:text("* Marcy...! [wait:10]Where is she!?[wait:5] Have you seen", "shocked", {auto = true})
		cutscene:setSpeaker(sus)
		local sux, suy = sus:getPosition()
		cutscene:walkTo(sus, ral.x- 40, ral.y + 20, 1.5)
		cutscene:text("* Woah, [wait:5]easy, [wait:5]dude!", "surprise_frown")
		cutscene:setSpeaker(ral)
		cutscene:text("* I think you should calm down, [wait:5]Mister...?", "surprise_neutral")
		cutscene:setSpeaker(j)
		cutscene:text("* Jamm.", "neutral")
		cutscene:text("* Well, [wait:5]my name's Luthane, [wait:5][face:neutral]but I prefer Jamm.", "look_left")
		cutscene:text("* You're... [wait:10]You're right, [wait:5]though.", "worried")
		cutscene:text("* I can't find her if I'm not focused...", "worried_down")
		cutscene:setSpeaker()
		cutscene:text("* ...[react:1]", "bangs_neutral", "susie",  {
					reactions = {
					{"* ...", "right", "bottom", "pensive", "ralsei"}
				},	
		})
		cutscene:setSpeaker(ral)
		cutscene:text("* Well, [wait:5]maybe we could help you?", "surprise_smile")
		cutscene:text("* I think we could all help each other out!", "surprise_neutral")
		cutscene:setSpeaker(j)
		cutscene:text("* ...You know what? [wait:10][face:stern]That's a good idea.", "worried")
		j = j:convertToFollower()
		cutscene:walkPath(
			ral,
			{
				{sux, suy},
				{rx, ry}
			},
			{speed = 5}
		)
		cutscene:walkPath(
			sus,
			{{sux, suy}},
			{speed = 5}
		)
		cutscene:wait(cutscene:walkPath(
			j,
			{
				{sux, suy},
				{rx, ry-30}
			},
			{speed = 5}
		))
        cutscene:wait(cutscene:attachFollowers())
		cutscene:setSpeaker()
		cutscene:text("* Jamm tried to join the party, [wait:5]but it was full.")
		cutscene:wait(1)
		cutscene:setSpeaker(j)
		cutscene:text("* Oh, [wait:5]one moment...", "neutral")
		cutscene:setSpeaker()
		Game.world.music:pause()
		Assets.playSound("great_shine")
		Game.world.player:flash()
		for _,party in ipairs(Game.world.followers) do
		  party:flash()
		end
		cutscene:text("* Jamm increased the party limit and joined the party.[wait:15][react:1][react:2]", {
					reactions = {
					{" ", "middle", "bottom", "shock", "susie"},
					{" ", "right", "bottom", "dismissive", "ralsei"}
					}
				}
			)
		cutscene:wait(1)
        Game:setFlag("jamm_join", true)
        Game:addPartyMember("jamm", #Game.party+1)
        Game.world.music:play()
    end,

	firsttravel = function (cutscene)
		local kris = cutscene:getCharacter("kris")
		local susie = cutscene:getCharacter("susie")
		local ralsei = cutscene:getCharacter("ralsei")
		local jamm = cutscene:getCharacter("jamm")

		cutscene:detachFollowers()
		cutscene:walkTo(kris, "kristo", 0.5, "down")
		cutscene:walkTo(susie, "susieto", 0.5, "right")
		cutscene:walkTo(ralsei, "ralseito", 0.5, "left")
		cutscene:wait(cutscene:walkTo(jamm, "jammto", 0.5, "up"))
		
		cutscene:wait(2)
		cutscene:text("* ...", "sus_nervous", "susie")
		cutscene:text("* ...So THAT'S [wait:5]what it does.", "look_left", "jamm")
		cutscene:text("* Well, [wait:5]at least we aren't stuck anymore.", "nervous_side", "susie")
		cutscene:text("* ...[wait:10][face:neutral]Where are we, [wait:5]anyways?", "neutral_side", "susie")
		cutscene:text("* I'm not sure, [wait:5]Susie.", "pensive", "ralsei")
		cutscene:text("* There's a bunch of doors here...", "pensive", "ralsei")
		cutscene:text("* Are they... [wait:10]warp doors???", "concern", "ralsei")
		cutscene:text("[shake:0.51][speed:0.8]* H-how... [wait:5]How big is this dark world...?!", "concern_smile", "ralsei")
        cutscene:text("[shake:0.51][speed:0.8]* None of this has been part of the prophecy...", "concern_smile", "ralsei")
        cutscene:text("[noskip][shake:0.56][speed:1]* Oh no...", "concern_smile", "ralsei", {auto = true})
        cutscene:text("[noskip][shake:0.60][speed:1.1]* No no no...", "concern_smile", "ralsei", {auto = true})
        cutscene:text("[noskip][shake:0.75][speed:1.2]* This can't be happening, it-", "concern_smile", "ralsei", {auto = true})
        cutscene:text("[noskip][shake:1]* What are we going to do??? How will we-", "concern_smile", "ralsei", {auto = true})
		cutscene:text("* Ralsei! [wait:10]Hey! [wait:5]It's...", "surprise_frown", "susie")
		cutscene:text("* ...", "bangs/down", "susie")
		cutscene:text("* I know we'll be able to figure it out, [wait:5]alright?", "bangs/down", "susie")
		cutscene:text("* WE were able to beat a TITAN, [wait:5]man.", "angry_look", "susie")
		cutscene:text("* We can stop whatever's going on here too.", "angry_look", "susie")
		cutscene:text("* ...[wait:10]I just know we can do this.", "bangs/down", "susie")
		cutscene:text("* And Jamm? [wait:10]We'll find Marcy. [wait:10]I promise.", "bangs/down", "susie")
		cutscene:text("* ...[wait:10][face:dejected]We better.", "dejected_front", "jamm")
		cutscene:wait(1)
		cutscene:text("* ...[wait:5]ANYWAYS, [wait:5]We should probably get a move on.", "sus_nervous", "susie")
		cutscene:text("* Let's go.", "neutral", "susie")

		cutscene:alignFollowers()
		cutscene:attachFollowers()
		
		Game:setFlag("fastTravelVisited", true)
	end,

    splitpath = function(cutscene)
        local susie, ralsei, kris = cutscene:getCharacter("susie"),cutscene:getCharacter("ralsei"),cutscene:getCharacter("kris")
        
        cutscene:setSpeaker(susie)
        cutscene:text("* This is a new cutscene!")
        cutscene:setSpeaker(ralsei)
        cutscene:text("* It's great to have new adventures!")
    end,

	churchbell_ring = function (cutscene)
		cutscene:enableMovement()
		Assets.playSound("churchbell_long", 0.75, 0.5)
		cutscene:wait(2.5)
		Assets.playSound("churchbell_long", 0.75, 0.5)
		cutscene:wait(2.5)
		Assets.playSound("churchbell_long", 0.75, 0.5)
		cutscene:wait(2.5)
		Game:setFlag("churchbell_rung_5th", true)
		Game.world.map:getHitbox("specblock").collidable = false
	end,

	apathy_intro = function (cutscene)
		local a = cutscene:getCharacter("cultist1")
		local k = cutscene:getCharacter("kris")
		local s = cutscene:getCharacter("susie")
		local r = cutscene:getCharacter("ralsei")
		local j = cutscene:getCharacter("jamm")

		cutscene:detachFollowers()
		
		r:shake()
		s:shake()
		Assets.playSound("wing")
		s:setSprite("shock_down_flip_1")
		r:setSprite("shocked_behind")
		cutscene:text("* Wait,[wait:5] Kris...![wait:10]\nHide...!", "shock", r)
		
		r:resetSprite()
		s:resetSprite()
		cutscene:walkPath(
			r,
			{
				{340, 530},
				{160, 500}
			},
			{speed =  8, facing = "down"}
		)
		
		cutscene:walkPath(
			s,
			{
				{340, 530},
				{200, 516}
			},
			{speed =  8}
		)

		cutscene:walkPath(
			j,
			{
				{340, 530},
				{120, 516}
			},
			{speed =  8, facing = "right"}
		)

		cutscene:wait(
			cutscene:walkTo(k, 160, 540, 1.25, "up")
		)

		
		

		cutscene:text("* Dude, [wait:5]you okay? [wait:10]I've never seen you get all jumpy like this", "surprise_frown", s, {auto = true})
		cutscene:text("* Shhh...![wait:10] It's them...", "unsure", r)
		cutscene:detachCamera()
		local ae = Game.world.camera.y
		cutscene:wait(cutscene:panTo(a.x, a.y, 3, "linear"))

		cutscene:text("* [voice:ralsei]They're that person...", {top = false})
		cutscene:text("* [voice:ralsei][speed:0.7]The one who made the fountain inside that Darkner.", {top = false})
		cutscene:attachCamera()
		cutscene:wait(cutscene:panTo(Game.world.camera.x, ae, 2, "out-circ"))
		

		cutscene:wait(1/2)
		cutscene:text("* So then, [wait:5]how are we gonna do this?", "look_left", j)
		cutscene:text("* Well.. [wait:10]They look a little busy...", "disappointed_side", r)
		cutscene:text("* I think I can just... [wait:10][face:disappointed]Pacify them?", "disappointed_side", r)

		cutscene:text("* ...", "bangs/down", s)
		
		local function doThis()
			cutscene:walkPath(
				s,
				{
					{340, s.y},
					{340, 285}
				},
				{speed = 7}
			)
		end

		cutscene:text("* O-[wait:5]Or... [wait:10]we can corner them, [wait:5]and ask[func:b] why they did that..?", "disappointed", r, {
			functions = {
				b = function()
					doThis()
				end
			}
		})

		cutscene:text("[noskip]* I... [face:disappointed_down]Really don't know what do do here...", "disappointed", r)
		cutscene:text("[noskip]* Yeah,[wait:5] this situation [wait:3]IS [wait:3]a little--", "look_left", j, {auto = true})

		r:setSprite("shocked_right")
		r:shake()
		j:setSprite("trip")
		j:shake()
		s:setSprite("point_up")
		cutscene:text("[noskip]* [voice:susie]HEY, [wait:7]YOU!")
		cutscene:wait(cutscene:panTo(s, 1.5))
		s:resetSprite()
		cutscene:text("* You've got some explaining to do. [wait:10]First-", "annoyed", s, {auto = true, top = false})
		
		Game.world.music:stop()
		cutscene:text("* [voice:none]Silence.", {top = false})
		a:setSprite("turn")
		r:resetSprite()
		j:resetSprite()
		cutscene:walkPath(
			r,
			{
				{300, r.y},
				{300, 290},
			},
			{speed = 8}
		)
		
		cutscene:walkPath(
			j,
			{
				{380, j.y},
				{380, 290},
			},
			{speed = 8}
		)
		
		cutscene:wait(cutscene:walkPath(
			k,
			{
				{340, k.y},
				{340, 335},
			},
			{speed = 8}
		))

		cutscene:text("* [voice:none]I see you've all come in one piece...", {top = false})
		cutscene:text("* [voice:none]Seems the Imbued was not strong enough.", {top = false})

		cutscene:text("[image:face/ralsei/disappointed,-10, 42, 2, 2][voice:susral]* Imbued...?", "dejected_scared", s)
		cutscene:text("* Imbued... [wait:5]With what?", "neutral", j)

		cutscene:wait(1)
		a.sprite:set("walk")
		Assets.playSound("wing")
		a:setFacing("down")
		cutscene:wait(1)
		cutscene:walkTo(a, a.x, a.y+40, 2, "down", true)
		cutscene:walkTo(s, s.x, s.y+20, 2, "up", true)
		cutscene:walkTo(k, k.x, k.y+20, 2, "up", true)
		cutscene:walkTo(j, j.x, j.y+20, 2, "up", true)
		cutscene:walkTo(r, r.x, r.y+20, 2, "up", true)
		
		cutscene:text("[noskip]* [voice:none]I want you all to think.", {top = false})
		cutscene:text("* [voice:none]This, [wait:5]is a Dark World.", {top = false})
		cutscene:text("[voice:none][instant]* This, is a Dark World.[stopinstant]\nAnd what gives life to such?", {top = false})
		
		cutscene:text("[speed:0.7][shake:0.52]* Dark Fountains.. [wait:10][speed:0.5]You don't mean..?", "roaring", r, {top = false})
		cutscene:text("* [voice:none]You, [wait:5]especially, [wait:5]would know that. ", {top = false})
		
		Game.world.music:play("wind_highplace", 0, 1)
		Game.world.music:fade(1, 2)

		cutscene:text("* [voice:none]When one makes a Dark Fountain,", {top = false})
		cutscene:text("[instant]* [voice:none]When one makes a Dark Fountain, [stopinstant]and their target is a living entity...", {top = false})
		cutscene:text("* [voice:none]They become [wait:5][color:9999ff]\"Imbued\" [wait:5][color:white]with the newly made fountain's energy.", {top = false})

		cutscene:wait(1)
		a:setSprite("turn")
		Assets.playSound("wing")
		cutscene:wait(1/6)
		a.sprite:set("walk")
		a:setFacing("up")
		cutscene:wait(1)

		cutscene:text("* [voice:none]They become a thrall bound to the user's will.", {top = false})
		cutscene:text("* [voice:none]In my case, [wait:5]the [wait:5]\"will\" [wait:5]was to stop you.", {top = false})

		cutscene:text("* [voice:none]I should not be telling you that, by the Order's word.", {top = false})
		cutscene:text("* [voice:none]But I do not care.", {top = false})
		
		a:setSprite("turn")
		Assets.playSound("wing")
		cutscene:wait(1/6)
		a.sprite:set("walk")
		a:setFacing("down")
		
		Game.world.music:stop()

		cutscene:text("* [voice:none]For these will be the last words you will hear.", {top = false})

		Game:getPartyMember("susie"):setFlag("serious", true)
		Game:getPartyMember("jamm"):setFlag("serious", true)
		cutscene:startEncounter("apathy_test", true, a)
		Game:getPartyMember("susie"):setFlag("serious", false)
		Game:getPartyMember("jamm"):setFlag("serious", false)
		
		cutscene:wait(1)
		Assets.playSound("wing")
		a:shake(4)
		cutscene:wait(0.75)
		Assets.playSound("wing")
		a:setSprite("downed")
		a:shake(4)
		
		cutscene:wait(0.5)
		
		cutscene:walkToSpeed(j, j.x, j.y-20, 2, "down", true)
		
		cutscene:wait(cutscene:walkPath(
			k,
			{
				{443, 286},
				{417, 189},
			},
			{speed = 4}
		))
		
		j:setFacing("up")
		
		k.flip_x = true
		Assets.playSound("weaponpull_fast")
		cutscene:wait(cutscene:setAnimation(k, "battle/intro"))
		cutscene:setAnimation(k, "battle/idle")
		
		cutscene:text("* [voice:none]...", {top = false})
		cutscene:text("* [voice:none]...So.", {top = false})
		cutscene:text("* [voice:none]You have me at bladepoint.", {top = false})
		cutscene:text("[speed:0.25]* [voice:none]Make it quick.", {top = false})
		
		cutscene:text("* We have questions,[wait:5] dude.", "annoyed", s, {top = false})
		cutscene:text("* We're not letting you go until we have our answers.", "annoyed", s, {top = false})
		
		cutscene:text("* [voice:none]So be it.", {top = false})
		cutscene:text("* [voice:none]But I will only answer one for each of you.", {top = false})
		
		cutscene:text("* I can make that work.", "teeth_smile", s, {top = false})
		
		cutscene:wait(cutscene:walkToSpeed(s, 346, 240, 4))
		
		cutscene:text("* ...", "sus_nervous", s, {top = false})
		cutscene:text("* Why are you doing this?", "annoyed", s, {top = false})
		
		cutscene:text("* [voice:none]We have a goal.", {top = false})
		cutscene:text("* [voice:none]Our goal,[wait:5] to call our God.", {top = false})
		cutscene:text("* [voice:none]And to do so,[wait:5] we desecrate every church by following their doing.", {top = false})
		cutscene:text("* [voice:none]Your church is but one of the many others we've stopped by.", {top = false})
		
		cutscene:text("* (So a bunch of criminals.)", "sus_nervous", s, {top = false})
		cutscene:text("* ...Got it.", "annoyed", s, {top = false})
		
		s:setFacing("down")
		
		cutscene:text("* Ralsei, you're up.", "neutral", s, {top = false})
		
		cutscene:walkToSpeed(s, 178, 240, 4, "right")
		cutscene:wait(0.25)
		cutscene:wait(cutscene:walkToSpeed(r, 346, 240, 4))
		
		cutscene:text("* ...How...[wait:7] did you make this happen?", "unsure", r, {top = false})
		
		cutscene:text("* [voice:none]Ah hah hah...[wait:5] I didn't make this happen.[wait:10] Not alone.", {top = false})
		cutscene:text("* [voice:none]We together made it happen.[wait:10]\n* Me,[wait:5] and my fellows.", {top = false})
		cutscene:text("* [voice:none]And we plan to keep moving forward until we have our goal fulfilled.", {top = false})
		cutscene:text("* [voice:none]...", {top = false})
		cutscene:text("* [voice:none]These [wait:5]\"rules\"[wait:5] you believe you must follow...", {top = false})
		cutscene:text("* [voice:none]Do you honestly think everybody is bound by them?", {top = false})
		
		cutscene:text("* ...", "roaring", r, {top = false})
		
		r:setFacing("down")
		
		cutscene:text("* My turn.", "stern", j, {top = false})
		
		cutscene:walkToSpeed(r, 522, 240, 4, "left")
		cutscene:wait(0.25)
		cutscene:wait(cutscene:walkToSpeed(j, 346, 240, 4))
		
		cutscene:text("* Where is she?", "stern", j, {top = false})
		
		cutscene:text("* [voice:none]Oh,[wait:5] [color:yellow]her[color:white]?", {top = false})
		cutscene:text("* [voice:none]Maybe your rude friend knows that better than I do.", {top = false})
		
		cutscene:wait(2)
		
		j.actor.default = "walk_shadowed"
		j:resetSprite()
		j:setFacing("left")
		
		cutscene:text("* ...What?", "insane_neutral", j, {top = false})
		
		s.actor.default = "walk_unhappy"
		s:resetSprite()
		
		cutscene:text("* Uh...[wait:10] Jamm?", "sad_frown", s, {top = false})

		Game.world.music:play("imminent_death")
		
		cutscene:wait(cutscene:walkToSpeed(j, 250, 240, 4))
		
		s:shake(2)
		s:setSprite("surprise_step")
		cutscene:text("* Jamm,[wait:5] hold on![wait:10]\n* They're--", "sad", s, {auto = true, top = false})
		
		cutscene:text("[shake:1]* I don't want to hear it.", "insane_neutral", j, {top = false})
		cutscene:text("[shake:1]* This...[wait:10] is all some sick joke to you,[wait:5] isn't it?", "insane_neutral", j, {top = false})
		cutscene:text("[shake:1]* Because of you,[wait:5] Marcy is...", "insane_frown", j, {top = false})
		j:setAnimation({"shadowed_pissed_left", 1/4, true})
		cutscene:text("[shake:1]* ...Give me...[wait:10] One good reason...", "insane", j, {top = false})
		
		local function doThat()
			j:setSprite("threaten")
			r:setSprite("shocked_left")
			r:shake(2)
		end
		
		cutscene:text("[noskip][shake:2]* ...Not to shoot you[func:b] in the GOD[wait:4] DAMN[wait:4] EYE!", "insane_pissed", j, {top = false,
			functions = {
				b = function()
					doThat() --[[   <-- The evil doThis() :jellycruel:    ]]
				end
			}
		})
		
		r:resetSprite()
		
		cutscene:text("* Jamm,[wait:5] stop!", "scared", r, {top = false})
		
		r.flip_x = true
		Game.world.music:stop()
		Assets.playSound("spellcast")
		cutscene:wait(cutscene:setAnimation(r, "battle/spell"))
		
		local mask = ColorMaskFX({0,1,0}, 1)
		j:addFX(mask)
		Game.world.timer:tween(1, mask, {amount = 0}, "linear", function()
			j:removeFX(mask)
		end)
		
		r:resetSprite()
		r.flip_x = false
		
		cutscene:wait(1.5)
		
		j:shake(2)
		Assets.playSound("wing")
		cutscene:wait(1.2)
		j:shake(2)
		Assets.playSound("wing")
		cutscene:wait(2.1)
		j:setSprite("landed_1")
		Assets.playSound("noise")
		j:shake(2)
		s:resetSprite()
		cutscene:wait(1)
		
		cutscene:text("* They...[wait:10] weren't talking about your daughter.", "disappointed", r, {top = false})
		
		cutscene:text("* ...Wh...[wait:10] what?", "shaded_neutral", j, {top = false})
		
		cutscene:text("* When you lost your slingshot...", "disappointed", r, {top = false})
		cutscene:text("* ...We found Noelle cornered by two darkners.", "disappointed", r, {top = false})
		cutscene:text("* Susie hit one with her Rude Buster,[wait:5] and...", "disappointed", r, {top = false})
		
		cutscene:text("* ...She fell.", "annoyed_down_alt", s, {top = false})
		
		cutscene:text("* ...", "shaded_neutral", j, {top = false})
		
		j:resetSprite()
		j:setFacing("down")
		j:shake(2)
		Assets.playSound("wing")
		
		cutscene:wait(1)
		
		cutscene:wait(cutscene:walkToSpeed(j, 280, 190, 2, "right", true))
		
		cutscene:text("* ...If you know what's good for you...", "shaded_neutral", j, {top = false})
		j.flip_x = true
		j:setSprite("threaten")
		cutscene:text("* You're going to tell me what I want to know.", "shaded_neutral", j, {top = false})
		cutscene:text("* Where.[wait:10] Is.[wait:10] My.[wait:10] Daughter?", "shaded_pissed", j, {top = false})
		
		cutscene:text("* [voice:none]...", {top = false})
		cutscene:text("* [voice:none]I have no idea who you're talking about.", {top = false})
		cutscene:text("* [voice:none]I know not of your daughter,[wait:5] or the fact she was present.", {top = false})
		cutscene:text("* [voice:none]Believe me or not,[wait:5] but I speak truth.", {top = false})
		
		j.flip_x = false
		j:resetSprite()
		cutscene:text("* ...", "shaded_neutral", j, {top = false})
		
		cutscene:wait(cutscene:walkToSpeed(j, 280, 100, 2))
		
		cutscene:text("* [voice:none]...And what about you,[wait:5] with the sword?", {top = false})
		cutscene:text("* [voice:none]Is there any curiosity in your mind?", {top = false})
		
		if Game:getFlag("route") == 3 then
			local box = Game.world:addChild(LockingChoicer(4, 76, 346, 529, 103, false, {color = {
				[1] = COLORS.white,
				[2] = COLORS.white,
				[3] = COLORS.white,
				[4] = COLORS.red
				}
			}))
			box:addChoice("Name") 
			box:addChoice("Allies")
			box:addChoice("Truce") 
			box:addChoice("Help Me")

			box.layer = WORLD_LAYERS["ui"]+1
			cutscene:wait(function () return box.done end)
			if box.selected_choice == 1 then
				cutscene:text("* [voice:none]Useless information.[wait:10]\n* If you desire it,[wait:5] so be it.", {top = false})
				cutscene:text("* [voice:none]Kaleise.", {top = false})
				goto postdialogue
			elseif box.selected_choice == 2 then
				cutscene:text("* [voice:none]We are eight.", {top = false})
				cutscene:text("* [voice:none]Eight fellows,[wait:5] with magnitudes more around the globe.", {top = false})
				cutscene:text("* [voice:none]My loss is only fodder.", {top = false})
				goto postdialogue
			elseif box.selected_choice == 3 then
				cutscene:text("* [voice:none]A truce?[wait:10] Me,[wait:5] you?", {top = false})
				cutscene:text("* [voice:none]...My allegiance is with the Order.", {top = false})
				goto postdialogue
			elseif box.selected_choice == 4 then

				cutscene:wait(1)

				local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				rect:setColor(COLORS.black)
				rect:setParallax(0)
				rect.layer = WORLD_LAYERS["ui"] - 2

				local origlayers = {a.layer, k.layer}
				a.layer = rect.layer + 1
				k.layer = a.layer
				Game.world:addChild(rect)
				Kristal.hideBorder(0)
				
				local fxx = OutlineFX(COLORS.red, {cutout = true})
				local soul = Sprite("player/heart")
				soul:setColor(COLORS.red)
				Game.world:addChild(soul)
				soul:setOrigin(0.5)
				soul.layer = k.layer + 1
				soul:setPosition(435, 160)
				k:addFX(fxx)
				k.alpha = 0.4
				Assets.playSound("noise")
				cutscene:wait(3)
				Game.world.music:play("me", 1, 0.8)
				cutscene:text("[shake:0.55][voice:none]* (Something's different.)", {top = false})
				cutscene:text("[shake:0.55][voice:none]* (That voice. [wait:10]It spoke through me.)", {top = false})
				cutscene:text("[voice:none][shake:0.7]* (This is not a child. [wait:10]No, [wait:5]this is something else entirely.)", {top = false})
				cutscene:text("[voice:none][shake:0.7]* (Something far more than what we anticipated.)", {top = false})
					
				local spr
				local function JustDoIt()
					spr = Sprite("misc/rose_bloom")
					Game.world:addChild(spr)
					spr:setScale(2)
					spr.x,spr.y = 225, 40
					spr.alpha = 0
					spr:setLayer(a.layer - 0.1)
					Game.world.timer:tween(3, spr, {alpha = 1}, 'in-expo')
				end
				cutscene:text("[voice:none][shake:0.7][speed:0.5][noskip]* (Something BETTER than what we anticipated. [wait:10][func:nike]Just. [wait:20]Look. [wait:20]Calm", {
					top = false, 
					auto = true,
					functions = {
						nike = function()
							JustDoIt() --[[  :jellywide: ]]
						end
					}
				})
				k:removeFX(fxx)
				soul.visible = false
				spr:remove()
				Game.world.music:stop()
				k.layer = origlayers[2]
				
				local slash = Sprite("effects/attack/blue_slash")
				a:addFX(ColorMaskFX(COLORS.white))
				slash:setScale(2)
				slash:setOrigin(0.5)
				slash:setPosition(a.x, a.y - (slash.height/2))
				Game.world:addChild(slash)
				slash.layer = a.layer + 1
				slash:setFrame(1)
				cutscene:wait(1/7)
				slash:setFrame(2)
				cutscene:wait(1/7)
				slash:setFrame(3)
				cutscene:wait(1/7)

				a.visible = false

				Assets.playSound("heavydamage")
				Assets.playSound("indoct_break1")
				Game.world.camera:shake(10, 0, 1, 1/15)
				

				local waw = DamageNumber("damage", love.math.random(3300, 3900), a.x+20, a.y - 20)
				waw.font = Assets.getFont("damage-cult")
				waw.layer = a.layer + 0.09
				Game.world:addChild(waw)

				local spr1 = Sprite("culthalf_1")
				Game.world:addChild(spr1)
				spr1:setLayer(a.layer + 0.1)
				spr1:setOrigin(0.5, 1)
				spr1:setScale(2)
				spr1:setPosition(a.x, a.y-(a.height/2))

				local spr2 = Sprite("culthalf_2")
				Game.world:addChild(spr2)
				spr2:setLayer(a.layer + 0.1)
				spr2:setOrigin(0.5, 1)
				spr2:setScale(2)
				spr2:setPosition(a.x, a.y)

				spr1:addFX(ColorMaskFX(COLORS.white))
				spr2:addFX(ColorMaskFX(COLORS.white))
				

				spr1.physics.direction = math.rad(-80)
				spr1.physics.speed = 4
				spr1.physics.friction = 0.15

				spr2.physics.direction = math.rad(100)
				spr2.physics.speed = 4
				spr2.physics.friction = 0.15
				Game.world.timer:tween(1, spr1, {rotation = math.rad(15)}, 'out-cubic')
				Game.world.timer:tween(1, spr2, {rotation = math.rad(-15)}, 'out-cubic')


				slash:setFrame(4)
				cutscene:wait(1/8)
				slash:setFrame(5)
				cutscene:wait(1/8)
				slash:setFrame(6)
				cutscene:wait(1/8)
				slash:remove()
				cutscene:wait(1)
				local posx, posy = spr1:getPosition()
				local death = FatalEffect(spr1:getTexture(), posx-5, posy-spr1.height-32, function() spr1:remove() end)
				spr1.visible = false
				death:addFX(ColorMaskFX(COLORS.white))
				death:setScale(spr1:getScale())
				Game.world:addChild(death)
				death:setLayer(spr1.layer)
				death.rotation = spr1.rotation

				local posx, posy = spr2:getPosition()
				local death = FatalEffect(spr2:getTexture(), posx-spr2.width-7, posy-spr2.height-9, function() spr2:remove() end)
				spr2.visible = false
				death:addFX(ColorMaskFX(COLORS.white))
				death:setScale(spr2:getScale())
				Game.world:addChild(death)
				death:setLayer(spr2.layer)
				death.rotation = spr2.rotation

				k.alpha = 1

				cutscene:wait(2)
				soul.visible = not soul.visible --true
				Assets.playSound("noise")

				cutscene:wait(1)
				local man = Game.world:spawnNPC("lobbyman_party", 570, 135)
				man:setFacing("up")
				
				for i = 1, 8 do
					cutscene:wait(1/15)
					rect.visible = not rect.visible
					if i == 1 then
						man:setPosition(465, 165)
						man:setSprite("shaded_down")
					end
					if i == 7 then
						man:setSprite("shaded")
					end
					if i%2 == 1 then
						Assets.playSound("noise", 0.2 + (i/10), 1)
					end
				end

				cutscene:wait(1.5)
				man:resetSprite()
				Assets.playSound("noise")
				soul:remove() --No more side B :(

				r:shake() j:shake() s:shake()

				k:resetSprite()
				k:setFacing("right")

				r:setSprite("shocked_left")
				s:setSprite("surprise_step")
				j:setSprite("trip")

				

				man:setPosition(570, 135)
				local glass = Game.world.map:getEvent("churchmagicglass")
				glass.idlealpha = 0.5
				glass.hiddenalpha = 0.5
				glass.should_light_up =  true
				man:addFX(ColorMaskFX(COLORS.black))
				cutscene:walkTo(man, 800, man.y, 1)
				rect:remove()
				a:remove()
				k.layer = origlayers[2]

				cutscene:wait(1)


				cutscene:text("[shake:0.6]* What... [wait:10]What was that...?", "terrified_down", r)
				cutscene:text("* I don't know. [wait:10]But it would be great if it [face:nervous_left]didn't [wait:5]happen [wait:10]again.", "speechless", j)
				
				cutscene:wait(1)

				Assets.playSound("wing")
				r:shake() j:shake() s:shake()
				j.actor.default = "walk_serious"
				r:resetSprite() j:resetSprite() s:resetSprite()
				j:setFacing("down")

				cutscene:wait(1)
				

				
		
				cutscene:text("* Hey, [wait:5]wait.", "neutral_side", s)
				cutscene:text("* Did that glass always appear there?", "neutral_side", s)

				k.flip_x = false
				k:setPosition(k.x + 16, k.y)
				k:setFacing("right")

				j:setFacing("right")
				
				r:setFacing("right")
				

				Game:setFlag("disable_travel", true)
				Game.world.music:play("tiling")

				cutscene:wait(1)
				glass.should_light_up =  false
				
				cutscene:walkTo(j, 340, 140, 1)
				cutscene:text("* We don't really have a choice.", "disappointed", r)
				cutscene:text("* I'm going to see if it's safe...", "disappointed_down", r)

				cutscene:wait(cutscene:walkTo(r, 580, 120, 1, "right"))
				cutscene:wait(1)
				cutscene:wait(cutscene:walkTo(r, 700, 120, 2))

				j:setFacing("down")
				cutscene:text("* I think I'm going to go after.", "look_left", j)
				cutscene:text("* You have each others back for now, [wait:5]I have Ralsei's.", "look_left", j)
	
				cutscene:wait(cutscene:walkPath(
					j,
					{
						{580, 120},
						{700, 120},
					},
					{speed = 6}
				))

				j.actor.default = "walk"
				cutscene:wait(2)


				local spr = Sprite("effects/shine_white")
				spr:setOrigin(0.5)
				spr:setScale(2)
				Game.world:spawnObject(spr)
				spr:play(1/3, true)
				spr:setPosition(340, -20)
				cutscene:wait(cutscene:slideTo(spr, 340, 140, 3))
				Assets.playSound("noise")
				Assets.playSound("spell_pacify", 0.9, 0.5)
				cutscene:wait(2)
				k:setFacing("left")
				cutscene:text("* ...What is that?", "sus_nervous", s)

				cutscene:walkTo(s, 320, 140, 2)
				cutscene:wait(cutscene:walkTo(k, 390, 140, 2, 'left', true))

				s:setSprite("heal_kneel")
				cutscene:wait(1)

				cutscene:text("* ...It, [wait:5]kinda looks like glass.", "suspicious", s)
				cutscene:text("* Kinda reminds me of the Knight's... [wait:5]Y'know. [wait:10]Their sword.", "sus_nervous", s)
				
				spr:remove()
				Mod:setDarkShard(Mod.DarkShardID.FourthSanctuary, true)
				Assets.playSound("shard_get")
				cutscene:text("* (Susie obtained a [color:9999ff]Dark Shard.[color:white])")
				cutscene:wait(1)

				Assets.playSound("wing")
				s:shake(2)
				s.actor.default = "walk"
				s:resetSprite()

				cutscene:wait(1)

				cutscene:text("* We should, [wait:5]uh. [wait:10][face:neutral_side]\nGet going.", "neutral", s)
				cutscene:walkPath(
					s,
					{
						{580, 120},
						{800, 120},
					},
					{speed = 6}
				)

				cutscene:wait(cutscene:walkPath(
					k,
					{
						{580, 120},
						{800, 120},
					},
					{speed = 6}
				))
				Game:setFlag("fought_apathy", true)
				cutscene:mapTransition("3_4th_sanctuary/fourth_sanctum_12_final", "entry")
				return
			end
		else
			local choice = cutscene:choicer({"Name", "Allies", "Truce", "Location"})
			
			if choice == 1 then
				cutscene:text("* [voice:none]Useless information.[wait:10]\n* If you desire it,[wait:5] so be it.", {top = false})
				cutscene:text("* [voice:none]Kaleise.", {top = false})
			elseif choice == 2 then
				cutscene:text("* [voice:none]We are eight.", {top = false})
				cutscene:text("* [voice:none]Eight fellows,[wait:5] with magnitudes more around the globe.", {top = false})
				cutscene:text("* [voice:none]My loss is only fodder.", {top = false})
			elseif choice == 3 then
				cutscene:text("* [voice:none]A truce?[wait:10] Me,[wait:5] you?", {top = false})
				cutscene:text("* [voice:none]...My allegiance is with the Order.", {top = false})
			elseif choice == 4 then
				cutscene:text("* [voice:none]We do not have a \"base\", persay.", {top = false})
				cutscene:text("* [voice:none]We move in groups,[wait:5] forming one unit.", {top = false})
				cutscene:text("* [voice:none]Each unit consisting of its own commandant,[wait:5] and support.", {top = false})
			end
		end

		::postdialogue::
		cutscene:text("* [voice:none]...", {top = false})
		cutscene:text("* [voice:none]Are we done here?", {top = false})

		cutscene:wait(2)
		j:setFacing("down")
		j.actor.default = "walk_serious"
		j:resetSprite()
		cutscene:text("* What should we do with this guy, [wait:5]Kris?", "stern", j, {top = false})
		cutscene:text("* We exhausted our answers.", "stern", j, {top = false})

		local ch = cutscene:choicer({"Knock Out", "Pacify"})

		if ch == 1 then
			k.flip_x = false
			k:resetSprite()
			cutscene:wait(cutscene:walkTo(k, k.x - 20, k.y))
			k:shake(2)
			Assets.playSound("wing")
			k.flip_x = true
			k:setSprite("battle/attackready")
			cutscene:fadeOut(1, {music = true})
			cutscene:wait(2)
			local m = Sprite("effects/attack/cut")
			m:setPosition(300, 145)
			m.flip_x = true
			m:setScale(2)
			m:setOrigin(0.5)
			Game.world:spawnObject(m)
			m.layer = 99999
			cutscene:playSound("damage_echo")
			local waw = DamageNumber("damage", love.math.random(300, 400), a.x+20, a.y - 20)
			waw:setColor(Game.party[1].color)
			waw.layer = m.layer - 1
			Game.world:addChild(waw)
			m:setFrame(1)
			cutscene:wait(1/7)
			m:setFrame(2)

			cutscene:wait(1/7)
			m:setFrame(3)
			cutscene:wait(1/7)
			m:remove()
			cutscene:wait(2)
			Game.world.music:play("tiling")
			k.flip_x = false
			a:setSprite("fallen")
			k:resetSprite()
			cutscene:fadeIn(1, {music = true})
		else
			cutscene:wait(1)
			r.flip_x = true
			Assets.playSound("spellcast")
			cutscene:wait(cutscene:setAnimation(r, "battle/spell"))
			
			local mask = ColorMaskFX({0,1,0}, 1)
			a:addFX(mask)
			Game.world.timer:tween(1, mask, {amount = 0}, "linear", function()
				a:removeFX(mask)
			end)

			r:resetSprite()
			r.flip_x = false

			cutscene:wait(1.5)
			a:shake(2)
			Assets.playSound("wing")
			cutscene:wait(1)
			a:shake(4)
			k.flip_x = false
			k:resetSprite()
			k:setPosition(k.x + 16, k.y)
			k:setFacing("left")
			Assets.playSound("noise")
			a:setSprite("fallen")
		end

		cutscene:wait(2)

		local spr = Sprite("effects/shine_white")
		spr:setOrigin(0.5)
		spr:setScale(2)
		Game.world:spawnObject(spr)
		spr:play(1/3, true)
		spr:setPosition(325, 190)
		if ch == 2 then
			cutscene:text("* That takes care of that...", "disappointed", r)
		else
			cutscene:text("* That takes care of that.[react:1]", "exhausted_smile", s,{
				reactions = {
					{"Did you really have to \nhit that hard?", "rightmid", "bottommid", "nervous_left", "jamm"}
				}
			})
		end

		cutscene:text("* Kris! [wait:10]It looks like they dropped something...", "small_smile_side_b", r)
		
		cutscene:wait(cutscene:walkTo(k, 350, 198))
		cutscene:wait(1)
		cutscene:text("* (The object that the enemy dropped looks like glass.)")
		cutscene:text("* (And,[wait:5] tinted in color.)")
		cutscene:text("* (Instinctively, [wait:10]you pocket it.)")
		spr:remove()
		Mod:setDarkShard(Mod.DarkShardID.FourthSanctuary, true)
		Assets.playSound("shard_get")
		cutscene:text("* (You have obtained a [color:9999ff]Dark Shard.[color:white])")
		cutscene:wait(cutscene:walkTo(j, 275, 193, 1, "right"))
		
		cutscene:text("* Huh. [wait:10]You think these are related to the doors in the Travel area?", "look_left", "jamm")
		
		
		local glass = Game.world.map:getEvent("churchmagicglass")
		glass.hiddenalpha = 0.5
		if not Game.world.music:isPlaying() then
			Game.world.music:play("tiling")
		end
		glass.should_light_up =  true
		cutscene:wait(1)
		cutscene:text("* ...[wait:10]Hey, [wait:5][face:neutral]Kris.\n[wait:10]* That glass always been there?", "neutral_side", s)
		k.flip_x = false
		k:setFacing("right")
		j:setFacing("right")
		
		r:setFacing("right")
		cutscene:wait(1)
		glass.should_light_up = false
		cutscene:wait(1)
		cutscene:text("* It looks like a way out.", "look_left", j)
		cutscene:text("* We don't really have a choice...", "disappointed", r)
		
		cutscene:alignFollowers()
		cutscene:wait(cutscene:attachFollowers())
		if ch == 1 then
			cutscene:text("* (For some reason, [wait:10]when you knocked out the Cultist...)")
			Assets.playSound("dtrans_lw", 1, 2)
			cutscene:text("* (Everyone felt a little stronger.)")
			Game.level_up_count = Game.level_up_count+1
			for _, party in ipairs(Game.party) do
				party:onLevelUp(Game.level_up_count)
			end
		end
		cutscene:wait(1)
		a.solid = false
		cutscene:text("* Whenever you're ready, [wait:5]Kris.", "small_smile_side_b", r)
		k:setFacing("down")

		local trans = Transition(
			680, 
			40,
			{40, 160},
			{
				map = "3_4th_sanctuary/fourth_sanctum_12_final",
				marker = "entry"
			}
		)

		Game.world:addChild(trans)
		cutscene:attachCamera()
		Game:setFlag("fought_apathy", true)
			
	end
}
