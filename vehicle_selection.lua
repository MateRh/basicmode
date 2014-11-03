
_initialLoading[ "vehicle_selection.lua" ] = function ( )
	
local vehicleCachefPos = {}
local _vehicleClass = { 

					fBuffer = {},
					fGui = {},
				} 

				
				--[[ Lol lodzi nie ma ]]--

function _vehicleCreate( x, y, z, no_w )

	_players[ localPlayer ]:updateStatus(  3, 2 )
	vehicleCachefPos = { x,y,z }
	
	if getWaterLevel ( x,y,z ) ~= false and getWaterLevel ( x,y,z ) > getGroundPosition( x,y,z ) then
		z = getWaterLevel( x,y,z + 5 ) -0.5
	else
		z = getGroundPosition( x,y,z + 5 )
	end
	
	local car 
	for k,v in ipairs( client_settings_t.vehicles ) do	
		car = createVehicle ( v, x,y,z+2 )
		if car then
			break
		end	
	end	
		
	removeEventHandler ( "onClientRender", getRootElement(), onRenderBar )	
	setVehicleDoorsUndamageable ( car, true )
	setVehicleDamageProof  ( car, true )
	setElementDimension( localPlayer, getElementData( localPlayer, "ID" ) + 1 )
	setElementDimension( car, getElementData( localPlayer, "ID" ) + 1)
	setElementRotation ( car, 0, 0, 0 )

	_vehicleClass.fGui = {
					x, y ,z, 
					sx = x,
					sy = y,
					sz = z,
					rot = 0,
					veh = car,
					color = { getTeamColor( getPlayerTeam ( localPlayer ) ) },
					no_w = no_w
				}
	setElementPosition(  _vehicleClass.fGui.veh, _vehicleClass.fGui.sx,_vehicleClass.fGui.sy,_vehicleClass.fGui.sz+2)
	
	local r, g, b = getTeamColor( getPlayerTeam ( localPlayer ) )
	setVehicleColor ( _vehicleClass.fGui.veh, r, g, b, r, g, b, r, g, b, r, g, b )
	
	local x1,y1,z1 = getCamPos_cords_rot_dis( x, y, z, 45, -8 )
	setCameraMatrix ( x1, y1, z1, x, y, z )
	_vehicleClass.fBuffer = { x1, y1, z1, x, y, z }
	
		if _gloabl_aspectratio == '16:9' or _gloabl_aspectratio == '16:10' then	
			_vehicleClass.fGui.guiGridList1 = guiCreateGridList (  0.15, 0.66, 0.7, 0.25, true, _vehicleClass.fGui.guiwindow1 )
				_vehicleClass.fGui.spawn_accept = guiCreateButton ( 0.75,0.635, 0.1, 0.02, "Spawn", true, _vehicleClass.fGui.img)
			_vehicleClass.fGui.edit = guiCreateEdit ( 0.15, 0.635, 0.1, 0.02, "Search...", true, _vehicleClass.fGui.img )
		else
			_vehicleClass.fGui.guiGridList1 = guiCreateGridList ( 0.00, 0.56, 1.0, 0.35, true, _vehicleClass.fGui.guiwindow1 )
				_vehicleClass.fGui.spawn_accept = guiCreateButton ( 0.85,0.56-0.04, 0.15, 0.035, "Spawn", true, _vehicleClass.fGui.img)
			_vehicleClass.fGui.edit = guiCreateEdit ( 0.0, 0.56-0.04, 0.15, 0.035, "Search...", true, _vehicleClass.fGui.img )
		end	
	

	_vehicleClass.fGui.start = getTickCount()+250
	guiGridListSetSortingEnabled ( _vehicleClass.fGui.guiGridList1, false )
	guiGridListSetSelectionMode ( _vehicleClass.fGui.guiGridList1, 2 )

	local sorting_seq = { }
	
				
	_vehicleClass.fGui.vehiclesRepo = {
									Automobiles = { {}, {}, {}, {} },
									Aircrafts = {},
									Motorbikes = {},
									Others = {}
								}

		if getWaterLevel ( x,y,z -2.5 ) ~= false and getWaterLevel ( x,y,z -2.5 ) > getGroundPosition( x,y,z -2.5 ) then
		
				_vehicleClass.inWater = true 
				
				sorting_seq = {
								Aircrafts={ "Plane", "Helicopter" },
								Boats={ "Boat" }
							}
								
				_vehicleClass.fGui.vehiclesRepo = {
									Aircrafts = {},
									Boats = {},
								}				
			guiGridListAddColumn ( _vehicleClass.fGui.guiGridList1 , "Aircrafts", 0.17 )	
			guiGridListAddColumn ( _vehicleClass.fGui.guiGridList1 , "Boats", 0.17 )	
			
				_vehicleClass.columns_ = {
							Aircrafts = 1,
							Boats = 2,
					}
					
			table.insert( client_settings_t.vehicles, 472 )
			table.insert( client_settings_t.vehicles, 473 )
			table.insert( client_settings_t.vehicles, 493 )
			table.insert( client_settings_t.vehicles, 595 )
			table.insert( client_settings_t.vehicles, 484 )
			table.insert( client_settings_t.vehicles, 453 )
			table.insert( client_settings_t.vehicles, 452 )
			table.insert( client_settings_t.vehicles, 446 )
			table.insert( client_settings_t.vehicles, 454 ) -- temp fix

		else
		
			_vehicleClass.inWater = false
			
			_vehicleClass.columns_ = {
								Automobiles = { 1, 2, 3, 4 },
								Aircrafts = 5,
								Motorbikes = 6,
								Others = 7  
							}
				sorting_seq = { 
						Automobiles = { "Automobile" },
						Aircrafts = { "Plane", "Helicopter" },
						Motorbikes = { "Bike" },
						Others = { "Train", "Trailer", "BMX", "Monster Truck", "Quad" }
					}			
							
			
			guiGridListAddColumn ( _vehicleClass.fGui.guiGridList1 , "Automobiles", 0.135 )
				guiGridListAddColumn ( _vehicleClass.fGui.guiGridList1 , "Automobiles" , 0.135 )
					guiGridListAddColumn ( _vehicleClass.fGui.guiGridList1 , "Automobiles" , 0.135 )
						guiGridListAddColumn ( _vehicleClass.fGui.guiGridList1 , "Automobiles" , 0.135 )
					guiGridListAddColumn ( _vehicleClass.fGui.guiGridList1 , "Aircrafts", 0.135 )	
				guiGridListAddColumn ( _vehicleClass.fGui.guiGridList1 , "Motorbikes", 0.135 )	
			guiGridListAddColumn ( _vehicleClass.fGui.guiGridList1 , "Others", 0.135 )	
			
		end
	
	
		for k, v in ipairs( client_settings_t.vehicles ) do	
		
			local type_ = getVehicleType( v )
			
				for k1, v1 in pairs( sorting_seq ) do	
				
					for k2, v2 in ipairs( v1 ) do	
					
						if type_ == v2 then
							if type_ == 'Automobile' then
								if #_vehicleClass.fGui.vehiclesRepo[k1][1] < 35 then
									table.insert( _vehicleClass.fGui.vehiclesRepo[k1][1], v )
									break
								elseif #_vehicleClass.fGui.vehiclesRepo[k1][1] > 34 and  #_vehicleClass.fGui.vehiclesRepo[k1][2] < 35  then
									table.insert( _vehicleClass.fGui.vehiclesRepo[k1][2], v )
									break
								elseif #_vehicleClass.fGui.vehiclesRepo[k1][2] > 34 and  #_vehicleClass.fGui.vehiclesRepo[k1][3] < 35  then
									table.insert( _vehicleClass.fGui.vehiclesRepo[k1][3], v )
									break
								else
									table.insert( _vehicleClass.fGui.vehiclesRepo[k1][4], v )
									break
								end
							else
								table.insert( _vehicleClass.fGui.vehiclesRepo[k1], v )
								break
							end
							
						end
						
					end
					
				end
				
		end

		for k,v in pairs( _vehicleClass.fGui.vehiclesRepo ) do	
			for k1,v1 in ipairs( v ) do	
				if type ( _vehicleClass.columns_[k] ) == 'table' then
					for k2,v2 in ipairs( v1 ) do	
						if k2 > guiGridListGetRowCount ( _vehicleClass.fGui.guiGridList1 ) then
							guiGridListAddRow ( _vehicleClass.fGui.guiGridList1 )
						end	
						guiGridListSetItemText ( _vehicleClass.fGui.guiGridList1, k2-1,_vehicleClass.columns_[k][k1], getVehicleNameFromModel( v2), false, false )
					end
				else
					if k1 > guiGridListGetRowCount ( _vehicleClass.fGui.guiGridList1 ) then
						guiGridListAddRow ( _vehicleClass.fGui.guiGridList1 )
					end	
				guiGridListSetItemText ( _vehicleClass.fGui.guiGridList1, k1-1, _vehicleClass.columns_[k], getVehicleNameFromModel( v1), false, false )
				end
			end
		end	

	addEventHandler( "onClientRender", getRootElement(), r_VehicleSelector )
	addEventHandler ( "onClientGUIClick", _vehicleClass.fGui.guiGridList1, onVehicleSelect, false )
	addEventHandler ( "onClientGUIClick", _vehicleClass.fGui.spawn_accept, onVehicleAccpet, false )
	addEventHandler ( "onClientGUIClick", _vehicleClass.fGui.edit, onVehicleAccpet, false )
	addEventHandler("onClientGUIChanged", _vehicleClass.fGui.edit, _vehicleSearch , false )

		if isElement( flashing_area ) then
			destroyElement( flashing_area )
		end
		flashing_area = createRadarArea ( x-175, y-175, 350, 350, r,g,b, 255, localPlayer )
		setRadarAreaFlashing ( flashing_area, true ) 
		
		setTimer( function()
				local r,g,b = getTeamColor( getPlayerTeam ( localPlayer ) )
				setVehicleColor ( _vehicleClass.fGui.veh, r,g,b,r,g,b,r,g,b,r,g,b ) 
			end, 50, 2 )
	
	
	guiSetInputMode ( "no_binds_when_editing" )
	guiGridListSetSelectedItem ( _vehicleClass.fGui.guiGridList1, 0, 1 )
	triggerEvent(  "onClientGUIClick", _vehicleClass.fGui.guiGridList1 )
	showCursor( true )
	dofSwitch( true )
	dofUpdateSettings( 0.9*1.5  )
	
		if screenHeight < 601 then
			guiSetFont ( _vehicleClass.fGui.spawn_accept, 'default-small' )
			guiSetFont ( _vehicleClass.fGui.guiGridList1, 'default-small' )
		end
