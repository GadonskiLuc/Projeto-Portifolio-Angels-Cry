// Inherit the parent event
event_inherited();

spr_idle = spr_lucifer2_idle;
spr_damage = spr_lucifer2_damage;
spr_attack1_1 = spr_lucifer2_attack1_1;
spr_attack1_2 = spr_lucifer2_attack1_2;
spr_attack2 = spr_lucifer2_attack2;
spr_damage_on_atk1 = spr_lucifer2_damage_on_attack1_1;
spr_damage_on_atk2 = spr_lucifer2_damage_on_attack1_2;
spr_death = spr_lucifer2_death

alpha = 1;
playedSound = false;

xspd = 0;
yspd = 0;
max_xspd = 1.5;
jspd = -5;
onGround = true;

life = 15;

idleTimer = 0;
idleTime = 60;
invTimer = 0;
invTime = 60;

firstAtk = true;
strength = 2;
attackType = 0;
attacking = false;
attacked = false;
reachedTop = false;

state = "idle";