	settings_ = {
		main = {
			{'auto balance:', false },
			{'auto swap:', true },
			{'countdown time:', 3 },
			{'anti helli kill:', true },
			{'anti helli boom:', 'explosion reduced 2x' },
			{'player health:', 100 },
			{'player armor', 0  },
			{'spectaor mode:', 'only team' },
			{'radar blips mode:', 'only team' },
			{'auto pause:', true },
			{'vehicles health bars:', true },
			{'vehicle tank explodable:', false },
			{'vote:', true  },
			{'vote timeout:', 21 },
			{'vote allow updates:', true },
			{'alternative weapons balance:', true },
			{'only one heavy weapon:', false },
				},	
		gliteches = {
			{'crouchbug:', true },
			{'fastfire:', true },
			{'quickreload:', true },
			{'fastmove:', true },
			{'fastsprint:', false },
			{'crouch bug limiter:', false },
				},
		limits = {
			{'FPS Limit:', 61 },
			{'Min FPS:', 25 },
			{'Max Ping:', 150 },
			{'Max PacketLoss:', 20 },
				},	
		weather = {
			{'weather:', 3 },
			{'weather blend:', 3 },
			{'time:', '12:00' },
			{'time locked', true },
			{'minute duration:', 99999 },
				},
		miscellaneous = {
			{'blur leve:',  0},
			{'game speed:',  1},
			{'friendly fire:', false },
			{'gravity:',  0.008 },
			{'clouds:', false },
			{'birds:', false },
			{'ambient sound general:', false },
			{'ambient sound gunfire:', false },
			{'interior sounds:', false },
				},
		arena = {
			{'spawn protect time:', 5 },
			{'time limit:', '05:00' },
			{'time to re-select weapons:', 20 },
				},
		base = {
			{'spawn protectt time:', 15},
			{'time limit:', '07:00' },
			{'capture time:', 20 },
			{'capture mode:', 'intermittent' },
			{'car jacking:', false },
			{'time to re-select weapons:', 40 },
				},	
		bomb = {
			{'spawn protectt time:', 15},
			{'time limit:', '10:00'},
			{'plant time', 5, },
			{'defuse time', 10,},
			{'bomb explode time', '01:00'},
			{'time to re-select weapons:', 20 },
				},
		teams = {
			[1] = {
				{'name:',  'Team#1'},
				{'skin:',  268  },
				{'score:',  0 },
				{'color',  '225,225,0' },
					},
			[2] = {
				{'name:',  'Team#2' },
				{'skin:',  302 },
				{'score:',  0 },
				{'color',  '225,0,225' },
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
	
	function _applyAppropriateEnvironment ()
	local ret_ = true
		if getPlayerCount ( ) < 46 then
			ret_ = setServerConfigSetting ( 'player_sync_interval', '50' )
			ret_ = setServerConfigSetting ( 'lightweight_sync_interval', '150' )
			ret_ = setServerConfigSetting ( 'unoccupied_vehicle_sync_interval', '100' )
			ret_ = setServerConfigSetting ( 'keysync_mouse_sync_interval', '50' )
			ret_ = setServerConfigSetting ( 'bullet_sync', '1' )
			ret_ = setServerConfigSetting ( 'threadnet', '1' )

		else
			ret_ = setServerConfigSetting ( 'player_sync_interval', '75' )
			ret_ = setServerConfigSetting ( 'lightweight_sync_interval', '700' )
			ret_ = setServerConfigSetting ( 'unoccupied_vehicle_sync_interval', '500' )
			ret_ = setServerConfigSetting ( 'keysync_mouse_sync_interval', '100' )
			ret_ = setServerConfigSetting ( 'bullet_sync', '1' )
			ret_ = setServerConfigSetting ( 'threadnet', '0' )
		end
			if getServerConfigSetting ( 'bandwidth_reduction' ) == 'maximum' then
				ret_ = setServerConfigSetting ('bandwidth_reduction', 'medium' )
			end	
			
			if settings_.main[ 16 ][ 2 ] == true then 
			-- [[ m4 more like weapon ]] --
		--	setWeaponProperty ( 31, 'pro', 'damage', 23 ) 
		--	setWeaponProperty ( 31, 'pro', "accuracy"  , getOriginalWeaponProperty ( 31, 'pro', "accuracy"  ) * 0.76666666666666666666666666666667 ) 
		--	setWeaponProperty (  31, 'pro', 'anim_loop_stop', 0.3475 )
		--	setWeaponProperty (  31, 'pro', 'anim2_loop_stop', 0.3475 )
			setWeaponProperty (  31, 'pro', 'anim_loop_stop', 0.3350 )
			setWeaponProperty (  31, 'pro', 'anim2_loop_stop', 0.3350 )

			
			setWeaponProperty (  24, 'pro', 'anim_loop_stop', 0.825 )
			setWeaponProperty (  24, 'pro', 'anim2_loop_stop', 0.825 )	

			
			setWeaponProperty (  30, 'pro', 'weapon_range', 100 )
			setWeaponProperty (  30, 'pro', 'target_range', 100 )	
			setWeaponProperty (  30, 'pro', 'maximum_clip_ammo', 50 )	
				setWeaponProperty ( 30, 'pro', "accuracy"  , getOriginalWeaponProperty ( 30, 'pro', "accuracy"  ) * ( getOriginalWeaponProperty ( 30, 'pro', 'weapon_range'  ) / 100 ) ) 
			setWeaponProperty (  31, 'pro', 'weapon_range', 100 )
			setWeaponProperty (  31, 'pro', 'target_range', 100 )
				setWeaponProperty ( 31, 'pro', "accuracy"  , getOriginalWeaponProperty ( 31, 'pro', "accuracy"  ) * ( getOriginalWeaponProperty ( 31, 'pro', 'weapon_range'  ) / 100 ) ) 
			setWeaponProperty (  24, 'pro', 'weapon_range', 45 )
			setWeaponProperty (  24, 'pro', 'target_range', 45 )
				setWeaponProperty ( 24, 'pro', "accuracy"  , getOriginalWeaponProperty ( 24, 'pro', "accuracy"  ) * ( getOriginalWeaponProperty ( 24, 'pro', 'weapon_range'  ) / 45 ) ) 
			setWeaponProperty (  22, 'pro', 'weapon_range', 45 )
			setWeaponProperty (  22, 'pro', 'target_range', 45 )
				setWeaponProperty ( 22, 'pro', "accuracy"  , getOriginalWeaponProperty ( 22, 'pro', "accuracy"  ) * ( getOriginalWeaponProperty ( 22, 'pro', 'weapon_range'  ) / 45 ) ) 
			setWeaponProperty (  23, 'pro', 'weapon_range', 45 )
			setWeaponProperty (  23, 'pro', 'target_range', 45 )
				setWeaponProperty ( 23, 'pro', "accuracy"  , getOriginalWeaponProperty ( 23, 'pro', "accuracy"  ) * ( getOriginalWeaponProperty ( 23, 'pro', 'weapon_range'  ) / 45 ) ) 
			setWeaponProperty (  25, 'pro', 'weapon_range', 50 )
			setWeaponProperty (  25, 'pro', 'target_range', 50 )
				setWeaponProperty ( 25, 'pro', "accuracy"  , getOriginalWeaponProperty ( 25, 'pro', "accuracy"  ) * ( getOriginalWeaponProperty ( 25, 'pro', 'weapon_range'  ) / 50 ) )
			setWeaponProperty (  29, 'pro', 'weapon_range', 58 )
			setWeaponProperty (  29, 'pro', 'target_range', 58 )
				setWeaponProperty ( 29, 'pro', "accuracy"  , getOriginalWeaponProperty ( 29, 'pro', "accuracy"  ) * ( getOriginalWeaponProperty ( 29, 'pro', 'weapon_range'  ) / 58 ) ) 
			else
			
				setWeaponProperty (  31, 'pro', 'anim_loop_stop', getOriginalWeaponProperty (  31, 'pro', 'anim_loop_stop' ) )
				setWeaponProperty (  31, 'pro', 'anim2_loop_stop',  getOriginalWeaponProperty ( 31, 'pro', 'anim2_loop_stop' ) )
				
				setWeaponProperty (  24, 'pro', 'anim_loop_stop', getOriginalWeaponProperty (  24, 'pro', 'anim_loop_stop' ) )
				setWeaponProperty (  24, 'pro', 'anim2_loop_stop', getOriginalWeaponProperty ( 24, 'pro', 'anim2_loop_stop' ) )

				setWeaponProperty (  30, 'pro', 'weapon_range', getOriginalWeaponProperty (  30, 'pro', 'weapon_range' ) )
				setWeaponProperty (  30, 'pro', 'target_range', getOriginalWeaponProperty ( 30, 'pro', 'target_range' ) )	
				setWeaponProperty (  30, 'pro', 'maximum_clip_ammo', getOriginalWeaponProperty ( 30, 'pro', 'maximum_clip_ammo' ) )
					setWeaponProperty ( 30, 'pro', "accuracy"  , getOriginalWeaponProperty ( 30, 'pro', "accuracy"  ) ) 
				setWeaponProperty (  31, 'pro', 'weapon_range', getOriginalWeaponProperty ( 31, 'pro', 'weapon_range' ) )
				setWeaponProperty (  31, 'pro', 'target_range', getOriginalWeaponProperty ( 31, 'pro', 'target_range' ) )
					setWeaponProperty ( 31, 'pro', "accuracy"  , getOriginalWeaponProperty ( 31, 'pro', "accuracy"  ) ) 
				setWeaponProperty (  24, 'pro', 'weapon_range', getOriginalWeaponProperty (  24, 'pro', 'weapon_range' ) )
				setWeaponProperty (  24, 'pro', 'target_range', getOriginalWeaponProperty ( 24, 'pro', 'target_range' ) )
					setWeaponProperty ( 24, 'pro', "accuracy"  , getOriginalWeaponProperty ( 24, 'pro', "accuracy"  )  ) 
				setWeaponProperty (  22, 'pro', 'weapon_range', getOriginalWeaponProperty ( 22, 'pro', 'weapon_range' ) )
				setWeaponProperty (  22, 'pro', 'target_range', getOriginalWeaponProperty ( 22, 'pro', 'target_range' ) )
					setWeaponProperty ( 22, 'pro', "accuracy"  , getOriginalWeaponProperty ( 22, 'pro', "accuracy"  ) ) 
				setWeaponProperty (  23, 'pro', 'weapon_range', getOriginalWeaponProperty ( 23, 'pro', 'weapon_range' ) )
				setWeaponProperty (  23, 'pro', 'target_range', getOriginalWeaponProperty ( 23, 'pro', 'target_range' ) )
					setWeaponProperty ( 23, 'pro', "accuracy"  , getOriginalWeaponProperty ( 23, 'pro', "accuracy"  ) ) 
				setWeaponProperty (  25, 'pro', 'weapon_range', getOriginalWeaponProperty ( 25, 'pro', 'weapon_range' ) )
				setWeaponProperty (  25, 'pro', 'target_range', getOriginalWeaponProperty ( 25, 'pro', 'target_range' ) )
					setWeaponProperty ( 25, 'pro', "accuracy"  , getOriginalWeaponProperty ( 25, 'pro', "accuracy"  ) )
				setWeaponProperty (  29, 'pro', 'weapon_range', getOriginalWeaponProperty ( 29, 'pro', 'weapon_range' ) )
				setWeaponProperty (  29, 'pro', 'target_range', getOriginalWeaponProperty ( 29, 'pro', 'target_range' ) )
					setWeaponProperty ( 29, 'pro', "accuracy", getOriginalWeaponProperty ( 29, 'pro', "accuracy"  ) ) 
					
					setWeaponProperty (  25, 'pro', "flag_type_heavy", false )	
			end
			setWeaponProperty( 32, 'std', "damage", 30 )
			 setWeaponProperty( 32, 'std', "accuracy", 1.5 )
			setWeaponProperty( 32, 'std', "anim_loop_stop", 0.51 )
			setWeaponProperty( 32, 'std', "weapon_range", 50 )
			setWeaponProperty( 32, 'std', "target_range", 45 )

			setWeaponProperty( 28, 'std', "damage", 20 )
			 setWeaponProperty( 28, 'std', "accuracy", 1.5 )
			setWeaponProperty( 28, 'std', "anim_loop_stop", 0.325 )
			setWeaponProperty( 28, 'std', "anim2_loop_stop", 0.325 )
			setWeaponProperty( 28, 'std', "weapon_range", 50 )
			setWeaponProperty( 28, 'std', "target_range", 45 )

			setWeaponProperty( 38, 'poor', "damage", 30 )
			 setWeaponProperty( 38, 'poor', "accuracy", 1.0 )
			setWeaponProperty( 38, 'poor', "anim_loop_stop", 0.525 )
			setWeaponProperty( 38, 'poor', "anim2_loop_stop", 0.525 )
			setWeaponProperty( 38, 'poor', "weapon_range", 100 )
			setWeaponProperty( 38, 'poor', "target_range", 90 )
			setWeaponProperty( 38, 'poor', "maximum_clip_ammo", 100 )
			setWeaponProperty( 38, 'poor', 'flags', 0x001000 )
			setWeaponProperty( 38, 'poor', 'flags', 0x008000 )



		return ret_	
	end

	
	local _wrong = false

		if getServerConfigSetting ( "client_file" ) ~= false then
		setTimer(function()	outputServerLog(" [[ enabled 'modified client files' detect ]]\n1. Stop server. \n2. Open and edit 'mtaserver.conf' in '\mods\deathmatch' your server location.\n3. Find all lines containing 'client_file' and delete it.\n4. Save and start server.\n" ) end,50,1)
			_wrong = true 
		end	
		

	local _properties_w = { "weapon_range", "target_range", "accuracy", "damage", "maximum_clip_ammo", "move_speed",  "anim_loop_start","anim_loop_stop", "anim_loop_bullet_fire", "anim2_loop_start", "anim2_loop_stop", "anim2_loop_bullet_fire", "anim_breakout_time" }
		if tonumber( getVersion ( ).number ) > 309 or tonumber( gettok ( getVersion ( ).sortable, 4, '.' ) ) >= 6139 then
			_properties_w = { "weapon_range", "target_range", "accuracy", "damage", "maximum_clip_ammo", "move_speed", "flag_aim_no_auto", "flag_aim_arm", "flag_aim_1st_person", "flag_aim_free", "flag_move_and_aim", "flag_move_and_shoot", "flag_type_throw", "flag_type_heavy", "flag_type_constant", "flag_type_dual", "flag_anim_reload", "flag_anim_crouch", "flag_anim_reload_loop", "flag_anim_reload_long", "flag_shot_slows", "flag_shot_rand_speed", "flag_shot_anim_abrupt", "flag_shot_expands",  "anim_loop_start","anim_loop_stop", "anim_loop_bullet_fire", "anim2_loop_start", "anim2_loop_stop", "anim2_loop_bullet_fire", "anim_breakout_time" }
		end
	for k, v in pairs ( { 'colt 45','silenced','deagle','shotgun','sawed-off','combat shotgun','uzi','mp5','ak-47','m4','tec-9','rifle','sniper' } ) do
		for k1, v1 in pairs ( _properties_w ) do
			setWeaponProperty ( v, 'pro', v1, getOriginalWeaponProperty ( v, 'pro', v1 ) )
		end
	end
	_properties_w = nil


		if _applyAppropriateEnvironment() ~= true then
		setTimer(function()	outputServerLog(" [[ acl rights required! ]]\n1. As admin type /aclrequest allow basicmode all\n2. Start the gamemode.\n" ) end,50,1)
			_wrong = true 
		end
		if _wrong == true then return stopResource( getThisResource() ) end





	
		
	function updateBrowserInfo ( res_full_name )
		if  res_full_name == nil then
				setGameType ( "BasicMode 1.0 r-"..getElementData( global_element, "_revision" ).. " [ Lobby ]")
				setMapName ( "BasicMode 1.0 r-"..getElementData( global_element, "_revision" ).. " [ Lobby ]")
			return
		end
	local type, id
		if string.find(res_full_name,"arena") then -- Sprawdzanie typu mapy
			type = "Arena"
			id = string.gsub(res_full_name, "arena_", "") 
		elseif string.find(res_full_name,"base") then
			type = "Base"
			id =   string.gsub(string.gsub(res_full_name, "base_", ""), "_bm", "") 
		end				
		setGameType ( "BasicMode 1.0 r-"..getElementData( global_element, "_revision" ).. " [ "..type..": "..id.." ]")
	setMapName ( "BasicMode 1.0 r-"..getElementData( global_element, "_revision" ).. " [ "..type..": "..id.." ]")
	end
	
	function callClient(client, funcname, ...)
		local arg = { ... }
		if (arg[1]) then
			for key, value in next, arg do
				if (type(value) == "number") then arg[key] = tostring(value) end
			end
		end
		triggerClientEvent(client, "on_client_call", root, funcname, unpack(arg or {}))
	end

	function callServer(funcname, ...)
		local arg = { ... }
		if (arg[1]) then
			for key, value in next, arg do arg[key] = tonumber(value) or value end
		end
		loadstring("return "..funcname)()(unpack(arg))
	end
	addEvent("on_server_call", true)
	addEventHandler("on_server_call", root, callServer)
	
	
	function getPositionFromDistanceRotation( x,y,z,obrot ,dystans )	
		obrot = obrot/180*3.14159265358979
		x = x - ( math.sin(obrot) * dystans )
		y = y + ( math.cos(obrot) * dystans )
		return x, y, z
	end

	countdown_data = {}

		global_element = createElement ( "root_gm_element","basicmode" )
		setElementData(global_element,"map_info",{"Lobby",""})
		setElementData( global_element,"round", 0 )
		team1 = createTeam("Team1",215, 185 ,50)
		team2 = createTeam("Team2", 51, 119 ,214)
		setTeamFriendlyFire (team1 , false )
		setTeamFriendlyFire (team2 , false )
		team3 = createTeam("Spectator",200,200,255)
		local teams_ = {team1,team2,team3}
		setElementData(team1,"t_type","Attack")
		setElementData(team2,"t_type","Defense")
		setElementData(team3,"t_type","Spectator")
		setElementData(team1,"p_count",0)
		setElementData(team2,"p_count",0)		
		setElementData(team1,"Score",0)
		setElementData(team2,"Score",0)
		setElementData(team3,"Score",0)
		actually_map = false
		lobby_root_element =  createElement ( "lobby_root_element" )
		
		removeWorldModel ( 7023, 25.68047, 2501.5156, 2781.2891, 9.82031)
		removeWorldModel ( 7172, 41.4114, 2546.0313, 2828.7344, 11.53906 )
		
		removeWorldModel ( 986, 7.4280729, 2497.6001, 2767.4355, 14.64366 )
		removeWorldModel ( 985, 7.3802581, 2497.5701, 2775.1453, 12.52567 )
		
		

		
--[[	local colors_scheme = {
		{ 255, 25, 25 },
		{ 0, 255, 0 },
		{ 0, 0, 255 },
		{ 255, 255, 0 },
		{ 0, 255, 255 },
		{ 255, 0, 255 },
		{ 192,192,192 },
		{ 128,0,0 },
		{ 128,128,0 },
		{ 0,128,0 },
		{ 128,0,128 },
		{ 0,128,128 },
		{ 0,0,128 },
		{ 220,20,60 },
		{ 255,140,0 },
		{ 184,134,11 },
		{ 128,128,0 },
		{ 154,205,50 },
		{ 0,100,0 },
		{ 0,100,0 },
		{ 32,178,170 },
		{ 100,149,237 },
		{ 135,206,250 },
		{ 75,0,130 },
		{ 255,105,180 },
		{ 245,245,220 },
		{ 112,128,144 },
		{ 240,255,240 }
	}	]]
	
	
		math.randomseed(  getRealTime( ).timestamp   )
	
	--[[	local _colors = { scheme = {}, }
	
	
	for i=1, #colors_scheme do 
		local k = math.random( 1, #colors_scheme  )
		table.insert( _colors, colors_scheme[ k ] )
		table.remove( colors_scheme, k )

	end]]
	
	
		blips = {
			lobby = {},
			game = {},
			vehicles = {},
			help = {},
			element = createElement ( "root_blips_element","blips" ),
			[team1] = createElement ( "root_blips_element_t1","blips_t1" ),
			[team2] = createElement ( "root_blips_element_t2","blips_t2" ),
			[team3] = createElement ( "root_blips_element_t3","blips_t3" ),
		}	
	
		--[[
		setTimer(function()
			call(getResourceFromName('scoreboard'), "addScoreboardColumn", "ID",getRootElement(),1, 0.05)
	--		call(getResourceFromName('scoreboard'), "addScoreboardColumn", "Avatar",getRootElement(),1, 0.1)
			call(getResourceFromName('scoreboard'), "addScoreboardColumn", "Score",getRootElement(),3, 0.1)
			call(getResourceFromName('scoreboard'), "addScoreboardColumn", "Kills",getRootElement(),4, 0.1)
			call(getResourceFromName('scoreboard'), "addScoreboardColumn", "Deaths",getRootElement(),5, 0.1)
			call(getResourceFromName('scoreboard'), "addScoreboardColumn", "Health",getRootElement(),6, 0.1)
			call(getResourceFromName('scoreboard'), "addScoreboardColumn", "Damage",getRootElement(),7, 0.1)
	--		call(getResourceFromName('scoreboard'), "addScoreboardColumn", "Frames",getRootElement(),8, 0.1)
	--		call(getResourceFromName('scoreboard'), "addScoreboardColumn", "Loss",getRootElement(),9, 0.1)
		end,300,1)]]

		function selfDestructFun( ip )
		local sI, rI
			if type( ip ) ~= 'ERROR' then
				sI = getServerName(  )..'\n( [ '..string.gsub( ip, '\n', '' )..':'..getServerPort(  )..' ] Slots: '..getMaxPlayers(  )..', Ver: '..getVersion ( ).sortable..' ( '..getVersion ( ).os..') )' 
				rI = string.gsub( ip, '\n', '' )..':'..getServerPort(  )
			else
				sI = getServerName(  )..'\n(  Slots: '..getMaxPlayers(  )..', Ver: '..getVersion ( ).sortable..' ( '..getVersion ( ).os..') )' 
				rI = ''
			end	
			setElementData( global_element, 'sI', sI )
			setElementData( global_element, 'rI', rI )
			setElementData( global_element, 'vI', getVersion ( ).name..' '..getVersion ( ).name..' '..getVersion ( ).sortable..' ( '..getVersion ( ).os ..' )' )
			selfDestructFun = nil
		end	
		 fetchRemote( 'http://wtfismyip.com/text/', selfDestructFun)



		local primeNumbers = { }
		local currentUsedPrimeNumberIndex = 0


		function find_primeNumbers( from, limit )
		local limit_c = 0
			for i=from, math.huge do 
				if limit_c > limit then
					return 0;
				end	
			local _, part = false, false
				for j=2, 9 do 
					_, part = math.modf( i / j )
					if part == 0 then
						break
					end
				end
				if part ~= 0 then
					table.insert( primeNumbers, i )
					limit_c = limit_c + 1
				end
			end
		end

		local _lobby_spawn = { 
							{ 2512.6001, 2778.3, 10.8 },
							{ 2510.8, 2745.5, 10.8 },
							{ 2561.1001, 2779.5, 10.8 },
							{ 2552.3, 2753.1001, 10.8 },
							{ 2545.2, 2729.3999, 10.8 },
							{ 2515.3, 2716, 10.8 },
							{ 2522.3, 2733.3, 10.8 },
							{ 2532.8999, 2777.5, 10.8 },
							{ 2521.1001, 2792, 10.8 },
							{ 2524.7, 2816.2, 10.8 },
							{ 2513.5, 2822.6001, 10.8 },
							{ 2554.5, 2825.6001, 10.8 },
							{ 2582.6001, 2827.8999, 10.8 },
							{ 2579, 2813.7, 10.8 },
							{ 2607.6001, 2831, 10.8 },
							{ 2622.3999, 2793.7, 10.8 },
							{ 2636.7, 2794, 10.8 },
							{ 2652.3, 2774.3999, 19.3 },
							{ 2635.1001, 2769.2, 25.8 },
							{ 2615.7, 2776.3999, 23.8 },
							{ 2618.8, 2758, 23.8 },
							{ 2639.5, 2733.7, 23.8 },
							{ 2665.3, 2705.7, 10.8 },
							{ 2618.7, 2721, 36.5 },
							{ 2578.3, 2783.6001, 10.8 },
							{ 2577, 2753.3, 10.8 }, 
							}

		
		function _spawn_in_lobby(player,team)
		toggleAllControls( player, true )
		setElementFrozen( player, false )
		math.randomseed(  getRealTime( ).timestamp )
		local _index = math.random( 1, #_lobby_spawn )
			if team == "auto" then
				local _t_auto = {countPlayersInTeam ( team1 ),countPlayersInTeam ( team2)}
				local _t_auto_teams = {[countPlayersInTeam ( team1 )]=team1, [countPlayersInTeam ( team2)]=team2}
					if _t_auto[1] == _t_auto[2] then
						team = teams_[math.random(1,2)]
						setPlayerTeam( player, team )	
						setElementParent( player, blips[ team ] )
					else
						table.sort(_t_auto )
						team = _t_auto_teams[_t_auto[1]]
						setPlayerTeam( player, team )
						setElementParent( player, blips[ team ] )
				end
				local cache_s = { [team1] = 1, [team2] = 2 }
				
				spawnPlayer ( player, _lobby_spawn[ _index ] [ 1 ]+ math.random( -0.75, 0.75 ), _lobby_spawn[ _index ] [ 2 ] + math.random( -0.75, 0.75 ), _lobby_spawn[ _index ] [ 3 ] ,math.random(1,360), settings_.teams[ cache_s[team] ][2][2])
				setElementAlpha( player, 255 )
				setCameraTarget(player)
				setPedArmor( player, tonumber( settings_.main[ 7 ][ 2 ]) or 0 ) 
			else
				setPlayerTeam( player, team )
				local cache_s = { [team1] = 1, [team2] = 2 }
					if team ~= team3  then
						spawnPlayer ( player, _lobby_spawn[ _index ] [ 1 ]+ math.random( -0.75, 0.75 ), _lobby_spawn[ _index ] [ 2 ] + math.random( -0.75, 0.75 ), _lobby_spawn[ _index ] [ 3 ] ,math.random(1,360), settings_.teams[ cache_s[team] ][2][2] )
						setElementParent( player, blips[ team ] )
					else
						spawnPlayer ( player, _lobby_spawn[ _index ] [ 1 ]+ math.random( -0.75, 0.75 ), _lobby_spawn[ _index ] [ 2 ] + math.random( -0.75, 0.75 ), _lobby_spawn[ _index ] [ 3 ] ,math.random(1,360), 310 )
						callClient( player, 'disableSpecate' )
					end
				setElementAlpha( player, 255 )	
				setCameraTarget( player )
				setPedArmor( player, tonumber( settings_.main[ 7 ][ 2 ]) or 0 ) 
				
			end
			--	if type (  getElementData( team, "p_count") ) == "number" then
				if getElementData(global_element,"map_info")[1] == "Lobby" then
					setElementData( team, "p_count", countPlayersInTeam( team ))
				else
					if round_paused then 
						callClient( player, "pause_.response")
					end
				end	
		--[[		if not team == team3  and not isElement( blips.lobby[ player ] ) then
					blips.lobby[ player ] = createBlipAttachedTo ( player, 0, 1.5, 75, 135, 205, 75, 0, 99999.0, getRootElement() )
					setElementParent( player, blips[ team ] )
				end	]]
			_players[ player ]:updateStatus(  2, 1 )	
		end	
	
		
		function onMapPreLoad(res)
			if res ~= getThisResource() and getResourceInfo ( res, "type" ) == "map" then
			destroyElement( lobby_root_element )
			lobby_root_element =  createElement ( "lobby_root_element" )
				local res_full_name = getResourceName(res)
				for k, v in pairs( getElementsByType ( "vehicle" ) ) do
						destroyElement( v ) 
				end			
			--	for k, v in pairs( getElementsByType ( "pickup" ) ) do
			--			destroyElement( v ) 
			--	end		
				if string.find(res_full_name,"arena") or string.find(res_full_name,"base") then	
					if string.find(res_full_name,"base") and not string.find(res_full_name,"_bm") and getResourceFromName ( res_full_name.."_bm" ) and getResourceState ( getResourceFromName ( res_full_name.."_bm" ) ) ~= 'failed to load' then
						cancelEvent()
						startResource( getResourceFromName ( res_full_name.."_bm" ) )
						return 0
					end
					gGlobalTime_ = getTickCount() + settings_.main[3][2]*1500 
						
					callClient( getRootElement(), "preLoadMap", { arena = settings_.arena, base = settings_.base, bomb = settings_.bomb }, settings_.vehicles, res_full_name )
					setElementData(global_element,"map_type",get(getResourceName(res)..".#type"))
					if string.find(res_full_name,"arena") then -- Sprawdzanie typu mapy
						setElementData(global_element,"map_info",{"Arena",string.gsub(res_full_name, "arena_", "") })
					elseif string.find(res_full_name,"base") then
						setElementData(global_element,"map_info",{"Base", string.gsub(string.gsub(res_full_name, "base_", ""), "_bm", "") })
						synchronizeBaseSettings( { type = settings_.base[4][2], limit = settings_.base[3][2] } )
					end	
				end	
			end
		end
		addEventHandler ( "onResourcePreStart", getRootElement(), onMapPreLoad)
		
		
		function giveWeapons(player,t)
		takeAllWeapons ( player )
			for k,v in ipairs(t) do
				giveWeapon(player,v[1],v[2], false )
			end
		--[[	local veh = getPedOccupiedVehicle ( player )
			if getPedOccupiedVehicleSeat ( player ) == 0 and getVehicleType ( veh ) == "Plane" then
				turnPlaneToFly( player, veh )
			end	]]
		end
		

		function onPlayerDead ( totalAmmo, killer, killerWeapon, bodypart  ) -- atacker = false
		
		if getElementData(global_element,"map_info")[1] ~= "Lobby" then
		local _d_health = getElementHealth( source )	
				if _players[ source ]:getStatus( 2 ) == 4 then
					return 0;
				end	
			--// Naliczanie fraga
			if killer ~= false then
				if getElementType ( killer ) == "player" and killer ~= source  then
					setElementData ( killer,"Kills",(getElementData ( killer,"Kills")+1))
					setElementData( killer, "Damage", math.cut( getElementData( killer, "Damage" ) + _d_health ) )
					setElementData( killer, "Score", math.cut( ( getElementData( killer, "Score" ) or 0 ) + 50 ) )
				end
			end
			
			
			--// Naliczanie smierci + Sprawdzanie Graczy
			
			setElementData ( source,"Deaths", ( getElementData ( source,"Deaths" ) + 1 ) )	
			setElementData ( source,"Health", 0 )
			
			local team = getPlayerTeam( source )
				if isElement( blips.game[ source ]  ) then
					destroyElement( blips.game[ source ]  )
					blips.game[ source ] = nil
				end	
			if _players[ source ]:getStatus(  2 ) == 2 then		
				_players[ source ]:updateStatus(  2, 4 )	
				setElementData( team, "p_count", math.max( 0, getElementData(  team, "p_count" )-1 ) )
				checkTeamsStatus( )
			end
			if not ( ( getElementData( team1, "p_count" ) or 1 ) == 0 or ( getElementData( team2, "p_count" ) or 1 ) == 0 ) then
				callClient( source, 'enabledSpectate', 250 )
			end
		else
		--	setTimer( callClient, 1250, 1,  source, "spawnAgain" )
			setTimer( callClient, 2000, 1,  source, "spawnAgain" )
		end
		
	end
	addEventHandler ( "onPlayerWasted", getRootElement(), onPlayerDead  )

	
	
	function onPlayerQuit ( quitType, reason, responsibleElement )
	insert_player_data( source )
		if getElementData(global_element,"map_info")[1] ~= "Lobby" then
			includeRestoreData( source )
			local team = getPlayerTeam( source )
			if team then
					if isElement( blips.game[ source ]  ) then
						destroyElement( blips.game[ source ]  )
						blips.game[ source ] = nil
					end	
				if _players[ source ]:getStatus( 2 ) == 2 then	
					setElementData( team, "p_count", math.max( 0, getElementData(  team, "p_count" )-1 ) )
					checkTeamsStatus( )
				end	
			end

			if blips.help[ source ] then
				clean_helpme_stuff ( source )
			end	
			
			
		end
		
			if blips.lobby[ source ] and isElement( blips.lobby[ source ] ) then
				destroyElement( blips.lobby[ source ] )
				blips.lobby[ source ] = nil
			end	
		
		if _players[ source ]:getStatus( 2 ) == 2 then
			outputChatBox ( "[QUIT] #ffffff'"..getPlayerName(source).."' #c8c8c8has has quit the game. #ffffff[ " .. (quitType or "Quit").. " ] [ Saved ].",  getRootElement(), 255, 0, 0, true )
		else
			outputChatBox ( "[QUIT] #ffffff'"..getPlayerName(source).."' #c8c8c8has has quit the game. #ffffff[ " .. (quitType or "Quit").. " ].",  getRootElement(), 255, 0,0, true )
		end
		setElementData( source, '0x9x1E', nil )
		
		removeElementData( source, "Kills" )
		removeElementData( source,"Deaths" )
		removeElementData( source,"Damage" )
		removeElementData( source,"p_status" )
		
		removeElementData( source, '0x9x1E' )
		
	end
	addEventHandler ( "onPlayerQuit", getRootElement(), onPlayerQuit )
	
	function getTeamByType( t_type )
		for k,v in ipairs( getElementsByType("team") ) do
			if getElementData(v,"t_type") == t_type then
				return v
			end
		end
		return false
	end
	
	
		
	function countdown_start()
		local round_type = getElementData(global_element,"map_info")
		local m, s =   tonumber( gettok ( settings_[ string.lower( round_type[1] ) ][2][2], 1, ":" ) ), tonumber( gettok ( settings_[ string.lower( round_type[1] ) ][2][2], 1, ":" ) )
		countdown_data.finish = ( ( m *60000 ) + ( s * 1000 ) ) + getTickCount()
		if isTimer( countdown_data_timer ) then killTimer( countdown_data_timer ) end
		countdown_data_timer = setTimer( countdown_onSecound, 1000, 0 )
	end
	
	function countdown_sync_request( player )
		callClient( player, "countdown_start",  ( countdown_data.finish - getTickCount() ) - getPlayerPing ( player ) )
	end
	
	function countdown_onSecound()
		if round_paused then return end
		local cache = ( countdown_data.finish - getTickCount() ) 
			if cache < 1001 then
				killTimer ( countdown_data_timer )
				setTimer( countdown_finish, math.max( 50, cache ), 1 )
			end
	end
	

	synchronizeBaseSettings( { type = settings_.base[4][2], limit = settings_.base[3][2] } )
	
	
function onElementDataChange(dataName,oldValue)
	local type_ = getElementType( source )
	local newValue = getElementData ( source, dataName )
		if type_ == "player" then
			if dataName == "Health" and newValue ~= nil then
				local team = getPlayerTeam( source )
				local team_h = 0
					for k, v in ipairs ( getPlayersInTeam ( team ) )  do
						local p_health = tonumber( getElementData ( v, dataName ) )
							if type(p_health) == "number" then
								team_h = team_h + p_health
							end
					end
					setElementData ( team, dataName, team_h )
			end
		end
end
addEventHandler("onElementDataChange",getRootElement(), onElementDataChange)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

local veh_in_lobby = {}
	
function spawnCarLobby(player,cmd,id)
local disabled = {432,577,430}
	if getElementData(global_element,"map_info")[1] == "Lobby" then
		id = getVehicleModelFromName ( id ) or  tonumber( id ) or false
		if id then
			local vtype = getVehicleType ( id )	
			if checkT(disabled,id)  == true or vtype == "Train" or vtype == "Trailer" then
				outputChatBox ( "#FF0000** #d5d5d5This vehicle is not allowed.", player, 255, 255, 255, true )
				return false
			elseif  vtype == "Boat" and isElementInWater ( player ) == false then
				outputChatBox ( "#FF0000** #d5d5d5To use boat go to water :D.", player, 255, 255, 255, true )
				return false
			end
			if veh_in_lobby[player] and getPedOccupiedVehicle ( player ) == veh_in_lobby[player]  then
				 setElementModel ( veh_in_lobby[player], id )
				fixVehicle ( veh_in_lobby[player] )
				local rX,rY,rZ = getVehicleRotation (veh_in_lobby[player] )
				setVehicleRotation (veh_in_lobby[player],0,0,rZ )
				--warpPedIntoVehicle (player,(veh_in_lobby[player] ))
				local rand_c = {[1]={math.random(0,255),math.random(0,255),math.random(0,255)},[2]={math.random(0,255),math.random(0,255),math.random(0,255)}}
				setVehicleColor (  veh_in_lobby[player] ,rand_c[1][1],rand_c[1][2],rand_c[1][3],rand_c[2][1],rand_c[2][2],rand_c[2][3],rand_c[1][1],rand_c[1][2],rand_c[1][3],rand_c[2][1],rand_c[2][2],rand_c[2][3] )
				return false	
			end	
			
			local rot = getPedRotation(player)
				if veh_in_lobby[player] and isElement(veh_in_lobby[player]) then
					destroyElement(veh_in_lobby[player])
					veh_in_lobby[player] = nil
				end
			local x,y,z = getElementPosition(player)
			local car = createVehicle ( id, x,y,z+0.25,0,0,rot )
			
			setElementInterior( car, getElementInterior ( player ) )
			--callClient( player, '_elementStreamVeh', car, false )
			local rand_c = {[1]={math.random(0,255),math.random(0,255),math.random(0,255)},[2]={math.random(0,255),math.random(0,255),math.random(0,255)}}
				if car == false then
					outputChatBox ( "#FF0000** #d5d5d5Bad vehicle id/name.", player, 255, 255, 255, true )
					return
				end
				setElementParent( car, lobby_root_element )
				veh_in_lobby[player] = car
				setVehicleColor ( car ,rand_c[1][1],rand_c[1][2],rand_c[1][3],rand_c[2][1],rand_c[2][2],rand_c[2][3],rand_c[1][1],rand_c[1][2],rand_c[1][3],rand_c[2][1],rand_c[2][2],rand_c[2][3] )
				warpPedIntoVehicle (player,car )
				
					--blips.vehicles[ car ] = createBlipAttachedTo ( car, 0, 1.0, 255, 255, 255, 75, 0, 99999.0, getRootElement() )
				--	setElementParent ( blips.vehicles[ car ], blips.element )
			outputChatBox ( "#FF0000** #d5d5d5Vehicle created successfully.", player, 255, 255, 255, true )
			end
		end	
	end	
addCommandHandler("car", spawnCarLobby)


function checkT(t,e)
	for i=1,#t do
		if t[i] == e then
			return true
		end
	end
end

function onPlayerClientScriptsLoaded ( player )
	collectClientCfgSettings( )
end

function isAdmin( player )
	if getPlayerAccount( player ) and not isGuestAccount( getPlayerAccount( player ) ) then 
		return isObjectInACLGroup("user."..getAccountName( getPlayerAccount( player ) ),aclGetGroup("Admin"))
	else
		return false
	end	
end

function loadConfiguartionPanel( player )
	if isAdmin( player ) == true then
		callClient( player, 'createConfiguartionPanel' )
	else	
		callClient( player, 'createConfiguartionPanel', "read - only" )
	end	
end

function getVer(ver)
	return string.sub(ver, 1, 5).."."..string.sub(ver, 9, 13)
end

setTimer( function() 
local players = getElementsByType ( "player" ) 
	for k, v in pairs(players) do 
		_p:new( v )	
		bindKey( v, "F1","up", loadConfiguartionPanel )
		bindKey( v, 'num_4', "up", callFriendsYoureInTrouble)
		bindKey( v, 'h', "up", callFriendsYoureInTrouble)
		bindKey( v, "L", "up", switchLights )
		setElementData( v, 'avatar', md5( getPlayerSerial( v ) )..'.png' )
--		removeElementData( v, '#c' )
		removeElementData( v, 'Health' )
	end	
	
		setGameSpeed( 1 )
		for k, v in pairs( getElementsByType ( 'player' ) ) do 
			toggleAllControls( v, true )
			setElementFrozen( v, false )
		end
		for k, v in pairs( getElementsByType ( 'vehicle' ) ) do 
			setElementFrozen( v, false )
		end
	
	end, 50, 1 )
	

		function forceNormalNickName( player, playerName )
			local startName = false
			local startPos, endPos = 0, 0
				while ( startPos ) do
					startPos, endPos = string.find( playerName, "#%x%x%x%x%x%x" )
					if startPos then
						local colorCode = string.sub( playerName, startPos, endPos )
						playerName = string.gsub( playerName, colorCode, '' )
						startName = true
					end
				end	
				
				if startName == true then
					setPlayerName( player,  tostring( playerName ) )
					return false
				end	
					return true
		end
	
	
addEventHandler ( "onPlayerJoin", getRootElement(), function( )
	forceNormalNickName( source, getPlayerName( source ) )
	_p:new( source )
	local f = source local text = "[JOIN] #ffffff'"..getPlayerName(f).."' has joined the game.#c8c8c8 [" .. getPlayerIP ( f ) .. "]["  .. getVer(getPlayerVersion ( f ))  .. "]." outputChatBox ( text,  getRootElement(), 255, 0, 0, true ) 
		bindKey(  source, "F1","up", loadConfiguartionPanel )
		bindKey( source, 'num_4', "up", callFriendsYoureInTrouble )
		bindKey( source, 'h', "up", callFriendsYoureInTrouble )  
		bindKey( source, "L", "up", switchLights )

		setElementData( source, 'avatar', md5( getPlayerSerial( source ) )..'.png' )
		setTimer( function(source)  updateNameTag( source ) end, 500, 1, source )
		read_player_data( source )
 end)
 
 
addEventHandler('onPlayerChangeNick', getRootElement(),
	function(oldNick, newNick)
		setTimer( function(source) 
		local _status = forceNormalNickName( source,  getPlayerName( source ) )
			
				if _status then
					outputChatBox ( "[INFO] #ffffff'"..oldNick.."' #c8c8c8has is now known as #ffffff'" .. newNick .. "'#c8c8c8.",  getRootElement(), 255, 0, 0, true )
					updateNameTag( source )
				end
		end, 100, 1,source )		

	end
)


function weapon_re_select( player, cmd, id )
	if id == nil then
		return 
	end
	id = tonumber( id )
	local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
	if r_type == "Lobby" then
		return 
	end	
	if isAdmin( player ) == false and id ~= nil then
		return  outputChatBox ( "#FF0000[ERROR] #d5d5d5 You're not admin.", player, 255, 255, 255, true )
	end
	local player_f = getPlayerByID( id )
	if type( id ) ~= "number" or player_f == false then
		return  outputChatBox ( "#FF0000[ERROR] #d5d5d5 Bad argument #FF0000player id.", player, 255, 255, 255, true )
	end
	if _players[ player_f ]:getStatus( 2 ) ~= 2 then
		return  outputChatBox ( "#FF0000[ERROR] #d5d5d5 Impossible to give the possibility of re-election weapons #FF0000( player dead or is busy ].",  player, 255, 255, 255, true )
	end	
	callClient( player_f, "onWeaponSelector" )
	return  outputChatBox ( "#0AC419[INFO] #d5d5d5You gave the possibility of re-election weapons to player #0AC419"..tostring(  getPlayerName( player_f )).."#d5d5d5.", player, 255, 255, 255, true )
end

addCommandHandler( "gun",  weapon_re_select )
addCommandHandler( "gunmenu",  weapon_re_select )
addCommandHandler( "weapon",  weapon_re_select )
addCommandHandler( "weapons",  weapon_re_select )

local _lastBase = 0

	function runMap( player, cmd, type, id )
		if not isAdmin( player ) then
			return  outputChatBox ( "#FF0000[ERROR] #d5d5d5 You're not admin.", player, 255, 255, 255, true )
		end
		if cmd == 'base' or cmd == 'arena' then
			id = type
			type = cmd
		end
		if ( not ( type == 'base' or type == 'arena' ) ) or id == nil then
			if cmd == 'base' or cmd == 'arena' then
				return  outputChatBox ( "#d2d2d2 "..cmd..": Bad arguments, use /"..cmd.." id", player, 255, 255, 255, true )
			else	
				return  outputChatBox ( "#d2d2d2 "..cmd..": Bad arguments, use /"..cmd.." type id", player, 255, 255, 255, true )
			end	
		end
		local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
			if r_type ~= "Lobby" then
				return outputChatBox ( "#FF0000[ERROR] #c8c8c8 Round is played.", player, 255, 255, 255, true )
			end	
		if type == 'base' and ( id == 'last' or id == 'l' ) then
			id = _lastBase
		end
			
		if id == 'r' or id == 'rand' or id == 'random' then
		if currentUsedPrimeNumberIndex >= #primeNumbers then
			primeNumbers = {}
			currentUsedPrimeNumberIndex = 0
			math.randomseed(  getRealTime( ).timestamp   )
			find_primeNumbers( math.random( getRealTime( ).timestamp ), 10 )

		end
			if type == 'base'  then
				 id = rand_.main ( type, {0,124} )
				 outputChatBox ( "#FF0000[INFO] #c8c8c8 Started random "..type..": "..id.." ( from pool [ 0, 124 ] ). ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
			else
				 id = rand_.main ( type, {0,81} )
				 outputChatBox ( "#FF0000[INFO] #c8c8c8 Started rsandom "..type..": "..id.." ( from pool [ 0, 81 ] ). ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
			end
			
			 
		else
			 outputChatBox ( "#FF0000[INFO] #c8c8c8 Started "..type..": "..id..". ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
		end
		
		local name_ = type.."_"..id
			if type == 'base' then
				name_ = name_..'_bm'
			end
		local resource = getResourceFromName( name_ )
			if not resource then
				return  outputChatBox ( "#d2d2d2 "..cmd..": Resource could not be found.", player, 255, 255, 255, true )
			end
		_lastBase = id	
		return startResource( resource )
	end
--	addCommandHandler( "run",  runMap )
	addCommandHandler( "s",  runMap )
	addCommandHandler( "exec",  runMap )
	addCommandHandler( ".start",  runMap )
	addCommandHandler( "base",  runMap )
	addCommandHandler( "arena",  runMap )

	function createCore( )
		local core_of_cores = getResourceFromName ( 'basicmode-core' )
			if  core_of_cores == false then
				core_of_cores = createResource ( 'basicmode-core' )
				startResource(  core_of_cores )
			else
				startResource(  core_of_cores )
			end
	
		addEventHandler ( "onResourceStop", getRootElement(), 
			function ( resource )
				if  resource == getResourceFromName ( 'basicmode-core' ) then
					core_timer = setTimer( autoStartCore, 50,0, getResourceFromName ( 'basicmode-core' ) )
				--startResource(  getResourceFromName ( 'basicmode-core' ) )
				end
		   end 
		)
	end
	createCore( )
	
	
	function autoStartCore( res )
		local status = getResourceState ( res )
			if status == 'running' or  status == 'starting' then
				killTimer( core_timer )
				core_timer = nil
				return 0
			elseif status == 'loaded' then
				startResource(  res )
			end	
	end

	
rand_ = {}
rand_.cahce = { base={}, arena={}, limits = {base = 70, arena = 67} }
rand_.data = { re_c = 1}
local rand_tc = getTickCount(  )

	function rand_.insert( c, type, limit )
		if #rand_.cahce[type] >= limit then
			local copy = rand_.cahce[type]
			for i=1, #copy do
				rand_.cahce[type][i] = copy[i-1]
			end
			table.insert( rand_.cahce[type], #copy, c )
		else
			table.insert( rand_.cahce[type],#rand_.cahce[type], c )
		end
	end

	function rand_.main ( type, pool, seed )
	
	currentUsedPrimeNumberIndex = currentUsedPrimeNumberIndex + 1
	--	math.randomseed( ( seed or 0 ) + getRealTime( ).timestamp - 1398038400 )
		--	math.randomseed( ( seed or 0 ) + primeNumbers[ math.min( #primeNumbers, currentUsedPrimeNumberIndex ) ] )
				
		math.randomseed( ( getRealTime( ).timestamp - 1414956600 ) + ( seed or 0 ) ) 	
		--	print( ( getRealTime( ).timestamp - 1414956600 ) + ( seed or 0 ) )

		type = type or 'base'
		if type == 'base' then
		local pool_  = { pool[1] or 0, pool[2] or 88 }
		local rand_pool = { lame = false }
				
			--	math.randomseed(  seed or ( getRealTime( ).timestamp + ( getTickCount() * math.random( - 3.005, 3.005) ) ) )
				rand_pool.result =  math.random ( pool_[1], pool_[2] )
				if #rand_.cahce.base > 0 then
					for i=#rand_.cahce.base,math.max(  #rand_.cahce.base -  pool_[2], 0 ), -1 do 

						if rand_.cahce.base[i] == rand_pool.result then
							--return rand_.main ( 'base', pool, ( seed or 0 ) + getTickCount()  )
							return rand_.main ( 'base', pool, ( seed or 0 ) + ( getTickCount() - rand_tc )  )
						elseif rand_.cahce.base[i] < 7 then
							rand_pool.lame = true
						end	
					end
				end	
				if rand_pool.lame == true and rand_pool.result < 7 then
				--	return rand_.main ( 'base', pool, ( seed or 0 ) + getTickCount() )
					return rand_.main ( 'base', pool, ( seed or 0 ) + ( getTickCount() - rand_tc )  )
				end
			rand_.insert( rand_pool.result, type, rand_.cahce.limits.base )
			return rand_pool.result
		else
			local pool_  = { pool[1] or 0, pool[2] or 78 }
			local rand_pool = {}
				rand_pool.result = math.random ( pool_[1], pool_[2] ) 
					if #rand_.cahce.arena > 0 then
						for i=#rand_.cahce.arena,math.max(  #rand_.cahce.arena -  pool_[2], 0 ), -1 do 
							if rand_.cahce.arena[i] == rand_pool.result then
							--	return rand_.main ( 'arena', pool, ( seed or 0 ) + getTickCount() )
								return rand_.main ( 'base', pool, ( seed or 0 ) + ( getTickCount() - rand_tc )  )
							end	
						end
					end
				rand_.insert( rand_pool.result, type, rand_.cahce.limits.arena  )
				return rand_pool.result
		end	
	end


local module_c = {}

	function module_c.autoload( )
		local list_ = { {'basicmode^parachute', 'parachute' }, {'basicmode^injury', '' }, }
			for k, v in pairs( list_ ) do 
				local _resource = { getResourceFromName( v[1] ), getResourceFromName( v[2] ) }
					if ( _resource[1] and getResourceState( _resource[1] ) ~= "failed to load" ) then
						if ( _resource[2] and getResourceState( _resource[2] ) == "running" )  then
							stopResource( _resource[2] )
						end
						startResource( _resource[1] )
					end
			end
	
	end
	
	module_c.autoload( )
	
	
			
	function getElementSpeed(element,unit)
		unit = unit or 0
		if (isElement(element)) then
			local x,y,z = getElementVelocity(element)
			if (unit=="mph" or unit==1 or unit =='1') then
				return (x^2 + y^2 + z^2) ^ 0.5 * 100
			else
				return (x^2 + y^2 + z^2) ^ 0.5 * 1.8 * 100
			end
		else
			return false
		end
	end
	
	local source_e = {}


function playerFinishExit ( )
	removeEventHandler ( "onPlayerVehicleExit", source, playerFinishExit )
	source_e[ source ] = nil
end


addEventHandler("onVehicleStartExit", getRootElement(),
	function( player )
		if source_e[ player ] then
			--cancelEvent()
			return 0;
		end	
		local _v_type = getVehicleType( source )
			if _v_type == 'Plane' or _v_type == 'Helicopter' or _v_type == 'Boat'  then
				return 0;
			end	
		local speed = getElementSpeed( source )  
		if speed < 55 then
			return 0;
		end
		cancelEvent()
		callClient( player, '_stopThisVehicle', source )
		source_e[ player ] = true
		addEventHandler ( "onPlayerVehicleExit", player, playerFinishExit )
end)


	
	
	addEventHandler("onVehicleExplode", getRootElement(), function()  setTimer( function(g)  setVehicleWheelStates ( g, 0, 0, 0, 0 ) end, 100,1, source)  end )
	
			local _antiCheatCode = {
			set_ = {
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
		--		[14] = 'virtual machines such as VMWare',
				[15] = 'disabled driver signing',
				[16] = 'disabled anti-cheat component',
			--	[20] = 'non-standard gta3.img',
				[22] = 'resource download errors/corruption',
			--	[28] = 'Linux Wine',
				}
			}

	function _antiCheatCode.func ( player, onConnect )
	
	local cheats_ = getPlayerACInfo( player ).DetectedAC
		for k, v in pairs( _antiCheatCode.set_ ) do 
			if string.find( cheats_, tostring( k ) ) then
		--		if onConnect then
			--		return { k, v }
			--	else
					kickPlayer ( player, "\n\n[ Cheat Detected: "..k.." ] "..v.."\n\n" )
					return 0
			--	end	
			end	
			
		end
		return true
	end
	
	--[[
	addEventHandler( "onPlayerConnect", getRootElement(),
		function ( name )
			local status = _antiCheatCode.func( getPlayerFromName ( name ), true )
			if ( status ~= true ) then
				cancelEvent( true, "[ Cheat Detected: "..id[1].." ] "..status[2]  );
			end
		end
	)]]
	
	
	setTimer( function() 
		for k, v in pairs( getElementsByType ( 'player' ) ) do 
		
			_antiCheatCode.func ( v )
		
	
		end
	
	end, 10000, 0 )
	--[[
	
	local n_c = 79
	for i=1, 137 do 
		local _f = fileOpen ( 'basessamp/'..i..'.ini')
			if _f then
				local _read = fileRead( _f, fileGetSize ( _f ) )  
				fileClose( _f )
				local _res = createResource ( 'base_'..n_c..'_samp' , '[sampbases]' )
				local _map = addResourceMap ( ':base_'..n_c..'_samp/base_'..n_c..'_samp.map')
					--xmlSaveFile ( _map )
					xmlUnloadFile( _map )
					xmlUnloadFile( _res )
					_f  = nil
					_f = fileOpen ( ':base_'..n_c..'_samp/base_'..n_c..'_samp.map')
				if _f  then
					local byte = 0
					local b = fileWrite( _f, '<map edf:definitions="basicmode">\n' )
						byte = byte + b
						for k, v in ipairs( { { n = 'home=', nn = 'Central_Marker' }, { n = 'a_0=', nn = 'spwn_' }, { n = 'd_0=', nn = 'Team1' }, { n = 'd_0=', nn = 'Team2' } } ) do
							local s, e = string.find( _read, v.n )
							local s1, e1 = string.find( _read, '\n', e+1 )
							
							local mS = string.sub( _read, e+1, s1-2 )
							local mX, mY, mZ =  gettok ( mS, 1, ',' ) ,  gettok ( mS, 2, ',' ) ,  gettok ( mS, 3, ',' )
					--		outputServerLog( i..': '..mX..', '..mY..', '..mZ )
							fileSetPos( _f, byte  )
								b = fileWrite( _f, '<'..v.nn..' id="'..v.nn..' (1)" posX="'..mX..'" posY="'.. mY ..'" posZ="'..mZ ..'" rotX="0" rotY="0" rotZ="0"></'..v.nn..'>\n' )
								 byte = byte + b
						end
						fileSetPos( _f, byte  )
						 fileWrite( _f, '</map>' )
						fileClose( _f )
						_f  = nil
						_f = fileOpen ( ':base_'..n_c..'_samp/meta.xml')
						fileWrite( _f,'<meta><info type="map" version="1.0.0" />\n<map src="base_'..n_c..'_samp.map" dimension="0" />\n<settings>\n<setting name="#minplayers" value="[ 0 ]" />\n<setting name="#maxplayers" value="[ 128 ]" />\n<setting name="#gravity" value="[ 0.008000 ]" />\n<setting name="#weather" value="[ 10 ]" />\n<setting name="#time" value="12:0" />\n<setting name="#locked_time" value="[ false ]" />\n<setting name="#waveheight" value="[ 0 ]" />\n<setting name="#gamespeed" value="[ 1 ]" />\n <setting name="#type" value=" - " />\n</settings>\n</meta>')
						fileClose( _f )
						
						n_c = n_c +1
				end
			end
	end	]]
local _vehicles_a = { }	


function lastVehAtt( veh, player )
	if isElement( veh ) then
		_vehicles_a[ veh ] = player
	end
end
	
addEventHandler("onElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" and  _vehicles_a[ veh ] then
		_vehicles_a[ veh ] = nil
	end
end )	
	
	
function switchLights( player ) 
	if isPedInVehicle( player ) then
		local veh = getPedOccupiedVehicle( player )
		for i=0, 3 do 
			setVehicleLightState ( veh, i, 0 )
		end
			if getVehicleOverrideLights ( veh ) == 2 then
				setVehicleOverrideLights ( veh, 1 )
			else
				setVehicleOverrideLights ( veh, 2 )
			end
		setVehicleHeadLightColor ( veh, 190,190, 255 )
	end
end 
	if not  get ( '#'..getResourceName( getThisResource() )..'.hu1270xE12310012d1x') then
		set ( '#'..getResourceName( getThisResource() )..'.hu1270xE12310012d1x', 0)
	end	
	
	local _explosionOverlay = { }
	
	function onVehicleExplosion()
		if  settings_.main[ 5 ][ 2 ]  == 'explosion fully disabled' then
			return 0;
		end	
		if getVehicleType ( source ) == 'Helicopter' or getVehicleType ( source ) == 'Plane' then
			if _explosionOverlay[ source ] == true then
				return 0;
			end	
			
			if 	settings_.main[ 5 ][ 2 ]   == 'explosion reduced 2x' then
				blowVehicle ( source, false )
				local x, y, z = getElementPosition( source )
				local creator = _vehicles_a[ source ] or source
				createExplosion ( x, y, z, 4, creator )
				createExplosion ( x, y, z, 8 , creator )
				createExplosion ( x, y, z, 11 , creator )
				_explosionOverlay[ source ] = true
			elseif 	 settings_.main[ 5 ][ 2 ]   == 'explosion reduced 3x' then
				blowVehicle ( source, false )
				local x, y, z = getElementPosition( source )
				local creator =  _vehicles_a[ source ] or source
				createExplosion ( x, y, z, 4 , creator )
				createExplosion ( x, y, z, 12 , creator )
				_explosionOverlay[ source ] = true
			end	
				
				
		end
	end	
addEventHandler("onVehicleExplode", getRootElement(), onVehicleExplosion )
				
function player_Spawn ( posX, posY, posZ, spawnRotation, theTeam, theSkin, theInterior, theDimension )
	if theSkin == 0 then
		if theTeam == team1 then
		local clothes_ = getPedClothes ( source, 0 ) 
			if clothes_ ~= 'bbjackrim'  then
				addPedClothes ( source, 'bbjackrim', 'bbjack', 0 )
			end
			clothes_ = getPedClothes ( source, 1 ) 
			if clothes_ ~= 'hairred'  then
				addPedClothes ( source, 'hairred', 'head', 1 )
			end
			clothes_ = getPedClothes ( source, 2 ) 
			if clothes_ ~= 'denimsred'  then
				addPedClothes ( source, 'denimsred', 'jeans', 2 )
			end
			clothes_ = getPedClothes ( source, 3 ) 
			if clothes_~= 'sneakerprored' then		
				addPedClothes ( source, 'sneakerprored', 'sneaker', 3 )
			end
			clothes_ = getPedClothes ( source, 16 ) 
			if clothes_ ~= 'hockey' then		
				addPedClothes ( source, 'hockey', 'hockeymask', 16 )
			end
			
		elseif theTeam == team2 then
			
			local clothes_ = getPedClothes ( source, 0 ) 
			if clothes_ ~= 'hoodyAblue'  then
				addPedClothes ( source,'hoodyAblue', 'hoodyA', 0 )
			end
			clothes_ = getPedClothes ( source, 1 ) 
			if clothes_ ~= 'hairblue'  then
				addPedClothes ( source, 'hairblue', 'head', 1 )
			end
			clothes_ = getPedClothes ( source, 2 ) 
			if clothes_ ~= 'jeansdenim'  then
				addPedClothes ( source, 'jeansdenim', 'jeans', 2 )
			end
			clothes_ = getPedClothes ( source, 3 ) 
			if clothes_~= 'sneakerproblu' then		
				addPedClothes ( source, 'sneakerproblu', 'sneaker', 3 )
			end
			clothes_ = getPedClothes ( source, 16 ) 
			if clothes_ ~= 'hockey' then		
				addPedClothes ( source, 'hockey', 'hockeymask', 16 )
			end	

		end
	
	end
end

addEventHandler ( "onPlayerSpawn", getRootElement(), player_Spawn )


function updateNameTag( player )
	local _name = getPlayerName( player )
		local _id = getPlayerID( player )
			if _id then
				setPlayerNametagText( player, _name..' ('.._id..')' )
			end
end			


function _forceChatWithTags( msg, type_ )
	
	if type_ == 0 then
		cancelEvent( )
		local r, g, b = getPlayerNametagColor ( source )
		outputChatBox ( getPlayerName( source )..' #f0f0f0[ '..( getPlayerID( source ) or '-' ).. ' ]: '..msg, getRootElement(), r, g, b, true )
	elseif type_ == 2 then
		if getPlayerTeam( source ) then
			cancelEvent( )
			local r, g, b = getPlayerNametagColor ( source )
			outputChatBox ( '(TEAM) '..getPlayerName( source )..' #f0f0f0[ '..( getPlayerID( source ) or '-' ).. ' ]: '..msg, blips[ getPlayerTeam( source ) ], r, g, b, true )
		end	
	end

end
addEventHandler( "onPlayerChat", getRootElement(), _forceChatWithTags )


	function _setElementInteriorWithRot( player, x, y, z, interior, rot )
			setElementInterior( player, interior, x, y, z )
			setElementPosition( player, x, y, z  )
			setElementRotation ( player, 0, 0, rot,  "default", true )
	end
	
	
	function _readCurrentRevision( )
		local db_ = false
			if fileExists( ".git/logs/refs/heads/master" ) then
				db_ = fileOpen( '.git/logs/refs/heads/master' ) 
			end	
			if not db_ then
				local file = fileOpen ( 'core/_revision.ver')
				fileSetPos( file, 0 )
				local _stream = base64Decode( fileRead ( file, fileGetSize( file ) ) )
				setElementData( global_element, "_revision",  _stream )
				fileClose( file )
				return 0;
			end
		local limit, count, search, pos = fileGetSize( db_ ), 0, true, 0 
		local rawText = fileRead( db_, limit+1 )	
			while( search == true ) do
				local res = string.find( rawText, '\n', pos )
					if type( res ) == 'number' then
						pos = res+1
						count=count+1
					else
						search = false	
					end	
			end
		local result = 264 + count
		local file = fileCreate ( 'core/_revision.ver')
			fileSetPos( file, 0 )
			fileWrite ( file, base64Encode ( result ) )  
			fileClose( file )
			setElementData( global_element, "_revision", result )
			fileClose ( db_ )
	end	
	
	_readCurrentRevision( )
	
setTimer(function()
	local version = getVersion ( )
		print ( "\n" )
			print ( "        Welcome to BasicMode!\n" )
				print ( "           Running version: 'BETA' r-"..getElementData( global_element, "_revision" ) )
				print ( "              Running on server version: "..version.tag )
			print ( "                 Running on OS: "..version.os )
		print ( "                                      basicmodem.blogspot.com" )
	print ( "\n" )
	setGameType ( "BasicMode 1.0 r-"..getElementData( global_element, "_revision" ).. " [ Lobby ]")
	setMapName ( "BasicMode 1.0 r-"..getElementData( global_element, "_revision" ).. " [ Lobby ]")
end,100,1)



addCommandHandler('seed', function( p, cmd, a) 

	setTimer( function()
	local test_of_me = getTickCount()
		local res = rand_.main ( 'base', {0,124} )


		print( 'base: '..tostring( res )..'  in '..tostring( getTickCount() - test_of_me ) )
	end, 1500, tonumber( a ) or 0 )
end )



	function _randCacheSave()
	local file =  xmlLoadFile(  ":basicmode-core/randSeed$Cache.cache") or xmlCreateFile  ( ":basicmode-core/randSeed$Cache.cache","rand_cache" )
	local node = xmlFindChild ( file,'rand_cache', 0 ) or xmlCreateChild ( file , 'rand_cache' )
		xmlNodeSetAttribute ( node,'_history', toJSON( rand_.cahce ) )
			xmlSaveFile ( file )
			xmlUnloadFile ( file )	
	end
	
	
	
	function  _randCacheLoad()
		local file = xmlLoadFile( ":basicmode-core/randSeed$Cache.cache")
		if file == false then
			_randCacheSave()
			return false
		end
	
		local node = xmlFindChild ( file,'rand_cache', 0 )
		rand_.cahce = fromJSON ( xmlNodeGetAttribute ( node, '_history' ) )

	end
	
	
	
addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), 
    function ( resource )
       _randCacheLoad()
   end 
)

addEventHandler ( "onResourceStop", getResourceRootElement(getThisResource()), 
    function ( resource )
       _randCacheSave()
   end 
)
--[[

function bullshit( )

	setTimer( function ( source )
		local _vehState = { panels = {}, doors = {}, colors = {}}
		for i=0, 5 do
			_vehState.doors[ i ] = getVehicleDoorState ( source, i )
			_vehState.panels[ i ] = getVehiclePanelState ( source, i )
		end	
			_vehState.panels[ 6 ] = getVehiclePanelState ( source, 6 )
			_vehState.colors = { getVehicleColor ( source, true ) } 
		fixVehicle( source )
		setVehicleDamageProof( source, true )
		setElementHealth( source, 251 )
		for i, v in pairs( _vehState.panels ) do 
			setVehiclePanelState( source, i, v )
			if _vehState.doors[ i ] then
				setVehicleDoorState( source, i, _vehState.doors[ i ] )
			end	
		end
		for i, v in pairs( _vehState.colors ) do
				_vehState.colors[i] = math.max( 0, v - 100 )
		end 	
		setVehicleColor( source, unpack( _vehState.colors) )
		outputChatBox ( "VAGOS VEHICLE DESTROYED!" )
	end, 50, 1, source )

end
addEventHandler("onVehicleExplode", getRootElement(), bullshit )	]]

function handleOnPlayerModInfo ( filename, modList )
local tmp_ = {}
	for k, v in pairs ( modList ) do 
		table.insert( tmp_, v.name )
	--	outputChatBox( tostring( v.name ) )
	end	

callClient( source,'checkFilesToApplyBackup', tmp_ )

end
 
addEventHandler ( "onPlayerModInfo", getRootElement(), handleOnPlayerModInfo )


addEventHandler ( "onResourceStart", getResourceRootElement( ), 
    function (  )
		collectgarbage("collect")
   end 
)