local dice_roller = {}

function dice_roller.roll(sides)
    return math.random(sides)
end

function dice_roller.countWhere(rolls, sides, condition)
    local count = 0
    for i = 1, rolls do
        if condition(dice_roller.roll(sides)) then
            count = count + 1
        end
    end
    return count
end

return dice_roller
