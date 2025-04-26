extends Node

# --- Character Customization handling

# body sprite collection
var bodies_collection = {
	"01" : preload("res://assets/sprites/player/body/base_animation.png")
}

# hair sprite collection
var hair_collection = {
	"none" : null,
	"01" : preload("res://assets/sprites/player/hair/hairstyle_1.png"),
	"02" : preload("res://assets/sprites/player/hair/hairstyle_2.png")
}

# hat sprite collection
var hats_collection = {
	"none" : null,
	"01" : preload("res://assets/sprites/player/hats/hat_1.png"),
}

# outfit sprite collection
var outfits_collection = {
	"01" : preload("res://assets/sprites/player/outfit/outfit_1.png"),
	"02" : preload("res://assets/sprites/player/outfit/outfit_2.png")
}

# skin colour rgb
var body_colour_options = [
	Color(1, 1, 1), # Default
	Color(0.96, 0.8, 0.69), # Light Skin
	Color(0.72, 0.54, 0.39), # Medium Skin
	Color(0.45, 0.34, 0.27), # Brown Skin
]

# hair colour rgb
var hair_colour_options = [
	Color(1, 1, 1), # Default
	Color(0.1, 0.1, 0.1), # Black
	Color(0.4, 0.2, 0.1), # Brown
	Color(0.9, 0.6, 0.2), # Blonde
	Color(0.5, 0.25, 0), # Auburn
]

var hat_colour_options = [
	Color(1, 1, 1), # Default
	Color(1, 0, 0), # Red
	Color(0, 1, 0), # Green
	Color(0, 0, 1), # Blue
	Color(0, 0, 0), # Black
	Color(1, 1, 1), # White
]

# outfit colour rgb
var outfit_colour_options = [
	Color(1, 1, 1), # Default
	Color(1, 0, 0), # Red
	Color(0, 1, 0), # Green
	Color(0, 0, 1), # Blue
	Color(0, 0, 0), # Black
	Color(1, 1, 1), # White
]

var title_options: = [
	"Novice",
	"Wand Waver",
	"Potion Spiller",
	"Bard",
	"Good Boy",
	"Good Girl",
	"Good Entity",
	"Cheese Wizard",
	"Caster",
	"Wizard",
	"Novice",
	"Apprentice",
	"Keiromancer",
	"Top Lad",
	"Top Lass",
	"Romancer",
	"Mud Wizard",
]


# selected values
var selected_body = ""
var selected_hair = ""
var selected_hat = ""
var selected_outfit = ""
var selected_skin_colour = ""
var selected_hair_colour = ""
var selected_hat_colour = ""
var selected_outfit_colour = ""
var selected_title = ""
