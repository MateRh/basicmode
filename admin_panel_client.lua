
_initialLoading[ "admin_panel_client.lua" ] = function ( )
	

function sync_client_settings( data )
	client_global_settings = {}
	client_global_settings = data

	--
	setBlurLevel( data.blur )
	setBirdsEnabled ( data.birds )
	setAmbientSoundEnabled( "general", data.a_sounds_general )
	setAmbientSoundEnabled( "gunfire", data.a_sounds_gunfire )
	--
end

function sync_client_one_setting( index, index2, val )

	client_global_settings[ index ] [index2] = val

end


function getRelativeByScreenPositionViaElement(x,y,element)
	local xE,yE = guiGetSize(element,false)
	local nX,nY =x/xE,y/yE
	return nX,nY
end


local  _panel = {grid_buffor ={}}
	function movePanel()
		guiSetPosition (_panel.window, (screenWidth-550)/2, (screenHeight-350)/2,false )
	end

local additional_data = {}
	
local c_panel_read_only_c = getTickCount()	- 9999
	
	function _panelUpdateCfgList( t, name )
	
		guiGridListClear( _panel.grid_configs )
			for k,v in ipairs( t ) do
				local row = guiGridListAddRow (_panel.grid_configs )
				guiGridListSetItemText ( _panel.grid_configs, row, 1, v[1], false, false )
				guiGridListSetItemText ( _panel.grid_configs, row, 2, v[2], false, false )
				guiGridListSetItemText ( _panel.grid_configs, row, 3, v[3], false, false )
			end
			
			for i=0, guiGridListGetRowCount ( _panel.grid_configs )-1 do
				if name == guiGridListGetItemText ( _panel.grid_configs, i, 1 ) then
					_panel.confing_a = i
					guiGridListSetSelectedItem ( _panel.grid_configs, i,1,true )
					guiSetText( _panel.edit_configs, name )
					return
				end
			end	
	
	end
	
	
	function createConfiguartionPanel( permisions )
	guiSetInputMode ( "allow_binds" )
	local read_only = false
	local read_only_t = ""
		if _panel.window  then
			showCursor(false)
			blur_remote( false )
			removeEventHandler( "onClientGUIDoubleClick", getRootElement(), _panel_double_click )
			removeEventHandler ( "onClientGUIClick", getRootElement(), _panel_click)
			removeEventHandler ( "onClientGUIComboBoxAccepted", getRootElement(), _panel_click )
			removeEventHandler ( "onClientGUIChanged", getRootElement(), _panel_changed )
			removeEventHandler ( "onClientGUIComboBoxAccepted", _panel.weapon_combo, load_weapon_settings )
			removeEventHandler ( "onClientGUIComboBoxAccepted", _panel.screen, _panelScreenCall )
			destroyElement( _panel.mainTab )
			_panel = {}
			additional_data = {}
			if isElement( myFont ) then destroyElement( myFont ) end
			if isElement( myFont3 ) then destroyElement( myFont3 ) end
			if isElement( myFont4 ) then destroyElement( myFont4 ) end
			if isElement( myFont5 ) then destroyElement( myFont5 ) end
			if isElement( myFont6 ) then destroyElement( myFont6 ) end

			return false
		end
		if  permisions == "read - only" then
			if getTickCount() - c_panel_read_only_c < 9999 then
				outputChatBox ( "#FF0000** Error:#d5d5d5 In mode 'read only' you can open configuration panel #ffae00only once every ten seconds.",255, 255, 255, true )
				return false
			end
			c_panel_read_only_c = getTickCount()	
			read_only = true
			read_only_t = " (READ ONLY MODE)"
			outputChatBox ( "#FF0000** Error:#d5d5d5 you are not admin... #ffae00Configuration panel will work in 'read only' mode.",255, 255, 255, true )
			
		end
			myFont = guiCreateFont( "fonts/visitor.ttf", 10 ) or 'default-normal'
		myFont3 = guiCreateFont( "fonts/TravelingTypewriter.ttf", 18 ) or 'sa-header'
		myFont4 = guiCreateFont( "fonts/TravelingTypewriter.ttf", 12 )  or 'clear-normal'
				myFont6 = guiCreateFont( "fonts/squarethings.ttf", 30 )  or 'clear-normal'
		myFont5 = guiCreateFont( "fonts/TravelingTypewriter.ttf", 10 ) 	 or 'sa-gothic'
		
		 _panel = {read_only=read_only,save = {},weapons_l = {},edit={},edit_={},teams_l ={{Name='123123',Skin='57',Score='0',Color='125,23,125'},{Name='1sadsa',Skin='157',Score='0',Color='225,23,25'}}}
		local settings_l ={22,23,24,25,26,27,28,29,32,30,31,33,34,37,38,16,17,18,39}			
			for k,i in ipairs(settings_l) do
				_panel.weapons_l[i] = {['Ammo']=tostring(math.random(0,100)),['Skills']=tostring(math.random(0,100)),['Primary weapon']='true',['Secondary weapon']='false',['Special weapon']='false'}
			end
						
		

		_panel.mainTab = guiCreateTabPanel ((screenWidth-754)/2, (screenHeight-480)/2, 754, 480, false )
		_panel.window = guiCreateTab ( "Settings panel", _panel.mainTab )
		guiSetAlpha ( _panel.window, 0 )
		_panel.info = guiCreateLabel ( 0.46, 0.49, 0.2, 0.1, 'Loading...',true )
		guiSetFont ( _panel.info,myFont )
		_panel.tab = guiCreateTabPanel (0.01, 0.099, 0.98, 0.901, true, _panel.window )
		guiSetFont ( _panel.tab,myFont )

		guiSetFont ( guiCreateLabel (0.02, 0.015, 0.9, 0.08, 'Settings Panel: ( here will be helpful texts changed dynamically during using the panel ).',true, _panel.window) ,'clear-normal' )
		_panel.configs = guiCreateTab ( "Confings", _panel.tab )
		_panel.grid_configs = guiCreateGridList (  0.015, 0.025, 0.5, 0.95 ,true, _panel.configs )
		guiGridListAddColumn ( _panel.grid_configs , 'Name', 0.375 )
		guiGridListAddColumn ( _panel.grid_configs , 'Date (YYYY-MM-DD)', 0.35 )
		guiGridListAddColumn ( _panel.grid_configs , 'Author', 0.225 )
		callServer( 'dbWith_cfgs_list' , 'load', localPlayer, '-load' )
		guiSetFont ( guiCreateLabel ( 0.535, 0.025, 0.175, 0.06, 'Confing name:',true, _panel.configs), myFont4 )
		_panel.b_load = guiCreateButton ( 0.535 , 0.15, 0.2, 0.067, 'Load',  true, _panel.configs  )
		_panel.b_save = guiCreateButton ( 0.75, 0.15, 0.2, 0.067, 'Save',  true, _panel.configs  )
		_panel.b_new = guiCreateButton ( 0.535 , 0.24, 0.2, 0.067, 'New',  true, _panel.configs  )
		_panel.b_import = guiCreateButton ( 0.75, 0.24, 0.2, 0.067, 'Import',  true, _panel.configs  )
		_panel.b_rename = guiCreateButton ( 0.535 , 0.33, 0.2, 0.067, 'Rename',  true, _panel.configs  )
		_panel.b_delete = guiCreateButton ( 0.75 , 0.33, 0.2, 0.067, 'Delete',  true, _panel.configs  )
			for k,v in ipairs({_panel.b_new, _panel.b_save, _panel.b_load, _panel.b_import, _panel.b_rename, _panel.b_delete  }) do
				guiSetFont( v, myFont )
			end

		
		_panel.edit_configs = guiCreateEdit ( 0.7, 0.025, 0.25, 0.06, '',true, _panel.configs)
		
		_panel.settings = guiCreateTab ( "Settings", _panel.tab )
		_panel.grid_settings = guiCreateGridList (  0.25, 0.025, 0.735, 0.95 ,true, _panel.settings )
		_panel.grid_settings_menu = guiCreateGridList (  0.015, 0.025, 0.22, 0.95 ,true, _panel.settings )

		guiSetFont ( guiCreateLabel ( 0.07, 0.258, 1, 0.05, 'GameModes:',true, _panel.grid_settings_menu ) ,myFont )
		guiGridListSetSelectionMode (_panel.grid_settings, 0 )
        guiGridListAddColumn ( _panel.grid_settings , 'Settings', 0.4 )
        guiGridListAddColumn ( _panel.grid_settings_menu , 'Category:', 0.85 )
		
		local categories = { {'main'}, {'limits'},  {'gliteches'}, {'weather'}, {'miscellaneous'}, {''},  {'base'},   {'arena'},   {"bomb"},  }

		for k,v in pairs( categories ) do
			local row = guiGridListAddRow ( _panel.grid_settings_menu )
			guiGridListSetItemText ( _panel.grid_settings_menu, row, 1, v[1], false, false )
		end
		  guiGridListAddColumn ( _panel.grid_settings , 'Value', 0.25 )
		  guiGridListAddColumn ( _panel.grid_settings , '', 0.25 )

		--// Players
		
		_panel.players = guiCreateTab ( "Players", _panel.tab )
		_panel.grid_players = guiCreateGridList (  0.015, 0.025, 0.25, 0.95 ,true, _panel.players  )
		guiGridListSetSelectionMode (_panel.grid_players , 0 )
        guiGridListAddColumn ( _panel.grid_players  , 'Players:', 0.9 )
		local ppl = getElementsByType("player")
			for k,v in ipairs(ppl) do
				local row = guiGridListAddRow (_panel.grid_players  )
				local a = guiGridListSetItemText ( _panel.grid_players , row, 1, getPlayerName(v), false, false )
			end
		_panel.memo_players = guiCreateMemo ( 0.285, 0.026, 0.7, 0.4, 'Select player from list on the right side..', true, _panel.players )
		guiMemoSetReadOnly ( _panel.memo_players,true )
		_panel.screen = guiCreateComboBox (  0.285, 0.452, 0.25, 0.2, 'Screenshot: fullscreen',  true, _panel.players  )
		guiComboBoxAddItem( _panel.screen, 'Screenshot: fullscreen' )
		guiComboBoxAddItem( _panel.screen, 'Screenshot: 1/2 screen' )
		guiComboBoxAddItem( _panel.screen, 'Screenshot: 1/4 screen' )

	--[[	_panel.b_kick = guiCreateButton ( 0.35, 0.065+0.35, 0.175, 0.08, 'Kick',  true, _panel.players  )	
		_panel.b_ban = guiCreateButton ( 0.56, 0.065+0.35, 0.175, 0.08, 'Ban',  true, _panel.players  )	
		_panel.b_name = guiCreateButton ( 0.77, 0.065+0.35, 0.175, 0.08, 'Change Name',  true, _panel.players  )
		_panel.b_add_ = guiCreateButton ( 0.35, 0.21+0.35, 0.175, 0.08, 'Add',  true, _panel.players  )	
		_panel.b_restore = guiCreateButton ( 0.56, 0.21+0.35, 0.175, 0.08, 'Restore',  true, _panel.players  )	
		_panel.b_remove_ = guiCreateButton ( 0.77, 0.21+0.35, 0.175, 0.08, 'Remove',  true, _panel.players  )
		_panel.b_team = guiCreateButton ( 0.35, 0.355+0.35, 0.175, 0.08, 'Set Team',  true, _panel.players  )	
		_panel.b_heal = guiCreateButton ( 0.56, 0.355+0.35, 0.175, 0.08, 'Heal',  true, _panel.players  )	
		_panel.b_gun = guiCreateButton ( 0.77, 0.355+0.35, 0.175, 0.08, 'Gun menu',  true, _panel.players  )
		_panel.b_healall = guiCreateButton ( 0.35, 0.5+0.35, (0.77-0.35)+0.175, 0.08, 'Heal all players',  true, _panel.players  )]]
			--guiSetEnabled( _panel.players ,false )
		  --// Druzyny
		  
		  _panel.teams = guiCreateTab ( "Teams", _panel.tab )
		  _panel.grid_teams = guiCreateGridList (   0.015, 0.025, 0.22, 0.825 ,true,  _panel.teams )
			guiGridListSetSelectionMode (_panel.grid_teams, 0 )
			guiGridListAddColumn ( _panel.grid_teams , 'Teams', 0.8 )
			local settings_l ={getTeamName(TableTeams[1]),getTeamName(TableTeams[2])}
				for k,v in ipairs(settings_l) do
					local row = guiGridListAddRow (_panel.grid_teams )
					guiGridListSetItemText ( _panel.grid_teams, row, 1, v, false, false )
				end
		  _panel.grid_teams2 = guiCreateGridList ( 0.25, 0.025, 0.735, 0.225 ,true, _panel.teams )
		  guiGridListAddColumn ( _panel.grid_teams2 , 'Setting name', 0.4 )
		  guiGridListAddColumn ( _panel.grid_teams2 , 'Value', 0.15 )
		  guiGridListAddColumn ( _panel.grid_teams2 , '', 0.35 )

				 
		local x,y = getRelativeByScreenPositionViaElement(298, 164,_panel.teams)		
		_panel.teams_color_pick = guiCreateStaticImage ( 0.255, 0.43,  x,y, "img/colors_palette.png", true, _panel.teams )	
		_panel.teams_color_f = guiCreateLabel ( 0.255, 0.28, 0.1, 0.07, 'Color:',true, _panel.teams )
		_panel.teams_color_i = guiCreateLabel ( 0.255, 0.38, 0.3, 0.07, 'To select the color use the color picker.',true, _panel.teams )
		guiSetFont ( _panel.teams_color_f,myFont3 )
		 _panel.teams_color_p1 = guiCreateLabel ( 0.35, 0.285, 0.1, 0.07, 'a',true, _panel.teams )
		guiSetFont ( _panel.teams_color_p1,myFont6 )
		_panel.teams_color_p2 = guiCreateLabel ( 0.4, 0.285, 0.1, 0.07, 'a',true, _panel.teams )
		guiSetFont ( _panel.teams_color_p2,myFont6 )
		 local fh = fileOpen( "img/colors_palette.png" )
		_panel.teams_color_pixels = fileRead(fh,fileGetSize ( fh ))
		fileClose(fh)
		_panel.teams_color_pixels = dxConvertPixels ( _panel.teams_color_pixels, 'plain', 100 )
		
		_panel.b_balance = guiCreateButton ( 0.04, 0.89, 0.28, 0.07, 'Auto Balance',  true,  _panel.teams  )
		_panel.b_switch = guiCreateButton ( 0.36, 0.89, 0.28, 0.07, 'Switch Sides',  true,  _panel.teams )
		_panel.b_reset = guiCreateButton ( 0.68, 0.89, 0.28, 0.07, 'Reset score and stats',  true,  _panel.teams  )
		
		--// Weapons
		
		_panel.weapon = guiCreateTab ( "Weapons", _panel.tab )
		_panel.weapon_combo = guiCreateComboBox ( 0.75, 0.75, 0.225, 0.25, "",true, _panel.weapon )
		guiComboBoxAddItem( _panel.weapon_combo, 'all gamemodes' ) guiComboBoxAddItem( _panel.weapon_combo, 'arena' ) guiComboBoxAddItem( _panel.weapon_combo, 'base' ) guiComboBoxAddItem( _panel.weapon_combo, 'bomb' )
		guiComboBoxSetSelected (_panel.weapon_combo, 0 )
		_panel.weapon_label = guiCreateLabel ( 0.74, 0.035, 0.25, 0.1, "Weapon",true, _panel.weapon )
		_panel.weapon_enabled = guiCreateCheckBox (  0.77, 0.15, 0.15, 0.05, " Enabled",  false, true, _panel.weapon )
		
		guiSetFont ( _panel.weapon_label ,myFont3 )	
		guiSetFont ( _panel.weapon_enabled ,myFont5 )	
		_panel.weapon_skill = guiCreateLabel ( 0.75, 0.22, 0.15, 0.05, "Skill:",true, _panel.weapon )
		guiSetFont (_panel.weapon_skill  ,myFont4 )
		_panel.weapon_gm = guiCreateLabel ( 0.75, 0.68, 0.15, 0.05, "Settings for:",true, _panel.weapon )
		guiSetFont (_panel.weapon_gm  ,myFont4 )	
		_panel.weapon_skill_1 = guiCreateRadioButton (  0.77, 0.29, 0.15, 0.05, " Poor",   true, _panel.weapon )
		_panel.weapon_skill_2 = guiCreateRadioButton (  0.77, 0.35, 0.15, 0.05, " Gangster",  true, _panel.weapon )
		_panel.weapon_skill_3 = guiCreateRadioButton (  0.77, 0.41, 0.15, 0.05, " Hitman",   true, _panel.weapon )
		guiSetFont (_panel.weapon_skill_1  ,myFont5 )	
		guiSetFont (_panel.weapon_skill_2  ,myFont5 )	
		guiSetFont (_panel.weapon_skill_3  ,myFont5 )	
		_panel.weapon_ammo = guiCreateLabel ( 0.75, 0.50, 0.12, 0.05, "Ammunition:",true, _panel.weapon )
		guiSetFont (_panel.weapon_ammo   ,myFont4 )	
		_panel.grid_ammo_edit =  guiCreateEdit ( 0.875, 0.50, 0.1, 0.05, "", true, _panel.weapon )
		guiSetFont ( _panel.grid_ammo_edit, myFont5 )	
		_panel.weapon_limit = guiCreateLabel ( 0.75, 0.59, 0.15, 0.05, "Limit per team:",true, _panel.weapon )
		guiSetFont (_panel.weapon_limit, myFont4 )	
		_panel.grid_limit_edit =  guiCreateEdit ( 0.9, 0.59, 0.075, 0.05, "", true, _panel.weapon )
		guiSetFont ( _panel.grid_limit_edit, myFont5 )	
		_panel.grid_weapons_1 = guiCreateGridList (   0.015, 0.025, 0.7, 0.95 ,true,  _panel.weapon )
		guiGridListAddColumn ( _panel.grid_weapons_1 , 'Weapons', 0.31 )
		guiGridListAddColumn ( _panel.grid_weapons_1 , 'Weapons', 0.31 )
		guiGridListAddColumn ( _panel.grid_weapons_1 , 'Weapons', 0.31 )

		guiGridListSetSortingEnabled ( _panel.grid_weapons_1, false )
		guiGridListSetSelectionMode (  _panel.grid_weapons_1, 2 )
		
		
		local settings_l = {1,2,3,4,5,6,7,8,9,22,23,24,25,26,27,28,29,31,32,30,33,34,35,36,37,38,16,17,18,41,42,10,11,12,14,15,44,45}

		local weapons_t_cat = { 
			Melee = { 1, 2, 3, 4, 5, 6, 7, 8, 9 },
			Handguns = { 22, 23, 24 },
			Shotguns = { 25, 26, 27 },
			['Sub-Machine Guns'] = { 28, 29, 32 },
			['Assault Rifles'] = { 30, 31 },
			['Rifles'] = { 33, 34 },
			['Heavy Weapons'] = { 35, 36, 37, 38 },
			['Projectiles'] = { 16, 17, 18, 39 },
			['Special'] = { 41, 42, 43, 44, 45, 46 },
			['Gifts/Other'] = { 10, 11, 12, 14, 15 },
		}
		local order = { 'Melee', 'Handguns', 'Shotguns', 'Sub-Machine Guns', 'Assault Rifles', 'Rifles', 'Heavy Weapons', 'Projectiles', 'Special', 'Gifts/Other' }	
		for i=1, 4 do 
				local row = guiGridListAddRow ( _panel.grid_weapons_1  )
				guiGridListSetItemText ( _panel.grid_weapons_1 , row, 1, '', false, false )
				guiSetFont ( guiCreateLabel ( 0.02, 0.07 + (0.038 * (row)),  0.305, 0.038, order[i]..":",true, _panel.grid_weapons_1) ,myFont )
					for k,v in ipairs( weapons_t_cat[ order[i] ] ) do	
						local row = guiGridListAddRow ( _panel.grid_weapons_1  )
						guiGridListSetItemText ( _panel.grid_weapons_1 , row, 1, getWeaponNameFromID( v ), false, false )
						guiGridListSetItemColor ( _panel.grid_weapons_1, row, 1, 180, 180, 180 )
					end
		end		
		local row = -1
		for i=5, 8 do 
				row = row+1
				guiGridListSetItemText ( _panel.grid_weapons_1 , row, 2, '', false, false )
				guiSetFont ( guiCreateLabel ( 0.31, 0.07 + (0.038 * (row)), 0.305, 0.038, order[i]..":",true, _panel.grid_weapons_1) ,myFont )
					for k,v in ipairs( weapons_t_cat[ order[i] ] ) do	
						row = row+1
						guiGridListSetItemText ( _panel.grid_weapons_1 , row, 2, getWeaponNameFromID( v ), false, false )
						guiGridListSetItemColor ( _panel.grid_weapons_1, row, 2, 180, 180, 180 )
					end
		end
		row = -1
		for i=9, 10 do 
				row = row+1
				guiGridListSetItemText ( _panel.grid_weapons_1 , row, 3, '', false, false )
				guiSetFont ( guiCreateLabel ( 0.62, 0.07 + (0.038 * (row)),  0.305, 0.038, order[i]..":",true, _panel.grid_weapons_1) ,myFont )
					for k,v in ipairs( weapons_t_cat[ order[i] ] ) do	
						row = row+1
						guiGridListSetItemText ( _panel.grid_weapons_1 , row, 3, getWeaponNameFromID( v ), false, false )
						guiGridListSetItemColor ( _panel.grid_weapons_1, row, 3, 180, 180, 180 )
					end
		end


		_panel.vehicles = guiCreateTab ( "Vehicles", _panel.tab )
		--VEHICLES
			_panel.grid_vehicles = guiCreateGridList ( 0.015, 0.025, 0.97, 0.95, true, _panel.vehicles)
			_panel.b_select =  guiCreateButton( 0.775, 0.9, 0.175, 0.05, 'Select / unSelect all', true, _panel.grid_vehicles  )
			guiGridListSetSelectionMode ( _panel.grid_vehicles, 3 )
			local t_sort_vehciles = { Automobiles={"Automobile"} ,Aircrafts={ "Plane", "Helicopter" }, Motorbikes={ "Bike" }, Others={ "Train", "Trailer", "BMX", "Monster Truck", "Quad" } }
			local t_sort_order = { Automobiles=1 , Aircrafts=3, Motorbikes=4, Others=5 }
				guiGridListAddColumn ( _panel.grid_vehicles , "Automobiles", 0.19 )
				guiGridListAddColumn ( _panel.grid_vehicles , "Automobiles cd", 0.19 )
				guiGridListAddColumn ( _panel.grid_vehicles , "Aircrafts", 0.19 )	
				guiGridListAddColumn ( _panel.grid_vehicles , "Motorbikes", 0.19 )	
				guiGridListAddColumn ( _panel.grid_vehicles , "Others", 0.19 )	
				
			local buffer_vehicles = { Automobiles={} , Aircrafts={}, Motorbikes={}, Boats={}, Others={} }
			for k,v in ipairs( { 602, 545, 496, 517, 401, 410, 518, 600, 527, 436, 589, 580, 419, 439, 533, 549, 526, 491, 474, 445, 467, 604, 426, 507, 547, 585,
								405, 587, 409, 466, 550, 492, 566, 546, 540, 551, 421, 516, 529, 592, 553, 577, 488, 511, 497, 548, 563, 512, 476, 593, 447, 425, 519, 520, 460,
								417, 469, 487, 513, 581, 510, 509, 522, 481, 461, 462, 448, 521, 468, 463, 586, 472, 473, 493, 595, 484, 430, 453, 452, 446, 454, 485, 552, 431, 
								438, 437, 574, 420, 525, 408, 416, 596, 433, 597, 427, 599, 490, 432, 528, 601, 407, 428, 544, 523, 470, 598, 499, 588, 609, 403, 498, 514, 524, 
								423, 532, 414, 578, 443, 486, 515, 406, 531, 573, 456, 455, 459, 543, 422, 583, 482, 478, 605, 554, 530, 418, 572, 582, 413, 440, 536, 575, 534, 
								567, 535, 576, 412, 402, 542, 603, 475, 441, 464, 501, 465, 564, 568, 557, 424, 471, 504, 495, 457, 539, 483, 508, 571, 500, 
								444, 556, 429, 411, 541, 559, 415, 561, 480, 560, 562, 506, 565, 451, 434, 558, 494, 555, 502, 477, 503, 579, 400, 404, 489, 505, 479, 442, 458 } ) do	
				local type_ = getVehicleType( v )
					for k1,v1 in pairs( t_sort_vehciles ) do	
						for k2,v2 in ipairs( v1 ) do	
							if type_ == v2 then
								table.insert( buffer_vehicles[k1], v )
								break
							end
						end
					end
			end
			for k,v in pairs( buffer_vehicles ) do	
				for k1,v1 in ipairs( v ) do	
					if k1 > 71 then
						guiGridListSetItemText ( _panel.grid_vehicles, k1-72, t_sort_order[k]+1, getVehicleNameFromModel( v1), false, false )
					else
						if k1 > guiGridListGetRowCount ( _panel.grid_vehicles ) then
							guiGridListAddRow ( _panel.grid_vehicles )
						end	
					guiGridListSetItemText ( _panel.grid_vehicles, k1-1, t_sort_order[k], getVehicleNameFromModel( v1), false, false )
					end
				end
			end		
			_panel.grid_buffor={}
		--
		--_panel.close = guiCreateButton ( 0.945, 0.063, 0.06, 0.064, "X", true, _panel.window )
				for k,v in pairs( _panel) do
					if type( v ) == 'userdata' and getElementType ( v ) == 'gui-gridlist' then
					guiGridListSetSortingEnabled ( v, false )
					end
				end	
		addEventHandler( "onClientGUIDoubleClick", getRootElement(), _panel_double_click )
	   addEventHandler ( "onClientGUIClick", getRootElement(), _panel_click)
	   addEventHandler ( "onClientGUIComboBoxAccepted", getRootElement(), _panel_click )
	   addEventHandler ( "onClientGUIChanged", getRootElement(), _panel_changed )
	   addEventHandler ( "onClientGUIComboBoxAccepted", _panel.weapon_combo, load_weapon_settings )
	   addEventHandler ( "onClientGUIComboBoxAccepted", _panel.screen, _panelScreenCall )
	   
	   showCursor(true)
	 --  callServer("_panel_load",localPlayer,false)	
		if _panel.read_only == true then

			
			for k1,v1 in pairs({ _panel.b_new, _panel.b_save, _panel.b_load, _panel.b_import, _panel.b_rename, _panel.b_delete, _panel.players, _panel.grid_teams2, _panel.teams_color_pick }) do
				guiSetEnabled ( v1, false )
			end
			

		end
				guiSetAlpha ( _panel.window, 1 )
		guiSetAlpha ( _panel.info, 0 )
		guiBringToFront ( _panel.window )
		blur_remote( true, 2.5, false )
	end
	
	
	function _panel_load_deafult_cfg( )
	--// DEFAULT
		_panel.setting_cat = {
			main = {
				{'auto balance:', false, {true, false} },
				{'auto swap:', true, {true, false} },
				{'countdown time:', 3, {3,4,5,6,7,8,9,10}},
				{'anti helli kill:', true, {true, false} },
				{'anti helli boom:', 'explosion reduced 2x', {'unchanged', 'explosion reduced 2x', 'explosion reduced 3x', 'explosion fully disabled'} },
				{'player health:', 100, 'integer', { 0, 200 } },
				{'player armor', 0, 'integer', { 0, 100 } },
				{'spectaor mode:', 'only team', {'only team', 'all teams'}},
				{'radar blips mode:', 'only team', {'only team', 'all teams'}},
				{'auto pause:', true, {true, false, 'only timeout'}},
				{'vehicles health bars:', true, {true, false} },
				{'vehicle tank explodable:', false, {true, false} },
				{'vote:', true, {true, false} },
				{'vote timeout:', 21, 'integer', {10,30}},
				{'vote allow updates:', true, {true, false}},
				{'alternative weapons balance:', true, {true, false} },
				{'only one heavy weapon:', false, {true, false} },
					},	
			gliteches = {
				{'crouchbug:', true, {true, false} },
				{'fastfire:', true, {true, false} },
				{'quickreload:', true, {true, false} },
				{'fastmove:', true, {true, false} },
				{'fastsprint:', false, {true, false} },
				{'crouch bug limiter:', false, {true, false} },
					},
			limits = {
				{'FPS Limit:', 61, 'integer', {0,999}},
				{'Min FPS:', 25, 'integer', {10,100}},
				{'Max Ping:', 150, 'integer', {0,999}},
				{'Max PacketLoss:', 20, 'float', {0,50}},
					},	
			weather = {
				{'weather:', 3, 'integer', {0,999}},
				{'weather blend:', 3, 'integer', {0,999}},
				{'time:', '12:00', 'time', {0, 24}},
				{'time locked', true, {true, false} },
				{'minute duration:', 99999, 'integer', {0,99999}},
					},
			miscellaneous = {
				{'blur leve:',  0, 'integer', {0,255}},
				{'game speed:',  1, 'integer', {0,10}},
				{'friendly fire:', false, {true, false} },
				{'gravity:',  0.008, 'float', {0, 10} },
				{'clouds:', false, {true, false} },
				{'birds:', false, {true, false} },
				{'ambient sound general:', false, {true, false} },
				{'ambient sound gunfire:', false, {true, false} },
				{'interior sounds:', false, {true, false} },
					},
			arena = {
				{'spawn protect time:', 5, 'integer', {0,60}},
				{'time limit:', '06:00', 'time', {0, 24}},
				{'time to re-select weapons:', 20, 'integer', {0,999}},
					},
			base = {
				{'spawn protectt time:', 15,  'integer', {0,60}},
				{'time limit:', '07:00', 'time', {0, 24}},
				{'capture time:', 20,  'integer', {0,60}},
				{'capture mode:', 'intermittent', { 'intermittent', 'with continuation'}},
				{'car jacking:', false, {true, false} },
				{'time to re-select weapons:', 40, 'integer', {0,999}},
					},	
			bomb = {
				{'spawn protectt time:', 15,  'integer', {0,60}},
				{'time limit:', '10:00', 'time', {0, 24}},
				{'plant time', 5, 'integer', {0,60}},
				{'defuse time', 10, 'integer', {0,60}},
				{'bomb explode time', '01:00', 'time', {0, 24}},
				{'time to re-select weapons:', 20, 'integer', {0,999}},
					},
			teams = {
				[1] = {
					{'name:',  'Team#1', 'string'},
					{'skin:',  268, 'integer', {0,350}},
					{'score:',  0, 'integer', {0,9999}},
					{'color',  '225,225,0', 'color'},
						},
				[2] = {
					{'name:',  'Team#2', 'string'},
					{'skin:',  302, 'integer', {0,350}},
					{'score:',  0, 'integer', {0,9999}},
					{'color',  '225,0,225', 'color'},
						},
			},
			weapons = { 
					['all gamemodes'] = {
						[1] = { false, 1, 1, 0 },
						[2] = { false, 1, 1, 0 },
						[3] = { false, 1, 1, 0 },
						[4] = { false, 1, 1, 0 },
						[5] = { false, 1, 1, 0 },
						[6] = { false, 1, 1, 0 },
						[7] = { false, 1, 1, 0 },
						[8] = { false, 1, 1, 0 },
						[9] = { false, 1, 1, 0 },
						[10] = { false, 1, 1, 0 },
						[11] = { false, 1, 1, 0 },
						[12] = { false, 1, 1, 0 },
						[13] = { false, 1, 1, 0 },
						[14] = { false, 1, 1, 0 },
						[15] = { false, 1, 1, 0 },
						--
						[22] = { true, 2, 120, 0 },
						[23] = { true, 3, 120, 0 },
						[24] = { true, 3, 90, 0 },
						--
						[25] = { true, 3, 120, 0 },
						[26] = { false, 2, 80, 2 },
						[27] = { false, 2, 60, 1 },
						--
						[28] = { false, 2, 100, 2 },
						[32] = { false, 2, 100, 2 },
						[29] = { true, 3, 300, 0 },
						--
						[30] = { true, 3, 300, 4 },
						[31] = { true, 3, 250, 3 },
						--
						[33] = { true, 3, 150, 0 },
						[34] = { true, 3, 80, 3 },
						--
						[35] = { true, 3, 1, 1 },
						[36] = { false, 3, 0, 0 },
						[37] = { false, 3, 0, 0 },
						[38] = { false, 3, 0, 0 },
						--
						[16] = { true, 3, 1, 0 },
						[17] = { false, 3, 0, 0 },
						[18] = { false, 3, 0, 0 },
						[39] = { false, 3, 0, 0 },
						--
						[41] = { false, 3, 0, 0 },
						[42] = { false, 3, 0, 0 },
						[43] = { false, 3, 0, 0 },
						--
						[44] = { false, 3, 0, 0 },
						[45] = { false, 3, 0, 0 },
						[46] = { false, 3, 0, 0 },
						},
							
					['arena'] = {},
					['base'] = {},
					['bomb'] = {},
				
					},
		vehicles = { 496, 517, 445, 507, 593, 487, 488, 497, 469, 513, 481, 462, 463, 468, 522, 461, 510, 473, 493, 595, 484, 453, 452, 446, 454, 431, 437, 408, 490, 470, 443, 573, 486, 578, 422, 554, 475, 603, 429, 541, 415, 480, 411, 555 }			
		}
	end
	
	local additional_data = {}
	
	
		function _panel_resendData( data, player )
		local _antiCheatCode = {
				[1] = 'health/armour hack',
				[4] = 'trainer',
				[5] = 'trainer',
				[6] = 'trainer{ player movement, health/damage, weapons, money, gamespeed, game cheats, aimbot }',
				[7] = 'trainer',
				[8] = 'unauthorized mods',
				[11] = 'trainer',
				[11] = 'Dll injector / Trainer',
				[13] = 'Data files issue',
				[17] = 'Speed / wall hacks',
				[21] = 'trainer / Custom gta_sa.exe',
				[26] = 'Anti-cheat component blocked',
				[12] = 'custom D3D9.DLL',
				[14] = 'virtual machines such as VMWare',
				[15] = 'disabled driver signing',
				[16] = 'disabled anti-cheat component',
				[20] = 'non-standard gta3.img',
				[22] = 'resource download errors/corruption',
				[28] = 'Linux Wine',
				}
							
		
		local text_ = ''
			for k ,v in ipairs( data ) do
				if v[1] == 'Anti cheats' then
					text_ = text_..v[1]..': '
					for i=1, #v[2] do 
					local res_ult = gettok ( v[2], i, ',' )
						if res_ult then
							text_ = text_ .. _antiCheatCode[ tonumber(res_ult) ]..'\n'
						else
							break
						end	
					end	
				else
					if v[1] == 'Resolution' then
						additional_data[ player ] = {res = v[2]}
						text_ = text_..v[1]..': '.. tostring( v[2][1]..'x'..v[2][2]	) ..'\n'
					else
						text_ = text_..v[1]..': '.. tostring( v[2] ) ..'\n'
					end	
				end	
			end
			guiSetText( _panel.memo_players, text_ )
		end
	
	
	function _panel_load_cfg( table, d_mode, name )
	--// Loading...
	_panel_load_deafult_cfg( )
		if d_mode == nil then
	
			for k,v in ipairs( { 'main', 'gliteches', 'limits', 'weather', 'miscellaneous', 'arena', 'base', 'bomb' } ) do
				for k1,v1 in ipairs( table[v] ) do
					_panel.setting_cat[v][k1][2] = table[v][k1][2] 
				end
			end
				for j=1,2 do
					for k1,v1 in ipairs( _panel.setting_cat['teams'][j] ) do
						_panel.setting_cat['teams'][j][k1][2] = table['teams'][j][k1][2]
					end
				end	
				_panel.setting_cat.weapons = table.weapons
				_panel.setting_cat.vehicles = table.vehicles
				
		end
	--// TAB: Settings
			for i=0, guiGridListGetRowCount ( _panel.grid_configs )-1 do
				if name == guiGridListGetItemText ( _panel.grid_configs, i, 1 ) then
					_panel.confing_a = i
					guiGridListSetSelectedItem ( _panel.grid_configs, i,1,true )
					guiSetText( _panel.edit_configs, name )
				end
			end
	
			guiGridListClear( _panel.grid_settings )
			for k,v in ipairs(_panel.setting_cat.main) do
				local row = guiGridListAddRow (_panel.grid_settings )
				guiGridListSetItemText ( _panel.grid_settings, row, 1, v[1], false, false )

				guiGridListSetItemText ( _panel.grid_settings, row, 2, tostring(v[2]), false, false )
				guiGridListSetItemText ( _panel.grid_settings, row, 3, " ", false, false )
			end
			
			guiGridListSetSelectedItem ( _panel.grid_settings_menu, 0, 1,true )
			
		--// TAB: Teams
			_panel.setting_cat.teams[1][4][2]  = { gettok ( _panel.setting_cat.teams[1][4][2] , 1, string.byte(',') ), gettok ( _panel.setting_cat.teams[1][4][2] , 2, string.byte(',') ), gettok ( _panel.setting_cat.teams[1][4][2] , 3, string.byte(',') ) }
			_panel.setting_cat.teams[2][4][2]  = { gettok ( _panel.setting_cat.teams[2][4][2] , 1, string.byte(',') ), gettok ( _panel.setting_cat.teams[2][4][2] , 2, string.byte(',') ), gettok ( _panel.setting_cat.teams[2][4][2] , 3, string.byte(',') ) }
		


			load_team_settings()
			guiGridListSetSelectedItem ( _panel.grid_teams, 0, 1,true )
		--// TAB: Weapons
			guiGridListSetSelectedItem ( _panel.grid_vehicles, -1, -1,true )

		_panel.grid_buffor={}
		--// TAB: Vehicles
		for i=1, guiGridListGetColumnCount ( _panel.grid_vehicles ) do
			for j=0, guiGridListGetRowCount ( _panel.grid_vehicles )-1 do
				local id =  getVehicleModelFromName( guiGridListGetItemText ( _panel.grid_vehicles, j, i ) )
					for k,v in ipairs( _panel.setting_cat.vehicles ) do
						if v == id then
						--	tab	le.insert ( _panel.grid_buffor, {j,i} )
							_panel.grid_buffor[ #_panel.grid_buffor+1 ] = {j,i}
							break
						end
					end
			end
		end						
		for k,v in ipairs(_panel.grid_buffor) do
			guiGridListSetSelectedItem ( _panel.grid_vehicles, v[1],v[2] ,false )
		end
			guiGridListSetSelectedItem( _panel.grid_weapons_1, 1, 1, true )	
			load_weapon_settings()	

			
	end
	
	
	
	
	
	
	
	


	
	
	function _panel_double_click()
		if source ~= _panel.grid_teams and source ~= _panel.grid_vehicles  and source ~= _panel.grid_weapons_1 and source ~= _panel.grid_players and source ~= _panel.grid_settings_menu then
			for k,v in pairs( _panel) do
				if v == source then
				--	
					_panel_edit_window(v)
					return false
				end
			end	
		end	
	end
	
	function load_team_settings()
	local row, column = guiGridListGetSelectedItem ( _panel.grid_teams )
		if row == -1 then
			guiGridListSetSelectedItem ( _panel.grid_teams, 0, 1 )
			row, column = guiGridListGetSelectedItem ( _panel.grid_teams )
		end	
			local name = guiGridListGetItemText ( _panel.grid_teams, row, column )	
			local m_fix = {[TableTeams[1]]=1,[TableTeams[2]]=2}
			guiGridListClear (  _panel.grid_teams2 )
			_panel.current_team = m_fix[getTeamFromName( name )]
				for k,v in ipairs( _panel.setting_cat.teams[ m_fix[getTeamFromName( name )]] ) do
						if v[1] == 'color' then
						--	local r,g,b = gettok (v[2], 1, string.byte(',')),gettok (v[2], 2, string.byte(',')),gettok (v[2], 3, string.byte(',')) 
							guiLabelSetColor( _panel.teams_color_p1, unpack (v[2]) )
							guiLabelSetColor( _panel.teams_color_p2, unpack (v[2]) )
							break 
						end
						local row = guiGridListAddRow ( _panel.grid_teams2  )
						guiGridListSetItemText ( _panel.grid_teams2 , row, 1, v[1], false, false )
						guiGridListSetItemText ( _panel.grid_teams2 , row, 2, v[2], false, false )
				end		
	end
	
	function load_weapon_settings()
	local row, column = guiGridListGetSelectedItem ( _panel.grid_weapons_1 )
		if row ~= -1 then
			local name = guiGridListGetItemText ( _panel.grid_weapons_1, row, column )	
			guiSetText ( _panel.weapon_label, name )
			local table_ = _panel.setting_cat.weapons[ guiComboBoxGetItemText ( _panel.weapon_combo, guiComboBoxGetSelected ( _panel.weapon_combo ) ) ] [ getWeaponIDFromName ( name ) ]
			-- 
			if type( table_ ) == 'nil' then
				table_ = _panel.setting_cat.weapons[ 'all gamemodes' ] [ getWeaponIDFromName ( name ) ]
			end
			guiCheckBoxSetSelected ( _panel.weapon_enabled , table_[1] )
			guiRadioButtonSetSelected ( _panel['weapon_skill_'..tostring( table_[2] ) ], true )
			guiSetText( _panel.grid_ammo_edit, tostring( table_[3] ) )
			guiSetText( _panel.grid_limit_edit, tostring( table_[4] ) )
		end
	end

	
	function getPosByRowCount(count)
		return count * 0.04167
	end
	
	function guiGridListAdjustHeight ( gridlist )
		if getElementType ( gridlist ) ~= "gui-gridlist" then return end
		local width = guiGetSize ( gridlist, false )
		guiSetSize ( gridlist, width, 25 + ( guiGridListGetRowCount ( gridlist ) * 16 ), false )
	end
	
	function _panel_onRenderFix ( )
		if  not isConsoleActive () then
			guiSetSelectedTab (_panel.tab, _panel.settings )
			guiBringToFront( _panel.optioncombo )
		end
	end
	
	function _panel_edit_window(element)
		if guiGetEnabled  ( element ) == true and getElementType ( element ) ==  'gui-gridlist' then
			local row, column = guiGridListGetSelectedItem ( element )
			local name = guiGridListGetItemText ( element, row, column )
				if row ~= -1 then
					if guiGetSelectedTab ( _panel.tab ) == _panel.settings then
					local c,r = guiGridListGetSelectedItem (  _panel.grid_settings_menu )
						if c ~= -1 and r ~= -1  then
							local cat_name = guiGridListGetItemText ( _panel.grid_settings_menu, c, r )
								for k,v in ipairs( _panel.setting_cat[cat_name] ) do
									if v[1] == name and type( v[3] ) == "table" then
									_panel.alphaStuff = { guiCreateStaticImage ( 0, 0, 1, 1, "img/white_pixel.png", true, _panel.grid_settings_menu ), guiCreateStaticImage ( 0, 0, 1, 1, "img/white_pixel.png", true, _panel.grid_settings ), guiCreateStaticImage ( 0, 0, 1, 1, "img/white_pixel.png", true, _panel.window ) }
										for a,b in ipairs( _panel.alphaStuff ) do
											guiSetAlpha( b, 0.1 )
										end
									_panel.optionCache = { row, cat_name, k, type(v[3][1]) }	
									_panel.optioncombo = guiCreateGridList ( 0.4, getPosByRowCount(row+1), 0.35, 0.1,true, _panel.grid_settings )
									
									guiGridListAddColumn (  _panel.optioncombo , 'Select the option:', 0.9 )
										for k1,v1 in pairs( v[3] ) do
											local rw = guiGridListAddRow ( _panel.optioncombo )
												guiGridListSetItemText ( _panel.optioncombo, rw, 1, tostring(v1), false, false )
										end
										for k1,v1 in pairs( {"", "              cancel"} ) do
											local rw = guiGridListAddRow ( _panel.optioncombo )
												guiGridListSetItemText ( _panel.optioncombo, rw, 1, v1, false, false )
										end
										guiGridListAdjustHeight (_panel.optioncombo )
										--guiCreateLabel ( 0, 0.55, 1, 0.2, "", true,  _panel.optioncombo )
										addEventHandler ( "onClientRender", getRootElement(), _panel_onRenderFix )
										return true
									end
								end
						end
					end
					
				_panel.cache_edit = {element , row, 2 }		
						
				if element == _panel.grid_teams2 then

					for k,v in ipairs( _panel.setting_cat.teams[ _panel.current_team ] ) do
						if v[1] == name then
						
							_panel.cache_edit[4] = _panel.setting_cat.teams[ _panel.current_team ][k][3] 
							_panel.cache_edit[5] = _panel.setting_cat.teams[ _panel.current_team ][k][4] 
							break
						end
					end	
					

					--_dynamic_team_settings( )
				else
					local c,r = guiGridListGetSelectedItem (  _panel.grid_settings_menu )
					local cat_name = guiGridListGetItemText ( _panel.grid_settings_menu, c, r )
					for k,v in ipairs( _panel.setting_cat[ cat_name ] ) do
						if v[1] == name then

							_panel.cache_edit[4] = _panel.setting_cat[ cat_name ][k][3] 
							_panel.cache_edit[5] = _panel.setting_cat[ cat_name ][k][4] 
							break
						end
					end	
				end	
					guiGridListSetSelectionMode ( element, 2 )
					guiGridListSetSelectedItem ( element, row,2)
					guiGridListSetItemText (  element, row, 3, "   ( Use the keyboard to write )", false, false )
					guiGridListSetItemText (  element, row, 2, "", false, false )			
					_panel.cache_edit.timer = setTimer( function() if guiGridListGetSelectedItem ( element ) == -1 then guiGridListSetSelectedItem ( element, row,2) else guiGridListSetSelectedItem ( element, -1, 0) end end,500,0 )
					bindKey ( "backspace", "down",  _panel_onCharacter_action )
					bindKey ( "enter", "down",  _panel_onCharacter_action )
					addEventHandler("onClientCharacter", getRootElement(), _panel_onCharacter)
				--	guiSetInputMode ( "no_binds" )
					 toggleAllControls ( false, false )
				end
		end			
	end
	
	function convertType( v, t )
		if t == 'boolean' then
			if v == 'true' then
				return true
			else
				return false
			end
		else
			return tonumber( v ) or tostring( v )
		end
	end
	
	function _panel_saveOption_Table( element, row )
		local row, column = guiGridListGetSelectedItem ( element )
		local name = guiGridListGetItemText ( element, row, 1 )
		local setting = guiGridListGetItemText ( element, row, 2 )
		guiGridListSetSelectedItem ( _panel.cache_edit[1], -1, 0 )
		--

		if _panel.cache_edit[4] == 'integer' or _panel.cache_edit[4] == 'float' then
				setting = math.min( math.max( tonumber( setting ), _panel.cache_edit[5][1] ), _panel.cache_edit[5][2])
				guiGridListSetItemText ( element, row, 2, setting, false, true )
				if element == _panel.grid_teams2 then
					if name == "skin:" then
						if _panel.current_team == 1 then
							 callServer( "_dynamic_team_settings", nil, nil, nil, { setting, nil } )
						else
							callServer( "_dynamic_team_settings", nil, nil, nil, { nil, setting } )
						end
						
					elseif name == "score:" then
						if _panel.current_team == 1 then
							 callServer( "_dynamic_team_settings", nil, nil, { setting, nil } )
						else
							callServer( "_dynamic_team_settings", nil, nil, { nil, setting } )
						end
					end
				
				end
		end
	

			if element == _panel.grid_teams2 then
				for k,v in ipairs( _panel.setting_cat.teams[ _panel.current_team ] ) do
					if v[1] == name then
						_panel.setting_cat.teams[ _panel.current_team ][k][2] = setting
						 callServer( "_dynamic_team_settings", { _panel.setting_cat.teams[ 1 ][1][2], _panel.setting_cat.teams[ 2 ][1][2] } )
						--break
					end
				end	
				
				--[[		[2] = {
					{'name:',  'Team2', 'string'},
					{'skin:',  101, 'integer', {0,350}},
					{'score:',  0, 'integer', {0,9999}},
					{'color',  '225,0,225', 'color'},]]
				
				
				
				local s_1, s_2 = guiGridListGetSelectedItem ( _panel.grid_teams )
					guiGridListClear (  _panel.grid_teams )
					local settings_l ={ _panel.setting_cat.teams[ 1 ][1][2], _panel.setting_cat.teams[ 2 ][1][2] }
					for k,v in ipairs(settings_l) do
						local row = guiGridListAddRow (_panel.grid_teams )
						guiGridListSetItemText ( _panel.grid_teams, row, 1, v, false, false )
					end
					guiGridListSetSelectedItem (  _panel.grid_teams, s_1, s_2 )
			else
				local c,r = guiGridListGetSelectedItem (  _panel.grid_settings_menu )
				local cat_name = guiGridListGetItemText ( _panel.grid_settings_menu, c, r )
				for k,v in ipairs( _panel.setting_cat[ cat_name ] ) do
					if v[1] == name then
						_panel.setting_cat[ cat_name ][k][2] = setting
						return
					end
				end	
			end
	end
	
	function _panel_onCharacter_action( key )
		if key == "backspace" then
			local text = guiGridListGetItemText ( unpack ( _panel.cache_edit ) )
			guiGridListSetItemText ( _panel.cache_edit[1], _panel.cache_edit[2], _panel.cache_edit[3], string.sub(text, 1,string.len(text)-1)  , false, false )		
		elseif key == "enter" then	
			unbindKey ( "backspace", "down",  _panel_onCharacter_action )
			unbindKey ( "enter", "down",  _panel_onCharacter_action )
			--guiSetInputMode ( "allow_binds" )
			toggleAllControls ( true, false )
			removeEventHandler("onClientCharacter", getRootElement(), _panel_onCharacter )
			killTimer( _panel.cache_edit.timer )
			guiGridListSetItemText (  _panel.cache_edit[1], _panel.cache_edit[2], 3, " ", false, false )	
			guiGridListSetSelectionMode ( _panel.cache_edit[1], 1 )
			guiGridListSetSelectedItem (  _panel.cache_edit[1], _panel.cache_edit[2], 1 )
			_panel_saveOption_Table( _panel.cache_edit[1], _panel.cache_edit[2] )
			playSound ( "sounds/blip.wav" )
		end
	end
	
		--	{'Max Ping:', 150, 'integer', {0,999}},
		--	{'Max PacketLoss:', 20, 'float', {0,50}},
	
	function _panel_onCharacter( char )
		local text = guiGridListGetItemText (  _panel.cache_edit[1], _panel.cache_edit[2], _panel.cache_edit[3] )
		if _panel.cache_edit[4] == 'string' then
			guiGridListSetItemText ( _panel.cache_edit[1], _panel.cache_edit[2], _panel.cache_edit[3], text..char, false, false )	
		elseif _panel.cache_edit[4] == 'integer' then
				if type( tonumber( char ) ) == 'number' then
					--guiGridListSetItemText ( _panel.cache_edit[1], _panel.cache_edit[2], _panel.cache_edit[3], math.min( math.max( tonumber( text..char ), _panel.cache_edit[5][1] ), _panel.cache_edit[5][2]) , false, false )	
					guiGridListSetItemText ( _panel.cache_edit[1], _panel.cache_edit[2], _panel.cache_edit[3], text..char, false, false )	
				end	
		elseif _panel.cache_edit[4] == 'float' then	
			if ( char == "." and checkDots( text ) == 0 ) or type( tonumber( char ) ) == 'number' then
				guiGridListSetItemText ( _panel.cache_edit[1], _panel.cache_edit[2], _panel.cache_edit[3], text..char, false, false )	
			end
		elseif _panel.cache_edit[4] == 'time' then
			if #text < 5 and type( tonumber( char ) ) == 'number' then
				if #text == 2 and string.find( text..char, ":") == nil  then
					guiGridListSetItemText ( _panel.cache_edit[1], _panel.cache_edit[2], _panel.cache_edit[3], text..":"..char, false, false )
				else
					guiGridListSetItemText ( _panel.cache_edit[1], _panel.cache_edit[2], _panel.cache_edit[3], text..char, false, false )	
				end
			elseif char == ':' and string.find( text, ":") == nil and #text == 1  then
				guiGridListSetItemText ( _panel.cache_edit[1], _panel.cache_edit[2], _panel.cache_edit[3], string.format( "%.2i:", text), false, false )
			end
		end
	
			
		--guiGridListSetSelectedItem (  _panel.cache_edit[1], _panel.cache_edit[2], 1)		
	end
	
	
	function checkDots( s )
		for i=1, #s do
			if string.byte( s, i, i+1) == 46 then
				return 1
			end
		end
		return 0
	end
	
	
	function _panel_update_table(grid,index,value)
		if grid == _panel.grid_weapons_2  then
			local row, column = guiGridListGetSelectedItem ( _panel.grid_weapons_1 )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_weapons_1, row, column )	
					_panel.weapons_l[ getWeaponIDFromName (name) ][index] = value
				end
		elseif grid == _panel.grid_teams2  then	
			local row, column = guiGridListGetSelectedItem ( _panel.grid_teams )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_teams, row, column )	
						local m_fix = {[TableTeams[1]]=1,[TableTeams[2]]=2}
					_panel.teams_l[ m_fix [getTeamFromName( name )] ][index] = value
					if index == 'Score' then
						setElementData ( getTeamFromName( name ),"Score",tonumber(value)  )	 
					end
				
				end	
		end
		
	end
	

	function _panel_changed( )
		if source == _panel.grid_limit_edit or source == _panel.grid_ammo_edit then
			local row, column = guiGridListGetSelectedItem ( _panel.grid_weapons_1 )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_weapons_1, row, column )	
					guiSetText ( _panel.weapon_label, name )
					local table_ =  guiComboBoxGetItemText ( _panel.weapon_combo, guiComboBoxGetSelected ( _panel.weapon_combo ) ) 
					if type( _panel.setting_cat.weapons[ table_ ][ getWeaponIDFromName ( name ) ] ) == 'nil' then
						_panel.setting_cat.weapons[ table_ ][ getWeaponIDFromName ( name ) ] = {}
					end
						if source == _panel.grid_ammo_edit then
							_panel.setting_cat.weapons[ table_ ] [ getWeaponIDFromName ( name ) ] [3] = guiGetText( source )
						elseif source == _panel.grid_limit_edit then
							_panel.setting_cat.weapons[ table_ ] [ getWeaponIDFromName ( name ) ] [4] = guiGetText( source )
						end
				end
		end
	end
	
	function _panel_vehGridAdd( source, c, r )
		local insert = true
		 if c == nil or r == nil then c,r = guiGridListGetSelectedItem (  source ) end
			for k,v in ipairs(_panel.grid_buffor) do
				if v[1] == c and v[2] == r then
					guiGridListSetSelectedItem ( source, 0,0)
					table.remove(_panel.grid_buffor,k)
					 insert = false
				end
			end
			for k,v in ipairs(_panel.grid_buffor) do
				guiGridListSetSelectedItem ( source, v[1],v[2] ,false )
			end
			if c ~= -1 and r ~= -1  then
				if insert == true then
					table.insert(_panel.grid_buffor, {c,r})
				else
					guiGridListSetSelectedItem ( source, 0,0)
					for k,v in ipairs(_panel.grid_buffor) do
						guiGridListSetSelectedItem ( source, v[1],v[2] ,false )
					end
				end
			end	
	
	
	end
	
	--addEventHandler("onClientGUITabSwitched", getRootElement( ), function() playSound ( "sounds/blip.wav" ) end )
	
	function _panelScreenCall( combobox )
	
			local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
							local item = guiComboBoxGetSelected( combobox)
							local text = guiComboBoxGetItemText( combobox, item)
							
								local x, y = unpack( additional_data[player].res )
									if text == 'Screenshot: 1/2 screen' then
										x, y = math.cut( x/2 ), math.cut( y / 2 )
									elseif text == 'Screenshot: 1/4 screen' then
										x, y = math.cut( x/4 ), math.cut( y / 4 )
									end	
									additional_data[player].sc_res = { x, y }	
								callServer( 'takePlayerScreenShot', player, x, y, getPlayerName( localPlayer ), 36, 65536 )
		
							end	
				end	
	
	end

