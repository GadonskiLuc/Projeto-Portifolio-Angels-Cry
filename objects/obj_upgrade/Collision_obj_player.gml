global.powerUp[type] = true;
global.maxLife = 15;

audio_play_sound(snd_gabriel_takeItem,5,false)
instance_destroy(self);