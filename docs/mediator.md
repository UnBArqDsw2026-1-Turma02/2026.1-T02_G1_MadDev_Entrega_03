# GameMediator

Ponto central de comunicação entre sistemas do jogo. Em vez de nós se chamarem diretamente, publicam eventos no mediator que os roteia para quem estiver registrado.

## Quando usar

Use o `GameMediator` quando o receptor é **instanciado em runtime** e precisa gerenciar seu próprio ciclo de vida no sistema de eventos.

Use o `SignalBus` via inspetor quando o receptor é um **nó fixo de cena** com ciclo de vida estável (HUD, PauseMenu, AudioManager).

| Situação | Use |
|---|---|
| Nó criado/destruído em runtime (ex: sala, inimigo) | `GameMediator` |
| Sistema que filtra eventos por dados (ex: só boss) | `GameMediator` |
| Sistema de achievements ou analytics | `GameMediator` |
| Nó fixo de cena (ex: HUD, PauseMenu) | `SignalBus` via inspetor |

## Como usar

### Publicar um evento

```gdscript
GameMediator.notify(self, GameMediator.EVENT_ENEMY_DIED, {"enemy": self})
```

O terceiro argumento é opcional. Use-o para passar dados relevantes ao evento.

### Registrar um handler

```gdscript
func _ready() -> void:
    GameMediator.register(GameMediator.EVENT_ENEMY_DIED, _on_enemy_died)

func _on_enemy_died(sender: Object, event: StringName, data: Dictionary) -> void:
    var enemy = data.get("enemy", sender)
    # ...
```

### Remover o handler

Sempre remova o handler quando o nó sair da árvore para evitar callbacks inválidos.

```gdscript
func _exit_tree() -> void:
    GameMediator.unregister(GameMediator.EVENT_ENEMY_DIED, _on_enemy_died)
```

## Eventos disponíveis

| Constante | Dados (`data`) |
|---|---|
| `EVENT_PLAYER_HEALTH_CHANGED` | `new_health: int`, `max_health: int` |
| `EVENT_PLAYER_DIED` | — |
| `EVENT_ENEMY_SPAWNED` | `enemy: Node` |
| `EVENT_ENEMY_DIED` | `enemy: Node` |
| `EVENT_ROOM_CLEARED` | — |
| `EVENT_RUN_STARTED` | — |
| `EVENT_RUN_ENDED` | `victory: bool` |
| `EVENT_GAME_PAUSED` | `is_paused: bool` |
| `EVENT_SCORE_CHANGED` | `new_score: int` |

## Adicionando um novo evento

1. Declare a constante em `game_mediator.gd`:

```gdscript
const EVENT_ITEM_PICKED_UP: StringName = &"item_picked_up"
```

2. Se sistemas via inspetor precisarem ouvir, adicione o sinal no `SignalBus` e registre a bridge em `_register_signal_bus_bridge()`.
