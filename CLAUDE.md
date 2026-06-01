# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Academic project (disciplina de Arquitetura de Software, Entrega 03). A roguelike/dungeon-crawler built in **Godot 4.6** (GDScript, GL Compatibility renderer). The grade depends on demonstrably implementing the **23 GoF design patterns** inside a working game, so the architecture is deliberately pattern-heavy and each pattern's purpose matters as much as the gameplay.

The Godot project lives in [jogo/](jogo/) — `project.godot` is at `jogo/project.godot`, not the repo root. Game design doc and backlog are in [jogo/docs/](jogo/docs/).

## Running and testing

There is **no CLI test runner and no CI** — Godot is not assumed to be on `PATH`. Everything runs through the editor:

- **Run the game:** open `jogo/project.godot` in Godot 4.6, press Play. Main scene is `res://scenes/ui/main_menu.tscn`.
- **Run a pattern test:** open the relevant standalone test scene/script and press **F6** (run current scene). Tests are plain scripts that print to the console and `assert()` expected values — see [jogo/scenes/test_patterns.gd](jogo/scenes/test_patterns.gd), `test_builder.gd`, `test_facade.gd`, `test_pool.gd`, `test_multiton.gd`, `test_template_method.gd`. There is no test framework; a test "passes" when its asserts don't trip and the printed output matches the commented expectations.
- **`@tool` testers:** some systems are validated in-editor via exported "fake button" booleans — e.g. [jogo/scripts/damage_tester.gd](jogo/scripts/damage_tester.gd) recomputes the damage chain when you toggle a checkbox in the Inspector. Build the Resource chain in the Inspector before toggling.

## Communication architecture (the core rule)

Domain nodes must **not** connect signals directly to nodes in another domain. All cross-system communication flows through a fixed chain:

```
gameplay code  →  GameFacade  →  SignalBus  →  listeners
```

- **[GameFacade](jogo/scripts/autoloads/game_facade.gd)** (Facade) — the only entry point gameplay code should call. Wraps Audio/Game/event subsystems and exposes simple verbs (`start_run`, `kill_player`, `award_points_with_sound`). Prefer adding a Facade method over calling other autoloads directly.
- **[SignalBus](jogo/scripts/autoloads/signal_bus.gd)** (Mediator/Observer) — the single event hub: the declared `signal` catalog for the whole game. Listeners `SignalBus.some_signal.connect(...)`; emitters `SignalBus.some_signal.emit(...)`. There is no separate mediator autoload — emit directly on the bus.
- **[GameManager](jogo/scripts/autoloads/game_manager.gd)** (Singleton) — owns volatile run state (`current_state`, room index, score, level/xp) and the run lifecycle. Permadeath: `reset_run()` wipes all run state; other systems should listen for `run_ended` and clear themselves.

Autoload load order is defined in `[autoload]` in `project.godot` and matters (SignalBus → GameManager → AudioManager → GameFacade → AchievementManager).

## Where the patterns live

Scripts are grouped by responsibility under [jogo/scripts/](jogo/scripts/), and **every pattern file's header docstring names the GoF pattern it implements** (in Portuguese). Keep that convention when adding files. Notable ones:

- **Chain of Responsibility** — [scripts/damage/](jogo/scripts/damage/): `DamageHandler` base `Resource` with an `@export var next`; `armor_handler`/`resistance_handler`/`health_handler` link in the Inspector and pass a `context` dict down the chain.
- **Builder + Director** — [scripts/world/](jogo/scripts/world/): `RoomBuilderBase` (abstract, fluent, returns `self`), `RoomBuilder` (concrete), `RoomDirector` holds a builder and exposes room recipes (`build_combat_room`, `build_boss_room`, …). `GameManager.load_room()` wires them together.
- **Factory Method** — [scripts/enemies/](jogo/scripts/enemies/): `EnemyFactory.create(type)` ([enemy_factory.gd](jogo/scripts/enemies/enemy_factory.gd)) is the single enemy-creation source — its `_SCENES` map is the only type→scene mapping. Both `RoomBuilder` and the `EnemySpawner` node hierarchy (`basic_enemy_spawner`/`ranged_enemy_spawner`) delegate to it; don't reintroduce ad-hoc `load(...).instantiate()` for enemies.
- **Decorator** — [scripts/items/decorators/](jogo/scripts/items/decorators/): `ItemDecorator extends ItemBase` wraps another `ItemBase` in `wrapped` and stacks `get_effect()`/`get_value()` via `super`.
- **Iterator** — [scripts/iterators/](jogo/scripts/iterators/): implements GDScript's native `_iter_init`/`_iter_next`/`_iter_get` protocol so instances work in `for x in iterator`.
- **Multiton** — [scripts/resources/student_profile_registry.gd](jogo/scripts/resources/student_profile_registry.gd) keyed registry of student-class `.tres` profiles in [jogo/resources/profiles/](jogo/resources/profiles/).
- **Object Pool / Bridge** — [scripts/world/projectile_pool.gd](jogo/scripts/world/projectile_pool.gd), [scripts/projectiles/](jogo/scripts/projectiles/).
- **Composite / Abstract Factory** — HUD and UI renderers in [scripts/ui/](jogo/scripts/ui/) (`hud_abstraction.gd`, `renderers/`).

When adding or changing gameplay code, identify which GoF pattern(s) it serves and follow the existing file's structure; don't collapse a pattern into a shortcut just because it's shorter.

## GDScript conventions

- **Statically typed** throughout — annotate variables, params, and return types (`func handle(damage: int, context: Dictionary) -> int:`). Match the surrounding strictness.
- **Tabs** for indentation (Godot default).
- Comments and docstrings are in **Portuguese**; keep new ones in Portuguese to match.
- Use `StringName` (`&"basic"`) for type/event keys, as the existing event and enemy-type code does.
- Pattern files carry a header docstring (`## Padrão X — …`) explaining the pattern and any usage rule (e.g. "connect via inspector, not code"). Preserve and replicate this.

## Input & physics reference

- Input actions: `move_up`/`down`/`left`/`right` (WASD), `dash` (Space), `shoot` (left mouse).
- Collision layers: 1=player, 2=walls, 3=enemies, 4=projectiles, 5=items. Top-down, gravity 0.
- Viewport 320×180, window 1280×720, `canvas_items` stretch (pixel-art).
