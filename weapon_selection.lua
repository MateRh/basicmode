
_initialLoading[ "weapon_selection.lua" ] = function ( )
	
 
local weapon_gui = {
grid_buffor ={},
limit=3,
--kits={[1]={true,1},[2]={true,1},[3]={true,1},[4]={true,1},[5]={true,1},[6]={true,1},[7]={true,1},[8]={true,1},[9]={true,1},[22]={true,150},[23]={true,120},[24]={true,90},[25]={true,100},[26]={true,100},[27]={true,40},[28]={true,200},[29]={true,200},[31]={true,200},[32]={true,200},[32]={true,200},[32]={true,200},[30]={true,200},[33]={true,200},[34]={true,200},[35]={true,200},[36]={true,200},[37]={true,200},[38]={true,200},[16]={true,1},[17]={true,1},[18]={true,1},[39]={true,1},[41]={true,100},[42]={true,500},[10]={true,1},[11]={true,1},[12]={true,1},[14]={true,1},[15]={true,1},[44]={true,1},[45]={true,1},}
}
global_client_data = {}


_slot8_garb = false

function weapon_re_select( cmd, a1)
	if a1 ~= nil then
		return 0
	end	
	local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
	if r_type == "Lobby" then
		return onWeaponSelector()
	end	
	local s_fix = { Arena = 3, Base = 6, Bomb = 6 }
		if getTickCount() - global_client_data.last > client_settings_t [ string.lower ( r_type ) ] [ s_fix[ r_type ] ] [2]*1000 then
			return outputChatBox ( "#FF0000[ERROR] #d5d5d5 Time to re-select weapons are finish.", 255, 255, 255, true )
		end	
	onWeaponSelector()
end

addCommandHandler( "gun",  weapon_re_select )
bindKey( "b", 'down', function() 
		if getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] == "Lobby" then
			return onWeaponSelector()
		end
	end )
addCommandHandler( "gunmenu",  weapon_re_select )
addCommandHandler( "weapon",  weapon_re_select )
addCommandHandler( "weapons",  weapon_re_select )





	function return_weapon_speed( n )
		if not n then
			return false
		end
			if n > 0.91 then
				return 'Very slow'
			elseif n > 0.7 then
				return 'Slow'
			elseif n > 0.5 then
				return 'Average'
			elseif n > 0.3 then
				return 'Fast'
			else
				return 'Very Fast'
			end
		
	end