end

function _vehicleSearch ( )

	local how_much = {}
	local text_ = guiGetText( source )
	
	if type( tonumber( text_  ) ) == "number" and getVehicleNameFromModel( tonumber( text_ ) ) then
		how_much.off = true
		text_ = string.lower( getVehicleNameFromModel( tonumber( text_  ) ) ) 
	else
		text_ = string.lower( text_ ) 
	end
	
		if text_ == false or #text_ == 0 then
			return 0
		end
	
		for k,v in pairs( _vehicleClass.fGui.vehiclesRepo ) do	
		
			for k1, v1 in ipairs( v ) do	
			
				if type(v1) == 'table' then
				
					for k2, v2 in ipairs( v1 ) do	
						local _f = { string.find( string.lower( getVehicleNameFromModel( v2 ) ), text_ ) }
						if _f[1] ~= nil then 
						
							if how_much.off == true then
								guiGridListSetSelectedItem ( _vehicleClass.fGui.guiGridList1, k2-1, _vehicleClass.columns_[k][k1] )
								return	triggerEvent(  "onClientGUIClick", _vehicleClass.fGui.guiGridList1 )
							else
								table.insert( how_much, { k2-1, _vehicleClass.columns_[k][k1], (_f[2]-_f[1])+1 } )
							end
							
						end
					end
				else
					local _f = { string.find( string.lower( getVehicleNameFromModel( v1 ) ), text_ ) }
					if _f[1] ~= nil then 
					
						if how_much.off == true then
							guiGridListSetSelectedItem ( _vehicleClass.fGui.guiGridList1, k1-1, _vehicleClass.columns_[k] )
							return triggerEvent(  "onClientGUIClick", _vehicleClass.fGui.guiGridList1 )
							
						else
							table.insert( how_much, { k1-1, _vehicleClass.columns_[k], (_f[2]-_f[1])+1 } )	
						end
					end
				end	
				
			end
			
		end	
		
		local _max, max_id = 0, 1
		for k, v in pairs( how_much ) do	
			if v[3] > _max then
				_max = v[3]
				max_id = k
			end
		end
		
			if how_much[max_id] == nil then
				return 
			end
			
		local select, cell = guiGridListGetSelectedItem ( _vehicleClass.fGui.guiGridList1 )
			if select == how_much[max_id][1] and cell == how_much[max_id][2] then
				return 0 
			end
		guiGridListSetSelectedItem ( _vehicleClass.fGui.guiGridList1, how_much[max_id] [1], how_much[max_id] [2] )
		triggerEvent(  "onClientGUIClick", _vehicleClass.fGui.guiGridList1 )
		
