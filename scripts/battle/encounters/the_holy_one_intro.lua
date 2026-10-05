local Dummy, super = Class(Encounter)

function Dummy:init()
    super.init(self)

    -- Text displayed at the bottom of the screen at the start of the encounter
    self.text = "* A divine entity blocks your way.[wait:5]\n* ([color:yellow]TP[color:reset] Gain reduced.)"

    -- Battle music ("battle" is rude buster)
    self.music = "ch4_battle"
    -- Enables the purple grid battle background
    self.background = true

    self.reduced_tp = true

    -- Add the dummy enemy to the encounter
    self:addEnemy("the_holy_one_intro")

    --- Uncomment this line to add another!
    --self:addEnemy("dummy")
end

return Dummy