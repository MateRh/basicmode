
_initialLoading[ "client.lua" ] = function ( )

		setTimer(function()
			local version = getVersion ( )
				for i=1, 10 do outputChatBox ( "\n" ) end
			outputChatBox ( "        Welcome to BasicMode!\n" )
			outputChatBox ( "        Running version: 'BETA' r-"..getElementData( getElementByIndex ( "root_gm_element",0 ), "_revision" ) )
			outputChatBox ( "            Your client version: "..version.tag )
			outputChatBox ( "                basicmodem.blogspot.com" )
		end,50,1)
	
		function calcPolygonDiagonalSize( R, n )
			return 2 * R * math.sin ( 3.14 / n )
		end
	--[[	
			local syf = outputChatBox
	
	function outputChatBox ( ... )
		local arg = { ... }
		outputConsole( arg[1] )
		syf( unpack( arg ) )
	
	end]]

local exit_tc = getTickCount()
addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
		if thePlayer == localPlayer then
			exit_tc = getTickCount()
		end
    end
)		
		
function sync_me_client()
	if tostring(getPedSimplestTask ( localPlayer )) == "TASK_SIMPLE_PLAYER_ON_FOOT" and (getTickCount() - exit_tc) > 5000  then
		if _players[ localPlayer ]:getStatus( 2 ) == 2 then
			removeCommandHandler("rsp", ReturnPlayerAmmo)
			removeCommandHandler ( "sync", sync_me_client )	
			removeCommandHandler ( "fix", sync_me_client )	
			setTimer(function() addCommandHandler ( "rsp", sync_me_client )	
								addCommandHandler ( "sync", sync_me_client )	
								addCommandHandler ( "fix", sync_me_client )	 end,10000,1)
			local rX,rY,rZ = getElementVelocity( localPlayer )
			local globalslot = getPedWeaponSlot ( localPlayer )
			local t_a = {}
			local int_c = 1
				for i=2,11 do
				local sts = getPedTotalAmmo ( localPlayer,i )
					if sts ~= false and sts ~= 0 then
					t_a[int_c] = {getPedWeapon (  localPlayer, i ),sts}
					int_c=int_c+1
					end
				end
				 he_use_rsp = true
				callServer("sync_me", localPlayer, globalslot,t_a ) 
				outputChatBox ( "#FF0000** Info:#0AC419 You will be able to use this command after #FF000010 #0AC419sec.", 255, 255, 255, true )
				
				exports['basicmode^parachute']:stopSkyDiving ()
			else
				outputChatBox ( "#FF0000** Error:#0AC419 You can use this cmd on round if you aren't dead.", 255, 255, 255, true )
			end
		else
		outputChatBox ( "#FF0000** Error:#0AC419 You can use this cmd if you stand on ground.", 255, 255, 255, true )
	end
end
addCommandHandler ( "rsp", sync_me_client )	
addCommandHandler ( "sync", sync_me_client )	
addCommandHandler ( "fix", sync_me_client )	


--[[
addEventHandler("onClientPlayerVehicleExit", localPlayer, function ()
	if getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] ~= "Lobby" then
	setTimer( function()	addEventHandler( 'onClientRender', getRootElement(), onFrameRSP ) end, 1000, 1 )
	end
end )

function onFrameRSP ()
	if tostring(getPedSimplestTask ( localPlayer )) == "TASK_SIMPLE_PLAYER_ON_FOOT" then
		removeEventHandler( 'onClientRender', getRootElement(), onFrameRSP )
		local rX,rY,rZ = getElementVelocity( localPlayer )
		local globalslot = getPedWeaponSlot ( localPlayer )
		local t_a = {}
		local int_c = 1
			for i=2,11 do
			local sts = getPedTotalAmmo ( localPlayer,i )
				if sts ~= false and sts ~= 0 then
				t_a[int_c] = {getPedWeapon (  localPlayer, i ),sts}
				int_c=int_c+1
				end
			end
			 he_use_rsp = true
			callServer("sync_me", localPlayer, globalslot,t_a ) 
		--	exports.parachute:stopSkyDiving ()
			--outputChatBox( " ***** " )
	end
end

]]

--==[[ pause client code ]]==

