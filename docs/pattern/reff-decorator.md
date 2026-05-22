**Assignees:** @Verissimoo, @AguionStryke

**Descrição:**
Implementar Decorator para adicionar modificadores a itens em tempo de execução. Um item base pode ser decorado com: `BurnDecorator` (adiciona dano de fogo), `DoubleDropDecorator` (dobra quantidade), `RareDecorator` (aumenta raridade). Decoradores podem ser empilhados.

**🎓 Newbie Guide**

**O que é Decorator?**
Adiciona comportamento a um objeto sem alterar sua classe. Como adicionar coberturas em uma pizza: a pizza base não muda, mas cada cobertura adiciona algo. E você pode adicionar várias.

**Por onde começar:**
1. Encontre ou crie `jogo/scripts/items/item_base.gd` — é o objeto a ser decorado.
2. Pense no que um item "faz": `get_effect() -> String`, `get_value() -> int`.

**Passos:**
1. Em `item_base.gd`, defina a interface: `func get_effect() -> String` e `func get_value() -> int`.
2. Crie `jogo/scripts/items/decorators/item_decorator.gd` que estende `ItemBase` e tem `@export var wrapped: ItemBase`. Delega tudo para `wrapped`.
3. Crie `burn_decorator.gd`, `double_drop_decorator.gd`, `rare_decorator.gd` — cada um sobrescreve `get_effect()` e/ou `get_value()` adicionando ao resultado do `wrapped`.
4. Teste empilhando: `RareDecorator` → `BurnDecorator` → `ItemBase`.

**Links úteis:**
- [GDScript class inheritance](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#inheritance)

**✅ Tasks:**
- [ ] `ItemBase` com interface `get_effect()` e `get_value()`
- [ ] `ItemDecorator` base que delega para `wrapped`
- [ ] Implementar 3 decoradores concretos
- [ ] Empilhamento de 2+ decoradores funciona corretamente
- [ ] Testar que `BurnDecorator(RareDecorator(item))` combina os efeitos

---
