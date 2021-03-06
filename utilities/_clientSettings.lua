_initialLoading[ "utilities/_clientSettings.lua" ] = function ( )

	
	client_settings = {
			dof = { enable = false, dof_blur = 0.9, dof_fades = 1, dof_fadee = 700, dof_skyb = 0.5, dof_bri = false, dof_briS = false },
			correction = { enable = false, satur = 1, contr = 0, hue = 0,  bright = 0},
			car = { enable = false},
			water = { enable = false},
			detail = { enable = false},
			bump = { enable = false},
			bloom = { enable = false},
			dynamic = { enable = false},
		}
		
	function _client_panel_save()
	local file =  xmlLoadFile( ":basicmode-core/$client_shaders.dat_") or xmlCreateFile  ( ":basicmode-core/$client_shaders.dat_","client" )
	local node = xmlFindChild ( file,'_client', 0 ) or xmlCreateChild ( file , '_client' )
		xmlNodeSetAttribute ( node,'_data', toJSON(client_settings) )
			xmlSaveFile ( file )
			xmlUnloadFile ( file )	
	end
	
	
	
	function _client_panel_load()
		local file = xmlLoadFile( ":basicmode-core/$client_shaders.dat_")
		if file == false then
			_client_panel_save()
			return false
		end
			local copy = {}
			copy = client_settings
		local node = xmlFindChild ( file,'_client', 0 )
		client_settings = fromJSON ( xmlNodeGetAttribute ( node, '_data' ) )
			for k, v in pairs( copy ) do
				if client_settings[ k ] == nil then
					client_settings[ k ] = v
				elseif type( client_settings[ k ] ) == 'table' then
					for k1, v1 in pairs( v ) do
						if client_settings[ k ][ k1 ] == nil then
							client_settings[ k ][ k1 ] = v
						end
					end	
				end
			end
		
		_onUpdateEvent ( )
	

	end
		
		function _stringFromBool ( bool )
			if bool then
				return ' ENABLED'
			end
			return ' DISABLED' 
		end
		
	function _onUpdateEvent ( )
			switchCarPaintReflect( client_settings.car.enable )
			switchWaterShine( client_settings.water.enable )
			handleOnClientSwitchDetail( client_settings.detail.enable )
			switchBumpMapping( client_settings.bump.enable )
			switchBloom( client_settings.bloom.enable )
		--	switchDynamicSky( client_settings.dynamic.enable )
			if client_settings.correction.enable then
				createColorCorrectionShader( )
				updateColorCorrectionShader( client_settings.correction.satur, client_settings.correction.bright, client_settings.correction.contr, client_settings.correction.hue )

			else
				disableColorCorrectionShader(  )   
			end	
			
			dofSwitch( client_settings.dof.enable )
			dofUpdateSettings( client_settings.dof.dof_blur, client_settings.dof.dof_bri, client_settings.dof.dof_fades, client_settings.dof.dof_fadee, client_settings.dof.dof_briS, client_settings.dof.dof_skyb  )

	end
	
	
		
	local guiShaders_t = {}
	local guiShaders_f = {}
	
	
	function guiShaders_f.setScrollBarFromData( )
	
	local _ = { dof_blur =  {'Blur ammount', 0, 10 },  dof_fades = {'Fade Start', 1, 100 },  dof_fadee = {'Fade End', 500, 2000 },  dof_skyb = {'Max sky blur', 0, 5 }, satur = {'Saturation', 0, 3 }, contr = { 'Contrast', 0, 1 }, hue = { 'Hue', 0, 360 }, bright = { 'Brightness', 0, 2 }  }
		for k, v in pairs( guiShaders_t.scrollBar ) do 
			local _index = 'correction'
				if string.find( k , 'dof' ) then
					_index = 'dof'
				end	
				guiSetText(  guiShaders_t.label[k], _[k][1]..': ( '..  client_settings[_index][k] ..' )' )
			
		guiScrollBarSetScrollPosition ( v,  (	(client_settings[_index][k]  /  _[k][3] ) - ( _[k][2]  /  _[k][3] )  )*100 )
		end
	end
	
	
	
	function guiShaders ( )
		if guiShaders_t.window then
			showCursor( false )
			destroyElement( guiShaders_t.window )
			guiShaders_t = {}
			_client_panel_save()
		
			return 0
		end
		guiShaders_t.window = guiCreateTabPanel ( (screenWidth-620)/2, (screenHeight-440)/2, 620, 440, false )
		guiShaders_t.main = guiCreateTab ( "Client settings", guiShaders_t.window )
		guiShaders_t.scroll = guiCreateTab ( "Shaders settings", guiShaders_t.window )
		guiSetSelectedTab ( guiShaders_t.window, guiShaders_t.scroll )
		guiShaders_t.doft = guiCreateLabel( 0.025, 0.05, 0.2, 0.05, "Depth of Field:", true, guiShaders_t.scroll  )
		guiLabelSetColor( guiShaders_t.doft , 55, 255, 55 )
		guiShaders_t.check = {}
		guiShaders_t.label = {}
		guiShaders_t.scrollBar = {}
		guiShaders_t.check.dof = guiCreateCheckBox ( 0.2, 0.0425, 0.15, 0.05,  _stringFromBool ( client_settings.dof.enable ), client_settings.dof.enable, true, guiShaders_t.scroll )
		guiShaders_t.label.dof_blur = guiCreateLabel( 0.05, 0.115, 0.275, 0.05, "Blur ammount: ( 0.9 )", true, guiShaders_t.scroll  )
		
		guiShaders_t.scrollBar.dof_blur = guiCreateScrollBar ( 0.275, 0.115, 0.3, 0.05, true, true, guiShaders_t.scroll )	

		guiShaders_t.label.dof_fades = guiCreateLabel( 0.05, 0.18, 0.275, 0.05, "Fade Start: ( 1 )", true, guiShaders_t.scroll  )

		guiShaders_t.scrollBar.dof_fades = guiCreateScrollBar ( 0.275, 0.18, 0.3, 0.05, true, true, guiShaders_t.scroll )

		guiShaders_t.label.dof_fadee = guiCreateLabel( 0.05, 0.245, 0.275, 0.05, "Fade End: ( 700 )", true, guiShaders_t.scroll  )

		guiShaders_t.scrollBar.dof_fadee = guiCreateScrollBar ( 0.275, 0.245, 0.3, 0.05, true, true, guiShaders_t.scroll )

		guiShaders_t.label.dof_skyb = guiCreateLabel( 0.05, 0.31, 0.275, 0.05, "Max sky blur: ( 0.5 )", true, guiShaders_t.scroll  )

		guiShaders_t.scrollBar.dof_skyb = guiCreateScrollBar ( 0.275, 0.31, 0.3, 0.05, true, true, guiShaders_t.scroll )
		
		guiShaders_t.label.dof_bri = guiCreateLabel( 0.65, 0.115, 0.15, 0.05, "Bright blur:", true, guiShaders_t.scroll  )

		guiShaders_t.check.dof_bri = guiCreateCheckBox ( 0.775, 0.11, 0.15, 0.05, _stringFromBool ( client_settings.dof.enable ) , client_settings.dof.dof_bri, true, guiShaders_t.scroll )
			
		guiShaders_t.dof_briS = guiCreateLabel( 0.65, 0.18, 0.15, 0.05, "Blur sky:", true, guiShaders_t.scroll  )

		guiShaders_t.check.dof_briS = guiCreateCheckBox ( 0.775, 0.175, 0.15, 0.05, _stringFromBool ( client_settings.dof.enable ) , client_settings.dof.dof_briS, true, guiShaders_t.scroll )
		
		guiShaders_t.colt = guiCreateLabel( 0.025, 0.385, 0.2, 0.05, "Color Correction:", true, guiShaders_t.scroll  )
		guiLabelSetColor( guiShaders_t.colt , 55, 255, 55 )
		guiShaders_t.check.correction = guiCreateCheckBox ( 0.2, 0.38, 0.15, 0.05,  _stringFromBool ( client_settings.correction.enable ), client_settings.correction.enable, true, guiShaders_t.scroll )
		

		
		
		guiShaders_t.label.satur = guiCreateLabel( 0.05, 0.45, 0.275, 0.05, "Saturation: ( 1.0 )", true, guiShaders_t.scroll  )

		guiShaders_t.scrollBar.satur = guiCreateScrollBar ( 0.275, 0.45, 0.3, 0.05, true, true, guiShaders_t.scroll )

		guiShaders_t.label.contr = guiCreateLabel( 0.05, 0.515, 0.275, 0.05, "Contrast: ( 0.0 )", true, guiShaders_t.scroll  )

		guiShaders_t.scrollBar.contr = guiCreateScrollBar ( 0.275, 0.515, 0.3, 0.05, true, true, guiShaders_t.scroll )	

		guiShaders_t.label.hue = guiCreateLabel( 0.05, 0.58, 0.275, 0.05, "Hue: ( 0.0 )", true, guiShaders_t.scroll  )

		guiShaders_t.scrollBar.hue = guiCreateScrollBar ( 0.275, 0.58, 0.3, 0.05, true, true, guiShaders_t.scroll )

		guiShaders_t.label.bright = guiCreateLabel( 0.05, 0.645, 0.275, 0.05, "Brightness: ( 0.0 )", true, guiShaders_t.scroll  )

		guiShaders_t.scrollBar.bright = guiCreateScrollBar ( 0.275, 0.645, 0.3, 0.05, true, true, guiShaders_t.scroll )	
		
		
		guiShaders_t.cart = guiCreateLabel( 0.125, 0.755, 0.15, 0.05, "Car reflections:", true, guiShaders_t.scroll  )
		guiLabelSetColor( guiShaders_t.cart , 55, 255, 55 )
		
		guiShaders_t.check.car = guiCreateCheckBox ( 0.3, 0.75, 0.5, 0.05, _stringFromBool ( client_settings.car.enable ) , client_settings.car.enable, true, guiShaders_t.scroll )
		
		guiShaders_t.watt = guiCreateLabel( 0.125, 0.82, 0.15, 0.05, "Water shader:", true, guiShaders_t.scroll  )
		guiLabelSetColor( guiShaders_t.watt , 55, 255, 55 )
		
		guiShaders_t.check.water = guiCreateCheckBox ( 0.3, 0.815, 0.5, 0.05, _stringFromBool ( client_settings.water.enable ), client_settings.water.enable, true, guiShaders_t.scroll )	

		guiShaders_t.dett = guiCreateLabel( 0.125, 0.885, 0.15, 0.05, "Detail shader:", true, guiShaders_t.scroll  )
		guiLabelSetColor( guiShaders_t.dett , 55, 255, 55 )
		
		guiShaders_t.check.detail = guiCreateCheckBox ( 0.3, 0.88, 0.5, 0.05, _stringFromBool ( client_settings.detail.enable ), client_settings.detail.enable, true, guiShaders_t.scroll )
		
		guiShaders_t.bloomt = guiCreateLabel( 0.525, 0.755, 0.15, 0.05, "Bloom Shader:", true, guiShaders_t.scroll  )
		guiLabelSetColor( guiShaders_t.bloomt , 55, 255, 55 )
		
		guiShaders_t.check.bloom = guiCreateCheckBox ( 0.7, 0.75, 0.5, 0.05, _stringFromBool ( client_settings.bloom.enable ) , client_settings.bloom.enable, true, guiShaders_t.scroll )
		
		guiShaders_t.bumpt = guiCreateLabel( 0.525, 0.82, 0.15, 0.05, "Bump shader:", true, guiShaders_t.scroll  )
		guiLabelSetColor( guiShaders_t.bumpt, 55, 255, 55 )
		
		guiShaders_t.check.bump = guiCreateCheckBox ( 0.7, 0.815, 0.5, 0.05, _stringFromBool ( client_settings.bump.enable ), client_settings.bump.enable, true, guiShaders_t.scroll )	

		guiShaders_t.dynamict = guiCreateLabel( 0.525, 0.885, 0.15, 0.05, "Dynamic sky:", true, guiShaders_t.scroll  )
		guiLabelSetColor( guiShaders_t.dynamict , 55, 255, 55 )
		
		guiShaders_t.check.dynamic = guiCreateCheckBox ( 0.7, 0.88, 0.5, 0.05, _stringFromBool ( client_settings.dynamic.enable ), client_settings.dynamic.enable, true, guiShaders_t.scroll )
		
		
		guiShaders_f.setScrollBarFromData( )
		addEventHandler( 'onClientGUIClick', guiShaders_t.scroll, guiShaders_f.onGuiClick )
		addEventHandler("onClientGUIScroll", guiShaders_t.scroll, guiShaders_f.onBarScroll )
			showCursor( true )
			
	end
	bindKey( 'F2', 'up', guiShaders )
	setTimer( _client_panel_load, 500, 1 )
	
	
	function guiShaders_f.onBarScroll ( )
			local _ = { dof_blur =  {'Blur ammount', 0, 10 },  dof_fades = {'Fade Start', 1, 100 },  dof_fadee = {'Fade End', 500, 2000 },  dof_skyb = {'Max sky blur', 0, 5 }, satur = {'Saturation', 0, 3 }, contr = { 'Contrast', 0, 1 }, hue = { 'Hue', 0, 360 }, bright = { 'Brightness', 0, 2 }  }
		for k, v in pairs( guiShaders_t.scrollBar ) do 
			if v == source then
				local val = _[k][2]+ math.round(guiScrollBarGetScrollPosition ( v ) * (( _[k][3] - _[k][2] )/100),2)
				guiSetText(  guiShaders_t.label[k], _[k][1]..': ( '..  val ..' )' )
				local _index = 'correction'
				if string.find( k , 'dof' ) then
					_index = 'dof'
				end	
				client_settings[ _index ] [k] = val
				_onUpdateEvent ( )
			end
		end
	
	end
	
	
	function guiShaders_f.onGuiClick ( )
		for k, v in pairs( guiShaders_t.check ) do 
			if v == source then
				guiSetText( v, _stringFromBool ( guiCheckBoxGetSelected ( v ) ) )
					if client_settings[k] then
						client_settings[k].enable = guiCheckBoxGetSelected ( v )
					end
						if k == 'dof_bri' or k == 'dof_briS' then
							client_settings.dof[k] = guiCheckBoxGetSelected ( v )
						end
					_onUpdateEvent ( )	
			end
		end
	
	end
	


	
	
