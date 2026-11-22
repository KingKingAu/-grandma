extends Control

@export var seedboth_contain: HBoxContainer
@export var seed1_contain: HBoxContainer
@export var seed2_contain: HBoxContainer

@export var custom_time: LineEdit
var custom_old := ""

@export var seedboth_lineedit: LineEdit
var seedboth_old := ""
@export var seed1_lineedit: LineEdit
var seed1_old := ""
@export var seed2_lineedit: LineEdit
var seed2_old := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_randomiseboth_pressed()
	_on_randomise1_pressed()
	_on_randomise2_pressed()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		for lineedit in [custom_time, seedboth_lineedit, seed1_lineedit, seed2_lineedit]:
			if lineedit.has_focus() and !custom_time.get_global_rect().has_point(event.global_position):
				lineedit.release_focus()

func _on_split_toggled(toggled_on: bool) -> void:
	seedboth_contain.visible = !toggled_on
	seed1_contain.visible = toggled_on
	seed2_contain.visible = toggled_on
	Autoload.split_seed = toggled_on

func _on_seedboth_text_changed(new_text: String) -> void:
	if new_text.is_empty() or new_text.is_valid_int():
		seedboth_old = seedboth_lineedit.text
		seedboth_lineedit.text = new_text
	else:
		seedboth_lineedit.text = seedboth_old
	seedboth_lineedit.caret_column = seedboth_lineedit.text.length()
	Autoload.seed = seedboth_lineedit.text
	Autoload.seed2 = seedboth_lineedit.text

func _on_seed1_text_changed(new_text: String) -> void:
	if new_text.is_empty() or new_text.is_valid_int():
		seed1_old = seed1_lineedit.text
		seed1_lineedit.text = new_text
	else:
		seed1_lineedit.text = seed1_old
	seed1_lineedit.caret_column = seed1_lineedit.text.length()
	Autoload.seed = seed1_lineedit.text

func _on_seed2_text_changed(new_text: String) -> void:
	if new_text.is_empty() or new_text.is_valid_int():
		seed2_old = seed2_lineedit.text
		seed2_lineedit.text = new_text
	else:
		seed2_lineedit.text = seed2_old
	seed2_lineedit.caret_column = seed2_lineedit.text.length()
	Autoload.seed2 = seed2_lineedit.text


func _on_randomiseboth_pressed() -> void:
	_on_seedboth_text_changed(str(randi_range(0, 99999)))

func _on_randomise1_pressed() -> void:
	_on_seed1_text_changed(str(randi_range(0, 99999)))

func _on_randomise2_pressed() -> void:
	_on_seed2_text_changed(str(randi_range(0, 99999)))


func _on_custom_time_text_changed(new_text: String) -> void:
	if new_text.is_empty() or new_text.is_valid_int():
		custom_old = custom_time.text
	else:
		custom_time.text = custom_old
	custom_time.caret_column = custom_time.text.length()
