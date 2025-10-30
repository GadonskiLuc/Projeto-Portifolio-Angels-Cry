global.life += 2;
if global.life > maxLife{
	global.life = maxLife;
}
audio_play_sound(snd_gabriel_takeItem,5,false)
instance_destroy(other);