pause_ = {}
pause_.sett = { sts = false }
	function pause_.update( )
		pause_.sett.lenght = dxGetTextWidth ( "Game || PAUSED.", 2,  "bankgothic" )
		pause_.sett.high = dxGetFontHeight ( 1,  "bankgothic")
		pause_.sett.x = ( screenWidth - pause_.sett.lenght ) / 2
		pause_.sett.y = ( screenHeight  - pause_.sett.high ) / 2
		pause_.sett.txt = "Game || PAUSED."
	end	

	function pause_.response( )
		if pause_.sett.sts == false then
			pause_.update( )
			sdasddsadsa(250)
			createColorCorrectionShader( 0.5 )   
			addEventHandler( "onClientRender", getRootElement(), pause_.render )
			pause_.sett.sts = true
			round_paused = true
			pause_.sett.start = getTickCount()
			local sound_ = playSFX("script", 92, 7, false)
			setSoundVolume (  sound_, 1.0 )
		elseif pause_.sett.sts == true then
			pause_.sett.sts = 0
			pause_.sett.txt = "[ Resumption in 1 sec! ]"
			local sound_ = playSFX("script", 65, 10, false)
			setSoundVolume (  sound_, 1.0 )
			setTimer( function ()
				pause_.sett.sts = false
				round_paused = false
				sdasddsadsa(250)
				disableColorCorrectionShader(  ) 
				removeEventHandler( "onClientRender", getRootElement(), pause_.render )
			end, 1000, 1 )	
		end

	end
	
	function pause_ForceDisable( )
		if pause_.sett.sts == 0 then return 0 end
			pause_.sett.sts = 0
			pause_.sett.txt = ""
			pause_.sett.sts = false
			round_paused = false
			disableColorCorrectionShader(  ) 
			removeEventHandler( "onClientRender", getRootElement(), pause_.render )
	end
	
	function pause_.render( )
		dxDrawTextBaQ_c( pause_.sett.txt, pause_.sett.x ,pause_.sett.y,screenWidth, screenHeight, colors_g.lblue, 2,  "bankgothic",colors_g.black) 
			local _time = getRealTime( string.format( "%d", (getTickCount () - pause_.sett.start ) / 1000 ))
			
		dxDrawTextBaQ_c( string.format( "%.2i:%.2i",_time.minute, _time.second) , pause_.sett.x ,pause_.sett.y + pause_.sett.high*2 ,screenWidth, screenHeight, colors_g.white, 1,  "bankgothic",colors_g.black) 	
	end
	
	
	--==[[ event code ]]==
	
	_event_class = {}
	
	function _event_class.main( name, action )
		if action == 1 then -- on create 
			if name == 'map_start' then
				finishRoundCloseButton ( -9 )
				
			end
		elseif action == -1 then -- on close / on delete 
			if name == "round_end" then
				forceCloseWeaponSelector( )
				forceCloseVehicleS( )
				forceClose_spawn_select( )
				_protect_ForceDisable(  )
				 pause_ForceDisable( )
				 restore_forceDisable( )
				 showCursor( false )
				 updateSides()
				 updateSides()
				 _players[ localPlayer ]:updateStatus(  2, 1 )
				if clientsideCollision then
					switchCollisionMode(  getPedOccupiedVehicle( localPlayer) , clientsideCollision, 1 )
					destroyElement( clientsideCollision )
					clientsideCollision = nil
				end
				  
			elseif name == "round_end_cmd" then
				foceClose_preLoadMap()
				onMapLoadForceEnd( )
				forceCloseWeaponSelector( )
				forceCloseVehicleS( )
				forceClose_spawn_select( )
				_protect_ForceDisable(  )
				 pause_ForceDisable( )
				 restore_forceDisable( )
				 showCursor( false )
				 updateSides()
				 updateSides()
				_players[ localPlayer ]:updateStatus(  2, 1 )
				 if clientsideCollision then
					switchCollisionMode(  getPedOccupiedVehicle( localPlayer) , clientsideCollision, 1 )
					destroyElement( clientsideCollision )
					clientsideCollision = nil
				end
				 
			end
		end
	end
	

	local enabled_was = false
	local enabled_was_tc = false
	local aiming = false
	
		bindKey( "fire", "both", function ( key, keyState )
			local _weapon_, thasw = getPedWeapon ( localPlayer ), false
				for k, v in pairs( {  29, 30, 31, 33, 38 } ) do 
					if _weapon_ == v then
						thasw = true
						
						break
					end
				end
				if not thasw then
					return 0
				end	
			if keyState == "down" then
				if not getControlState("aim_weapon" ) then
					setControlState( "aim_weapon", true )
				end	
					 enabled_was  = true
					 enabled_was_tc = false
			else
				if  enabled_was  == true then
					if ( not  enabled_was_tc ) and ( not aiming  ) then
						setControlState( "aim_weapon", false )
					end
					 enabled_was  = false
					 local status = false
					 local keys = getBoundKeys ( "aim_weapon" )
						for keyName, state in pairs(keys) do
							if getKeyState ( keyName ) == true then
								status = true
								break
							end
						end
							if status == false then
								setControlState( "aim_weapon", false )
							end
					  
				end
				
			end
		end )
		
		
		bindKey( "aim_weapon", "both", function ( key, keyState )
			local _weapon_, thasw = getPedWeapon ( localPlayer ), false
				for k, v in pairs( {  29, 30, 31, 33, 38 } ) do 
					if _weapon_ == v then
						thasw = true
						
						break
					end
				end
				if not thasw then
					return 0
				end	
					
			if keyState == "down" then
				enabled_was_tc  = true
			--	enabled_was  = true
				aiming = true
			else
				if  enabled_was  == true then
					
					setControlState( "aim_weapon", true )
				else
					setControlState( "aim_weapon", false )
				--	 enabled_was  = false
				end
				aiming = false
			end
		end )
		
		
		
	local args_v = {}			
		
		
		
		function _elementStreamVeh_enter(  player )
		removeEventHandler("onClientVehicleEnter", source, _elementStreamVeh_enter )
			if getVehicleType ( source ) == "Helicopter"  or getVehicleType ( source ) == "Plane" then
				local x, y, z = getElementRotation( source )
					setElementRotation( source, 90, y, z )
					setTimer( setElementRotation, 350, 1, source, x, y, z )
					setTimer( setElementRotation, 700, 1, source, 270, y, z )
					setTimer( setElementRotation, 1050, 1, source, x, y, z )
					setTimer( setCameraTarget, 1100, 1, localPlayer )
					setTimer( blur_remote, 1100, 1, nil, 0.5, false )
				return 0;
			else
				setCameraTarget( localPlayer )
				blur_remote( nil, 0.5, false )
			end
			
			--setCameraTarget( localPlayer )
		end
		
		function _elementStreamVeh_stream(  )
			removeEventHandler( "onClientElementStreamIn", source, _elementStreamVeh_stream )
			--	if args_v[1] then
				--	callServer( '_vehicle_spawner_cd', localPlayer, source )
			--	else
				addEventHandler("onClientVehicleEnter", source, _elementStreamVeh_enter )
				callServer( 'warpPedIntoVehicle', localPlayer, source, 0 )
			--	setCameraTarget( localPlayer )
			--	setTimer( setCameraTarget, getPlayerPing( localPlayer ) + 50, 1, localPlayer )
				--	setTimer( function() sdasddsadsa(500)  blur_remote( false ) setCameraTarget( localPlayer ) end, getPlayerPing( localPlayer ) + 50, 1, localPlayer )

			--	end
		end
		
		
		
		function _onFrameCollisionSet( )	
			local _veh = getPedOccupiedVehicle( localPlayer )
				if _veh then
					for _, vehicle in pairs(getElementsByType("vehicle")) do 
						setElementCollidableWith(vehicle, _veh, false) 
					end
				
				fixVehicle( _veh )
				end
			if getElementData(  getElementByIndex ( "root_gm_element",0 ),"map_info")[1] == "Lobby" then
				removeEventHandler('onClientRender', getRootElement(), _onFrameCollisionSet )
			end	
		end
		
		
		function _elementStreamVeh(  vehicle, rBool )
			args_v = {  rBool }	
			addEventHandler( "onClientElementStreamIn", vehicle, _elementStreamVeh_stream )
			blur_remote( nil, 0.5, true )
			local x,y,z = getElementPosition( vehicle )
				setCameraMatrix( x-2,y-2,z, x, y, z )
				local type_ = getVehicleType( vehicle )
					if  type_ == 'Helicopter' or type_ == 'Plane' or getElementModel( vehicle ) == 539 then 
						addEventHandler('onClientRender', getRootElement(), _onFrameCollisionSet )
						if  type_ == 'Helicopter' then
							setHelicopterRotorSpeed ( vehicle, 0.2 )
						end
					end	
		end

