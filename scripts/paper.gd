extends MeshInstance3D

@export var isStamped := false
@export var isSigned := false

@onready var namelbl = $SubViewport/Central/PaperBG/Namelbl
@onready var roomlbl = $SubViewport/Central/PaperBG/TenantInfo/Roomlbl
var tenant_room
var tenant_name

func _process(delta):
	
	namelbl.text = tenant_name
	roomlbl.text = str(tenant_room)
	
	if not isStamped:
		$SubViewport/Central/PaperBG/Stamp.visible = false
	else:
		$SubViewport/Central/PaperBG/Stamp.visible = true
