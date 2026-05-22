## Multiton Pattern — cada perfil é uma instância nomeada única deste Resource.
##                   O registry (StudentProfileRegistry) garante que só exista
##                   uma instância por profile_name em toda a aplicação.
## Decorator Pattern — os modificadores base são o ponto de entrada para que
##                     equipamentos e consumíveis "decorarem" os atributos do jogador.
@tool
extends Resource
class_name StudentProfile

# ---------------------------------------------------------------------------
# Identificação
# ---------------------------------------------------------------------------
@export var profile_name: String = ""

# ---------------------------------------------------------------------------
# Modificadores de atributo (multiplicadores sobre a base do jogador)
# ---------------------------------------------------------------------------
@export var base_hp_modifier: float = 1.0
@export var base_speed_modifier: float = 1.0
@export var base_damage_modifier: float = 1.0

# ---------------------------------------------------------------------------
# Equipamento inicial
# ---------------------------------------------------------------------------
## Caminho para o Resource da arma inicial (ex: "res://resources/weapons/caderno.tres").
## Deixe vazio para começar sem arma.
@export var starting_weapon: String = ""

# ---------------------------------------------------------------------------
# Utilitários
# ---------------------------------------------------------------------------
func apply_to(player: Node) -> void:
	if player.get("max_health") != null:
		player.max_health = roundi(player.max_health * base_hp_modifier)
		player.current_health = player.max_health
	if player.get("move_speed") != null:
		player.move_speed *= base_speed_modifier
	if player.get("base_damage") != null:
		player.base_damage = roundi(player.base_damage * base_damage_modifier)