function handleVehicleDamage(attacker, weapon, loss, x, y, z, tyre)
    if tyre and isVehicleBlown ( source ) then
        cancelEvent()
    end
end
addEventHandler("onClientVehicleDamage", root, handleVehicleDamage )
local _heliExplosion = { }
local _colSphere = createColSphere  ( 0, 0, 0, 7.5 )


function ClientExplosionFunction(x,y,z,theType)
if client_global_settings.helliboom == 'unchanged' then
	return 0;
end	
	if theType == 7 or theType == 2 then
		setElementPosition( _colSphere, x, y, z )
		local veh = getElementsWithinColShape ( _colSphere, "vehicle" ) 
			for k, v in ipairs( veh ) do      
				if getVehicleType ( v ) == 'Helicopter' or getVehicleType ( v ) == 'Plane' then
					cancelEvent( )
					if  client_global_settings.helliboom  == 'explosion fully disabled' then
						_heliExplosion.text = getVehicleType ( v )..' explision completely canceled'
					elseif 	client_global_settings.helliboom  == 'explosion reduced 2x' then
						_heliExplosion.text = getVehicleType ( v )..' explosion reduced 2x'
					elseif 	client_global_settings.helliboom  == 'explosion reduced 3x' then
						_heliExplosion.text = getVehicleType ( v )..' explosion reduced 3x'
					end
						_heliExplosion.x, _heliExplosion.y, _heliExplosion.z = x, y, z
						_heliExplosion.w, _heliExplosion.h =  dxGetTextWidth ( _heliExplosion.text ), dxGetFontHeight ( )
						_heliExplosion.start_ = getTickCount() + 2000
						_heliExplosion.end_ = getTickCount() + 7000
						_heliExplosion.veh = v
						if not _heliExplosion.enabled then
							addEventHandler("onClientRender", getRootElement(), _renderInfo, false, 'low' )
						end		
						_heliExplosion.enabled = true
					return 1;
				end
			end
	
	end
	
