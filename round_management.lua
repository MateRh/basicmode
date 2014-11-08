--//===========[ add command ]==========

function add_handler(  player, cmd, a1, a2, a3 )
	if a1 == nil then
		return 
	end
		a1 = tonumber( a1 )
		local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
	if r_type == "Lobby" then
		return 
	end	
	if isAdmin( player ) == false  then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 You're not admin.", player, 255, 255, 255, true )
	end
		local player_f = getPlayerByID( a1 )
	if type( a1 ) ~= "number" or player_f == false then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Bad argument #FF0000player id.", player, 255, 255, 255, true )
	end
	if _players[ player_f ]:getStatus( 2 ) == 2 or _players[ player_f ]:getStatus( 2 ) == 0 then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Impossible to add this player.",  player, 255, 255, 255, true )
	end	
	--callClient( player_f, "changeHudFunctionality", "lobby" )
	callClient( player_f, "send_missingData", { arena = settings_.arena, base = settings_.base, bomb = settings_.bomb }, settings_.vehicles )
	callClient( player_f, "sdasddsadsa")
	callClient( player_f, "onPlayerRequestSpawn", getPlayerTeam( player_f ))
	callClient( player_f, "disableSpecate" )
	return  outputChatBox ( "#FF0000[INFO] #c8c8c8 Player #ffffff'"..tostring( getPlayerName( player_f ) ).."' #c8c8c8has been added. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
end
addCommandHandler( "add", add_handler )


--//===========[ remove command ]==========

function remove_handler(  player, cmd, a1 )

	local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
	if r_type == "Lobby" then
		return 
	end	

	local player_f 
		if a1 == nil then
			player_f = player
		else
			if isAdmin( player ) == false  then
				return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 You're not admin.", player, 255, 255, 255, true )
			end
			a1 = tonumber( a1 )
			player_f = getPlayerByID( a1 )
			
		end
	if player_f == false then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Bad argument #FF0000player id.", player, 255, 255, 255, true )
	end
	if _players[ player_f ]:getStatus( 2 ) ~= 2 then	
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Impossible to remove this player.",  player, 255, 255, 255, true )
	end	
	setElementData ( player_f,"Health", 0 )
	callClient( player_f, "sdasddsadsa")
	local team = getPlayerTeam( player_f )
	_players[ player_f ]:updateStatus(  2, 1 )	
	setElementData( team, "p_count", math.max( 0, getElementData(  team, "p_count" )-1 ) )
	killPed ( player_f, nil, 6, 9 )
	
		if isElement( blips.game[ player_f ]  ) then
			destroyElement( blips.game[ player_f ]  )
			blips.game[ player_f ] = nil
		end	
	checkTeamsStatus( )	
		if player_f == player then
			return  outputChatBox ( "#FF0000[INFO] #c8c8c8 Player #ffffff'"..tostring( getPlayerName( player_f ) ).."' #c8c8c8 removes himself from the round.",  getRootElement(), 255, 255, 255, true )
		else
			return  outputChatBox ( "#FF0000[INFO] #c8c8c8 Player #ffffff'"..tostring( getPlayerName( player_f ) ).."' #c8c8c8has been removed. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
		end
end
addCommandHandler("remove", remove_handler)

--//===========[ rsp command ]==========


function sync_me( player, slot , w_t )
	local t = getPlayerTeam(player)
	local int = getElementInterior(player)
	local pSkin = getPedSkin(player)
	local Rot = getPedRotation(player)
	local x,y,z = getElementPosition(player)
	local Health = getElementHealth(player)
	local Armor = getPedArmor(player)
--	 setPedAnimation( player)
	local velociy = {getElementVelocity( player )}
	spawnPlayer ( player, x,y,z, Rot, pSkin, int, 0, t )
	setElementHealth(player,Health)
	setPedArmor(player,Armor)
		for i=1,#w_t do
			giveWeapon(player,w_t[i][1],w_t[i][2], false)
		end
	setPedWeaponSlot ( player, slot )
	setElementVelocity( player, unpack ( velociy ) )
	if getCameraTarget( player ) ~= player then setCameraTarget(  player,  player ) end
--	setElementAlpha(player,255)
end

--//===========[ switch command ]==========

function switch_handler ( player )
	if isAdmin( player ) == false then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 You're not admin.", player, 255, 255, 255, true )
	end
	if getElementData(global_element,"map_info")[1] == "Lobby" then
		local current_sides = { getElementData(team1,"t_type"), getElementData(team2,"t_type") }
		setElementData(team1,"t_type", tostring( current_sides[2]) , true )
		setElementData(team2,"t_type", tostring(current_sides[1]), true )
		--callClient( getRootElement(), "switchSides")
		callClient( getRootElement(), "updateSides")
		return  outputChatBox ( "#FF0000[INFO] #c8c8c8 Switching sides.( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
	end	
end
addCommandHandler("switch", switch_handler)
addCommandHandler("switchsides", switch_handler)
addCommandHandler("sides", switch_handler)
addCommandHandler("swap", switch_handler)

--//===========[ damage calc ]==========
function math.cut( n )
	if ( n - math.modf( n ) ) > 0.5 then
		return math.ceil( n )
	else
		return math.floor( n )
	end
end

function playerDamage_calc ( attacker, weapon, bodypart, loss ) 
	if getElementData(global_element,"map_info")[1] == "Lobby" or attacker == source or not attacker or getElementType( attacker ) ~= "player" then
		return 0
	end 
	setElementData( attacker, "Damage", math.cut( getElementData( attacker, "Damage" ) + loss ) )
	setElementData( attacker, "Score", math.cut( ( getElementData( attacker, "Score" ) or 0 ) + loss/10 ) )
end
addEventHandler ( "onPlayerDamage", getRootElement (), playerDamage_calc )


function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end


--//===========[ help command ]==========


local help_timers_cache = {}

function callFriendsYoureInTrouble( player, cmd )

		if _players[ player ]:getStatus( 2 ) ~= 2 then
			return 0
		end
			
		
		
		local team = getPlayerTeam( player )
		local r, g, b
		if not isTimer( help_timers_cache[ player ] ) then
			if type( help_timers_cache[ player ] ) == 'number' and getTickCount() < help_timers_cache[ player ] then
				return 0;
			end	
			local x,y,z = getElementPosition( player )
			math.randomseed( (x+y+z)*math.max(getPlayerPing( player ),1 ) + getTickCount()*math.random( -1.0, 1.0 ) )
			r, g, b =  unpack( colors_scheme [ getElementData( player, '#c' ) ] )
			blips.help[ player ] = { createBlipAttachedTo ( player, 0, 3.0, r, g, b, 255, 0, 2000.0, blips[ team ] ),createMarker ( x,y,z  , "arrow",1.0, r, g, b, 255, blips[ team ] )	}	
			attachElements ( blips.help[ player ][2], player, 0, 0, 3)
			help_timers_cache[ player ] = setTimer( clean_helpme_stuff, 40000, 1, player )
		else	
			if getTimerDetails ( help_timers_cache[ player ] ) > 38500 then
				outputChatBox ( "#FF0000[ERROR] #ffffffYou can not spam this feature, use your key binds with greater caution", player, 255, 255, 255, true )
				return   0;
			end	
			killTimer( help_timers_cache[ player ] )
			clean_helpme_stuff ( player )
			help_timers_cache[ player ] = getTickCount() + 2000
			return
		end
		callClient( blips[ team ], 'playSound', "sounds/help.wav" )
		return  outputChatBox ( "#FF0000[HELP] Teammate #ffffff'".. getPlayerName( player ).."'#c8c8c8 needs your help! [ "..tostring(RGBToHex( r, g, b )).." BLIP OF THIS TEXT COLOR ON RADAR #c8c8c8]",  blips[ team ], 255, 255, 255, true )
end
addCommandHandler("helpme", callFriendsYoureInTrouble)


function clean_helpme_stuff ( player )
	for k, v in pairs ( blips.help[ player ] ) do
		destroyElement( v )
	end
	if isTimer( help_timers_cache[ player ] ) then 
		killTimer( help_timers_cache[ player ] )
	end	
	
	help_timers_cache[ player ] = nil
	blips.help[ player ] = nil
end


--//===========[ pause command ]==========
local pause = false
function pause_handler( player, cmd )

	local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
	if r_type == "Lobby" then
		return 
	end	
	if isAdmin( player ) == false then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 You're not admin.", player, 255, 255, 255, true )
	end
		if getTickCount() < gGlobalTime_ then
			return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Wait a while to pause the round.", player, 255, 255, 255, true )
		end	
	
		if pause == false then
			for k, v in pairs( getElementsByType ( 'player' ) ) do 
				toggleAllControls( v, false, true, false )
				setElementFrozen( v, true )
			end
			for k, v in pairs( getElementsByType ( 'vehicle' ) ) do 
				setElementFrozen( v, true )
				setVehicleEngineState( v, false )
			end
			setTimer( function() setGameSpeed( 0 )	end, 100, 1)
			callClient( getRootElement(), "pause_.response")
			pause = true
			round_paused  = true
			return  outputChatBox ( "#FF0000[INFO] #c8c8c8 The round has been paused. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
		elseif pause == true then
			setTimer( function ()
				pause = false
				round_paused  = false
				setGameSpeed( 1 )
				for k, v in pairs( getElementsByType ( 'player' ) ) do 
					toggleAllControls( v, true )
					setElementFrozen( v, false )
				end
				for k, v in pairs( getElementsByType ( 'vehicle' ) ) do 
					setElementFrozen( v, false )
					if getVehicleController( v )  then
						if getElementData( getPlayerTeam( getVehicleController( v ) ) ,"t_type") == "Defense"  and settings_.base[5][2] == false then
							break
						end	
						setVehicleEngineState( v, true )
					end	
				end
			end, 1000, 1 )	
			callClient( getRootElement(), "pause_.response" )
			pause = 0
			setTimer( checkTeamsStatus, 2500, 1 )
			return  outputChatBox ( "#FF0000[INFO] #c8c8c8 The round has been unpaused. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
		end
end
addCommandHandler("pause", pause_handler)
addCommandHandler("unpause", pause_handler)


--//===========[ reset command ]==========

function reset_handler(  player, cmd)
	local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
--	if r_type ~= "Lobby" then
	--	return outputChatBox ( "#FF0000[ERROR] #c8c8c8 You can't use this during the round.",  player, 255, 255, 255, true )
--	end	
	if isAdmin( player ) == false then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 You're not admin.", player, 255, 255, 255, true )
	end
				for k, v in pairs( getElementsByType ( 'player' ) ) do 
						setElementData( v,  "Kills", 0 )
						setElementData( v,  "Deaths", 0 )
						setElementData( v,  "Damage", 0 )
						setElementData( v,  "Score", 0 )
				end
				setElementData(team1,"Score",0)
				setElementData(team2,"Score",0)
				setElementData(team3,"Score",0)
				clean_data_base( )
	return  outputChatBox ( "#FF0000[INFO] #c8c8c8 Scores and stats has been reset. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
end
addCommandHandler("reset", reset_handler)
addCommandHandler("resetscore", reset_handler)
addCommandHandler("clean", reset_handler)
addCommandHandler("cleanscore", reset_handler)


--//===========[ heal command ]==========

function heal_handler(  player, cmd, id)
	local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
	if r_type == "Lobby" then
		return outputChatBox ( "#FF0000[ERROR] #c8c8c8 You can't use this cmd in lobby.",  player, 255, 255, 255, true )
	end	
	if isAdmin( player ) == false then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 You're not admin.", player, 255, 255, 255, true )
	end
		if cmd == 'healall' then
				for k, v in pairs( getElementsByType ( 'player' ) ) do 
					if _players[ v ]:getStatus( 2 ) == 2 then
						setElementHealth( v, 100 )
						setPedArmor( v, tonumber( settings_.main[ 7 ][ 2 ]) )
					end
				end
		return  outputChatBox ( "#FF0000[INFO] #c8c8c8 All players has been healed. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
		else
				id = tonumber( id )
				local v = getPlayerByID( id )
				if type( id ) ~= "number" or v == false then
					return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Bad argument #FF0000player id.", player, 255, 255, 255, true )
				end
					if  _players[ v ]:getStatus( 2 ) == 2 then
						setElementHealth( v, 100 )
						setPedArmor( v, tonumber( settings_.main[ 7 ][ 2 ]) )
						return  outputChatBox ( "#FF0000[INFO] #c8c8c8 Player #ffffff'"..tostring( getPlayerName( v ) ).."' #c8c8c8has been healed. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
					end
		end
end
addCommandHandler("heal", heal_handler)
addCommandHandler("healall", heal_handler)


--//===========[ fix command ]==========

function fix_handler(  player, cmd, id, blow)
	local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
	if r_type == "Lobby" then
		return outputChatBox ( "#FF0000[ERROR] #c8c8c8 You can't use this cmd in lobby.",  player, 255, 255, 255, true )
	end	
	if isAdmin( player ) == false then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 You're not admin.", player, 255, 255, 255, true )
	end
		if cmd == 'fixall' then
				for k, v in pairs( getElementsByType ( 'vehicle' ) ) do 
					if isVehicleBlown( v ) and  not blow then
						break
					end	
						fixVehicle ( v )

				end
		return  outputChatBox ( "#FF0000[INFO] #c8c8c8 All vehicles has been fixed. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
		else
				id = tonumber( id )
				local v = getPlayerByID( id )
				if type( id ) ~= "number" or v == false then
					return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Bad argument #FF0000player id.", player, 255, 255, 255, true )
				end
					if  isPedInVehicle( v ) then
						fixVehicle ( getPedOccupiedVehicle( v ) )
						return  outputChatBox ( "#FF0000[INFO] #c8c8c8 Player's #ffffff'"..tostring( getPlayerName( v ) ).."' #c8c8c8 vehicle has been fixed. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
					end
		end
end
addCommandHandler("fix",  fix_handler)
addCommandHandler("fixall",  fix_handler)


function team_handler(  player, cmd, id, team )
	local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
	if r_type ~= "Lobby" then
		return outputChatBox ( "#FF0000[ERROR] #c8c8c8 You can't use this during the round.",  player, 255, 255, 255, true )
	end	
	if isAdmin( player ) == false then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 You're not admin.", player, 255, 255, 255, true )
	end
		if  team  ~= 'auto'  then
			team = tonumber( team ) or nil
		end	
		id = tonumber( id )
				
		local v = getPlayerByID( id )
			if type( id ) ~= "number" or v == false then
				return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Bad argument #FF0000player id.", player, 255, 255, 255, true )
			end
				if  _players[ v ]:getStatus( 2 ) == 2 then
					return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 This player #FF0000playing int the round.", player, 255, 255, 255, true )
				end	
				
		if type( team ) ~= 'number' or team < 1 or team > 3 then
			local team_ = getPlayerTeam( v )
				if team_ == team1 then
					_spawn_in_lobby( v, team2 )
					return  outputChatBox ( "#FF0000[INFO] #ffffff'"..tostring( getPlayerName( v ) ).."' #c8c8c8 has been moved to opposite team. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
				elseif team_ == team2 then
					_spawn_in_lobby( v, team1 )
					return  outputChatBox ( "#FF0000[INFO] #ffffff'"..tostring( getPlayerName( v ) ).."' #c8c8c8 has been moved to opposite team. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
				end
			return 0;
		else
			if team == 1 then
				_spawn_in_lobby( v, team1 )
				return  outputChatBox ( "#FF0000[INFO] #ffffff'"..tostring( getPlayerName( v ) ).."' #c8c8c8 has been moved to "..getTeamName( team1 )..". ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
			elseif team == 2 then
				_spawn_in_lobby( v, team2 )
				return  outputChatBox ( "#FF0000[INFO] #ffffff'"..tostring( getPlayerName( v ) ).."' #c8c8c8 has been moved to "..getTeamName( team2 )..". ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
			elseif team == 3 then
				_spawn_in_lobby( v, team3 )
				return  outputChatBox ( "#FF0000[INFO] #ffffff'"..tostring( getPlayerName( v ) ).."' #c8c8c8 has been moved to "..getTeamName( team3 )..". ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
			else
				_spawn_in_lobby( v, 'auto' )
				return  outputChatBox ( "#FF0000[INFO] #ffffff'"..tostring( getPlayerName( v ) ).."' #c8c8c8 has been moved to random team. ( by #ffffff'".. getPlayerName( player ).."'#c8c8c8 )",  getRootElement(), 255, 255, 255, true )
			end
		end
			
end
addCommandHandler("team",  team_handler)
addCommandHandler("move",  team_handler)



function movewholeteam_handler(  player, cmd, tag, team )
	local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
	if r_type ~= "Lobby" then
		return outputChatBox ( "#FF0000[ERROR] #c8c8c8 You can't use this during the round.",  player, 255, 255, 255, true )
	end	
	if isAdmin( player ) == false then
		return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 You're not admin.", player, 255, 255, 255, true )
	end

			if not tag then
				return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Bad argument #FF0000clan tag.", player, 255, 255, 255, true )
			end	
			team = tonumber( team )
			if type( team ) ~= "number" or team < 1 or team > 3 then
				return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Bad argument #FF0000team id.", player, 255, 255, 255, true )
			end

		if team == 3 then
			for k, v in pairs( getElementsByType( 'player' ) ) do
				local name_ = getPlayerName( v )
					if string.find( name_, tag ) and getPlayerTeam( v ) ~= false then
						_spawn_in_lobby( v, team3 )
					end
			end	
			outputChatBox ( "#FF0000[INFO] #ffffffPlayers with '"..tag.."' #c8c8c8 in nick has been moved to 'Spectator' team. #ffffff( by '".. getPlayerName( player ).."' )",  getRootElement(), 255, 255, 255, true )
		else
		local _ways = { positive = { team1, team2 }, negative = { team2, team1 } }
			for k, v in pairs( getElementsByType( 'player' ) ) do
				if getPlayerTeam( v ) ~= false then
					local name_ = getPlayerName( v )
						if string.find( name_, tag ) then 
							_spawn_in_lobby( v, _ways.positive[ team ] )
						elseif getPlayerTeam( v ) ~= team3 then
							_spawn_in_lobby( v, _ways.negative[ team ] )
						end
				end	
			end	
			outputChatBox ( "#FF0000[INFO] #ffffffPlayers with '"..tag.."' #c8c8c8 in nick has been moved to '"..getTeamName( _ways.positive[ team ] ).."' team. #ffffff( by '".. getPlayerName( player ).."' )",  getRootElement(), 255, 255, 255, true )
			outputChatBox ( "#FF0000[INFO] #ffffffPlayers without '"..tag.."' #c8c8c8 in nick has been moved to '"..getTeamName( _ways.negative[ team ] ).."' team. #ffffff( by '".. getPlayerName( player ).."' )",  getRootElement(), 255, 255, 255, true )
		end
		
			
end
addCommandHandler("order",  movewholeteam_handler )
addCommandHandler("sort",  movewholeteam_handler )




