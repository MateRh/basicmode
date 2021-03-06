
_initialLoading[ "hud_code.lua" ] = function ( )
	


local hud_table = { colors_count =  { tocolor( 255, 255, 255 ), tocolor( 255, 0, 0 ), 1 } }
local root_element = nil
local class_hud = {
			colors_c =  { 
						tocolor( 255, 255, 255 ),
						tocolor( 255, 0, 0 ),
						1 
						},
			render = {},
			data_ = {},
			fonts = {},
			round_ = 'lobby',
			info_ = 'Arena: 0   00:00',
			settings_ = { style = 'outline', outline = 1, shadow = 1 },
				}

	function getTeamByType(t_type)
		for k,v in ipairs( getElementsByType("team") ) do
			if getElementData(v,"t_type") == t_type then
				return v
			end
		end
		return false
	end
	
	local dxTextDraw = {}

	function dxTextDraw.normal ( text, x, y, color, scale, font )
		dxDrawText ( text, x, y, 0, 0, color, scale, font )
	end	
	
	function dxTextDraw.shadow ( text, x, y, color, scale, font )
		local shadow = class_hud.settings_.shadow
		dxDrawText ( text, x, y , 0, 0,  colors_g.black, scale, font )
		dxDrawText ( text, x-shadow, y-shadow , 0, 0, color, scale, font )
	end	
	
	function dxTextDrawShadow ( text, x, y, color, scale, font, o )
		local shadow = o or class_hud.settings_.shadow
		dxDrawText ( text, x, y , 0, 0,  colors_g.black, scale, font )
		dxDrawText ( text, x-shadow, y-shadow , 0, 0, color, scale, font )
	end

	function dxTextDraw.shadow2 ( text, x, y, color, scale, font )
		dxDrawText ( text, x, y , 0, 0,  colors_g.black, scale, font )
		dxDrawText ( text, x-2, y-2 , 0, 0,  colors_g.black, scale, font )
		dxDrawText ( text, x-1, y-1 , 0, 0, color, scale, font )
	end	
	
	function dxTextDraw.outline ( text, x, y, color, size, font )
		local outline = class_hud.settings_.outline
		dxDrawText ( text, x-outline, y-outline , 0, 0, colors_g.black, size, font )
		dxDrawText ( text, x, y-outline , 0, 0, colors_g.black, size, font )
		dxDrawText ( text, x+outline, y+outline , 0, 0, colors_g.black, size, font )
		dxDrawText ( text, x, y+outline , 0, 0, colors_g.black, size, font )
		dxDrawText ( text, x-outline, y+outline , 0, 0, colors_g.black, size, font )
		dxDrawText ( text, x+outline, y-outline , 0, 0, colors_g.black, size, font )
		dxDrawText ( text, x-outline, y , 0, 0, colors_g.black, size, font )
		dxDrawText ( text, x+outline, y , 0, 0, colors_g.black, size, font )
		
		
		dxDrawText ( text, x, y , 0, 0, color, size, font )
	end
	
	dxDrawOutlineText = dxTextDraw.outline 
	
	function dxText( text, x, y, color, scale, font )
		if not text then return end
		 dxTextDraw[ class_hud.settings_.style ]( text, x, y, color, scale, font )
	end
	
	
	
	function math.cut( n )
		if ( n - math.modf( n ) ) > 0.5 then
			return math.ceil( n )
		else
			return math.floor( n )
		end
	end
	
local scalar =  screenWidth  * ( 1 / 1920 ) 
	
	addEventHandler("onClientVehicleRespawn",root,function()
		setVehicleEngineState ( source, false )
	end)
	
	function disableVehicleArmory( )
		if getVehicleType ( getPedOccupiedVehicle( localPlayer ) ) ~= "BMX" then
			setControlState ( 'vehicle_fire', false )
			setControlState ( 'vehicle_secondary_fire', false )
		end
		--toggleControl ( 'vehicle_fire', false )
		--toggleControl ( 'vehicle_secondary_fire', false )

	end	

	bindKey( 'vehicle_fire', 'down', disableVehicleArmory )
	bindKey( 'vehicle_secondary_fire', 'down', disableVehicleArmory )



	
