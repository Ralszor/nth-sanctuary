return {
    flaf = function (cutscene, event)
        cutscene:text("* Hey! [wait:10]I'm Flafchef! [wait:10]Everybody loves me![react:1]", {
            reactions = {
                {"Like Nubert", "rightmid","bottom"}
            }
        })
        
    end,
    boid = function (cutscene)
        local boid = cutscene:getCharacter("boid")
        if Kristal.PluginLoader and next(Kristal.PluginLoader.plugin_scripts) ~= nil then
            cutscene:text("* Hi.[wait:5] I'm so sorry for what I've done.")
            if Game:getFlag("fun") == 66 then
                Assets.playSound("snd_mysterygo")
                boid:remove()
                Game:setFlag("hyperboid_dies_real_2027", true)
            end
        else
            cutscene:text([[
* Hey.[wait:5] I'm supposed to say[wait:5] "I need some generic NPC dialogue," but that's not really my thing."
]])
        end
    end,
    spawn = function(cutscene)
        local t = Game.world.map:getEvent(3)
        
        local susie = cutscene:getCharacter("susie")
        local ralsei = cutscene:getCharacter("ralsei")

        cutscene:detachFollowers()
        
        t:shake(10, 0)
        Assets.playSound("tspawn", 1, 1.25)
        cutscene:wait(1)
        Game.world.timer:tween(1, t, {x = t.x - 30, y = t.y - 30})
        cutscene:wait(1.2)
        t:shake(10, 0) 
        Assets.playSound("tspawn", 1, 1.25)
        cutscene:wait(0.5)
        Game.world.timer:tween(1, t, {x = t.x - 50, y = t.y + 50})
        cutscene:wait(1.2)
        t:shake(10, 0) 
        Assets.playSound("tspawn", 1, 1.25)
        cutscene:wait(0.5)
        cutscene:wait(cutscene:walkTo(susie, 540, 310, 1))
        cutscene:wait(1/4)
        cutscene:panTo(Game.world.camera.x + 100, Game.world.camera.y)
        Game.world.timer:tween(1, t, {x = t.x + 50, y = t.y + 20})
        cutscene:wait(cutscene:walkTo(susie, t.x, t.y, 2))
        susie:setSprite("diagonal_kick_right")
        susie.sprite:setFrame(1)
        cutscene:wait(1.2)
        t:shake(20, 0) 
        Assets.playSound("tspawn", 1, 1)
        susie.sprite:setFrame(2)
        cutscene:wait(0.5)
        susie.sprite:play(1/7, false)
        ralsei:setSprite("shocked_right")
        ralsei:shake()
        Assets.stopAllSounds()
        Assets.playSound("impact")
        Assets.playSound("damage")
        t.sprite.physics.direction = math.rad(-25)
        t.sprite.graphics.spin = 1
        t.physics.speed = 10
        t.physics.gravity = 1
        cutscene:during(function () if t.y > 700 then t:remove() end end)
        for i = 3, 5 do
            susie.sprite:setFrame(i)
            cutscene:wait(1/7)
        end
        cutscene:wait(1/3)
        susie:setSprite("point_laugh_right")
        susie:play(1/5)
        Assets.playSound("suslaugh")
        cutscene:wait(1)
        susie.sprite:stop()
        cutscene:text("* That takes care of that.", "smile", susie)
        cutscene:text("* S-Susie! [wait:10]That one didn't even seem like a threat![wait:5][react:1]", "concern", ralsei, {
            reactions = {
                {"Then again, they ARE Titan Spawn...", "middle", "bottom", "dismissive", "ralsei"},
            }
        })
        ralsei:resetSprite()
        susie:resetSprite()
        cutscene:attachCamera()
        cutscene:wait(cutscene:attachFollowers())

        cutscene:text("* (Would you like to see the consequences of Susie's actions?)")
        local ch = cutscene:choicer({"Yes", "No"})

        if ch == 1 then
            cutscene:text("* (Keep walking.)")
            local kris = cutscene:getCharacter("kris")
            local b = Game.world:spawnObject(ChaserEnemy("buff_spawn", 1480, 260, {encounter = "buff_spawn"}))
            cutscene:wait(cutscene:walkTo(kris, 1200, 260, 5))
            cutscene:wait(1)
            Assets.playSound("spawn_weaker", 1, 0.5)
            Game.world.camera:shake(20, 0)
            b:setSprite("throw")
            for i = 1, 4 do
                b.sprite:setFrame(i)
                cutscene:wait(1/6)
            end
            cutscene:wait(1.2)
            cutscene:wait(cutscene:slideTo(b, kris.x,kris.y,0.5))
        else
            local spr = Sprite("battle/enemies/titanspawn/idle")
            Game.world:addChild(spr)
            spr.x, spr.y = susie.x, -40
            spr.layer = 9999
            spr:setOrigin(0.5, 0.5)
            Assets.playSound("hraaaugh")
            cutscene:wait(1/2)
            Assets.playSound("fall")
            spr.physics.gravity = 0.75
            spr.graphics.spin = 0.3
            spr.physics.speed = 0
            cutscene:wait(function()
                return spr.y > (susie.y - susie.height/1.5)
            end)
            spr.physics.gravity_direction = math.rad(85)
            spr.physics.speed_y = -20
            spr.physics.gravity = 2
            Assets.playSound("hurt")
            susie:shake()
            Game.world:hurtParty("susie", Game.party[2].health-1)
            susie:setSprite("battle/swooned")
            Assets.stopAndPlaySound("clonk",1, 1.05)
            cutscene:wait(1/12)
            Assets.stopAndPlaySound("clonk",1, 1.1)
        end
         Game:setFlag("fought_titren", true)
    end,
    clean = function(cutscene)
        local h = Game.inventory:hasItem("rake")
        local a = Game:getFlag("cleanup") if a then return end
        if h then
            cutscene:text("* (The glass shards that fell off this tree look like leaves.)")
            cutscene:text("* (...[wait:5]Well, [wait:5]you happen to have a rake.)")
            cutscene:text("* (Do janitor things?)")
            local ch = cutscene:choicer({"Yes", "No"})
            if ch == 1 then goto clean else
                cutscene:text("* (And they shall remain.)")
                return
            end
            ::clean::
            cutscene:fadeOut(1)
            for i = 1, 4 do
                cutscene:wait(20/30)
                Assets.playSound("leaf_dodge")
            end
            local glass = Game.world.map:getEvent(11)
            cutscene:text("* (You used the rake to clean up the glass shards.)")
            cutscene:text("* (...Well, [wait:5]you did your best, [wait:5]but there is no trash bin.)")
            cutscene:text("* (Reluctantly,[wait:5] you sweep them off the side of the platform.)")
            cutscene:wait(1)
            glass:remove()
            cutscene:fadeIn(1)
            cutscene:text("* (But, [wait:5]one leaf looked to remain. [wait:10]One you forgot.)")
            cutscene:text("* (Unlike the others, [wait:5]this one is black in color.)")
            cutscene:text("* (It twinges with a strange energy...)")
            cutscene:text("* (You pick it up, [wait:5]and realize it's a [color:9999ff]Dark Shard.[color:white].)")
            Assets.playSound("shard_get")
			cutscene:text("* (You obtained a [color:9999ff]Dark Shard.[color:white])")
			Mod:setDarkShard(Mod.DarkShardID.LeafRoomShard, true)
            Game:setFlag("cleanup", true)
        else
            cutscene:text("* (The glass shards that fell off this tree look like leaves.)")
        end
    end,
    sans = function(cutscene)
        local sans = cutscene:getCharacter("sans")
        local flag = Game:getFlag("got_rake")
        cutscene:setSpeaker(sans)
        if not flag then
            cutscene:text("* heya.", "neutral")
            cutscene:text("* someone gotta babysit these kids.", "look_left")
            cutscene:text("* actually, [wait:5]want a rake? [wait:10][face:wink]don't need it anymore.", "neutral")
            local ch = cutscene:choicer({"Yes", "No"})
            if ch == 1 then
                cutscene:text("* here. [wait:5]have fun.", "neutral")
                Game.inventory:addItem("sound_stone")
                cutscene:setSpeaker()
                Assets.playSound("item")
                cutscene:text("* You got a Rake.")
                Game:setFlag("got_rake", true)
                Game.inventory:addItem("rake")
            else
                cutscene:text("* well, [wait:5]if you're sure...", "neutral")
                cutscene:text("* just don't come back when you're raked from whatever you're doing.", "joking")
            end
        else
            cutscene:text("* heya.", "neutral")
            cutscene:text("* someone gotta babysit these kids.", "look_left")
            cutscene:text("* enjoying the rake? [wait:10][face:wink]it really isn't one to be leafed alone.", "neutral")
        end
        
        
    end,
    sans2 = function(cutscene)
        local sans = cutscene:getCharacter("sans")
        local flag = Game:getFlag("got_rake")
        cutscene:setSpeaker(sans)
        if not flag then
            cutscene:text("* heya.", "neutral")
            cutscene:text("* someone gotta babysit these kids.", "look_left")
        else
            cutscene:text("* heya.", "neutral")
            cutscene:text("* someone gotta babysit these kids.", "look_left")
            cutscene:text("* actually, [wait:5]want a rake? [wait:10][face:wink]don't need it anymore.", "neutral")
            cutscene:text("* ...i gave it to you already? [wait:10][face:joking]i can't beleaf this.", "neutral")
        end
        
        
    end,

    untroll = function (cutscene)
        local get = Game:getFlag("untroll_moss")
        if not get then
            Game.world.music.volume = 0
            Assets.playSound("moss_fanfare",1, 1.25)
            cutscene:text("* You found the [color:green]Moss!")
            Game.inventory:addItem("moss")
            Game.world.timer:tween(1, Game.world.music, {volume = 1})
            Game:setFlag("untroll_moss", true)
            Game:setFlag("trolled", false)
            Game:setFlag("#citadel_room2#6:opened", false)
        elseif get == true then
            cutscene:text("* (You already got the moss.)")
            Game:setFlag("#citadel_room2#6:opened", false)
            Game:setFlag("trolled", false)
        end
    end,

    mason = function (cutscene)
        local intMason = Game:getFlag("intMason", 0)
        local belch = Game:getFlag("belch", false)
        local belch2 = Game:getFlag("belch2", false)
        local belch3 = Game:getFlag("belch3", false)
        local belch4 = Game:getFlag("belch4", false)
        local mason = cutscene:getCharacter("mason")
        if not belch then
            if intMason >= 1 then
                cutscene:text("> i am still mason.[wait:5] im in a very [gold]golden[gold:ungold] mood right now.", { indent_string = "> " }, mason)
                cutscene:text("> let me just tell you again to please do not mention the [color:red]belch.plorgius[color:reset].", { indent_string = "> " }, mason)
                local ch = cutscene:choicer({"Mention", "Do Not"})
                if ch == 2 then
                    cutscene:text("> most people would've mentioned it by now.[wait:5] thank you for not.", { indent_string = "> " }, mason)
                    cutscene:text("> here's your terrific prize:[wait:10]\n> [rainbow]New Future![rainbow:unrainbow]", { indent_string = "> " }, mason)
                else
                    mason:setSprite("fell")
                    Assets.playSound("noise")
                    Assets.playSound("bump")
                    cutscene:wait(0.5)
                    cutscene:text("> owww...[wait:5] the horrors of the [color:red]belch.plorgius[color:reset]...", { indent_string = "> " }, mason)
                    Game:setFlag("belch", true)
                end
            else
                cutscene:text("> i am mason.[wait:5] im in a very [gold]golden[gold:ungold] mood right now.", { indent_string = "> " }, mason)
                cutscene:text("> but please do not mention the [color:red]belch.plorgius[color:reset].", { indent_string = "> " }, mason)
                cutscene:text("> things you can mention include:[wait:5] [color:#ffb467]funnyfeline[color:reset],[wait:5] deltarune,[wait:5] undertale,[wait:5] [color:#0085fa]tts bot[color:reset],[wait:5] etc.", { indent_string = "> " }, mason)
                cutscene:text("> [rainbow]New Future![rainbow:unrainbow]", { indent_string = "> " }, mason)
            end
        elseif not belch2 then
            cutscene:text("> why would you do this to me.", { indent_string = "> " }, mason)
            cutscene:text("> please dont mention it again.", { indent_string = "> " }, mason)
            local ch = cutscene:choicer({"Mention", "Do Not"})
            if ch == 2 then
                cutscene:text("> ... thank you.", { indent_string = "> " }, mason)
            else
                Game:setFlag("belch2", true)
                Game:saveQuick()
                Game:gameOver(Game.world.player.x, Game.world.player.y)
            end
        elseif not belch3 then
            cutscene:text("> man WHAT did I tell you about not mentioning it.", { indent_string = "> " }, mason)
            local ch = cutscene:choicer({"Mention", "Do Not"})
            if ch == 2 then
                cutscene:text("> ... are you really thinking about saying it again?", { indent_string = "> " }, mason)
            else
                Game:setFlag("belch3", true)
                Game:saveQuick()
                Game:gameOver(Game.world.player.x, Game.world.player.y)
            end
        elseif not belch4 then
            cutscene:text("> so did you hear about the belch.plorgius from that man in hell?", { indent_string = "> " }, mason)
            cutscene:text("> good.", { indent_string = "> " }, mason)
            local ch = cutscene:choicer({"Mention", "Do Not"})
            if ch == 2 then
                cutscene:text("> ... are you really thinking about saying it again?", { indent_string = "> " }, mason)
            else
                Game:saveQuick()
                Game:gameOver(Game.world.player.x, Game.world.player.y)
            end
        else
            cutscene:text("> WHAT HAVE YOU DONE!!??", { indent_string = "> " }, mason)
            cutscene:text("> [rainbow]NONONONONONONONONONONONONONONON\nONONONONONONONONONONONONO-[rainbow:unrainbow]", { indent_string = "> ", auto = true }, mason)
            mason:explode()
            Game:setFlag("nomoremasonsad", true)
        end
        Game:setFlag("intMason", intMason + 1)
    end,

    INSERTBELCHPLORGIUS = function(cutscene)
        local function texter(text, x, y, persist,waitfor)
            text = DialogueText("[speed:0.03][font:vcr, 48][voice:none]" .. text, x or 160, y or 40, SCREEN_WIDTH, SCREEN_HEIGHT, {align = "left"})
            text.layer = 101
            text.can_advance = false
            text.align = "center"
            text.skip_speed = true
            local fade = 0
            Game.stage:addChild(text)
            if not persist then
                cutscene:wait(function () return not text:isTyping() end)
                cutscene:wait(0.75)
                text:advance()
                cutscene:wait(function () return text:isDone() end)
                cutscene:wait(0.75)
            else
                --[[ cutscene:wait(waitfor)
                cutscene:during(function ()
                    if fade < 1 then
                        fade = fade + DTMULT * 0.05
                        text:setColor(1, 1, 1, 1 - fade)
                    end
                end)
                cutscene:wait(function () return fade >= 1 end)
                Game.stage:removeChild(text)
                cutscene:wait(0.75) ]]
                cutscene:wait(function () return not text:isTyping() end)
                cutscene:wait(0.75)
                text:advance()
                cutscene:wait(function () return text:isDone() end)
                cutscene:during(function ()
                    if fade < 1 then
                        fade = fade + DTMULT * 0.05
                        text:setColor(1, 1, 1, 1 - fade)
                    end
                end)
                cutscene:wait(function () return fade >= 1 end)
                cutscene:wait(0.75)
            end
        end

        local rect = Game.stage:addChild(Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))
        rect:setLayer(100)
        Kristal.hideBorder()
        rect:setColor(COLORS.black)
        Game.world.music:play("snd_plorgius_next", 1.25, 0.65)
        Game.stage:addFX(CrtFX(), "vhsfx")
        cutscene:wait(1)
        texter("Insert The[wait:80]\nBelch.Plorgius.[wait:120]", nil, nil)
        Mod.inserted_plorgius = nil
        cutscene:wait(function() return Mod.inserted_plorgius ~= nil end)
        Game.stage:removeFX("vhsfx")

        
        Game:setFlag("belch4", true)
        Game:saveQuick()
        Game:gameOver(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
    end,

    hell_mason = function(cutscene)
        local interactedCount = Game:getFlag("hellmason_intCount", 0)
        local mason = cutscene:getCharacter("mason")
        
        if interactedCount == 0 and not Game:getFlag("belch4") then
            cutscene:setSpeaker(mason)
            cutscene:text("[color:#808080]> the plorgius image format...")
            cutscene:text("[color:#808080]> the plorgius image format is a simple image format.")
            cutscene:text("[color:#808080]> here is what it stands for:[wait:5]\n> Potentially[wait:5] Long[wait:5] (or)[wait:5] Good[wait:5] Image[wait:5] (with)[wait:5] Useful[wait:5] S#!%.")
            cutscene:text("[color:#808080]> [color:red]it[color:#808080][wait:5] is the [color:red]it[color:#808080][wait:5] that ral mentions.")
            cutscene:text("[color:#808080]> he created it,[wait:5] so you must not be fooled by his lies.")
            cutscene:text("[color:#808080]> mention it to ral,[wait:5] and insert it.")
        elseif interactedCount >= 1 and not Game:getFlag("belch4") then
            cutscene:setSpeaker(mason)
            cutscene:text("[color:#808080]> mention it to ral,[wait:5] and insert it.")
        elseif Game:getFlag("belch4") then
            cutscene:setSpeaker(mason)
            cutscene:text("[color:#808080]> IT HAS BEEN INSERTED...!")
            mason:explode()
            cutscene:wait(1.5)
            cutscene:text("[instant]* ", "shock", "susie")
            cutscene:text("[instant]* ", "shock_down", "susie")
            cutscene:text("[instant]* ", "shock_nervous", "susie")
            cutscene:text("* Kris let's not talk to that guy again", "shock_nervous", "susie")
            Game:setFlag("hellmason_foundout", true)
        end

        Game:setFlag("hellmason_intCount", interactedCount + 1)
    end,

    ralszor = function(cutscene)
        local ralszorintcount = Game:getFlag("ralszor_intCount", 0)
        local ralszor = cutscene:getCharacter("ral")

        if Game:getFlag("hellmason_intCount", 0) >= 1 and not Game:getFlag("belch4") then
            cutscene:gotoCutscene("konverge.INSERTBELCHPLORGIUS")
        elseif Game:getFlag("belch4") then
            cutscene:setSpeaker(ralszor)
            cutscene:text("[style:none][font:main,48]*[font:main,72] You saw nothing.")
        elseif ralszorintcount == 0 then
            cutscene:setSpeaker(ralszor)
            cutscene:text("* I have no connection to Ralsei whatsoever I am Ralszor")
            cutscene:text("* Dont drag me into [color:red][style:none]it")
        elseif ralszorintcount == 1 then
            cutscene:setSpeaker(ralszor)
            cutscene:text("* stop it youre dragging me into [color:red][style:none]it")
        elseif ralszorintcount >= 2 then
            cutscene:setSpeaker(ralszor)
            cutscene:text("[color:red][style:none][font:main,48]*[font:main,72] it")
        end

        Game:setFlag("ralszor_intCount", ralszorintcount + 1)
    end,

	ddelta = function(cutscene)
        local ddelta = cutscene:getCharacter("ddelta")
		cutscene:text("[image:ui/ddelta_asterisk]ddelta here, i helped\n code this lil game!", "aha", ddelta)
		cutscene:text("[image:ui/ddelta_asterisk]ask me anything will ya", "neutral", ddelta)
        local ch = cutscene:choicer({"Can you\nturn into\na prism", "Ask about\nlore", "Nah"})
		if ch == 1 then
			if Game:getFlag("ddeltaPrismed", false) then
				cutscene:text("[image:ui/ddelta_asterisk]nah,[wait:5] not doing it twice", "lookdown", ddelta)
			else
				cutscene:text("[image:ui/ddelta_asterisk]hey,[wait:5] i only did that\n ONCE as a joke.", "neutral", ddelta)
				cutscene:text("[image:ui/ddelta_asterisk]i don't do it all the\n time yknow", "lookdown", ddelta)
				cutscene:text("[image:ui/ddelta_asterisk](and technically me\n turning into a prism\n isn't even canon...)", "helpme", ddelta)
				local ch = cutscene:choicer({"Do it anyway", "Okay"})
				if ch == 1 then
					cutscene:text("[image:ui/ddelta_asterisk]alright, fiiiine, i'll do\n it", "helpme", ddelta)
					Game.world.music:pause()
					local dd_y = ddelta.y
					Assets.playSound("3dprism_appear")
					local wave_mag = 0
					local function getFXWaveMag()
						return wave_mag
					end
					ddelta:addFX(ShaderFX("wave_interlace", {
						["wave_sine"] = function () return Kristal.getTime() * 100 end,
						["wave_mag"] = function () return getFXWaveMag() end,
						["wave_height"] = 2,
						["texsize"] = { SCREEN_WIDTH, SCREEN_HEIGHT }
					}), "funky_mode")
					Game.world.timer:during(15/30, function()
						ddelta.y = MathUtils.lerp(ddelta.y, dd_y - 40, 0.125)
						wave_mag = MathUtils.lerp(wave_mag, 120, 0.125)
					end)
					cutscene:wait(15/30)
					wave_mag = 60
					prism_sprite = Sprite("enemies/3d/idle", ddelta.x, dd_y)
					prism_sprite:setLayer(ddelta.layer)
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
					ddelta.visible = false
					Game.world.timer:during(15/30, function()
						wave_mag = MathUtils.lerp(wave_mag, 0, 0.25)
					end)
					cutscene:wait(15/30)
					wave_mag = 0
					cutscene:wait(2)
					prism_sprite:remove()
					ddelta.y = dd_y
					ddelta.visible = true
					Assets.stopSound("3dprism_appear")
					Game.world.music:resume()
					cutscene:text("[image:ui/ddelta_asterisk]there ya go!", "lookup", ddelta)
					cutscene:text("[image:ui/ddelta_asterisk]i'm not doing that again\n by the way", "helpme", ddelta)
					Game:setFlag("ddeltaPrismed", true)
				end
			end
		elseif ch == 2 then
			if Mod:checkIndoct(10) and not Game:getFlag("ddelta_knows", false) then
				local ddelta_layer = ddelta.layer
				cutscene:wait(0.25)
				Game.world.music:pause()
				Assets.playSound("noise")
				local rect = Rectangle(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				rect:setColor(COLORS.black)
				rect:setParallax(0)
				rect.layer = WORLD_LAYERS["ui"] - 2
				Game.world:addChild(rect)
				Kristal.hideBorder(0)
				ddelta.layer = WORLD_LAYERS["ui"] - 1
				cutscene:wait(5)
				cutscene:text("[speed:0.4][image:ui/ddelta_asterisk]I know what you did.", "neutral", ddelta)
				ddelta.layer = ddelta_layer
				rect:remove()
				Game.world.music:resume()
				Game:setFlag("ddelta_knows", true)
				Kristal.showBorder(0)
			else
				cutscene:text("[image:ui/ddelta_asterisk]funny story i actually\n don't know the lore much\n either", "neutral", ddelta)
				cutscene:text("[image:ui/ddelta_asterisk]i do the coding,[wait:5] not the\n story", "lookup", ddelta)
				cutscene:text("[image:ui/ddelta_asterisk]ya got the wrong guy for\n this one,[wait:5] sorry", "lookdown", ddelta)
			end
		end
	end,
    mangle = function (cutscene, event)
        cutscene:text("* (Join it for a bite?)")
        local bite = cutscene:choicer({"Yes", "No No No\nNo No No\nNo No No"})
        if bite == 1 then
            Game.world.music:fade(0,1)
            cutscene:wait(1.5)
            
            cutscene:playSound("noise")

            local rect = Rectangle(0, 0, 960, 480)
            rect:setColor(0, 0, 0)
            rect.parallax_x = 0
            rect.parallax_y = 0
            rect.layer = WORLD_LAYERS["ui"] + 1
    
            Game.world:addChild(rect)
            Game:setBorder("none", 0)
            cutscene:wait(3)

            local m_anim = Sprite("misc/mangle_jumpscare/mangle_jumpscare")
            Assets.playSound("fnaf_scream")
            m_anim:play(1 / 19, false)
            m_anim.layer = WORLD_LAYERS["ui"] + 3
            m_anim.x = m_anim.x - 50
            m_anim.y = m_anim.y - 2
            m_anim.parallax_x = 0
            m_anim.parallax_y = 0
            m_anim:setScale(0.7)
            Game.world:addChild(m_anim)
    
            cutscene:wait(1.5)

            rect:setColor(1, 0, 0)
            m_anim:remove()
            Assets.stopSound("fnaf_scream")
            Game:saveQuick()
            Game:gameOver(Game.world.player.x, Game.world.player.y)
        end
    end,
    cruel = function (cutscene, event)
        if Game:getFlag("cruelled") then
            cutscene:text("* (Never again.)")
            if Game:getFlag("cruelled") == 1 then
                cutscene:text("* (...Actually, [wait:5]the [color:red]Jellycruel[color:white] left something behind.)")
                cutscene:text("* (It was an axe.)")
                Assets.playSound("item")
                Game.inventory:addItem("cruelaxe")
                cutscene:text("* (You obtained the [color:red]CruelAxe[color:white].)")
                Game:setFlag("cruelled", 2)
            end
            return
        end
        for _, child in ipairs(event.children) do
            if child:includes(TileObject) then
                child:remove()
            end
        end
        event:setSprite("world/objects/treasure_chest_2")
        event:setScale(2, 1)
        Assets.playSound("locker")
        cutscene:text("* (You looked inside the chest...)")
        local cr = cutscene:spawnNPC("jellycruel", 160, 380)
        cr:setScale(0, 4)
        cr.alpha = 0
        Game.world.timer:tween(1, cr, {scale_x = 1, scale_y = 1, alpha = 1}, 'out-expo')
        cr.layer = 1000
        cutscene:wait(0.8)
        cutscene:text("* (Inside, [wait:5]was a [color:red]Jellycruel!")
        local src = Assets.playSound("tensionhorn")
        src:setPitch(0.7)
        cutscene:wait(10/30)
        local src = Assets.playSound("tensionhorn")
        src:setPitch(0.8)
        cutscene:wait(12/30)
        cutscene:startEncounter("jellycruel")
        Game:setFlag("cruelled", 1)
        cr:remove()
        event:setSprite("world/objects/treasure_chest_1")
    end,
    scammed = function (cutscene)
        local sp = cutscene:getCharacter("spamton")
        local function emote(who, anim, sound, shakex, shakey, fric)
            who:setAnimation(anim)
            cutscene:shakeCharacter(who, shakex or 4, shakey or 0, fric or 1)
            if sound then
                Assets.playSound(sound)
            end
        end
        cutscene:setSpeaker(sp)
        if Game:getFlag("scammed") then
            cutscene:text("* No Refunds[wait:10][font:main, 16]TM")
            return true
        end
        cutscene:text("* KRIS!!! [wait:10]MY FAVORITE [[Esteemed Customer]]")
        cutscene:text("* MAY I INTEREST YOU IN A [[Distinct Healing Item]]?")
        emote(sp, "grab", "wing")
        cutscene:text("* A [[Deal]] SO GOOD, [wait:10][func:em][[Even I don't want it!]]", {
            functions = {
                em = function()
                    emote(sp, "armsup_laugh", "wing")
                end
            }
        })
        cutscene:text("* ONLY FOR THE PRICE OF 500 KROMER.")
        emote(sp, "grab", "wing")
        cutscene:text("* WHADDYA SAY, [wait:5][friend][shake:0][Friend][friend:unfriend]?")
        local ch = cutscene:choicer({"Deal", "No Deal"})
        if ch == 2 then
            Game.world.music:pause()
            cutscene:wait(2)
            sp:setAnimation("dark")
            cutscene:text("* Oh. [wait:10]Ok.")
            Game.world.music:resume()
        elseif ch == 1 then
            if Game.money < 500 then
                cutscene:text("* WHAT??!?! [wait:10]YOU DON'T HAVE ENOUGH [[Wacky Stacks]]?!?")
                cutscene:text("* [[Outrageous]], [wait:10]YOU HEAR ME?")
                if cutscene:getCharacter("jamm") then
                    cutscene:text("* SORRY [friend][[Friend]][friend:unfriend], [wait:5][[I don't give credit!]][react:1]",{
                        reactions = {
                            {"Do you take \nMonopoly Money?", "right", "bottommid", "troll", "jamm"}
                        }
                    })
                else
                    cutscene:text("* SORRY [friend][[Friend]][friend:unfriend], [wait:5][[I don't give credit!]]")
                end
                cutscene:text("* COME BACK [[When you're a little, [wait:5]mmmm, [wait:5]RICHER!]]")
                goto endcut
            end
            Game.money = Game.money - 500
            sp:setSprite("laugh_left")
            sp.sprite:play(1/15)
            cutscene:slideTo(sp, sp.x+20, sp.y, 0.5, 'out-expo')
            cutscene:text("* THANK YOU [[Little Sponge]] FOR THE [[Bits!]]")
            cutscene:text("* ENJOY THIS [[Toxic Gift]] THAT YOU WILL")
            sp.sprite:stop()
            sp.sprite:setFrame(2)
            cutscene:wait(1)
            sp:setAnimation("dark")
            cutscene:text("* [Hyperlink Blocked].")
            sp:setSprite("glitch_laugh/glitch_laugh")
            sp.sprite:play(0.1)
            cutscene:text("* EAHAHAHAHAH!")
            sp.sprite:stop()
            sp.sprite:setFrame(20)
            cutscene:wait(1)
            cutscene:slideTo(sp, sp.x-20, sp.y, 0.5, 'out-expo')
            emote(sp, "arms", "wing")
            cutscene:text("* No Refunds[wait:10][font:main, 16]TM")
            cutscene:setSpeaker()
            Assets.playSound("item")
            cutscene:text("* (You got the S.POISON.)")
            Game.inventory:tryGiveItem("s_poison", true)
            Game:setFlag("scammed", true)
        end
        ::endcut::
        sp:resetSprite()
    end,
    ---@param cutscene WorldCutscene
    ---@param event NPC
    starwalker = function (cutscene, event)
        cutscene:text("* These design choices              [color:yellow]suck")
        cutscene:text("* I'm the original [shake:4][image:ui/funnytext_star][func:funny_text][shake:0]                               walker...", nil, nil, {
            functions = {
                funny_text = function ()
                    for _, sprite in ipairs(cutscene.textbox.text.children) do
                        if sprite:includes(Sprite) and sprite.texture_path == 'ui/funnytext_star' then
                            sprite:setScale(1.3)
                            sprite:setScaleOrigin(.5)
                            sprite.timer = Timer()
                            sprite:addChild(sprite.timer)
                            Assets.playSound("mercyadd")
                            sprite.timer:approach(10/30, 1.5, 1, function (value)
                                sprite:setScale(value)
                            end, "out-elastic")
                            sprite.timer:every(1/30, function ()
                                sprite.x = sprite.init_x + MathUtils.random(1, 3)
                                sprite.y = sprite.init_y + MathUtils.random(1, 3)
                            end)
                        end
                    end
                end
            }
        })
    end,
    bunny = function (cutscene, event)
        cutscene:text("* (A bunny.)")
        if event.interact_count > 1 and Game:hasPartyMember("noelle") then
            local n = cutscene:getCharacter("noelle")
            cutscene:setSpeaker(n)
            cutscene:text("* Aww, [wait:5]a bunny!", "smile_closed")
            cutscene:text("* I love you, [wait:5]bunny!", "smile_closed_b")
            local a = Game.world.camera
            Game.world.timer:tween(1, a, {zoom_x = 2, zoom_y = 2}, 'out-cubic')
            cutscene:wait(2)
            local g = Textbox(56,344, 529, 103, 100, 100)
            Game.stage:addChild(g)
            g:setText("[font:main,72][style:none][color:red][noskip][speed:0.4]GO F#%@ YOURSELF!")
            Game.world.music:pause()
            Assets.playSound("go_fuck")
            cutscene:wait( function ()
                return g.text:isTyping()==false
            end)
            g:remove()
            a.zoom_x, a.zoom_y = 1, 1
            event:explode()
            Game.world.music:resume()
            cutscene:text("* ", "what")
            cutscene:text("* why did it do that-", "what_smile")
            
            --cutscene:text("[font:main,72][style:none][color:red]GO F#%@ YOURSELF!")
        end
    end,
    camac = function (cutscene)
        cutscene:text("[noskip]* [sound:camac117]camac [wait:18]one hundred [wait:5]and [wait:9]seven[wait:5]teen")
        cutscene:text("[noskip]* [sound:bigballsmetalgear]big balls [wait:25]metal [wait:4]gear")
    end,
    kay = function (cutscene)
        cutscene:text("* Hi, I'm Jade!")
        cutscene:text("* What do you wanna Know?")
        local choicer= cutscene:choicer({"Ask About Lore","Are you a dev?","your stupoid lookig","Bye"})
        if choicer == 1 then
            cutscene:text("* That's for you to discover.")
            cutscene:text("* I wish you luck.")
elseif choicer == 2 then
   cutscene:text("* Uhhh[next]")
   cutscene:text("* Uhhh Uhm-[next]")
   cutscene:text("* so[next]")
   cutscene:text("* you see-[next]")
   cutscene:text("* Yes, I am.[wait:3][next]")
   cutscene:text("* Definetely.[wait:3][next]")
   cutscene:text("* Is that all?")
elseif choicer == 3 then
    cutscene:text("* Learn to spell, dumbass.")
    if not Game:getFlag("jade_link") then
    cutscene:text("[font:main,20][color:1985fc][style:none]* https://www.merriam-webster.com/")
    Game:setFlag("jade_link", true)
else
  cutscene:text("[font:main,20][color:a591dc][style:none]* https://www.merriam-webster.com/")
end
else 
    cutscene:text("* Goodbye, and good luck!")
   return
end
            
    end
}
