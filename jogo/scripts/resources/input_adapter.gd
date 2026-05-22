## Adapter Pattern — traduz InputEvent (interface incompatível do Godot) para
##                   GameAction (interface esperada pelo sistema de gameplay).
##
## O player e demais sistemas de gameplay NUNCA chamam Input diretamente.
## Toda leitura de input passa por este adapter, que é o único ponto do código
## que conhece a API de Input do Godot. Isso permite trocar o adapter no futuro
## (ex: por um InputAdapter de replay, de IA ou de testes automatizados)
## sem alterar o player.
##
## Uso típico no player:
##   var action := _input_adapter.translate(event)      # event-driven
##   var dir    := _input_adapter.poll_move_vector()    # polling de movimento
##   var dash   := _input_adapter.is_just_pressed(ACTION_DASH)
extends Node
class_name InputAdapter
 
 
# ---------------------------------------------------------------------------
# Mapa de ações — espelha o Input Map definido em Project Settings
# Altere aqui se os nomes mudarem no project.godot, sem tocar em player.gd.
# ---------------------------------------------------------------------------
const ACTION_MOVE_UP    := &"move_up"
const ACTION_MOVE_DOWN  := &"move_down"
const ACTION_MOVE_LEFT  := &"move_left"
const ACTION_MOVE_RIGHT := &"move_right"
const ACTION_DASH       := &"dash"
 
## Lista de todas as ações mapeadas — usada em translate() para varredura.
const ALL_ACTIONS: Array = [
	ACTION_MOVE_UP,
	ACTION_MOVE_DOWN,
	ACTION_MOVE_LEFT,
	ACTION_MOVE_RIGHT,
	ACTION_DASH,
]
 
 
# ---------------------------------------------------------------------------
# API principal — event-driven
# ---------------------------------------------------------------------------
 
## Recebe um InputEvent bruto e retorna o GameAction correspondente.
##
## Percorre as 5 ações mapeadas e retorna a primeira que este evento dispara.
## Se o evento não corresponde a nenhuma ação conhecida, retorna GameAction
## com action_name = &"none" e strength = 0.0.
##
## Exemplo:
##   func _input(event: InputEvent) -> void:
##       var action := _input_adapter.translate(event)
##       if action.action_name == InputAdapter.ACTION_DASH:
##           _execute_dash()
func translate(event: InputEvent) -> GameAction:
	for action_name: StringName in ALL_ACTIONS:
		if event.is_action(action_name):
			return GameAction.make(action_name, event.get_action_strength(action_name))
	return GameAction.make(&"none", 0.0)
 
 
# ---------------------------------------------------------------------------
# API de polling — para consulta contínua em _physics_process
# ---------------------------------------------------------------------------
 
## Retorna o vetor de movimento combinando as 4 ações direcionais.
## Equivale a Input.get_vector(), mas sem expor Input ao chamador.
## Suporta tanto teclado (WASD / setas) quanto analógico de gamepad.
func poll_move_vector() -> Vector2:
	return Input.get_vector(
		ACTION_MOVE_LEFT,
		ACTION_MOVE_RIGHT,
		ACTION_MOVE_UP,
		ACTION_MOVE_DOWN
	)
 
 
## Retorna true se a ação informada foi pressionada neste frame (just_pressed).
## Uso: _input_adapter.is_just_pressed(InputAdapter.ACTION_DASH)
func is_just_pressed(action_name: StringName) -> bool:
	return Input.is_action_just_pressed(action_name)
 
 
## Retorna true enquanto a ação informada estiver pressionada (held).
func is_pressed(action_name: StringName) -> bool:
	return Input.is_action_pressed(action_name)
 
 
## Retorna a intensidade atual de uma ação [0.0, 1.0].
## Útil para gatilhos analógicos de gamepad.
func get_strength(action_name: StringName) -> float:
	return Input.get_action_strength(action_name)
