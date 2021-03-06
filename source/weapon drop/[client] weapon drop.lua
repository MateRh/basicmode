
_initialLoading[ "source/weapon drop/[client] weapon drop.lua" ] = function ( )



local _dropSystem = { }
local _dropSystemClass = {  toRemove = {} }
_dropSystemClass.handled = false

local wepons_models = {
	[16]=342,
	[17]=343,
	[18]=344,
	[22]=346,
	[23]=347,
	[24]=348,
	[25]=349,
	[26]=350,
	[27]=351,
	[28]=352,
	[29]=353,
	[30]=355,
	[31]=356,
	[33]=357,
	[34]=358,
}



function _dropSystemClass.dropWeapon( player, wpn )
	if wpn == false then
		return 0;
	end	
	local weapon = wpn or getPedWeapon( player )
		if not wepons_models[ weapon ] then
			return 0;
		end
	local ammo, ammoc, slot =  getPedTotalAmmo ( player ), getPedAmmoInClip ( player ), getSlotFromWeapon( weapon )
	local x, y, z = getPedBonePosition ( player, 25 )
	local x1, y1, z1 = getPedBonePosition ( player, 51 )
		local multipler = 2.5
			if isPedDucked( player ) then
				multipler = 1.25
			end
	local disnace = math.abs( getDistanceBetweenPoints3D( x, y, z, x1, y1, z1 ) ) *multipler
		
	x, y, z = getCamPos_cords_rot_dis( x, y, z, getPedRotation( player), 0.125 )
	local x1, y1, z1 = getCamPos_cords_rot_dis( x, y, z, getPedRotation( player), disnace  )
	z1 = getGroundPosition( x1, y1, z1 ) + 0.04
		if not isLineOfSightClear ( x, y, z, x1, y1, z1, true, true, true, true, true, true,  true, player ) then
			x1, y1, z1 = getCamPos_cords_rot_dis( x, y, z, getPedRotation( player), disnace/-2 )
			z1 = getGroundPosition( x1, y1, z1 ) + 0.04
		end

	local pickup = createObject ( wepons_models[ weapon ], x, y, z, 87, 0, getPedRotation( player) )
	local p_rot = getPedRotation( player)
	_dropSystem[ pickup ] = { }
	_dropSystem[ pickup ].object = pickup
	setElementCollisionsEnabled ( _dropSystem[ pickup ].object, false )
	_dropSystem[ pickup ].anim_end = getTickCount()
	_dropSystem[ pickup ].time = math.min( 600, math.max( math.round( ( disnace * 1000 ) - 250, 0 ), 100 ) )
	_dropSystem[ pickup ].rawPositions = { x, y, z, x1, y1, z1 }
		if player == localPlayer then
			setTimer( function() callServer( 'createDropPicukup', wepons_models[ weapon ], x1, y1, z1, p_rot, slot, ammo, ammoc ) end, _dropSystem[ pickup ].time +50, 1 )
		end
	if not _dropSystemClass.handled then
		_dropSystemClass.handled = true
		addEventHandler( 'onClientRender', getRootElement(), _dropSystemClass.renderAnimation, false, 'low-999' )
	end	
	
end
--bindKey( 'f', 'up', function() _dropSystemClass.dropWeapon( localPlayer ) end )

function isElementWithinMarker_ ( a, b )
	if a and b and isElement( a ) and isElement( b ) then
		return isElementWithinMarker ( a, b )
	end 
end



bindKey( 'f', 'both', function( k, s )
	if not isPedOnGround ( localPlayer ) or isPedInVehicle( localPlayer ) then
		_dropSystemClass.pressTime = nil
		return 0
	end	
	
		if not isElementWithinMarker_ ( localPlayer, _dropSystemClass.lastM ) then
			if s == 'down' then
				_dropSystemClass.pressTime = getTickCount() + 500
			elseif _dropSystemClass.pressTime and getTickCount() > _dropSystemClass.pressTime then
				_dropSystemClass.pressTime = nil
				_dropSystemClass.dropWeapon( localPlayer )
				callServer( 'takeWeapon', localPlayer, getPedWeapon ( localPlayer ) )
					setSoundVolume (  playSFX("script", 62, 9, false), 0.75 )
			else
				_dropSystemClass.pressTime = nil
			end
		end	
end )

function _dropSystemClass.renderAnimation( )

	for k, v in pairs( _dropSystem ) do 

		if ( getTickCount() - v.anim_end ) > v.time  then
			table.insert( _dropSystemClass.toRemove, v.object )
			_dropSystem[ k ] = nil
			if #_dropSystem == 0 then
				_dropSystemClass.handled = false
				return removeEventHandler( 'onClientRender', getRootElement(), _dropSystemClass.renderAnimation )
			end
		else 
		local x,y,z = interpolateBetween ( v.rawPositions[ 1 ],
										 v.rawPositions[ 2 ],
										 v.rawPositions[ 3 ],
										 v.rawPositions[ 4 ],
										 v.rawPositions[ 5 ],
										 v.rawPositions[ 6 ],
										( ( getTickCount() - v.anim_end )/v.time  ),
										--_dropSystem.anim_end,
										 'InQuad' )
		setElementPosition( v.object, x, y, z )
		end	
	end
