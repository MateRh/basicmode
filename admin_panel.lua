function convertToString( v )
	if type( v ) == 'boolean' then
		return tostring( v )
	else
		return v
	end
end

function dbWith_cfgs_list ( action, element, name, date, author )
	local db
		if fileExists ( "cfgs/$cache/$cfg_cache.db" ) == false then -- there no cache file
			db = dbConnect( "sqlite", "cfgs/$cache/$cfg_cache.db", "", "", "share=0" )
			dbExec( db, "CREATE TABLE IF NOT EXISTS list (name TEXT, date TEXT, author TEXT)")
			dbExec(db, "INSERT INTO list(name,date,author) VALUES(?,?,?)", "default", "2013-06-02", "basicmode" )
			dbExec( db, "CREATE TABLE IF NOT EXISTS enabled_cfg (name TEXT)")
			dbExec(db, "INSERT INTO enabled_cfg(name) VALUES(?)", "default" )
		end
			db = dbConnect( "sqlite", "cfgs/$cache/$cfg_cache.db", "", "", "share=0" )
				if action == 'load' then
					local return_cache = {}
					local result = dbPoll( dbQuery( db, "SELECT * FROM list" ), -1 )
					for k,v in ipairs( result ) do
						table.insert( return_cache, { v.name, v.date, v.author } )
					end	
					result = dbPoll( dbQuery( db, "SELECT * FROM enabled_cfg" ), -1 )
					destroyElement( db )
						if element and getElementType( element ) == 'player' then
							callClient( element, "_panelUpdateCfgList", return_cache, result[1].name )
							if name == '-load' then
								if result[1].name == 'default' then
									callClient( element, "_panel_load_cfg", nil, true, 'default' )
								else	
									_panel_load( element, result[1].name ) 
								end	
							end
						else
							--return return_cache
							return result[1].name
						end
				elseif action == 'del' then
					dbExec( db, "DELETE FROM list WHERE name='".. name .."'" )
					local result = dbPoll( dbQuery( db, "SELECT * FROM enabled_cfg" ), -1 )
						if result[1].name == name then
							dbExec( db, "UPDATE enabled_cfg SET name='default'" )
						end
						local return_cache = {}
						local result = dbPoll( dbQuery( db, "SELECT * FROM list" ), -1 )
						for k,v in ipairs( result ) do
							table.insert( return_cache, { v.name, v.date, v.author } )
						end	
						callClient( element, "_panelUpdateCfgList", return_cache, 'default' )
						destroyElement( db )
						fileDelete (  "cfgs/"..name..".db" )
				elseif action == 'add' then
					dbExec(db, "INSERT INTO list(name,date,author) VALUES(?,?,?)", name, date, author )
						local return_cache = {}
						local result = dbPoll( dbQuery( db, "SELECT * FROM list" ), -1 )
						for k,v in ipairs( result ) do
							table.insert( return_cache, { v.name, v.date, v.author } )
						end	
						callClient( element, "_panelUpdateCfgList", return_cache, name )
						dbExec( db, "UPDATE enabled_cfg SET name='"..name.."'" )
						destroyElement( db )
				end
				if isElement( db ) then
					destroyElement( db )
				end
end

