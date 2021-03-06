
_initialLoading[ "extensions/interiors_client.lua" ] = function ( )

local _interiors = { in_zone = false, _markers = {}, _markers_Z = {}, targets = {}, players = {}, zones = {} }

	function bringInteriorsSystem(  res )
		local map_root = getResourceRootElement ( res )
		local int_e = getElementsByType ( "Int", map_root )
				if not int_e or #int_e < 2 then
					return 0
				end		
			for _, element in ipairs(  int_e ) do
				local _aditional_z = 1.75
					--if tonumber( getElementData( element, "interior") ) == 0 then
				--		_aditional_z = 1.6
				--	end	
			
				local _mZ = createMarker ( getElementData( element, "posX"), getElementData( element, "posY"), getElementData( element, "posZ")+_aditional_z, "arrow", 1.4, 255, 225, 0, 200 )
				local _m = createMarker ( getElementData( element, "posX"), getElementData( element, "posY"), getElementData( element, "posZ")+0.05, "cylinder", 0.75, 255, 225, 0, 0 )
				table.insert( _interiors._markers, _m  )

				_interiors._markers_Z[ _mZ ] = { getElementData( element, "posZ")+_aditional_z, 0.003 }
				setElementInterior( _m, getElementData( element, "interior"), getElementData( element, "posX"), getElementData( element, "posY"), getElementData( element, "posZ") )
				setElementInterior( _mZ, getElementData( element, "interior"), getElementData( element, "posX"), getElementData( element, "posY"), getElementData( element, "posZ")+_aditional_z )
					local _t_element = getElementByID( getElementData( element, "target") )
				_interiors.targets[ _m ] = {  getElementData( _t_element, "posX"), getElementData( _t_element, "posY"), getElementData( _t_element, "posZ") , getElementData( _t_element, "interior"), getElementData( _t_element, "target_rotation") }

			end
			
		
		addEventHandler( "onClientMarkerHit", getRootElement(), _onInteriorMarkerHit )
		
		local forzone_e = getElementsByType ( "forbidden_zone", map_root )
				if not forzone_e or #forzone_e < 3 then
					return 0
				end	
			for _, element in ipairs(  forzone_e ) do
				local _id = tonumber( getElementData( element, "GroupID") )
			
						
					if not _interiors.zones[ _id ]  then
						_interiors.zones[ _id ] = { positions = { getElementData( element, "posX"), getElementData( element, "posY") }, action = getElementData( element, "Action"), team = getElementData( element, "Team"), z_min = tonumber( getElementData( element, "posZ") ),z_max = tonumber( getElementData( element, "posZ") ) + tonumber( getElementData( element, "High") ), interior = tonumber( getElementData( element, "interior") ) }
					end	
				table.insert( _interiors.zones[ _id ].positions, getElementData( element, "posX") )
				table.insert( _interiors.zones[ _id ].positions, getElementData( element, "posY") )
			end
			
			for _, v in ipairs(  _interiors.zones ) do
				_interiors.zones[ _ ].polygon = createColPolygon( unpack( v.positions ) )
				addEventHandler( "onClientColShapeHit", _interiors.zones[ _ ].polygon, onEnterForbiddenZone )
				addEventHandler( "onClientColShapeLeave", _interiors.zones[ _ ].polygon, onExitForbiddenZone )
			end
				
			addEventHandler( 'onClientRender', getRootElement(), markers_anim, false, 'low-999' )											
	end	
	
	function destroyInteriorsSystem(  )
	
		if #_interiors._markers == 0  and #_interiors.zones == 0 then
			return 0;
		end	

			for _, element in ipairs(  _interiors._markers ) do
				destroyElement( element )
			end	

			for _, element in ipairs(  getElementsByType( 'marker', getResourceDynamicElementRoot (  getThisResource() ) ) ) do
				if isElementLocal( element ) and getMarkerType( element ) == "arrow" then
					destroyElement( element )
				end
			end
			
		
		removeEventHandler( "onClientMarkerHit", getRootElement(), _onInteriorMarkerHit )
		removeEventHandler( 'onClientRender', getRootElement(), markers_anim )

			for _, v in ipairs(  _interiors.zones ) do
				removeEventHandler( "onClientColShapeHit", v.polygon, onEnterForbiddenZone )
				removeEventHandler( "onClientColShapeLeave", v.polygon, onExitForbiddenZone )
				destroyElement( v.polygon  )
			end
			if _interiors.in_zone then
				removeEventHandler('onClientRender', getRootElement(), _onFrameForbideenZone )
				toggleControl( 'fire', true )
			end
			
			_interiors = nil
			_interiors = { in_zone = false, _markers = {}, _markers_Z = {}, targets = {}, players = {}, zones = {} }	
														
	end
	
		function onEnterForbiddenZone ( theElement )
			if theElement ~= localPlayer then
				return 0;
			end
			
			for _, v in ipairs(  _interiors.zones ) do
				if v.polygon == source then
					if getElementInterior( localPlayer ) ~= v.interior then
						return 0;
					end	
					if getTeamByType( v.team ) ~= getPlayerTeam( localPlayer ) then
						return 0;
					end	
						local x, y, z = getElementPosition( localPlayer )
							if z > v.z_min and z < v.z_max then
								addEventHandler('onClientRender', getRootElement(), _onFrameForbideenZone )
								toggleControl( 'fire', false )
								_interiors.in_zone = true
							else
							
							end
					return 0;
				end
			end	
		end	

		function onExitForbiddenZone ( theElement )
			if theElement ~= localPlayer or _interiors.in_zone == false then
				return 0;
			end
			
			for _, v in ipairs(  _interiors.zones ) do
				removeEventHandler('onClientRender', getRootElement(), _onFrameForbideenZone )
				toggleControl( 'fire', true )
				_interiors.in_zone = false
				return 0;
			end		
		end
		
		local _textFF = "You're in forbideen zone for your team! \nYou cannot use weapons here, \nbut this dosen't mean the oppositive \nteam also cannot use weapons here. \nSo you stay here on your own RISK!"
		function _onFrameForbideenZone( )
			local _flo = math.random( - 25, 25 )
			dxTextDrawShadow ( _textFF, (screenWidth - dxGetTextWidth (  _textFF , 2, "default-bold" ))/2, screenHeight*0.65, tocolor( 255, 50+_flo , 50+_flo  ), 2, "default-bold" )
		end
	
	
	function _onInteriorMarkerHit( hitE )
	if hitE ~= localPlayer then
		return 0;
	end	
		local marker = source
		for _, v in ipairs(  _interiors._markers ) do	
			if v == marker then
				local x,y,z = getElementPosition( v )
				local x1,y1,z1 = getElementPosition( localPlayer )
				if getDistanceBetweenPoints3D( x,y,z, x,y,z1 ) > 2 then --// zfix
					return 0;
				end	
			
			--[[		if _interiors.players[ hitE ] then
						_interiors.players[ hitE ] = nil
					else]]
						sdasddsadsa( 200 )
						_interiors.players[ hitE ] = true
							if tonumber( _interiors.targets[ v ] [ 4 ] ) == 0 then
								resetSkyGradient()
							else
								setSkyGradient( 0, 0, 0, 0, 0, 0 )
							end	
							local x, y, z = _interiors.targets[ v ] [ 1 ], _interiors.targets[ v ] [ 2 ], _interiors.targets[ v ] [ 3 ]
							x, y, z = getCamPos_cords_rot_dis( x,y,z, _interiors.targets[ v ] [ 5 ] , 2 )	
					callServer( "_setElementInteriorWithRot", localPlayer, x, y, z+0.3, _interiors.targets[ v ] [ 4 ], _interiors.targets[ v ] [ 5 ] )
				--	end
				return 0;
			end
		end
	end	
	
	
	
--14485
--14417
--14389
--13724

	local _value_m = 0.05
	
	
	
		function markers_anim()
			
			
			for _, v in ipairs( getElementsByType ( "marker", getRootElement(), true ) ) do	
				if getMarkerType ( v ) == "arrow" then
					local x,y,z = getElementPosition( v )
					local difference = math.abs( z ) - math.abs( _interiors._markers_Z[ v ][1] )

						if difference > 0.1 and _interiors._markers_Z[ v ][2] == 0.003 then
							_interiors._markers_Z[ v ][2] = -0.003
						elseif difference < -0.1 and _interiors._markers_Z[ v ][2] == -0.003 then
							_interiors._markers_Z[ v ][2] = 0.003
						end
						setElementPosition( v, x, y, z + _interiors._markers_Z[ v ][2]  )
				end
			end
		end
		
		

		_initialLoaded( "extensions/interiors_client.lua" )	

end	