# Padrão de Projeto: Multiton (Registry de Dificuldade)

## 📌 Visão Geral
Para evitar a criação desnecessária de múltiplos objetos na memória e garantir um ponto centralizado de configuração, implementamos o padrão **Multiton** (também conhecido como Registry). 

Enquanto o *Singleton* restringe uma classe a apenas uma única instância global, o *Multiton* gerencia um **dicionário de instâncias únicas nomeadas** (neste caso: `"easy"`, `"normal"` e `"hard"`).

---

## 🛠️ Como Utilizar no Código (Exemplos Práticos)

Qualquer script do jogo (como a IA de um inimigo ou um gerenciador de loot) pode acessar as modificações da dificuldade atual de forma estática, sem precisar caçar nós na árvore da cena (`get_node`).

### Exemplo 1: Aplicando vida a um Inimigo

extends CharacterBody2D

var max_health: float = 100.0

func _ready() -> void:
    # 1. Puxa a configuração do modo Hard de forma segura e tipada
    var config: DifficultyConfig = DifficultyRegistry.get_instance(&"hard")
    
    # 2. Aplica o modificador de vida da dificuldade
    max_health *= config.enemy_hp_modifier