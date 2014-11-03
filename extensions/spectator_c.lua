
_initialLoading[ "extensions/spectator_c.lua" ] = function ( )

local _spect_Render = { }
local currentSpect = 0
local currentSpect_player 
local spectEnable = false
addEventHandler ( "onClientElementDataChange",localPlayer,
function ( dataName, old )
	if getElementType ( source ) == "player" and "p_status" then
		local data = getElementData (source, dataName)
		
		if type( data ) == 'table' and type( old ) == 'table' then
			if ( data[1] == "d" and data[2] == 8 and old[1] == "c" and old[2] == 6 ) or ( getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] ~= "Lobby" and  data[1] == "d" and data[2] == 7 ) then
				if ( getElementData( TableTeams[ 1 ], "p_count" ) or 1 ) == 0 or ( getElementData( TableTeams[ 2 ], "p_count" ) or 1 ) == 0 then
					return 0;
				end	
				local _delay = 2300
					if ( getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] ~= "Lobby" and  data[1] == "d" and data[2] == 7 ) then
						_delay = 250
						changeHudFunctionality( getElementData(getElementByIndex ( "root_gm_element",0 ) ,"map_info")[1], getElementData(getElementByIndex ( "root_gm_element",0 ) ,"map_info")[1]..": "..getElementData(getElementByIndex ( "root_gm_element",0 ) ,"map_info")[2], true ) 	
					end
				enabledSpectate( _delay )
			--elseif spectEnable == true and old[1] == "d" and ( data[1] ~= "d" and data[2] ~= 8 then
			elseif spectEnable == true and old[1] == "d" and data[2] ~= 8 then
				spectEnable = false
				unbindKey( "r", "up", spectNext )
				unbindKey( "left", "up", spectNext )
				unbindKey( "right", "up", spectNext )
				unbindKey( "v", "up", cameraSwitch )
				removeEventHandler( "onClientRender", getRootElement(), _renderSpect )
				destroyElement( _spect_Render.font )
					for k, v in ipairs( _spect_Render.alphaCache ) do 
						setElementAlpha( v, 255 )
						table.remove( _spect_Render.alphaCache, k )
					end
			end
		end	
	end
end )


function disableSpecate ( )
	if spectEnable == false then
		return 0;
	end	
	spectEnable = false
	unbindKey( "r", "up", spectNext )
	unbindKey( "left", "up", spectNext )
	unbindKey( "right", "up", spectNext )
	unbindKey( "v", "up", cameraSwitch )
	removeEventHandler( "onClientRender", getRootElement(), _renderSpect )
	destroyElement( _spect_Render.font )
		for k, v in ipairs( _spect_Render.alphaCache ) do 
			setElementAlpha( v, 255 )
			table.remove( _spect_Render.alphaCache, k )
		end

end

function enabledSpectate( _delay )
	if spectEnable == true then
		return 0;
	end	
	currentSpect = 0
	_spect_Render.camera = 0
	bindKey( "r", "up", spectNext )
	bindKey( "left", "up", spectNext )
	bindKey( "right", "up", spectNext )
	bindKey( "v", "up", cameraSwitch )
	setTimer( spectNext, _delay, 1 )
	spectEnable = true
	_spect_Render.title = { x = scaleIntPercent( screenWidth, 24 ), y = scaleIntPercent( screenHeight, 75 ) }
	_spect_Render.text = { x = scaleIntPercent( screenWidth, 26 ), y = scaleIntPercent( screenHeight, 79 ) }
	_spect_Render.text2 = { x = scaleIntPercent( screenWidth, 22 ), y = scaleIntPercent( screenHeight, 79+11 ) }
	_spect_Render.font = dxCreateFont ( "fonts/TravelingTypewriter.ttf", math.cut( 18*(   screenWidth  * ( 1 / 1920 )  ) ) , false ) or "bankgothic" 
	_spect_Render.alphaCache = {}
	setTimer( function() addEventHandler( "onClientRender", getRootElement(), _renderSpect )	end, _delay, 1 )	
	_spect_Render.updateTc = getTickCount() + _delay	
	if not isPlayerHudComponentVisible( 'radar' ) then
		showPlayerHudComponent ( 'radar', true )
	end
