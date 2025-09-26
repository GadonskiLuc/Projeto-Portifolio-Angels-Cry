function setOnGround(_val = false){
	if _val == true {
		onGround = true;
		coyoteHangTimer = coyoteHangFrames;
	}else{
		onGround = false;
		myFloorPlat = noone;
		coyoteHangTimer = 0;	
	}
}

function setPlaning(_val = false){
	if _val == true{
		planing = true;
		grav = 0;
	}else{
		planing = false
		grav = .275
	}
}

//Sprites
maskSpr		= spr_gabriel_idle;
idleSpr		= spr_gabriel_idle;
walkSpr		= spr_gabriel_walk;
runSpr		= spr_gabriel_walk;
jumpSpr		= spr_gabriel_jump;
crouchSpr	= spr_gabriel_crouch;
attackSpr	= spr_gabriel_attack_slash;
airAtkSpr	= spr_gabriel_attack_air;
depth		= -30;


// movimento
controlsSetup();

face	= 1;
moveDir = 0;
runType = 0;
moveSpd[0] = 2;
moveSpd[1] = 3.5;
xspd	= 0;
yspd	= 0;
iniX = x;
iniY = y;

//variaveis de estado
crouching = false;
getting_damage = false;
hitByAttack = ds_list_create();
attack = 1;
damage = noone;
maxLife = 10;

//scripts de estado
state = "idle";

//dano
damage_timer = 0;
damage_time = 15;
pushTimer = 0;
pushTime = 30;
inv_timer = 0;
inv_time = 90;


// pulo
	grav				=	 .275;
	termVel				=		4;
	onGround			=	 true;
	planing				=	false;
	jumpMax				=		1;
	jumpCount			=		0;
	jumpHoldTimer		=		0;
		//valores para cada tipo de pulo (no chão, duplo, etc)
		jumpHoldFrames[0]	=	   18;
		jspd[0]				=	-3.15;
		jumpHoldFrames[1]	=	   100;
		jspd[1]				=	-2.85;
		planeSpd			=	   .5;
	
	//coyote time
		//hang time
		coyoteHangTimer		=	0;
		coyoteHangFrames	=	2;
		//jump buffer time
		coyoteJumpTimer		=	0;
		coyoteJumpFrames	=	5;
		
//plataformas moveis
myFloorPlat			= noone;
earlyMoveplatXspd	= false;
downSlopeSemiSolid	= noone;
forgetSemiSolid		= noone;
moveplatXspd		=	  0;
crushTimer			=	  0;
crushDeathTime		=	  3;