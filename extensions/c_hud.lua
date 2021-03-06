
_initialLoading[ "extensions/c_hud.lua" ] = function ( )

_gloabl_aspectratio = 0

local _hud_bar = { }
	local screen_ratio =  screenWidth / screenHeight
	local screen_ratio_cache = { cache= 9999, vars = { {1.7777777777777777777777777777778,'16:9'},  {1.6,'16:10'},  {1.3333333333333333333333333333333,'4:3'},  {1.25, '5:4'},  } }
		for k, v in ipairs ( screen_ratio_cache.vars ) do 
			if math.abs( screen_ratio - v[1] ) <  screen_ratio_cache.cache then
			
				screen_ratio_cache.cache = math.abs( screen_ratio - v[1] )
				screen_ratio_cache.ratio = v[2]
			end	
			
		end
	local f_size = math.min( math.max(1, scaleInt(1080,1.3) ), 1.3 )
	local f_sizeAre =  math.min(1,   (screenWidth  * ( 1 / 1270 )  ) *1 )
	local frame_size = math.min( math.max(2, scaleInt(1080,6) ), 6 )
	if screen_ratio_cache.ratio == '16:9' then
		_hud_bar = { x = screenWidth*0.853125, y =  screenHeight*0.19907407, sizeX = screenWidth*0.096354, sizeY =  screenHeight*0.0259 }
		_hud_bar.textX =  _hud_bar.x  + _hud_bar.sizeX/2.5 + frame_size
		_hud_bar.textY =  _hud_bar.y + _hud_bar.sizeY - dxGetFontHeight( 1.35 , 'default-bold' )
	elseif	screen_ratio_cache.ratio == '4:3' then
		_hud_bar = { x = screenWidth*0.853125, y =  screenHeight*0.1484375, sizeX = screenWidth*0.097, sizeY =  screenHeight*0.01953125 }
		_hud_bar.textX =  _hud_bar.x  + _hud_bar.sizeX/2.5 + frame_size
		_hud_bar.textY =  _hud_bar.y + _hud_bar.sizeY - dxGetFontHeight( 1.35 , 'default-bold' )
	elseif	screen_ratio_cache.ratio == '16:10' then
		_hud_bar = { x = screenWidth*0.853125, y =  screenHeight*0.1788, sizeX = screenWidth*0.097, sizeY =  screenHeight*0.0244 }
		_hud_bar.textX =  _hud_bar.x  + _hud_bar.sizeX/2.5 + frame_size
		_hud_bar.textY =  _hud_bar.y + _hud_bar.sizeY - dxGetFontHeight( 1.35 , 'default-bold' )
	elseif	screen_ratio_cache.ratio == '5:4' then
		_hud_bar = { x = screenWidth*0.853125, y =  screenHeight*0.1396484375, sizeX = screenWidth*0.097, sizeY =  screenHeight*0.0185546875 }
		_hud_bar.textX =  _hud_bar.x  + _hud_bar.sizeX/2.5 + frame_size
		_hud_bar.textY =  _hud_bar.y + _hud_bar.sizeY - dxGetFontHeight( 1.35 , 'default-bold' )
	end
	_hud_bar.armor = { x = _hud_bar.x, y = _hud_bar.y - 2.5* _hud_bar.sizeY}
	_hud_bar.armor.textY = _hud_bar.armor.y + _hud_bar.sizeY - dxGetFontHeight( 1.45 , 'default-bold' )
	_hud_bar.area = { x = math.cut( scaleIntPercent( screenWidth, 6.25 ) ), y = math.cut( scaleIntPercent( screenHeight, 93.42) ) }
	_gloabl_aspectratio = screen_ratio_cache.ratio
	showPlayerHudComponent ( 'health', true )
	showPlayerHudComponent ( 'armour', true )


	function _hud_bar.render()
		if getCameraTarget() and ( getCameraTarget() == localPlayer or getCameraTarget() == getPedOccupiedVehicle ( localPlayer ) ) and not iSscoreboard then
			dxDrawRectangle ( _hud_bar.x, _hud_bar.y, _hud_bar.sizeX, _hud_bar.sizeY , tocolor( 0, 0, 0, 170 ))
					local hp = getElementHealth( localPlayer )
					
					local health = math.max(hp , 0)/100
					local p = -510*(health^2)
					local r,g = math.max(math.min(p + 255*health + 255, 255), 0), math.max(math.min(p + 765*health, 255), 0)
			 dxDrawImage ( _hud_bar.x+frame_size, _hud_bar.y+frame_size, _hud_bar.sizeX-frame_size*2, _hud_bar.sizeY-frame_size*2, 'img/bar.png' , 0, 0, 0, tocolor(r,g,0, 125) )
			 dxDrawImage ( _hud_bar.x+frame_size, _hud_bar.y+frame_size, (_hud_bar.sizeX-frame_size*2)*health, _hud_bar.sizeY-frame_size*2, 'img/bar.png' , 0, 0, 0, tocolor(r,g,0) )
			 dxDrawTextBaQ_c ( math.ceil(hp).."%", _hud_bar.textX  ,_hud_bar.textY  ,0, 0,  tocolor(r,g,0)  , 1.3 , 'default', colors_g.black)
				local armor = getPedArmor( localPlayer )
					if armor > 0 then
						dxDrawRectangle ( _hud_bar.armor.x, _hud_bar.armor.y, _hud_bar.sizeX, _hud_bar.sizeY , tocolor( 0, 0, 0, 170 ))
						dxDrawImage ( _hud_bar.armor.x+frame_size, _hud_bar.armor.y+frame_size, _hud_bar.sizeX-frame_size*2, _hud_bar.sizeY-frame_size*2, 'img/bar.png' , 0, 0, 0, tocolor(255,255,255, 125) )
						dxDrawImage ( _hud_bar.armor.x+frame_size, _hud_bar.armor.y+frame_size, (_hud_bar.sizeX-frame_size*2)*(armor/100), _hud_bar.sizeY-frame_size*2, 'img/bar.png' , 0, 0, 0, tocolor(255,255,255) )
						 dxDrawTextBaQ_c ( math.ceil(armor).."%", _hud_bar.textX  ,_hud_bar.armor.textY  ,0, 0,  tocolor(255,255,255)  , 1.3 , 'default', colors_g.black)
					end
		--[[		local x, y, z = getElementPosition( localPlayer )	
			local _zones = { getZoneName (x, y, z ), getZoneName (x, y, z, true ) }
				if _zones[1] == _zones[2] then
					dxTextDrawShadow ( _zones[1], _hud_bar.area.x, _hud_bar.area.y, colors_g.white, f_sizeAre, 'clear' )
				else
					dxTextDrawShadow ( _zones[1]..' ( '.._zones[2]..' )', _hud_bar.area.x, _hud_bar.area.y, colors_g.white, f_sizeAre, 'clear' )
				end	]]
		end
	end
