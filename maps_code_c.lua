
_initialLoading[ "maps_code_c.lua" ] = function ( )

local current_option = -1
function switchCollisionMode( v, col, option )
local again = false
	if current_option == option then
		again = true
	--	return
	end
	current_option = option
	if option == 0 then     -- on
		for _, vehicle in pairs( getElementsWithinColShape ( col, "vehicle" ) ) do 
			setElementCollidableWith(vehicle, v, false) 
		end
		if again == false then
			addEventHandler( "onClientElementStreamIn", getRootElement( ), onStreamCollisionMode )
		end	
	elseif option == 1 then -- off
	removeEventHandler( "onClientElementStreamIn", getRootElement( ), onStreamCollisionMode )
		for _, vehicle in pairs(getElementsByType("vehicle")) do 
			setElementCollidableWith(vehicle, v, true) 
		end
		current_option = -1
	end
end

function onStreamCollisionMode( )
	if getElementType( source ) == "vehicle" and getPedOccupiedVehicle( localPlayer ) then
		setElementCollidableWith(source, getPedOccupiedVehicle( localPlayer ), false) 
	end
end



	_initialLoaded( "maps_code_c.lua" )	

end