if (position_meeting(mouse_x, mouse_y, self)){
	if (mouse_check_button(mb_left))
		image_index = 2;
	else
		image_index = 1;	

	if (mouse_check_button_released(mb_left)){
		show_message("Your icon must be a PNG (.png) 48x48 image!")	
		global.icon_path = get_open_filename("Png Files (*.png)", "");
		var savedico = global.icon_sprite;
		global.icon_sprite = sprite_add(global.icon_path,0,false,false,0,0);
		
		if (!file_exists(global.icon_path)) {
			show_message("Error!\nThe icon file does not exist.\nPlease double check your path.");
			global.icon_sprite = savedico;
		}

		if (!string_ends_with(global.icon_path, ".png")) {
			show_message("Error!\nThe selected file is not a .png.\nPlease choose a valid .png file.");
			global.icon_sprite = savedico;
		}

		if (sprite_get_width(global.icon_sprite) != 48) {
			show_message("Error!\nInvalid icon size.\nYour icon must be 48x48 pixels.");
			global.icon_sprite = savedico;
		}
	}
}
else
	image_index = 0;
	
