if instance_exists(obj_player) && instance_exists(father){
	var _dir;
	_dir = point_direction(x, y, targetX,targetY);
	speed = 5;
	direction = _dir;
}else{
	instance_destroy(self);
}