--	addEventHandler ( "onClientRender", getRootElement(), _hud_bar.render, false, "low" )
	function renderHudOverlay( )
		if getCameraTarget() == localPlayer and isPlayerHudComponentVisible( 'health' ) then
		local hp, color = math.ceil( getElementHealth( localPlayer ) ), tocolor( 255, 255, 255 )

			dxDrawText (  hp.."%", _hud_bar.textX  ,_hud_bar.textY, 'left', 'top', color )
				
			local armord = math.ceil( getPedArmor( localPlayer ) )
				if armord > 0 then
					dxDrawText (  armord.."%", _hud_bar.textX  ,_hud_bar.armor.textY, 'left', 'top',  tocolor( 0, 0, 0 ) )

				end	
			-- dxDrawTextBaQ_c ( , _hud_bar.textX  ,_hud_bar.textY  ,0, 0,  colors_g.red  , 1.0 , 'default', colors_g.black)
		end
	end

	addEventHandler ( "onClientRender", getRootElement(), renderHudOverlay, false, "low" )

	local death_c = { y = math.ceil( screenHeight* 0.75), text = "Upps...", info_t = "", info_x= 0, info_y = math.ceil( screenHeight* 0.75) }
		death_c.fonts = { dxCreateFont ( "fonts/visitor.ttf",math.min( math.max(7, scaleInt(1080,11) ), 11 )) or "default-bold", dxCreateFont ( "fonts/TravelingTypewriter.ttf", math.min( math.max(16, scaleInt(1080,26) ), 26 ) ) or "bankgothic" }

		function findRotation(x1,y1,x2,y2)
		  local t = -math.deg(math.atan2(x2-x1,y2-y1))
		  if t < 0 then t = t + 360 end;
		  return t;
		end
		
	function getPositionFromDistanceRotation( x,y,z,obrot ,dystans )	
		obrot = obrot/180*3.14159265358979
		x = x - ( math.sin(obrot) * dystans )
		y = y + ( math.cos(obrot) * dystans )
		return x, y, z
	end
	
		local sm = {mov=0, time=0}


	local function camRender ()
		if getTickCount() > sm.time then
			destroyElement( sm.object1 )
			destroyElement( sm.object2 )
			removeEventHandler ( "onClientPreRender", getRootElement(), camRender )
			sm.moov = 0
			dxUpdateScreenSource ( death_c.source, true )
			sdasddsadsa(100)
				for k,v in ipairs ( getElementsByType ( "player" ) ) do       
					setPlayerNametagShowing ( v, false )      
				end
			addEventHandler ( "onClientHUDRender", getRootElement(), render_fall, false, "low" )
			setTimer( function () 
						sdasddsadsa(250)
						removeEventHandler ( "onClientRender", getRootElement(),death_crender )
						removeEventHandler ( "onClientHUDRender", getRootElement(), render_fall)
						setCameraTarget( localPlayer )
					--	destroyElement( death_c.fonts[1] )
					--	destroyElement( death_c.fonts[2] )
						destroyElement(  death_c.source )
						death_c.info_t = {}
						death_c.info_t2 = {}
						for k,v in ipairs ( getElementsByType ( "player" ) ) do       
							setPlayerNametagShowing ( v, true )      
						end
					end, 1700, 1 )
			return
		end
		local x1, y1, z1 = getElementPosition ( sm.object1 )
		local x2, y2, z2 = getElementPosition ( sm.object2 )
		setCameraMatrix ( x1, y1, z1, x2, y2, z2 )
	end
	 
	function MoveCamera ( x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time )
		if(sm.moov == 1) then return false end
		sm.object1 = createObject ( 1337, x1, y1, z1 )
		sm.object2 = createObject ( 1337, x1t, y1t, z1t )
		setElementAlpha ( sm.object1, 0 )
		setElementAlpha ( sm.object2, 0 )
		setObjectScale(sm.object1, 0.01)
		setObjectScale(sm.object2, 0.01)
		moveObject ( sm.object1, time, x2, y2, z2, 0, 0, 0, "InOutQuad" )
		moveObject ( sm.object2, time, x2t, y2t, z2t, 0, 0, 0, "InOutQuad" )
		sm.time = getTickCount() + time +50
		addEventHandler ( "onClientPreRender", getRootElement(), camRender )
		sm.moov = 1
		return true
	end

		
	
	
	
	
