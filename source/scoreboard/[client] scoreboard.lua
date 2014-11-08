
_initialLoading[ "source/scoreboard/[client] scoreboard.lua" ] = function ( )

	iSscoreboard = false
	local scoreboard_ = { sides = { left = getTeamByType( 'Attack'), right = getTeamByType( 'Defense' ) }, columns = {}, settings = { marginLeft = 25 }, global = { w = 1020, h = 700, scalar = 1 }, teams = { } }
	local sb_cache = {}
	local blur_enabled_was = false
	
	function addScoreboardColumn ( title, w, pos,  typex )
		if type( title ) == 'string' and type( w ) == 'number' and type( pos ) == 'number' then
			typex = typxe or 'data'
			
			table.insert( scoreboard_.columns, pos, { title, math.cut(   sb_cache.global.hW *w ) , typex } )
			
		
		end

	end
	

	function onScoreScroll( scoll )
	local t 
		if scoll == sb_cache.teams[ scoreboard_.sides.left ].scroll then
			t = scoreboard_.sides.left
		else
			t = scoreboard_.sides.right
		end	
		scoreboard_.teams [ t ].shift = scoreboard_.teams [ t ].pixels * guiScrollBarGetScrollPosition( scoll )

	end	

	function resizeRenderTarget( t, c )
		if isElement( sb_cache.renderTarget[t] ) then 
			destroyElement(	sb_cache.renderTarget[t] )
		end	
		scoreboard_.teams [ t ].pixels =  math.floor( 32*sb_cache.global.scalar[2] )*c
		sb_cache.renderTarget[ t ] = dxCreateRenderTarget ( sb_cache.global.hW, scoreboard_.teams [ t ].pixels, true )
	end
	
	function verifyCount ( )
		for k, t in pairs ( { scoreboard_.sides.left, scoreboard_.sides.right } ) do 
			if countPlayersInTeam ( t ) > 15 and scoreboard_.teams [ t ].playerCount  < 16 then
				scoreboard_.teams [ t ].playerCount  = countPlayersInTeam ( t )
				resizeRenderTarget( t, scoreboard_.teams [ t ].playerCount )
			elseif scoreboard_.teams [ t ].playerCount > 15 and countPlayersInTeam ( t ) < 15 then
				scoreboard_.teams [ t ].playerCount = 15
				resizeRenderTarget( t, scoreboard_.teams [ t ].playerCount )
			end
		end
	end

	function onSideUpdate( )

		local copyA = sb_cache.teams [ scoreboard_.sides.left ] 
		local copyAr = sb_cache.renderTarget [ scoreboard_.sides.left ] 
		local copyB = sb_cache.teams [ scoreboard_.sides.right ] 
		local copyBr = sb_cache.renderTarget [ scoreboard_.sides.right ] 

		scoreboard_.sides = { }
		scoreboard_.sides.left = getTeamByType( 'Attack')
		scoreboard_.sides.right = getTeamByType( 'Defense' )	
		sb_cache.renderTarget = {}
		sb_cache.teams [ scoreboard_.sides.left ] = {}
		sb_cache.teams [ scoreboard_.sides.left ] = copyA
		sb_cache.renderTarget [ scoreboard_.sides.left ] = copyAr
		sb_cache.teams [ scoreboard_.sides.right ] = {}
		sb_cache.teams [ scoreboard_.sides.right ] = copyB
		sb_cache.renderTarget [ scoreboard_.sides.right ] = copyBr

		updateWholeTeamData ( scoreboard_.sides.left )
		updateWholeTeamData ( scoreboard_.sides.right )
	end	



	
	function initilalizeScoreboard( )
		sb_cache.global = { }
		sb_cache.global.scalar = { math.min( 1, scaleByWidth ( 780, 1, 2 ) ), math.min( 1, scaleInt( 760, 1, 2) ) }
			if  sb_cache.global.scalar[1] < 1 then
				 sb_cache.global.scalar[1] =  sb_cache.global.scalar[1] * ( (screenWidth-18) / screenWidth ) 	
			end
			if  sb_cache.global.scalar[2] < 1 then
				 sb_cache.global.scalar[1] =  sb_cache.global.scalar[2] * ( (screenHeight-18) / screenHeight ) 
			end

		sb_cache.global.w = 780*sb_cache.global.scalar[1]
		sb_cache.global.h = 740*sb_cache.global.scalar[2] 
		sb_cache.colors = {  main_bg = tocolor( 0, 0, 0, 12.5 ), text = tocolor( 255, 255, 255 ), [1] = tocolor( 0, 0, 0, 100 ), [2] = tocolor( 150, 150, 150, 100 ), }
		sb_cache.global.x = ( screenWidth - sb_cache.global.w ) / 2
		sb_cache.global.y = ( screenHeight - sb_cache.global.h ) / 2
		sb_cache.global.hW = sb_cache.global.w
		sb_cache.columns = { y = sb_cache.global.y +7 }
		sb_cache.fonts = {	
				columns = dxCreateFont ('fonts/visitor.ttf', math.floor( 7*sb_cache.global.scalar[1] ) ),
				list = dxCreateFont ('fonts/PTM55F.ttf', math.floor( 9*sb_cache.global.scalar[1] ), true ),
				list2 = dxCreateFont ('fonts/PTM55F.ttf', math.floor( 7*sb_cache.global.scalar[1] ), true ),
				list3 = dxCreateFont ('fonts/PTM55F.ttf', math.floor( 6*sb_cache.global.scalar[1] ), true ),
				teamM = dxCreateFont ('fonts/TallLean.ttf', math.floor( 18*sb_cache.global.scalar[1] ), true ),
				info = dxCreateFont ('fonts/TallLean.ttf', math.floor( 11*sb_cache.global.scalar[1] ), true ) 
						}

			addScoreboardColumn ('ID', 0.02, 1,  'data' )
			--addScoreboardColumn ('Avatar', 0.085, 2,  'image' )
			addScoreboardColumn ('Player', 0.07, 3 )
			addScoreboardColumn ('Score', 0.4, 4 )
			addScoreboardColumn ('Damage', 0.5, 5 )
			addScoreboardColumn ('K / D', 0.65, 6 )
		--	addScoreboardColumn ('Deaths', 0.5, 5 )
			addScoreboardColumn ('Health', 0.75, 7 )
			addScoreboardColumn ('FPS', 0.85, 8 )
			--addScoreboardColumn ('Loss', 0.8, 8 )
			addScoreboardColumn ('Net', 0.925, 9 )
		
		sb_cache.renderTarget = { 
			[ scoreboard_.sides.left ] = dxCreateRenderTarget ( sb_cache.global.hW , math.floor( 224*sb_cache.global.scalar[2] ), true ),
			[ scoreboard_.sides.right ] = dxCreateRenderTarget ( sb_cache.global.hW, math.floor( 224*sb_cache.global.scalar[2] ), true )
		}
		
		local alpha_bg = tocolor( 255, 255, 255, 155)
		sb_cache.g_shadow = { 
			{ sb_cache.global.x-9, sb_cache.global.y, 9, sb_cache.global.h, "img/scoreboard/bg_shadow_ver.png", 0, 0, 0, alpha_bg },
			{ sb_cache.global.x, sb_cache.global.y-9, sb_cache.global.w, 9, "img/scoreboard/bg_shadow_hor.png", 0, 0, 0, alpha_bg },
			{ sb_cache.global.x + sb_cache.global.w, sb_cache.global.y, 9, sb_cache.global.h, "img/scoreboard/bg_shadow_ver.png", 180, 0, 0, alpha_bg },
			{ sb_cache.global.x, sb_cache.global.y+sb_cache.global.h, sb_cache.global.w, 9, "img/scoreboard/bg_shadow_hor.png", 180, 0, 0, alpha_bg },
			{ sb_cache.global.x-9, sb_cache.global.y-9, 9, 9, "img/scoreboard/bg_shadow_cor.png", 0, 0, 0, alpha_bg },
			{ sb_cache.global.x+sb_cache.global.w, sb_cache.global.y-9, 9, 9, "img/scoreboard/bg_shadow_cor.png", 90, 0, 0, alpha_bg },
			{ sb_cache.global.x+sb_cache.global.w, sb_cache.global.y+sb_cache.global.h, 9, 9, "img/scoreboard/bg_shadow_cor.png", 180, 0, 0, alpha_bg },
			{ sb_cache.global.x-9, sb_cache.global.y+sb_cache.global.h, 9, 9, "img/scoreboard/bg_shadow_cor.png", 270, 0, 0, alpha_bg }
		}
		
			updateWholeTeamData ( scoreboard_.sides.left )
			updateWholeTeamData ( scoreboard_.sides.right )

		sb_cache.teams = { 
			[ scoreboard_.sides.left ] = { 
				texts = { 
					name = { sb_cache.global.x + 25, sb_cache.global.y +5, sb_cache.colors.text, 1, sb_cache.fonts.teamM, 1 },
					info = { sb_cache.global.x + 25, sb_cache.global.y + dxGetFontHeight ( 1,  sb_cache.fonts.teamM ) + 5, sb_cache.colors.text, 1, sb_cache.fonts.info, 1 },
					},
				bg = { sb_cache.global.x, sb_cache.global.y , sb_cache.global.hW, math.floor( 76*sb_cache.global.scalar[2] ), tocolor( 255, 0, 0 ,35 ) },
				scroll = guiCreateScrollBar ( sb_cache.global.x +sb_cache.global.hW-10, sb_cache.global.y + math.floor( 76*sb_cache.global.scalar[2] ), 10, math.floor( 224*sb_cache.global.scalar[2] ), false, false )
				},
			
			[ scoreboard_.sides.right ] =	{ 	texts = { 
					name = { sb_cache.global.x +25, sb_cache.global.y +300*sb_cache.global.scalar[1]+5, sb_cache.colors.text, 1, sb_cache.fonts.teamM, 1 },
					info = { sb_cache.global.x +25, sb_cache.global.y +300*sb_cache.global.scalar[1]+ dxGetFontHeight ( 1,  sb_cache.fonts.teamM ) + 5, sb_cache.colors.text, 1, sb_cache.fonts.info, 1 },
					},
				bg = { sb_cache.global.x, sb_cache.global.y+300*sb_cache.global.scalar[1] ,  sb_cache.global.hW, math.floor( 76*sb_cache.global.scalar[2] ), tocolor( 255, 0, 0 ,35 ) },
				scroll = guiCreateScrollBar ( sb_cache.global.x + sb_cache.global.w -10, sb_cache.global.y +300+ math.floor( 76*sb_cache.global.scalar[2] ), 10, math.floor( 224*sb_cache.global.scalar[2] ), false, false ),
			}
		}	
		sb_cache.info_ = {
			bg = { x = sb_cache.global.x, y = sb_cache.global.y + sb_cache.global.h - scale_ ( 144, 2 ) },
			t = { x = sb_cache.global.x + scale_ ( 25, 1 ), y = sb_cache.global.y + sb_cache.global.h - scale_ ( 144, 2 ) + scale_ ( 15, 2 ) },
		}
		sb_cache.rawData = { }
			local _ = sb_cache.rawData
			_.c1 =  sb_cache.columns.y+ math.floor( 55*sb_cache.global.scalar[2] ) 
			_.c2 =  sb_cache.columns.y+ math.floor( 55*sb_cache.global.scalar[2] + (300*sb_cache.global.scalar[2] ) ) 


		guiSetAlpha( sb_cache.teams[ scoreboard_.sides.left ].scroll, 0.75 )
		guiSetAlpha( sb_cache.teams[ scoreboard_.sides.right ].scroll, 0.75 )
		guiSetEnabled( sb_cache.teams[ scoreboard_.sides.left ].scroll, false )
		guiSetEnabled( sb_cache.teams[ scoreboard_.sides.right ].scroll, false )

		addEventHandler("onClientGUIScroll", sb_cache.teams[ scoreboard_.sides.left ].scroll, onScoreScroll )
		addEventHandler("onClientGUIScroll", sb_cache.teams[ scoreboard_.sides.right ].scroll, onScoreScroll )
			
	end
	
	
		addEventHandler ( "onClientElementDataChange", getRootElement(),
		function ( dataName )
			if getElementType ( source ) == "team" then
				updateWholeTeamData ( source )
			end
		end )
	
	moveable = 0


	function scale_ ( n, i )
			return math.floor( n*sb_cache.global.scalar[ i ] )
	end	



	function updateWholeTeamData ( team )
		scoreboard_.teams [ team ] = { }
		scoreboard_.teams [ team ].name = getTeamName( team )
		scoreboard_.teams [ team ].into  = string.upper( getElementData( team, 't_type' )..'  /  score: '.. ( getElementData( team, 'Score' ) or 0 ) ..'  /  Alive: '.. ( getElementData( team, 'p_count' ) or 0 ) ..'  /  Health: '..( getElementData( team, 'Health' ) or 0 )..'%' )
			local r, g, b = getTeamColor( team )
		scoreboard_.teams [ team ].color = tocolor( r, g, b, 125 )
		scoreboard_.teams [ team ].colorSolid = tocolor( r, g, b )
		scoreboard_.teams [ team ].playerCount = scoreboard_.teams [ team ].playerCount or 15
		scoreboard_.teams [ team ].pixels = scoreboard_.teams [ team ].pixels or math.floor( 32*sb_cache.global.scalar[2] )*15
		scoreboard_.teams [ team ].shift = 0
	end

