local item, super = Class(Item, "halo_guard")

function item:init()
    super.init(self)

    -- Display name
    self.name = "Halo Guard"

    -- Item type (item, key, weapon, armor)
    self.type = "armor"
    -- Item icon (for equipment)
    self.icon = "ui/menu/icon/armor"

    -- Battle description
    self.effect = ""
    -- Shop description
    self.shop = ""
    -- Menu description
    self.description = "A radiant light shining over you.\nGreatly protects against Demon attacks."

    -- Default shop price (sell price is halved)
    self.price = 0
    -- Whether the item can be sold
    self.can_sell = false

    -- Consumable target mode (ally, party, enemy, enemies, or none)
    self.target = "none"
    -- Where this item can be used (world, battle, all, or none)
    self.usable_in = "all"
    -- Item this item will get turned into when consumed
    self.result_item = nil
    -- Will this item be instantly consumed in battles?
    self.instant = false

    -- Equip bonuses (for weapons and armor)
    self.bonuses = {
        defense = 4,
    }
    -- Bonus name and icon (displayed in equip menu)
    self.bonus_name = "Demon"
    self.bonus_icon = "ui/menu/icon/armor"

    -- Equippable characters (default true for armors, false for weapons)
    self.can_equip = {
        lobby_man = false,
    }

    -- Character reactions
    self.reactions = {
        susie = "Hell yeah!",
        ralsei = "It's a warm light!",
        noelle = "An angel dropped this...?",
        jamm = "So the light just goes around me?",
    }

    -- TODO: Elemental resistance
    -- Resists demon attack damage by 0.66
end

return item