function _panel_save( name, data )
	local db = dbConnect( "sqlite", "cfgs/"..name..".db", "", "", "share=0" )
	dbExec( db, "DROP TABLE IF EXISTS `settings_root`")
	dbExec( db, "DROP TABLE IF EXISTS `settings_teams`")
	dbExec( db, "DROP TABLE IF EXISTS `settings_weapons`")
	dbExec( db, "DROP TABLE IF EXISTS `settings_vehicles`")	
	dbExec( db, "CREATE TABLE IF NOT EXISTS settings_root (cat TEXT, name TEXT, value BLOB, type TEXT)")
	dbExec( db, "CREATE TABLE IF NOT EXISTS settings_teams (id INTEGER, name TEXT, value BLOB, type TEXT)")
	dbExec( db, "CREATE TABLE IF NOT EXISTS settings_weapons (mode TEXT, id INTEGER, value1 BLOB, value2 BLOB, value3 BLOB, value4 BLOB)")
	dbExec( db, "CREATE TABLE IF NOT EXISTS settings_vehicles (id INTEGER)")
		for k0,v0 in pairs( data ) do
				if k0 == 'weapons' then
					for k1,v1 in pairs( v0 ) do
						for k2,v2 in pairs( v1 ) do
							for k3,v3 in pairs( v2 ) do
								dbExec(db, "INSERT INTO settings_weapons(mode,id,value1,value2,value3,value4) VALUES(?,?,?,?,?,?)", k2, k3, tostring(v3[1]), v3[2], v3[3], v3[4] )
							end	
						end	
					end	
				elseif k0 == 'vehicles' then
					for k1,v1 in pairs( v0 ) do
						dbExec(db, "INSERT INTO settings_vehicles(id) VALUES(?)", v1 )
					end
				elseif k0 == 'teams' then
					for k1,v1 in ipairs( v0 ) do
						for k2,v2 in ipairs( v1 ) do
							if v2[1] == "color" then
								dbExec(db, "INSERT INTO settings_teams(id,name,value,type) VALUES(?,?,?,?)", k1, v2[1], table.concat(v2[2], ","), 'string' )
							else	
								dbExec(db, "INSERT INTO settings_teams(id,name,value,type) VALUES(?,?,?,?)", k1, v2[1], convertToString( v2[2] ), type(v2[2]) )
							end	
						end	
					end
				else
					for k1,v1 in ipairs( v0 ) do
						dbExec(db, "INSERT INTO settings_root(cat,name,value,type) VALUES(?,?,?,?)", k0, v1[1], convertToString( v1[2] ), type(v1[2]) )
					end
				end
		end
	destroyElement( db )
end

function convertType( v, t )
	if t == 'boolean' then
		if v == 'true' then
			return true
		else
			return false
		end
	else
		return v
	end
end

function _panel_load( player, name ) 
	local db = dbConnect( "sqlite", "cfgs/"..name..".db", "", "", "share=0" )
	for a,b in ipairs( { 'main', 'gliteches', 'limits', 'weather', 'miscellaneous', 'arena', 'base', 'bomb'} ) do 
	--	settings_[b] = {}
		local result = dbPoll( dbQuery( db, "SELECT * FROM settings_root WHERE cat='"..b.."'" ), -1 )
			for k,v in ipairs( result ) do
			--	table.insert( settings_[b], k, { v.name,  convertType( v.value, v.type ) } )
		
				settings_[b][k] = { v.name,  convertType( v.value, v.type ) } 
			end	
	end	
	settings_.vehicles = {}
	local result = dbPoll( dbQuery( db, "SELECT * FROM settings_vehicles" ), -1 )
	for k,v in ipairs( result ) do
		table.insert( settings_.vehicles, k,  v.id )
	end	
	--settings_.vehicles = settings_.vehicles
	settings_.teams = {}
	for a,b in ipairs( {1, 2} ) do 
		settings_.teams[b] = {}
		local result = dbPoll( dbQuery( db, "SELECT * FROM settings_teams WHERE id='"..b.."'" ), -1 )
			for k,v in ipairs( result ) do
				table.insert( settings_.teams[b], k, { v.name,  convertType( v.value, v.type ) } )
			end	
	end	
	settings_.weapons = {}
	for a,b in ipairs( {'all gamemodes', 'arena', 'base', 'bomb'} ) do 
		settings_.weapons[b] = {}
		local result = dbPoll( dbQuery( db, "SELECT * FROM settings_weapons WHERE mode='"..b.."'" ), -1 )
			for k,v in ipairs( result ) do
				table.insert( settings_.weapons[b], v.id, { convertType( v.value1, 'boolean' ), v.value2, v.value3, v.value4 } )
			end	
	end	
	if player and getElementType( player ) == "player" then
		callClient(player, "_panel_load_cfg", settings_, nil, name )
	end	
	destroyElement( db )
	applyCfgSettings( )
