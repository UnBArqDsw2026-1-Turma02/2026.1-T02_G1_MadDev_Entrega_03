**Assignees:** @Verissimoo, @AguionStryke

**Descrição:**
Implementar Multiton para gerenciar múltiplas instâncias nomeadas de configurações de dificuldade. Ao contrário do Singleton (1 instância), o Multiton mantém um dicionário de instâncias identificadas por chave (ex: `"easy"`, `"normal"`, `"hard"`).

> ⚠️ Esta tarefa inclui documentação do padrão no wiki do projeto além da implementação.

**🎓 Newbie Guide**

**O que é Multiton?**
Variação do Singleton onde existem N instâncias fixas, cada uma identificada por uma chave. Como as instâncias únicas de dificuldade de um jogo: só existe um "modo difícil", mas você pode ter fácil, normal e difícil ao mesmo tempo.

**Por onde começar:**
1. Veja `jogo/scripts/autoloads/game_manager.gd` — ele já gerencia estado global.
2. Pense nas configurações de dificuldade como um `Resource` com dados de balanceamento.

**Passos:**
1. Crie `jogo/scripts/resources/difficulty_config.gd` (Resource) com campos: `enemy_hp_multiplier: float`, `enemy_speed_multiplier: float`, `item_drop_rate: float`.
2. Crie `jogo/scripts/difficulty_registry.gd` com dicionário estático `_instances: Dictionary` e método estático `get_instance(key: StringName) -> DifficultyConfig`.
3. No primeiro acesso a uma chave, crie e armazene a instância. Acesso subsequente retorna a mesma.
4. Registre as 3 dificuldades padrão no `_ready()` do `GameManager`.
5. Documente o padrão em `docs/patterns/multiton.md`.

**Links úteis:**
- [Static variables in GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#static-variables)

**✅ Tasks:**
- [x] Criar `DifficultyConfig` Resource com campos de balanceamento
- [x] `DifficultyRegistry.get_instance(key)` retorna sempre a mesma instância por chave
- [x] Registrar dificuldades `easy`, `normal`, `hard` no GameManager
- [x] Testar que duas chamadas com mesma chave retornam o mesmo objeto
- [x] Documentar padrão em `docs/patterns/multiton.md`

---
