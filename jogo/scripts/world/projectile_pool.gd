## Object Pool Pattern
## Gerencia um pool de projéteis reutilizáveis
class_name ProjectilePool
extends Node

# ---------------------------------------------------------------------------
# Configuração exportada (ajustável no inspetor)
# ---------------------------------------------------------------------------
@export var projectile_scene: PackedScene = preload("res://scenes/projectiles/projectile.tscn")
@export var pool_size: int = 10
@export var auto_expand: bool = true

# ---------------------------------------------------------------------------
# Pool interno
# ---------------------------------------------------------------------------
var _pool: Array[Area2D] = []
var _active_count: int = 0


# ---------------------------------------------------------------------------
# Inicialização
# ---------------------------------------------------------------------------
func _ready() -> void:
	_preload_projectiles()


func _preload_projectiles() -> void:
	for i in range(pool_size):
		var projectile = _create_projectile()
		_pool.append(projectile)
		add_child(projectile)
	
	print("ProjectilePool: ", pool_size, " projéteis pré-criados")


func _create_projectile() -> Area2D:
	var projectile: Area2D = projectile_scene.instantiate()
	projectile.name = "Projectile_" + str(_pool.size())
	
	# Passa a referência do pool para o projétil
	if projectile.has_method("set_pool"):
		projectile.set_pool(self)
	
	_disable_projectile(projectile)
	return projectile


# ---------------------------------------------------------------------------
# Desativa um projétil
# ---------------------------------------------------------------------------
func _disable_projectile(projectile: Area2D) -> void:
	projectile.process_mode = Node.PROCESS_MODE_DISABLED
	projectile.visible = false
	projectile.set_process(false)
	
	if projectile.has_method("set_monitoring"):
		projectile.set_monitoring(false)
		projectile.set_monitorable(false)


# ---------------------------------------------------------------------------
# Ativa um projétil
# ---------------------------------------------------------------------------
func _enable_projectile(projectile: Area2D, position: Vector2, direction: Vector2) -> void:
	projectile.process_mode = Node.PROCESS_MODE_INHERIT
	projectile.visible = true
	projectile.set_process(true)
	
	if projectile.has_method("set_monitoring"):
		projectile.set_monitoring(true)
		projectile.set_monitorable(true)
	
	if projectile.has_method("enable"):
		projectile.enable(position, direction)


# ---------------------------------------------------------------------------
# Método público: pega um projétil do pool
# ---------------------------------------------------------------------------
func get_projectile(position: Vector2, direction: Vector2) -> Area2D:
	# Procura um projétil inativo
	for projectile in _pool:
		if projectile.process_mode == Node.PROCESS_MODE_DISABLED:
			_enable_projectile(projectile, position, direction)
			_active_count += 1
			return projectile
	
	# Se não encontrou e auto_expand está ativo, cria um novo
	if auto_expand:
		print("ProjectilePool: expandindo pool (", _pool.size() + 1, ")")
		var new_projectile = _create_projectile()
		_pool.append(new_projectile)
		add_child(new_projectile)
		_enable_projectile(new_projectile, position, direction)
		_active_count += 1
		return new_projectile
	
	push_warning("ProjectilePool: sem projéteis disponíveis!")
	return null


# ---------------------------------------------------------------------------
# Devolve um projétil ao pool
# ---------------------------------------------------------------------------
func return_projectile(projectile: Area2D) -> void:
	print("return_projectile chamado para: ", projectile.name)
	
	if projectile in _pool:
		print("Projétil encontrado no pool, desativando...")
		_disable_projectile(projectile)
		_active_count = max(0, _active_count - 1)
		print("Novo active_count: ", _active_count)
	else:
		push_error("ProjectilePool: projétil não pertence a este pool!")

# ---------------------------------------------------------------------------
# Status do pool
# ---------------------------------------------------------------------------
func get_pool_status() -> Dictionary:
	return {
		"total": _pool.size(),
		"active": _active_count,
		"available": _pool.size() - _active_count
	}
