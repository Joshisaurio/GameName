extends MeshInstance3D

const eye_colors = ["Blue", "Black", "Brown", "Hazel", "Gray", "Green"]

@export var isStamped := false
@export var isSigned := false

@onready var namelbl = $SubViewport/Central/PaperBG/Namelbl
@onready var roomlbl = $SubViewport/Central/PaperBG/TenantInfo/Roomlbl
@onready var signaturelbl = $SubViewport/Central/PaperBG/Line/SigName
@onready var age_label = $SubViewport/Central/PaperBG/TenantInfo/Infolbl
@onready var eye_label = $SubViewport/Central/PaperBG/TenantInfo/Infolbl2
var tenant_room
var tenant_name

func _ready():
	age_label.text = "Age: " + str(randi_range(18, 50))
	eye_label.text = "Eye Color: " + eye_colors.pick_random()

func _process(_delta):
	namelbl.text = tenant_name
	roomlbl.text = str(tenant_room)
	
	if not isStamped:
		$SubViewport/Central/PaperBG/Stamp.visible = false
	else:
		$SubViewport/Central/PaperBG/Stamp.visible = true
	
	if not isSigned:
		signaturelbl.visible = false
	else:
		signaturelbl.visible = true
