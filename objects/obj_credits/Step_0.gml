confirmButton = keyboard_check_pressed(vk_enter) + gamepad_button_check_pressed(0, gp_start);
confirmButton = clamp(confirmButton,0,1);

y -= scroll_speed;

if y <= -string_height(text) || confirmButton{
    room_goto(rmTitleScreen); 
}