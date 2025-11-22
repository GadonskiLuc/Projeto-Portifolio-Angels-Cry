ini_open("checkpoint.ini");

ini_write_real("player", "iniX", other.x);
ini_write_real("player", "iniY", other.y);
ini_write_real("player", "room", room);
ini_write_real("player", "Maxlife", global.Maxlife);
ini_write_real("player", "dash", global.powerUp[0]);
ini_write_real("player", "defense", global.powerUp[1]);

ini_close();

//global.iniX = x;
//global.iniY = y;

audio_play_sound(snd_gabriel_takeItem,5,false)

instance_destroy(other);