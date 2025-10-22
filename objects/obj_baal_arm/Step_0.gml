if instance_exists(obj_player) && instance_exists(father){
	var _dist = point_direction(x, y, obj_baal.x, obj_baal.y)
	yspd = lengthdir_y(maxVel,_dist)
	
	if followTimer > 0{
		x = obj_player.x
		followTimer--
	}else{
	
		if !place_meeting(x,y+1,obj_wall){
			y += yspd
		}
		//followTimer = followTime
	}
	
	if place_meeting(x,y+1,obj_wall){
		existTimer--
		
		if existTimer <= 0{
			father.timesAttacked = 0
			father.idleTimer = father.idleTime;
			instance_destroy(self)
		}
	}
}