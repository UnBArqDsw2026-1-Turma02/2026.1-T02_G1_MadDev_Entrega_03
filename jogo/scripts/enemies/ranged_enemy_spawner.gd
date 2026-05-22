## Factory Method Pattern — ConcreteCreator para inimigo de longa distância.
class_name RangedEnemySpawner
extends EnemySpawner

const SCENE: PackedScene = preload("res://scenes/enemies/enemy_ranged.tscn")

func _create_enemy() -> CharacterBody2D:
	return SCENE.instantiate()
