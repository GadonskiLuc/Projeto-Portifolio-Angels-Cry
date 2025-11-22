function checkForSemisolidePlatform(_x, _y){
	//variavel de retorno
	var _rtrn = noone;
	
	//nao estamos subindo, ai checamos uma colisao normalmente
	if yspd >= 0 && place_meeting(_x, _y, obj_semiSolidWall){
		//criar uma dslist para guardar todas as instancias de colisao com a obj_semiSolidWall
		var _list = ds_list_create();
		var _listSize = instance_place_list(_x,_y, obj_semiSolidWall, _list, false);
		
		//percorrer pela lista e retornar apenas a plataforma que esata abaixo do player
		for(var i = 0; i< _listSize; i++){
			var _listInst = _list[| i];
			if _listInst != forgetSemiSolid && floor(bbox_bottom) <= ceil(_listInst.bbox_top - _listInst.yspd){
				//retornar o id da plataforma
				_rtrn = _listInst;
				//sair do loop mais cedo
				i = _listSize;
			}
		}
		//destruir a lista para economizar memoria
		ds_list_destroy(_list);
	}
	//retornar a variavel
	return _rtrn;
}

//vida
life = 10;

//variaveis de movimento
vel = 1;
xspd = 0;
yspd = 0; 
grav = .275;
termVel = 4;
movCooldown = 0;

//posição inicial
iniX = x;
iniY = y;

//variaveis de estado
onGround = false;
active = false;
seeingPlayer = false;
damageTimer  = 0;
damageTime	= 30;
attacked = false;
strength = 0;
damage = noone;
spawnLife = 0;
state = "idle";
invTimer = 0;
invTime = 0;

face = 1;
depth = 1;

//variaveis de ataque
dist = 50;

//variaveis de colisao
myFloorPlat = noone;
forgetSemiSolid = noone;
downSlopeSemiSolid = noone;

//sprites
spr_idle = noone;
spr_damage = noone;
spr_death = noone;