end	
--[[
function _panel_load( player, name ) 
	local sett_t = {}
	local db = dbConnect( "sqlite", "cfgs/"..name..".db", "", "", "share=0" )
	for a,b in ipairs( { 'main', 'gliteches', 'limits', 'weather', 'miscellaneous', 'arena', 'base', 'bomb'} ) do 
		sett_t[b] = {}
		local result = dbPoll( dbQuery( db, "SELECT * FROM settings_root WHERE cat='"..b.."'" ), -1 )
			for k,v in ipairs( result ) do
				table.insert( sett_t[b], k, { v.name,  convertType( v.value, v.type ) } )
			end	
	end	
	sett_t.vehicles = {}
	local result = dbPoll( dbQuery( db, "SELECT * FROM settings_vehicles" ), -1 )
	for k,v in ipairs( result ) do
		table.insert( sett_t.vehicles, k,  v.id )
	end	
	--settings_.vehicles = sett_t.vehicles
	sett_t.teams = {}
	for a,b in ipairs( {1, 2} ) do 
		sett_t.teams[b] = {}
		local result = dbPoll( dbQuery( db, "SELECT * FROM settings_teams WHERE id='"..b.."'" ), -1 )
			for k,v in ipairs( result ) do
				table.insert( sett_t.teams[b], k, { v.name,  convertType( v.value, v.type ) } )
			end	
	end	
	sett_t.weapons = {}
	for a,b in ipairs( {'all gamemodes', 'arena', 'base', 'bomb'} ) do 
		sett_t.weapons[b] = {}
		local result = dbPoll( dbQuery( db, "SELECT * FROM settings_weapons WHERE mode='"..b.."'" ), -1 )
			for k,v in ipairs( result ) do
				table.insert( sett_t.weapons[b], v.id, { convertType( v.value1, 'boolean' ), v.value2, v.value3, v.value4 } )
			end	
	end	
	if player and getElementType( player ) == "player" then
		callClient(player, "_panel_load_cfg", sett_t, nil, name )
	end	

	
		settings_ = sett_t 
	destroyElement( db )
	applyCfgSettings( )
end	
]]

function applyCfgSettings( )
	--
	setGlitchEnabled ( 'crouchbug', 	settings_.gliteches[1][2] )
	setGlitchEnabled ( 'fastfire', 	settings_.gliteches[2][2] )
	setGlitchEnabled ( 'quickreload', 	settings_.gliteches[3][2] )
	--
	setGlitchEnabled ( 'fastmove', settings_.gliteches[4][2]  )

		if tonumber( gettok ( getVersion ( ).sortable, 4, '.' ) ) > 6276 or tonumber( getVersion ( ).number ) > 309 then
			setGlitchEnabled ( 'fastsprint', settings_.gliteches[5][2]  )
		end	
	setGlitchEnabled ( 'highcloserangedamag', false )
	--setGlitchEnabled ( 'hitanim', false )
	--
	setFPSLimit( settings_.limits[1][2] )
	--
	setWeather( settings_.weather[1][2] )
	setWeatherBlended( settings_.weather[2][2] )
	setTime( tonumber( gettok ( settings_.weather[3][2], 1, ":" ) ), tonumber( gettok ( settings_.weather[3][2], 2, ":" ) ) )
	setMinuteDuration ( settings_.weather[5][2] )
	--
	setGameSpeed ( settings_.miscellaneous[2][2]  )
	--
	for _, team in pairs( getElementsByType( "team" ) ) do 
		setTeamFriendlyFire ( team , settings_.miscellaneous[3][2]  )
	end	
	--
	setGravity ( settings_.miscellaneous[4][2] )
	setCloudsEnabled ( settings_.miscellaneous[5][2]  )
	setInteriorSoundsEnabled ( settings_.miscellaneous[9][2]  )
	--
	for _, team in ipairs( { team1, team2 } ) do 
		setTeamName( team, settings_.teams[_][1][2] )
		setTeamColor( team, tonumber( gettok ( settings_.teams[_][4][2], 1, "," ) ), tonumber( gettok ( settings_.teams[_][4][2], 2, "," ) ), tonumber( gettok ( settings_.teams[_][4][2], 3, "," ) ) )
	end
	

		
	if #getElementsByType ( 'player' ) > 0 then
		collectClientCfgSettings( )
	end	
	_applyAppropriateEnvironment ()	
end

