class_name Map extends Node2D


func get_all_teleporations():
	return $Objects/Teleporations.get_children()


func get_teleporation(id: int) -> TeleporationPoint:
	for tele: TeleporationPoint in get_all_teleporations():
		if tele.id == id and not tele.is_default:
			return tele
	return null


func get_default_teleporation() -> TeleporationPoint:
	for tele: TeleporationPoint in get_all_teleporations():
		if tele.is_default:
			return tele
	return null