end

--addEventHandler( 'onClientRender', getRootElement(), _dropSystemClass.renderAnimation, false, 'low-999' )

function isElementInTable( t, e )
	for k, v in pairs ( t ) do 
		if v == e then
			return true
		end	
	end
	return false
end


addEventHandler( "onClientElementStreamIn", getRootElement( ),
    function ( )
        if getElementType( source ) == "object" and isElementInTable( wepons_models, getElementModel( source ) ) then
			local x, y, z = getElementPosition( source ) 
			local id = getElementModel( source )
			for k, v in pairs( _dropSystemClass.toRemove ) do 
				if getElementModel( v ) == id then
					local x1, y1, z1 = getElementPosition( source ) 
					local distance = getDistanceBetweenPoints3D( x, y, z, x1, y1, z1 );
						if distance < 0.05 then
							destroyElement( v )
							setElementPosition( source, x1, y1, z1 )
							return table.remove( _dropSystemClass.toRemove, k )
						end
					
				end
			end
        end
    end
);




addEventHandler("onClientPlayerWasted", getRootElement(), function (killer, weapon, bodypart)

	if isElementStreamedIn( source ) then
		local x,y,z = getCameraMatrix()
			if getDistanceBetweenPoints3D( x,y,z, getElementPosition( source ) ) < math.min( 1000, getFarClipDistance () ) then
				_dropSystemClass.dropWeapon( source )
				
			end
	end

end)


_dropSystemClass.draw = { x = scaleIntPercent( screenWidth, 23 ), y = scaleIntPercent( screenHeight, 84 ), text = nil, w = 0, h = 0, size = math.min( 2, math.max( 1, string.format( "%.0f", scaleInt(480,1) ) ) ) }

	function _dropSystemClass.onRender( )
		dxDrawRectangle( _dropSystemClass.draw.x, _dropSystemClass.draw.y, _dropSystemClass.draw.w, _dropSystemClass.draw.h, _dropSystemClass.draw.color  )
		dxTextDrawShadow ( _dropSystemClass.draw.text, _dropSystemClass.draw.x, _dropSystemClass.draw.y, tocolor( 255, 255, 255 ), _dropSystemClass.draw.size, 'default',  _dropSystemClass.draw.size )
			if getKeyState( 'f' ) then
			
			local pW_d = getElementData( _dropSystemClass.lastM, 'pWeapon' )
				_dropSystemClass.dropWeapon( localPlayer, getPedWeapon ( localPlayer,  getSlotFromWeapon (  pW_d[1] ) ) ) 
				callServer( 'pickupTheWeapon', localPlayer, _dropSystemClass.lastM, unpack( pW_d ) )
					removeEventHandler( 'onClientRender', getRootElement(), _dropSystemClass.onRender )
					removeEventHandler ( "onClientMarkerLeave", _dropSystemClass.lastM,  _dropSystemClass.markerLeave )
					_dropSystemClass.draw.text = nil
					setSoundVolume (  playSFX("script", 62, 10, false), 0.5 )
			end	
	
	end

function MarkerHit ( hitPlayer, matchingDimension )

		if hitPlayer ~= localPlayer or isPedDead( hitPlayer ) or isPedInVehicle( hitPlayer ) then
			return 0
		end	
		if not getElementData( source, 'pWeapon' ) then
			return false
		end	
		
		
	local before = _dropSystemClass.draw.text 
	_dropSystemClass.lastM = source
	_dropSystemClass.draw.text = ' Press F to pickup weapon, Hold F to grab the ammo.'
	_dropSystemClass.draw.w, _dropSystemClass.draw.h = dxGetTextWidth( 	_dropSystemClass.draw.text, _dropSystemClass.draw.size ), dxGetFontHeight( _dropSystemClass.draw.size )
	local r, g, b = getMarkerColor( source )
	_dropSystemClass.draw.color = tocolor( r, g, b, 100 )
		if before == nil then
			addEventHandler( 'onClientRender', getRootElement(), _dropSystemClass.onRender )
		end	
		addEventHandler ( "onClientMarkerLeave", source,  _dropSystemClass.markerLeave )
end
addEventHandler ( "onClientMarkerHit", getRootElement(), MarkerHit )


function _dropSystemClass.markerLeave( hitPlayer )

		if hitPlayer ~= localPlayer then
			return 0
		end	
	
	removeEventHandler( 'onClientRender', getRootElement(), _dropSystemClass.onRender )
	removeEventHandler ( "onClientMarkerLeave", source,  _dropSystemClass.markerLeave )
	_dropSystemClass.draw.text = nil
end

	_initialLoaded( "source/weapon drop/[client] weapon drop.lua" )	

end