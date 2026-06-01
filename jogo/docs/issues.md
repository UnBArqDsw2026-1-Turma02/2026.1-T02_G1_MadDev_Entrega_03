# Issues — 2026.1-T02_G1_MadDev_Entrega_03

Repositório: [UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03](https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03)

Total de issues: 18

---

## #1 — [GOF CRIACIONAL] Factory Method — Criação de Inimigos

- **Estado:** closed
- **Responsável:** BrenoLUCO
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/1

**Assignees:** @matix0, @BrenoLUCO

**Descrição:**
Implementar o padrão Factory Method para centralizar a criação de inimigos. Em vez de instanciar `PackedScene` espalhado pelo código, uma única função de fábrica recebe um tipo e retorna a cena correta já configurada. Isso facilita adicionar novos inimigos sem alterar o código de spawn.

**🎓 Newbie Guide**

**O que é Factory Method?**
É um padrão que diz: "não use `new` diretamente — chame uma função que sabe qual objeto criar". Em Godot, `PackedScene.instantiate()` é o equivalente a `new`. O Factory Method centraliza essas chamadas.

**Por onde começar:**
1. Abra `jogo/scripts/world/room_validator.gd` e `jogo/scripts/autoloads/game_manager.gd` para entender como inimigos são esperados.
2. Leia `jogo/scripts/enemies/enemy_base.gd` — todos os inimigos herdam daqui.

**Passos:**
1. Crie `jogo/scripts/enemies/enemy_factory.gd` com uma função estática `create(type: StringName) -> CharacterBody2D`.
2. Dentro da função, use um `match` para escolher qual `PackedScene` instanciar.
3. Registre os `PackedScene` como `@export` ou como constantes no topo do arquivo.
4. Substitua qualquer `load("res://...").instantiate()` espalhado pelo código pela chamada `EnemyFactory.create(...)`.

