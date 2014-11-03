local base_mode = { capture = { type='intermittent', limit=0 } }

	function synchronizeBaseSettings( settings )
		base_mode.capture = settings
		base_mode.capture.start = false
		base_mode.capture.state = false
	--	base_mode.player = false
	end
	
	function onBaseMarkerEnter( player )
		if getElementType( player ) == "player" and not isPedInVehicle (player )  then
			local team = getPlayerTeam( player )
				if  getElementData(team,"t_type") == "Attack" then
					if base_mode.capture.state == false then
					
						if base_mode.capture.type == 'intermittent' or base_mode.capture.start == false then
							base_mode.capture.start = getTickCount()
							base_mode.capture.finish = ( base_mode.capture.start - 1 ) + ( base_mode.capture.limit * 1000 ) 
		
						elseif base_mode.capture.type == 'with continuation' then
							local difference =  getTickCount() - base_mode.capture.last
							base_mode.capture.start = base_mode.capture.start + difference 
							base_mode.capture.finish = base_mode.capture.finish + difference 
						end	
						base_mode.capture.state = true
						callClient(getRootElement(),  "beginCaptureAnim",base_mode.capture.limit,base_mode.capture.type)
						base_mode.capture.timer = setTimer( onBaseTimer, 100, 0 )
						base_mode.player = player
						
					end
				end
		end	
	end
	
	function onBaseTimer ( )
		local tickcount = getTickCount()
		if tickcount > base_mode.capture.finish then
			setElementData( base_mode.player, "Score", ( getElementData( base_mode.player, "Score" ) or 0 ) + 150 ) 
			killTimer ( base_mode.capture.timer )
			
				finishRound( getTeamByType( "Attack" ), getTeamByType( "Defense" ), "Base has been captured by: "..getPlayerName( base_mode.player) )
					
				
			base_mode.capture.start = false
			base_mode.capture.state = false
			base_mode.player = false
			killTimer ( countdown_data_timer )

		end
	end
	
	
	
	function onBaseMarkerLeft( player )
		if getElementType( player ) == "player" and base_mode.player == player  then
			if base_mode.capture.state ~= false then
				callClient(getRootElement(),  "stopCaptureAnim")
				base_mode.capture.state =  false
				base_mode.capture.last = getTickCount()
				killTimer ( base_mode.capture.timer )
				base_mode.player = false
			end
		end	
	end
	function onBaseMarkerLeftDead(  )
		if source == base_mode.player then
			onBaseMarkerLeft( source )
		end
	end
	addEventHandler ( "onPlayerWasted", getRootElement(), onBaseMarkerLeftDead ) 
	
	function onBaseForceLeft( )
		if isElement( base_mode.player ) then
			onBaseMarkerLeft( base_mode.player  )
		end	
	end	


	
