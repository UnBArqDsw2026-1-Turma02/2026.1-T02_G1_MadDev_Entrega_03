## Builder Pattern — ConcreteBuilder para salas de jogo.
## Constrói uma sala Node2D passo a passo com configurações personalizadas.
class_name RoomBuilder
extends RoomBuilderBase

const _ITEM_SCENE: String = "res://scenes/consumables/consumable.tscn"

var _room_name: String = "Sala"
var _enemy_list: Array[Dictionary] = []
var _item_list: Array[Dictionary] = []
var _door_positions: Array[Vector2] = []
var _tilemap_source: String = "res://art/tilesets/room.tres"
var _player_start_position: Vector2 = Vector2(152, 112)

# ---------------------------------------------------------------------------
# Interface fluente (métodos encadeáveis)
# ---------------------------------------------------------------------------

func set_room_name(name: String) -> RoomBuilderBase:
	_room_name = name
	return self

func add_enemy(enemy_type: StringName, position: Vector2) -> RoomBuilderBase:
	_enemy_list.append({"type": enemy_type, "pos": position})
	return self

func add_enemies(enemies: Array[Dictionary]) -> RoomBuilderBase:
	_enemy_list.append_array(enemies)
	return self

func set_enemy_count(count: int, enemy_type: StringName = &"basic") -> RoomBuilderBase:
	var positions: Array[Vector2] = [
		Vector2(100, 100),
		Vector2(200, 100),
		Vector2(150, 200),
		Vector2(50, 150),
		Vector2(250, 150),
	]
	for i in range(mini(count, positions.size())):
		add_enemy(enemy_type, positions[i])
	return self

func add_item(item_type: StringName, position: Vector2) -> RoomBuilderBase:
	_item_list.append({"type": item_type, "pos": position})
	return self

func set_exits(directions: Array[Vector2]) -> RoomBuilderBase:
	_door_positions = directions
	return self

func set_player_start(position: Vector2) -> RoomBuilderBase:
	_player_start_position = position
	return self

func set_tilemap(tilemap_path: String) -> RoomBuilderBase:
	_tilemap_source = tilemap_path
	return self

# ---------------------------------------------------------------------------
# Método principal: constrói e retorna a sala pronta
# ---------------------------------------------------------------------------
func build() -> Node2D:
	var room := Node2D.new()
	room.name = _room_name

	# 1. Chão / paredes
	room.add_child(_create_tilemap())

	# 2. Jogador
	room.add_child(_create_player())

	# 3. Portas com IDs únicos
	var door_ids: Array[String] = []
	for i in range(_door_positions.size()):
		var door_id := "door_%d" % i
		room.add_child(_create_door(_door_positions[i], door_id))
		door_ids.append(door_id)

	# 4. Validator ciente das portas desta sala
	room.add_child(_create_room_validator(door_ids))

	# 5. Inimigos — notificação de spawn adiada para após _ready() do validator
	for enemy_data in _enemy_list:
		var enemy := _create_enemy(enemy_data["type"])
		if enemy:
			enemy.position = enemy_data["pos"]
			enemy.add_to_group("enemies")
			room.add_child(enemy)
			SignalBus.enemy_spawned.emit.call_deferred(enemy)

	# 6. Itens consumíveis
	for item_data in _item_list:
		var item := _create_item(item_data["type"])
		if item:
			item.position = item_data["pos"]
			room.add_child(item)

	# 7. HUD e pausa
	room.add_child(_create_hud())
	room.add_child(_create_pause_layer())

	return room

# ---------------------------------------------------------------------------
# Métodos privados de criação
# ---------------------------------------------------------------------------

func _create_tilemap() -> TileMapLayer:
	var tilemap := TileMapLayer.new()
	tilemap.name = "TileMapLayer"
	var tileset = load(_tilemap_source)
	if tileset:
		tilemap.tile_set = tileset
	return tilemap


func _create_player() -> CharacterBody2D:
	var scene := load("res://scenes/player/player.tscn") as PackedScene
	var player: CharacterBody2D = scene.instantiate()
	player.name = "Player"
	player.position = _player_start_position
	return player


func _create_room_validator(door_ids: Array[String]) -> Node:
	var validator := Node.new()
	validator.name = "RoomValidator"
	validator.set_script(load("res://scripts/world/room_validator.gd"))
	validator.set("managed_door_ids", door_ids)
	return validator


func _create_door(position: Vector2, door_id: String) -> StaticBody2D:
	var scene := load("res://scenes/world/door.tscn") as PackedScene
	var door: StaticBody2D = scene.instantiate()
	door.position = position
	door.name = "Door_" + door_id
	door.set("door_id", door_id)
	return door


func _create_enemy(type: StringName) -> CharacterBody2D:
	return EnemyFactory.create(type)


func _create_item(type: StringName) -> Node:
	var scene := load(_ITEM_SCENE) as PackedScene
	if scene == null:
		return null
	var item := scene.instantiate()
	item.set("consumable_name", str(type))
	return item


func _create_hud() -> CanvasLayer:
	var hud_layer := CanvasLayer.new()
	hud_layer.name = "HUD"
	var hud := (load("res://scenes/ui/hud.tscn") as PackedScene).instantiate()
	hud.name = "HUDContent"
	hud_layer.add_child(hud)
	return hud_layer


func _create_pause_layer() -> CanvasLayer:
	var pause_layer := CanvasLayer.new()
	pause_layer.name = "PauseLayer"
	pause_layer.layer = 10
	var pause_menu := (load("res://scenes/ui/pause_menu.tscn") as PackedScene).instantiate()
	pause_menu.name = "PauseMenu"
	pause_layer.add_child(pause_menu)
	return pause_layer
