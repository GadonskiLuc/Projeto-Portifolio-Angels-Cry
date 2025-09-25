global.life += 2;
if global.life > maxLife{
	global.life = maxLife;
}
instance_destroy(other);