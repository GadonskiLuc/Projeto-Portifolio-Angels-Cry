global.life += 2;
if global.life > global.maxLife{
	global.life = global.maxLife;
}
audio_play_sound(snd_gabriel_takeItem,5,false)
instance_destroy(other);