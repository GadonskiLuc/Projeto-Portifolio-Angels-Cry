function enemy_attack(_sprite, _index_min, _index_max, _distX, _distY, _xscaleDmg, _yscaleDmg){
	xspd = 0;
	
	if !_xscaleDmg{ _xscaleDmg = 1};
	if !_yscaleDmg{	_yscaleDmg = 1};
	
	if sprite_index != _sprite {
		sprite_index = _sprite;
		image_index = 0;
		damage = noone;
	}
	
	if image_index > (image_number-1){
		state = "idle";
	}
	
	//criando o dano
	if image_index > _index_min
	&& damage == noone
	&& image_index < _index_max{
		damage  = instance_create_layer(x + _distX, y + _distY,layer,obj_enemy_damage);
		damage.image_xscale = _xscaleDmg;
		damage.image_yscale = _yscaleDmg;
	}
	
	//destruindo o dano
	if damage != noone && image_index >= _index_max{
		instance_destroy(damage);
		damage = noone;
	}
}