local _weapons_Gui =  { _last_sel = { } }


 function onWeaponSelector( protection )
	
	if isElement( _weapons_Gui.window ) then
		return 0;
	end	

	if protection == true then
		_protect_enable( )
	end
	if getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] ~= "Lobby" then
		_players[ localPlayer ]:updateStatus(  3, 10 )
	end	
	--sdasddsadsa(250)
		blur_remote( true, 0.5 )
 		
	_weapons_Gui.width =  380 + math.cut( 18*( screenWidth  * ( 1 / 1920 )  ) )*2.5 
	_weapons_Gui.window = guiCreateTabPanel( (screenWidth-620)/2, (screenHeight- _weapons_Gui.width ), 620, 380, false )
	_weapons_Gui.Tab = guiCreateTab( 'Select your weapons', _weapons_Gui.window )
	_weapons_Gui.combo={}
	_weapons_Gui.grid={}
	_weapons_Gui.label={}
	_weapons_Gui._positions = { { 0.025, 0.05 }, { 0.35, 0.05 }, { 0.675, 0.05 }, { 0.025, 0.45 }, { 0.35, 0.45 }, { 0.675, 0.45 } }
	_weapons_Gui.enabled_slots = 3
	 
	--[[	if getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] == "Lobby" then
			_weapons_Gui.enabled_slots = 6
		end	]]
	for k, v in ipairs( _weapons_Gui._positions ) do
	local _c = 0
	_weapons_Gui.label[k] = {}
	_weapons_Gui.slots_c = {}
		if k > _weapons_Gui.enabled_slots then
		 _weapons_Gui.combo[k] = guiCreateComboBox (v[1], v[2], 0.3, 0.55, 'slot inactive', true, _weapons_Gui.Tab  )
		guiSetFont ( _weapons_Gui.combo[k],'default-bold-small' )
		_weapons_Gui.label[k].ammo_total = guiCreateLabel ( v[1] +0.025, v[2] + 0.05 + 0.025, 0.3, 0.05, 'slot inactive', true, _weapons_Gui.Tab )
		_weapons_Gui.label[k].ammo_clip = guiCreateLabel ( v[1]+0.025, v[2] + 0.1+ 0.025, 0.3, 0.05,  '', true, _weapons_Gui.Tab )
		_weapons_Gui.label[k].range_ = guiCreateLabel ( v[1]+0.025, v[2] + 0.15+ 0.025, 0.3, 0.05,  '', true, _weapons_Gui.Tab )
		_weapons_Gui.label[k].damage = guiCreateLabel ( v[1]+0.025, v[2] + 0.2+ 0.025, 0.3, 0.05,  '', true, _weapons_Gui.Tab )
		_weapons_Gui.label[k].fire_speed = guiCreateLabel ( v[1]+0.025, v[2] + 0.25+ 0.025, 0.3, 0.05,  '', true, _weapons_Gui.Tab )
		  guiSetEnabled( _weapons_Gui.combo[k], false )
		else
		 _weapons_Gui.grid[k] = guiCreateGridList (v[1], v[2], 0.3, 0.35, true, _weapons_Gui.Tab  )
		 guiGridListSetSortingEnabled (  _weapons_Gui.grid[k], false )
		 _weapons_Gui.combo[k] = guiCreateComboBox (v[1], v[2], 0.3, 0.55, 'Deagle', true, _weapons_Gui.Tab  )
		 guiSetFont ( _weapons_Gui.combo[k],'default-bold-small' )
		 guiGridListAddColumn(  _weapons_Gui.grid[k], "Weapons:", 0.8 )
			 for i,_ in pairs(client_global_settings.weapons ) do	
			 		
			
				if getWeaponNameFromID ( i ) and _[1] == true then 
					local row = guiGridListAddRow (  _weapons_Gui.grid[k] )
					guiGridListSetItemText (  _weapons_Gui.grid[k], row, 1, getWeaponNameFromID ( i ), false, false )
					guiComboBoxAddItem( _weapons_Gui.combo[k],  getWeaponNameFromID ( i ) )
							_weapons_Gui.slots_c[ getSlotFromWeapon ( i ) ] = row
					 _c  =  _c +1
				end
			end
			
				if #_weapons_Gui._last_sel == 0 then
					local _c_c_c = 0
					local slotsCache = _weapons_Gui.slots_c 
						if #slotsCache > _weapons_Gui.enabled_slots then
							for x,z in pairs( slotsCache ) do	
								if x == 0 or x == 1 then
									table.remove( slotsCache, x )
								end
							end
						end
					for x,z in pairs( slotsCache ) do	
						_c_c_c = _c_c_c  +1
							if _c_c_c  == k  then
									guiComboBoxSetSelected ( _weapons_Gui.combo[k], z )
							end
					end
				else

						for i=0, guiGridListGetRowCount ( _weapons_Gui.grid[ k ] ) do
							if	guiGridListGetItemText ( _weapons_Gui.grid[ k ], i, 1 ) == _weapons_Gui._last_sel[ k ] then
								guiComboBoxSetSelected ( _weapons_Gui.combo[ k ], i )
								break
							end
						end
					
				end
			
			guiSetVisible( _weapons_Gui.grid[k], false )
			
		_weapons_Gui.label[k].ammo_total = guiCreateLabel ( v[1]+0.025, v[2] + 0.05 + 0.025, 0.3, 0.05, 'Ammunition total: '..client_global_settings.weapons[ getWeaponIDFromName(  guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ) ) ][3] , true, _weapons_Gui.Tab )
		_weapons_Gui.label[k].ammo_clip = guiCreateLabel ( v[1]+0.025, v[2] + 0.1+ 0.025, 0.3, 0.05, 'Ammunition in clip: '..(getWeaponProperty ( guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ), 'pro', 'maximum_clip_ammo' ) or '1') , true, _weapons_Gui.Tab )
		_weapons_Gui.label[k].range_ = guiCreateLabel ( v[1]+0.025, v[2] + 0.15+ 0.025, 0.3, 0.05, 'Range: '..(getWeaponProperty ( guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ), 'pro', 'weapon_range' ) or '-') ..' m' , true, _weapons_Gui.Tab )
		_weapons_Gui.label[k].damage = guiCreateLabel ( v[1]+0.025, v[2] + 0.2+ 0.025, 0.3, 0.05, 'Damage: '..math.round ( (getWeaponProperty ( guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ), 'pro', 'damage' ) or 0 )  *0.333333, 1 )  , true, _weapons_Gui.Tab )
		_weapons_Gui.label[k].fire_speed = guiCreateLabel ( v[1]+0.025, v[2] + 0.25+ 0.025, 0.3, 0.05, 'Firing speed: '.. (return_weapon_speed( getWeaponProperty ( guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ), 'pro', 'anim_loop_stop' ) ) or 'unspecified') , true, _weapons_Gui.Tab )
		end
	  end
	  
	
	