end

function onVehicleSelect()
	local select, cell = guiGridListGetSelectedItem ( _vehicleClass.fGui.guiGridList1 )
		if select ~= -1 then
			local name = guiGridListGetItemText ( _vehicleClass.fGui.guiGridList1, select , cell  )
				if name then
					sdasddsadsa(250)
					setElementPosition(  _vehicleClass.fGui.veh, _vehicleClass.fGui.sx,_vehicleClass.fGui.sy,_vehicleClass.fGui.sz + 1 )
					setElementModel(  _vehicleClass.fGui.veh, getVehicleModelFromName ( name ))
					setElementRotation (  _vehicleClass.fGui.veh, 0, 0, 0 )
						if 432 ==  getVehicleModelFromName ( name ) then
							_vehicleClass.fGui.z_fix = 0.05
						else
							_vehicleClass.fGui.z_fix = 0
						end
					setElementPosition( _vehicleClass.fGui.veh, _vehicleClass.fGui.sx,_vehicleClass.fGui.sy,_vehicleClass.fGui.sz +  math.abs(  getVehicleComponentPosition ( _vehicleClass.fGui.veh, 'wheel_rf_dummy' ) or getVehicleComponentPosition ( _vehicleClass.fGui.veh, 'wheel_front' ) or 0.75  ) +0.15 )
					setVehicleEngineState ( _vehicleClass.fGui.veh, false )
					local r,g,b =  getTeamColor( getPlayerTeam ( localPlayer ) ) 
					setVehicleColor ( _vehicleClass.fGui.veh, r,g,b,r,g,b,r,g,b,r,g,b )	
				end
		end		
