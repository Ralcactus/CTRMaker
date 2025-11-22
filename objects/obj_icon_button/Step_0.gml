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
		
		if (sprite_get_width(global.icon_sprite) != 48){
			show_message("Your icon size is invalid!\nitshould be 256x256")	
			global.icon_sprite = savedico;
		}
		
	}
}
else
	image_index = 0;
	
