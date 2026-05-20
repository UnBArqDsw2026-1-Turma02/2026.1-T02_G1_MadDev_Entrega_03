# ItemDecorator

Padrão **Decorator** (GoF Estrutural) aplicado aos itens do jogo. Permite anexar modificadores (fogo, raridade, drop duplicado) a um item base em tempo de execução, sem criar uma classe nova para cada combinação possível.

A ideia é envolver um `ItemBase` em um `ItemDecorator`, que delega chamadas ao item envolvido e adiciona seu próprio efeito ao resultado. Como o decorador é, ele próprio, um `ItemBase`, decoradores podem ser empilhados.

## Quando usar

Use quando um item precisa receber modificadores em runtime e várias combinações são possíveis. Sem o padrão, surgem classes como `FlamingRareSword`, `RareDoubleDropAxe`, `FlamingDoubleDropPotion` — combinação explode rapidamente.

| Situação | Use |
|---|---|
| Aplicar buff/debuff temporário a um item já existente | `ItemDecorator` |
| Combinar 2+ modificadores em runtime (raro + queima) | `ItemDecorator` |
| Definir todos os atributos de um item no inspetor antes da run | `ItemBase` direto |
| Atributo é fixo para todas as instâncias daquele item | Subclasse de `ItemBase` |

## Estrutura

```
ItemBase (Resource)
   ↑
ItemDecorator (abstrato, tem `wrapped: ItemBase`)
   ↑
├── BurnDecorator
├── DoubleDropDecorator
└── RareDecorator
```

Cada decorador concreto sobrescreve `get_effect()` e `get_value()` chamando `super.*` para herdar o resultado da cadeia antes de adicionar seu próprio efeito.

## Como usar

### Criar um item base

```gdscript
var item := ItemBase.new()
item.item_name = "Lápis"
item.base_value = 10
```

### Aplicar um decorador

```gdscript
var rare := RareDecorator.new()
rare.wrapped = item

print(rare.get_effect())  # → "✨RARE✨ Lápis"
print(rare.get_value())   # → 30  (10 base + 20 de raridade)
```

### Empilhar decoradores

A ordem importa: o decorador mais externo é o último aplicado.

```gdscript
var burn := BurnDecorator.new()
burn.wrapped = rare
burn.burn_damage = 5

print(burn.get_effect())  # → "✨RARE✨ Lápis 🔥(burn +5)"
print(burn.get_value())   # → 35  (30 do rare + 5 do burn)
```

## Decoradores disponíveis

| Classe | Efeito em `get_effect()` | Efeito em `get_value()` |
|---|---|---|
| `BurnDecorator` | concatena ` 🔥(burn +N)` | soma `burn_damage` |
| `DoubleDropDecorator` | concatena ` ×2` | multiplica por 2 |
| `RareDecorator` | prefixa `✨RARE✨ ` | soma `rarity_bonus` |

## Adicionando um novo decorador

1. Crie um novo arquivo em `jogo/scripts/items/decorators/` que `extends ItemDecorator`.
2. Sobrescreva `get_effect()` e/ou `get_value()` chamando `super.*` para preservar a cadeia.

Exemplo — `frost_decorator.gd`:

```gdscript
## Decorator Pattern — adiciona efeito de gelo (reduz velocidade do alvo).
class_name FrostDecorator
extends ItemDecorator

@export var slow_amount: int = 3

func get_effect() -> String:
    return super.get_effect() + " ❄️(slow -%d)" % slow_amount

func get_value() -> int:
    return super.get_value() + slow_amount
```

## Cuidados

- **Sempre defina `wrapped`** antes de chamar `get_effect()` / `get_value()` no decorador. Se ficar `null`, o decorador emite warning e retorna valores padrão (`""` e `0`).
- **A ordem de empilhamento afeta o resultado** em decoradores não-comutativos (ex: `DoubleDrop` aplicado antes ou depois de `Burn` produz valores diferentes).
- **Decoradores não modificam o item envolvido** — eles produzem um novo valor a cada chamada. Se o item base mudar (ex: `base_value` for ajustado), a próxima chamada da cadeia reflete a mudança.

## Arquivos

- `jogo/scripts/items/item_base.gd` — interface base (`Resource`)
- `jogo/scripts/items/decorators/item_decorator.gd` — decorador abstrato
- `jogo/scripts/items/decorators/burn_decorator.gd`
- `jogo/scripts/items/decorators/double_drop_decorator.gd`
- `jogo/scripts/items/decorators/rare_decorator.gd`
- `jogo/scenes/test_patterns.tscn` + `jogo/scripts/test_patterns.gd` — cena de teste
