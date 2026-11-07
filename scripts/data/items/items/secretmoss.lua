-- Create a healing item and specify its ID (id is optional, defaults to file path)
local item, super = Class(HealItem, "secretmoss")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Secret Moss"
    -- Name displayed when used in battle (optional)
    self.use_name = nil

    -- Item type (item, key, weapon, armor)
    self.type = "item"

    -- Battle description
    self.effect = "Secret\nMoss"
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "One of a kind. Makes everybody exercise."

    -- Amount healed (HealItem variable)
    self.heal_amount = 1
    -- Amount healed for anyone other than Kris
    self.heal_amount_other = 1

    -- Default shop price (sell price is halved)
    self.price = -50
    -- Whether the item can be sold
    self.can_sell = true

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "ally"
    -- Where this item can be used (world, battle, all, or none/nil)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Character reactions (key = party member id)
    self.reactions = {
        susie = "It's just dirt?",
        ralsei = "Oh, there's a worm in it...",
		jamm = "Eugh.",
    }
end

function item:getHealAmount(id)
    return self.heal_amount
end

function item:onWorldUse(target)
    target.stats.health = target.stats.health + 0.5
    Game.world:heal(target, 1)
    return true
end
function item:onBattleUse(user, target) end

return item