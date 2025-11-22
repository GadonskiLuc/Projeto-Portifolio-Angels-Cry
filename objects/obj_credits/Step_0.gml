
y -= scroll_speed;

if (y <= -string_height(text)) {
    room_goto(rmTitleScreen); // Assuming your main menu room is rm_main_menu
}