--[[
	
	local fake_players = 15



	local getPlayersInTeamCopy = getPlayersInTeam

	function getPlayersInTeam ( team )
	local returnT = { }
		if team == getPlayerTeam( localPlayer ) then

			for i=1,fake_players do 
				table.insert( returnT, localPlayer )
			end	
			return returnT
		else 
			return {}	
		end
	end	

	local akordy = countPlayersInTeam

	function countPlayersInTeam( team )
			if team == getPlayerTeam( localPlayer ) then
				return fake_players
			end
			return akordy( team )
	end		

]]
function onMouse( _, state )
	if state == 'down' then
		for k, v in pairs( sb_cache.teams ) do 
				if not guiGetEnabled( v.scroll ) then
					guiSetEnabled( v.scroll, true)
					guiSetVisible ( v.scroll, true )
				end	
			end	
		sb_cache.cursor = isCursorShowing(  )
		showCursor( true )	
	else
		for k, v in pairs( sb_cache.teams ) do 
			if guiGetEnabled( v.scroll ) then
				guiSetEnabled( v.scroll, false )
				guiSetVisible ( v.scroll, false )
			end	
				
		end	
		if sb_cache.cursor then
			sb_cache.cursor = nil	
		else
			showCursor( false )	
		end	
	end	

end	