end

	local scalar =  math.min( 1, screenWidth  * ( 1 / 1920 ) ) 
		local crosshair_s = { math.cut( scalar*16 ), math.cut( scalar*32 ) } 


function _renderSpect( )
	if isElement( currentSpect_player ) then
	dxDrawOutText ( _spect_Render.titletext, _spect_Render.title.x, _spect_Render.title.y , colors_g.white, 1, _spect_Render.font, 2 )
	dxDrawOutText ( _spect_Render.textetext, _spect_Render.text.x, _spect_Render.text.y , colors_g.white, 0.5, _spect_Render.font, 1 )
	dxDrawOutText ( "Press 'R' to change spectating player, V to change camera.", _spect_Render.text2.x, _spect_Render.text2.y , colors_g.gray, 0.75, _spect_Render.font, 1 )
		if getTickCount( ) > _spect_Render.updateTc then
			_spect_Render.updateTc = getTickCount() + 500
			collectPlayerData( currentSpect_player  )
		end	
		

			if getPedControlState ( currentSpect_player, "aim_weapon" ) then
				local hitX, hitY, hitZ =   getPedTargetCollision (  currentSpect_player )
					if not hitX then
						hitX, hitY, hitZ =   getPedTargetEnd ( currentSpect_player )
					end	
						if hitX then	
							local sX,sY = getScreenFromWorldPosition (hitX, hitY, hitZ, 0, false)
								if sX then 
									dxDrawImage( sX-crosshair_s[1], sY-crosshair_s[1], crosshair_s[2], crosshair_s[2], 'img/cross.png' )
								end
						end
			end			
		
		if _spect_Render.camera == 2 and ( not isPedInVehicle( currentSpect_player ) ) then
			if getElementAlpha( currentSpect_player ) > 0 then
				setElementAlpha( currentSpect_player, 0 )
				table.insert( _spect_Render.alphaCache, currentSpect_player )
			end	
				if getPedControlState ( currentSpect_player, "aim_weapon" ) then
				local hitX, hitY, hitZ =   getPedTargetCollision (  currentSpect_player )
					if not hitX then
						hitX, hitY, hitZ =   getPedTargetEnd ( currentSpect_player )
					end	
						if hitX then
							local x, y, z = getPedBonePosition ( currentSpect_player, 41  )
							z = z + 0.8
							local rotX = getPedCameraRotation( currentSpect_player ) 
							 x, y, z = getCamPos_cords_rot_dis( x, y, z , 360 - rotX, -0.3 )
								setCameraMatrix (  x, y, z, hitX, hitY, hitZ )
						end
				else
					local x, y, z = getPedBonePosition ( currentSpect_player, 6  )
					local rotX = getPedCameraRotation( currentSpect_player ) 
					x, y, z = getCamPos_cords_rot_dis( x, y, z , 360 - rotX, -0.1 )
					
					local x1, y1, z1 = getCamPos_cords_rot_dis( x, y, z , 360 - rotX, -0.15 )

					setCameraMatrix (  x1, y1, z1, x, y, z )
				end	
		elseif _spect_Render.camera == 1 and ( not isPedInVehicle( currentSpect_player ) ) then
			--if getPedControlState ( currentSpect_player, "aim_weapon" ) then
				local hitX, hitY, hitZ =   getPedTargetCollision (  currentSpect_player )
					if not hitX then
						hitX, hitY, hitZ =   getPedTargetEnd ( currentSpect_player )
					end	
					if hitX and getPedControlState ( currentSpect_player, "aim_weapon" ) then
							local x, y, z = getPedBonePosition ( currentSpect_player, 51  )
							
							local x1, y1, z1 = getPedBonePosition ( currentSpect_player, 41  )
							local _fRot = findRotation(x1, y1, x, y)
							x, y, z = getElementPosition ( currentSpect_player  )
							z = z + 0.8

						local rotX = getPedCameraRotation( currentSpect_player ) 
								local z_ = z

							local _v =   ( 4.25 / getDistanceBetweenPoints3D( x, y, z, hitX, hitY, hitZ ) )
							x, y, z = calc_vector( x, y, z, hitX, hitY, hitZ , _v)
							
							x, y = getCamPos_cords_rot_dis( x, y, z , _fRot, 0.75 )

							local _abs = ( z_ - z )
							
								if z < getGroundPosition( x, y, z_ ) then
									z = getGroundPosition( x, y, z_ ) + 0.3
								end	
						local hitB = isLineOfSightClear ( x, y, z, hitX, hitY, hitZ, 
                             true, 
                             false, 
                             false, 
                             true,
                             false, 
                             false, 
                             false )
						if hitB  == false then
							setCameraTarget( currentSpect_player )
								return 0;
						end
						
						setCameraMatrix( x, y, z, hitX, hitY, hitZ )
						

					else
						local x, y, z = getPedBonePosition ( currentSpect_player, 3  )
						z = z + 0.575
						local f_Start = { x, y, z }
						local rotX = getPedCameraRotation( currentSpect_player ) 

						
						local x1, y1, z1 = getCamPos_cords_rot_dis( x, y, z , 360 - rotX, -5 )
						x, y, z = getCamPos_cords_rot_dis( x, y, z , 360 - rotX, -4.5 )
	
					--	hitX, hitY, hitZ = getCamPos_cords_rot_dis( x, y, z , 360 - rotX, 0.05 )
						local x2, y2, z2 = getCamPos_cords_rot_dis( x, y, z , 360 - rotX, 0.55 )
						
						
						local hitB = isLineOfSightClear ( x1, y1, z1, x2, y2, z2, 
                             true, 
                             false, 
                             false, 
                             true,
                             false, 
                             false, 
                             false )
						if hitB  == false then
							setCameraTarget( currentSpect_player )
								return 0;
						end
							setCameraMatrix( x1, y1, z1, x2, y2, z2 )
					end
	
		else
			if getCameraTarget( localPlayer ) ~=  currentSpect_player then
				setCameraTarget(  currentSpect_player )
				setElementAlpha( currentSpect_player, 255 )
			end	

			
		end
		
	end
