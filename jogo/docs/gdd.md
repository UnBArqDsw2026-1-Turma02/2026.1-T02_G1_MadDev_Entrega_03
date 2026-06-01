**Projeto:** \[Nome do Jogo\] **Data:** Maio de 2026 **Equipe:** Mateus Vieira e equipe

---

## 1\. Visão Geral (Game Overview)

### 1.1. Resumo do Conceito

O jogo é um título de Ação e Exploração de Labirintos (estilo Roguelike focado em combate de arena) com temática universitária e tom de humor. O jogador assume o controle de um estudante que deve atravessar uma sequência de salas enfrentando inimigos inspirados no cotidiano acadêmico — provas, cadernos, tabelas de UML e outros pesadelos universitários. O núcleo do jogo gira em torno do combate, esquiva e gerenciamento contínuo de inventário para adaptar os atributos do personagem aos desafios encontrados.

A identidade visual e sonora do jogo deve reforçar esse universo temático: inimigos são representações caricatas de elementos da vida universitária, as armas são objetos do dia a dia escolar, e os tipos de personagem representam perfis estudantis reconhecíveis.

### 1.2. Características Principais

- **Gênero:** Ação, Sobrevivência, Roguelike  
    
- **Plataforma:** PC.  
    
- **Perspectiva:** Top-down (visão de cima), permitindo clara visualização do ambiente, inimigos e projéteis.  
    
- **Mecânica Central:** *Permadeath* (morte permanente). Se a vida do personagem chegar a zero, a tentativa atual termina, todos os itens e atributos ganhos são perdidos, e o jogador deve iniciar uma nova partida do zero.

---

## 2\. Mecânicas de Jogo (Core Gameplay)

### 2.1. Movimentação e Física

- O personagem se movimenta bidimensionalmente pelo cenário.  
    
- **Colisão:** O sistema impede que o jogador atravesse paredes, obstáculos sólidos e delimitações das salas.  
    
- **Esquiva (Dash):** Uma movimentação rápida que permite ao jogador desviar de ataques e projéteis inimigos. Possui as seguintes propriedades de design:  
    
  - **Cooldown:** Fixo, com valor base a definir na Tabela de Design. O cooldown é reduzível por atributos do personagem (campo "Redução de Cooldown de Dash" na Tabela de Atributos).  
  - **Uso:** Livre durante o cooldown — não possui custo de recurso adicional.  
  - **I-frames:** A presença de frames de invencibilidade durante o dash é a definir pela equipe durante a implementação.  
  - **Distância:** Valor a definir na Tabela de Design.

### 2.2. Sistema de Combate

- **Ataques do Jogador:** O sistema de ataque é unificado e baseado em projéteis. Todo ataque instancia um projétil — armas de longo alcance disparam projéteis convencionais, enquanto armas de curto alcance instanciam um projétil que percorre uma curta distância e retorna à mão do personagem, emulando o comportamento de ataque corpo a corpo.  
    
- **Ameaças (Inimigos):** Os inimigos perseguem, miram e atacam o jogador de forma autônoma. Eles possuem atributos independentes de Vida, Resistência e Dano. Além de disparar projéteis, **todos os inimigos causam dano de colisão ao tocar o jogador** — o valor desse dano é definido individualmente na Tabela de Inimigos (§7).

### 2.3. Sistema de Atributos e Progressão (In-Run)

Como o jogo não possui progressão permanente, tudo ocorre durante a partida:

- **Experiência (XP):** O jogador ganha **1 XP por recompensa de atributo obtida em sala**. O nível vai de 0 a 5 (máximo nível 5). Ao atingir o nível 5, XP adicional é descartado sem acumular.  
    
- **Fluxo de Level Up:** Ao atingir o XP necessário para subir de nível, **o jogo congela** (Time Scale \= 0\) e exibe uma tela de escolha. O jogador deve selecionar um dos três incrementos permanentes para a run atual:  
    
  - Incremento de **Dano**  
  - Incremento de **Vida Máxima**  
  - Incremento de **Velocidade**


  Os valores de cada incremento são definidos na Tabela de Atributos do Jogador (§7).


- **Modificadores de Atributos (Stats):** Ao ganhar níveis ou equipar itens específicos, o jogador recebe modificadores que afetam Vida Máxima, Dano, Velocidade, Cooldown de Dash, entre outros.

