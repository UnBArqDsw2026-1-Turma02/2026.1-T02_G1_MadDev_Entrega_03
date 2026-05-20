## Factory Method Pattern — ConcreteCreator para inimigo básico.
class_name BasicEnemySpawner
extends EnemySpawner

const SCENE: PackedScene = preload("res://scenes/enemies/enemy.tscn")

func _create_enemy() -> CharacterBody2D:
	return SCENE.instantiate()
