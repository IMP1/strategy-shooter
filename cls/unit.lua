local character = {}
character.__index = character

function character.load(blueprint)
    local self = {}
    setmetatable(self, character)

    self.name       = unit.name
    self.movement   = unit.movement
    self.melee      = unit.melee
    self.accuracy   = unit.accuracy
    self.strength   = unit.strength
    self.toughness  = unit.toughness
    self.wounds     = unit.wounds
    self.armour     = unit.armour
    self.leadership = unit.leadership
    self.save       = unit.save

    self.weapons    = {}
    self.wounds_inflicted = 0

    return self
end

function character:allAttacks()
    local attacks = {}
    for _, weapon in pairs(self.weapons) do
        for _, attack in pairs(weapon.attacks) do
            table.insert(attacks, attack)
        end
    end
    return attacks
end

return character