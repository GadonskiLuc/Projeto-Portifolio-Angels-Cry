global.life += 2;
if global.life > global.Maxlife{
	global.life = global.Maxlife;
}
audio_play_sound(snd_gabriel_takeItem,5,false)
instance_destroy(other);