local para_info =  getTickCount() - 90000
	
	addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
		if thePlayer ~= localPlayer then
			return 0
		end

	--	toggleControl ( 'vehicle_fire', false )
	--	toggleControl ( 'vehicle_secondary_fire', false )
		callServer('setPedWeaponSlot',  localPlayer, 0 )
		if seat == 0 then
		
			if client_settings_t.base and client_settings_t.base[5][2] == false and getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] == "Base"  and getElementData( getPlayerTeam( localPlayer ),"t_type") == "Defense" then
				setVehicleEngineState ( source, false )
				return 0;
			end
		--	setVehicleEngineState ( source, false )
		--	setTimer( function(v) setVehicleEngineState ( v, true ) end, 550,1, source)
		end
			local vehicle_type = getVehicleType( source )
				if vehicle_type  == 'Plane' or vehicle_type  == 'Helicopter' then
					if getTickCount() > para_info then
						para_info = getTickCount() + 90000
						return outputChatBox( "#FF0000[INFO] #FFFFFF You can get '#c8c8c8parachute#FFFFFF' via cmd #c8c8c8/para or /parachute#FFFFFF or jump out from a height.", 255, 255, 255, true )
					end
				end
    end
)
 
 local v_doors = { [0]="door_lf_dummy", [1]="door_rf_dummy",  [2]="door_lr_dummy",  [3]="door_rr_dummy" }
 