end


local _on_waitForAction = {}
_on_waitForAction.data = {}

function _on_waitForAction.getData ()
	_on_waitForAction.data = {}
	_on_waitForAction.data.lenght = dxGetTextWidth ( "When you're ready, try to 'accelerate'\n your vehicle. After this you will regain \ncontrol of the vehicle, so get ready!", 3,  "default-bold" )
	_on_waitForAction.data.high = dxGetFontHeight ( 3, "default-bold")
	_on_waitForAction.data.x = ( screenWidth - _on_waitForAction.data.lenght ) / 2
	_on_waitForAction.data.y = ( (screenHeight / 2 ) - _on_waitForAction.data.high ) / 2
end

function forceCloseVehicleS()
	if not isElement( _vehicleClass.fGui.guiGridList1 )  then
		return 0 
	end
		addEventHandler ( "onClientRender", getRootElement(), onRenderBar, false, "low" )
			setElementDimension( localPlayer, 0 )
				removeEventHandler("onClientGUIChanged", _vehicleClass.fGui.edit, _vehicleSearch  )
					removeEventHandler ( "onClientGUIClick", _vehicleClass.fGui.guiGridList1, onVehicleSelect )
						removeEventHandler ( "onClientGUIClick", _vehicleClass.fGui.spawn_accept, onVehicleAccpet )
							destroyElement(_vehicleClass.fGui.guiGridList1)
							destroyElement(_vehicleClass.fGui.spawn_accept )
						destroyElement(_vehicleClass.fGui.edit )
					removeEventHandler( "onClientRender", getRootElement(),r_VehicleSelector )
				destroyElement(  _vehicleClass.fGui.veh )
			_vehicleClass.fGui = {}
		guiSetInputMode ( "allow_binds" )
		dofSwitch( client_settings.dof.enable )
		dofUpdateSettings( client_settings.dof.dof_blur, client_settings.dof.dof_bri, client_settings.dof.dof_fades, client_settings.dof.dof_fadee, client_settings.dof.dof_briS, client_settings.dof.dof_skyb  )
