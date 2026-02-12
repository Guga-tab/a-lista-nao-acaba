extends Node

var id_usuario: int = -1
var id_avatar: int = -1

func carregar_ou_criar_usuario():
	var data = Database.fetch_one("""
        SELECT id_usuario, id_avatar, coins
        FROM USUARIO_AVATAR
        LIMIT 1
	""")

	if data:
		id_usuario = data["id_usuario"]
		id_avatar = data["id_avatar"]
		return

	Database.exec("""
        INSERT INTO USUARIO_AVATAR (id_usuario, id_avatar, coins, nivel_atual, xp_atual, estrelas)
        VALUES (1, 1, 0, 1, 0, 0)
	""")

	id_usuario = 1
	id_avatar = 1


func get_user_ids():
	return { "id_usuario": id_usuario, "id_avatar": id_avatar }


func adicionar_coins(qtd: int):
	Database.exec("""
        UPDATE USUARIO_AVATAR
        SET coins = coins + ?
        WHERE id_usuario = ? AND id_avatar = ?
	""", [qtd, id_usuario, id_avatar])


func get_coins() -> int:
	var data = Database.fetch_one("""
        SELECT coins
        FROM USUARIO_AVATAR
        WHERE id_usuario = ? AND id_avatar = ?
	""", [id_usuario, id_avatar])
	return data["coins"]
