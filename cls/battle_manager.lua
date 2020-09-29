local dice_roller = require 'cls.dice'

local battle_manager = {}

local function getShots(attacker, attack, defender)
    local shots = 0
    if type(attack.shots) == "number" then
        shots = attack.shots
    elseif type(attack.shots) == "function" then
        shots = attack.shots(attacker, defender)
    end
    return shots
end

local function getHits(shots, attacker, attack, defender)
    local hits = 0
    for i = 1, shots do
        local accuracy = 0
        if type(attack.accuracy) == "number" then
            accuracy = attack.accuracy
        elseif type(attack.accuracy) == "function" then
            accuracy = attack.accuracy(attacker, defender, i)
        elseif type(attacker.accuracy) == "number" then
            accuracy = attacker.accuracy
        elseif type(attacker.accuracy) == "function" then
            accuracy = attacker.accuracy(attack, defender, i)
        end
        if dice_roller.roll(6) >= accuracy then
            hits = hits + 1
        end
    end
    return hits
end

local function getAttackerStrength(attacker, attack, defender)
    local strength = 0
    if type(attack.strength) == "number" then
        strength = attack.strength
    elseif type(attack.strength) == "function" then
        strength = attack.strength(attacker, defender)
    elseif type(attacker.strength) == "number" then
        strength = attacker.strength
    elseif type(attacker.strength) == "function" then
        strength = attacker.strength(attacker, defender)
    end
    return strength
end

local function getDefenderToughness(attacker, attack, defender)
    local toughness = 0
    if type(defender.toughness) == "number" then
        toughness = defender.toughness
    elseif type(defender.toughness) == "function" then
        toughness = defender.toughness(attacker, attack)
    end
    return toughness
end

local function getWounds(hits, attacker, attack, defender)
    local strength = getAttackerStrength(attacker, attack, defender)
    local toughness = getDefenderToughness(attacker, attack, defender)
    local wounds = 0
    local to_wound = 0
    if strength >= toughness * 2 then
        to_wound = 2
    elseif strength > toughness then
        to_wound = 3
    elseif strength <= toughness / 2 then
        to_wound = 6
    elseif strength < toughness then
        to_wound = 5
    elseif strength == toughness then
        to_wound = 4
    end
    return dice_roller.countWhere(hits, 6, function(n) n >= to_wound end)
end

local function getSaves(wounds, attacker, attack, defender)
    local to_save = 0
    if type(attack.save) == "number" then
        to_save = attack.save
    if type(attack.save) == "function" then
        to_save = attack.save(attacker, defender)
    elseif type(defender.save) == "number" then
        to_save = defender.save
    elseif type(defender.save) == "number" then
        to_save = defender.save(attacker, attack)
    end

    if type(attack.armour_penetration) == "number" then
        to_save = to_save + attack.armour_penetration
    elseif type(attack.armour_penetration) == "function" then
        to_save = to_save + attack.armour_penetration(attacker, defender)
    end

    return dice_roller.countWhere(wounds, 6, function(n) n >= to_save end)
end

local function getDamage(attacker, attack, defender)
    local damage = 0
    if type(attack.damage) == "number" then
        damage = attack.damage
    elseif type(attack.damage) == "function" then
        damage = attack.damage(attacker, defender)
    end
    return damage
end

function battle_manager.attack(attacker, attack, defender)
    local shots = getShots(attacker, attack, defender)
    local hits = getHits(shots, attacker, attack, defender)
    local wounds = getWounds(hits, attacker, attack, defender)
    local saves = getSaves(wounds, attacker, attack, defender)
    wounds = wounds - saves
    while wounds > 0 do
        local damage = getDamage(attacker, attack, defender)
        -- TODO: Inflict damage
        -- SEE: https://www.reddit.com/r/Warhammer40k/comments/6evqu6/8th_wound_allocation_help/
        wounds = wounds - 1
    end
end

-- TODO: Implement melee combat
-- SEE: https://www.youtube.com/watch?v=r0GrQ2DIPyc

return battle_manager