end

function onVehicleAccpet()

	if source == _vehicleClass.fGui.edit then
		if guiGetText( source ) == "Search..." or  #guiGetText( source ) == guiEditGetCaretIndex ( source ) then
			guiSetText( source, '' )
		end
	else
	
		addEventHandler ( "onClientRender", getRootElement(), onRenderBar, false, "low" )
		_players[ localPlayer ]:updateStatus(  2, 2 )
		setElementDimension( localPlayer, 0 )
		
		removeEventHandler("onClientGUIChanged", _vehicleClass.fGui.edit, _vehicleSearch )
		removeEventHandler ( "onClientGUIClick", _vehicleClass.fGui.guiGridList1, onVehicleSelect )
		removeEventHandler ( "onClientGUIClick", _vehicleClass.fGui.spawn_accept, onVehicleAccpet )
		removeEventHandler ( "onClientGUIClick", _vehicleClass.fGui.edit, onVehicleAccpet )
		
		callServer("VehicleSelector_server",localPlayer,getElementModel( _vehicleClass.fGui.veh ), _vehicleClass.fGui.sx,_vehicleClass.fGui.sy,_vehicleClass.fGui.sz+ getElementDistanceFromCentreOfMassToBaseOfModel (  _vehicleClass.fGui.veh )+_vehicleClass.fGui.z_fix, _vehicleClass.fGui.no_w )
		sdasddsadsa(1000)

		local vehid = getVehicleType( _vehicleClass.fGui.veh )
		destroyElement(_vehicleClass.fGui.guiGridList1)
		destroyElement(_vehicleClass.fGui.spawn_accept )
		destroyElement(_vehicleClass.fGui.edit )	
		
		removeEventHandler( "onClientRender", getRootElement(),r_VehicleSelector )
		destroyElement(  _vehicleClass.fGui.veh )
		showCursor(false)
		
			if _vehicleClass.fGui.no_w == nil then
					onWeaponSelector()
			else
					showPlayerHudComponent( "radar", true )
			end
		_vehicleClass.fGui = {}
		
		if ( vehid == 'Plane' or vehid == 'Helicopter' ) and _on_waitForAction.data.lenght == nil then
		
				_on_waitForAction.getData ()
				addEventHandler( "onClientRender", getRootElement(), _on_waitForAction.render )
				bindKey ( 'accelerate', 'down', _on_waitForAction.pressKey )
				toggleControl( 'enter_exit', false )
				
		end
		
		guiSetInputMode ( "allow_binds" )
		dofSwitch( client_settings.dof.enable )
		dofUpdateSettings( client_settings.dof.dof_blur, client_settings.dof.dof_bri, client_settings.dof.dof_fades, client_settings.dof.dof_fadee, client_settings.dof.dof_briS, client_settings.dof.dof_skyb  )
	end	
end


