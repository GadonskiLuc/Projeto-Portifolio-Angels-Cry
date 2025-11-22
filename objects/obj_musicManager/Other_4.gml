if room == rmLvl1 || room == rmLvl2{
	set_song_ingame(snd_level1, 60, 60)
}
if room == rmBoss1 || room == rmBoss2{
	set_song_ingame(snd_level1_boss, 60, 60)
}
if room == rmBoss3{
	set_song_ingame(snd_boss3, 60, 60)
}
if room == rmTitleScreen || room == rmCreditsScreen{
	set_song_ingame(noone, 60, 60)
}