addEvent ( "sendScreenData", true )
 
local screen_window_c = {}

function sendScreenDataf ( data, player )
	
	local x, y = unpack( additional_data[player].sc_res )
		if x > screenWidth*0.9 then
			local scalar =  ( screenWidth*0.9 ) / x
			x, y = x * scalar, y * scalar
		end
		local _t_g = {}
		math.randomseed(  getRealTime( ).timestamp   )
		for i=1, math.random ( 4, 9 ) do 
		
			local rrr = { math.random( 48, 57 ), math.random( 65, 90 ), math.random( 97, 122 ) }
			table.insert(_t_g, rrr[ math.random( 1, 3 )] )
		end
	local name = string.char( unpack( _t_g ) )..'.jpg'
	
	
	local newFile = fileCreate( name )
	fileWrite(newFile, data )  
	local size =  math.ceil(fileGetSize ( newFile ) / 1024) ..' KB '
	fileClose(newFile)

	local _index = #screen_window_c +1
	screen_window_c[ _index ] = { player =  getPlayerName( player), raw = data } 
	screen_window_c[_index ].window = guiCreateWindow( ( screenWidth - x+54 ) / 2, ( screenHeight - y+18 ) / 2, x+54, y+19, getPlayerName( player) .. ' ( Quality: 36%, '..additional_data[player].sc_res[1]..'x'..additional_data[player].sc_res[2]..', '..size..' )', false )
	guiCreateStaticImage ( 27,  19, x, y, name, false, screen_window_c[_index ].window )
	fileDelete( name )
	screen_window_c[_index ].close = guiCreateButton ( 0, 18, 19, y, 'C\nL\nO\nS\nE',  false, screen_window_c[_index ].window )
	screen_window_c[_index ].save = guiCreateButton ( 27+x, 18, 19, y, 'S\nA\nV\nE',  false, screen_window_c[_index ].window )
	guiSetFont ( screen_window_c[_index ].close, myFont )
	guiSetFont ( screen_window_c[_index ].save, myFont )
	
	 addEventHandler ( "onClientGUIClick", screen_window_c[_index ].close, _onScreenGClick, false )
	 addEventHandler ( "onClientGUIClick", screen_window_c[_index ].save, _onScreenGClick, false )
	 guiBringToFront( screen_window_c[_index ].window )