function _on_waitForAction.render ()
	if not _players[ localPlayer ]:getStatus( 3 ) == 10 then
			dxDrawTextBaQ_c( "When you're ready, try to 'accelerate' \nyour vehicle. After this you will regain \ncontrol of the vehicle, so get ready!", _on_waitForAction.data.x ,_on_waitForAction.data.y,screenWidth, screenHeight, colors_g.white, 3, "default-bold",colors_g.black) 
	end
end





function _on_waitForAction.pressKey ()
	local veh = getPedOccupiedVehicle( localPlayer )
		if not veh then
			return 0;
		end	
	removeEventHandler( "onClientRender", getRootElement(), _on_waitForAction.render )
	unbindKey ( 'accelerate', 'down', _on_waitForAction.pressKey )
	toggleControl( 'enter_exit', true )
	setTimer( function() callServer( 'setElementFrozen', veh, false ) end, 100, 1 )
	_on_waitForAction.data = {}
		setTimer( function() 
			removeEventHandler('onClientRender', getRootElement(), _onFrameCollisionSet )
		end, 15000, 1 )
end

function r_preVehicleSelector()
	_vehicleClass.fGui.rot=_vehicleClass.fGui.rot+0.25
	local x1,y1,z1 =  getCamPos_cords_rot_dis(_vehicleClass.fGui[1],_vehicleClass.fGui[2],_vehicleClass.fGui[3],_vehicleClass.fGui.rot ,-10 )
		if getWaterLevel ( x1,y1,z1 + 6 ) == false then
			z1 = math.max ( z1 + getElementDistanceFromCentreOfMassToBaseOfModel (  _vehicleClass.fGui.veh ), getGroundPosition( x1,y1,z1 + 6 ) + ( getElementDistanceFromCentreOfMassToBaseOfModel (  _vehicleClass.fGui.veh )*2) )
		else
			z1 = math.max ( z1 + getElementDistanceFromCentreOfMassToBaseOfModel (  _vehicleClass.fGui.veh ), math.max(getWaterLevel( x1,y1,z1 + 6 )  ,getGroundPosition( x1,y1,z1 + 6 ) ) + ( getElementDistanceFromCentreOfMassToBaseOfModel (  _vehicleClass.fGui.veh )*2))
		end
	setCameraMatrix ( x1,y1,z1,_vehicleClass.fGui[1],_vehicleClass.fGui[2],_vehicleClass.fGui[3] )
	setElementVelocity (  _vehicleClass.fGui.veh, 0, 0, 0 )
		if getTickCount() > _vehicleClass.fGui.start then
			removeEventHandler( "onClientRender", getRootElement(),r_preVehicleSelector )
			addEventHandler( "onClientRender", getRootElement(),r_VehicleSelector )
		end
end

function r_VehicleSelector()
	_vehicleClass.fGui.rot = _vehicleClass.fGui.rot + 0.25
	local count = getTickCount()
	local box = {getElementBoundingBox ( _vehicleClass.fGui.veh )}
	if not box[1] then
		return
	end	
	local e_dis = ( math.min( math.max( 3.5,box[5] -box[2]),8 ) ) *-2
	local clear_ = {true}
	local x1, y1 ,z1 = 0, 0, 0
			while clear_[1] == true do
				x1, y1 ,z1 =  getCamPos_cords_rot_dis( _vehicleClass.fGui[1], _vehicleClass.fGui[2], _vehicleClass.fGui[3], _vehicleClass.fGui.rot, e_dis )
				z1 = z1 + ( getElementDistanceFromCentreOfMassToBaseOfModel (  _vehicleClass.fGui.veh ) * 2.5 )
				clear_ = {processLineOfSight ( _vehicleClass.fGui[1], _vehicleClass.fGui[2], _vehicleClass.fGui[3]+0.25, x1, y1, z1, true, false, false, true, false, false, false )}
				e_dis = e_dis + 0.15
					if getTickCount() - count > 50 then
						clear_[1] = false
					end
			end
	x1, y1 ,z1 =  getCamPos_cords_rot_dis( x1, y1 ,z1, _vehicleClass.fGui.rot, 0.5 )		
	
	setCameraMatrix ( ( x1 + _vehicleClass.fBuffer[1] )/2, ( y1 + _vehicleClass.fBuffer[2] )/2, ( z1 + _vehicleClass.fBuffer[3] )/2, ( _vehicleClass.fGui[1] + _vehicleClass.fBuffer[4] )/2, ( _vehicleClass.fGui[2] + _vehicleClass.fBuffer[5] )/2, ( _vehicleClass.fGui[3] + _vehicleClass.fBuffer[6] )/2 )
	_vehicleClass.fBuffer = { x1,y1,z1,_vehicleClass.fGui[1],_vehicleClass.fGui[2],_vehicleClass.fGui[3] }
	
		if _vehicleClass.inWater and ( getVehicleType( _vehicleClass.fGui.veh ) == 'Plane' or getVehicleType( _vehicleClass.fGui.veh ) == 'Helicopter' ) then
				setElementPosition( _vehicleClass.fGui.veh, _vehicleClass.fGui.sx,_vehicleClass.fGui.sy,_vehicleClass.fGui.sz + getElementDistanceFromCentreOfMassToBaseOfModel ( _vehicleClass.fGui.veh )*1.5 )
				setElementVelocity( _vehicleClass.fGui.veh, 0, 0, 0 )
		end
