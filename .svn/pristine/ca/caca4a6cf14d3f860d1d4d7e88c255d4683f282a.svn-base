

	local _vote = { current = { }, status = false }

	function _onPlayerVote( id, id_r )
		if _vote.current[ id ]  then
			_vote.current[ id ] = _vote.current[ id ] + 1
		else
			_vote.current[ id ] = 1
		end	
			if _vote.current[ id_r ] then
				_vote.current[ id_r ] = _vote.current[ id_r ] - 1
			end	
			callClient( getRootElement(  ), 'updateVoteProgress', id, id_r )
	end

	function voteInitializeHandler( data )
		
		if _vote.status and getTimerDetails( _vote.timer ) > 5000 then
			if not settings_.main[15][2] then
				return
			end	
				data = _vote.filter( data )
				killTimer( _vote.timer )
		end	

		_vote.lastData = data
		_vote.status = true
		callClient( getRootElement(  ), 'vote_voting', data  )
		_vote.timer = setTimer( _vote.results, settings_.main[14][2]*1000, 1 )
	end	


		function _vote.filter( data )
			local returnData = _vote.lastData
				for k, v in pairs( data ) do
				local add = true
					for _i, _v in pairs( returnData ) do
						if v[1] == _v[1] then
							add = false
						end	
					end
						if add then
							table.insert( returnData, v )
						end	
				end	
				
			return returnData
		end	


	function _vote.results(  )
		local totalVotes, map = 0, ''
			for k, v in pairs ( _vote.current ) do 
				if v > totalVotes then
					totalVotes, map = v, k
				end	
			end	
		if totalVotes > 0 then
			local resource = getResourceFromName( map )
			outputChatBox(  "#FF0000[VOTE] #c8c8c8 Next map will be #FF0000".. getResourceName( resource )..".", getRootElement(), 0, 0, 0, true )
			setTimer( startResource, 5000, 1, resource )
		end	
		_vote.current = { } 
		_vote.status = false
	end