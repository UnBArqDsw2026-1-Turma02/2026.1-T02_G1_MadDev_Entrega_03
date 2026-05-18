## Inimigo à distância - ataque com projétil
extends "res://scripts/enemies/enemy_base.gd"

## Tempo de preparação do tiro
@export var shoot_preparation_time: float = 0.5


## Sobrescreve a verificação de ataque (precisa de linha de visão)
func can_attack() -> bool:
	if _is_dead:
		return false
	
	# Verifica se o jogador está perto o suficiente
	var player = get_tree().get_first_node_in_group("player")
	if player == null:
		return false
	
	var distance = global_position.distance_to(player.global_position)
	return distance <= 150.0  # Alcance do ranged


## Sobrescreve a preparação do ataque
func prepare_attack() -> void:
	print(name, " mira no jogador...")
	# Aguarda um pouco antes de atirar
	await get_tree().create_timer(shoot_preparation_time).timeout


## Sobrescreve a execução do ataque
func execute_attack() -> void:
	print(name, " DISPAROU PROJÉTIL!")
	
	# Encontra o pool de projéteis
	var pool = get_node("/root/TestRoom/ProjectilePool")
	if pool == null:
		pool = get_tree().get_first_node_in_group("projectile_pool")
	
	if pool and pool.has_method("get_projectile"):
		var direction = Vector2.RIGHT
		var player = get_tree().get_first_node_in_group("player")
		if player:
			direction = (player.global_position - global_position).normalized()
		
		var projectile = pool.get_projectile(global_position, direction)
		if projectile:
			projectile.damage = attack_damage
	else:
		# Fallback: dano direto se não tiver pool
		_apply_damage_to_player(attack_damage)
