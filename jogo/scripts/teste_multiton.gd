extends Node

func _ready() -> void:
	# 1. Espera o jogo carregar completamente
	await get_tree().process_frame
	
	print("\n--- INICIANDO TESTE DO MULTITON ---")
	
	# 2. Puxa as configurações do Modo Fácil
	var easy_mode: DifficultyConfig = DifficultyRegistry.get_instance(&"easy")
	print("Modo Fácil -> Vida: %s, Velocidade: %s" % [easy_mode.enemy_hp_modifier, easy_mode.enemy_speed_modifier])
	
	# 3. Puxa as configurações do Modo Difícil
	var hard_mode: DifficultyConfig = DifficultyRegistry.get_instance(&"hard")
	print("Modo Difícil -> Vida: %s, Drop Rate: %s" % [hard_mode.item_drop_rate, hard_mode.enemy_hp_modifier])
	
	# 4. Verifica se a instância é estritamente a mesma
	var hard_mode_copy = DifficultyRegistry.get_instance(&"hard")
	
	if hard_mode == hard_mode_copy:
		print("✅ SUCESSO: O Multiton retornou a mesma instância de memória!")
	else:
		print("❌ ERRO: O Multiton criou instâncias duplicadas para a mesma chave.")
		
	print("-----------------------------------\n")
