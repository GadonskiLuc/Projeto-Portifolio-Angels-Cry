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
		//para som das pedras
		if audio_is_playing(snd_stone_falling){
			audio_stop_sound(snd_stone_falling);
		}
		//som de ataque
		if !playedSound{
			audio_play_sound(snd_baal_atk_arm,8,false);
		}
		playedSound = true
		
		if existTimer <= 0{
			father.timesAttacked = 0
			father.idleTimer = father.idleTime;
			instance_destroy(self)
		}
	}
}else{
	instance_destroy(self)
}