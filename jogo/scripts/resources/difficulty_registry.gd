class_name DifficultyRegistry
extends RefCounted

# O dicionário estático que guarda as instâncias únicas nomeadas
static var _instances: Dictionary = {}

## Retorna a instância associada à chave. Se não existir, cria uma com valores padrão.
static func get_instance(key: StringName) -> DifficultyConfig:
	if not _instances.has(key):
		# Cria uma instância padrão caso ela seja chamada antes do registro oficial.
		_instances[key] = DifficultyConfig.new()
	return _instances[key]

## Permite registrar ou sobrescrever explicitamente uma configuração de dificuldade
static func register_difficulty(key: StringName, config: DifficultyConfig) -> void:
	_instances[key] = config