addEventHandler( "onClientMouseMove", _weapons_Gui.Tab,  _weapons_Gui.onClientMouseMove, true, 'high' )

	
	
	
addEventHandler ( "onClientGUIClick", _weapons_Gui.window, _weapons_Gui.onClientGUIClick )





	
	_weapons_Gui.label_main =  guiCreateLabel ( 0.025, 0.825, 0.95, 0.05, '', true, _weapons_Gui.Tab )
	guiSetFont ( _weapons_Gui.label_main ,'default-bold-small' )
	_weapons_Gui.button = guiCreateButton( 0.025, 0.9, 0.95, 0.05, 'Do you accept weapons ?', true, _weapons_Gui.Tab )
	guiSetFont ( _weapons_Gui.button ,'default-bold-small' )
	addEventHandler ( "onClientGUIClick", _weapons_Gui.button , _weapons_Gui.accpet, false  )
	local _text = ''
	for k, v in ipairs( _weapons_Gui._positions ) do
			if k <= _weapons_Gui.enabled_slots then
				if k > 1 then
					_text = _text ..' + '
				end	
				_text = _text.. guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ).. ' ( '..client_global_settings.weapons[ getWeaponIDFromName(  guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ) ) ][3]..' )'
			end
		end	
	guiSetText( _weapons_Gui.label_main, _text )
	showCursor( true )
	--[[
	if  _weapons_Gui.enabled_slots < 4 then
		_weapons_Gui.width = _weapons_Gui.width / 2
		guiSetSize( _weapons_Gui.window, 620, 380/2, false )
		guiSetPosition( _weapons_Gui.window, (screenWidth-620)/2, (screenHeight- _weapons_Gui.width ), false )
	end]]

