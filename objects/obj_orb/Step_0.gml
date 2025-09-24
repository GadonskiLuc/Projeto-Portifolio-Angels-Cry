if instance_exists(obj_player) && instance_exists(father){
	var _dir;
	if father.side == "right"{
		_dir = point_direction(x, y,-20,targetY);
	}else{
		_dir = point_direction(x, y, room_width+20,targetY);
	}
	speed = 6;
	direction = _dir;
}
