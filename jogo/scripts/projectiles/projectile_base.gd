## Object Pool Pattern — enable()/disable() permitem reusar instâncias sem queue_free().
## Bridge Pattern   — lógica de dano separada da representação visual (Sprite2D).
extends Area2D

# ---------------------------------------------------------------------------
# Atributos
# ---------------------------------------------------------------------------
@export var speed: float = 300.0
@export var damage: int = 10
@export var lifetime: float = 3.0

var direction: Vector2 = Vector2.RIGHT
var _elapsed: float = 0.0
var _pool: Node = null  


# ---------------------------------------------------------------------------
# Object Pool — interface pública de ativação/desativação
# ---------------------------------------------------------------------------
func enable(spawn_position: Vector2, spawn_direction: Vector2) -> void:
	global_position = spawn_position
	direction = spawn_direction.normalized()
	_elapsed = 0.0
	show()
	set_process(true)
	monitoring = true
	monitorable = true


func disable() -> void:
	print("Projétil ", name, " desativado! Pool: ", _pool != null)
	hide()
	set_process(false)
	monitoring = false
	monitorable = false
	
	if _pool != null and _pool.has_method("return_projectile"):
		print("Chamando return_projectile para ", name)
		_pool.return_projectile(self)
	else:
		print("ERRO: Pool não encontrado ou método inexistente!")


func set_pool(pool: Node) -> void:
	_pool = pool
	print("Projétil ", name, " conectado ao pool")  # DEBUG

# ---------------------------------------------------------------------------
# Movimento e lifetime
# ---------------------------------------------------------------------------
func _ready() -> void:
	disable()


func _process(delta: float) -> void:
	position += direction * speed * delta
	_elapsed += delta
	if _elapsed >= lifetime:
		print("Projétil ", name, " expirou!")  # DEBUG
		disable() 


# ---------------------------------------------------------------------------
# Colisão — conecte body_entered ou area_entered via inspetor
# ---------------------------------------------------------------------------
func apply_damage_to(target: Node) -> void:
	if target.has_method("take_damage"):
		target.take_damage(damage)
	disable()  
	
## ─────────────────────────────────────────────────────────────────────────────
## SNIPPET — Visitor Pattern (#10)
##
## Adicione o bloco abaixo ao final do seu projectile_base.gd existente.
## NÃO substitua o arquivo inteiro — apenas copie e cole este bloco.
## ─────────────────────────────────────────────────────────────────────────────
 
# ---------------------------------------------------------------------------
# Visitor Pattern (#10) — Double Dispatch
# ---------------------------------------------------------------------------
## Permite que um StatsVisitor colete dados deste projétil sem que ProjectileBase
## precise conhecer o visitor.
## Adicione também o nó ao grupo "projectiles" no inspetor do Godot para que
## o RoomStatsReport o encontre via get_tree().get_nodes_in_group("projectiles").
func accept(visitor: Object) -> void:
	visitor.visit_projectile(self)
