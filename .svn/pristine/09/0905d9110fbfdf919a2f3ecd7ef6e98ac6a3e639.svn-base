

local color_fromSlot = {
	[2] = { r = 255, g = 240, b = 0 },
	[3] = { r = 0, g = 190, b = 40 },
	[4] = { r = 225, g = 125, b = 0 },
	[5] = { r = 255, g = 25, b = 25 },
	[6] = { r = 0, g = 72, b = 255 },
	[7] = { r = 25, g = 25, b = 25 },
	[8] = { r = 165, g = 0, b = 255 }
}
	
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
	
	function getIDFromModel( model )
		for k, v in pairs( wepons_models ) do 
			if v == model then
				return k
			end	
		
		end
	return false;
	end
	

	function createDropPicukup ( id, x, y, z, rot, slot, ammo, ammoc )
	
	local object = createObject ( id, x, y, z, 87, 0, rot )
	setElementCollisionsEnabled ( object, false )
	 local marker = createMarker ( x, y, z+0.25 + math.random( 0.0500, 0.1005 ) , "corona", 1.3, color_fromSlot[ slot ].r or 255, color_fromSlot[ slot ].g or 255, color_fromSlot[ slot ].b or 255, 12.5, getRootElement() )
		setElementData( marker, 'pWeapon', { getIDFromModel( id ), ammo , ammoc } ) 
		 attachElements ( marker, object )
		 setElementParent( object, marker )
	end
	
	
	function pickupTheWeapon( player, marker, id, ammo, ammoc )
		
		takeWeapon( player, getPedWeapon ( player, getSlotFromWeapon ( id ) ) )
		giveWeapon( player, id, ammo, true )
		setWeaponAmmo ( player, id, ammo, ammoc )
		destroyElement( marker )
	
	end
	
	
	function destroyAllWeaponPickups( )
		for k, v in pairs( getElementsByType( 'marker' ) ) do 
			if type( getElementData( v, 'pWeapon' ) ) == 'table' then
				destroyElement( v )
			end	
		end
	end

	