end

    function  _weapons_Gui.onClientMouseMove (aX, aY)
	aX = ( aX -  (screenWidth-620)/2 ) /620
	aY = ( ( aY -  ( screenHeight-_weapons_Gui.width ) ) / _weapons_Gui.width  ) - 0.05
		for k, v in ipairs( _weapons_Gui._positions ) do
			if  _weapons_Gui.enabled_slots >= k then
			if aX >= v[1] and aY >= v[2] and aX <= v[1]+0.3 and aY <= v[2]+0.35  then
					guiSetVisible(  _weapons_Gui.combo[k], false )
					guiSetVisible(  _weapons_Gui.label[k].ammo_total, false )
				 guiSetVisible(    _weapons_Gui.label[k].ammo_clip, false )
				 guiSetVisible(    _weapons_Gui.label[k].range_, false )
				 guiSetVisible(   _weapons_Gui.label[k].damage, false )
				 guiSetVisible(    _weapons_Gui.label[k].fire_speed, false )
				 guiSetVisible(   _weapons_Gui.grid[k], true )
				 
					else
			 guiSetVisible(  _weapons_Gui.combo[k], true  )
			 guiSetVisible(  _weapons_Gui.label[k].ammo_total, true  )
		 guiSetVisible(    _weapons_Gui.label[k].ammo_clip, true  )
		 guiSetVisible(    _weapons_Gui.label[k].range_, true  )
		 guiSetVisible(   _weapons_Gui.label[k].damage, true  )
		 guiSetVisible(    _weapons_Gui.label[k].fire_speed, true  )
		 guiSetVisible(   _weapons_Gui.grid[k], false )	 
			end
			end
		end
	end

	function _weapons_Gui.onClientGUIClick(  )
		for k, v in ipairs( _weapons_Gui.grid ) do
			if source == v and  _weapons_Gui.enabled_slots >= k then
			local row =  guiGridListGetSelectedItem ( v )
			guiComboBoxSetSelected ( _weapons_Gui.combo[k], row )
			guiSetText(	_weapons_Gui.label[k].ammo_total, 'Ammunition total: '..client_global_settings.weapons[ getWeaponIDFromName(  guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ) ) ][3] )
			guiSetText(	_weapons_Gui.label[k].ammo_clip, 'Ammunition in clip: '..(getWeaponProperty ( guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ), 'pro', 'maximum_clip_ammo' ) or '1'))
			guiSetText(	_weapons_Gui.label[k].range_, 'Range: '..(getWeaponProperty ( guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ), 'pro', 'weapon_range' ) or '-') ..' m' )
			guiSetText(	_weapons_Gui.label[k].damage,  'Damage: '..math.round ( (getWeaponProperty ( guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ), 'pro', 'damage' ) or 0 )  *0.333333, 1 )  )
			guiSetText(	_weapons_Gui.label[k].fire_speed, 'Firing speed: '.. (return_weapon_speed( getWeaponProperty ( guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ), 'pro', 'anim_loop_stop' ) ) or 'unspecified') )
				local _text = ''
				for k, v in ipairs( _weapons_Gui._positions ) do
						if k <= _weapons_Gui.enabled_slots then
							if k > 1 then
								_text = _text ..' + '
							end	
							_text = _text.. guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ).. ' ( '..client_global_settings.weapons[ getWeaponIDFromName(  guiComboBoxGetItemText( _weapons_Gui.combo[k], guiComboBoxGetSelected( _weapons_Gui.combo[k] ) ) ) ][3]..' )'
						end
					end	
				guiSetText( _weapons_Gui.label_main, _text )
			end
        end
    end	
	
	local _startInfo = nil
	function funInfo( )
		dxText( "You can't select two heavy weapons!", ( screenWidth -dxGetTextWidth( "You can't select two heavy weapons!", 2, 'default') ) /2 , screenHeight/5 , colors_g.red, 2, 'default' ) 
		if getTickCount() > _startInfo then
			removeEventHandler( 'onClientRender', getRootElement(), funInfo )
			_startInfo = nil
		end
	end 
	
	
	_slot8_garb = false

