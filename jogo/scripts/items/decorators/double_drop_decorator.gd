## Decorator Pattern — dobra a quantidade/valor do item envolvido.
## Útil para itens que aumentam a taxa de drop ou recompensa.
class_name DoubleDropDecorator
extends ItemDecorator

# ---------------------------------------------------------------------------
# Override — duplica o valor e marca o efeito
# ---------------------------------------------------------------------------
func get_effect() -> String:
	return super.get_effect() + " ×2"


func get_value() -> int:
	return super.get_value() * 2
