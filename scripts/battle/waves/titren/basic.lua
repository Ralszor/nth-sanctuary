local Basic, super = Class(Wave)

function Basic:init()
    super.init(self)
    self.time = 30
end

function Basic:onStart()
    -- Every 0.33 seconds...
    local e = Game.battle.enemies[1]
    self.timer:every(1.3, function()
            self.timer:script(function (wait)
            wait(0.5)
            e:setSprite("throw")
            wait(1/10)
            e.sprite:setFrame(2)
            wait(1/10)
            e.sprite:setFrame(3)
            wait(1/10)
            e.sprite:setFrame(4)
            wait(1/3)
            local x, y = e:getRelativePos(e.width/3, e.height/3)
            local angle = MathUtils.angle(x, y, Game.battle.soul.x, Game.battle.soul.y)
            
            local b = self:spawnBullet("smallSpawn", 500, 80, angle, 0)
            b.physics.gravity = 0.6
            b.physics.speed_x = love.math.random(-700, -300)/100
            b.physics.speed_y = -10
            for i = 5, 8 do
                e.sprite:setFrame(i)
                wait(1/10)
            end
        end)
    end)
end

function Basic:beforeEnd()
    Game.battle.enemies[1]:resetSprite()
end

function Basic:update()
    -- Code here gets called every frame

    super.update(self)
end

return Basic