if room != rminit && room != rmTitleScreen{
	if file_exists("checkpoint.ini")
	&& room != rmBoss2 && room != rmBoss1{
	        ini_open("checkpoint.ini");
	        global.iniX = ini_read_real("player", "iniX", global.iniX);
	        global.iniY = ini_read_real("player", "iniY", global.iniY);
	        global.life = ini_read_real("player", "maxLife", global.life);
	        global.powerUp[0] = ini_read_real("player", "dash", global.powerUp[0]);
			global.powerUp[1] = ini_read_real("player", "defense", global.powerUp[1]);
		
	        ini_close();
	
	}else{
		global.life = 10;
	}
	if !instance_exists(obj_player){
		instance_create_layer(global.iniX,global.iniY,"Instances",obj_player)
	}
	obj_player.x = global.iniX
	obj_player.y = global.iniY
}