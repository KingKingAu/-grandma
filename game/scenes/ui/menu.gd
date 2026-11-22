extends Control

@export var seedboth_contain: HBoxContainer
@export var seed1_contain: HBoxContainer
@export var seed2_contain: HBoxContainer

@export var seedboth_lineedit: LineEdit
var seedboth_old = ""
@export var seed1_lineedit: LineEdit
var seed1_old := ""
@export var seed2_lineedit: LineEdit
var seed2_old := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_randomiseboth_pressed()
	_on_randomise1_pressed()
	_on_randomise2_pressed()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_split_toggled(toggled_on: bool) -> void:
	seedboth_contain.visible = !toggled_on
	seed1_contain.visible = toggled_on
	seed2_contain.visible = toggled_on
	Autoload.split_seed = toggled_on

func _on_seedboth_text_changed(new_text: String) -> void:
	if new_text.is_empty() or new_text.is_valid_int():
		seedboth_old = seedboth_lineedit.text
	else:
		seedboth_lineedit.text = seedboth_old
	seedboth_lineedit.caret_column = seedboth_lineedit.text.length()
	Autoload.seed = seedboth_lineedit.text

func _on_seed1_text_changed(new_text: String) -> void:
	if new_text.is_empty() or new_text.is_valid_int():
		seed1_old = seed1_lineedit.text
	else:
		seed1_lineedit.text = seed1_old
	seed1_lineedit.caret_column = seed1_lineedit.text.length()
	Autoload.seed = seed1_lineedit.text

func _on_seed2_text_changed(new_text: String) -> void:
	if new_text.is_empty() or new_text.is_valid_int():
		seed2_old = seed2_lineedit.text
	else:
		seed2_lineedit.text = seed2_old
	seed2_lineedit.caret_column = seed2_lineedit.text.length()
	Autoload.seed2 = seed2_lineedit.text


func _on_randomiseboth_pressed() -> void:
	seedboth_lineedit.text = str(randi_range(0, 99999))

func _on_randomise1_pressed() -> void:
	seed1_lineedit.text = str(randi_range(0, 99999))

func _on_randomise2_pressed() -> void:
	seed2_lineedit.text = str(randi_range(0, 99999))
