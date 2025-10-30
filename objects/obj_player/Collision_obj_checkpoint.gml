ini_open("checkpoint.ini");

ini_write_real("player", "iniX", x);
ini_write_real("player", "iniY", y);
ini_write_real("player", "maxLife", maxLife);
ini_write_real("player", "dash", global.powerUp[0]);
ini_write_real("player", "defense", global.powerUp[1]);

ini_close();

audio_play_sound(snd_gabriel_takeItem,5,false)

instance_destroy(other);