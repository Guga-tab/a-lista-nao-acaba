PRAGMA foreign_keys = OFF;

CREATE TABLE roupa (
    roupa_PK INTEGER PRIMARY KEY,
    roupa TEXT
);

CREATE TABLE tipo (
    tipo_PK INTEGER PRIMARY KEY,
    tipo TEXT
);

CREATE TABLE USUARIO_AVATAR (
    id_usuario INTEGER,
    nivel_atual INTEGER,
    xp_atual INTEGER,
    coins INTEGER,
    estrelas INTEGER,
    ofensiva_individual INTEGER,
    avatar_id_FK_ INTEGER,
    nome TEXT,
    data_criacao_conta INTEGER,
    id_avatar INTEGER,
    acessorio TEXT,
    cor_pele TEXT,
    FK_roupa_roupa_PK INTEGER,
    cabelo TEXT,
    PRIMARY KEY (id_usuario, id_avatar),
    FOREIGN KEY (FK_roupa_roupa_PK) REFERENCES roupa(roupa_PK)
);

CREATE TABLE CASA_DECORACAO (
    id_casa INTEGER,
    id_decoracao INTEGER,
    ofensiva_geral INTEGER,
    nome_casa TEXT,
    estrelas_acumuladas INTEGER,
    id_dono INTEGER,
    data_criacao INTEGER,
    nome TEXT,
    FK_tipo_tipo_PK INTEGER,
    raridade TEXT,
    preco_estrelas INTEGER,
    descricao TEXT,
    PRIMARY KEY (id_casa, id_decoracao),
    FOREIGN KEY (FK_tipo_tipo_PK) REFERENCES tipo(tipo_PK)
);

CREATE TABLE COMODO (
    id__comodo INTEGER PRIMARY KEY,
    nome_comodo TEXT,
    id_casa INTEGER,
    FOREIGN KEY (id_casa) REFERENCES CASA_DECORACAO(id_casa)
);

CREATE TABLE TAREFA (
    id_tarefa INTEGER PRIMARY KEY,
    data_criacao INTEGER,
    xp_recompensa INTEGER,
    coins_recompensa INTEGER,
    titulo TEXT,
    id_comodo INTEGER,
    id_criador INTEGER,
    id_executante INTEGER,
    prazo INTEGER,
    descricao TEXT,
    pendente INTEGER,
    em_andamento INTEGER,
    concluida INTEGER,
    data_conclusao INTEGER,
    FK_USUARIO_AVATAR_id_usuario INTEGER,
    FK_USUARIO_AVATAR_id_avatar INTEGER,
    FOREIGN KEY (id_comodo) REFERENCES COMODO(id__comodo),
    FOREIGN KEY (FK_USUARIO_AVATAR_id_usuario, FK_USUARIO_AVATAR_id_avatar)
        REFERENCES USUARIO_AVATAR(id_usuario, id_avatar)
);

CREATE TABLE CONQUISTA (
    id_conquista INTEGER PRIMARY KEY,
    bonus_xp INTEGER,
    descricao TEXT,
    nome_conquista TEXT,
    criteiro TEXT,
    bonus_coins INTEGER,
    individual INTEGER,
    coletiva INTEGER
);

CREATE TABLE FASE (
    id_fase INTEGER PRIMARY KEY,
    nivel_dificuldade TEXT,
    tema_visual TEXT,
    numero_fase INTEGER,
    xp_minimo_para_desbloqueio INTEGER,
    FK_USUARIO_AVATAR_id_usuario INTEGER,
    FK_USUARIO_AVATAR_id_avatar INTEGER,
    FOREIGN KEY (FK_USUARIO_AVATAR_id_usuario, FK_USUARIO_AVATAR_id_avatar)
        REFERENCES USUARIO_AVATAR(id_usuario, id_avatar)
);

CREATE TABLE ITEM_COSMETICO (
    id_item INTEGER PRIMARY KEY,
    nome_item TEXT,
    tipo_item INTEGER,
    preco_coins INTEGER,
    descricao TEXT
);

CREATE TABLE AVATAR_ITEM_POSSUI (
    id_avatar_item INTEGER PRIMARY KEY,
    id_avatar_FK INTEGER,
    id_item_FK INTEGER,
    data_equipado INTEGER,
    sim INTEGER,
    nao INTEGER,
    FK_USUARIO_AVATAR_id_usuario INTEGER,
    FK_USUARIO_AVATAR_id_avatar INTEGER,
    FK_ITEM_COSMETICO_id_item INTEGER,
    FOREIGN KEY (FK_USUARIO_AVATAR_id_usuario, FK_USUARIO_AVATAR_id_avatar)
        REFERENCES USUARIO_AVATAR(id_usuario, id_avatar),
    FOREIGN KEY (FK_ITEM_COSMETICO_id_item)
        REFERENCES ITEM_COSMETICO(id_item)
);

CREATE TABLE COMODO_DECORACAO_APLICA (
    id_comodo_decoracao INTEGER PRIMARY KEY,
    id_comodo_FK INTEGER,
    id_decoracao_FK INTEGER,
    x INTEGER,
    y INTEGER,
    FK_CASA_DECORACAO_id_casa INTEGER,
    FK_CASA_DECORACAO_id_decoracao INTEGER,
    FOREIGN KEY (FK_CASA_DECORACAO_id_casa, FK_CASA_DECORACAO_id_decoracao)
        REFERENCES CASA_DECORACAO(id_casa, id_decoracao),
    FOREIGN KEY (id_comodo_FK)
        REFERENCES COMODO(id__comodo)
);

CREATE TABLE USUARIO_CONQUISTA_GANHA (
    id_usuario_conquista INTEGER PRIMARY KEY,
    id_usuario_fk INTEGER,
    id_conquista_fk INTEGER,
    data_obtencao INTEGER,
    sim INTEGER,
    nao INTEGER,
    FK_USUARIO_AVATAR_id_usuario INTEGER,
    FK_USUARIO_AVATAR_id_avatar INTEGER,
    FK_CONQUISTA_id_conquista INTEGER,
    FOREIGN KEY (FK_USUARIO_AVATAR_id_usuario, FK_USUARIO_AVATAR_id_avatar)
        REFERENCES USUARIO_AVATAR(id_usuario, id_avatar),
    FOREIGN KEY (FK_CONQUISTA_id_conquista)
        REFERENCES CONQUISTA(id_conquista)
);

CREATE TABLE PERTENCE (
    FK_USUARIO_AVATAR_id_usuario INTEGER,
    FK_USUARIO_AVATAR_id_avatar INTEGER,
    FK_CASA_DECORACAO_id_casa INTEGER,
    FK_CASA_DECORACAO_id_decoracao INTEGER,
    FOREIGN KEY (FK_USUARIO_AVATAR_id_usuario, FK_USUARIO_AVATAR_id_avatar)
        REFERENCES USUARIO_AVATAR(id_usuario, id_avatar)
        ON DELETE SET NULL,
    FOREIGN KEY (FK_CASA_DECORACAO_id_casa, FK_CASA_DECORACAO_id_decoracao)
        REFERENCES CASA_DECORACAO(id_casa, id_decoracao)
        ON DELETE SET NULL
);

PRAGMA foreign_keys = ON;
