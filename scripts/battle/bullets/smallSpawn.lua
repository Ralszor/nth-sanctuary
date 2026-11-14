local SmallBullet, super = Class(Bullet)

function SmallBullet:init(x, y, dir, speed)
    -- Last argument = sprite path
    super.init(self, x, y, "battle/bullets/titan/default/idle")
    self.sprite:play(1/10, true)
    -- Move the bullet in dir radians (0 = right, pi = left, clockwise rotation)
    self.physics.direction = dir
    -- Speed the bullet moves (pixels per frame at 30FPS)
    self.physics.speed = speed
    self.graphics.spin = 0.125
    self.collider = Hitbox(self, 0,0,30,34)

    self.passx = false
    self.passy = false
end

function SmallBullet:update()
    -- For more complicated bullet behaviours, code here gets called every update

    if self.x < Game.battle.arena.left then
        self.passx = true
    end
    if self.y > Game.battle.arena.bottom then
        self.passy = true
    end
    
    if self.passx then
        self.physics.speed_x = self.physics.speed_x + DTMULT*3
    end

    if self.passy then
        self.physics.speed_y = self.physics.speed_y - DTMULT*3
    end

    

    super.update(self)
end

return SmallBullet