end


function collectPlayerData( player )
	_spect_Render.titletext = 'Spectating: '..getPlayerName( player)
	_spect_Render.textetext = 'Health: '..math.cut( getElementHealth( player ) )..'%\n'
	if getPedOccupiedVehicle( player ) then
		local v =  getPedOccupiedVehicle( player )
		_spect_Render.textetext = _spect_Render.textetext.. 'Vehicle: '.. getVehicleName(v) ..' ( '..math.cut( math.max( (getElementHealth ( v ) - 250 )/7.496, 0 ) )..'% )\n'
	end 
	local _n = false
		for i=2, 8 do 
		local _weapon = getPedWeapon ( player, i )
			if _weapon and getPedTotalAmmo ( player, i ) > 0 then
				_n = true
				_spect_Render.textetext = _spect_Render.textetext..getWeaponNameFromID ( _weapon )..' ( '..getPedAmmoInClip( player, i )..' )      '
			end
		end
		if _n then
			_spect_Render.textetext = _spect_Render.textetext..'\n'
		end
	_spect_Render.textetext = _spect_Render.textetext..'Kills: '..getElementData( player, 'Kills' )..'      Deaths: '..getElementData( player, 'Deaths' )..'      Damage: '..getElementData( player, 'Damage' )..'      Ping: '..getPlayerPing ( player )
end
	
function getPlayerByID ( id )
	for k, v in pairs( getElementsByType ( "player" )  ) do 
		if getElementData( v, "ID" ) == id then
			return v
		end	
	end	
	return false
end


