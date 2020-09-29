local weapon = {}

weapon.name = "Lasgun"
weapon.cost = nil
weapon.attacks = {}

weapon.attacks[1] = {}
weapon.attacks[1].range = 24
weapon.attacks[1].shots = 1
weapon.attacks[1].strength = 3
weapon.attacks[1].armour_penetration = 0
weapon.attacks[1].damage = 1

weapon.attacks[2] = {}
weapon.attacks[2].range = 12
weapon.attacks[2].shots = 2
weapon.attacks[2].strength = 3
weapon.attacks[2].armour_penetration = 0
weapon.attacks[2].damage = 1

return weapon
