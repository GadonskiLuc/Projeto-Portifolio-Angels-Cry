global.powerUp[type] = true;
global.Maxlife = 15;

audio_play_sound(snd_gabriel_takeItem,5,false)
instance_destroy(self);