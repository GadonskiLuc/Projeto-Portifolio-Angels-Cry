//tocando em alguem
var _hitByAtkNow = ds_list_create();
var _hits = instance_place_list(x,y,obj_enemy_father,_hitByAtkNow,false);

if _hits>0{
	for(var i = 0; i<_hits; i++){
		//se essa instancia ainda não foi acertada por esse ataque
		var _hitId = _hitByAtkNow[| i];
		if ds_list_find_index(father.hitByAttack, _hitId) == -1{
			ds_list_add(father.hitByAttack,_hitId);
			with(_hitId){
				_hitId.life -= 2;
				_hitId.damageTimer = _hitId.damageTime;
				_hitId.state = "attacked";
				
			}
		}
	}
}
if animation_end() {instance_destroy()};