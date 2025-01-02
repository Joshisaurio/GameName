extends MeshInstance3D

#Tenant 1
const T1N = preload("res://Textures/Tenants/tenant1_default.png")
const T1M = preload("res://Textures/Tenants/tenant1_mad.png")

#Tenant 2
const T2N = preload("res://Textures/Tenants/tenant2_default.png")
const T2M = preload("res://Textures/Tenants/tenant2_mad.png")

var active_tenant 
@export var normal_tenant: Texture2D
@export var mad_tenant: Texture2D

func _ready():
	active_tenant = randi_range(1,2)
	
	match active_tenant:
		1:
			normal_tenant = T1N
			mad_tenant = T1M
		2:
			normal_tenant = T2N
			mad_tenant = T2M
