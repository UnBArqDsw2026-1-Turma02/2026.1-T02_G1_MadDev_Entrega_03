class_name ArmorHandler
extends DamageHandler

var armor_value: int = 0

func handle(damage: int, context: Dictionary) -> int:
	var reduced_damage = maxi(0, damage - armor_value)
	return super.handle(reduced_damage, context)