---

## 3\. Elementos do Jogo e Entidades

### 3.1. O Personagem (Player)

Entidade principal controlada pelo usuário. Possui um estado contínuo monitorado pelo sistema:

- **Vida e Cura:** Monitoramento de pontos de vida (HP). O jogador morre se o HP chegar a 0, mas pode recuperar HP utilizando poções.  
    
- **Inventário:** O personagem possui espaços limitados para guardar itens. O jogador deve gerenciar esses espaços, podendo descartar itens indesejados.

#### 3.1.1. Tipos de Personagem

O jogador escolhe um tipo de personagem antes de iniciar a run. Cada tipo possui **atributos base distintos** (HP, Dano e Velocidade), sem habilidades passivas — a diferenciação é puramente por atributos. Os quatro tipos disponíveis são:

| Tipo | Descrição temática | HP Base | Dano Base | Velocidade Base |
| :---- | :---- | :---- | :---- | :---- |
| **Calouro** | Estudante novato, equilibrado | A definir | A definir | A definir |
| **Veterano** | Estudante experiente | A definir | A definir | A definir |
| **Jubilado** | Estudante há anos na faculdade | A definir | A definir | A definir |
| **Cara da Atlética** | Estudante atleta | A definir | A definir | A definir |

Os valores de atributos base de cada tipo devem ser definidos pela equipe e registrados na Tabela de Atributos do Jogador (§7).

### 3.2. Os Inimigos

Gerados pelas regras da sala, cada inimigo obedece a comportamentos sistêmicos:

- **Padrões de Movimentação:** Algoritmos que definem como o inimigo se move (ex: seguir o jogador, mover-se aleatoriamente, manter distância).  
    
- **Padrões de Ataque:** Definição da cadência de tiro, área de efeito e dano base.  
    
- **Dano de Colisão:** Todos os inimigos causam dano ao tocar fisicamente o jogador. O valor é definido individualmente na Tabela de Inimigos (§7).  
    
- A quantidade e os tipos de inimigos são definidos dinamicamente de acordo com a dificuldade da sala.

#### Inimigos Disponíveis (Temática Universitária)

| Inimigo | Descrição |
| :---- | :---- |
| **Livro** | Inimigo básico de combate |
| **Caderno** | Inimigo básico de combate |
| **Provas** | Inimigo de dificuldade intermediária |
| **Tabelas de UML** | Inimigo de dificuldade intermediária |
| **Símbolos de Cálculo** | Inimigo de dificuldade elevada |
| **Boss** | Inimigo especial — ver §3.2.1 |

#### 3.2.1. Boss

O Boss é uma entidade especial que habita exclusivamente a **Sala 12** (sala final da run). Suas características:

- **Atributos escalados:** HP e Dano significativamente superiores aos inimigos comuns. Valores a definir na Tabela de Inimigos (§7).  
- **Padrão de ataque diferenciado:** Comportamento de ataque específico a definir pela equipe.  
- **Condição de vitória:** Derrotar o Boss encerra a run com **vitória**. O jogo exibe a tela de vitória e retorna ao Menu Principal.

### 3.3. Equipamentos (Equipáveis)

Itens que o jogador veste/empunha para receber modificadores contínuos. O sistema de equipamentos é organizado em **5 slots**, cada um comportando **1 item simultâneo**:

| Slot | Tipo de item |
| :---- | :---- |
| **Cabeça** | Armadura de cabeça |
| **Tronco** | Armadura de tronco |
| **Perna** | Armadura de perna |
| **Pé** | Armadura de pé |
| **Acessório** | Acessório (1 por vez) |

Armas são gerenciadas separadamente do sistema de slots de armadura (ver abaixo).

- **Armas:** Todo ataque do jogador é baseado em projéteis. Armas de longo alcance disparam projéteis convencionais; armas de curto alcance instanciam um projétil que vai e volta da mão do personagem. A arma equipada determina o dano base e o comportamento do projétil. Armas disponíveis (temática universitária): **Lápis, Caneta, Régua, Baralho, Bola, Guarda-chuva**.  
    
- **Armaduras (slots Cabeça, Tronco, Perna, Pé):** Aumentam a resistência ou reduzem o dano recebido.  
    
- **Acessórios (slot Acessório):** Fornecem buffs específicos aos atributos do jogador.

