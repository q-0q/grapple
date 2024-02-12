extends Node

func delayed_callback(callback, delay):
	var timer := Timer.new()
	timer.wait_time = delay
	timer.one_shot = true
	timer.autostart = true
	timer.timeout.connect(callback)
	add_child(timer)
