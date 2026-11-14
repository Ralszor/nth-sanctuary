local Dummy, super = Class(EnemyBattler)

function Dummy:init()
    super.init(self)

    -- Enemy name
    self.name = "Ti-tren Spawn"
    -- Sets the actor, which handles the enemy's sprites (see scripts/data/actors/dummy.lua)
    self:setActor("buff_spawn")

    -- Enemy health
    self.max_health = 3000
    self.health = 3000
    -- Enemy attack (determines bullet damage)
    self.attack = 25
    -- Enemy defense (usually 0)
    self.defense = 0
    -- Enemy reward
    self.money = 0

    -- Mercy given when sparing this enemy before its spareable (20% for basic enemies)
    self.spare_points = -5

    -- List of possible wave ids, randomly picked each turn
    self.waves = {
        "basic",
        "aiming",
        "movingarena"
    }

    -- Dialogue randomly displayed in the enemy's speech bubble
    self.dialogue = {}

    self.disable_mercy = true
    self.tired_percentage = -1000

    -- Check text (automatically has "ENEMY NAME - " at the start)
    self.check = "AT BUFF DF RAD\n* Shadow fetus chucker gang! \nWe love throwing spawns!"

    -- Text randomly displayed at the bottom of the screen each turn
    self.text = {
        "* Smells like Creatine.",
        "* The enemy checks itself in the mirror.",
        "* Titren Spawn injects performance enhancing drugs.",
        "* Something hovered in front of your face. It was the enemy flexing.",
        "* Titren Spawn bench presses a Balthizard.",
        "[image:misc/spawn_dialogue] what are you doing get out of the textbox"
    }

    self.low_health_percentage = 0
    if Mod:isWeird() then
        TableUtils.merge(self.text, {"* Titren Spawn pulls out a frozen chicken drumstick and nibbles on it."})
    else
        TableUtils.merge(self.text, {"* Titren Spawn pulls out a raw chicken breast and nibbles on it."})
    end

    -- Register act called "Smile"
    self:registerAct("Steroids", "Big Gain,\nBig Pain", "susie")

    self:registerAct("BigBain", "Think!\nThink!\nThink!", "ralsei")
    
    self:registerAct("ArmUp", "Throw\nhands", "jamm", 32)
    
	self.boss = true
    -- Register party act with Ralsei called "Tell Story"
    -- (second argument is description, usually empty
end

function Dummy:onAct(battler, name)
    if name == "Steroids" then
        -- Give the enemy 100% mercy
        Game.battle:startActCutscene(function (cutscene, battler)
            cutscene:text("* You asked the enemy to pass the steroids over to Susie!")
            local susie = Game.battle:getPartyBattler("susie")
            local spr = Sprite("tmax")
            spr:setOrigin(0.5,1)
            spr.alpha = 0
            spr:setScale(2)
            Game.battle:addChild(spr)
            spr.x, spr.y = susie.x + 70, susie.y
            Game.battle.timer:tween(1, spr, {scale_x = 1, scale_y = 1, alpha = 1}, 'out-circ')
            Assets.playSound("magic_sparkle")
            cutscene:wait(1)
            Game.battle.timer:tween(0.5, spr, {x = spr.x + 70}, 'out-circ', function() 
                Game.battle.timer:tween(0.5, spr, {x = susie.x}, 'in-circ', function() 
                    spr:remove() susie.chara.health = 1 susie:hurt(10) susie.chara:addStatBuff("attack", 5) susie.chara:addStatBuff("magic", 5)
                end)
            end)
            cutscene:wait(3)
        end)
        return 
        
    elseif name == "Standard" then --X-Action
        -- Give the enemy 50% mercy
        self:addMercy(50)
        if battler.chara.id == "ralsei" then
            -- R-Action text
            return "* Ralsei bowed politely.\n* The dummy spiritually bowed\nin return."
        elseif battler.chara.id == "susie" then
            -- S-Action: start a cutscene (see scripts/battle/cutscenes/dummy.lua)
            Game.battle:startActCutscene("dummy", "susie_punch")
            return
        else
            -- Text for any other character (like Noelle)
            return "* "..battler.chara:getName().." straightened the\ndummy's hat."
        end
    end

    -- If the act is none of the above, run the base onAct function
    -- (this handles the Check act)
    return super.onAct(self, battler, name)
end

function Dummy:onHurt(damage, battler)
	super.onHurt(self, damage, battler)

    Assets.stopAndPlaySound("spawn_weaker", 1, 0.8)
end

return Dummy