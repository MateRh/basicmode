	local round_history = { }
	local locked_check = false
	function finishRound( winner, losser, reson )
		
	
		if winner == false or losser == false then
			callClient(getRootElement(),  "finishRoundAnimation",  false, false, reson, {}, true)
		else	
			local round_type = getElementData(global_element,"map_info")
			table.insert( round_history, { round_type[1]..": "..round_type[2], getTeamName( winner ).." ( ".. string.sub( getElementData( winner, "t_type" ), 1, 3 ) .. " )", getTeamName( losser ).." ( ".. string.sub( getElementData( losser, "t_type" ), 1, 3 ) .. " )",(getElementData( winner, "Score" )+1).." - "..getElementData( losser, "Score" ), "czas", reson } )
			callClient(getRootElement(),  "finishRoundAnimation",  winner, losser, reson, round_history, false)
		end
			if pause == true then
				pause = false
				round_paused  = false
				setGameSpeed( 1 )
			--	for k, v in pairs( getElementsByType ( 'player' ) ) do 
				--	toggleAllControls( v, true )
				--	setElementFrozen( v, false )
		--		end
				for k, v in pairs( getElementsByType ( 'vehicle' ) ) do 
					setElementFrozen( v, false )
				end
				pause = 0
			end	
				for k, v in pairs( getElementsByType ( 'player' ) ) do 
					if isElement( blips.game[ v ]  ) then
						destroyElement( blips.game[ v ]  )
						blips.game[ v ] = nil
					end	
				end	
			for k, v in pairs( getElementsByType ( 'player' ) ) do 
				setElementFrozen( v, true )
				toggleAllControls( v, false, true, false )
			end

		setElementData( team1, "p_count", 0 )
		setElementData( team2, "p_count", 0 )
		setElementData( team1, "Health", nil )
		setElementData( team2, "Health", nil )
		onBaseForceLeft( )
		setTimer( finishRound_cd, 3500, 1, winner )
		setTimer( function() 
		destroyElement ( map_root_element )
		stopResource( actually_map ) 
				end, 250, 1 )
		_explosionOverlay = {}	
	end

	function finishRound_cd( winner )
		setElementData(global_element,"map_info",{"Lobby",""})
		if winner ~= false then setElementData( winner, "Score", getElementData( winner, "Score" ) + 1 ) end
		updateBrowserInfo (  )
		local current_sides = { getElementData(team1,"t_type"), getElementData(team2,"t_type") }
		setElementData(team1,"t_type", tostring( current_sides[2]) , true )
		setElementData(team2,"t_type", tostring(current_sides[1]), true )
		callClient( getRootElement(), "updateSides")
		locked_check = false
		
		removeWorldModel ( 7023, 25.68047, 2501.5156, 2781.2891, 9.82031)
		removeWorldModel ( 7172, 41.4114, 2546.0313, 2828.7344, 11.53906 )
		removeWorldModel ( 986, 7.4280729, 2497.6001, 2767.4355, 14.64366 )
		removeWorldModel ( 985, 7.3802581, 2775.1453, 2767.4355, 12.52567 )
		destroyAllWeaponPickups( )
	end

	function endRoundCommand(player)
		local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
		if r_type == "Lobby" then
			return 
		end	
		if isAdmin( player ) == false then
			return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 You're not admin.", player, 255, 255, 255, true )
		end
		if getTickCount() < gGlobalTime_ then
			return  outputChatBox ( "#FF0000[ERROR] #c8c8c8 Wait a while to end the round.", player, 255, 255, 255, true )
		end	
		if pause == true then
				pause = false
				round_paused  = false
				setGameSpeed( 1 )
				for k, v in pairs( getElementsByType ( 'player' ) ) do 
					toggleAllControls( v, true )
					setElementFrozen( v, false )
				end
				for k, v in pairs( getElementsByType ( 'vehicle' ) ) do 
					setElementFrozen( v, false )
				end
			pause = 0
		end	
			for k, v in pairs( getElementsByType ( 'player' ) ) do 
				setElementFrozen( v, true )
			end
		callClient(getRootElement(),  "finishRoundAnimation",  false, false, "By using the command /end by "..getPlayerName( player )..".", {}, true)
		killTimer ( countdown_data_timer )
		setTimer( function() 
			destroyElement ( map_root_element )
			stopResource( actually_map )
		end, 250, 1 )
		setElementData( team1, "p_count", 0 )
		setElementData( team2, "p_count", 0 )
		setElementData( team1, "Health", nil )
		setElementData( team2, "Health", nil )
		setElementData(global_element,"map_info",{"Lobby",""})
				for k, v in pairs( getElementsByType ( 'player' ) ) do 
					if isElement( blips.game[ v ]  ) then
						destroyElement( blips.game[ v ]  )
						blips.game[ v ] = nil
					end	
				end	
				_explosionOverlay = {}	
	--	countdown_data = {}
		removeWorldModel ( 7023, 25.68047, 2501.5156, 2781.2891, 9.82031)
		removeWorldModel ( 7172, 41.4114, 2546.0313, 2828.7344, 11.53906 )
		removeWorldModel ( 986, 7.4280729, 2497.6001, 2767.4355, 14.64366 )
		removeWorldModel ( 985, 7.3802581, 2497.5701, 2775.1453, 12.52567 )
		destroyAllWeaponPickups( )
		
	end
	addCommandHandler( "end", endRoundCommand )
	
	function checkTeamsStatus( )
		if locked_check == true then
			return 0;
		end
		if true == true then
			return 0;
		end	
		local teams_c = { getElementData(  getTeamByType( "Attack" ), "p_count" ), getElementData(  getTeamByType( "Defense" ), "p_count" ) }
			if teams_c[1] == 0 or teams_c[2] == 0 then
				local round_i = getElementData(global_element,"map_info")
				if round_i[1] == "Base" then

					if teams_c[2] == 0 and teams_c[1] > 0 then --// 'Defense' elemenited
						locked_check = true
						setTimer(function()
							finishRound( getTeamByType( "Attack" ), getTeamByType( "Defense" ), "All players from opposite team has been eliminate." )
							--locked_check = false
						end,500,1)	
						return
					else
						locked_check = true
						setTimer(function()
							finishRound( getTeamByType( "Defense" ), getTeamByType( "Attack" ), "All players from opposite team has been eliminate." )
							--locked_check = false
						end,500,1)	
						return
					end
					
				elseif round_i[1] == "Arena" then
			
					if teams_c[1] == 0 and teams_c[2] == 0 then
						locked_check = true
						setTimer(function()
							finishRound( false, false, "Draw, no alive players in both teams." )
						--	locked_check = false
						end,500,1)	
						return
					elseif teams_c[1] == 0 then
						locked_check = true
						setTimer(function()
							finishRound( getTeamByType( "Defense" ), getTeamByType( "Attack" ), "All players from opposite team has been eliminate." )
							--locked_check = false
						end,500,1)	
						return
					elseif teams_c[2] == 0 then
						locked_check = true
						setTimer(function()
							finishRound( getTeamByType( "Attack" ), getTeamByType( "Defense" ), "All players from opposite team has been eliminate." )
						--	locked_check = false
						end,500,1)	
						return
					end
				elseif round_i[1] == "Bomb" then
				
				end
			end
	end
	
	function countdown_finish()
		if locked_check == true then
			return 0;
		end	
	
		local round_type = getElementData(global_element,"map_info")
			if round_type[1] == "Base" then
				locked_check = true
				finishRound( getTeamByType( "Defense" ), getTeamByType( "Attack" ), "Time's up")	
			elseif round_type[1] == "Arena" then
				local teams_c = { getElementData(  team1, "p_count" ), getElementData(  team2, "p_count" ) ,getElementData(  team1, "Health" ), getElementData(  team2, "Health"  )  }
					if teams_c[1] > teams_c[2] then
						locked_check = true
						setTimer(function()
							finishRound( team1, team2, "Time is up, the team with more alive players has won." )
						end,500,1)	
						return
					elseif teams_c[1] < teams_c[2] then
						locked_check = true
						setTimer(function()
							finishRound( team2, team1, "Time is up, the team with more alive players has won." )
						end,500,1)	
						return
					else
						if teams_c[3] > teams_c[4] then
							locked_check = true
							setTimer(function()
								finishRound( team1, team2, "Time is up, players count in both teams are the same, team with more health wins.")
							end,500,1)	
						elseif teams_c[3] < teams_c[4] then
							locked_check = true
							setTimer(function()
								finishRound( team2, team1, "Time is up, players count in both teams are the same, team with more health wins.")
							end,500,1)	
						else
							locked_check = true
							setTimer(function()
								finishRound( false, false, "Draw, players and health count in both teams are the same." )
							end,500,1)	
						end
					end
				
			end
	end
	
	--[[
	
				if teams_c[1] == teams_c[2] then
					
						if teams_c[3] > teams_c[4] then
							locked_check = true
							setTimer(function()
								finishRound( team1, team2, "All players from opposite team has been eliminate." )
								locked_check = false
							end,500,1)	
							return
						elseif teams_c[4] > teams_c[3] then
						
						else
						
						end
						
						--]]
						
						
						
