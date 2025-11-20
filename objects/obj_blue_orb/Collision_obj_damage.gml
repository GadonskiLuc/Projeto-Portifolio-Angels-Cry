//toca som de hit
if !other.playedSound{
	audio_play_sound(snd_gabriel_hit,8,false)
}
other.playedSound = true
instance_destroy(self);