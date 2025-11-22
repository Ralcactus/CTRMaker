if (position_meeting(mouse_x, mouse_y, self)){
	if (mouse_check_button(mb_left))
		image_index = 2;
	else
		image_index = 1;	

	if (mouse_check_button_released(mb_left))
		obj_converter.scr_compile();
}
else
	image_index = 0;
	
