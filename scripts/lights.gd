extends Node

@onready var l = $L
@onready var l_2 = $L2
@onready var l_3 = $L3
@onready var l_4 = $L4
@onready var l_5 = $L5
@onready var l_6 = $L6
@onready var l_7 = $L7
@onready var l_8 = $L8
@onready var l_9 = $L9
@onready var l_10 = $L10
@onready var l_11 = $L11
@onready var l_12 = $L12
@onready var l_13 = $L13
@onready var l_14 = $L14
@onready var l_15 = $L15

var switch = false

func _process(delta):
	
	switch = not switch
	
	match switch:
		true:
			l.visible = false
			l_2.visible = false
			l_3.visible = false
			l_4.visible = false
			l_5.visible = false
			l_6.visible = false
			l_7.visible = false
			l_8.visible = false
			
			l_9.visible = true
			l_10.visible = true
			l_11.visible = true
			l_12.visible = true
			l_13.visible = true
			l_14.visible = true
			l_15.visible = true
		false:
			l.visible = true
			l_2.visible = true
			l_3.visible = true
			l_4.visible = true
			l_5.visible = true
			l_6.visible = true
			l_7.visible = true
			l_8.visible = true
			
			l_9.visible = false
			l_10.visible = false
			l_11.visible = false
			l_12.visible = false
			l_13.visible = false
			l_14.visible = false
			l_15.visible = false
