if global.life <= 0 {
	obj_player.xspd = 0;
	obj_player.yspd = 0;
	obj_player.state = "death";
	isDead = true;
	
	if isDead{
		global.lives--
	}
	if global.lives >= 0{
		if room == rmLvl2 || room == rmLvl1{
			room_restart();
		}else if room == rmBoss3{
			global.lives = -1
		}else{
			room_goto_previous()
		}
	}
}else{
	if instance_exists(obj_player){
		isDead = false;
	}
}

if global.lives < 0{
	gameOver = true;
}

if gameOver{
	set_song_ingame(noone)
}else{
	if !instance_exists(obj_transition){
		if global.masterVolume < 1{
			global.masterVolume += 0.1;
		}
	}
}