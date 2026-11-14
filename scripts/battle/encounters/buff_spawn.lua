local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = [==[
* Titren Spawn is about to hit a new PR!
]==]

    -- Battle music ("battle" is rude buster)
    self.music = "bufftitan"
    -- Enables the purple grid battle background
    self.background = true

    self.reduced_tp = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("buff_spawn",525, 260)

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

return Dummy