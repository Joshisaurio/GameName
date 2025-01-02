extends MeshInstance3D

@export var isStamped := false
@export var isSigned := false

@onready var namelbl = $SubViewport/Central/PaperBG/Namelbl
@onready var roomlbl = $SubViewport/Central/PaperBG/TenantInfo/Roomlbl
@onready var signaturelbl = $SubViewport/Central/PaperBG/Line/SigName
var tenant_room
var tenant_name

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
