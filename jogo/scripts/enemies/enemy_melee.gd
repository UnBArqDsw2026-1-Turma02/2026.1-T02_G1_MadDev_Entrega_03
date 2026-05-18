## Inimigo corpo a corpo - ataque próximo
extends "res://scripts/enemies/enemy_base.gd"

## Sobrescreve a preparação do ataque
func prepare_attack() -> void:
	# Animação de preparação (se tiver)
	print(name, " se prepara para atacar!")
	# Tocar som de preparação
	# AudioManager.play_sfx(preload("res://art/sounds/melee_prepare.wav"))


## Sobrescreve a execução do ataque
func execute_attack() -> void:
	print(name, " ATACOU COM A FORÇA BRUTA!")
	_apply_damage_to_player(attack_damage)
	# Efeito visual (opcional)
	# Tocar som de impacto