**Links úteis:**
- [PackedScene.instantiate()](https://docs.godotengine.org/en/stable/classes/class_packedscene.html#class-packedscene-method-instantiate)
- [Static functions in GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#static-functions)

**✅ Tasks:**
- [x] Criar `enemy_factory.gd` com função `create(type: StringName) -> CharacterBody2D`
- [x] Mapear pelo menos 2 tipos de inimigos (ex: `&"basic"`, `&"ranged"`)
- [x] Substituir instanciações avulsas pela fábrica
- [x] Adicionar tipagem estática em todos os parâmetros e retornos
- [x] Testar que o inimigo correto é spawnado para cada tipo

---

---

## #2 — [GOF CRIACIONAL] Builder — Construção de Salas Procedurais

- **Estado:** closed
- **Responsável:** BrenoLUCO
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/2

**Assignees:** @matix0, @BrenoLUCO

**Descrição:**
Implementar o padrão Builder para montar salas de forma procedural passo a passo. Em vez de uma sala ser sempre idêntica, o Builder permite configurar: quantos inimigos, quais itens, qual tilemap, quais portas existem. Cada "diretor" chama os métodos do builder em sequência para produzir uma sala completa.

**🎓 Newbie Guide**

**O que é Builder?**
Builder separa a *construção* de um objeto complexo da sua *representação final*. Pense como um cardápio: você escolhe entrada, prato principal e sobremesa — o garçom (director) faz os pedidos ao cozinheiro (builder) que monta o prato.

**Por onde começar:**
1. Leia `jogo/scenes/world/test_room.tscn` para entender o que compõe uma sala.
2. Veja `jogo/scripts/world/room_validator.gd` — ele lista o que uma sala precisa ter.

**Passos:**
1. Crie `jogo/scripts/world/room_builder.gd` com métodos: `set_enemy_count(n)`, `set_item_pool(items)`, `set_exits(directions)`, `build() -> Node`.
2. Crie `jogo/scripts/world/room_director.gd` com funções que chamam o builder em sequências pré-definidas (ex: `build_combat_room()`, `build_rest_room()`).
3. O `build()` deve retornar um nó `Node2D` com todos os filhos já adicionados.
4. Integre com `GameManager` para usar o director ao trocar de sala.

**Links úteis:**
- [Node.add_child()](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-method-add-child)

**✅ Tasks:**
- [ ] Criar `room_builder.gd` com interface fluente (métodos encadeáveis)
- [ ] Criar `room_director.gd` com ao menos 2 tipos de sala
- [ ] `build()` retorna a sala como `Node` pronto para `add_child`
- [ ] Integrar com `GameManager.start_run()` ou equivalente
- [ ] Testar geração de 2 salas diferentes com o mesmo builder

---

---

## #3 — [GOF CRIACIONAL] Object Pool — Pool de Projéteis

- **Estado:** closed
- **Responsável:** BrenoLUCO
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/3

**Assignees:** @matix0, @BrenoLUCO

**Descrição:**
Implementar um pool de objetos para projéteis. Em vez de criar e destruir nós a cada disparo (`instantiate` + `queue_free`), o pool mantém um conjunto de projéteis inativos e os reutiliza. Projéteis ficam com `process_mode = DISABLED` quando "inativos" e são reativados ao disparar.

**🎓 Newbie Guide**

**O que é Object Pool?**
É uma técnica para evitar criação/destruição constante de objetos caros. Imagine um estoque de caixas: em vez de fabricar uma nova caixa toda vez, você pega uma do estoque, usa, e devolve quando terminar.

**Por onde começar:**
1. Leia `jogo/scripts/projectiles/projectile_base.gd` — é o objeto que será poolado.
2. Veja como o player dispara (se existir) ou onde projéteis seriam criados.

**Passos:**
1. Crie `jogo/scripts/world/projectile_pool.gd` como autoload ou nó na cena.
2. No `_ready()`, pré-instancie N projéteis e os adicione como filhos com `process_mode = Node.PROCESS_MODE_DISABLED` e `visible = false`.
3. Crie `get_projectile() -> Node` que itera pelos filhos, encontra um inativo e o retorna ativado.
4. Em `projectile_base.gd`, ao terminar (colidir ou timeout), chame `process_mode = DISABLED` e `visible = false` em vez de `queue_free()`.

**Links úteis:**
- [Node.process_mode](https://docs.godotengine.org/en/stable/classes/class_node.html#class-node-property-process-mode)

**✅ Tasks:**
- [ ] Criar `projectile_pool.gd` com pré-alocação configurável via `@export`
- [ ] `get_projectile()` retorna projétil inativo ou expande o pool se necessário
- [ ] Projéteis desativam via `process_mode = DISABLED` (sem `queue_free`)
- [ ] Integrar com o sistema de disparo do player/inimigo
- [ ] Testar que o pool não cresce indefinidamente durante uso normal

---

---

## #4 — [GOF ESTRUTURAL] Facade — Facade de Serviços do Jogo

- **Estado:** closed
- **Responsável:** BrenoLUCO
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/4

**Assignees:** @matix0, @BrenoLUCO

**Descrição:**
Criar uma Facade que simplifique o acesso aos subsistemas complexos do jogo (AudioManager, GameManager, SignalBus). Código de gameplay não deve precisar saber de qual autoload chamar — chama a Facade e ela encaminha para o subsistema correto.

**🎓 Newbie Guide**

**O que é Facade?**
É uma fachada (como a entrada de um prédio): você não vê a fiação, encanamento e estrutura — só a porta. A Facade oferece uma interface simples para sistemas complexos por baixo.

**Por onde começar:**
1. Veja os autoloads em `jogo/scripts/autoloads/` — são os subsistemas que a Facade vai simplificar.
2. Note quais chamadas se repetem no código (ex: `AudioManager.play_sfx(...)`, `GameManager.add_score(...)`).

**Passos:**
1. Crie `jogo/scripts/autoloads/game_facade.gd` e registre como autoload `GameFacade` em `project.godot`.
2. Adicione métodos de alto nível: `play_sound(sfx_name)`, `award_points(n)`, `emit_event(signal_name)`.
3. Internamente, delegue para `AudioManager`, `GameManager`, `SignalBus`.
4. Refatore 1 script existente para usar `GameFacade` em vez de chamar autoloads diretamente.

**Links úteis:**
- [Autoloads (Singletons)](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

**✅ Tasks:**
- [ ] Criar `game_facade.gd` registrado como autoload `GameFacade`
- [ ] Cobrir ao menos 3 subsistemas (Audio, Game, Signal)
- [ ] Pelo menos 5 métodos de alto nível implementados
- [ ] Refatorar ao menos 1 script existente para usar a Facade
- [ ] Documentar (comentário de cabeçalho) o propósito de cada método

---

---

## #5 — [GOF COMPORTAMENTAL] Template Method — Fluxo de Ataque Base

- **Estado:** closed
- **Responsável:** BrenoLUCO
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/5

**Assignees:** @matix0, @BrenoLUCO

**Descrição:**
Implementar Template Method para definir o esqueleto do fluxo de ataque dos inimigos. A classe base define a ordem: `can_attack()` → `prepare_attack()` → `execute_attack()` → `cooldown()`. Cada inimigo sobrescreve apenas as etapas que diferem.

**🎓 Newbie Guide**

**O que é Template Method?**
Define o "roteiro" de uma operação na classe pai, mas deixa as classes filhas preencherem os detalhes. Como uma receita de bolo: a sequência (misturar, assar, decorar) é sempre a mesma, mas cada bolo tem ingredientes diferentes.

**Por onde começar:**
1. Leia `jogo/scripts/enemies/enemy_base.gd` — adicione o método template aqui.
2. Crie ou edite pelo menos 1 inimigo concreto para sobrescrever as etapas.

**Passos:**
1. Em `enemy_base.gd`, adicione `func attack_sequence() -> void` que chama em ordem: `can_attack()`, `prepare_attack()`, `execute_attack()`, `cooldown()`.
2. Implemente versões padrão (que podem ser vazias ou retornar `false`) de cada etapa.
3. Em um inimigo concreto (ex: `enemy_melee.gd`), sobrescreva `execute_attack()` com o ataque específico.
4. Chame `attack_sequence()` de dentro do loop de comportamento do inimigo.

**Links úteis:**
- [GDScript inheritance / virtual methods](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#inheritance)

**✅ Tasks:**
- [ ] Adicionar `attack_sequence()` como método template em `enemy_base.gd`
- [ ] Definir 4 etapas: `can_attack`, `prepare_attack`, `execute_attack`, `cooldown`
- [ ] Implementar ao menos 2 inimigos concretos com `execute_attack` diferente
- [ ] `attack_sequence()` é chamado pelo loop de AI do inimigo
- [ ] Testar que a sequência correta é executada para cada inimigo

---

---

## #6 — [GOF CRIACIONAL] Prototype — Clonagem de Perfis de Estudante

- **Estado:** open
- **Responsável:** RufinoVfR
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/6

**Assignees:** @RufinoVfR, @rich4rd1

**Descrição:**
Implementar o padrão Prototype com interface `ICloneable` explícita para clonar `StudentProfile` (Resource). Em vez de criar perfis do zero, um perfil-template é clonado e personalizado. O método `clone()` garante cópia profunda dos dados.

**🎓 Newbie Guide**

**O que é Prototype?**
Em vez de construir um objeto do zero, você copia um já existente e ajusta o que precisar. Como duplicar um formulário preenchido e mudar só o nome.

**Por onde começar:**
1. Leia `jogo/scripts/resources/student_profile.gd` — é o objeto a ser clonado.
2. Note que Godot tem `duplicate()` nativo, mas precisamos de `clone()` explícito com interface.

**Passos:**
1. Crie `jogo/scripts/interfaces/i_cloneable.gd` com `func clone() -> Resource: return null`.
2. Em `student_profile.gd`, adicione `extends ICloneable` (use composição se herança não for possível) e implemente `clone()` usando `duplicate(true)` internamente mas com lógica adicional de validação.
3. Crie um `StudentProfileRegistry` (já existe como autoload) que mantém perfis-template e clona sob demanda.
4. Teste clonando um perfil e alterando o clone sem afetar o original.

**Links úteis:**
- [Resource.duplicate()](https://docs.godotengine.org/en/stable/classes/class_resource.html#class-resource-method-duplicate)

**✅ Tasks:**
- [ ] Criar `i_cloneable.gd` com método `clone() -> Resource`
- [ ] `StudentProfile.clone()` realiza cópia profunda (subresources incluídos)
- [ ] `StudentProfileRegistry` usa clone em vez de criar perfis novos
- [ ] Alterar o clone não afeta o original (teste explícito)
- [ ] Adicionar ao menos 1 perfil-template pré-configurado no registry

---

---

## #7 — [GOF ESTRUTURAL] Adapter — Adaptador de Input para Ações do Jogo

- **Estado:** open
- **Responsável:** RufinoVfR
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/7

**Assignees:** @RufinoVfR, @rich4rd1

**Descrição:**
Criar um Adapter que traduz eventos brutos de `InputEvent` (teclado, gamepad) para ações de jogo tipadas (`MoveAction`, `AttackAction`). O sistema de gameplay nunca lida com `InputEvent` diretamente — sempre recebe uma `GameAction`.

**🎓 Newbie Guide**

**O que é Adapter?**
Faz dois sistemas incompatíveis conversarem. Como um adaptador de tomada: a mesma energia (input), mas na forma certa para o aparelho (gameplay).

**Por onde começar:**
1. Veja as ações de input definidas em `project.godot` (seção `[input]`): `move_up`, `move_down`, `move_left`, `move_right`, `dash`.
2. Leia `jogo/scripts/player/player.gd` — é quem consome o input atualmente.

**Passos:**
1. Crie `jogo/scripts/input/game_action.gd` como Resource com campos: `action_name: StringName`, `strength: float`.
2. Crie `jogo/scripts/input/input_adapter.gd` com método `translate(_event: InputEvent) -> GameAction`.
3. No `translate()`, use `Input.is_action_pressed()` para mapear para `GameAction`.
4. Em `player.gd`, substitua leituras diretas de `Input` pela chamada ao adapter.

**Links úteis:**
- [InputEvent](https://docs.godotengine.org/en/stable/classes/class_inputevent.html)
- [Input.is_action_pressed()](https://docs.godotengine.org/en/stable/classes/class_input.html)

**✅ Tasks:**
- [ ] Criar `GameAction` Resource com `action_name` e `strength`
- [ ] Criar `InputAdapter` com `translate(event) -> GameAction`
- [ ] Mapear todas as 5 ações do `project.godot`
- [ ] `player.gd` usa o adapter em vez de `Input` direto
- [ ] Testar que WASD e setas geram `GameAction` equivalentes

---

---

## #8 — [GOF COMPORTAMENTAL] State — Máquina de Estados do Player

- **Estado:** open
- **Responsável:** RufinoVfR
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/8

**Assignees:** @RufinoVfR, @rich4rd1

**Descrição:**
Implementar uma máquina de estados finita (FSM) para o player com estados: `IdleState`, `MoveState`, `DashState`, `AttackState`. Cada estado é um Resource com métodos `enter()`, `update(delta)`, `exit()`. O player delega toda lógica para o estado ativo.

**🎓 Newbie Guide**

**O que é State?**
O objeto muda de comportamento conforme seu estado interno — como um semáforo que só faz uma coisa dependendo da cor acesa. Em vez de `if is_dashing: ... elif is_attacking: ...`, cada estado é um objeto separado.

**Por onde começar:**
1. Leia `jogo/scripts/player/player.gd` — identifique onde há lógica condicional baseada em estado.
2. O dash já existe como input (`dash` action) — vai virar um estado.

**Passos:**
1. Crie `jogo/scripts/player/states/player_state.gd` (base) com `enter()`, `update(delta)`, `exit()`, `get_transition() -> StringName`.
2. Crie `idle_state.gd`, `move_state.gd`, `dash_state.gd`, `attack_state.gd` herdando de `player_state.gd`.
3. Em `player.gd`, adicione `@export var states: Dictionary` mapeando nome → Resource de estado.
4. Implemente `transition_to(state_name: StringName)` que chama `exit()` no atual e `enter()` no novo.
5. Em `_physics_process()`, chame `current_state.update(delta)` e verifique `get_transition()`.

**Links úteis:**
- [GDScript Resources](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html)

**✅ Tasks:**
- [ ] Criar classe base `PlayerState` com `enter/update/exit/get_transition`
- [ ] Implementar 4 estados: Idle, Move, Dash, Attack
- [ ] `player.gd` delega `_physics_process` para o estado ativo
- [ ] Transições acontecem via `get_transition()` sem condicionais em `player.gd`
- [ ] Testar todas as transições possíveis entre os 4 estados

---

---

## #9 — [GOF COMPORTAMENTAL] Strategy — Estratégias de Pathfinding de Inimigos (B)

- **Estado:** open
- **Responsável:** RufinoVfR
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/9

**Assignees:** @RufinoVfR, @rich4rd1

**Descrição:**
Implementar o padrão Strategy para intercambiar algoritmos de pathfinding em inimigos em tempo de execução. Estratégias: `DirectChaseStrategy` (linha reta), `NavigationStrategy` (usa NavigationAgent2D), `PatrolStrategy` (segue waypoints).

**🎓 Newbie Guide**

**O que é Strategy?**
Permite trocar o algoritmo usado por um objeto sem mudar o objeto. Como trocar o GPS de um carro: o carro (inimigo) não muda, mas a rota calculada sim.

**Por onde começar:**
1. Leia `jogo/scripts/enemies/enemy_base.gd` — adicione `@export var move_strategy: MoveStrategy`.
2. Veja como `NavigationAgent2D` funciona no Godot (link abaixo).

**Passos:**
1. Crie `jogo/scripts/enemies/strategies/move_strategy.gd` (base) com `func get_velocity(enemy: CharacterBody2D, target: Node2D) -> Vector2: return Vector2.ZERO`.
2. Implemente `direct_chase_strategy.gd`: retorna `(target.position - enemy.position).normalized() * speed`.
3. Implemente `navigation_strategy.gd`: usa `NavigationAgent2D` do inimigo.
4. Implemente `patrol_strategy.gd`: segue lista de `waypoints: Array[Vector2]`.
5. Em `enemy_base.gd`, use `velocity = move_strategy.get_velocity(self, player)` em `_physics_process`.

**Links úteis:**
- [NavigationAgent2D](https://docs.godotengine.org/en/stable/classes/class_navigationagent2d.html)

**✅ Tasks:**
- [ ] Criar `MoveStrategy` base com `get_velocity(enemy, target) -> Vector2`
- [ ] Implementar `DirectChaseStrategy`, `NavigationStrategy`, `PatrolStrategy`
- [ ] `enemy_base.gd` usa `@export var move_strategy: MoveStrategy`
- [ ] Troca de estratégia funciona em tempo de execução (no Inspector)
- [ ] Testar que cada estratégia produz movimento diferente

---

---

## #10 — [GOF COMPORTAMENTAL] Visitor — Relatório de Estatísticas de Nós da Sala (B)

- **Estado:** open
- **Responsável:** RufinoVfR
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/10

**Assignees:** @RufinoVfR, @rich4rd1

**Descrição:**
Implementar o padrão Visitor para percorrer nós de uma sala e coletar estatísticas sem modificar as classes visitadas. O `StatsVisitor` visita: `EnemyBase`, `ItemBase`, `ProjectileBase`, `TileMapLayer` e coleta dados como contagem, HP total, tipos presentes.

**🎓 Newbie Guide**

**O que é Visitor?**
Permite adicionar operações a objetos sem alterar suas classes. Como um inspetor que visita diferentes departamentos de uma empresa e anota informações — cada departamento sabe "receber" o inspetor, mas não sabe o que ele vai fazer com os dados.

**Por onde começar:**
1. Identifique os 4 tipos de nós na cena de teste: inimigos, itens, projéteis, tilemaps.
2. Em Godot, o equivalente é `get_tree().get_nodes_in_group("enemies")` etc.

**Passos:**
1. Crie `jogo/scripts/utils/stats_visitor.gd` com métodos: `visit_enemy(e: EnemyBase)`, `visit_item(i: ItemBase)`, `visit_projectile(p: ProjectileBase)`, `visit_tilemap(t: TileMapLayer)`.
2. Adicione método `accept(visitor: StatsVisitor)` em cada classe base.
3. Crie `jogo/scripts/utils/room_stats_report.gd` que instancia o visitor, percorre todos os grupos e retorna um `Dictionary` com as estatísticas.
4. Exiba o relatório no console (print) ao pressionar uma tecla de debug.

**Links úteis:**
- [SceneTree.get_nodes_in_group()](https://docs.godotengine.org/en/stable/classes/class_scenetree.html#class-scenetree-method-get-nodes-in-group)

**✅ Tasks:**
- [ ] Criar `StatsVisitor` com `visit_*` para 4 tipos de nó
- [ ] Cada classe base tem método `accept(visitor)`
- [ ] `RoomStatsReport` percorre todos os grupos e agrega dados
- [ ] Relatório imprime no console com tecla de debug
- [ ] Testar que alterar a cena muda os dados do relatório

---

---

## #11 — [GOF CRIACIONAL] Multiton — Registry de Perfis por Dificuldade

- **Estado:** closed
- **Responsável:** AguionStryke
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/11

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

---

## #12 — [GOF ESTRUTURAL] Decorator — Modificadores de Itens

- **Estado:** closed
- **Responsável:** AguionStryke
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/12

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

---

## #13 — [GOF COMPORTAMENTAL] Iterator — Iteradores de Coleções do Inventário (B)

- **Estado:** closed
- **Responsável:** AguionStryke
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/13

### [Task 14] 

**Assignees:** @Verissimoo, @AguionStryke

**Descrição:**
Implementar iteradores customizados para coleções do jogo usando o protocolo nativo do GDScript (`_iter_init`, `_iter_next`, `_iter_get`). Criar dois iteradores: `FilteredItemIterator` (filtra por tipo) e `SortedEnemyIterator` (ordena inimigos por distância).

**🎓 Newbie Guide**

**O que é Iterator?**
Fornece uma forma uniforme de percorrer uma coleção sem expor sua estrutura interna. Em Godot, você pode criar um objeto iterável que funciona com `for item in collection:` implementando 3 métodos especiais.

**Por onde começar:**
1. Em GDScript, para `for x in obj:` funcionar, `obj` precisa ter `_iter_init`, `_iter_next`, `_iter_get`.
2. Veja a documentação (link abaixo) — é um protocolo pouco conhecido mas poderoso.

**Passos:**
1. Crie `jogo/scripts/iterators/filtered_item_iterator.gd` com `var items: Array`, `var filter_type: StringName`, e os 3 métodos do protocolo de iteração.
2. No `_iter_init`, filtre `items` pelo `filter_type` e armazene o resultado.
3. Crie `sorted_enemy_iterator.gd` que aceita `enemies: Array` e `origin: Vector2`, ordena por distância em `_iter_init`.
4. Teste com `for item in FilteredItemIterator.new(inventory, &"weapon"):`.

**Links úteis:**
- [GDScript iterator protocol](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#custom-iterators)

**✅ Tasks:**
- [ ] `FilteredItemIterator` implementa `_iter_init/next/get` com filtro por tipo
- [ ] `SortedEnemyIterator` ordena por distância do ponto de origem
- [ ] Ambos funcionam com sintaxe `for x in iterator:`
- [ ] Testar filtro: iterar apenas itens do tipo `"weapon"` de um inventário misto
- [ ] Testar ordenação: inimigos retornados do mais próximo ao mais distante

---

---

## #14 — [GOF COMPORTAMENTAL] Chain of Responsibility — Pipeline de Dano (B)

- **Estado:** closed
- **Responsável:** AguionStryke
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/14

**Assignees:** @Verissimoo, @AguionStryke

**Descrição:**
Implementar uma cadeia de responsabilidade para processar dano recebido pelo player. Cada handler na cadeia pode modificar, absorver ou repassar o dano: `ArmorHandler` → `ResistanceHandler` → `HealthHandler`. O dano final só chega à vida se passar por todos.

**🎓 Newbie Guide**

**O que é Chain of Responsibility?**
Uma requisição passa por uma cadeia de handlers, cada um podendo processá-la, modificá-la ou passá-la adiante. Como uma triagem hospitalar: recepção → enfermeiro → médico. Cada um faz sua parte ou encaminha.

**Por onde começar:**
1. Veja como dano é aplicado atualmente em `jogo/scripts/player/player.gd` ou `enemy_base.gd`.
2. Pense nos modificadores de dano que o jogo poderia ter: armadura, resistências, efeitos.

**Passos:**
1. Crie `jogo/scripts/damage/damage_handler.gd` (Resource) com `@export var next: DamageHandler` e `func handle(damage: float, context: Dictionary) -> float`.
2. Na implementação base de `handle()`, chame `next.handle(damage, context)` se `next != null`.
3. Crie `armor_handler.gd` (reduz dano por valor fixo), `resistance_handler.gd` (aplica % de resistência), `health_handler.gd` (aplica dano final ao HP).
4. Monte a cadeia via Inspector: `ArmorHandler.next = ResistanceHandler`, `ResistanceHandler.next = HealthHandler`.
5. Dispare com `damage_chain.handle(incoming_damage, {})`.

**Links úteis:**
- [GDScript Resources with @export](https://docs.godotengine.org/en/stable/tutorials/scripting/resources.html)

**✅ Tasks:**
- [x] Criar `DamageHandler` base com `next` e `handle(damage, context)`
- [x] Implementar `ArmorHandler`, `ResistanceHandler`, `HealthHandler`
- [x] Cadeia montável via Inspector (sem código)
- [x] `HealthHandler` aplica dano final ao HP do alvo
- [x] Testar que dano de 100 com armadura 20 e resistência 50% resulta em 40

---

---

## #15 — [GOF CRIACIONAL] Singleton —  GameManager

- **Estado:** closed
- **Responsável:** PhMoraiis
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/15

**Assignees:** @PhMoraiis, @Pietrocv

**Descrição:**
O padrão Singleton já está implementado nativamente pelo sistema de Autoload do Godot (`GameManager`, `SignalBus`, `AudioManager`). Esta tarefa consiste em documentar formalmente o padrão, mapear todos os singletons existentes, e garantir que não existam anti-padrões (acoplamento excessivo, estado global desnecessário).

> ⚠️ Esta tarefa inclui documentação do padrão no wiki do projeto além da auditoria.

**🎓 Newbie Guide**

**O que é Singleton?**
Garante que uma classe tenha apenas uma instância global. Em Godot, o sistema de Autoload faz isso automaticamente — qualquer script registrado como autoload pode ser acessado de qualquer lugar pelo nome.

**Por onde começar:**
1. Abra `project.godot` e veja a seção `[autoload]` — esses são os singletons.
2. Leia cada script em `jogo/scripts/autoloads/`.

**Passos:**
1. Audite cada autoload: ele precisa ser singleton? Tem estado desnecessário? Poderia ser um nó local?
2. Documente em `docs/patterns/singleton.md`: o que é, por que Godot usa autoload, lista dos singletons do projeto, responsabilidade de cada um.
3. Verifique se `GameManager` tem responsabilidades demais (God Object) e proponha divisão se necessário.
4. Garanta que nenhum script acessa propriedades internas de outro autoload (violação do encapsulamento).

**Links úteis:**
- [Godot Singletons / Autoload](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

**✅ Tasks:**
- [x] Auditar os 4 autoloads existentes (GameManager, SignalBus, AudioManager, StudentProfileRegistry)
- [x] Documentar o padrão em `docs/patterns/singleton.md`
- [x] Listar responsabilidades de cada singleton
- [x] Identificar e corrigir qualquer violação de encapsulamento
- [x] Propor (e implementar se viável) divisão de responsabilidades do GameManager

---

---

## #16 — [GOF ESTRUTURAL] Bridge — Separação de Renderização e Lógica de UI

- **Estado:** closed
- **Responsável:** PhMoraiis
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/16

**Assignees:** @PhMoraiis, @Pietrocv

**Descrição:**
Implementar Bridge para desacoplar a abstração da UI (o que mostrar) da implementação de renderização (como mostrar). A `HUDAbstraction` define o que exibir (HP, score, tempo), e `CanvasRenderer` / `DebugRenderer` são implementações intercambiáveis.

**🎓 Newbie Guide**

**O que é Bridge?**
Separa uma abstração de sua implementação para que ambas possam variar independentemente. Como uma lâmpada (abstração: "dar luz") e a tomada (implementação: voltagem, frequência) — você pode trocar qualquer uma sem afetar a outra.

**Por onde começar:**
1. Veja `jogo/scenes/ui/` — quais elementos de UI existem.
2. Pense: o que a UI precisa exibir (abstração) vs. como ela exibe (implementação).

**Passos:**
1. Crie `jogo/scripts/ui/renderers/ui_renderer.gd` (interface) com `func render_hp(value: float, max: float)`, `func render_score(value: int)`, `func render_time(seconds: float)`.
2. Implemente `canvas_renderer.gd` (usa Labels/ProgressBar do Godot) e `debug_renderer.gd` (usa `print()`).
3. Crie `jogo/scripts/ui/hud_abstraction.gd` com `@export var renderer: UIRenderer` e métodos de alto nível que delegam para o renderer.
4. Conecte o HUD ao `SignalBus` para atualizar quando o estado muda.

**Links úteis:**
- [Control nodes](https://docs.godotengine.org/en/stable/classes/class_control.html)

**✅ Tasks:**
- [x] Criar `UIRenderer` interface com `render_hp`, `render_score`, `render_time`
- [x] Implementar `CanvasRenderer` (visual) e `DebugRenderer` (console)
- [x] `HUDAbstraction` usa `@export var renderer: UIRenderer`
- [x] Trocar renderer no Inspector muda como a UI é exibida
- [x] Conectar ao SignalBus para atualização automática

---

---

## #17 — [GOF COMPORTAMENTAL] Mediator — Coordenador de Comunicação entre Sistemas

- **Estado:** closed
- **Responsável:** Pietrocv
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/17

###

**Assignees:** @PhMoraiis, @Pietrocv

**Descrição:**
Implementar Mediator para centralizar a comunicação entre sistemas do jogo (Player, Enemies, HUD, AudioManager). Em vez de sistemas se chamarem diretamente, eles publicam eventos no Mediator que os roteia. Isso é uma extensão tipada do `SignalBus` existente.

**🎓 Newbie Guide**

**O que é Mediator?**
Objetos não se comunicam diretamente — falam com um intermediário que roteia as mensagens. Como um controlador de tráfego aéreo: aviões não falam entre si, falam com a torre.

**Por onde começar:**
1. Veja `jogo/scripts/autoloads/signal_bus.gd` — o SignalBus já é um mediator informal.
2. O objetivo é criar um Mediator mais formal com roteamento baseado em tipo de evento.

**Passos:**
1. Crie `jogo/scripts/autoloads/game_mediator.gd` (autoload) com `func notify(sender: Object, event: StringName, data: Dictionary) -> void`.
2. Internamente, `notify()` usa um dicionário `_handlers: Dictionary` para mapear eventos a callbacks.
3. Adicione `func register(event: StringName, callback: Callable)` e `func unregister(event: StringName, callback: Callable)`.
4. Migre 2-3 sinais do `SignalBus` para usar o Mediator.
5. Registre handlers no `_ready()` dos sistemas interessados.

**Links úteis:**
- [Callable](https://docs.godotengine.org/en/stable/classes/class_callable.html)
- [Signals vs Mediator](https://docs.godotengine.org/en/stable/getting_started/step_by_step/signals.html)

**✅ Tasks:**
- [ ] Criar `GameMediator` autoload com `notify`, `register`, `unregister`
- [ ] Suportar múltiplos handlers por evento
- [ ] Migrar ao menos 3 comunicações do SignalBus para o Mediator
- [ ] Handler recebe `sender`, `event` e `data` tipados
- [ ] Testar que remover handler via `unregister` para de receber eventos

---

---

## #18 — [GOF COMPORTAMENTAL] Observer — Sistema de Conquistas

- **Estado:** closed
- **Responsável:** Pietrocv
- **Labels:** —
- **Link:** https://github.com/UnBArqDsw2026-1-Turma02/2026.1-T02_G1_MadDev_Entrega_03/issues/18

**Assignees:** @PhMoraiis, @Pietrocv

**Descrição:**
Implementar o padrão Observer para um sistema de conquistas (achievements). O `AchievementManager` observa eventos do jogo (inimigo derrotado, item coletado, sala completada) e desbloqueia conquistas quando condições são atingidas. Usa o SignalBus como mecanismo de notificação.

**🎓 Newbie Guide**

**O que é Observer?**
Quando um objeto muda de estado, notifica automaticamente todos os seus "ouvintes". Como uma newsletter: quem se inscreveu recebe a notificação — quem não se inscreveu, não recebe.

**Por onde começar:**
1. Veja `jogo/scripts/autoloads/signal_bus.gd` — os sinais já existentes são o mecanismo de notificação.
2. Pense em 3-5 conquistas que fazem sentido para o jogo (ex: "Primeiro Sangue", "Colecionador", "Sobrevivente").

**Passos:**
1. Crie `jogo/scripts/resources/achievement.gd` (Resource) com: `id: StringName`, `name: String`, `description: String`, `unlocked: bool`, `condition: Callable`.
2. Crie `jogo/scripts/autoloads/achievement_manager.gd` (autoload) que se conecta a sinais do `SignalBus`.
3. Quando um sinal chega, percorre a lista de conquistas e verifica `condition.call(data)`.
4. Se a condição for satisfeita e `unlocked == false`, emite `achievement_unlocked(achievement)` e marca como desbloqueada.
5. Adicione ao menos 5 conquistas com condições diferentes.

**Links úteis:**
- [Signals in GDScript](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_basics.html#signals)
- [Callable with arguments](https://docs.godotengine.org/en/stable/classes/class_callable.html)

**✅ Tasks:**
- [ ] Criar `Achievement` Resource com `id`, `name`, `description`, `unlocked`, `condition`
- [ ] `AchievementManager` conecta ao SignalBus no `_ready()`
- [ ] Verificação de condições é feita via `Callable` (sem switch/if por achievement)
- [ ] Implementar ao menos 5 conquistas concretas
- [ ] Emitir sinal `achievement_unlocked` ao desbloquear e exibir notificação na UI

---

---
