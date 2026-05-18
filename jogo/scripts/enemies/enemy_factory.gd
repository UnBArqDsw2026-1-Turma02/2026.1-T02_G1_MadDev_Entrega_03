## Factory Method Pattern
## Centraliza a criação de inimigos. Adicione novos tipos aqui.
class_name EnemyFactory
extends Node

# ---------------------------------------------------------------------------
# Registro de PackedScenes (adicione novos inimigos aqui)
# ---------------------------------------------------------------------------
const ENEMY_SCENES: Dictionary = {
	&"basic": preload("res://scenes/enemies/enemy.tscn"),
	&"melee": preload("res://scenes/enemies/enemy.tscn"),
	&"ranged": preload("res://scenes/enemies/enemy_ranged.tscn"),
}


# ---------------------------------------------------------------------------
# Factory Method - cria um inimigo pelo tipo
# ---------------------------------------------------------------------------
static func create(type: StringName) -> CharacterBody2D:
	if not ENEMY_SCENES.has(type):
		push_error("EnemyFactory: tipo desconhecido '%s'" % type)
		return null
	
	var enemy_scene: PackedScene = ENEMY_SCENES[type]
	var enemy: CharacterBody2D = enemy_scene.instantiate()
	
	# Configura propriedades baseado no tipo (sem anexar script)
	match type:
		&"melee":
			enemy.move_speed = 80.0
			enemy.attack_damage = 8
			enemy.max_health = 40
		
		&"ranged":
			enemy.move_speed = 40.0
			enemy.attack_damage = 5
			enemy.max_health = 25
		
		&"basic":
			enemy.move_speed = 60.0
			enemy.attack_damage = 5
			enemy.max_health = 30
	
	enemy.current_health = enemy.max_health
	
	return enemy
