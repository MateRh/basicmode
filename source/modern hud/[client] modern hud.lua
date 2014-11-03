
_initialLoading[ "source/modern hud/[client] modern hud.lua" ] = function ( )

local hud = { no_avatarTexture = dxCreateTexture ( 'img/no_avatar.png', 'dxt5' ), deadTexture = dxCreateTexture ( 'img/dead.png', 'dxt5' ), render = { }, data = { hide = false, round = 'Lobby', time = '--;--' }, colors = { green = tocolor( 0, 170, 0 ), blackT = tocolor( 0, 0, 0, 100 ), white = tocolor( 255, 255, 255 ) } }

local functionHealth

local colors_scheme = {
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
	
	for i=29, 48 do 
		local r, g, b = ( colors_scheme[ i-28 ][1] + colors_scheme[ i-27 ][1] + colors_scheme[ i-26 ][1] ) / 3,  ( colors_scheme[ i-28 ][2] + colors_scheme[ i-27 ][2] + colors_scheme[ i-26 ][2] ) / 3,  ( colors_scheme[ i-28 ][3] + colors_scheme[ i-27 ][3] + colors_scheme[ i-26 ][3] ) / 3  
		colors_scheme[ i ] = { r, g, b   }
	end
	


	
	--[[
	local gpit = getPlayersInTeam
	
		function getPlayersInTeam ( t )
		
				local __ = {}
					for i=1, 4 do 
						table.insert( __, localPlayer )
					end
				return __

		
		end
		
		
	local cpit = countPlayersInTeam
	
		function countPlayersInTeam ( t )
		
		
				return 4

		end
	]]

	
	function hud.getHealthL( p )
		return getElementHealth( p )
	end		

	function hud.getHealthR( p )
		return getElementData( p, 'Health' )
	end	

	functionHealth = hud.getHealthL




	
	function hud.dataUpdate( data )
		if data == "map_info" then
			local var = getElementData( source, data )[1]
				if var == "Lobby" then
					functionHealth = hud.getHealthL
				else
					functionHealth = hud.getHealthR
				end	
		end	

	end

	




	
	function hud.create( )
	local t1_, t2_ = getTeamByType( 'Attack'), getTeamByType( 'Defense' )
--	hud.data.h_min = { math.min( 80, scaleInt( 1080, 80 ) ), math.min( 75, scaleInt( 1080, 75 ) ) }
	hud.data.h_min = { scaleIntPercent( screenHeight, 93.9 ) , scaleIntPercent( screenHeight, 94.5 ), scaleIntPercent( screenHeight, 97.0 ) }
		hud.render.time = { 
			bg = { w = scaleByWidth( 1920, 128 ), h = scaleInt( 1080, 24 ), x = screenWidth/2 - scaleByWidth( 1920, 64 ), y = hud.data.h_min[1] },
			text = { }
		}		
		
		local rTargetW = dxGetFontHeight( 1, "clear" )+2
		hud.render.info = { 
			bg = { w = scaleByWidth( 1920, 1024 ), h = scaleInt( 1080, 24 ), x = screenWidth/2 - scaleByWidth( 1920, 512 ), y = scaleIntPercent( screenHeight, 90.5 ) },
			text = { },
		}
		hud.render.info.text = { 
			x = hud.render.info.bg.x+scaleByWidth( 1920, 128 ),
			xE = hud.render.info.bg.x+scaleByWidth( 1920, 640 ),
			y =  hud.render.info.bg.y + ( hud.render.info.bg.h - dxGetFontHeight( 1, "clear" )+2 )/2,
			addc = 1, 
			add = 0 
		}
		
		hud.render.time.text = { x = hud.render.time.bg.x + ( hud.render.time.bg.w - dxGetTextWidth( '99:99', 1, "clear" ) )/2, 
								y = hud.render.time.bg.y + ( hud.render.time.bg.h - dxGetFontHeight( 1, "clear" ) )/2 }
		hud.render.round = { 
			bg = { w = scaleByWidth( 1920, 200 ), h = scaleInt( 1080, 24 ), x = screenWidth/2 - scaleByWidth( 1920, 100 ), y = hud.data.h_min[3] },
			text = { },
		}
		hud.render.round.text = { x = hud.render.round.bg.x + ( hud.render.round.bg.w - dxGetTextWidth( 'Lobby', 1, "clear" ) )/2, 
								y = hud.render.round.bg.y + ( hud.render.round.bg.h - dxGetFontHeight( 1, "clear" ) )/2 }		
		hud.render.avatars = { [ t1_ ] = {}, [ t2_ ] = {} }
		

		hud.calc(  )
		hud.render.teams = { getTeamByType( 'Attack'), getTeamByType( 'Defense' ) }
		addEventHandler( 'onClientRender', getRootElement( ), hud.renderf )
		addEventHandler ( "onClientElementDataChange", getElementByIndex ( "root_gm_element",0 ), hud.dataUpdate )
	end
	
	
	local _av_c = { }

	function hud.verify ( player )
		if _av_c[ player] then
			return _av_c[ player]
		end

		local patch = 'avatars/'..getElementData( player, 'avatar' )
			if fileExists( patch ) then
				_av_c[ player] = dxCreateTexture ( patch, 'dxt5' )
				return patch
			else
				_av_c[ player] = hud.no_avatarTexture
				return  
			end
			
	end

	 hudVerify = hud.verify 


	 function hudReVerify ( player )
		if _av_c[ player ] then
				if isElement( _av_c[ player ] ) and _av_c[ player ] ~= hud.no_avatarTexture then
					destroyElement( _av_c[ player ] )
				end
			_av_c[ player ] = nil
			return hud.verify ( player )
		end


	 end	


	addEventHandler( "onClientPlayerQuit", getRootElement(), function ( )
		if _av_c[ source ] and isElement( _av_c[ source ] ) and _av_c[ source ] ~= hud.no_avatarTexture then
			destroyElement( _av_c[ source ] )
			_av_c[ source ] = nil
		end	
	end )
	 

function hud.renderf ( ) 

	if not hud.data.hide then		
		for i, t in pairs(  hud.render.teams ) do 	
			for k, p in pairs(  getPlayersInTeam ( t )) do 
				local _, hp = hud.render.avatars [ t ][ k ], functionHealth( p ) or 0
				
				--dxDrawImage ( _.x, _.y, hud.data.avatar_size, hud.data.avatar_size, getElementData( p, 'avatar' ) or 'img/no_avatar.png' )
					if hp < 1 then
						dxDrawImageSection ( _.x, _.y, hud.data.avatar_size[ t ], hud.data.avatar_size[ t ], 0, 0, 128, 128, hud.deadTexture )
					else
							dxDrawRectangle( _.bg.x, _.bg.y, hud.data.avatar_bg_size[ t ], hud.data.avatar_bg_size[ t ], tocolor( 0, 0, 0 ) )
						--dxDrawImageSection ( _.x, _.y, hud.data.avatar_size[ t ], hud.data.avatar_size[ t ], 0, 0, 128, 128, hud.verify (getElementData( p, 'avatar' ) ) )
						dxDrawImage ( _.x, _.y, hud.data.avatar_size[ t ], hud.data.avatar_size[ t ], hud.verify ( p ) )
					end
				if getPlayerTeam( localPlayer ) == t then
					dxDrawRectangle( _.x, _.y, hud.data.avatar_color, hud.data.avatar_color, tocolor( unpack( colors_scheme[ getElementData( p, '#c' ) ] ) ) )
				end
					
				dxDrawRectangle( _.bar.x, _.bar.y, hud.data.avatar_bar_size[ t ] * hp, hud.data.avatar_bar[ t ],  hud.colors.green )
			end
		end	
		
			local _ = hud.render.time.bg 
				dxDrawImage ( _.x, _.y, _.w, _.h, "img/hud.png", 0, 0, 0, hud.colors.blackT )
			_ = hud.render.round.bg 
				dxDrawImage ( _.x, _.y, _.w, _.h, "img/hud.png", 0, 0, 0, hud.colors.blackT )
			_ = hud.render.time.text 	
			dxDrawText ( hud.data.time, _.x, _.y, 0, 0,   hud.colors.white, 1, 'clear' )
			_ = hud.render.round.text 	
			dxDrawText ( hud.data.round, _.x, _.y, 0, 0,  hud.colors.white, 1, 'clear' )
			
		end
	
	end

	function updateSides()
		hud.render.teams = { getTeamByType( 'Attack'), getTeamByType( 'Defense' ) }
		local copyA, copyB = hud.render.avatars[ getTeamByType( 'Attack') ], hud.render.avatars[ getTeamByType( 'Defense' ) ]
		hud.render.avatars[ getTeamByType( 'Attack') ], hud.render.avatars[ getTeamByType( 'Defense' ) ] = copyB, copyA
		onSideUpdate( )
	end

	
	function hud.calc(  )
	
	local screenCapability =  hud.render.time.bg.x  / (  math.min( 64, scaleByWidth( 1920, 54 ) )  + math.ceil( math.min( 64, scaleByWidth( 1920, 54 ) ) / 3 ) )
	local t1_, t2_ = getTeamByType( 'Attack'), getTeamByType( 'Defense' )
	local m1_, m2_ = 1, 1
	local twoLine = { [t1_] = false, [t2_] = false }
		if countPlayersInTeam ( t1_ ) > screenCapability then
			m1_ = math.min( 2, ( countPlayersInTeam ( t1_ )+1.5) / screenCapability )
			outputChatBox( m1_ )
			if countPlayersInTeam ( t1_ ) > screenCapability*2 then
				twoLine[ t1_ ] = true
			end
		end	

		if countPlayersInTeam ( t2_ ) > screenCapability then
			m2_ = math.min( 2, ( countPlayersInTeam ( t2_ )+1.5) / screenCapability )
			if countPlayersInTeam ( t2_ ) > screenCapability*2 then
				twoLine[ t2_ ] = true
			end
		end	
		
	
		hud.data.avatar_size = { [ t1_ ] = math.min( 64/m1_, scaleByWidth( 1920, 54/m1_ ) ), [ t2_ ] = math.min( 64/m2_, scaleByWidth( 1920, 54/m2_ ) ) }
		hud.data.avatar_color = math.min( 10/m1_, scaleByWidth( 1920, 10/m1_ ) )
		hud.data.avatar_bar = { [ t1_ ] = math.min( 5, scaleByWidth( 1920, 5/m1_ ) ), [ t2_ ] = math.min( 5, scaleByWidth( 1920, 5/m2_ ) ) }
		hud.data.avatar_bg_size = { [ t1_ ] = hud.data.avatar_size[ t1_ ] + 2, [ t2_ ] = hud.data.avatar_size[ t2_ ] + 2 }
		hud.data.avatar_bar_size = { [ t1_ ] = ( hud.data.avatar_size[ t1_ ] -2) /100 , [ t2_ ] = ( hud.data.avatar_size[ t2_ ] -2)/100  }
		hud.data.avatar_space = { [ t1_ ] = math.ceil( hud.data.avatar_size[ t1_ ] / 3 ), [ t2_ ] =  math.ceil( hud.data.avatar_size[ t2_ ] / 3 ) }

	
	local _ = getTeamByType( 'Attack')
	local playersPerSide = 0	
		local _start = { hud.render.time.bg.x - hud.data.avatar_size[ _ ] + hud.data.avatar_space[ _ ],
						hud.render.time.bg.x + scaleByWidth( 1920, 128 ) - hud.data.avatar_space[ getTeamByType( 'Defense' ) ],
					}
					
					
		local i, c, _lastPos, nextColumn =  1, 1, 512, false
		
		while ( _lastPos > ( hud.data.avatar_size [ _ ]  + hud.data.avatar_space [ _ ]  ) ) do 
		
			hud.render.avatars [ _ ] [ i ] = { x = _start[ 1 ] - ( hud.data.avatar_size [ _ ]  + hud.data.avatar_space [ _ ]  )*c, y = hud.data.h_min[2] }
				if m1_ > 1 and twoLine[ _ ] then
					hud.render.avatars [ _ ] [ i ].y = hud.render.avatars [ _ ] [ i ].y -  hud.data.avatar_space [ _ ]  
				end
				if nextColumn == true then
					hud.render.avatars [ _ ] [ i ].y = hud.render.avatars [ _ ] [ i ].y + ( hud.data.avatar_size [ _ ]  + hud.data.avatar_space [ _ ] )* ( m1_ - 1 )
				end
			hud.render.avatars [ _ ] [ i ].bg = { x = hud.render.avatars [ _ ] [ i ].x - 1, y = hud.render.avatars [ _ ] [ i ].y - 1 } 
			hud.render.avatars [ _ ] [ i ].bar = { x = hud.render.avatars [ _ ] [ i ].x + 1, y = hud.render.avatars [ _ ] [ i ].y - 1 + hud.data.avatar_size [ _ ]  - hud.data.avatar_bar [ _ ] } 
			_lastPos = hud.render.avatars [ _ ] [ i ].x
			c = c + 1
			i = i + 1
			
			if m1_ > 1 and c > screenCapability*2 and nextColumn == false then
				nextColumn = true
				_lastPos = 512
				c = 1
			end
		end
		
		_ = getTeamByType( 'Defense' )
		c, i, _lastPos, nextColumn =  1, 1, 512, false
		while ( _lastPos < screenWidth - ( hud.data.avatar_size [ _ ] *2 + hud.data.avatar_space [ _ ]  ) ) do 
		
			hud.render.avatars [ _ ] [ i ] = { x = _start[ 2 ] + ( hud.data.avatar_size [ _ ]  + hud.data.avatar_space [ _ ]  )*c, y = hud.data.h_min[2] } 
				if m2_ > 1 and twoLine[ _ ] then
					hud.render.avatars [ _ ] [ i ].y = hud.render.avatars [ _ ] [ i ].y -  hud.data.avatar_space [ _ ]  
				end
				if nextColumn == true then
					hud.render.avatars [ _ ] [ i ].y = hud.render.avatars [ _ ] [ i ].y + ( hud.data.avatar_size [ _ ]  + hud.data.avatar_space [ _ ] )* ( m2_ - 1 )
				end
			
			
			hud.render.avatars [ _ ] [ i ].bg = { x = hud.render.avatars [ _ ] [ i ].x - 1, y = hud.render.avatars [ _ ] [ i ].y - 1 } 
			hud.render.avatars [ _ ] [ i ].bar = { x = hud.render.avatars [ _ ] [ i ].x + 1, y = hud.render.avatars [ _ ] [ i ].y - 1 + hud.data.avatar_size [ _ ]  - hud.data.avatar_bar [ _ ] } 
			_lastPos = hud.render.avatars [ _ ] [ i ].x
			c = c + 1
			i = i + 1
			
			if m2_ > 1 and c > screenCapability*2 and nextColumn == false then
				nextColumn = true
				_lastPos = 512
				c = 1
			end
		end

			
	end
	
	function hideHud()
		hud.data.hide = true
	end

	function showHud()
		hud.data.hide = false
	
	end
	
	
	
		function changeHudFunctionality( type, name, spect )
			hud.data.round = name or 'Lobby'
			hud.render.round.text.x = hud.render.round.bg.x + ( hud.render.round.bg.w - dxGetTextWidth( hud.data.round , 1, "clear" ) )/2
				if hud.data.round ~= 'Lobby' then
					setElementData( localPlayer, "Health", tonumber( string.format("%.0f", getElementHealth( localPlayer )) ) )
					addEventHandler ( "onClientRender", getRootElement(), updateHealth )
				else
					removeEventHandler ( "onClientRender", getRootElement(), updateHealth )
					setElementData( localPlayer, "Health", 0 )
				end

		end
	
	
		local countdown_data = {buffer=0}
		
		function countdown_start( ms )
		--	local m, s = { math.modf( ms ) }
			countdown_data.finish =  ( ms ) + getTickCount()
			hud.data.colors_ = tocolor( 255, 255, 255 )
			hud.data.colors_c =  { tocolor( 255, 255, 255 ), tocolor( 255, 0, 0 ), 1 }
			addEventHandler ( "onClientRender", getRootElement(),countdown_onSecound )
		end
		
		function countdown_onSecound()
		if round_paused then return end
			local count = getTickCount()
				if count - countdown_data.buffer > 499 then
					local cache = (( countdown_data.finish - count ) / 60000 )
					local m = math.modf(cache) 
					local s = math.modf((cache-m)*60)
					hud.data.time = string.format("%.2i : %.2i", m,s )
					countdown_data.buffer = count
					if m == 0 and s < 31 then
						if s == 0 then
							hud.data.time = "Time's up"
							removeEventHandler ( "onClientRender", getRootElement(), countdown_onSecound )
							return 
						end
						hud.data.colors_c[3] = hud.data.colors_c[3]+1
						
							if hud.data.colors_c[3] == 3 then
								hud.data.colors_c[3] = 1
							else
								local sound = playSound ( "sounds/end.wav" )
								setSoundVolume(sound, 0.5 )
							end
						hud.data.colors_ = hud.data.colors_c[hud.data.colors_c[3]]

					end	
				end
				
		end
		
		function countdown_stop()
			removeEventHandler ( "onClientRender", getRootElement(), countdown_onSecound )
			hud.data.time = "-- : --"	
			countdown_data = {buffer=0}
		end	
		local updateHealth_tc = getTickCount()
		
		function updateHealth( )
			if getTickCount() - updateHealth_tc > 500 then
				updateHealth_tc = getTickCount()
				setElementData( localPlayer, "Health", tonumber( string.format("%.0f", getElementHealth( localPlayer )+ getPedArmor( localPlayer) ) ) )
			end
		end
	
	
	
	
	
	
	
	
	
	
	
	
		hud.create( )
		
		hideHud ( )


local crouch_overlay = { step = 0 }

--[[


bindKey( 'sprint', 'down', function ()
						if not getControlState( localPlayer, 'aim_weapon' ) and  getPedTask ( localPlayer, "secondary", 0 ) == 'TASK_SIMPLE_USE_GUN' then
						
					--	for i=1, 10 do
							setControlState( 'crouch', true )
						setTimer( function()	setControlState( 'crouch', false ) end, 50, 1 )
							
						--end	
							outputChatBox('sialalala' )
						
						end
						
						end )
						
						]]
						
					bindKey( 'crouch', 'down', function ()
						local weapon = getPedWeapon( localPlayer )
						if weapon ~= 25 and weapon ~= 34 then
							return 0
						end	

						if not getControlState( 'aim_weapon' ) and  getPedTask ( localPlayer, "secondary", 0 ) == 'TASK_SIMPLE_USE_GUN' then
							setControlState( 'crouch', false )
							crouch_overlay.step = 1
					--	for i=1, 10 do
						--[[	setControlState( 'crouch', false )
						setTimer( function()	setControlState( 'crouch', true ) end, 50, 1 )
						setTimer( function()	setControlState( 'crouch', false ) end, 75, 1 )
							
						--end	
							outputChatBox('sialalala' )]]
						
						end
						
						end )
						
	addEventHandler( 'onClientRender', getRootElement(), 
	
	function ( )
		if crouch_overlay.step == 0 then
			return 0
		end	
	--outputDebugString( ' me, with me ' );
		if crouch_overlay.step < 4 then
			if crouch_overlay.step > 1 then
				setControlState( 'crouch', true )
			else
				setControlState( 'crouch', false )
			end	
			crouch_overlay.step = crouch_overlay.step + 1
		else 
			setControlState( 'crouch', false )
			crouch_overlay.step = 0
			setControlState( 'crouch', false )
		end
		
	end )


	_initialLoaded( "source/modern hud/[client] modern hud.lua" )	

end		