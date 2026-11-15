return {
	jack = function (cutscene, event)
		local flag = Game:getFlag("talkedtojack")
		local s = cutscene:getCharacter("susie")
		if flag then 
			cutscene:text({
			"* (A bunch of old history books. [wait:10]Sadly, [wait:5]they're in your way.)",
			"* (You can still hear Jackenstein crying through the doorway...)",
			})
			cutscene:setSpeaker(s)
			cutscene:text("* Kris, let's just give him some time alone...", "dejected")
			return
		end
		
		cutscene:text({
			"* (A bunch of old history books. [wait:10]Sadly, [wait:5]they're in your way.)",
			"* (...But, [wait:5]you can hear a deep voice crying from beyond.)",
		})
			cutscene:setSpeaker(s)
			cutscene:text("* Hey, [wait:5]wait. [wait:10]Is that Jack?", "surprise_smile")
			cutscene:setSpeaker()
			cutscene:text("* [voice:jack]...SCAIRY... GO NO FAERTHER....")
			cutscene:setSpeaker(s)
			cutscene:text("* Jack, [wait:5]what are you doing back there??", "surprise_frown")
			cutscene:setSpeaker()
			cutscene:text("* [voice:jack]AX... [wait:10]FELL THROAGH SCEILING...")
			cutscene:text("* [voice:jack]PROATECTING FROM SCAIRY FIGORE...")
			cutscene:setSpeaker(s)
			cutscene:text("* So THAT'S where it went! [wait:10][face:surprise_smile]Can you give it back to me?", "surprise", {auto = true})
			cutscene:setSpeaker()
			cutscene:text("* [voice:jack]ME MISS OLDMAN... I MISS T...")
			cutscene:text("* [voice:jack]ME WANTES TIME TO REHMAEMBER...")
			cutscene:text("* [voice:jack]COAM BACHK SOON...? [wait:10]I JUST NEED SOME TAIME ALOAN WITH IT...")
			cutscene:setSpeaker(s)
			cutscene:text("* [wait:5]...Alright... [wait:10]I miss him too...", "bangs_neutral")
			cutscene:text("* See you later, [wait:5]I guess...", "bangs_neutral")
			Game:setFlag("talkedtojack", true)
	end,
    oldman = function(cutscene, event)
        local susie, ralsei, kris = cutscene:getCharacter("susie"),cutscene:getCharacter("ralsei"),cutscene:getCharacter("kris")
		cutscene:detachCamera()
		cutscene:detachFollowers()
        for _, save in ipairs(Game.world.map:getEvents("savepoint")) do
            save.visible = false
        end

		Assets.playSound("sussurprise")
		susie:setSprite("surprise_step")
		susie:shake()
		
		cutscene:setSpeaker(susie)
		cutscene:text("* ... Old man!", "dejected_scared")

		susie:resetSprite()
		susie:walkTo(481, 960, 1.5)
		cutscene:wait(cutscene:panTo(484, 784, 1.5))
		cutscene:wait(0.01)
		susie:setFacing("up")

		cutscene:wait(.5)
		cutscene:text("* ... [wait:5]He's not here.", "dejected")

		cutscene:wait(1)
		Assets.playSound("sussurprise")
		susie:shake()
		susie:setSprite("exasperated_left")
		cutscene:text("* Why,[wait:5] of COURSE he wouldn't be here!", "angry_e")
		cutscene:text("* If he would then he'd...", "angry_look")

		cutscene:wait(1.5)
		Assets.playSound("wing")
		susie:shake()
		susie:setFacing("down")
		susie:setSprite("walk_unhappy")
		cutscene:text("* ...", "dejected")
		susie:setFacing("left")
		cutscene:text("* ... Whatever.[wait:5]\n* Let's just explore this place for a bit.", "dejected_look")
		cutscene:text("* Maybe we can find something interesting.", "dejected_smile")
		
		cutscene:attachCamera()
		susie:walkTo(340, 960, 1)
		cutscene:wait(1)
        cutscene:wait(cutscene:attachFollowers())
		kris:setFacing("down")
		susie:setFacing("down")
        for _, save in ipairs(Game.world.map:getEvents("savepoint")) do
            save.visible = true
        end
		Game:setFlag("enteredGersonStudy", true)
    end,
    fountain = function(cutscene, event)
		if not Game:getFlag("interactedWithFountain", false) then
			cutscene:text("* (It's a pool of water. ...[wait:5] huh?)")
			cutscene:text("* (A feather drifted into it...[wait:5] and turned into coins!)")
			cutscene:text("* (Throw something inside?)")
			Game:setFlag("interactedWithFountain", true)
		else
			cutscene:text("* (It's a pool of water. Throw something in?)")		
		end
        Game:enterShop("toss_fountain")
    end,
    table = function(cutscene, event)
		--[[if not Game:getFlag("interactedWithTable", false) then
			Game:setFlag("interactedWithTable", true)
		else]]
			cutscene:text("* Umm,[wait:5] would you like anything,[wait:5] Kris?", "blush_smile", "ralsei")
			cutscene:text("* (Make sure to pay for it, Kris.)", "shy_b", "susie")
		--end
        local choicer = cutscene:choicer({"Buy", "Do not"})
        if choicer == 1 then
			Game:enterShop("gerson_table")
		end
    end,
	book = function (cutscene, event)
		local flag = Game:getFlag("readCount")
		local books = {
			[1] = {
				"* \"We sought another power when the old rites yielded nothing.\"",
				"* \"One of our acolytes returned from a small town bearing transcripts and polaroids.\"",
				"* \"The writings described darkness made manifest.\"",
				"* \"Not an absence of light, [wait:5]but a place given form.\"",
				"* \"The photographs should have been impossible.\"",
				"* \"Rooms stretched beyond the walls which contained them.\"",
				"* \"Someone in that town discovered this before us.\"",
				"* \"They studied it. [wait:10]We shall give it purpose.\"",
			},
			[2] = {
				"* \"The transcripts explained the wound, [wait:5]but not the hand which must inflict it.\"",
				"* \"Six blades broke. [wait:5]Three rooms remained ordinary.\"",
				"* \"On the seventh attempt, [wait:5]the floor answered.\"",
				"* \"Darkness poured upward like blood flowing in reverse.\"",
				"* \"When we returned, [wait:5]the chamber was no longer a chamber.\"",
				"* \"One acolyte had remained too close.\"",
				"* \"They emerged obedient, [wait:5]and filled with strength that was not their own.\"",
				"* \"We intended to create a world. [wait:10]Instead, [wait:5]we learned darkness could create servants.\"",
			},
			[3] = {
				"* \"The first sanctuary belonged to a god whose name is no longer important.\"",
				"* \"We repeated their prayers exactly.\"",
				"* \"We rang their bells, [wait:5]lit their candles, [wait:5]and knelt before their altar.\"",
				"* \"Then we opened the Fountain beneath it.\"",
				"* \"Their painted saints became kings, [wait:5]beasts, [wait:5]and jesters.\"",
				"* \"Their congregation fled from what their own devotion had created.\"",
				"* \"They called it desecration.\"",
				"* \"We called it the first prayer that had ever been answered.\"",
			},
			[4] = {
				"* \"The fourth sanctuary offered no resistance.\"",
				"* \"By then, [wait:5]we knew where the darkness preferred to gather.\"",
				"* \"Beneath altars. [wait:5]Behind icons. [wait:5]Within objects made sacred by repetition.\"",
				"* \"Every faith leaves a hollow place for its god.\"",
				"* \"We need only fill it.\"",
				"* \"One Fountain is a whisper. [wait:10]Several become a hymn.\"",
				"* \"When the sky is dark enough, [wait:5]the Angel will hear us.\"",
				"* \"When the world begins to roar, [wait:5]the Angel will descend.\"",
				"* \"Those who survive shall receive its blessing.\"",
			},
			[5] = {
				"* \"Our acolyte has finally named the place from which the transcripts were taken.\"",
				"* \"Hometown.\"",
				"* \"A quiet settlement with a school, [wait:5]a graveyard, [wait:5]and a church.\"",
				"* \"The people there have lived beside the darkness without understanding its grace.\"",
				"* \"We departed when the bell next rang.\"",
				"* \"Their church yielded beautifully.\"",
				"* \"The town which gave us darkness became the place from which we shall call the Angel.\"",
				"* \"We named our work the Grand Sanctum.\"",
				"* \"A splinter of its birth has been preserved with this record.\"",
				"* \"A memento of the making of our greatest prayer.\"",
			},
			
		}
		if not flag then
			cutscene:text("* (It's a book.[wait:10] It has the...)")
			cutscene:text("* (Huh? [wait:5]This isn't the Delta Rune...)")
			cutscene:text("* (The triangles are replaced with a shield.)")
			cutscene:text("* (...and 6 triangles all pointed to a star in the center,[wait:10] on the shield.)")
			Game:setFlag("readCount", 0)
		end
		if Game:getFlag("readCount", 0) >= 5 then
			if Game:getFlag("fun") == 66 and love.math.random(1, 10) == 10 then
				cutscene:gotoCutscene("study.gaster")
			end
    		cutscene:text("* That's enough reading for now.")
    		return
		end

		::req::
		if not flag or flag < 1 then
			cutscene:text("* (Read a passage?)")
		else
			cutscene:text("* (Read another passage?)")
		end
		local choice = cutscene:choicer({"Yes", "No"})
		if choice == 1 then
			cutscene:text("* (You open the book to a random page...)")
			Game:addFlag("readCount", 1)
			flag = Game:getFlag("readCount")
			for i = 1, #books[flag] do
				cutscene:text(books[flag])
				if flag == 5 then
					cutscene:text("* (As you put the book back, [wait:5]you see something glinting behind.)")
					cutscene:text("* (You reach behind with your free hand...)")
					cutscene:text("* (And when you pull back, [wait:5]you find yourself holding a [color:9999ff]Dark Shard.[color:white])")
					Mod:setDarkShard(Mod.DarkShardID.BookShard, true)
					Game.stage:addChild(ShardGetController(Mod.DarkShardID.BookShard))
					return
				end
				goto req
			end
		elseif choice == 2 then
			if Game:getFlag("readCount") == 1 then
				cutscene:text("* (You bookn't.)")
			else
				cutscene:text("* You close the book.")
			end
		end
	end,
	gaster = function(cutscene, event)
		cutscene:text({
			"* (The book changed.)",
			"* (The cover has a hand on it.)",
			"* (Instinctively, you open it.)",
		})
		Game.world.music:pause()
		cutscene:wait(2)
		Assets.playSound("smile", 1, 0.25)
		cutscene:text("* (It's filled with symbols.)")
		cutscene:text("* (Lines upon lines of symbols.)")
		cutscene:text("* (Nothing can be read.)")
		cutscene:text("* (You couldn't comprehend this, and close it.)")
		cutscene:text("* (...Where it then phases through the table.)")
		Assets.stopSound("smile")
		Game.world.music:play()
		
		
		
	end
}
