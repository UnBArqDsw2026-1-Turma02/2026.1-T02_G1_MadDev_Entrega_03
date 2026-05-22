## Adapter Pattern — representa uma ação de jogo tipada, desacoplada do InputEvent bruto.
##
## GameAction é o "contrato" que o sistema de gameplay recebe do InputAdapter.
## O player e demais sistemas nunca lidam com InputEvent diretamente —
## sempre recebem um GameAction com nome e intensidade da ação.
##
## Uso:
##   var action := _input_adapter.translate(event)
##   if action.action_name == InputAdapter.ACTION_DASH:
##       _execute_dash()
extends Resource
class_name GameAction
 
 
# ---------------------------------------------------------------------------
# Constantes de nome de ação (evita strings soltas pelo código)
# ---------------------------------------------------------------------------
## Use estas constantes ao comparar action_name, nunca strings literais.
 
 
# ---------------------------------------------------------------------------
# Campos
# ---------------------------------------------------------------------------
## Nome da ação mapeada em Project Settings → Input Map.
## Ex: &"move_up", &"dash", &"none"
@export var action_name: StringName = &""
 
## Intensidade da ação no intervalo [0.0, 1.0].
## Para teclas digitais vale 0.0 (inativa) ou 1.0 (pressionada).
## Para analógicos (gamepad) pode ser qualquer valor intermediário.
@export var strength: float = 0.0
 
 
# ---------------------------------------------------------------------------
# Factory helper
# ---------------------------------------------------------------------------
## Cria e retorna um GameAction configurado em uma única linha.
##
## Exemplo:
##   var a := GameAction.make(&"dash", 1.0)
static func make(p_name: StringName, p_strength: float = 1.0) -> GameAction:
	var a := GameAction.new()
	a.action_name = p_name
	a.strength    = p_strength
	return a
 
 
## Retorna true se este GameAction representa uma ação real (não &"none").
func is_valid() -> bool:
	return action_name != &"" and action_name != &"none"
