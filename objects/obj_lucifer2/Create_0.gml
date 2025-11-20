// Inherit the parent event
event_inherited();

spr_idle = spr_lucifer2_idle;
spr_damage = spr_lucifer_damage;
spr_damage_on_atk = spr_lucifer_damage_on_attack;

alpha = 1;

xspd = 0;
yspd = 0;
max_xspd = 1.5;
airHoldTimer = 0;
airHoldTime = 60;
jspd = -5;
onGround = true;

life = 15;

idleTimer = 0;
idleTime = 60;
invTimer = 0;
invTime = 60;

side = "right";
firstAtk = true;
strength = 2;
attackType = 0;
attacking = false;
attacked = false;
reachedTop = false;

state = "idle";