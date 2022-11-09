extends MenuButton

var popup

func _ready():
	popup = get_popup()
	popup.add_item("Intructions")
	popup.add_item("Quit Game")
	popup.connect("id_pressed", self, "_on_item_pressed")

	

func _on_item_pressed(ID):
	var action = popup.get_item_text(ID)
	if action == "Quit Game":
		get_tree().change_scene("res://TitleScreen.tscn")
