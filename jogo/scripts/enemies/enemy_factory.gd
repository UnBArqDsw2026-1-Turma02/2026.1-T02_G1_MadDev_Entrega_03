## Factory Method Pattern
## Centraliza a criação de inimigos. Adicione novos tipos aqui.
class_name EnemyFactory
extends Node

# ---------------------------------------------------------------------------
# Registro de PackedScenes (adicione novos inimigos aqui)
# ---------------------------------------------------------------------------
const ENEMY_SCENES: Dictionary = {
	&"basic": preload("res://scenes/enemies/enemy.tscn"),
	&"ranged": preload("res://scenes/enemies/enemy_ranged.tscn"),  # ← NOVO!
}


# ---------------------------------------------------------------------------
# Factory Method - cria um inimigo pelo tipo
# ---------------------------------------------------------------------------
static func create(type: StringName) -> CharacterBody2D:
	# Verifica se o tipo existe
	if not ENEMY_SCENES.has(type):
		push_error("EnemyFactory: tipo desconhecido '%s'" % type)
		return null
	
	# Instancia a cena
	var enemy_scene: PackedScene = ENEMY_SCENES[type]
	var enemy: CharacterBody2D = enemy_scene.instantiate()
	
	# Configurações específicas por tipo (opcional)
	match type:
		&"basic":
			# Básico usa valores padrão da cena
			pass
		&"ranged":
			# Ranged pode ter configurações extras
			# Ex: enemy.attack_range = 100.0
			pass
	
	return enemy
