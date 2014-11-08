		local _elements = {}
		
		function onMapLoad(res)
	
			if res ~= getThisResource() and getResourceInfo ( res, "type" ) == "map" then
						for k, v in pairs( getElementsByType ( 'player' ) ) do 
							toggleAllControls( v, true )
							setElementFrozen( v, false )
						end
						for k, v in pairs( getElementsByType ( 'vehicle' ) ) do 
							setElementFrozen( v, false )
						end
				destroyAllWeaponPickups( )		
				_explosionOverlay = {}		
				updateBrowserInfo( getResourceName( res ) )
				destroyElement( blips.element )
				blips.element = createElement ( "root_blips_element","blips" )
				setElementData( team1, "p_count", 0 )
				setElementData( team2, "p_count", 0 )
				--	setElementData( team1, "Health", nil )
				--setElementData( team2, "Health", nil )
				local map_root = getResourceRootElement ( res )
				map_root_element = createElement( "_map_root_element_" )
				actually_map = res
				_elements = {map = res, _xyz={[getTeamByType( "Attack" )]=getElementsByType ( "Team1",map_root ),[ getTeamByType( "Defense" )]=getElementsByType ( "Team2",map_root )},marker_data=getElementsByType ( "Central_Marker",map_root ) }
				_elements.marker = {getElementData(_elements.marker_data[1], "posX"),getElementData(_elements.marker_data[1], "posY"),getElementData(_elements.marker_data[1], "posZ"),}
					
					setElementData(getElementByIndex ( "root_gm_element",0 ),"marker_root", mark)
					setElementData( global_element, "interior", get(getResourceName(res)..".#Interior") or 0 )
					local round_type = getElementData(global_element,"map_info")
					if round_type[1] == "Base" then
					_elements._xyz[ getTeamByType( "Attack" ) ] = getElementsByType ( "spwn_",map_root )
						for k, v in ipairs( _elements.marker_data ) do
						local markPos = {getElementData(v, "posX"),getElementData(v, "posY"),getElementData(v, "posZ")}
							local mark = createMarker ( markPos[1], markPos[2], markPos[3], "cylinder", 2, 210, 210, 210, 100)
							local lod = createObject ( 1276, markPos[1], markPos[2], markPos[3] +3 )
							local lod1 = createObject ( 1276, markPos[1], markPos[2], markPos[3] +3, 0, 0,0, true )
							setLowLODElement (  lod ,  lod1  )
							 setElementCollisionsEnabled ( lod, false )
							setElementInterior( mark, getElementData( global_element, "interior" ) or 0 )
							setElementInterior( lod, getElementData( global_element, "interior" ) or 0 )
							setElementInterior( lod1, getElementData( global_element, "interior" ) or 0 )
							local blip
								if ( getElementData( global_element, "interior" ) or 0 ) ~= 0 then
									blip = createBlip (  markPos[1], markPos[2], markPos[3], 41 )
								else
									blip = createBlip (  markPos[1], markPos[2], markPos[3], 19 )
								end	
									
							addEventHandler( "onMarkerHit", mark, onBaseMarkerEnter )
							addEventHandler( "onMarkerLeave", mark, onBaseMarkerLeft )
							setElementParent( mark, map_root_element )
							setElementParent( blip, map_root_element )
							setElementParent( lod, map_root_element )
							setElementParent( lod1, map_root_element )
								
						end
					end	
				countdown_start()
					for k, v in pairs( getElementsByType ( "spwn_", map_root )  ) do 
						local x, y, z = getElementData( v, "posX"),getElementData( v, "posY"),getElementData( v, "posZ")
						local coll = createColTube ( x, y, z - 15, 100,  35 )
						setElementParent( coll, map_root_element )
						addEventHandler ( "onColShapeHit", coll, onVehicleEnterSafeZone )
						addEventHandler ( "onColShapeLeave", coll, onVehicleLeaveSafeZone )
					end
				_applyAppropriateEnvironment ()	
			end
		end
		addEventHandler ( "onResourceStart", getRootElement(), onMapLoad )
		
		
		addEventHandler ( "onResourceStop", getResourceRootElement( getThisResource() ), 
			function ( resource )
				if _elements.map and ( getResourceState( _elements.map ) == 'running' or getResourceState( _elements.map ) ==  'starting' ) then
					stopResource( _elements.map )
				end
		   end 
		)
		
		function findRotation(x1,y1,x2,y2)
		  local t = -math.deg(math.atan2(x2-x1,y2-y1))
		  if t < 0 then t = t + 360 end;
		  return t;
		end
		
		function spawnOnRound( _p, _t, re_add )
			local _g = global_element
				local team = getPlayerTeam( _p )
				cretePlayerBlip( _p, team )
				local round_type, interior = getElementData( _g,"map_info"), getElementData( _g, "interior" )
				local ran = math.random( 1,#_elements._xyz[team] )
				local position = _elements._xyz[ team ][ ran ]
				local x, y, z = getElementData( position, "posX"), getElementData( position, "posY"), getElementData( position, "posZ")
				local rotation = findRotation( x, y ,_elements.marker[1], _elements.marker[2] )
				local cache_s = { [team1] = 1, [team2] = 2 }
				local _o =  { -0.5, 0.5, -0.25, 0.25 }
				x, y = x + _o[ math.random( 1, 4 )], y + _o[ math.random( 1, 4 )]
				toggleAllControls( _p, true )
				setElementFrozen( _p, false )
				spawnPlayer ( _p, x, y, z, rotation, settings_.teams[ cache_s[team] ][2][2], interior  )
				_players[ _p ]:updateStatus(  2, 2 )
				setPedArmor( _p, tonumber( settings_.main[ 7 ][ 2 ]) or 0 )

				callClient( player, "_protect_enable", true )
				if round_paused then 
					toggleAllControls( _p, false, true, false )
					setElementFrozen( _p, true )
				end	
 		end
		
		function onVehicleEnterSafeZone( element )

			if getElementType( element ) ~= "vehicle" then
				return false
			end	
			
			for _, player in pairs( getVehicleOccupants ( element ) ) do 
				callClient( player, "switchCollisionMode",  element, source, 0 )
			end
			
		end
		
		function onVehicleLeaveSafeZone( element )

			if getElementType( element ) ~= "vehicle" then
				return false
			end		
			
			for _, player in pairs( getVehicleOccupants ( element ) ) do 
				callClient( player, "switchCollisionMode",  element, source, 1 )
			end
			
		end
		

		
		function cretePlayerBlip( player, team )
		
			setElementParent( player, blips[ team ] )
			local r, g, b =  unpack( colors_scheme [ getElementData( player, '#c' ) ] )
			blips.game[ player ] = createBlipAttachedTo ( player, 0, 1, r, g, b, 255, 0, 99999.0, blips[ team ] )
	--		setElementParent( player, blips[ team ] )
		end
	
		local vehicles = {}
		
		function VehicleSelector_server(player,id,vx,vy,vz, no_s )
		local new_vehicle = nil
		local rot = findRotation( vx,vy, _elements.marker[1],_elements.marker[2] )
			if type(vehicles[player]) == "nil" then
				vehicles[player] = {}
			end
				local cache_s = { [team1] = 1, [team2] = 2 }
					if not no_s then
						spawnPlayer ( player, vx,vy,vz , rot, settings_.teams[ cache_s[getPlayerTeam( player )] ][2][2] )
						setPedArmor( player, tonumber( settings_.main[ 7 ][ 2 ]) or 0 )
					else 
						setElementPosition ( player, vx,vy,vz )
						setPedRotation( player , rot ) 
					end
					local freeze = true
					local z_fix = 250
					if vz > 350 then
						z_fix = 515
					end	
				if  id  == 539 then 
					
						if z_fix == 250 then
							z_fix = 350
						end
						vx,vy,vz = getPositionFromDistanceRotation( vx,vy, z_fix ,rot, 0 )	
				elseif getVehicleType ( id ) == "Helicopter" then 
					vx,vy,vz = getPositionFromDistanceRotation( vx,vy, z_fix ,rot + math.random( - 10.5, 10.5 ) , -500 )	
				elseif getVehicleType ( id ) == "Plane" then
						if z_fix == 250 then
							z_fix = 350
						end
					vx,vy,vz = getPositionFromDistanceRotation( vx,vy, z_fix ,rot , -1000 )	
				elseif getVehicleType ( id ) == 'Boat' then 	
					vz = vz + 1.5
					freeze = false
				else	
					vx,vy,vz = getPositionFromDistanceRotation( vx,vy,vz  , -75 +rot ,1.75 )
					freeze = false
				end
				new_vehicle = createVehicle( id,vx,vy,vz,0,0, rot)
				setElementParent( new_vehicle, map_root_element )
				local r,g,b = getTeamColor( getPlayerTeam ( player ) ) 
				setVehicleColor( new_vehicle, r,g,b,r,g,b,r,g,b,r,g,b )
					if freeze == true then
						setElementFrozen( new_vehicle, true )
					end	
				if #vehicles[player] > 4 then
					destroyElement( vehicles[player][1] )
					table.remove( vehicles[player], 1 )
				end	
			--	setElementDimension ( new_vehicle, getPlayerID( player )+1 )
		--		setElementDimension ( player, getPlayerID( player )+1 )
				table.insert(vehicles[player],new_vehicle)
			--	callClient( player, 'bringPlayerToVehicle', new_vehicle, true )
				callClient( player, '_elementStreamVeh', new_vehicle, true )
				
			
		end
		
	
	--// restore cmd code
	 _restore_global_t = {}
	
		function includeRestoreData( player )
		if _players[ player ]:getStatus( 2 ) ~= 2 then
			return false
		end
			local status = _players[ player ]:getStatus( 3 )
				for _, v in pairs( { 1, 2, 3, 9 } ) do
					if v == status then
						return false
					end	
				end	
		local w_cache = {}
			for i = 0, 12 do 
					if getPedTotalAmmo( player, i ) > 0 and getPedWeapon ( player, i ) > 0 then
						local t_ammo, c_ammo = getPedTotalAmmo( player, i ), getPedAmmoInClip( player, i )
						table.insert( w_cache, { getPedWeapon ( player, i ), t_ammo - c_ammo , c_ammo  } )
					end
			end
			
		local v_cache = {}
		if isPedInVehicle ( player ) then
			v_cache.veh = getPedOccupiedVehicle ( player ) 
			if getPedOccupiedVehicleSeat ( player ) == 0 then
				v_cache.pos = { getElementPosition( v_cache.veh  ) }
				v_cache.rot = { getElementRotation( v_cache.veh  ) }
			else
				v_cache.seat = getPedOccupiedVehicleSeat ( player )
			end
		end
			local cache = (( countdown_data.finish - getTickCount()  ) / 60000 )
			local m = math.modf(cache) 
			local s = math.modf((cache-m)*60)
			if _restore_global_t[ getPlayerSerial ( player ) ] == nil then
				_restore_global_t[ getPlayerSerial ( player ) ] = {}
			end	
			table.insert( _restore_global_t[ getPlayerSerial ( player ) ], { team = getPlayerTeam( player ), pos = { getElementPosition( player ) }, rot = getPedRotation ( player ), armor = math.round(getPedArmor ( player ), 1 ), hp = math.round(getElementHealth ( player ), 1 ),
			name = getPlayerName( player ), weapons = w_cache, vehicle = v_cache, interior = getElementInterior( player ), time = string.format("%.2i:%.2i", m,s ) } )
		
		end
		
		function applyRestoreData( player, id, n )
			callClient( player, "send_missingData", { arena = settings_.arena, base = settings_.base, bomb = settings_.bomb }, settings_.vehicles )
			callClient( player, "changeHudFunctionality", getElementData(global_element,"map_info")[1], getElementData(global_element,"map_info")[1]..": "..getElementData(global_element,"map_info")[2] ) 
			callClient( player, "sdasddsadsa")
		--	callClient( player, "disableSpecate" )
			id = id or getPlayerSerial( player )
			n = n or 1
			local cache_s = { [team1] = 1, [team2] = 2 }
			
			spawnPlayer ( player, _restore_global_t[ id ][ n ].pos[1], _restore_global_t[ id ][ n ].pos[2], _restore_global_t[ id ][ n ].pos[3], _restore_global_t[ id ][ n ].rot,   settings_.teams[ cache_s[ _restore_global_t[ id ][ n ].team ] ][2][2], _restore_global_t[ id ][ n ].interior or getElementData( global_element, "interior" )  )
			_players[ player ]:updateStatus(  2, 2 )	
			
			if _restore_global_t[ id ][ n ].vehicle.veh then -- if player was in vehicle
				if _restore_global_t[ id ][ n ].vehicle.pos then -- if player was a driver
					if getVehicleOccupant( _restore_global_t[ id ][ n ].vehicle.veh ) == false then
						setElementPosition( _restore_global_t[ id ][ n ].vehicle.veh, unpack(_restore_global_t[ id ][ n ].vehicle.pos ) )
						setElementRotation( _restore_global_t[ id ][ n ].vehicle.veh, unpack(_restore_global_t[ id ][ n ].vehicle.rot ) )
						warpPedIntoVehicle( player, _restore_global_t[ id ][ n ].vehicle.veh )
					end
				else
					local x, y, z = getElementPosition( _restore_global_t[ id ][ n ].vehicle.veh )
					if getDistanceBetweenPoints2D( x, y, _restore_global_t[ id ][ n ].pos[1], _restore_global_t[ id ][ n ].pos[2] ) < 200 then -- if this vehicle is still near this place
						warpPedIntoVehicle( player, _restore_global_t[ id ][ n ].vehicle.veh, _restore_global_t[ id ][ n ].vehicle.seat )
					end
				end
			end
			for k, v in pairs ( _restore_global_t[ id ][ n ].weapons ) do 
				giveWeapon ( player, v[1], math.max( v[2], 1 ),  false )
				--setWeaponAmmo ( player, unpack( v ) )
			end
			setElementData( getPlayerTeam( player ), "p_count", getElementData( getPlayerTeam( player ), "p_count") + 1)
			setElementHealth( player, _restore_global_t[ id ][ n ].hp )
			setPedArmor( player, _restore_global_t[ id ][ n ].armor )
				toggleAllControls( player, true )
				setElementFrozen( player, false )
				callClient( player, 'changeHudFunctionality', getElementData(global_element ,"map_info")[1], getElementData(global_element ,"map_info")[1]..": "..getElementData(global_element ,"map_info")[2] )	

			outputChatBox ( "#0AC419[INFO] #d5d5d5Player #0AC419"..tostring(  getPlayerName( player )).."#d5d5d5 has been restored to the round.", getRootElement(), 255, 255, 255, true )
				if round_paused then 
				--	callClient( player, "pause_.response" )
					toggleAllControls( player, false, true, false )
					setElementFrozen( player, true )
				end	
				
				setCameraTarget(  player,  player )
				countdown_sync_request( player )

		end
		
		
		function restore_cmd( player, cmd, id )
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
			if _players[ player_f ]:getStatus( 2 ) == 2 or _players[ player_f ]:getStatus( 2 ) == 0 then
				return  outputChatBox ( "#FF0000[ERROR] #d5d5d5 Impossible to restore player, try again a little bit later.",  player, 255, 255, 255, true )
			end	
			setElementFrozen( player, true )
			if getPedOccupiedVehicle ( player ) then
				setElementFrozen( getPedOccupiedVehicle ( player ), true )
			end	
			return callClient( player, "createRestoreSceneWindow", _restore_global_t, player_f )
			  
		end
		addCommandHandler( "restore",  restore_cmd )
			
		function restore_unfreze( player )
			if round_paused then return 0; end
			
			setElementFrozen( player, false )
			if getPedOccupiedVehicle ( player ) then
				setElementFrozen( getPedOccupiedVehicle ( player ), false )
			end	
		
		end
