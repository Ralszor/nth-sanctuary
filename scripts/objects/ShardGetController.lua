local ShardGetController, super = Class(Object)

function ShardGetController:init(id, name)
    super.init(self, id)
    self.shard = Mod:getDarkShard(id)
    
    self.text = Text(name, 0,0,nil, nil, {font = Assets.getFont("ebtitle")}) --plorgius

    self:addChild(self.text)
    self.timer = Timer()
end

return ShardGetController