end


function createVehicleSelector( x, y, z, no_w )
	return _vehicleCreate( x, y, z, no_w )
end


local BarColors = {[1]={},[2]={}}
	for i=0,8 do
		local Hp = math.max((125*i)- 250, 0)/750
		local p = -510*(Hp^2)
		local r,g = math.max(math.min(p + 255*Hp + 255, 255), 0), math.max(math.min(p + 765*Hp, 255), 0)
		BarColors[1][i] = tocolor(r,g,0,50)
		BarColors[2][i] = tocolor(r,g,0,125)
	end
	
local v_render = {}
local bar_scale =  math.min(1, string.format("%.3f",scaleInt(480,0.4) ))




	local vehicle_dash = { m = scaleByWidth( 1920, 4.125 ), frame = scaleByWidth( 1920, 12 ), fontSize = scaleByWidth( 1920, 1 ), color = tocolor( 255, 255, 255 ) }
	vehicle_dash.bg = { x = screenWidth/4.8, y = screenHeight*0.85, w = scaleByWidth( 1920, 223 ), h = scaleByWidth( 1920, 29 )  }
	vehicle_dash.lay1 = { x = screenWidth/4.8 + vehicle_dash.frame/2, y = screenHeight*0.85 + vehicle_dash.frame/2, w = scaleByWidth( 1920, 211 ), h = scaleByWidth( 1920, 17 )  }
	vehicle_dash.text = { x = screenWidth/4.8 + vehicle_dash.bg.w/8, y = screenHeight*0.85 - vehicle_dash.bg.h*1.2 }
	vehicle_dash.onehp = vehicle_dash.lay1.w / 750
function renderPassager( v )
	if not iSscoreboard  and not blur_enabled then
		local hp = math.max( getElementHealth ( v ) - 250, 0 )
		local col = math.ceil( hp / 100 )
	
		dxDrawRectangle ( vehicle_dash.bg.x, vehicle_dash.bg.y, vehicle_dash.bg.w, vehicle_dash.bg.h,  tocolor ( 0, 0, 0, 125 ))
		dxDrawRectangle ( vehicle_dash.lay1.x, vehicle_dash.lay1.y, vehicle_dash.lay1.w, vehicle_dash.lay1.h,  BarColors[1][col])
		dxDrawRectangle ( vehicle_dash.lay1.x, vehicle_dash.lay1.y, vehicle_dash.onehp * hp, vehicle_dash.lay1.h,  BarColors[1][col])
		dxTextDrawShadow ( math.cut(getElementSpeed( v, 0 ))..' km/h', vehicle_dash.text.x, vehicle_dash.text.y , vehicle_dash.color, vehicle_dash.fontSize, 'bankgothic' )
	end
end



