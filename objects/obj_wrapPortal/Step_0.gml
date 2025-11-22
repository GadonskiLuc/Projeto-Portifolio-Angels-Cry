if animation_end(){
	image_speed = 0;
	var _sensor = instance_create_layer(x,y,"Sensors", obj_sensor);
		_sensor.mask_index = spr_wrapPortal
		_sensor.destination = destination;
		_sensor.destinationX = destinationX;
		_sensor.destinationY = destinationY;
}