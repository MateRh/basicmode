	local id_assigned = {} 

	function return_unassigned_id()
		local i = 0
		while id_assigned[i] ~= nil do
			i = i +1
		end
		return i
	end
	
	function setPlayerID(v)
		local id = return_unassigned_id()
			id_assigned[ id ] = v
		setElementData ( v, "ID", id )
	end
	
	function getPlayerID(v)
		return getElementData( v, "ID" ) or false
	end
	
	function getPlayerByID(id)
		return id_assigned[id] or false
	end
	
	function removePlayerID(v)
		local id = getPlayerID(v)
			 id_assigned[id] = nil
		removeElementData(v,"ID")
	end
	
	addEventHandler ( "onPlayerJoin", getRootElement(), function () setPlayerID( source ) end )
	addEventHandler ( "onPlayerQuit", getRootElement(), function () removePlayerID( source ) end )
	
	
		for k, v in ipairs( getElementsByType ( "player" )  ) do 
			setPlayerID( v )
		end