function onRenderBar( )
local _p_t_type = getPlayerTeam( localPlayer )
	if _p_t_type then
		_p_t_type = getElementData( _p_t_type,"t_type")
	end
	for k,v in pairs(v_render) do
		if getPedOccupiedVehicle( localPlayer ) == v then
			renderPassager( v )
			break;
		end	
	
		if isElement( v ) and isElementOnScreen ( v ) then
		local cX, cY, cZ = getCameraMatrix ( )
		local x, y, z = getElementPosition( v )
		if _p_t_type == "Defense" and getDistanceBetweenPoints2D( cX, cY,  x, y ) > 75 and not ( getPedTarget ( localPlayer ) == v ) then
			break
		end	
			if isLineOfSightClear ( cX, cY, cZ,  x, y, z, true, false, true, true, true, false, false, localPlayer ) then
				local box = {getElementBoundingBox ( v )}
				local w,s = getScreenFromWorldPosition (x, y, z+box[6] +math.abs(box[3] /2 ))
				if w ~= false then
					local Size = ( 75 /  math.max( 11, getDistanceBetweenPoints3D(cX, cY, cZ, x, y, z) ) ) *bar_scale
					w = w - ( 25  * Size )
					local Hp = math.max(getElementHealth ( v )- 250, 0)
					local col = math.ceil(Hp/100)
					dxDrawRectangle ( w,s, 54*Size, 7*Size,  tocolor ( 0, 0, 0, 125 ))
					dxDrawRectangle ( w+(Size),s+(1.75*Size), 52*Size, 3.5*Size, BarColors[1][col])
					dxDrawRectangle ( w+(Size),s+(1.75*Size),(5.2*(Hp/75))*Size, 3.5*Size,  BarColors[2][col])	
				end
			end	
		end
	end
end
addEventHandler ( "onClientRender", getRootElement(), onRenderBar, false, "low" )

function updateVehicle_r()
	if getElementType(source) == "vehicle" then
	setTimer(function() 
			v_render = {}
			for k,v in ipairs(getElementsByType ( "vehicle", getRootElement(), true )) do
				if not isVehicleBlown ( v ) then
					table.insert( v_render, v )
				end
			end
	end,50,1)
	end
end

addEventHandler( "onClientElementStreamIn", getRootElement( ), updateVehicle_r )
addEventHandler( "onClientElementStreamOut", getRootElement( ), updateVehicle_r )
addEventHandler( "onClientVehicleExplode", getRootElement( ), updateVehicle_r )
addEventHandler("onClientElementDestroy", getRootElement(), updateVehicle_r)


function vehicleChangeRequest( cmd, id )
	if getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] == "Base" then
					if _players[ localPlayer ]:getStatus( 2 ) ~= 2 then
						 outputChatBox ( "#FF0000[ERROR] #d5d5d5 First select the spawn, #FFFFFFafter this the vehicle selection will appear automatically.", 255, 255, 255, true )
						 return 0;
					end	
		local x,y = getElementPosition( localPlayer )
		if	isInsideRadarArea ( flashing_area, x, y ) == false then
			return outputChatBox ( "#FF0000[ERROR] #d5d5d5 Return to the flashing area to be able to use this command.", 255, 255, 255, true )
		end	
			if id == nil then
				showPlayerHudComponent( "radar", false )
				_vehicleCreate( vehicleCachefPos[1], vehicleCachefPos[2], vehicleCachefPos[3], true )
				return 
			end
		local match_id = tonumber( id )	
		for k,v in ipairs( client_settings_t.vehicles ) do	
			if v == match_id then
				return callServer( "VehicleSelector_server",localPlayer, match_id ,vehicleCachefPos[1], vehicleCachefPos[2], vehicleCachefPos[3] + 0.5 )
			end	
		end
		return outputChatBox ( "#FF0000[ERROR] #d5d5d5 No matching results or this id isn't on vehicle list able to select.", 255, 255, 255, true )
	end
end
addCommandHandler( "car", vehicleChangeRequest )



addEventHandler("onClientPlayerVehicleEnter", localPlayer, function ()
																setRadioChannel ( 0 )
															end )
																	
	_initialLoaded( "vehicle_selection.lua" )	

end