@tool
extends Button

func _ready() -> void:
	print("Script carregado:", self.name)

func _on_pressed() -> void:
	var _tool_menu = get_parent()
	var _magic_name = _tool_menu._current_name_magic
	var _element_name = _tool_menu._current_name_element
	var _type_name = _tool_menu._current_name_type
	var _base_code = FileAccess.get_file_as_string("res://addons/Magic_Builder/Basics_scripts/Basic_projectile_magic.gd")
	_base_code = _base_code.replace('var element = "NONE"', 'var element = "%s"' % _element_name)
	_base_code = _base_code.replace('var type = "NONE"', 'var type = "%s"' % _type_name)
	
	var _node2D = Node2D.new()
	_node2D.name = _magic_name
	
	var _area2D = Area2D.new()
	_area2D.name = "HitBox"
	
	var _collision = CollisionShape2D.new()
	_collision.name = "Collision"
	_collision.shape = RectangleShape2D.new()
	
	var _anim = AnimationPlayer.new()
	_anim.name = "AnimationPlayer"
	
	var _sprite = Sprite2D.new()
	_sprite.name = "Sprite2D"
	
	_area2D.add_child(_collision)
	print("childs: ", _area2D.get_child_count())
	
	_node2D.add_child(_area2D)
	_node2D.add_child(_sprite)
	_node2D.add_child(_anim)
	print("childs of node: ", _node2D.get_child_count())
	
	
	var _script = GDScript.new()
	_script.source_code = _base_code
	_script.reload()
	var _save_path_code = "res://assets/Skills/Codes/%s.gd" % _magic_name
	ResourceSaver.save(_script, _save_path_code)
	_node2D.set_script(load(_save_path_code))
	
	_area2D.owner = _node2D
	_collision.owner = _node2D
	_anim.owner = _node2D
	_sprite.owner = _node2D
	#_area2D.connect("body_entered", Callable(_node2D, "_on_hit_box_body_entered"))
	
	var _scene = PackedScene.new()
	_scene.pack(_node2D)
	
	var _save_path_scene = "res://assets/Skills/%s.tscn" % _magic_name
	var err = ResourceSaver.save(_scene, _save_path_scene)
	
	if err != OK:
		push_error("Erro ao salvar: %s" % err)
	else:
		print("Cena salva com sucesso em: ", _save_path_scene)
