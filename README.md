# 🧩 A Lista Não Acaba  

**A Lista Não Acaba** é um sistema desenvolvido em **Godot Engine** que utiliza elementos de
**gamificação** para incentivar e auxiliar na organização e execução de atividades, especialmente por pessoas
com **Transtorno de Déficit de Atenção** no geral.



## 🎯 Visão Geral

O sistema permite que os usuários criem, gerenciem e concluam tarefas, recebendo recompensas como moedas e conquistas a cada progresso realizado. 

Com uma abordagem inspirada em jogos, o aplicativo incentiva a consistência por meio de sistemas de progressão, personalização de avatar e evolução de ambientes virtuais, tornando a rotina mais dinâmica, motivadora e envolvente.



## 🛠️ Tecnologias Utilizadas

- **Godot Engine** (projeto `.godot`/`.tscn`)  
- **GDScript** (lógica do jogo)  
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

  3. Rode a cena principal (`principal.tscn` ou `control.tscn`, conforme configurado como Main Scene).

### 3. Passos para rodar no Celular (Android)
  
  1. Exporte o projeto para Android APK
  2. Instale o .apk
  3. Aproveite!

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