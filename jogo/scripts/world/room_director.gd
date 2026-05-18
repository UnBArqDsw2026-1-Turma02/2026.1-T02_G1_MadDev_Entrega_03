## Director Pattern
## Define receitas pré-definidas de salas usando o Builder
class_name RoomDirector
extends Node

## Cria uma sala de combate (com inimigos)
static func build_combat_room(builder: RoomBuilder, difficulty: int = 1) -> Node2D:
	builder.set_room_name("Sala de Combate")
	builder.set_player_start(Vector2(152, 112))
	
	# Adiciona portas
	builder.set_exits([Vector2(-44, -106)])
	
	# Adiciona inimigos baseado na dificuldade
	match difficulty:
		1:
			builder.add_enemy(&"basic", Vector2(100, 100))
			builder.add_enemy(&"basic", Vector2(200, 100))
		2:
			builder.add_enemy(&"basic", Vector2(80, 100))
			builder.add_enemy(&"ranged", Vector2(220, 100))
			builder.add_enemy(&"basic", Vector2(150, 200))
		3:
			builder.add_enemy(&"ranged", Vector2(80, 80))
			builder.add_enemy(&"basic", Vector2(200, 80))
			builder.add_enemy(&"ranged", Vector2(140, 180))
			builder.add_enemy(&"basic", Vector2(80, 200))
	
	# Itens aleatórios (opcional)
	if difficulty >= 2:
		builder.add_item(&"health", Vector2(300, 150))
	
	return builder.build()


## Cria uma sala de descanso (sem inimigos, com itens)
static func build_rest_room(builder: RoomBuilder) -> Node2D:
	builder.set_room_name("Sala de Descanso")
	builder.set_player_start(Vector2(152, 112))
	
	# Adiciona portas (entrada e saída)
	builder.set_exits([Vector2(-44, -106), Vector2(300, -106)])
	
	# Adiciona itens de cura
	builder.add_item(&"health", Vector2(100, 150))
	builder.add_item(&"health", Vector2(200, 150))
	builder.add_item(&"mana", Vector2(150, 80))
	
	# Sem inimigos!
	
	return builder.build()


## Cria uma sala de chefão (difícil)
static func build_boss_room(builder: RoomBuilder) -> Node2D:
	builder.set_room_name("Sala do Chefão")
	builder.set_player_start(Vector2(152, 200))
	
	# Adiciona porta única
	builder.set_exits([Vector2(152, -100)])
	
	# Chefão + minions
	builder.add_enemy(&"ranged", Vector2(100, 80))
	builder.add_enemy(&"ranged", Vector2(200, 80))
	builder.add_enemy(&"basic", Vector2(150, 50))
	
	# Múltiplos inimigos básicos
	for i in range(3):
		builder.add_enemy(&"basic", Vector2(60 + i * 50, 150))
	
	return builder.build()


## Cria uma sala vazia (para testes)
static func build_empty_room(builder: RoomBuilder) -> Node2D:
	builder.set_room_name("Sala Vazia")
	builder.set_player_start(Vector2(152, 112))
	builder.set_exits([Vector2(-44, -106), Vector2(300, -106), Vector2(152, 250)])
	return builder.build()
