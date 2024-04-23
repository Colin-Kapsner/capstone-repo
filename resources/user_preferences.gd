class_name UserPreferences extends Resource



@export var user_token := ""





func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")


static func load_or_create() -> UserPreferences:
	var res
	if FileAccess.file_exists("user://user_prefs.tres"):
		res = load("user://user_prefs.tres") as UserPreferences
	else:
		res = UserPreferences.new()
	return res
