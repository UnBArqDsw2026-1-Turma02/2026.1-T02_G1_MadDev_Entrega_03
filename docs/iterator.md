# Iteradores Customizados

Padrão **Iterator** (GoF Comportamental) aplicado a coleções do jogo. Fornece uma forma uniforme de percorrer uma coleção sem expor sua estrutura interna, usando o protocolo nativo do GDScript (`_iter_init`, `_iter_next`, `_iter_get`).

Em vez de espalhar lógica de filtro ou ordenação pelo código com `if`/`sort_custom` repetidos, um iterador encapsula a regra de travessia e é consumido com `for x in iterator:` como qualquer Array.

## Quando usar

Use um iterador customizado quando você precisa percorrer uma coleção com uma regra de seleção ou ordenação que se repete em vários pontos do código.

| Situação | Use |
|---|---|
| Percorrer todos os itens de um Array sem filtro | `for x in array:` direto |
| Filtrar por tipo/categoria em vários lugares | `FilteredItemIterator` |
| Ordenar por distância em vários sistemas (IA, mira, drop) | `SortedEnemyIterator` |
| Filtro/ordenação aplicada uma única vez localmente | `array.filter()` / `array.sort_custom()` inline |

## Protocolo de iteração do GDScript

Para que `for x in obj:` funcione, `obj` precisa implementar três métodos:

| Método | Quando é chamado | Retorno |
|---|---|---|
| `_iter_init(arg: Array)` | Uma vez, no início do `for` | `true` se há elementos a iterar |
| `_iter_next(arg: Array)` | A cada iteração, antes de pegar o próximo | `true` se ainda há elementos |
| `_iter_get(arg: Variant)` | A cada iteração, para obter o elemento atual | O elemento na posição atual |

O parâmetro `arg` em `_iter_init` e `_iter_next` é um Array de 1 elemento usado como ponteiro mutável — `arg[0]` guarda o índice atual.

## Iteradores disponíveis

### FilteredItemIterator

Filtra um Array de itens por um campo `type`. O filtro é aplicado uma vez em `_iter_init`; iterações subsequentes apenas percorrem o resultado.

```gdscript
var inventory := [
    {"name": "Lápis",  "type": &"weapon"},
    {"name": "Café",   "type": &"consumable"},
    {"name": "Caneta", "type": &"weapon"},
]

for item in FilteredItemIterator.new(inventory, &"weapon"):
    print(item.name)
# → Lápis
# → Caneta
```

Os elementos do Array de entrada devem expor um campo `type` (StringName). Funciona com `Dictionary`, com objetos que tenham `type` como propriedade, ou com `Resource` que tenha `@export var type: StringName`.

### SortedEnemyIterator

Ordena um Array de inimigos por distância de um ponto de origem, do mais próximo ao mais distante.

```gdscript
var enemies := [
    {"name": "Livro",   "position": Vector2(100, 0)},
    {"name": "Caderno", "position": Vector2(20, 0)},
    {"name": "Prova",   "position": Vector2(50, 0)},
]

for enemy in SortedEnemyIterator.new(enemies, player.position):
    print(enemy.name)
# → Caderno  (mais próximo)
# → Prova
# → Livro    (mais distante)
```

Os elementos do Array de entrada devem expor um campo `position: Vector2`. Funciona com `Dictionary` ou diretamente com nós que herdam de `Node2D` (que já têm `position`).

## Criando um novo iterador customizado

1. Crie um arquivo em `jogo/scripts/iterators/` que `extends RefCounted`.
2. Implemente os três métodos do protocolo.
3. Use `_init()` para receber os parâmetros (coleção, critério de filtro/ordenação, etc.).

Exemplo — iterador que retorna apenas inimigos vivos:

```gdscript
## Iterator Pattern — itera apenas inimigos com HP > 0.
class_name AliveEnemyIterator
extends RefCounted

var enemies: Array
var _alive: Array = []

func _init(p_enemies: Array) -> void:
    enemies = p_enemies

func _iter_init(arg: Array) -> bool:
    _alive = enemies.filter(func(e): return e.current_health > 0)
    arg[0] = 0
    return _alive.size() > 0

func _iter_next(arg: Array) -> bool:
    arg[0] += 1
    return arg[0] < _alive.size()

func _iter_get(arg: Variant) -> Variant:
    return _alive[arg]
```

## Cuidados

- **Iteradores estendem `RefCounted`**, não `Node` nem `Resource`. Eles não vivem na árvore de cena — são objetos descartáveis criados, usados e liberados durante uma única operação.
- **A coleção é "fotografada" em `_iter_init`**. Se você alterar o Array original durante o `for`, o iterador não reflete a mudança (ele opera sobre uma cópia filtrada/ordenada). Isso é seguro por padrão — evita bugs de modificação durante iteração.
- **Tipos retornados são `Variant`**. Se for usar campos do elemento dentro do `for`, declare o tipo explicitamente para evitar warnings de inferência:

```gdscript
for enemy in SortedEnemyIterator.new(enemies, origin):
    var d: float = enemy.position.distance_to(origin)  # tipo explícito
```

## Arquivos

- `jogo/scripts/iterators/filtered_item_iterator.gd`
- `jogo/scripts/iterators/sorted_enemy_iterator.gd`
- `jogo/scenes/test_patterns.tscn` + `jogo/scripts/test_patterns.gd` — cena de teste

## Referências

- [GDScript iterator protocol](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#custom-iterators) — documentação oficial.
