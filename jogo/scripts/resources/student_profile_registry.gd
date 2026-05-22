## Prototype Pattern — mantém perfis-template de StudentProfile e os clona sob demanda.
##
## Em vez de criar cada StudentProfile do zero a cada run, o registry guarda
## instâncias-template pré-configuradas e entrega cópias profundas via clone().
## Isso garante que o template original nunca seja modificado acidentalmente.
##
## Setup no projeto:
##   Project → Project Settings → Autoload → adicione este script com o nome
##   "StudentProfileRegistry".
##
## Uso típico (ex: no GameManager ao iniciar uma run):
##   var perfil := StudentProfileRegistry.clone_profile("guerreiro") as StudentProfile
##   perfil.apply_to(player)
extends Node
## class_name removido intencionalmente: este script é registrado como autoload com o
## nome "StudentProfileRegistry" em Project Settings. No Godot 4, ter class_name e
## autoload com o mesmo nome gera o erro "hides an autoload singleton".
## O acesso global via StudentProfileRegistry.clone_profile() já funciona pelo autoload.
 
 
# ---------------------------------------------------------------------------
# Armazenamento interno de templates
# ---------------------------------------------------------------------------
## Dicionário: profile_name (String) → StudentProfile (template, nunca modificado).
var _templates: Dictionary = {}
 
 
# ---------------------------------------------------------------------------
# Lifecycle — registra os perfis-template padrão ao iniciar
# ---------------------------------------------------------------------------
func _ready() -> void:
	_register_default_templates()
 
 
## Registra os perfis padrão do jogo.
## Adicione aqui novos perfis conforme o design do jogo evoluir.
func _register_default_templates() -> void:
	# ── Perfil: Guerreiro ────────────────────────────────────────────────────
	var guerreiro := StudentProfile.new()
	guerreiro.profile_name       = "guerreiro"
	guerreiro.base_hp_modifier     = 1.3   # +30% de vida
	guerreiro.base_speed_modifier  = 0.9   # -10% de velocidade
	guerreiro.base_damage_modifier = 1.2   # +20% de dano
	guerreiro.starting_weapon      = "res://resources/weapons/espada.tres"
	register_template(guerreiro)
 
	# ── Perfil: Explorador ───────────────────────────────────────────────────
	var explorador := StudentProfile.new()
	explorador.profile_name       = "explorador"
	explorador.base_hp_modifier     = 1.0
	explorador.base_speed_modifier  = 1.3   # +30% de velocidade
	explorador.base_damage_modifier = 0.9
	explorador.starting_weapon      = ""
	register_template(explorador)
 
	# ── Perfil: Mago ────────────────────────────────────────────────────────
	var mago := StudentProfile.new()
	mago.profile_name       = "mago"
	mago.base_hp_modifier     = 0.8   # -20% de vida
	mago.base_speed_modifier  = 1.0
	mago.base_damage_modifier = 1.5   # +50% de dano
	mago.starting_weapon      = "res://resources/weapons/grimorio.tres"
	register_template(mago)
 
 
# ---------------------------------------------------------------------------
# API pública
# ---------------------------------------------------------------------------
 
## Registra um StudentProfile como template.
## O registry passa a ser dono da referência — não modifique o objeto após registrá-lo.
func register_template(profile: StudentProfile) -> void:
	assert(profile != null, "StudentProfileRegistry.register_template(): profile não pode ser null.")
	assert(profile.profile_name != "", \
		"StudentProfileRegistry.register_template(): profile_name não pode ser vazio.")
	_templates[profile.profile_name] = profile
 
 
## Retorna uma cópia profunda do template com o nome informado.
## Seguro modificar o retorno sem afetar o template original.
func clone_profile(profile_name: String) -> StudentProfile:
	assert(_templates.has(profile_name), \
		"StudentProfileRegistry.clone_profile(): perfil '%s' não encontrado. \
		Verifique se foi registrado em _register_default_templates()." % profile_name)
	return _templates[profile_name].clone() as StudentProfile
 
 
## Retorna true se um template com o nome informado estiver registrado.
func has_template(profile_name: String) -> bool:
	return _templates.has(profile_name)
 
 
## Retorna a lista de nomes de todos os templates registrados.
func get_template_names() -> Array:
	return _templates.keys()