end
addEventHandler("onClientExplosion",getRootElement(),ClientExplosionFunction)



addEventHandler("onClientVehicleDamage", getRootElement(), 
	function ( player, wepon, loss )
		if player == localPlayer and loss > 5 then
			callServer( 'lastVehAtt', source, player )
		end
	end )



function _renderInfo( )
	if getTickCount() < _heliExplosion.start_ then
		return 0;
	end	
	local x, y = getScreenFromWorldPosition( _heliExplosion.x, _heliExplosion.y, _heliExplosion.z )
		if x and y  and isElementOnScreen( _heliExplosion.veh ) then
		x = x - _heliExplosion.w / 2
			dxDrawRectangle ( x - 2, y - 2, _heliExplosion.w + 4, _heliExplosion.h + 4 , tocolor( 0, 0, 0, 200 ) )
			dxDrawText (  _heliExplosion.text, x , y  )
		end	
	if getTickCount() > _heliExplosion.end_ then
		removeEventHandler("onClientRender", getRootElement(), _renderInfo )
		_heliExplosion = {}
	end

end

local weapon_switch = { slot = 0,
						action = 'next_weapon'
						}

		function weapon_switch.func ( )
			setControlState ( weapon_switch.action, true )
		end
		
		function weapon_switch.getSlot( id )
			local av_slots = {}
				for i=2, 8 do
					if getPedWeapon ( localPlayer, i ) ~= 0 then
						table.insert( av_slots, i )
					end	
				end
			return av_slots[id] or false
		end
		
		function weapon_switch.getAction( id )
			if id - getPedWeaponSlot( localPlayer) < 0 then
				
				return 'previous_weapon'
			else
				return 'next_weapon'
			end
		end
						
function weapon_switch.event ( prevSlot, newSlot )
	if newSlot ~= weapon_switch.slot then

		setControlState ( 'next_weapon', false )
		setControlState ( 'previous_weapon', false )
		setTimer( weapon_switch.func, 50, 1 )

	else
		removeEventHandler ( "onClientPlayerWeaponSwitch", getRootElement(), weapon_switch.event )
		setControlState ( 'next_weapon', false )
		setControlState ( 'previous_weapon', false )
	end	
end



 function  weapon_switch.bind( key )
	if isPedDead( localPlayer ) or isPedInVehicle( localPlayer )  or getControlState( 'fire' ) or getControlState(  'aim_weapon' ) then
		return 0
	end
 
 
	local slot = weapon_switch.getSlot( tonumber( key ) )
	if getPedWeapon ( localPlayer, slot ) == 0 or getPedTotalAmmo ( localPlayer, slot ) == 0 or slot == getPedWeaponSlot ( localPlayer ) or slot == false then
		return 0
	end
		
		weapon_switch.action = weapon_switch.getAction( slot )
		weapon_switch.slot = slot
		addEventHandler ( "onClientPlayerWeaponSwitch", getRootElement(), weapon_switch.event )
		 weapon_switch.func ( )
