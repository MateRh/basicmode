_initialLoading[ "extensions/bounds_c.lua" ] = function ( )


	local _t = { bounds = {}, bounds_r = {}, ground_position = 999,ground_position_m = -999, color = tocolor( 125, 176, 212, 140 ) }

	function bringBoundSystem( )
	local round_type = getElementData(getElementByIndex ( "root_gm_element",0 ),"map_info")
		if  round_type[1] == "Arena" then
			local map_root = getResourceRootElement ( getResourceFromName( string.lower( round_type[1] ).."_"..round_type[2] ))
			local bounds_e = getElementsByType ( "Anti_Rush_Point", map_root )
				if not bounds_e or #bounds_e < 2 then
					return 0
				end		
				if #bounds_e == 2 then --// if someone don't know how make rush bounds
				
						table.insert( _t.bounds,  getElementData( bounds_e[1], "posX")  )
						table.insert( _t.bounds,  getElementData( bounds_e[1], "posY") )	
						
						table.insert( _t.bounds,  getElementData( bounds_e[2], "posX")  )
						table.insert( _t.bounds,  getElementData( bounds_e[1], "posY") )	
						table.insert( _t.bounds_r , { _t.bounds[1], _t.bounds[2], _t.bounds[3], _t.bounds[4],   } )
						
						table.insert( _t.bounds,  getElementData( bounds_e[2], "posX")  )
						table.insert( _t.bounds,  getElementData( bounds_e[2], "posY") )	
						table.insert( _t.bounds_r , { _t.bounds[3], _t.bounds[4], _t.bounds[5], _t.bounds[6],   } )
						
						table.insert( _t.bounds,  getElementData( bounds_e[1], "posX")  )
						table.insert( _t.bounds,  getElementData( bounds_e[2], "posY") )
						table.insert( _t.bounds_r , { _t.bounds[5], _t.bounds[6], _t.bounds[7], _t.bounds[8],   } )
						table.insert( _t.bounds_r , { _t.bounds[7], _t.bounds[8], _t.bounds[1], _t.bounds[2],   } )
						_t.ground_position = math.min ( _t.ground_position,  getElementData( bounds_e[1], "posZ") ) 
						_t.ground_position_m = math.max ( _t.ground_position_m,  getElementData( bounds_e[1], "posZ") ) 
						
				else
					for _, point in ipairs(  bounds_e ) do
						table.insert( _t.bounds,  getElementData( point, "posX")  )
						table.insert( _t.bounds,  getElementData( point, "posY") )
						_t.ground_position = math.min ( _t.ground_position,  getElementData( point, "posZ") ) 
						_t.ground_position_m = math.max ( _t.ground_position_m,  getElementData( point, "posZ") ) 
						table.insert( _t.bounds_r , { getElementData( point, "posX"), getElementData( point, "posY"), getElementData( bounds_e[_+1] or bounds_e[1], "posX"), getElementData( bounds_e[_+1] or bounds_e[1], "posY"),   } )
					end
				end	
					table.insert( _t.bounds, _t.bounds[1] )
					table.insert( _t.bounds,  _t.bounds[2] )
			_t.bound_s = math.max( 15,  10 + 	(_t.ground_position_m - _t.ground_position) )
			_t.texture = dxCreateTexture("img/bound.png", "dxt1", false)		
			_t.polygon = createColPolygon ( unpack(_t.bounds)  )
			addEventHandler( "onClientRender", getRootElement(), drawWorldBounds, false, 'low' )
			addEventHandler("onClientColShapeLeave",_t.polygon, collshapeLeave)
		else
			return
		end
	end
	
	function disableBoundSystem( )
		if not isElement( _t.texture ) or not isElement( _t.polygon ) then
			return 0;
		end
		removeEventHandler( "onClientRender", getRootElement(), drawWorldBounds )

		if type( _t.render_data ) == "table" then
			collshapeBack( localPlayer )
		end	
		destroyElement( _t.texture )
		destroyElement( _t.polygon )
		 _t = { bounds = {}, bounds_r = {}, ground_position = 999,ground_position_m = -999, color = tocolor( 60, 105, 160, 125 ) }
	end
	

	function drawWorldBounds( )
		for _, data in pairs( _t.bounds_r ) do

				dxDrawMaterialLine3D ( data[1],  data[2], _t.ground_position,  data[3],  data[4], _t.ground_position, _t.texture, _t.bound_s, _t.color , 0, 0, _t.ground_position )

		end
	end
	
	function collshapeLeave( element )
		if element ~= localPlayer then return false end
			if _players[ localPlayer ]:getStatus( 3 ) == 8 then
				return false
			end
		createColorCorrectionShader( 0.25 )     
		addEventHandler("onClientColShapeHit",_t.polygon,collshapeBack)
		local screenWidth, screenHeight  = guiGetScreenSize ( )
		_t.render_data = {size=math.round(math.min(1.6,math.max(scaleInt(900,1.0),0.7)),1),pos={getScreenPositionByRelative(0.2,0.35)},count=3}
		_t.render_data.text = "\
	                    Turn back!\n\
	Or you will be annihilated in ".. _t.render_data.count .." seconds."
		_t.render_data.pos[1] = (screenWidth - dxGetTextWidth ( "Or you will be annihilated in 3 seconds.", _t.render_data.size,  "bankgothic" ))/2
		_t.render_data.timers = {setTimer(function() _t.render_data.count = _t.render_data.count-1 _t.render_data.text = "\
	                    Turn back!\n\
	Or you will be annihilated in ".. _t.render_data.count .." seconds." for i=1, 10 do playSoundFrontEnd ( 101 ) end  end,1000,2), setTimer( function()  setPedOnFire( localPlayer, true ) _t.render_data.text = "\n\n\n\n\n\n\n\n	                    Annihilation" _t.render_data.timers[2] = setTimer( setPedOnFire, 100, 0, localPlayer, true )  end,3100,1)}
		addEventHandler("onClientRender", getRootElement(), render_b )
	end
	
	function collshapeBack( element )
		if element ~= localPlayer then return false end
		removeEventHandler("onClientRender", getRootElement(), render_b )
		removeEventHandler("onClientColShapeHit",_t.polygon,collshapeBack)
		disableColorCorrectionShader(  )  
		if isTimer( _t.render_data.timers[1] ) then killTimer( _t.render_data.timers[1] ) end
		if isTimer( _t.render_data.timers[2] ) then killTimer( _t.render_data.timers[2] ) end
		setPedOnFire( localPlayer, false )
	end
	
	function burnThisBitch( )
	
		setPedOnFire( localPlayer, true )
	
	end

	function dxDrawTextBaQ_c ( text, l, t ,r, c, color, scale, font, color2, alginX )
	alginX = alginX or 'left'
		dxDrawText(text, l+2, t, 0, 0, color2,  scale, font, alginX )
			dxDrawText(text, l-2, t, 0, 0,  color2,  scale, font, alginX )
				dxDrawText(text, l, t+2, 0, 0, color2,  scale, font, alginX )
					dxDrawText(text, l, t-2, 0, 0,  color2,  scale, font, alginX )	
						dxDrawText(text, l-1, t+1, 0, 0, color2,  scale, font, alginX )
					dxDrawText(text, l+1, t+1, 0, 0, color2,  scale, font, alginX )
				dxDrawText(text, l-1, t-1, 0, 0, color2,  scale, font, alginX )
			dxDrawText(text, l+1, t-1, 0, 0, color2,  scale, font, alginX )
		dxDrawText ( text, l, t ,r, c, color, scale, font, alginX)
	end	
	
	function dxDrawTextOutlineWcolor ( text, l, t ,r, c, color, scale, font, color2, alginX, colored )
	alginX = alginX or 'left'
		dxDrawText(text, l+2, t, 0, 0, color2,  scale, font, alginX )
			dxDrawText(text, l-2, t, 0, 0,  color2,  scale, font, alginX )
				dxDrawText(text, l, t+2, 0, 0, color2,  scale, font, alginX )
					dxDrawText(text, l, t-2, 0, 0,  color2,  scale, font, alginX )	
						dxDrawText(text, l-1, t+1, 0, 0, color2,  scale, font, alginX )
					dxDrawText(text, l+1, t+1, 0, 0, color2,  scale, font, alginX )
				dxDrawText(text, l-1, t-1, 0, 0, color2,  scale, font, alginX )
			dxDrawText(text, l+1, t-1, 0, 0, color2,  scale, font, alginX )
		dxDrawText ( colored, l, t ,r, c, color, scale, font, alginX, "top", false, false, false, true )
	end
	
	
	function render_b()
		dxDrawTextBaQ_c( _t.render_data.text, _t.render_data.pos[1], _t.render_data.pos[2],screenWidth, screenHeight, colors_g.lblue, _t.render_data.size,  "bankgothic",colors_g.black) 
			if isElementInWater ( localPlayer ) then
				setElementHealth( localPlayer, math.max( 0, getElementHealth( localPlayer ) -0.15) )
				if getPedOxygenLevel ( localPlayer ) > 200 then
					setPedOxygenLevel ( localPlayer, 200 )	
				end
			end
	
	end


	_initialLoaded( "extensions/bounds_c.lua" )	

end