local _commands = {}
_commands.data = {}
	
	function _commands.gui ( )
		if isElement( _commands.data.window  ) then
			removeEventHandler ( "onClientGUIClick", _commands.data.button ,  _commands.gui, false )
			destroyElement( _commands.data.Font  )
			destroyElement( _commands.data.window  )
			showCursor( false )
			return 0
		end	
	
		_commands.data.window = guiCreateTabPanel ( (screenWidth-math.min( 720,  math.floor( scaleInt( 480, 600 ) ) ))/2, (screenHeight-math.min( 540,math.floor( scaleInt( 480, 450 )) ))/2, math.min( 720,math.floor( scaleInt( 480, 600 ) )), math.min( 540, math.floor( scaleInt( 480, 450 ) )), false )
		_commands.data.tab = guiCreateTab ( "Commands", _commands.data.window )
		_commands.data.list = guiCreateGridList ( 0.0, 0.0, 1, 0.95, true, _commands.data.tab )
		_commands.data.button = guiCreateButton ( 0.0, 0.95, 1.0, 0.05, "Close", true, _commands.data.tab )
		addEventHandler ( "onClientGUIClick", _commands.data.button ,  _commands.gui, false )
		_commands.data.Font = guiCreateFont( "fonts/PTM55F.ttf", math.min( 12, math.floor( scaleInt( 480, 10 ) ) ) ) or 'clear-normal'
		 guiGridListAddColumn ( _commands.data.list , "command", 0.175 )
		 guiGridListAddColumn ( _commands.data.list , "arguments", 0.275 )
		 guiGridListAddColumn ( _commands.data.list , "description", 0.5 )
		local cmd_list = { 
			{ {'rsp', 'sync', 'fix' }, '', {'re-spawn to fix problems with', 'synchronization or occurring bugs',''}, 3  },
			{  'add', ' player id ', 'adds the player to the roud' },
			{  'remove', ' player id ', 'remove the player from the roud' },
			{  'end', '  ', 'ends the rounds' },
			{  'pause', '  ', 'pause or unpause the round' },
			{  {'restore',''}, '[ player id ]', {'restore player to the round', '( could be used for any player )'} },
			{  'car', ' veh id ', 'jus give the vehicle' },
			{  'helpme', '  ', 'call help, when you need it ( only on round )' },
			{  'heal', ' player id ', ' heal the player' },
			{  'healall', '  ', ' heal all players' },
			{ {'gun', 'gunmenu', 'weapon', 'weapons'}, ' - or  player id ', {'without arg: weapon re-select', 'with arg: give weapon menu to player' }},
			{ {'reset', 'resetscore', 'clean', 'cleanscore'}, '', 'cleaning teams scores and players stats ' },
			{ {'switch', 'switchsides', 'sides', 'swap'}, '', 'changes the sides of \'conflict\'' },
			{ {'s', 'exec', '.start'}, 'type  id', 'starts the round from type and id' },
			{ {'base',''}, 'id:', {'starst base from id, for random','base use id \'r\' or \'rand\' or \'random\''} },
			{ {'arena',''}, 'id:', {'starts arena from id, for random','arena use id \'r\' or \'rand\' or \'random\''} },
			{ {'commands','cmds'}, '', 'this gui' },
			
		}
		guiGridListSetSortingEnabled ( _commands.data.list, false)
		local _add = math.random( 999,999999 )
		for k, v in ipairs ( cmd_list ) do 
		math.randomseed( getTickCount()+_add  )
		local r, g, b = math.random( 100, 255), math.random( 100, 255), math.random( 100, 255)
			if type(  v[1] ) == "table" then
			local row
				for k1, v1 in ipairs ( v[1] ) do 
					row = guiGridListAddRow( _commands.data.list )
					guiGridListSetItemText ( _commands.data.list, row, 1, v1, false, false )
					guiGridListSetItemColor ( _commands.data.list, row, 1, r, g, b )
				end
				
				guiGridListSetItemText ( _commands.data.list, row-(#v[1]-1), 2, v[2], false, false )
				guiGridListSetItemColor ( _commands.data.list, row-(#v[1]-1), 2, r, g, b )
				
				if type(  v[3] ) == "table" then
				row = row - #v[1]
					for k1, v1 in ipairs ( v[3] ) do 
						row = row +1
						guiGridListSetItemText ( _commands.data.list, row, 3, v1, false, false )
						guiGridListSetItemColor ( _commands.data.list, row, 3, r, g, b )
					end
				else
					guiGridListSetItemText ( _commands.data.list, row-(#v[1]-1), 3, v[3], false, false )
					guiGridListSetItemColor ( _commands.data.list, row-(#v[1]-1), 3, r, g, b )
				end
			else	
				local row = guiGridListAddRow( _commands.data.list )
				guiGridListSetItemText ( _commands.data.list, row, 1, v[1], false, false )
				guiGridListSetItemText ( _commands.data.list, row, 2, v[2], false, false )
				guiGridListSetItemText ( _commands.data.list, row, 3, v[3], false, false )
				guiGridListSetItemColor ( _commands.data.list, row, 1, r, g, b )
				guiGridListSetItemColor ( _commands.data.list, row, 2, r, g, b )
				guiGridListSetItemColor ( _commands.data.list, row, 3, r, g, b )
			end	
			--[[	local row = guiGridListAddRow( _commands.data.list )
				local sadasd = " "
				guiGridListSetItemText ( _commands.data.list, row, 1,sadasd, false, false )
				guiGridListSetItemText ( _commands.data.list, row, 2, sadasd, false, false )
				guiGridListSetItemText ( _commands.data.list, row, 3,sadasd, false, false )]]
				_add = _add+ _add*math.random( 1,10 )
		end

		guiSetFont( _commands.data.list , _commands.data.Font )
		showCursor( true )
	end
	bindKey( 'F3', 'up', _commands.gui )
	addCommandHandler( 'commands', _commands.gui )
	addCommandHandler( 'cmds', _commands.gui )

	_initialLoaded( "utilities/_clientSettings.lua" )	

end	