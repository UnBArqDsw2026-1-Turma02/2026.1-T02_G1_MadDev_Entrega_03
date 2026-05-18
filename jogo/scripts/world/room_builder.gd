## Builder Pattern
## Constrói salas passo a passo com configurações personalizadas
class_name RoomBuilder
extends Node

# ---------------------------------------------------------------------------
# Atributos da sala (valores padrão)
# ---------------------------------------------------------------------------
var _room_name: String = "Sala"
var _enemy_list: Array[Dictionary] = []  # Lista de {type: &"basic", pos: Vector2}
var _item_list: Array[Dictionary] = []   # Lista de {type: &"health", pos: Vector2}
var _door_positions: Array[Vector2] = []
var _tilemap_source: String = "res://art/tilesets/room.tres"
var _player_start_position: Vector2 = Vector2(152, 112)

# ---------------------------------------------------------------------------
# Interface fluente (métodos encadeáveis)
# ---------------------------------------------------------------------------

## Define o nome da sala
func set_room_name(name: String) -> RoomBuilder:
	_room_name = name
	return self

## Adiciona um inimigo à sala
func add_enemy(enemy_type: StringName, position: Vector2) -> RoomBuilder:
	_enemy_list.append({"type": enemy_type, "pos": position})
	return self

## Adiciona múltiplos inimigos de uma vez
func add_enemies(enemies: Array[Dictionary]) -> RoomBuilder:
	_enemy_list.append_array(enemies)
	return self

## Define quantos inimigos básicos (posições automáticas)
func set_enemy_count(count: int, enemy_type: StringName = &"basic") -> RoomBuilder:
	# Limpa inimigos existentes se quiser substituir
	# _enemy_list.clear()
	
	# Distribui inimigos em posições pré-definidas
	var positions: Array[Vector2] = [
		Vector2(100, 100),
		Vector2(200, 100),
		Vector2(150, 200),
		Vector2(50, 150),
		Vector2(250, 150),
	]
	
	for i in range(min(count, positions.size())):
		add_enemy(enemy_type, positions[i])
	
	return self

## Adiciona um item consumível à sala
func add_item(item_type: StringName, position: Vector2) -> RoomBuilder:
	_item_list.append({"type": item_type, "pos": position})
	return self

## Define as posições das portas
func set_exits(directions: Array[Vector2]) -> RoomBuilder:
	_door_positions = directions
	return self

## Define a posição inicial do jogador
func set_player_start(position: Vector2) -> RoomBuilder:
	_player_start_position = position
	return self

## Define o tileset da sala
func set_tilemap(tilemap_path: String) -> RoomBuilder:
	_tilemap_source = tilemap_path
	return self

# ---------------------------------------------------------------------------
# Método principal: constrói e retorna a sala pronta
# ---------------------------------------------------------------------------
func build() -> Node2D:
	# Cria o nó raiz da sala
	var room = Node2D.new()
	room.name = _room_name
	
	# 1. Adiciona o TileMapLayer (chão/paredes)
	var tilemap = _create_tilemap()
	room.add_child(tilemap)
	
	# 2. Adiciona o Player
	var player = _create_player()
	room.add_child(player)
	
	# 3. Adiciona o RoomValidator (gerencia limpeza da sala)
	var validator = _create_room_validator()
	room.add_child(validator)
	
	# 4. Adiciona as portas
	for door_pos in _door_positions:
		var door = _create_door(door_pos)
		room.add_child(door)
	
	# 5. Adiciona os inimigos (usando a Factory da Issue 1!)
	for enemy_data in _enemy_list:
		var enemy = EnemyFactory.create(enemy_data["type"])
		if enemy:
			room.add_child(enemy)
			enemy.position = enemy_data["pos"]
			enemy.add_to_group("enemies")
			# Atualiza o contador do validator
			validator._total_enemies += 1
	
	# 6. Adiciona o HUD (interface)
	var hud_layer = _create_hud()
	room.add_child(hud_layer)
	
	# 7. Adiciona o PauseLayer
	var pause_layer = _create_pause_layer()
	room.add_child(pause_layer)
	
	return room


# ---------------------------------------------------------------------------
# Métodos privados de criação (encapsulamento)
# ---------------------------------------------------------------------------

func _create_tilemap() -> TileMapLayer:
	var tilemap = TileMapLayer.new()
	tilemap.name = "TileMapLayer"
	
	# Carrega o tileset
	var tileset = load(_tilemap_source)
	if tileset:
		tilemap.tile_set = tileset
	
	# Aqui você pode adicionar lógica para gerar o mapa procedural
	# Por enquanto, usamos um tilemap simples ou carregamos de um recurso
	
	return tilemap


func _create_player() -> CharacterBody2D:
	var player_scene = load("res://scenes/player/player.tscn")
	var player = player_scene.instantiate()
	player.name = "Player"
	player.position = _player_start_position
	return player


func _create_room_validator() -> Node:
	var validator = Node.new()
	validator.name = "RoomValidator"
	
	# Adiciona o script
	var script = load("res://scripts/world/room_validator.gd")
	validator.set_script(script)
	
	# Configura o validator
	validator.set("managed_door_ids", ["door_default"])
	validator._total_enemies = 0
	validator._enemies_killed = 0
	
	return validator


func _create_door(position: Vector2) -> StaticBody2D:
	var door_scene = load("res://scenes/world/door.tscn")
	var door = door_scene.instantiate()
	door.position = position
	door.name = "Door"
	door.set("door_id", "door_default")
	return door


func _create_hud() -> CanvasLayer:
	var hud_layer = CanvasLayer.new()
	hud_layer.name = "HUD"
	
	var hud_scene = load("res://scenes/ui/hud.tscn")
	var hud = hud_scene.instantiate()
	hud.name = "HUDContent"
	
	hud_layer.add_child(hud)
	return hud_layer


func _create_pause_layer() -> CanvasLayer:
	var pause_layer = CanvasLayer.new()
	pause_layer.name = "PauseLayer"
	pause_layer.layer = 10
	
	var pause_scene = load("res://scenes/ui/pause_menu.tscn")
	var pause_menu = pause_scene.instantiate()
	pause_menu.name = "PauseMenu"
	
	pause_layer.add_child(pause_menu)
	return pause_layer
