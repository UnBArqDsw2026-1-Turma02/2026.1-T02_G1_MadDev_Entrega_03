class_name ResistanceHandler
extends DamageHandler

@export_range(0.0, 1.0) var resistance_pct: float = 0.2

func handle(damage: int, context: Dictionary) -> int:
	var final_damage = damage * (1.0 - resistance_pct)
	return super.handle(final_damage, context)
