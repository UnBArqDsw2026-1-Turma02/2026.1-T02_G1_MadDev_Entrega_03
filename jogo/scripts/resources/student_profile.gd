## Prototype Pattern  — clone() garante cópia profunda do perfil sem criar do zero.
## Multiton Pattern — cada perfil é uma instância nomeada única deste Resource.
##                   O registry (StudentProfileRegistry) garante que só exista
##                   uma instância por profile_name em toda a aplicação.
## Decorator Pattern — os modificadores base são o ponto de entrada para que
##                     equipamentos e consumíveis "decorarem" os atributos do jogador.
@tool
extends ICloneable  ## Antes: extends Resource — agora herda ICloneable (que estende Resource).
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
# Prototype — clonagem profunda
# ---------------------------------------------------------------------------
 
## Retorna uma cópia profunda deste StudentProfile.
##
## Usa duplicate(true) internamente para garantir que sub-resources (se houver)
## também sejam copiados — sem compartilhar referências com o template original.
## Validações são executadas antes de retornar para detectar templates inválidos cedo.
##
## Exemplo de uso:
##   var novo_perfil := StudentProfileRegistry.clone_profile("guerreiro") as StudentProfile
##   novo_perfil.profile_name = "guerreiro_run_1"
func clone() -> Resource:
	assert(profile_name != "", \
		"StudentProfile.clone(): profile_name não pode ser vazio. Configure o template antes de clonar.")
 
	var copia: StudentProfile = duplicate(true) as StudentProfile
 
	assert(copia != null, \
		"StudentProfile.clone(): duplicate() retornou null — verifique a herança do Resource.")
	assert(copia.base_hp_modifier > 0.0, \
		"StudentProfile.clone(): base_hp_modifier deve ser maior que 0.")
	assert(copia.base_speed_modifier > 0.0, \
		"StudentProfile.clone(): base_speed_modifier deve ser maior que 0.")
	assert(copia.base_damage_modifier > 0.0, \
		"StudentProfile.clone(): base_damage_modifier deve ser maior que 0.")
 
	return copia

# ---------------------------------------------------------------------------
# Utilitários
# ---------------------------------------------------------------------------
func apply_to(player: Node) -> void:
	if player.has_method("take_damage"):
		pass  # ponto de extensão — chamado pelo GameManager ao iniciar a run
	if player.get("max_health") != null:
		player.max_health = roundi(player.max_health * base_hp_modifier)
		player.current_health = player.max_health
	if player.get("move_speed") != null:
		player.move_speed *= base_speed_modifier
	if player.get("base_damage") != null:
		player.base_damage = roundi(player.base_damage * base_damage_modifier)