### 3.4. Itens Consumíveis

Os consumíveis se dividem em duas categorias com comportamentos distintos:

#### Itens Utilitários Fixos

Possuem **slots permanentes** no inventário do jogador. Iniciam em 0 no começo de cada run e podem ser acumulados ao longo da partida. São três tipos:

- **Bombas:** Usadas para causar dano explosivo em área ou quebrar obstáculos.  
- **Chaves:** Usadas para destravar portas bloqueadas, baús ou passagens secretas.  
- **Poções:** Consumidas para restaurar pontos de vida imediatamente.

#### Consumíveis de Benefício

Itens que concedem um efeito (temporário ou permanente para a run) e são descartados imediatamente após o uso. O jogador pode carregar **no máximo 1 consumível de benefício por vez** — coletar um novo substitui o anterior. Os efeitos específicos de cada consumível de benefício são a definir pela equipe.

---

## 4\. O Mundo do Jogo e Níveis

### 4.1. Geração de Salas

O mapa é estabelecido como salas de tamanho fixo com variação na sua geração, podendo alterar sprites, tipos de inimigos e tipos de recompensas. Toda sala contém pelo menos duas portas para o jogador escolher qual a próxima sala que irá visitar (com exceção da Sala 11, que terá apenas uma porta levando ao Boss).

O jogador não pode sair da sala atual enquanto houver inimigos vivos — as portas ficam bloqueadas até que todos os inimigos sejam derrotados.

### 4.2. Tipos de Sala

As salas das corridas (Salas 2 a 10\) são geradas aleatoriamente a partir dos seguintes tipos:

| Tipo | Descrição |
| :---- | :---- |
| **Combate** | Sala padrão com inimigos. O jogador não pode avançar enquanto houver inimigos vivos. |
| **Armadilha** | Sala com quantidade elevada de inimigos. Variante mais difícil da sala de combate. |
| **Baú — Armas** | Sala segura com baú contendo uma arma. Nenhum inimigo presente. |
| **Baú — Equipamentos** | Sala segura com baú contendo um equipável (armadura ou acessório). Nenhum inimigo presente. |
| **Baú — Consumíveis** | Sala segura com baú contendo um consumível (utilitário fixo ou de benefício). Nenhum inimigo presente. |
| **Sala Segura** | Sala sem inimigos que restaura uma quantidade de HP do jogador ao ser visitada. |

### 4.3. Portas e Obstáculos

As portas que conectam salas podem ter três estados:

| Estado | Descrição | Item necessário |
| :---- | :---- | :---- |
| **Aberta** | Porta transitável livremente. | Nenhum |
| **Trancada** | Porta bloqueada por uma fechadura. | 1 Chave |
| **Bloqueada por Rocha** | Porta obstruída por uma rocha. | 1 Bomba |

#### Regra Anti-Softblock

**O jogador nunca pode ficar sem caminho disponível para avançar.** O gerador de salas garante que, em toda sala com múltiplas portas de saída, **pelo menos 1 porta esteja sempre no estado Aberta**. Portas Trancadas e Bloqueadas por Rocha são sempre opcionais — representam rotas alternativas com recompensas extras, nunca o único caminho possível.

### 4.4. Estrutura da Run

Cada run é composta por **12 salas fixas** dispostas na seguinte sequência obrigatória:

| Sala | Tipo | Portas | Descrição |
| :---- | :---- | :---- | :---- |
| 1 | Inicial | 2 abertas | Sempre vazia. O jogador escolhe por qual porta entrar para iniciar o desafio. |
| 2 a 10 | Variável (ver §4.2) | Mínimo 2 (ao menos 1 aberta) | Salas com conteúdo variado gerado aleatoriamente. |
| 11 | Pré-Boss | 1 aberta | Sala antes do boss. Apenas uma porta de saída (para a Sala 12). |
| 12 | Boss | — | Sala do Boss. Derrotar o Boss encerra a run com vitória. |

A sequência é sempre linear: o jogador avança da Sala 1 à Sala 12\. A variação ocorre no tipo de sala, conteúdo e layout — nunca na ordem estrutural.

---

## 5\. Interface de Usuário (UI) e Controles

### 5.1. Telas e Menus

- **Menu Principal:** Tela de entrada com opções para Iniciar Jogo e Sair. Deve conter ambientação visual e musical própria.  
    
