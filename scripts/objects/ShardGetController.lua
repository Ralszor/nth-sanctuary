local ShardGetController, super = Class(Object)

function ShardGetController:init(id, options)
    super.init(self, id)
    
    
    self.timer = Timer()
    self:addChild(self.timer)
    self.spr = Sprite("misc/shard_big2")
    self.get_sprite = Sprite("misc/shardget")
    self:addChild(self.spr)
    self:addChild(self.get_sprite)
    
    self.options = options or {}
    
    self.highcolor = options["color1"] or "9999ff"
    self.lowcolor = options["color2"] or "6666ee"
    
    self.text = Text("[color:"..self.highcolor.."][style:dark]"..Mod.DarkShardName[id], 0,0,640, nil, {["font"] = "ebtitle", ["align"] = "center"}) --plorgius
    self:addChild(self.text)
    Assets.playSound("shard_get")
    --self.text:addFX(ProphecyScrollFX(1, 2), "prop")

    self:initSequence()
end

function ShardGetController:initSequence()
    self.spr:setOrigin(0.5)
    self.spr:setScale(2)
    self.get_sprite:setOrigin(0.5)
    self.get_sprite:setScale(2)
    self.get_sprite:setPosition(SCREEN_WIDTH/2, SCREEN_HEIGHT/2+20)
    self.spr:setPosition(SCREEN_WIDTH/2, SCREEN_HEIGHT/2-80)
    self.text:setPosition(0, SCREEN_HEIGHT/2+60)
    
    self.timer:script(function (wait)
        self.spr:addFX(ProphecyScrollFXAlt(1, nil, nil, {color = self.highcolor}), "prop")
        self.get_sprite:addFX(ProphecyScrollFXAlt(1, nil, nil, {color = self.lowcolor}), "prop")
        
        for i = 1, 10 do
            if i %2 == 0 then
                local img = AfterImage(self.spr, 0.75)
                img.graphics.grow = 0.02
                img:setColor(ColorUtils.hexToRGB(self.highcolor))
                self:addChild(img)
            end
            local img2 = AfterImage(self.get_sprite, 1)
            img2.graphics.grow = 0.01
            img2:setColor(ColorUtils.hexToRGB(self.lowcolor))
            self:addChild(img2)
            wait(1/10)
        end
        wait(2)
        local f = self:addFX(AlphaFX(0.99, 1), "alpha")
        while f.alpha > 0.01 do
            f.alpha = f.alpha-DT
            wait()
        end
        self:remove()
    end)
end

function ShardGetController:update()
    super.update(self)
end

return ShardGetController