end
 


addEventHandler ( "sendScreenData", getRootElement(), sendScreenDataf )
	
	
	function _onScreenGClick( )
		for k, v in pairs( screen_window_c ) do 
			if v.close == source then
				 removeEventHandler ( "onClientGUIClick", v.close, _onScreenGClick, false )
				removeEventHandler ( "onClientGUIClick", v.save, _onScreenGClick, false )
				destroyElement( screen_window_c[k ].window )
				screen_window_c[k ] = {}
				
			elseif v.save == source then	

			local time_ = getRealTime(  )
			local patch = "basicmode-core/screenshots/"..v.player.." "..1900+time_.year.."-"..string.format("%.2i-%.2i-%.2i-%.2i-%.2i", time_.month+1, time_.monthday, time_.hour, time_.minute, time_.second or 0 )..'.jpg'
					local newFile = fileCreate( ":"..patch  )
					fileWrite(newFile, v.raw )  
					fileClose(newFile)
			outputChatBox( "[INFO] #FFFFFF Screenshot saved in: '(MTA Folder)/mods/deathmatch/resources/#c8c8c8"..patch.."'.", 255, 0, 0, true )		
			end
		
		end
	
	end
	

	
	function _panel_click(but, state, cX, cY)
		if getElementType( source ) == "gui-tabpanel" or getElementType( source ) == "gui-gridlist"   or getElementType( source ) == "gui-radiobutton" or getElementType( source ) == "gui-button"  or getElementType( source ) == "gui-staticimage"   or getElementType( source ) == "gui-checkbox" then
				playSound ( "sounds/blip.wav" )
		end	
		if source == _panel.optioncombo then
			local c,r = guiGridListGetSelectedItem (  source )
				if c ~= -1 and r ~= -1  then
					local option = guiGridListGetItemText ( source, c, r )
					if option == "" then guiGridListSetSelectedItem ( source, 0, 0 ) return end
					for a,b in ipairs( _panel.alphaStuff ) do
						destroyElement( b )
					end
					removeEventHandler ( "onClientRender", getRootElement(), _panel_onRenderFix )
					guiGridListClear ( _panel.optioncombo )
					destroyElement( _panel.optioncombo )
					if option == "              cancel" then
						return
					end	
					guiGridListSetItemText ( _panel.grid_settings, _panel.optionCache[1], 2, option, false, false  )
					_panel.setting_cat[ _panel.optionCache[2]][ _panel.optionCache[3]][2] =  convertType( option, _panel.optionCache[4] ) 
					_panel.optioncombo = nil _panel.optionCache = nil _panel.alphaStuff = nil
				end
		elseif source == _panel.grid_configs then
			local r,c = guiGridListGetSelectedItem ( source )
				if c ~= -1 and r ~= -1  then
					local option = guiGridListGetItemText ( source, r, 1 )
					guiSetText( _panel.edit_configs, option )
				else
					guiGridListSetSelectedItem ( _panel.grid_configs, _panel.confing_a,1,true )
					local option = guiGridListGetItemText ( source, _panel.confing_a, 1 )
					guiSetText( _panel.edit_configs, option )
				end
		
		elseif source == _panel.teams_color_pick then
		 local x,y = 0,0
		 for k, v in ipairs( {_panel.mainTab, _panel.tab, _panel.teams_color_pick } ) do
			local bX, bY = guiGetPosition( v, false )
			x = x + bX y = y + bY
		 end
		 local bX, bY = guiGetPosition( _panel.tab, false )
		 y = y + bY+3 
		local r, g, b = dxGetPixelColor( _panel.teams_color_pixels, cX-x, cY-y )
		guiLabelSetColor( _panel.teams_color_p1, r, g, b)
		guiLabelSetColor( _panel.teams_color_p2, r, g, b)
		local row, column = guiGridListGetSelectedItem ( _panel.grid_teams )
			if row ~= -1 then
				local name = guiGridListGetItemText ( _panel.grid_teams, row, column )	
				local m_fix = {[TableTeams[1]]=1,[TableTeams[2]]=2}
				_panel.setting_cat.teams[ m_fix[getTeamFromName( name )]][4][2] = { r, g, b }
						if _panel.current_team == 1 then
							 callServer( "_dynamic_team_settings", nil,  {  { r, g, b }, nil } )
						else
							callServer( "_dynamic_team_settings", nil,  { nil,  { r, g, b } } )
						end
				
			end
		elseif source == _panel.grid_settings_menu then
			local c,r = guiGridListGetSelectedItem (  source )
				if c ~= -1 and r ~= -1  then
					local cat_name = guiGridListGetItemText ( source, c, r )
					guiGridListClear ( _panel.grid_settings )
						for k,v in ipairs(_panel.setting_cat[cat_name]) do
						local row = guiGridListAddRow (_panel.grid_settings )
							guiGridListSetItemText ( _panel.grid_settings, row, 1, v[1], false, false )
							guiGridListSetItemText ( _panel.grid_settings, row, 2, tostring(v[2]), false, false )
						guiGridListSetItemText ( _panel.grid_settings, row, 3, " ", false, false )
					end
				else
					guiGridListSetSelectedItem ( _panel.grid_settings_menu, 0, 1,true )	
				end
		elseif source == _panel.grid_vehicles then
			 _panel_vehGridAdd( source )
		elseif source == _panel.grid_weapons_1  then
			load_weapon_settings()
		elseif source == _panel.b_balance  then	
		elseif source == _panel.b_switch  then	
			callServer('ChangeTeamAllPpl')		
		elseif source == _panel.b_reset  then	
			callServer('resetscore_cmd',localPlayer)	
		elseif source == _panel.b_delete  then	

			local name = guiGetText( _panel.edit_configs )
				if name == '' then
					return false
				elseif name == 'default' then
					
					return false
				else

				callServer( 'dbWith_cfgs_list' , 'del', localPlayer, name )
				end

		elseif source == _panel.b_new  then
		
			_panel_add_new( )
			_panel_save( )
			
		elseif source == _panel.b_save  then
			_panel_add_new( )
			_panel_save( )
		elseif source == _panel.b_save_as  then	
			_panel_save_as()	
		elseif source == _panel.grid_teams  then		
				load_team_settings()
		elseif source == _panel.grid_players  then	
			local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
								callServer("_pane_player_tab",localPlayer,player) 
							end	
				end	
		elseif source == _panel.memo_players then
			setClipboard ( guiGetText( _panel.memo_players ) )
			outputConsole (  '\n\n'..guiGetText( _panel.memo_players )..'\n\n')
		elseif source == _panel.b_load then
			local cfg_name = guiGetText( _panel.edit_configs )
				if cfg_name == 'default' then
					return _panel_load_cfg( nil, true, 'default' )
				end	
			callServer("_panel_load", localPlayer, cfg_name)	
		elseif source == _panel.b_kick then	
			local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
								_panel_edit_window_(source,player,'Kick reason:','kickPlayer')
							end	
				end		

		elseif source == _panel.b_name then
			local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
								_panel_edit_window_(source,player,'New name:','setPlayerName')
							end	
				end	
		elseif source == _panel.b_team then
				local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
								guiSetPosition ( _panel.window,1,1,true )
								change_team_window(player)
							end	
				end	
		elseif source == _panel.b_add_ then
			local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
								callServer("add_cmd",localPlayer,'add',getElementData(player,'ID'))	
							end	
				end	
		elseif source == _panel.b_select then
			if #_panel.grid_buffor < 432 then
				_panel.grid_buffor = {}
				for i=0, guiGridListGetColumnCount( _panel.grid_vehicles ) do 
					for j=0, guiGridListGetRowCount( _panel.grid_vehicles ) do 
						 guiGridListSetSelectedItem ( _panel.grid_vehicles , j, i ,false )
						 _panel_vehGridAdd( _panel.grid_vehicles, j, i )
					end
				end	
			else
				 guiGridListSetSelectedItem ( _panel.grid_vehicles , -1, -1 ,true )
				 _panel.grid_buffor = {}
			end	 
		elseif source == _panel.b_restore then
			local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
								restore_window_request('restore',getElementData(player,'ID'))
							end	
				end
		elseif source == _panel.b_remove_ then
			local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
								callServer("remove_cmd",localPlayer,'remove',getElementData(player,'ID'))	
							end	
				end			
		elseif source == _panel.b_heal then
			local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
								callServer("heal",localPlayer,'heal',getElementData(player,'ID'))	
							end	
				end			
		elseif source == _panel.b_gun then
			local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
								callServer("gunmenu_cmd",localPlayer,'gunmenu',getElementData(player,'ID'))	
							end	
				end				
		elseif source == _panel.b_healall then
			local row, column = guiGridListGetSelectedItem (_panel.grid_players )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_players, row, column )
						local player = getPlayerFromName(name)
							if player then
								callServer("healall",localPlayer,'healall',getElementData(player,'ID'))	
							end	
				end			
		elseif source == _panel.weapon_enabled or source == _panel.weapon_skill_1 or source == _panel.weapon_skill_2 or source == _panel.weapon_skill_3  then
			local row, column = guiGridListGetSelectedItem ( _panel.grid_weapons_1 )
				if row ~= -1 then
					local name = guiGridListGetItemText ( _panel.grid_weapons_1, row, column )	
					local table_ =  guiComboBoxGetItemText ( _panel.weapon_combo, guiComboBoxGetSelected ( _panel.weapon_combo ) ) 
					if type( _panel.setting_cat.weapons[ table_ ] [ getWeaponIDFromName ( name ) ] ) == 'nil' then
						-- zapisuje wszytsko
						_panel_weapon_saveall( table_, getWeaponIDFromName ( name ) )
						return
					end
						if source == _panel.weapon_enabled then
							_panel.setting_cat.weapons[ table_ ] [ getWeaponIDFromName ( name ) ] [1] = guiCheckBoxGetSelected ( source )
						else
							if source == _panel.weapon_skill_3 then
								_panel.setting_cat.weapons[ table_ ] [ getWeaponIDFromName ( name ) ] [2] = 3
							elseif source == _panel.weapon_skill_2 then
								_panel.setting_cat.weapons[ table_ ] [ getWeaponIDFromName ( name ) ] [2] = 2
							else
								_panel.setting_cat.weapons[ table_ ] [ getWeaponIDFromName ( name ) ] [2] = 1
							end
						end
				end
		end
	end	
	
	function _panel_add_new( )
			local name = guiGetText( _panel.edit_configs )
			if name == '' then
				return false
			elseif name == 'default' then
				
				return false
			else
				for j=0, guiGridListGetRowCount ( _panel.grid_configs )-1 do
					local id =  guiGridListGetItemText ( _panel.grid_configs, j, 1 ) 
						if id == name then
						
							return false
						end
				end
			local rTime = getRealTime( )
			callServer( 'dbWith_cfgs_list' , 'add', localPlayer,name, string.format("%.i-%.2i-%.2i", 1900+rTime.year, rTime.month+1,rTime.monthday ), getPlayerName( localPlayer)  )
			end
	end
	
	function _panel_weapon_saveall( idex_0, index_1 )
			_panel.setting_cat.weapons[ idex_0 ] [ index_1 ] = {}
			_panel.setting_cat.weapons[ idex_0 ] [ index_1 ] [1] = guiCheckBoxGetSelected ( _panel.weapon_enabled )
				if guiRadioButtonGetSelected( _panel.weapon_skill_3 ) == true then
					_panel.setting_cat.weapons[ idex_0 ] [ index_1 ] [2] = 3
				elseif guiRadioButtonGetSelected( _panel.weapon_skill_2 ) == true then
					_panel.setting_cat.weapons[ idex_0 ] [ index_1 ] [2] = 2
				elseif guiRadioButtonGetSelected( _panel.weapon_skill_1 ) == true then
					_panel.setting_cat.weapons[ idex_0 ] [ index_1 ] [2] = 1
				end
			_panel.setting_cat.weapons[ idex_0 ] [ index_1 ] [3] = guiGetText( _panel.grid_ammo_edit )
			_panel.setting_cat.weapons[ idex_0 ] [ index_1 ] [4] = guiGetText( _panel.grid_limit_edit )
	end
	
	--[[function _pane_player_tab(name,player,serial,ping,hp,version,ip)

		if getPedOccupiedVehicle ( player ) == false then
			guiSetText ( _panel.memo_players, 'Name: '..name..'\nIP: '..ip..'\nSerial: '..serial..'\nVersion: '..version..'\nPing: '..ping..'\nHP: '..getElementHealth(player))
		else
			guiSetText ( _panel.memo_players, 'Name: '..name..'\nIP: '..ip..'\nSerial: '..serial..'\nVersion: '..version..'\nPing: '..ping..'\nHP: '..getElementHealth(player)..'\nVehicle: '..getVehicleName(getPedOccupiedVehicle ( player ))..'( '..math.round(getElementHealth (getPedOccupiedVehicle ( player )),0)..' )')
		end
	end]]
	
	function _panel_save( )
		local name = guiGetText( _panel.edit_configs )
			if name == '' then
				return false
			elseif name == 'default' then
				
				return false
			else
				local low_fat_table = {} -- optimization to reduce connection traffic
					for k0,v0 in pairs(_panel.setting_cat) do
						low_fat_table[k0] = {}
							if k0 == 'weapons' then
								table.insert( low_fat_table[k0], v0 )	
							elseif k0 == 'teams' then
								for k1,v1 in ipairs( v0 ) do
								low_fat_table[k0][k1] = {}
									for k2,v2 in ipairs( v1 ) do
										table.insert( low_fat_table[k0][k1], k2, v2 )
										table.remove ( low_fat_table[k0][k1][k2], 3 )
									end	
								end
							else
								for k1,v1 in ipairs( v0 ) do
									table.insert( low_fat_table[k0], k1, v1 )
								--	table.remove ( low_fat_table[k0][k1], 3 )
								end
							end
					end
					low_fat_table.vehicles = {}
						for k,v in ipairs( _panel.grid_buffor ) do
							table.insert( low_fat_table.vehicles, getVehicleModelFromName( guiGridListGetItemText ( _panel.grid_vehicles, unpack( v ) ) ) )
						end
			callServer("_panel_save", name, low_fat_table )	
		end
	end	
	
	
	function _i_need_more_of_yourData( re_send )
		local _dx = dxGetStatus ( )
		callServer("_pane_player_tab_collect", re_send, localPlayer, {
		_dx.VideoCardName.. ' ( '.._dx.VideoCardRAM..' MB, PS: '.._dx.VideoCardPSVersion.. ' )', _dx.AllowScreenUpload, _dx.VideoMemoryFreeForMTA..' MB', _dx.SettingStreamingVideoMemoryForGTA..' MB', { screenWidth, screenHeight} })	
	end



	_initialLoaded( "admin_panel_client.lua" )	

end