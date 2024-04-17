class_name UserPreferences extends Resource


@export var username := ""
@export var user_token := ""





func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")


static func load_or_create() -> UserPreferences:
	var res: UserPreferences = load("user://user_prefs.tres") as UserPreferences
	if !res:
		res = UserPreferences.new()
	return res
