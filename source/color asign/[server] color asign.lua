colors_scheme = {
		{ 255, 25, 25 },
		{ 0, 255, 0 },
		{ 0, 0, 255 },
		{ 255, 255, 0 },
		{ 0, 255, 255 },
		{ 255, 0, 255 },
		{ 192,192,192 },
		{ 128,0,0 },
		{ 128,128,0 },
		{ 0,128,0 },
		{ 128,0,128 },
		{ 0,128,128 },
		{ 0,0,128 },
		{ 220,20,60 },
		{ 255,140,0 },
		{ 184,134,11 },
		{ 128,128,0 },
		{ 154,205,50 },
		{ 0,100,0 },
		{ 0,100,0 },
		{ 32,178,170 },
		{ 100,149,237 },
		{ 135,206,250 },
		{ 75,0,130 },
		{ 255,105,180 },
		{ 245,245,220 },
		{ 112,128,144 },
		{ 240,255,240 }
	}

function oppositiveTeam( team )
	if team == team1 then
		return team2
	else
		return team1
	end		
end	



local assigned_colors = { [ team1 ] = {}, [ team2 ] = {} }


	local setPlayerTeam_ = setPlayerTeam

	function setPlayerTeam( player, team )
			onTeamJoin( player, team, getPlayerTeam( player ) )
		return setPlayerTeam_ ( player, team )
	end	

	function debugOutput( ... )
		print( table.concat({ ... }, ", ") )
	end	



function onTeamJoin( player, team, lastteam )

	debugOutput( tostring( player ), tostring( getElementData( player, '#c' ) ), tostring( assigned_colors[ team ][ getElementData( player, '#c' ) ] ), tostring( team ), tostring( lastteam ) )
	if getElementData( player, '#c' ) and team ~= nil and team == lastteam then
		return 0
	end	
		if team == team3 then
			return 0
		end	

	if getElementData( player, '#c' ) and  assigned_colors[ team ][ getElementData( player, '#c' ) ] == nil then
		if lastteam and lastteam ~= team3 then
			assigned_colors[ lastteam ][ getElementData( player, '#c' ) ] = nil
		end	
		assigned_colors[ team ][ getElementData( player, '#c' ) ] = player

		return 0
	elseif getElementData( player, '#c' )   then
		print( 'save the world' )	
	end	

	for k, v in ipairs ( colors_scheme ) do 
		if not assigned_colors[ team ][ k ]  then
			if lastteam then
				assigned_colors[ lastteam ][ k ] = nil
			end	
			assigned_colors[ team ][ k ] = player
			setElementData( player, '#c', k )
			return 0
		end	

	end	

end	


addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), 
    function ( resource )
	local players = getElementsByType ( "player" ) 
		for k, v in pairs( players ) do 
			removeElementData( v, '#c' )
		end
		assigned_colors = { [ team1 ] = {}, [ team2 ] = {} }
   end 
)

addEventHandler ( "onPlayerQuit", getRootElement(), function (  )
	local v = source
	if getElementData( v, '#c' ) then
		if assigned_colors[ getPlayerTeam( v ) ][ getElementData( v, '#c' ) ] then
			assigned_colors[ getPlayerTeam( v ) ][ getElementData( v, '#c' ) ] = nil
		end	
		removeElementData( v, '#c' )
	end
end )