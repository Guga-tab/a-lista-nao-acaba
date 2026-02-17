````markdown
# 🧩 A Lista Não Acaba  
_Sistema de gamificação para tarefas domésticas_

> Protótipo de jogo eletrônico que transforma tarefas domésticas em uma experiência gamificada,
com foco em motivação, organização e participação familiar

---

## 🎯 Visão Geral

**A Lista Não Acaba** é um jogo desenvolvido em **Godot Engine** que utiliza elementos de
**gamificação** para incentivar a realização de tarefas domésticas, especialmente por pessoas
com **Transtorno de Déficit de Atenção no geral**.

O projeto faz parte do **Trabalho de Conclusão de Curso (TCC)** do curso de
**Tecnologia em Análise e Desenvolvimento de Sistemas** da **Fatec Praia Grande**.

---

## 🧠 Motivação

Muitas pessoas enfrentam desafios como:

Dificuldade em manter o foco em tarefas rotineiras;
Problemas de organização e gestão do tempo;
Tendência à procrastinação;
Desmotivação diante de atividades pouco atrativas.

A proposta do sistema é utilizar mecânicas de jogos (pontuação, recompensas, progressão, avatares e personalização de ambientes) para:

Tornar as tarefas domésticas mais atrativas;
Facilitar a organização pessoal e familiar;
Incentivar a conclusão consistente de atividades;
Reforçar comportamentos produtivos de forma lúdica.

---

## ✅ Requisitos de Domínio

O sistema foi pensado para:

> **Estimular a realização de tarefas domésticas** por meio de uma interface lúdica e mecânicas de jogo,
promovendo organização, engajamento e conclusão das atividades por todos os membros da família.

---

## 🛠️ Tecnologias Utilizadas

- **Godot Engine** (projeto `.godot`/`.tscn`)  
- **GDScript** (lógica do jogo)  
- **SQLite** via plugin  
  - `addons/godot-sqlite`  
- **Banco de dados local**  
  - Arquivos:  
    - `database/A-tarefa-nao-acaba.db`  
    - `database/A-tarefa-nao-acaba-fisico.sql`  
- **Pixel Art e UI**  
  - Assets em `Assets_GODOT/Assets_GODOT`  
  - Fonte **Pixelify Sans** em `Assets_GODOT/Assets_GODOT/fontes/Pixelify_Sans`

---

## 🗂️ Estrutura do Repositório

```text
a-lista-nao-acaba
├── addons/
│   └── godot-sqlite/        # Plugin de integração com SQLite
├── Assets_GODOT/
│   └── Assets_GODOT/
│       ├── Backgrounds/     # Planos de fundo e molduras
│       ├── Buttons/         # Botões da UI
│       ├── fontes/          # Fontes (Pixelify Sans + licenças)
│       ├── Fonts/           # Elementos gráficos com numeração e barras
│       └── Icons/           # Ícones (calendário, bandeira, estrela, moeda etc.)
├── database/
│   ├── A-tarefa-nao-acaba.db          # Banco de dados SQLite
│   └── A-tarefa-nao-acaba-fisico.sql  # Script SQL de criação/estrutura
├── button.gd / button.gdshader        # Lógica e shader de botões
├── control.gd / control.tscn          # Cena e script de UI principal
├── principal.gd / principal.tscn      # Cena principal do jogo
├── Database.gd                        # Acesso ao banco de dados
├── TarefaService.gd                   # Lógica de tarefas
├── UserService.gd                     # Lógica de usuários/jogadores
├── project.godot                      # Arquivo principal do projeto Godot
└── README.md                          # Este arquivo
````

---

## ▶️ Como Executar o Projeto

### 1. Pré-requisitos

* **Godot Engine** instalado
* Ambiente com suporte a **GDScript**
* (Opcional) Ambiente Android configurado para exportar APK

### 2. Passos para rodar no desktop

1. Clone o repositório:

   ```bash
   git clone https://github.com/<seu-usuario>/a-lista-nao-acaba.git
   cd a-lista-nao-acaba
   ```

2. Abra o projeto no **Godot** usando o arquivo `project.godot`.

3. Verifique se o plugin **godot-sqlite** está habilitado:

   * `Project > Project Settings > Plugins`
   * Ative **godot-sqlite** se necessário.

4. Rode a cena principal (`principal.tscn` ou `control.tscn`, conforme configurado como Main Scene).

## 🧩 Arquitetura Lógica

Alguns dos scripts principais:

* **`Database.gd`**
  Responsável pela comunicação com o banco SQLite (conexão, consultas, inserts/updates).

* **`TarefaService.gd`**
  Camada de serviço para lidar com cadastro, atualização, conclusão e consulta de tarefas.

* **`UserService.gd`**
  Gerencia dados do usuário: progresso, moedas, estrelas, níveis, etc.

* **`control.gd` / `principal.gd`**
  Controlam a lógica visual e fluxo entre telas (ex.: tela principal, listas de tarefas, pop-ups).

---

## 🎓 Contexto Acadêmico

Este projeto está vinculado ao **Trabalho de Conclusão de Curso (TCC)**:

* **Instituição:** Centro Estadual de Educação Tecnológica Paula Souza – Fatec Praia Grande
* **Curso:** Tecnologia em Análise e Desenvolvimento de Sistemas
* **Título do Trabalho:** *Sistema de Gamificação para Tarefas Domésticas: A lista não acaba!*
* **Autores:**

  * Gustavo Machado dos Santos
  * Gustavo de Souza Carlos
  * Roberto Neiva Corvino
* **Orientador:** Prof. Bruno Baruffi Esteves
* **Ano:** 2025

O relatório técnico aborda:

* Conceitos de procrastinação e desinteresse por tarefas cotidianas
* Gamificação como estratégia para aumentar foco e motivação
* Metodologia de pesquisa aplicada, com abordagem qualitativa exploratória, composta por revisão bibliográfica e aplicação de questionário com participantes.
* Proposição e desenvolvimento de um protótipo de aplicativo móvel gamificado

---

## 🧭 Roadmap (Ideias Futuras)

* Hub social familiar mais completo (rankings, desafios em grupo)
* Mais opções de **cosméticos** e **decoração de ambientes**
* Mecanismos mais avançados de dificuldade adaptativa
* Melhorias de acessibilidade específicas para pessoas com déficit de atenção (ex.: timers visuais, modos de foco)
* Sistema de notificações integrado com Android


## 📩 Contato

Para dúvidas, sugestões ou colaborações relacionadas ao projeto/TCC, entre em contato
com os autores via canais pessoais/academicamente combinados (e-mails institucionais ou GitHub dos autores).

---

> *“Eles oferecem recompensas que a realidade não consegue dar. Eles nos ensinam, nos inspiram e nos envolvem.”*
> — Jane McGonigal, 2012

```
```
