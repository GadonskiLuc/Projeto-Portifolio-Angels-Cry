// Inherit the parent event
event_inherited();

spr_idle = spr_lucifer_idle;
spr_walking = spr_lucifer_idle; // mudar
spr_damage = spr_lucifer_idle;
spr_attack1 = spr_lucifer_attack1;

xspd = 0;
max_xspd = 1.5;

life = 8;

idleTimer = 0;
idleTime = 60;

side = "right";
firstAtk = true;
strength = 2;
attackType = 0;

state = "idle";