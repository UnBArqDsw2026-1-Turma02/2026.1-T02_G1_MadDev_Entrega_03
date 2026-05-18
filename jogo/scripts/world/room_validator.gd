## Visitor Pattern — visita cada inimigo ativo e cada porta da sala para determinar
## se o estado da sala mudou (todos mortos → destrava portas).
## Coloque um nó com este script em cada sala de combate.
## Conecte SignalBus.enemy_died → _on_enemy_died() via inspetor.
extends Node

# IDs das portas que este validador controla (preencha via inspetor).
@export var managed_door_ids: Array[String] = []

var _total_enemies: int = 0
var _enemies_killed: int = 0


func _ready() -> void:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("enemies")
	_total_enemies = enemies.size()
	_enemies_killed = 0

	# Visita cada inimigo para registrar estado inicial.
	for enemy in enemies:
		visit_enemy(enemy)


# ---------------------------------------------------------------------------
# Visitor — visita um inimigo (consulta, não modifica)
# ---------------------------------------------------------------------------
func visit_enemy(enemy: Node) -> void:
	if not enemy.has_method("take_damage"):
		return
	# Ponto de extensão: inspecionar atributos sem acoplar ao tipo concreto.
	_total_enemies = maxi(_total_enemies, 1)


# ---------------------------------------------------------------------------
# Visitor — visita uma porta e a destranca se a sala foi liberada
# ---------------------------------------------------------------------------
func visit_door(door: Node) -> void:
	if not door.has_method("unlock"):
		return
	if _is_room_cleared():
		door.unlock()


# ---------------------------------------------------------------------------
# Receptor do sinal SignalBus.enemy_died — conectar via inspetor
# ---------------------------------------------------------------------------
func _on_enemy_died(_enemy: Node) -> void:
	_enemies_killed += 1
	_validate()


# ---------------------------------------------------------------------------
# Lógica central de validação
# ---------------------------------------------------------------------------
func _validate() -> void:
	if not _is_room_cleared():
		return

	# Visita todas as portas gerenciadas na árvore de cena.
	for door_id in managed_door_ids:
		var doors: Array[Node] = get_tree().get_nodes_in_group("doors")
		for door in doors:
			if door.get("door_id") == door_id:
				visit_door(door)

	SignalBus.room_cleared.emit()


func _is_room_cleared() -> bool:
	return _total_enemies > 0 and _enemies_killed >= _total_enemies


# ---------------------------------------------------------------------------
# Factory Method - criar inimigos usando a fábrica
# ---------------------------------------------------------------------------
func spawn_enemy(enemy_type: StringName, position: Vector2) -> CharacterBody2D:
	var enemy: CharacterBody2D = EnemyFactory.create(enemy_type)
	if enemy == null:
		return null
	
	# Adiciona à cena
	add_child(enemy)
	enemy.global_position = position
	
	# Adiciona ao grupo para o validador encontrar
	enemy.add_to_group("enemies")
	
	# Incrementa contador de inimigos
	_total_enemies += 1
	
	return enemy


# ---------------------------------------------------------------------------
# Criar uma sala completa com vários inimigos
# ---------------------------------------------------------------------------
func setup_combat_room(enemy_list: Array[Dictionary]) -> void:
	# enemy_list exemplo: [
	#     {"type": &"basic", "pos": Vector2(100, 100)},
	#     {"type": &"basic", "pos": Vector2(200, 150)},
	# ]
	
	for enemy_data in enemy_list:
		var enemy_type: StringName = enemy_data.get("type", &"basic")
		var pos: Vector2 = enemy_data.get("pos", Vector2.ZERO)
		spawn_enemy(enemy_type, pos)