function spectCommand( cmd, id )
	id = tonumber( id )
		if not id then
			return 0
		end
	local _player =  getPlayerByID ( id )
		if not _player then
			return 0
		end
	if ( not getElementData( localPlayer, "p_status" ) ) or getElementData( localPlayer, "p_status" )[1] ~= "d" then
		return 0
	end
	if ( not getElementData( _player, "p_status" ) ) or getElementData( _player, "p_status" )[1] ~= "c"  then
		return 0
	end
	if getTeamName( getPlayerTeam( _player ) )  == "Spectator" then
		if getPlayerTeam( _player ) == getPlayerTeam( localPlayer ) then
			return 0
		end
	else
		if getPlayerTeam( _player ) ~= getPlayerTeam( localPlayer ) then
			return 0
		end
	end	
	if spectEnable == true then
		sdasddsadsa( 100 )
		currentSpect_player = _player 
		setCameraTarget ( currentSpect_player )
		collectPlayerData( currentSpect_player  )
	else
		currentSpect = 0
		bindKey( "r", "up", spectNext )
		bindKey( "left", "up", spectNext )
		bindKey( "right", "up", spectNext )
		sdasddsadsa( 100 )
		spectEnable = true
		_spect_Render.title = { x = scaleIntPercent( screenWidth, 24 ), y = scaleIntPercent( screenHeight, 75 ) }
		_spect_Render.text = { x = scaleIntPercent( screenWidth, 26 ), y = scaleIntPercent( screenHeight, 79 ) }
		_spect_Render.text2 = { x = scaleIntPercent( screenWidth, 24 ), y = scaleIntPercent( screenHeight, 79+15 ) }
		_spect_Render.font = dxCreateFont ( "fonts/TravelingTypewriter.ttf", math.cut( 18*(   screenWidth  * ( 1 / 1920 )  ) ) , false ) 
		_spect_Render.updateTc = getTickCount() + 500	
		addEventHandler( "onClientRender", getRootElement(), _renderSpect )
		currentSpect_player = _player 
		setCameraTarget ( currentSpect_player )
		collectPlayerData( currentSpect_player  )
	end
	
end
addCommandHandler( 'spectate', spectCommand )
addCommandHandler( 'spect', spectCommand )
addCommandHandler( 'spec', spectCommand )


function cameraSwitch() 
	_spect_Render.camera = _spect_Render.camera + 1
	setCameraTarget(  currentSpect_player )
	setElementAlpha( currentSpect_player, 255 )	
		if _spect_Render.camera > 2 then
			_spect_Render.camera = 0
		end	
playSoundFrontEnd ( 40 )
_c_frame_b = { false }
_c_frame_brot = false
	for k, v in ipairs( _spect_Render.alphaCache ) do 
		setElementAlpha( v, 255 )
		table.remove( _spect_Render.alphaCache, k )
	end
end




function spectNext( val )
	local _pool = filterPlayers( getElementsByType( 'player' ), getPlayerTeam( localPlayer ) )
		local _c_spect = currentSpect 

	
		for k, v in ipairs( _pool ) do
		--outputChatBox( tostring( k )..' '..tostring( _c_spect )..' #'..tostring( #_pool ) )
			if k > _c_spect then
				sdasddsadsa( 100 )
				setElementInterior( localPlayer, getElementInterior( v ) )
				currentSpect_player = v 
				setCameraTarget ( currentSpect_player )
				collectPlayerData( currentSpect_player  )
				_c_spect = k
				currentSpect = _c_spect
				for k, v in ipairs( _spect_Render.alphaCache ) do 
					setElementAlpha( v, 255 )
					table.remove( _spect_Render.alphaCache, k )
				end
				_c_frame_b = { false }
				_c_frame_brot = false
				playSoundFrontEnd ( 15 )
				return setCameraTarget ( currentSpect_player )
			end	
			
		end
		
			--if _c_spect == _pool  then
				_c_spect = 0
				currentSpect = 0
		--	end
		
end

function filterPlayers( t, team )
	local _nT = {}
		if getTeamName( team ) == "Spectator" then
			for k, v in ipairs( t ) do
		
				if getTeamName( getPlayerTeam( v ) ) ~= "Spectator" then
					if _players[ v ]:getStatus( 2 ) == 2 then
						table.insert( _nT, v )
					end
			--		outputDebugString( tostring( getTeamName( getPlayerTeam( v ) ) ).. ' p_status '..tostring( getElementData ( v, "p_status" )[1] )..', '..tostring( getElementData ( v, "p_status" )[2] ), 3 )
				end
				
			end
		else
			for k, v in ipairs( t ) do
		
				if getPlayerTeam( v ) == team then
					local data = getElementData ( v, "p_status" )
					if data[1] == 'c' and tonumber( data[2] ) == 6 then
						table.insert( _nT, v )
					end
				end
				--outputDebugString( tostring( getTeamName( getPlayerTeam( v ) ) ).. ' p_status '..tostring( getElementData ( v, "p_status" )[1] )..', '..tostring( getElementData ( v, "p_status" )[2] ), 3 )
			end
		end
			
	return _nT			 
end

	_initialLoaded( "extensions/spectator_c.lua" )	

end