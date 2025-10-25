if instance_exists(obj_player) && instance_exists(father) && father.life > 0{
	var _dist = point_direction(x, y, obj_baal.x, obj_baal.y)
	var _distPlayer = point_direction(x, y, obj_player.x, obj_player.y)
	
	yspd = lengthdir_y(maxYspd,_dist)
	
	
	if followTimer > 0{
		xspd = lengthdir_x(maxXspd,_distPlayer)
		x += xspd
		followTimer--
	}else{
		if y <= 220{
			y += yspd
		}
		//followTimer = followTime
	}
	
	if y > 220{
		existTimer--
		
		if existTimer <= 0{
			father.timesAttacked = 0
			father.idleTimer = father.idleTime;
			instance_destroy(self)
		}
	}
}else{
	instance_destroy(self)
}