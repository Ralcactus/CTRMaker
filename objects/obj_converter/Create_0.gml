global.output = "";
compiler_window = noone;
compile_output = "";


function scr_compile(){
	#region init stuff
	global.yyp = get_open_filename("GameMaker Project (*.yyp)", "");
	global.project_path = filename_path(global.yyp);

	scr_resetbuild();

	//create dirs, copy makefile, copy compile bat, and copy icon
	directory_create(global.project_path + "export_project\\");
	directory_create(global.project_path + "export_project\\source\\");
	directory_create(global.project_path + "export_project\\sprites\\");
	file_copy(working_directory + "project empty\\Makefile", global.project_path + "export_project\\Makefile");
	file_copy(working_directory + "project empty\\compile.bat", global.project_path + "export_project\\compile.bat");
	
	if (global.icon_sprite = spr_icon_default)
		file_copy(working_directory + "project empty\\icon.png", global.project_path + "export_project\\icon.png");
	else
		file_copy(global.icon_path, global.project_path + "export_project\\icon.png");

	//add C intro stuff
	var file = file_text_open_write(global.project_path + "export_project\\source\\main.c");
	file_text_write_string(file, "#include <3ds.h>\n#include <citro2d.h>\n\ntypedef struct{float x,y,sx,sy;int spr;} RoomSpr;\n\n");
	file_text_close(file);

	//get text
	var buffer = buffer_load(global.yyp);
	var text = buffer_read(buffer, buffer_string);
	buffer_delete(buffer);
	var yyp_json = json_parse(text);

	//these store the names and paths of all assets (it pulls these from the yyp, as seen below)
	global.asset_names = [];
	global.asset_paths = [];
	global.sprite_names = [];

	global.room_jsons = [];
	global.first_room_name = "";

	for (var i = 0; i < array_length(yyp_json.resources); i++)
	{
	    global.asset_names[i] = yyp_json.resources[i][$ "id"].name;
	    global.asset_paths[i] = yyp_json.resources[i][$ "id"].path;
		global.asset_paths[i] = string_replace(global.asset_paths[i], "/", "\\");
	}
	#endregion


	//loops for all assets
	for (var i = 0; i < array_length(global.asset_paths); i++)
	{
	    var _buffer = buffer_load(global.project_path + global.asset_paths[i]);
	    var _text   = buffer_read(_buffer, buffer_string);
	    buffer_delete(_buffer);

	    var assetjson = json_parse(_text); //the asset we are looking through


	    //here and below check what the asset is (sprite, room, ect) and write it to the c code
	    #region Sprites
	    if (assetjson[$ "$GMSprite"] != undefined)
	    {
	        var spr_index = array_length(global.sprite_names);
	        global.sprite_names[spr_index] = global.asset_names[i];
	        var frames = assetjson[$ "frames"];
	        var spr_folder = filename_path(global.project_path + global.asset_paths[i]);

	        var idx_str = string(spr_index);
	        if (spr_index < 10)
	            idx_str = "00" + idx_str;
	        else if (spr_index < 100)
	            idx_str = "0" + idx_str;

	        var fname = idx_str + "_" + global.asset_names[i] + "_f0.png";
	        var dst = global.project_path + "export_project\\sprites\\" + fname;

	        file_copy(spr_folder + frames[0][$ "%Name"] + ".png", dst);
	    }
	    #endregion


		#region Rooms
		if (assetjson[$ "$GMRoom"] != undefined)
		{
		    global.room_jsons[array_length(global.room_jsons)] = assetjson;

		    if (global.first_room_name = "")
		        global.first_room_name = assetjson[$ "%Name"];
		}
		#endregion
	}


	#region write rooms
	for (var r = 0; r < array_length(global.room_jsons); r++)
	{
	    var _room = global.room_jsons[r];
	    var mainc = file_text_open_append(global.project_path + "export_project\\source\\main.c");
	    file_text_write_string(mainc, "RoomSpr room_" + _room[$ "%Name"] + "[] = {\n");
		
	    for (var li = 0; li < array_length(_room[$ "layers"]); li++)
	    {
	        var roomlayers = _room[$ "layers"][li];
	
	        if (roomlayers[$ "resourceType"] = "GMRAssetLayer")
	        {
	            var roomlayers_assets = roomlayers[$ "assets"];

	            for (var j = 0; j < array_length(roomlayers[$ "assets"]); j++)
	            {
	                var room_sprite = roomlayers_assets[j];
	                var spr_index = -1;
					
	                for (var e = 0; e < array_length(global.sprite_names); e++)
	                {
	                    if (global.sprite_names[e] = room_sprite[$ "spriteId"][$ "name"])
	                    {
	                        spr_index = e;
	                        break;
	                    }
	                }


	                if spr_index < 0
	                    spr_index = 0;
						
	                var px = room_sprite[$ "x"];
	                var py = room_sprite[$ "y"];
	                var sx = room_sprite[$ "scaleX"];
	                var sy = room_sprite[$ "scaleY"];
	                file_text_write_string(mainc, "    {" + string(px) + "," + string(py) + "," + string(sx) + "," + string(sy) + "," + string(spr_index) + "},\n");
	            }
	        }
	    }

	    file_text_write_string(mainc, "};\n\n");
	    file_text_close(mainc);
	}
	#endregion

	#region long ass string for writing the main loop
	var fuckyou = file_text_open_append(global.project_path + "export_project\\source\\main.c");
	var main_str =
	"int main(void)\n" +
	"{\n" +
	"    gfxInitDefault();\n" +
	"    romfsInit();\n" +
	"    C3D_Init(C3D_DEFAULT_CMDBUF_SIZE);\n" +
	"    C2D_Init(C2D_DEFAULT_MAX_OBJECTS);\n" +
	"    C2D_Prepare();\n\n" +
	"    C3D_RenderTarget* top = C2D_CreateScreenTarget(GFX_TOP, GFX_LEFT);\n\n" +
	"    C2D_SpriteSheet sheet = C2D_SpriteSheetLoad(\"romfs:/sprites.t3x\");\n" +
	"    int hasSheet = (sheet != NULL);\n\n" +
	"    C2D_Sprite base;\n" +
	"    if (hasSheet)\n" +
	"        C2D_SpriteFromSheet(&base, sheet, 0);\n\n" +
	"    int count = sizeof(room_" + global.first_room_name + ")/sizeof(room_" + global.first_room_name + "[0]);\n\n" +
	"    while (aptMainLoop())\n" +
	"    {\n" +
	"        hidScanInput();\n" +
	"        if (hidKeysDown() & KEY_START) break;\n\n" +
	"        C3D_FrameBegin(C3D_FRAME_SYNCDRAW);\n" +
	"        C2D_TargetClear(top, C2D_Color32(0,0,0,255));\n" +
	"        C2D_SceneBegin(top);\n\n" +
	"        if (hasSheet)\n" +
	"        {\n" +
	"            for (int i = 0; i < count; i++)\n" +
	"            {\n" +
	"                RoomSpr* r = &room_" + global.first_room_name + "[i];\n" +
	"                C2D_Sprite spr;\n" +
	"                C2D_SpriteFromSheet(&spr, sheet, r->spr);\n" +
	"                C2D_SpriteSetPos(&spr, r->x, r->y);\n" +
	"                C2D_SpriteSetScale(&spr, r->sx, r->sy);\n" +
	"                C2D_DrawSprite(&spr);\n" +
	"            }\n" +
	"        }\n" +
	"        else\n" +
	"        {\n" +
	"            C2D_DrawRectSolid(50, 50, 0, 40, 40, C2D_Color32(255,0,0,255));\n" +
	"        }\n\n" +
	"        C3D_FrameEnd(0);\n" +
	"    }\n\n" +
	"    if (hasSheet)\n" +
	"        C2D_SpriteSheetFree(sheet);\n" +
	"    C2D_Fini();\n" +
	"    C3D_Fini();\n" +
	"    romfsExit();\n" +
	"    gfxExit();\n" +
	"    return 0;\n" +
	"}\n";

	file_text_write_string(fuckyou, main_str);
	file_text_close(fuckyou);
	#endregion
	
	
	//compiles the 3dsx
	/// scr_compile(target_name)
	var target_name = "bread me too";
	compiler_window = ProcessExecuteAsync("cmd /c \"" + global.project_path + "export_project\\compile.bat\" " + yyp_json[$ "%Name"]);
	compile_output = "";
}