function collectClientCfgSettings( player )

	callClient( player or getRootElement(), "sync_client_settings", { 
																		coundtdown = tonumber(settings_.main[3][2]),
																		hellikill = settings_.main[4][2],
																		helliboom = settings_.main[5][2],
																		spectator = settings_.main[8][2],
																		veh_hp_bars = settings_.main[11][2],
																		min_fps = settings_.limits[2][2],
																		max_ping = settings_.limits[3][2],
																		packet_loss = settings_.limits[4][2], 
																		blur = settings_.miscellaneous[1][2], 
																		birds = settings_.miscellaneous[6][2], 
																		a_sounds_general = settings_.miscellaneous[7][2], 
																		a_sounds_gunfire = settings_.miscellaneous[8][2],
																		weapons = settings_.weapons['all gamemodes'],
																		heavy_w =  settings_.main[17][2],
																		skins = { settings_.teams[1][2][2], settings_.teams[2][2][2], 310 },
																		c_bug_lim = settings_.gliteches[6][2],
																		vote = { settings_.main[13][2], settings_.main[14][2], settings_.main[15][2] }
																	} );
																	
	local weapons_skills = { [22] = 69, [23] = 70, [24] = 71, [25] = 72, [26] = 73, [27] = 74, [28] = 75, [32] = 75, [29] = 76, [30] = 77, [31] = 78, [34] = 79, points = { 1, 501, 1000 }, element = player or getRootElement()}


		for _, w_data in pairs( settings_.weapons['all gamemodes'] ) do 
			if weapons_skills[ _ ] then
				setPedStat( weapons_skills.element, weapons_skills[ _ ], weapons_skills.points [ w_data[2] ] )
			end
		end
		setPedStat ( weapons_skills.element, 22, 999 )
		setPedStat ( weapons_skills.element, 160, 999 )
		setPedStat ( weapons_skills.element, 229, 999 )
		setPedStat ( weapons_skills.element, 230, 999 )
		setPedStat ( weapons_skills.element, 225, 999 )
								
end

function _dynamic_team_settings( names, colors, scores, skins )
	if names then
		setTeamName( team1, names[1] ) 
		setTeamName( team2, names[2] ) 
		callClient( getRootElement(), "updateHudValuses", "names" )
	end
	if colors then
		if colors[1] then  setTeamColor( team1, unpack( colors[1] )) end
		if colors[2] then  setTeamColor( team2, unpack( colors[2] ) ) end
		callClient( getRootElement(), "updateColors")
	end	
	if scores then
		if scores[1] then  setElementData( team1,"Score", tonumber( scores[1] ) )   end 
		if scores[2] then  setElementData( team2,"Score", tonumber( scores[2] ) )   end 
	end
	if skins then
		if skins[1] then  settings_.teams[ 1 ][2][2] = skins[1] callClient( getRootElement(), "sync_client_one_setting", "skins", 1,  skins[1] )  end 
		if skins[2] then  settings_.teams[ 2 ][2][2] = skins[2] callClient( getRootElement(), "sync_client_one_setting", "skins", 2,  skins[2] )  end 

	end
end

setTimer( function() 
	_panel_load( false, dbWith_cfgs_list ( 'load') ) 
end,100,1 )	


	function _pane_player_tab ( re_player, player )
		callClient( player, "_i_need_more_of_yourData", re_player )
	end
	
	function _pane_player_tab_collect ( re_player, player, data )
	
		callClient( re_player, '_panel_resendData', { { 'Serial', getPlayerSerial( player )},
														{'Ip', getPlayerIP( player )},
														{'Version', getPlayerVersion( player )},
														{'Anti cheats', getPlayerACInfo( player ).DetectedAC},
														{'Screen upload', data[2]},
														{'Resolution', data[5]},
														{'Video Card', data[1]},
														{'Free video memory to MTA', data[3]},
														{'GTA stream video memory', data[4]},
			
													}, player )
	
	end
	
	
	
addEventHandler( "onPlayerScreenShot", root, 	
	function ( theResource, status, pixels, timestamp, tag )
	   if status == 'ok' then
			local re_ = getPlayerFromName( tag )
			triggerLatentClientEvent ( re_, 'sendScreenData', 65536*2, false,  re_, pixels,  source )
		elseif status == "minimized" then
			outputChatBox ( "#FF0000[INFO] #c8c8c8 Player #ffffff'"..tostring( getPlayerName( source ) ).."' #c8c8c8has have minimized the game.",  re_, 255, 255, 255, true )
		else
			outputChatBox ( "#FF0000[INFO] #c8c8c8 Player #ffffff'"..tostring( getPlayerName( source ) ).."' #c8c8c8has have disabled screnshots.",  getRootElement(), 255, 255, 255, true )
		end
	end
)