end 
bindKey( '1', 'down', weapon_switch.bind )
bindKey( '2', 'down', weapon_switch.bind )
bindKey( '3', 'down', weapon_switch.bind )
bindKey( '4', 'down', weapon_switch.bind )
bindKey( '5', 'down', weapon_switch.bind )
bindKey( '6', 'down', weapon_switch.bind )

	
	setTimer( outputChatBox, math.random( 37000, 81000 ), 1 ,"#FF0000[INFO] #FFFFFF Use '#c8c8c8F2#FFFFFF' for shader panel.", 255, 255, 255, true )
	math.randomseed(  getRealTime( ).timestamp)
	setTimer( outputChatBox, math.random( 37000, 81000 ), 1 ,"#FF0000[INFO] #FFFFFF Use '#c8c8c81, 2, 3, 4, 5, 6#FFFFFF' for fast weapon switch like in fps games.", 255, 255, 255, true )

for i=1, 49 do setGarageOpen ( i , true ) end

			
addEventHandler("onClientPlayerVehicleExit", localPlayer,
    function( vehicle )
		local vehicle_type = getVehicleType( vehicle )
		if vehicle_type  == 'Plane' or vehicle_type  == 'Helicopter' then
			local x, y, z = getElementPosition( vehicle )
			local ground = math.max( getGroundPosition( x, y, z ), getWaterLevel( x, y, z, false ) or -1 )
				if z - ground > 10 then
					setTimer( function() 
							callServer("giveWeapon", localPlayer, 46, 1, false )	
							end, 50, 1 )
				end
		end
	
    end
)							
							
							
function para_request( )
	if isPedInVehicle( localPlayer ) then
		local vehicle = getPedOccupiedVehicle( localPlayer )
			local vehicle_type = getVehicleType( vehicle )
				if vehicle_type  == 'Plane' or vehicle_type  == 'Helicopter' then
					if getPedWeapon ( localPlayer, 11 ) == 46 then
						callServer("takeWeapon", localPlayer, 46)	
						return outputChatBox( "#FF0000[INFO] #FFFFFF You left '#c8c8c8parachute#FFFFFF' in the vehicle.", 255, 255, 255, true )
					else
					local x, y, z = getElementPosition( vehicle )
					--[[	local ground = math.max( getGroundPosition( x, y, z ), getWaterLevel( x, y, z, false ) or -1 )
							if z - ground > 10 then
								return outputChatBox( "#FF0000[INFO] #FFFFFF You can't took '#c8c8c8parachute#FFFFFF' from the vehicle while you're in airborne.", 255, 255, 255, true )
							end]]
						callServer("giveWeapon", localPlayer, 46, 1, false )
						callServer('setPedWeaponSlot',  localPlayer, 0 )		
						return outputChatBox( "#FF0000[INFO] #FFFFFF You took '#c8c8c8parachute#FFFFFF' from the vehicle.", 255, 255, 255, true )
					end	
				end
	end
	return outputChatBox( "#FF0000[ERROR] #FFFFFF Parachute is only on equipment of '#c8c8c8planes and helicopters#FFFFFF'.", 255, 255, 255, true )
end							
	addCommandHandler ( 'para', para_request )				
	addCommandHandler ( 'parachute', para_request )	



	
function cancelDeath()
	if  client_global_settings.hellikill == true then
		cancelEvent()
	end	
end
addEventHandler("onClientPedHeliKilled", root, cancelDeath)
						
						
						
						
						
		setPedTargetingMarkerEnabled ( false )		
		setPedVoice ( localPlayer, "PED_TYPE_DISABLED", "" )
		setWorldSoundEnabled( 6, true )
		setWorldSoundEnabled( 4, true )
		
		
		addEventHandler( "onClientResourceStop", getRootElement( ),
    function ( res )
       if getThisResource() == res then
			setPedTargetingMarkerEnabled ( true )		
	   end 
	 end ) 
	 
	 
	 
	 
	 addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
        if getElementType( source ) == "ped" then
				setPedVoice ( source, "PED_TYPE_DISABLED", "" )
			if isPedDead ( source ) then
				if getPedMoveState ( source ) ~= false then
					local x,y,z = getElementPosition( source )
						setElementPosition( source, x, y, z + 15 )
				end
			
			end
        end
    end
);

