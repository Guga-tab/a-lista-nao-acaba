extends Node

var user_id: int = -1
var avatar_id: int = -1

func load_or_create_user():
	# return a dictionary
	var data = Database.fetch_one("
        SELECT id_usuario, id_avatar, coins
        FROM USUARIO_AVATAR
        LIMIT 1
	")

	if data:
		user_id = data["id_usuario"]
		avatar_id = data["id_avatar"]
		return
		
	Database.exec("
        INSERT INTO USUARIO_AVATAR (id_usuario, id_avatar, coins, nivel_atual, xp_atual, estrelas)
        VALUES (1, 1, 0, 1, 0, 0)
	")

	user_id = 1
	avatar_id = 1

func get_user_ids():
	return { "user_id": user_id, "avatar_id": avatar_id }

func add_coins(qtd: int) -> void:
	Database.exec("
        UPDATE USUARIO_AVATAR
        SET coins = coins + ? 
        WHERE id_usuario = ? AND id_avatar = ?
	", [qtd, user_id, avatar_id])

func get_coins() -> int:
	var data = Database.fetch_one("
        SELECT coins
        FROM USUARIO_AVATAR
        WHERE id_usuario = ? AND id_avatar = ?
	", [user_id, avatar_id])
	return data["coins"]