- **HUD (Heads-Up Display) durante a partida:** Exibe em tempo real: pontos de vida do jogador, arma atual equipada, quantidade de itens utilitários fixos (bombas, poções e chaves) e o consumível de benefício atualmente carregado.  
    
- **Menu de Inventário:** Interface acionada pelo jogador para equipar armaduras, trocar armas e descartar itens.  
    
- **Menu de Pausa:** Interrompe a lógica de tempo do jogo (Time Scale \= 0), permitindo ajustes ou abandono da partida.  
    
- **Menu de Fim de Jogo (Game Over / Vitória):** Exibe o resultado da tentativa e permite retornar ao Menu Principal.

---

## 6\. Estética: Áudio e Arte

Para garantir acessibilidade e clareza (Requisitos Não Funcionais), a direção de arte e som deve seguir diretrizes rigorosas de *feedback* ao usuário.

### 6.1. Identidade Visual

- **Sprites 2D Clientes:** Personagem, inimigos e itens devem ser facilmente distinguíveis entre si. A paleta de cores deve separar o que é ameaça (inimigos/projéteis) do que é recompensa (itens).  
    
- **Cenário:** O ambiente deve ser visualmente claro, deixando óbvio para o jogador quais partes do chão são caminháveis e quais são paredes (colisão).

### 6.2. Efeitos Sonoros (SFX)

Feedback em áudio é obrigatório para as seguintes ações:

- Ataques e movimentação do jogador.  
    
- Recebimento de dano e som de morte do jogador.  
    
- Ataques de inimigos (aviso sonoro antes do disparo) e morte de inimigos.  
    
- Uso de itens (poções, bombas) e navegação pelos menus.

### 6.3. Trilha Sonora

Músicas contextuais desenvolvidas para: Tema Principal (Menu), Música de Combate/Exploração, Tema de Vitória e Tema de Derrota.

---

## 7\. Arquitetura de Dados (Tabelas de Design)

Para que o jogo seja facilmente balanceável e expansível, todos os números do jogo não devem estar fixos no código, mas sim lidos a partir de **Tabelas de Design**.

### Tabela de Atributos do Jogador

| Campo | Descrição |
| :---- | :---- |
| Tipo de Personagem | Calouro / Veterano / Jubilado / Cara da Atlética |
| HP Base | Valor inicial de pontos de vida |
| Dano Base | Valor base de dano do projétil |
| Velocidade Base | Velocidade de movimentação base |
| Cooldown de Dash Base | Tempo base (em segundos) entre usos do dash |
| Redução de Cooldown de Dash | Modificador de atributo que reduz o cooldown do dash |
| XP por Nível | Fixo: 1 XP por recompensa de atributo de sala |
| Nível Máximo | 5 |
| Incremento de Dano por Nível | Valor adicionado ao Dano Base a cada level up (escolha do jogador) |
| Incremento de Vida por Nível | Valor adicionado ao HP Máximo a cada level up (escolha do jogador) |
| Incremento de Velocidade por Nível | Valor adicionado à Velocidade a cada level up (escolha do jogador) |

### Tabela de Inimigos

| Campo | Descrição |
| :---- | :---- |
| ID | Identificador único do inimigo |
| Nome | Nome temático (ex: Livro, Caderno, Provas) |
| HP Base | Pontos de vida do inimigo |
| Dano Base (Projétil) | Dano causado pelo projétil disparado |
| Dano de Colisão | Dano causado ao tocar fisicamente o jogador |
| Velocidade | Velocidade de movimentação |
| Tipo de Comportamento | Padrão de IA: perseguir / manter distância / aleatório |
| É Boss | Booleano — indica se é o inimigo especial da Sala 12 |

### Tabela de Itens e Armas

| Campo | Descrição |
| :---- | :---- |
| ID | Identificador único do item |
| Nome | Nome temático (ex: Lápis, Caneta, Régua) |
| Tipo | Utilitário Fixo / Consumível de Benefício / Equipável / Arma |
| Slot | cabeça / tronco / perna / pé / acessório / arma / nenhum |
| Efeito / Valor | Descrição do efeito e valor numérico associado |
| Modificadores de Stats | Atributos afetados e delta (ex: \+10 HP, \+5 Dano) |
