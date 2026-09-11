@tool
extends Container

@onready var but_change_skill: Button = $HBoxContainer/Button
@onready var magic_text: Label = $HBoxContainer2/Magic_name
@onready var element_text: Label = $HBoxContainer3/Element_text
@onready var type_name: Label = $HBoxContainer4/Type_name
@onready var create_button: Button = $Create_Button
var actual_skill: int = -1
var skills_slot: Array = [
	{"Name": "Fireball", "Element": "Fire", "Type": "Projectile"},
	{"Name": "Waterball", "Element": "Water", "Type": "Projectile"},
	{"Name": "Energy bolt", "Element": "Eletric", "Type": "Projectile"},
	{"Name": "Ice Arrow", "Element": "Ice", "Type": "Projectile"},
	{"Name": "Rock Throw", "Element": "Ground", "Type": "Projectile"},
	{"Name": "Magic missel", "Element": "Common", "Type": "Projectile"},
	{"Name": "Flash", "Element": "Light", "Type": "Projectile"},
	{"Name": "Dark globe", "Element": "Darkness", "Type": "Projectile"},
]
var _current_name_magic: String = ""
var _current_name_element: String = ""
var _current_name_type: String = ""

func _ready() -> void:
	if not Engine.is_editor_hint():
		return
	but_change_skill.text = "Change Preset"
	create_button.text = "Create The Magic"

func _change_skill(indice: int):
	var skill = skills_slot[indice]
	magic_text.text = skill["Name"]
	element_text.text = skill["Element"]
	type_name.text = skill["Type"]
	_current_name_magic = magic_text.text
	_current_name_element = element_text.text
	_current_name_type = type_name.text

func _on_button_pressed() -> void:
	actual_skill += 1
	print("atual: ", actual_skill)
	if actual_skill < skills_slot.size():
		_change_skill(actual_skill)
	elif actual_skill >= skills_slot.size():
		actual_skill = 0
		_change_skill(actual_skill)

func _on_create_folder_pressed() -> void:
	var folders_path = "res://assets/Skills/Codes"
	var dir = DirAccess.open("res://")
	if not DirAccess.dir_exists_absolute(folders_path):
		var err = dir.make_dir_recursive(folders_path)
		if err == OK:
			print("Success to create the folders: ", folders_path)
			print("Press Alt+Tab to view the folder")
		else:
			push_error("Error when create the folders: %s" % err)
	else:
		print("Folders already exist: ", folders_path)
