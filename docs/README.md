# Projeto MadDev

**Código da Disciplina**: FGA0208<br>
**Número do Grupo**: 01<br>
**Entrega**: 03<br>

## Alunos

| Matrícula | Aluno                                                           |
| --------- | --------------------------------------------------------------- |
| 202017343 | [Breno Lucena Cordeiro](https://github.com/BrenoLUCO)           |
| 211061716 | [Felipe Santos Veríssimo](https://github.com/verissimoo)        |
| 221022631 | [Kauã Richard de Souza Cavalcante](https://github.com/rich4rd1) |
| 190112093 | [Lucas Freire Lopes](https://github.com/AguionStryke)           |
| 202016963 | [Mateus Vinicius Vieira](https://github.com/matix0)             |
| 211062830 | [Philipe Barbosa de Morais](https://github.com/PhMoraiis)       |
| 232014754 | [Pietro Calegari Visentin](https://github.com/Pietrocv)         |
| 200062891 | [Vinicius Fernandes Rufino](https://github.com/RufinoVfR)       |


## Sobre

O **Projeto MadDev** é um jogo no estilo *dungeon crawler* / *roguelike* desenvolvido em **Godot 4** com **GDScript**, baseado em **Tiny Rogues** e adaptado ao contexto acadêmico da **FGA/FCTE** — o jogador encarna um estudante de Engenharia de Software tentando atravessar 12 salas mapeadas em espaços reais do campus, do saguão da UAC até a Banca de TCC.

Esta **Entrega 03** documenta o módulo de **Desenho de Software (Padrões de Projeto GoF)** aplicado ao jogo. O código-fonte vive na branch `game` do repositório; esta branch concentra a documentação dos padrões e dos artefatos da entrega.

### Padrões documentados nesta entrega

- **GoFs Criacionais (3.1):** [Builder](/PadroesDeProjeto/3.1.1.Builder.md), [Factory Method](/PadroesDeProjeto/3.1.2.FactoryMethod.md), [Multiton](/PadroesDeProjeto/3.1.3.Multiton.md), [Object Pool](/PadroesDeProjeto/3.1.4.ObjectPool.md), [Singleton](/PadroesDeProjeto/3.1.5.Singleton.md)
- **GoFs Estruturais (3.2):** [Decorator](/PadroesDeProjeto/3.2.1.Decorator.md), [Facade](/PadroesDeProjeto/3.2.2.Facade.md)
- **GoFs Comportamentais (3.3):** [Iterator](/PadroesDeProjeto/3.3.1.Iterator.md), [Mediator](/PadroesDeProjeto/3.3.2.Mediator.md), [Template Method](/PadroesDeProjeto/3.3.3.TemplateMethod.md)
- **Iniciativa Extra (3.5):** [Conceito Narrativo](/PadroesDeProjeto/3.5.1.ConceitoNarrativo.md) — premissa, cenário, personagens e significado narrativo dos elementos de gameplay

## Screenshots da Terceira Entrega

> *Adicionar screenshots dos artefatos da entrega (sidebar renderizado, páginas de padrão exibindo histórico de versionamento, código rodando no Godot, etc.)*

## Há algo a ser executado?

(x) SIM

( ) NÃO

A documentação é servida por **docsify** (instruções abaixo). O código do jogo é executado pela engine **Godot 4** e está disponível na branch `game` do repositório.


### Tecnologia

A geração do site estático é realizada utilizando o [docsify](https://docsify.js.org/).

```shell
"Docsify generates your documentation website on the fly. Unlike GitBook, it does not generate static html files. Instead, it smartly loads and parses your Markdown files and displays them as a website. To start using it, all you need to do is create an index.html and deploy it on GitHub Pages."
```

#### Instalando o docsify

Execute o comando:

```shell
npm i docsify-cli -g
```

#### Executando localmente

Para iniciar o site localmente, utilize o comando:

```shell
docsify serve ./docs
```

#### Testando localmente a conversao de .puml para .svg

Instale as dependencias necessarias no Linux (Ubuntu/Debian):

```shell
sudo apt-get install -y plantuml graphviz
```

Execute o script de teste local:

```shell
./scripts/test-puml-local.sh
```

## Histórico de Versionamento

| Nome                                                     | Alteração                                                                                            | Versão | Data       |
| -------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ------ | ---------- |
| [Mateus Vieira](https://github.com/matix0/)              | Setup inicial do projeto                                                                             | v0.1   | 13/04/2026 |
| [Mateus Vieira](https://github.com/matix0/)              | Adicionada ferramenta de conversão de Puml para Svg                                                  | v0.2   | 22/04/2026 |
| [Felipe Santos Veríssimo](https://github.com/verissimoo) | Atualização da Home para a Entrega 03 (Padrões de Projeto GoF) e organização da documentação        | v1.0   | 22/05/2026 |