addEventHandler("onClientPedWasted", getRootElement(),     
	function ( )
		if source ~= localPlayer and isPedDead ( source ) then
			if getPedMoveState ( source ) ~= false then
				local x,y,z = getElementPosition( source )
					setElementPosition( source, x, y, z + 15 )
			end
		
		end
    end
);

addEventHandler ( "onClientPlayerSpawn", getRootElement(), function() setPedVoice ( source, "PED_TYPE_DISABLED", "" ) end )

function findRotation(x1,y1,x2,y2)
 
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
 
end


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
					
	local t__stopThisVehicle = {}													
function _stopThisVehicle ( veh )
	t__stopThisVehicle.veh = veh
	addEventHandler( 'onClientRender', getRootElement(), r_stopThisVehicle )
	setControlState ( 'brake_reverse', true )
	setControlState ( 'handbrake', true )
	setVehicleEngineState ( veh, false )
	toggleControl ( 'enter_exit', false )
end

function r_stopThisVehicle ( )
	if getElementSpeed( t__stopThisVehicle.veh ) > 20 then
		
		setControlState ( 'brake_reverse', true )
		setControlState ( 'handbrake', true )
		
		setControlState ( 'accelerate', false )
		setControlState ( 'enter_exit', false )
		local x, y, z = getElementVelocity( t__stopThisVehicle.veh )
		--	if getVehicleType(  t__stopThisVehicle.veh ) == 'Automobile' then
				setElementVelocity(  t__stopThisVehicle.veh, x*0.98, y*0.98, z )
		--	else
			--		setElementVelocity(  t__stopThisVehicle.veh, x*0.95, y*0.95, z )
		--	end
	else
		local x, y, z = getElementVelocity( t__stopThisVehicle.veh )
			if getVehicleType(  t__stopThisVehicle.veh ) == 'Bike' or getVehicleType(  t__stopThisVehicle.veh ) == 'BMX' then
				setElementVelocity(  t__stopThisVehicle.veh, x*0.25, y*0.25, z )
			end
		toggleControl ( 'enter_exit', true )
		setControlState ( 'brake_reverse', true )
		setControlState ( 'handbrake', true )
			for i=1, 10 do 
				setControlState ( 'enter_exit', true )
			end
		removeEventHandler( 'onClientRender', getRootElement(), r_stopThisVehicle )
		setControlState ( 'brake_reverse', false )
		setControlState ( 'handbrake', false )
		setTimer( function() setControlState ( 'enter_exit', false ) end, 100, 1 )
	end

end

--[[
local _blipsAnim = getTickCount() + 300
addEventHandler( 'onClientRender', getRootElement(), 
	function()
		if getTickCount() > _blipsAnim then
		_blipsAnim = getTickCount() + 300
			for k, v in pairs(  getElementsByType ( 'blip', getRootElement(), true ) ) do 
				if getBlipIcon( v ) == 0 and getBlipSize( v ) == 3 then
				local r,g,b,a = getBlipColor ( v )
					if a == 255 then
						setBlipColor( v, r,g,b, 75 )
					else
						setBlipColor( v, r,g,b, 255 )
					end
				end
			end
		end
	end
, false, 'low-999' )]]


bindKey( 'aim_weapon', 'both', function (key, state )

	if getPedWeapon( localPlayer ) == 32 or getPedWeapon( localPlayer ) == 28 then
		if state == 'down' then
			callServer( 'setPedWalkingStyle', localPlayer, 55 )
			setPedWalkingStyle ( localPlayer, 55 )
		else
			callServer( 'setPedWalkingStyle', localPlayer, 0 )
			setPedWalkingStyle ( localPlayer, 0 )
		end
	end	


	end)


setDevelopmentMode ( true )
	for i=11, 16 do 
		setWorldSoundEnabled( 5, i, false )
	end	
	setWorldSoundEnabled( 5, 63, false )


--playSFX("genrl", 136, 3, false)
--[[

	addEventHandler("onClientPlayerWeaponFire" ,getRootElement(),
     function( weapon, ammo, ammoInClip, hitX, hitY, hitZ, hitElement, x, y, z )
          if weapon == 38 then
             --  local x, y, z = getPedWeaponMuzzlePosition( source )
              setSoundVolume ( playSFX3D ( "genrl", 136, 3, x, y, z ), 0.75 )
             -- setSoundVolume ( playSFX3D ( "genrl", 136, 3, x, y, z ), 0.5 )
          end
     end
)]]
	_initialLoaded( "client.lua" )	

end

addEventHandler( "onClientResourceStart", getRootElement( ),
    function (  )
		collectgarbage('collect')
    end
);