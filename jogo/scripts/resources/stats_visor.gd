## Visitor Pattern — percorre nós da sala e coleta estatísticas sem modificar
##                   as classes visitadas.
##
## Cada classe base aceita o visitor via accept(visitor), que chama de volta
## o método visit_*() correspondente (Double Dispatch).
## TileMapLayer é built-in e não pode ter accept() — é visitado diretamente
## pelo RoomStatsReport via visit_tilemap().
##
## Uso:
##   var visitor := StatsVisitor.new()
##   enemy.accept(visitor)
##   var report := visitor.get_report()
extends RefCounted
class_name StatsVisitor
 
 
# ---------------------------------------------------------------------------
# Relatório interno (acumulado a cada visit_*)
# ---------------------------------------------------------------------------
var _report: Dictionary = {}
 
 
func _init() -> void:
	_reset()
 
 
func _reset() -> void:
	_report = {
		"enemy_count":          0,
		"total_enemy_hp":       0,
		"total_enemy_max_hp":   0,
		"item_count":           0,
		"projectile_count":     0,
		"tilemap_layer_count":  0,
		"total_tilemap_cells":  0,
	}
 
 
# ---------------------------------------------------------------------------
# visit_* — um método por tipo de nó visitável
# ---------------------------------------------------------------------------
 
## Visita um inimigo e acumula contagem e pontos de vida.
func visit_enemy(enemy: EnemyBase) -> void:
	_report["enemy_count"]        += 1
	_report["total_enemy_hp"]     += enemy.current_health
	_report["total_enemy_max_hp"] += enemy.max_health
 
 
## Visita um item e acumula contagem.
## Expanda conforme ItemBase ganhar mais atributos (tipo, raridade, etc.).
func visit_item(_item: Node) -> void:
	_report["item_count"] += 1
 
 
## Visita um projétil e acumula contagem.
func visit_projectile(_projectile: Node) -> void:
	_report["projectile_count"] += 1
 
 
## Visita uma camada de TileMap e acumula células usadas.
## Chamado diretamente pelo RoomStatsReport (TileMapLayer é built-in, sem accept()).
func visit_tilemap(tilemap: TileMapLayer) -> void:
	_report["tilemap_layer_count"] += 1
	_report["total_tilemap_cells"] += tilemap.get_used_cells().size()
 
 
# ---------------------------------------------------------------------------
# Acesso ao relatório
# ---------------------------------------------------------------------------
 
## Retorna uma cópia do relatório acumulado.
## Chame após todos os accept() terem sido executados.
func get_report() -> Dictionary:
	return _report.duplicate()