bindKey ( 'tab', 'both', function ( _, state )

	if state == 'down' then
	--	sb_cache.renderEnabled = true 
			iSscoreboard = true	
			if sb_cache.hud == nil then
			--	sb_cache.cursor = isCursorShowing(  )
				sb_cache.hud = { r =  isPlayerHudComponentVisible( 'radar' ) }
				showPlayerHudComponent( 'radar', false )
				showChat( false )
			end	

			if _localPlayer:getStatus( 3 ) ~= 1 then
				blur_enabled_was = blur_remote( true, 3, false, true, sb_cache.global.x, sb_cache.global.y,  sb_cache.global.w,  sb_cache.global.h )
				bindKey ( 'mouse2', 'both', onMouse )
			end	
		verifyCount ( )	
		addEventHandler( 'onClientRender', getRootElement(), onFrameScoreBoard )
		
	else
	--	sb_cache.renderEnabled = false
		if _localPlayer:getStatus( 3 ) ~= 1 then
			onMouse( 'up')
			unbindKey ( 'mouse2', 'both', onMouse )
		end	

		removeEventHandler( 'onClientRender', getRootElement(), onFrameScoreBoard )
			iSscoreboard = false
			if blur_enabled_was then
				blur_remote( false )
				blur_enabled_was = false
			end
			if sb_cache.hud  then
				showPlayerHudComponent( 'radar', sb_cache.hud.r)
				showChat( true )
				sb_cache.hud = nil
				--[[	if sb_cache.cursor then
						showCursor( sb_cache.cursor )
						sb_cache.cursor = nil
					end	]]
			end	
				for k, v in pairs( sb_cache.teams ) do 
					if guiGetEnabled( v.scroll ) then
						guiSetEnabled( v.scroll, false )
						guiSetVisible ( v.scroll, false )
					end	
						
				end	
	end

end )

	function onFrameScoreBoard () 
			if isConsoleActive(  ) then
				return 0;
			end	
		

		
		
		

		for k, v in pairs ( sb_cache.g_shadow ) do 
			dxDrawImage( unpack( v ) )
		end
		
		dxDrawRectangle ( sb_cache.global.x, sb_cache.global.y,  sb_cache.global.w,  sb_cache.global.h, sb_cache.colors.main_bg )
	
	

		
		for k, v in pairs ( sb_cache.teams ) do 
			dxDrawImage( v.bg[1], v.bg[2], v.bg[3], v.bg[4], "img/scorebg.png", 0, 0, 0, scoreboard_.teams [ k ].color )
			--dxDrawRectangle( v.bg[1], v.bg[2], v.bg[3], v.bg[4], scoreboard_.teams [ k ].color )
			
			dxTextDrawShadow ( scoreboard_.teams [ k ].name,  unpack( v.texts.name  ) )
			--dxDrawText ( scoreboard_.teams [ k ].title, v.texts.title[1], v.texts.title[2] , 0, 0, v.texts.title[3], v.texts.title[4], v.texts.title[5] )
			dxTextDrawShadow ( scoreboard_.teams [ k ].into,  unpack( v.texts.info  ) )
		--	dxDrawImage( unpack( v.img ) )
				
		end



		
	
	--	local _playerlist_c = { col = 1, y =  sb_cache.columns.y +scale_ ( 26, 2 ), textY = sb_cache.columns.y + scale_ ( 34, 2 ), rY = 0, rtY = scale_ ( 8, 2 )  }
			for k, v in pairs( scoreboard_.columns ) do 
				dxDrawOutlineText( v[1],  sb_cache.global.x +v[2], sb_cache.rawData.c1, sb_cache.colors.text , 1, sb_cache.fonts.columns  )
				dxDrawOutlineText( v[1],  sb_cache.global.x +v[2], sb_cache.rawData.c2, sb_cache.colors.text , 1, sb_cache.fonts.columns  )
			end	

			for team, _ in pairs( sb_cache.teams ) do 
				local  _playerlist_c = { col = 1, y =  sb_cache.columns.y +scale_ ( 26, 2 ), textY = sb_cache.columns.y + scale_ ( 34, 2 ), rY = 0, rtY = scale_ ( 8, 2 )  }
				dxSetRenderTarget( sb_cache.renderTarget[ team ], true )

				_playerlist_c.y = sb_cache.columns.y+scale_ ( 55, 2 )
					for _, player in pairs( getPlayersInTeam ( team ) ) do

						dxDrawRectangle(  0, _playerlist_c.rY,  sb_cache.global.w, scale_ ( 32, 2 ), sb_cache.colors[ _playerlist_c.col ] )
						
						
						_playerlist_c.col = _playerlist_c.col + 1
							if _playerlist_c.col > 2 then
								_playerlist_c.col  = 1
							end	

						for k, v in pairs( scoreboard_.columns ) do 	
							local posX = v[2]
							local _data 
								if v[1] == 'Player' then
									_data = getPlayerName( player )
									dxDrawImage( v[2],  _playerlist_c.rY, scale_ ( 32, 2 ), scale_ ( 32, 2 ),   hudVerify ( player ) )
									posX = posX + scale_ ( 42, 2 )
								elseif v[1] == 'K / D' then
									_data = getElementData( player, 'Kills' ).. ' / '..getElementData( player, 'Deaths' )
								elseif v[1] == 'Net' then
									dxTextDrawShadow ( getPlayerPing( player ),  posX, _playerlist_c.rtY-5, sb_cache.colors.text , 1, sb_cache.fonts.list, 1  )
									dxTextDrawShadow ( ( getElementData( player, 'l%' ) or 0 )..'%',  posX, _playerlist_c.rtY+scale_ ( 9, 2 ), sb_cache.colors.text , 1, sb_cache.fonts.list2, 1  )
								else
									_data =  getElementData( player, v[1] ) or ''
								end
									if _data then
										dxTextDrawShadow ( _data,  posX, _playerlist_c.rtY, sb_cache.colors.text , 1, sb_cache.fonts.list, 1  )
									end	
									
						end	
						_playerlist_c.rY = _playerlist_c.rY + scale_ ( 32, 2 )
						_playerlist_c.rtY = _playerlist_c.rtY + scale_ ( 32, 2 )

					end

						
			dxSetRenderTarget( )	
			end
		dxDrawImageSection ( sb_cache.global.x, sb_cache.columns.y  + math.floor( 69*sb_cache.global.scalar[2] ),sb_cache.global.hW , math.floor( 224*sb_cache.global.scalar[2] ), 0,  scoreboard_.teams [ scoreboard_.sides.left ].shift,  sb_cache.global.hW, math.floor( 224*sb_cache.global.scalar[2] ), sb_cache.renderTarget [ scoreboard_.sides.left ] )			
		dxDrawImageSection ( sb_cache.global.x, sb_cache.columns.y + 300*sb_cache.global.scalar[1] + math.floor( 69*sb_cache.global.scalar[2] ),  sb_cache.global.hW, math.floor( 224*sb_cache.global.scalar[2] ), 0, scoreboard_.teams [ scoreboard_.sides.right ].shift, sb_cache.global.hW, math.floor( 224*sb_cache.global.scalar[2] ), sb_cache.renderTarget [ scoreboard_.sides.right ] )			


		dxDrawImage( sb_cache.info_.bg.x, sb_cache.info_.bg.y, sb_cache.global.w, scale_ ( 144, 2 ), "img/scorebg_rev.png", 180, 0, 0, tocolor( 255, 255, 255, 25 ) )
		
		dxTextDrawShadow (  getElementData( getElementByIndex ( "root_gm_element",0 ), 'sI'),sb_cache.info_.t.x, sb_cache.info_.t.y, sb_cache.colors.text , 1, sb_cache.fonts.info, 1  )

	

	local connectd, spectators, sTeam = 'Connected: ', '\nSpectators: ', getTeamByType(  "Spectator" )
			for k, v in pairs ( getElementsByType ( "player" ) ) do 
				local p_team = getPlayerTeam( v );
				if p_team == false then
					connectd = connectd..getPlayerName( v )..' ( ID: '..getElementData( v, 'ID' )..' P: '..getPlayerPing ( v )..' ), ' 
				elseif p_team == sTeam then
					spectators = spectators..getPlayerName( v )..' ( ID: '..getElementData( v, 'ID' )..' P: '..getPlayerPing ( v )..' ), ' 
				end
			end	
		dxTextDrawShadow( connectd..'\n'..spectators,   sb_cache.global.x+35,  sb_cache.global.y+sb_cache.global.h-80, sb_cache.colors.text , 1, sb_cache.fonts.list  )	
		
	end	
	
	setTimer( initilalizeScoreboard, 1000, 1 )

	_initialLoaded( "source/scoreboard/[client] scoreboard.lua" )	

end	