--[[
local usedLODModels = {}

function onResourceStartOrStop ( res )
	if res ~= getThisResource() and getResourceInfo ( res, "type" ) == "map" then
		for _, object in ipairs ( getElementsByType ( "removeWorldObject", source ) ) do
			local model = getElementData ( object, "model" )
			local lodModel = getElementData ( object, "lodModel" )
			local posX = getElementData ( object, "posX" )
			local posY = getElementData ( object, "posY" )
			local posZ = getElementData ( object, "posZ" )
			local interior = getElementData ( object, "interior" )
			local radius = getElementData ( object, "radius" )
			if ( eventName == "onResourceStart" ) then
				removeWorldModel ( model, radius, posX, posY, posZ, interior )
				removeWorldModel ( lodModel, radius, posX, posY, posZ, interior )
			else
				restoreWorldModel ( model, radius, posX, posY, posZ, interior )
				restoreWorldModel ( lodModel, radius, posX, posY, posZ, interior )
			end
		end
	end	
end
addEventHandler ( "onResourceStart", getRootElement(), onResourceStartOrStop )
addEventHandler ( "onResourceStop", getRootElement(), onResourceStartOrStop )]]