addEventHandler ( "onClientPlayerWasted", getRootElement(),
	function( killer, weapon, bodypart )
		if source == localPlayer then
			if killer and getElementType( killer ) == 'player' and killer ~= source then
				local cam_ = {}
				cam_[1],cam_[2],cam_[3] =  getPedBonePosition( localPlayer, 6 ) 
				cam_[7],cam_[8],cam_[9] =  getPedBonePosition( killer, 6 ) 
				if  getDistanceBetweenPoints3D(  cam_[1], cam_[2], cam_[3], cam_[7], cam_[8], cam_[9] ) < 60 then
					local rotation = findRotation(cam_[1],cam_[2],cam_[7],cam_[8])
					cam_[7],cam_[8],cam_[9] =  getPositionFromDistanceRotation( 	cam_[7],cam_[8],cam_[9] ,rotation ,-2.75 )	
					cam_[4],cam_[5],cam_[6] =  getPositionFromDistanceRotation( cam_[1],cam_[2],cam_[3] ,rotation ,1 )	
					cam_[10],cam_[11],cam_[12] =  getPositionFromDistanceRotation( 	cam_[7],cam_[8],cam_[9] ,rotation ,1 )	
					table.insert( cam_, 250 )
					death_c.info_t = { "Killed by '"..getPlayerName( killer ).."' ( "..math.ceil( getElementHealth( killer ) ) .." hp ).", "#ff0024Killed by #d2d2d2'"..getPlayerName( killer ).."' #ff0024( #d2d2d2"..math.ceil( getElementHealth( killer ) ) .." #ff0024hp )." }
					death_c.info_t2 = { "\n\n\n[Weapon]: '"..( getWeaponNameFromID( weapon ) or " - " ).."' [Distance]: ~".. math.ceil( getDistanceBetweenPoints3D(  cam_[1], cam_[2], cam_[3], cam_[7], cam_[8], cam_[9] )) .."m" , "\n\n\n#ff0024[Weapon]: #d2d2d2'"..( getWeaponNameFromID( weapon )  or " - " ).."' #ff0024[Distance]: #d2d2d2~".. math.ceil( getDistanceBetweenPoints3D(  cam_[1], cam_[2], cam_[3], cam_[7], cam_[8], cam_[9] )) .."m"}
					sdasddsadsa(100)
					death_c.source = dxCreateScreenSource ( screenWidth, screenHeight )
					addEventHandler ( "onClientRender", getRootElement(),death_crender )
					MoveCamera ( unpack( cam_ ) )
					
					death_c.text = ''
				else

					death_c.info_t = { "Killed by '"..getPlayerName( killer ).."' ( "..math.ceil( getElementHealth( killer ) ) .." hp ).", "#ff0024Killed by #d2d2d2'"..getPlayerName( killer ).."' #ff0024( #d2d2d2"..math.ceil( getElementHealth( killer ) ) .." #ff0024hp )." }
					death_c.info_t2 = { "\n\n\n[Weapon]: '"..( getWeaponNameFromID( weapon ) or " - " ).."' [Distance]: ~".. math.ceil( getDistanceBetweenPoints3D(  cam_[1], cam_[2], cam_[3], cam_[7], cam_[8], cam_[9] )) .."m" , "\n\n\n#ff0024[Weapon]: #d2d2d2'"..( getWeaponNameFromID( weapon )  or " - " ).."' #ff0024[Distance]: #d2d2d2~".. math.ceil( getDistanceBetweenPoints3D(  cam_[1], cam_[2], cam_[3], cam_[7], cam_[8], cam_[9] )) .."m"}
					death_c.text = ''
					death_c.source = dxCreateScreenSource ( screenWidth, screenHeight )
					addEventHandler ( "onClientRender", getRootElement(),death_crender )
					setTimer( function () 
					dxUpdateScreenSource ( death_c.source, true )
						sdasddsadsa(250)
						addEventHandler ( "onClientHUDRender", getRootElement(), render_fall, false, "low" )
						setTimer( function () 
									sdasddsadsa(250)
									removeEventHandler ( "onClientRender", getRootElement(),death_crender )
									removeEventHandler ( "onClientHUDRender", getRootElement(), render_fall)
								--	destroyElement( death_c.fonts[1] )
								--	destroyElement( death_c.fonts[2] )
									destroyElement(  death_c.source )
									setCameraTarget( localPlayer )
									death_c.info_t = {}
									death_c.info_t2 = {}
									
								end, 2000, 1 )
						end, 150, 1 )
				end
			else
					if killer == false and weapon == 6 and bodypart == 9 then
						return 0;
					end	
			
				local sweet_textts =   {"Uppss...","Oh, no!","HoHoHoho...","Perfectly suicide, my rate: 1/10 :D","Oh, no! Why you?","What a waste :(","You doing it better and better...", "You have a talent, to suicides..." }
				death_c.text = sweet_textts[math.random(1,#sweet_textts)]
				death_c.source = dxCreateScreenSource ( screenWidth, screenHeight )
				setTimer( function () 
				dxUpdateScreenSource ( death_c.source, true )
					sdasddsadsa(250)
					addEventHandler ( "onClientHUDRender", getRootElement(), render_fall, false, "low" )
					setTimer( function () 
								sdasddsadsa(250)
								removeEventHandler ( "onClientHUDRender", getRootElement(), render_fall)
								setCameraTarget( localPlayer )
								destroyElement(  death_c.source )
							end, 2000, 1 )
					end, 150, 1 )
			end
		elseif killer == localPlayer then
				local cam_ = {}
				cam_[1],cam_[2],cam_[3] =  getPedBonePosition( source, 6 ) 
				cam_[7],cam_[8],cam_[9] =  getPedBonePosition( localPlayer, 6 ) 
					death_c.info_t = { "You killed '"..getPlayerName( source ).."'",  "#ff0024You killed #d2d2d2'"..getPlayerName( source ).."'" }
					death_c.info_t2 = { "\n\n\nfrom distance: ~".. math.ceil( getDistanceBetweenPoints3D(  cam_[1], cam_[2], cam_[3], cam_[7], cam_[8], cam_[9] )) , "\n\n\n#ff0024from distance: ~#d2d2d2".. math.ceil( getDistanceBetweenPoints3D(  cam_[1], cam_[2], cam_[3], cam_[7], cam_[8], cam_[9] )) }
					addEventHandler ( "onClientRender", getRootElement(),death_crender )
					setTimer( function () 
									removeEventHandler ( "onClientRender", getRootElement(),death_crender )
									death_c.info_t = {}
									death_c.info_t2 = {}
							end, 2000, 1 )
		end
	end)
	
	function render_fall ( )
		dxDrawImage ( 0, 0, screenWidth, screenHeight, death_c.source )
		dxDrawImage ( 0, 0, screenWidth, screenHeight, death_c.source,  0, 0, 0, tocolor(255,0,0,50) )
		dxDrawTextBaQ_c ( death_c.text ,screenWidth ,death_c.y  ,0, 0,  colors_g.white  , 2 , 'default-bold', colors_g.black, 'center')
	end

	function death_crender( )
		dxDrawTextOutlineWcolor  ( death_c.info_t[1] ,screenWidth ,death_c.info_y  ,0, 0,  colors_g.white  , 1 , death_c.fonts[2], colors_g.black, 'center', death_c.info_t[2] )
		dxDrawTextOutlineWcolor  ( death_c.info_t2[1] ,screenWidth ,death_c.info_y  ,0, 0,  colors_g.white  , 1 , death_c.fonts[1], colors_g.black, 'center', death_c.info_t2[2])
	
	end
	
	callServer ( 'onPlayerClientScriptsLoaded', localPlayer )

	_initialLoaded( "extensions/c_hud.lua" )	

end	
