extends Resource
class_name RR
var _user_path: String

func _init():
	_user_path = get_user_path()

	# If the resource exists in user://, reload it and update the values
	if FileAccess.file_exists(_user_path):
		var new_resource = ResourceLoader.load(_user_path)
		if new_resource:
			copy_data_from(new_resource)
	else:
		# If it doesn't exist in user://, ensure it's saved there
		ensure_writable()

func get_user_path() -> String:
	if resource_path.begins_with("res://"):
		return "user://" + resource_path.substr(6)
	return resource_path

func ensure_writable():
	if not resource_path or resource_path.begins_with("user://"):
		return

	var user_path = get_user_path()

	if FileAccess.file_exists(user_path):
		resource_path = user_path
		return
	
	# Duplicate and save to user:// if not already in user://
	var new_resource = self.duplicate(true)
	ResourceSaver.save(new_resource, user_path)
	resource_path = user_path

func copy_data_from(new_resource: Resource) -> void:
	# Manually copy the properties from the new_resource to the current instance
	# Assuming you know which properties you want to copy
	# For example, if you have a property called "some_property", you can do:
	self.some_property = new_resource.some_property
	# Repeat for other properties if necessary