addEventHandler("onClientVehicleExit", getRootElement(),
    function(thePlayer, seat)
		if seat == 0 then
			setVehicleEngineState ( source, false )
		end

    end
	
)



       function dxDrawBorderText(text,x,y,color,size,font,postgui,b_color,b_x,b_y)
                if text == nil then return end
                dxDrawText ( text, x, y , 0, 0, b_color, size, font, "left", "top",false, false, postgui )
                dxDrawText ( text, x+b_x, y-b_y , 0, 0, color, size, font, "left", "top",false, false, postgui )
        end     
        
        function dxDrawTextBackground(text,x,y,color,size,font,postgui, colored, lines, fix)
                
                
                
                dxDrawRectangle ( x-5, y-5, dxGetTextWidth ( fix  or text, size, font )+10 , (dxGetFontHeight ( size, font )*lines)+10, tocolor( 0, 0, 0, 150) )
                dxDrawText ( text, x, y , 0, 0, b_color, size, font, "left", "top",false, false, postgui, colored )
        end

        function dxDrawBorderTextColored(text, text2,x,y,color,size,font,postgui,b_color,b_x,b_y)
                dxDrawText ( text2 , x-b_x, y-b_x , 0, 0, b_color, size, font, "left", "top",false, false, postgui )
                dxDrawText ( text, x, y , 0, 0, color, size, font, "left", "top",false, false, postgui, true )
        end
        
        
        function dxDrawTextBoreder( textc, text, x, y , color, size, font, o )
        
                dxDrawText ( text, x-o, y-o , "left", "top", colors_g.black, size, font, "left","top", false, false, false, false )
                dxDrawText ( text, x, y-o , "left", "top", colors_g.black, size, font, "left","top", false, false, false, false )
                dxDrawText ( text, x+o, y+o , "left", "top", colors_g.black, size, font, "left","top", false, false, false, false )
                dxDrawText ( text, x, y+o , "left", "top", colors_g.black, size, font, "left","top", false, false, false, false )
                dxDrawText ( text, x-o, y+o , "left", "top", colors_g.black, size, font, "left","top", false, false, false, false )
                dxDrawText ( text, x+o, y-o , "left", "top", colors_g.black, size, font, "left","top", false, false, false, false )
                dxDrawText ( text, x-o, y , "left", "top", colors_g.black, size, font, "left","top", false, false, false, false )
                dxDrawText ( text, x+o, y , "left", "top", colors_g.black, size, font, "left","top", false, false, false, false )
                
                
                dxDrawText ( textc, x, y , "left", "top", color, size, font, "left","top", false, false, false, true )
        end
		
		
		
		    function dxDrawOutText ( text, x, y , color, size, font, o )
        
                dxDrawText ( text, x-o, y-o , "left", "top", colors_g.black, size, font )
                dxDrawText ( text, x, y-o , "left", "top", colors_g.black, size, font )
                dxDrawText ( text, x+o, y+o , "left", "top", colors_g.black, size, font )
                dxDrawText ( text, x, y+o , "left", "top", colors_g.black, size, font )
                dxDrawText ( text, x-o, y+o , "left", "top", colors_g.black, size, font )
                dxDrawText ( text, x+o, y-o , "left", "top", colors_g.black, size, font )
                dxDrawText ( text, x-o, y , "left", "top", colors_g.black, size, font )
                dxDrawText ( text, x+o, y , "left", "top", colors_g.black, size, font )
                
                
                dxDrawText ( text, x, y , "left", "top", color, size, font )
        end
		

		
		
		
		local framePerSec = getFPSLimit()
		local rev_size =  math.round( math.max( 1, math.min( 2, scalar*2 ) ), 1 )
		local nextUpdate = getTickCount(  ) + 1000
		local full_ver = "'BETA' r-"..getElementData( getElementByIndex ( "root_gm_element",0 ), "_revision" )
	--[[	addEventHandler( 'onClientRender', getRootElement(), function() 
		
															local x, y = 2 , 2
															dxTextDraw.shadow ( full_ver, x, y, colors_g.white, rev_size, 'default-bold' )
															
															local text = framePerSec
															x = screenWidth - dxGetTextWidth( text, rev_size, 'default-bold')-4
															dxDrawOutText  ( text , x, y, colors_g.green, rev_size, 'default-bold',2 )
															local net = getNetworkStats ( )	
																if getTickCount(  ) > nextUpdate then
																setElementData( localPlayer, 'FPS', text, true )
																setElementData( localPlayer, 'l%', string.format("%.0f", net.packetlossLastSecond ), true )
																nextUpdate = getTickCount(  ) + 1000
															end
															text =  ' Ping: '..getPlayerPing( localPlayer )..'  /  Packet Loss  [  total: '..math.round( net.packetlossTotal, 2 )..'%  |  last sec: '.. math.round( net.packetlossLastSecond, 2  )..'% ] '
															x = x - dxGetTextWidth( text, 1, 'clear')-20
															if not iSscoreboard then
																dxDrawRectangle( x, y, dxGetTextWidth( text, 1, 'clear'), dxGetFontHeight( 1, 'clear' ), tocolor( 0, 0, 120 ) )
																dxTextDraw.normal ( text , x, y, colors_g.white, 1, 'clear' )
															end
														end, false, 'low' )	]]	
														
		
		local framePerSeccalc = 0
		local framePerSec_count = getTickCount() + 1000
		 function countFrames() 
			if framePerSec_count  <  getTickCount() then
				framePerSec_count = getTickCount()  + 1000
				framePerSec = framePerSeccalc 
				framePerSeccalc = -1
			end
			framePerSeccalc=framePerSeccalc+1
		end
		addEventHandler( 'onClientRender', root, countFrames, false, 'high' )

	_infoR = {
			sizes = { math.min( 2, scaleInt( 768, 2 ) ), math.min( 1, scaleInt( 768, 1 ) ) },
			updatefreq = getTickCount(  ) + 1000
		}
	_infoR.fps = { x = screenWidth -dxGetTextWidth( '300', _infoR.sizes[ 1 ] , 'default'), y = math.min( 5, scaleInt( 1080, 5)) }

	_infoR.text = { txt = '', x = _infoR.fps.x - scaleByWidth ( 640, 10 )-dxGetTextWidth( '1000ms.', _infoR.sizes[ 1 ], 'default')-dxGetTextWidth( '0.03 %.', _infoR.sizes[ 2 ], 'default'), y = _infoR.fps.y }
	_infoR.text2 = { txt = '', x = _infoR.fps.x - scaleByWidth ( 640, 10 )-dxGetTextWidth( '0.030 %', _infoR.sizes[ 2 ], 'default'), y = _infoR.fps.y }
	_infoR.text3 = { txt = '', x = screenWidth , y = math.min( 50, scaleInt( 1080, 50)), box = 0 }
	setTimer( function () 
		_infoR.text3.txt = "BasicMode 'BETA' 1.0 bulid: "..getElementData( getElementByIndex ( "root_gm_element",0 ), "_revision" )..'\n'..getVersion ( ).name..' '..getVersion ( ).sortable..' ( netcode: '..getVersion ( ).netcode..' )\n\n'..getElementData( getElementByIndex ( "root_gm_element",0 ), 'vI')..'\n'..getElementData( getElementByIndex ( "root_gm_element",0 ), 'rI')
		_infoR.text3.x = screenWidth -dxGetTextWidth( _infoR.text3.txt ) -5
		_infoR.text3.y = screenHeight - dxGetFontHeight( )*5 -5
		_infoR.text3.box = screenWidth -5
	end, 3500, 1 )

	function render_someinfo( )
	
		dxTextDraw.shadow ( _infoR.text.txt, _infoR.text.x, _infoR.text.y, colors_g.rwhite, _infoR.sizes[ 1 ], 'default' )
		dxTextDraw.shadow ( _infoR.text2.txt, _infoR.text2.x, _infoR.text2.y, colors_g.rwhite, _infoR.sizes[ 2 ], 'default' )
		dxTextDraw.shadow ( framePerSec, _infoR.fps.x, _infoR.fps.y, colors_g.green, _infoR.sizes[ 1 ], 'default' )
			if getTickCount() > _infoR.updatefreq then
				_infoR.updatefreq = _infoR.updatefreq + 1000
				local net = getNetworkStats ( )	
				_infoR.text.txt = getPlayerPing( localPlayer )..'ms'
				_infoR.text2.txt = string.format( "%.2f", net.packetlossLastSecond )..' %\n'..string.format( "%.2f", net.packetlossTotal )..' %'
				_infoR.text2.x = _infoR.text.x + dxGetTextWidth( _infoR.text.txt..'.', _infoR.sizes[ 1 ], 'default')
					setElementData( localPlayer, 'FPS', framePerSec, true )
					setElementData( localPlayer, 'l%', string.format("%.2f", net.packetlossLastSecond ), true )

			end	
			if isConsoleActive () then
			--	dxTextDraw.shadow ( _infoR.text3.txt, _infoR.text3.x, _infoR.text3.y, colors_g.rwhite, 1, 'default' )	
				dxDrawText ( _infoR.text3.txt, _infoR.text3.x, _infoR.text3.y, _infoR.text3.box, 0, colors_g.rwhite, 1, "default", 'right')	
			end	
	end
	addEventHandler( 'onClientRender', root, render_someinfo, false, 'low-998' )	
		
		
	
	local _spectI_c = { x = math.cut( screenWidth*0.8 ), y = math.cut( screenHeight*0.3 ), size = math.max( 0.7, math.round( 1.5*scalar, 1) ) }
	local _spectating_you = {}

	 
			function detectSpect()
				if #_spectating_you > 0 then
					dxTextDraw.shadow ( 'Spectating you:\n\n'..table.concat( _spectating_you, "\n") , _spectI_c.x, _spectI_c.y, colors_g.white, _spectI_c.size, 'clear' )
				end	
				local _target_ = getCameraTarget ()
					if _target_ == localPlayer then
						setElementData( localPlayer, '0x9x1E', nil )
						return 0;
					end	
					
						if _target_ ~= false then
							setElementData( localPlayer, '0x9x1E', tonumber(  getElementData( _target_, "ID" ) ) )
							return 0;
						else
							local _ele_garb = {}
							local cam = { getCameraMatrix () }
							for k, v in pairs(  getElementsByType( "player" ), getRootElement(), true ) do 
								if v ~= localPlayer and isElementOnScreen( v ) then
									local x, y, z = getElementPosition( v )
										if getDistanceBetweenPoints2D( cam[1], cam[2], x, y ) < 40 then
											table.insert( _ele_garb, tonumber( getElementData( v, "ID" ) ) )
										end	
								end
							end
							setElementData( localPlayer, '0x9x1E', _ele_garb )
							return 0;
						end
				setElementData( localPlayer, '0x9x1E', nil )
			end
	addEventHandler ( "onClientRender", getRootElement(), detectSpect,false, "low-999" )
			
	
	addEventHandler ( "onClientElementDataChange", getRootElement(),
	
		function ( dataName, oldValue )
		
			if getElementType ( source ) == "player" and dataName == '0x9x1E' then
			
				local newValue = getElementData ( source, dataName )
					local localID = tonumber(  getElementData( localPlayer, "ID" ) )
				
						if type( newValue ) == 'table' then
						
							for k, v in pairs(  newValue ) do 
								if localID == tonumber(  v ) then
									table.insert( _spectating_you, getPlayerName( source ) )
									break
								end
							end
							
						elseif newValue == localID  then
							table.insert( _spectating_you, getPlayerName( source ) )
						end	
						
					
						if type( oldValue ) == 'table' then
						
							for k, v in pairs( oldValue ) do 
								if localID == tonumber(  v ) then
								
										local name_ = getPlayerName( source )
											for k1, v1 in pairs( _spectating_you ) do 
												if v1 == name_ then
													table.remove( _spectating_you, k1 )
													break
												end
											end
									
									break
								end
							end
							
						elseif oldValue == localID  then
								local name_ = getPlayerName( source )
									for k1, v1 in pairs( _spectating_you ) do 
										if v1 == name_ then
											table.remove( _spectating_you, k1 )
											break
										end
									end
						end	
						
				
			end
		end )	
		


	_initialLoaded( "hud_code.lua" )	

end		