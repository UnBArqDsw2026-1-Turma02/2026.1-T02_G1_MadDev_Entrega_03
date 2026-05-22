## Visitor Pattern — orquestra o StatsVisitor, percorre todos os grupos da sala
##                   e agrega as estatísticas coletadas em um Dictionary.
##
## Adicione este Node como filho da cena de sala (Room) ou do GameManager.
## Ele responde a uma tecla de debug (padrão: F1) imprimindo o relatório no console.
##
## Grupos esperados na SceneTree (configure no inspetor de cada nó):
##   "enemies"     → nós que estendem EnemyBase
##   "items"       → nós que estendem ItemBase
##   "projectiles" → nós que estendem ProjectileBase
##   "tilemaps"    → nós do tipo TileMapLayer
##
## Uso via código:
##   var stats := $RoomStatsReport.collect()
##   print(stats["enemy_count"])
extends Node
class_name RoomStatsReport
 
 
## Tecla de atalho para imprimir o relatório no console durante o desenvolvimento.
## Altere em Project Settings → Input Map ou diretamente neste @export.
@export var debug_key: Key = KEY_F1
 
 
# ---------------------------------------------------------------------------
# Input de debug
# ---------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == debug_key:
			_print_report(collect())
 
 
# ---------------------------------------------------------------------------
# API pública
# ---------------------------------------------------------------------------
 
## Percorre todos os grupos da sala, aplica o StatsVisitor e retorna
## um Dictionary com os dados agregados.
##
## Retorno (chaves garantidas):
##   enemy_count         : int — total de inimigos vivos na sala
##   total_enemy_hp      : int — soma dos HP atuais de todos os inimigos
##   total_enemy_max_hp  : int — soma dos HP máximos de todos os inimigos
##   item_count          : int — total de itens presentes na sala
##   projectile_count    : int — total de projéteis ativos
##   tilemap_layer_count : int — total de camadas TileMapLayer encontradas
##   total_tilemap_cells : int — total de células usadas em todas as camadas
func collect() -> Dictionary:
	var visitor := StatsVisitor.new()
 
	# ── Inimigos ──────────────────────────────────────────────────────────
	for node in get_tree().get_nodes_in_group("enemies"):
		if node.has_method("accept"):
			node.accept(visitor)
 
	# ── Itens ─────────────────────────────────────────────────────────────
	for node in get_tree().get_nodes_in_group("items"):
		if node.has_method("accept"):
			node.accept(visitor)
 
	# ── Projéteis ─────────────────────────────────────────────────────────
	for node in get_tree().get_nodes_in_group("projectiles"):
		if node.has_method("accept"):
			node.accept(visitor)
 
	# ── TileMapLayer — built-in sem accept(), chamada direta ──────────────
	for node in get_tree().get_nodes_in_group("tilemaps"):
		if node is TileMapLayer:
			visitor.visit_tilemap(node as TileMapLayer)
 
	return visitor.get_report()
 
 
# ---------------------------------------------------------------------------
# Formatação do relatório para o console
# ---------------------------------------------------------------------------
func _print_report(report: Dictionary) -> void:
	print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	print("  ROOM STATS REPORT — ", Time.get_time_string_from_system())
	print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	print("  Inimigos   : ", report.get("enemy_count", 0))
	print("  HP total   : ", report.get("total_enemy_hp", 0),
		" / ", report.get("total_enemy_max_hp", 0))
	print("  Itens      : ", report.get("item_count", 0))
	print("  Projéteis  : ", report.get("projectile_count", 0))
	print("  TileMapLayers : ", report.get("tilemap_layer_count", 0),
		"  (", report.get("total_tilemap_cells", 0), " células)")
	print("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