function _weapons_Gui.accpet()

	local weapons_to_return = {}
	_weapons_Gui._last_sel = {}
		for k, v in ipairs( _weapons_Gui.combo ) do
			if  _weapons_Gui.enabled_slots >= k then
				local id = guiComboBoxGetItemText( v, guiComboBoxGetSelected( v ) )
				table.insert( _weapons_Gui._last_sel, id )
				id = getWeaponIDFromName(id)
				
				if getSlotFromWeapon ( id ) == 8 and getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] ~= "Lobby" then
						if _slot8_garb == false then
							_slot8_garb = true
							table.insert(weapons_to_return,{id, client_global_settings.weapons [id][3]})
						elseif  getPedTotalAmmo ( localPlayer, 8 ) == 0 then
						else
							table.insert(weapons_to_return,{id, client_global_settings.weapons [id][3]})
						--	break
						end	
						
				else
					table.insert(weapons_to_return,{id, client_global_settings.weapons [id][3]})	
				end	
				
				
			end	
		end
		
	if	client_global_settings.heavy_w == true then
	local Heavy_c = 0;
		for a, b in pairs( weapons_to_return ) do 
			if b[1] == 30 or b[1] == 31 or b[1] == 33 or b[1] == 34 then
				Heavy_c = Heavy_c + 1
					if Heavy_c > 1 then
						
						if _startInfo == nil then
							_startInfo = getTickCount() + 3500
							addEventHandler( 'onClientRender', getRootElement(), funInfo )
						end
						return setSoundVolume( playSFX("script", 205, 0, false), 0.75 )
					end
			end
		end
	end
		
	if getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] ~= "Lobby" then
		_players[ localPlayer ]:updateStatus(  2, 2 )
	end	
		
		if getCameraTarget( ) ~= localPlayer then
			setCameraTarget( localPlayer )
		end	
		sdasddsadsa()
		callServer("giveWeapons",localPlayer,weapons_to_return)
			saveLastCache ( _weapons_Gui._last_sel )

		removeEventHandler( "onClientMouseMove", _weapons_Gui.Tab,  _weapons_Gui.onClientMouseMove )
		removeEventHandler ( "onClientGUIClick", _weapons_Gui.window, _weapons_Gui.onClientGUIClick )
		removeEventHandler ( "onClientGUIClick", _weapons_Gui.button , _weapons_Gui.accpet )
		destroyElement( _weapons_Gui.window  )
		_weapons_Gui.combo={}
		_weapons_Gui.grid={}
		_weapons_Gui.label={}
		_weapons_Gui._positions = {}
		showCursor(false)
		blur_remote( false )
		showPlayerHudComponent (  "radar", true )
		_localPlayer:updateStatus(  3, 0 )
		if global_client_data.last == nil then global_client_data.last = getTickCount() end


	end

	function forceCloseWeaponSelector()
		if not isElement( _weapons_Gui.window ) then return 0 end
		removeEventHandler( "onClientMouseMove", _weapons_Gui.Tab,  _weapons_Gui.onClientMouseMove )
		removeEventHandler ( "onClientGUIClick", _weapons_Gui.window, _weapons_Gui.onClientGUIClick )
		removeEventHandler ( "onClientGUIClick", _weapons_Gui.button , _weapons_Gui.accpet )
		destroyElement( _weapons_Gui.window  )
			_weapons_Gui.combo={}
			_weapons_Gui.grid={}
			_weapons_Gui.label={}
			_weapons_Gui._positions = {}
		showCursor(false)
		blur_remote( false )
	end

	
	function saveLastCache( data )
		local _file =  fileCreate ( ':basicmode-core/weaponsCache' )
        fileSetPos ( _file, 0 )
		fileWrite ( _file, toJSON ( data ) )
		fileClose ( _file )
	end	
	
	function loadLastCache( )
		if fileExists( ':basicmode-core/weaponsCache' ) then
			local _file = fileOpen ( ':basicmode-core/weaponsCache' )  
			fileSetPos ( _file, 0 )
			local data = fileRead( _file,  fileGetSize ( _file ) + 1 )
			fileClose ( _file )
			_weapons_Gui._last_sel = { }
			_weapons_Gui._last_sel = fromJSON ( data )
		end	
	end	

	loadLastCache( )


	_initialLoaded( "weapon_selection.lua" )	

end	