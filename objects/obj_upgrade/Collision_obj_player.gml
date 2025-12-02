global.powerUp[type] = true;
global.Maxlife = 15;
global.life = global.Maxlife

audio_play_sound(snd_gabriel_takeItem,5,false)


ini_open("checkpoint.ini");

ini_write_real("player", "iniX", global.iniX);
ini_write_real("player", "iniY", global.iniY);
ini_write_real("player", "room", rmLvl2);
ini_write_real("player", "Maxlife", global.Maxlife);
ini_write_real("player", "dash", global.powerUp[0]);
ini_write_real("player", "defense", global.powerUp[1]);

ini_close();

if room == rmBoss1{
	var _wrap = instance_create_layer(460,224,"Sensors", obj_wrapPortal);
	_wrap.destination = rmLvl2;
	_wrap.destinationX = global.iniX;
	_wrap.destinationY = global.iniY;
}

instance_destroy(self);