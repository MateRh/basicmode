
_initialLoading[ "spawn_selection.lua" ] = function ( )
	
	local sm = {mov=0, time=0}


	local function camRender ()
		if getTickCount() > sm.time then
			destroyElement( sm.object1 )
			destroyElement( sm.object2 )
			removeEventHandler ( "onClientPreRender", getRootElement(), camRender )
			sm.moov = 0
			return
		end
		local x1, y1, z1 = getElementPosition ( sm.object1 )
		local x2, y2, z2 = getElementPosition ( sm.object2 )
		setCameraMatrix ( x1, y1, z1, x2, y2, z2 )
	end
	 
	function smoothMoveCamera ( x1, y1, z1, x1t, y1t, z1t, x2, y2, z2, x2t, y2t, z2t, time )
		if(sm.moov == 1) then return false end
		sm.object1 = createObject ( 1337, x1, y1, z1 )
		sm.object2 = createObject ( 1337, x1t, y1t, z1t )
		setElementAlpha ( sm.object1, 0 )
		setElementAlpha ( sm.object2, 0 )
		setObjectScale(sm.object1, 0.01)
		setObjectScale(sm.object2, 0.01)
		moveObject ( sm.object1, time, x2, y2, z2, 0, 0, 0, "InOutQuad" )
		moveObject ( sm.object2, time, x2t, y2t, z2t, 0, 0, 0, "InOutQuad" )
		sm.time = getTickCount() + time - 50
		addEventHandler ( "onClientPreRender", getRootElement(), camRender )
		sm.moov = 1
		return true
	end

		
	
	
	
	function getScreenPositionByRelative(x,y)
		local nX,nY =x*screenWidth,y*screenHeight 
		return math.format(nX),math.format(nY)
	end

	function getScreenPositionByRelativeViaElement(x,y,element)
		local xE,yE = guiGetSize(element,false)
			local xsE,ysE = guiGetPosition(element,false)
			local nX,nY =x*xE,y*yE
		return math.format(nX+xsE),math.format(nY+ysE)
	end

	function getRelativeByScreenPosition(x,y)
		local nX,nY =x/screenWidth,y/screenHeight 
		return nX,nY
	end
	function getRelativeByScreenPositionViaElement(xxx,yyy,element)
		local xE,yE = guiGetSize(element,false)
		local nX,nY =xxx/xE,yyy/yE
		return nX,nY
	end

	function returnSizeFromResolution(h,s)
		local mn = s/h
		return tonumber(string.format("%.0f", (screenHeight)*mn))
	end

		local s_o_x,  s_o_y = scaleIntPercent(screenWidth,50), scaleIntPercent(screenHeight,50)
		local ox,oy = scaleIntPercent(screenWidth,10), scaleIntPercent(screenHeight,31)
		local px,py = scaleIntPercent(screenWidth,60), scaleIntPercent(screenHeight,31)
		local pyx = scaleIntPercent(screenHeight,55)
		local sizeDSDd = scaleIntPercent(screenHeight,5)
		--local distances ={ ( screenWidth -(x  + y)) /3 ,(( screenWidth -(x  + y)) /3 )*2+ x }
		local distances ={  screenWidth*0.95 -s_o_y , (screenHeight -s_o_y )*0.5}
		
		local img_spawn = { distances[1] +(  s_o_y / 4), distances[2] + s_o_y + ( ( ( s_o_y /2 )*0.18)/2 ), s_o_y /2, ( s_o_y /2 )*0.18 }
		local img_spawm_teammate = { distances[1] +(  s_o_y / 4 ), distances[2] + s_o_y + ( ( ( s_o_y /2 )*0.72)/2 ), s_o_y /2, ( s_o_y /2 )*0.18 }

        myScreenSource3 = dxCreateScreenSource ( s_o_x,  s_o_y )          -- Create a screen source texture which is 640 x 480 pixels
		dxUpdateScreenSource( myScreenSource3 ,false) 
		
	client_settings_t = {}	

	local _main_sel = { gui = { } }
		
local t_render = {}
spawn_select = {e=1,rot=0,add_z=2,fov=75,gui={}} -- sprawn selector i table
function renderBackground()

end

function onCreateSpawnPointSelector()

_localPlayer:updateStatus(  3, 3 )
addEventHandler ( "onClientClick", getRootElement(),  onClick_spawn_select )
--addEventHandler("onClientGUIClick", getRootElement(), onGuiClick_spawn_select)
_core_attack_selector()

		--local x,y,z =  getCamPos_cords_rot_dis(t_spw_a.ce[1],t_spw_a.ce[2],t_spw_a.ce[3],spawn_select.rot ,1)
		--setCameraMatrix (t_spw_a.spawns_t[t_spw_a.id][1],t_spw_a.spawns_t[t_spw_a.id][2],t_spw_a.spawns_t[t_spw_a.id][3]+spawn_select.add_z,x,y,z,0,spawn_select.fov )
end





function SmoothTransition(functionname,value,addvalue,timer,t)
spawn_select.e = 0
local time_to_render = (addvalue-value)/timer 
local start = getTickCount()
local final_ = addvalue
local current_ = value

	function renderSmoothTransition()
	--	current_ = current_ + time_to_render
		current_ =  value + (  getTickCount() -start)*time_to_render
		loadstring(functionname.." = "..current_)()
		--setCameraMatrix (t_spw_a.spawns_t[t_spw_a.id][1],t_spw_a.spawns_t[t_spw_a.id][2],t_spw_a.spawns_t[t_spw_a.id][3]+spawn_select.add_z,t_spw_a.ce[1],t_spw_a.ce[2],t_spw_a.ce[3],0,spawn_select.fov )
		local x,y,z =  getCamPos_cords_rot_dis(t_spw_a.ce[1],t_spw_a.ce[2],t_spw_a.ce[3],spawn_select.rot ,1 )
		setCameraMatrix (t_spw_a.spawns_t[t_spw_a.id][1],t_spw_a.spawns_t[t_spw_a.id][2],t_spw_a.spawns_t[t_spw_a.id][3]+spawn_select.add_z,x,y,z,0,spawn_select.fov )
			--if getTickCount() > 
			if t == 1 then
				if current_ >= final_ then
				removeEventHandler("onClientRender",getRootElement(),renderSmoothTransition)
				spawn_select.e = 1
				end
			else
				if current_ <= final_ then
				removeEventHandler("onClientRender",getRootElement(),renderSmoothTransition)
				spawn_select.e = 1
				end
			end

	end
	addEventHandler("onClientRender",getRootElement(),renderSmoothTransition)
end

local _base_rec = { screen_c = 0, screen = { dxCreateScreenSource ( screenWidth/4,  screenHeight/4 ), dxCreateScreenSource ( screenWidth/4,  screenHeight/4 ), dxCreateScreenSource ( screenWidth/4,  screenHeight/4 ) } }
 
 map_preStart = {}

 function preLoadMap(data, vehicles, resource)
	_event_class.main( 'map_start', 1 )
	_captureReset( )
		if _players[ localPlayer ]:getStatus( 2 ) == 1 then
			map_preStart.font = guiCreateFont ( "fonts/TravelingTypewriter.ttf",returnSizeFromResolution((1080),24)) 
				blur_remote( true, 2.5, true )

			hideHud()
			map_preStart.map_s = getTickCount()
			
			map_preStart.dxfont_size = returnSizeFromResolution(1080,6)

			
			map_preStart.positions = {txt1={scaleIntPercent(screenWidth,75),scaleIntPercent(screenHeight,90)},txt2={}}
		
			map_preStart.screenSource = dxCreateScreenSource(screenWidth,screenHeight)	
			showPlayerHudComponent("radar",false)
			
			client_settings_t = data
			client_settings_t.vehicles = vehicles
			map_preStart.dxfont = dxCreateFont ( "fonts/TravelingTypewriter.ttf", returnSizeFromResolution((1080),46)) or "bankgothic"
			map_preStart.infot =  guiCreateLabel ( 0, 0, 500, 50, "Loading...", false )
			while ( not ( map_preStart.font ) ) do
				map_preStart.font = guiCreateFont ( "fonts/TravelingTypewriter.ttf",returnSizeFromResolution((1080),24)) or 'sa-header'
			end
			guiSetFont( map_preStart.infot, map_preStart.font)
				guiSetPosition( map_preStart.infot, (screenWidth-guiLabelGetTextExtent ( map_preStart.infot ))/2,scaleIntPercent(screenHeight,92),false )
			_sdadsd_resource = resource
			addEventHandler( 'onClientRender', root, preLoadMapRSD )	
			_base_rec.screen_c = 0

		end
 end 
 

 
 function foceClose_preLoadMap()
	if not isElement( map_preStart.infot ) then return 0 end
		blur_remote( false )
		showHud( )
		showPlayerHudComponent("radar",true)
		destroyElement( map_preStart.infot )
		destroyElement( map_preStart.font )
		destroyElement( map_preStart.dxfont )
		destroyElement( map_preStart.screenSource )
		
	
 end
 
  function send_missingData(data, vehicles )
		client_settings_t = data
		client_settings_t.vehicles = vehicles
		local index_  =  getElementData( getElementByIndex ( "root_gm_element",0 ),"map_info" )
			map_preStart.map_type = index_[1]
			map_preStart.map_id =  index_[2]

		map_preStart.map_name = map_preStart.map_type..": "..map_preStart.map_id
  end

function preLoadMap_r()

	dxDrawImage ( 0, 0, map_preStart.black_b[1], map_preStart.black_b[2], "img/_up.png" )
	
	dxDrawImage ( 0, screenHeight - map_preStart.black_b[2], map_preStart.black_b[1], map_preStart.black_b[2], "img/_down.png" )
	
	dxDrawOutText ( map_preStart.map_name, map_preStart.positions.txt1[1],  map_preStart.positions.txt1[2], colors_.white,  1,  map_preStart.dxfont, map_preStart.dxfont_size )
	
	dxDrawOutText ( map_preStart.info1, map_preStart.positions.txt2[1],  map_preStart.positions.txt2[2], colors_.white,  0.5,  map_preStart.dxfont, math.ceil(  map_preStart.dxfont_size / 2 ) )

	local x,y, z = map_preStart.camCenter[1], map_preStart.camCenter[2], map_preStart.camCenter[3]
	local x1, y1 = getScreenFromWorldPosition( x,y, z )
	local x2, y2 = getScreenFromWorldPosition( x,y, z +2.5)
		if x1 and y1 and x2 and y2 then
			dxDrawLine ( x1, y1, x2, y2, tocolor( 255, 0 , 0 ), 3 )
		end	
	x1, y1 = getScreenFromWorldPosition( x,y, z )
	x2, y2 = getScreenFromWorldPosition( x+1.25,y, z)
		if x1 and y1 and x2 and y2 then
			dxDrawLine ( x1, y1, x2, y2, tocolor( 0, 255 , 0 ), 3 )
		end
	x1, y1 = getScreenFromWorldPosition( x,y, z )
	x2, y2 = getScreenFromWorldPosition( x,y+1.25, z)
		if x1 and y1 and x2 and y2 then
			dxDrawLine ( x1, y1, x2, y2, tocolor( 0, 0 , 255 ), 3 )
		end

end

function preLoadMapRSD()
	local res = getResourceFromName( _sdadsd_resource )
		if res then
				local map_root = getResourceRootElement ( res)
					if map_root then
					
						local e_ = getElementsByType ( "Central_Marker",map_root )[1]
						math.randomseed(  getRealTime( ).timestamp )
						local x, y, z = getElementData( e_, "posX") +math.random( -15, 15 ), getElementData( e_, "posY") +math.random( -15, 15 ), getElementData( e_, "posZ") +math.random( 0, 15 )
						setCameraMatrix(x, y, z + 50, x, y, z  )

					removeEventHandler( 'onClientRender', root, preLoadMapRSD )

					end
	end
end


 function randomize(t)
local t_r = {}
	 for i=1,#t do
		local random_ = math.random(1,#t)
		t_r[i] = t[random_]
		table.remove(t,random_)
	end	
	return t_r
end
 local l_range_ = {}
 
		function onMapLoadForceEnd( )
			if _players[ localPlayer ]:getStatus( 3 ) == 8 then
				if isTimer(  map_preStart.cam_timer ) then killTimer( map_preStart.cam_timer  ) end
				if isTimer(  map_preStart.timer_to_kill ) then killTimer( map_preStart.timer_to_kill  ) end
				if isTimer(  map_preStart.timer_1 ) then killTimer( map_preStart.timer_1  ) end
				if isTimer(  map_preStart.timer_2 ) then killTimer( map_preStart.timer_2  ) end
				removeEventHandler("onClientPreRender",getRootElement(),preLoadMap_r)
				if isElement( map_preStart.font ) then destroyElement(map_preStart.font) end
				if isElement( map_preStart.dxfont ) then destroyElement(map_preStart.dxfont)  end
				disableBoundSystem( )
				destroyInteriorsSystem(  )
				 map_preStart = {}
				 setCameraTarget( localPlayer )
			end
		end
 
 
 
		function onMapLoad( res )

			if _players[ localPlayer ]:getStatus( 2 ) == 1 then
			
				if res ~= getThisResource() then
				
				local r_type = getElementData( getElementByIndex ( "root_gm_element",0 ) , "map_info")[1] 
				
					if r_type == "Lobby" then
						return 
					end	
					
				local res_full_name = getResourceName(res)
				if 	string.find(res_full_name,"arena_") == nil and string.find(res_full_name,"base_") == nil and string.find(res_full_name,"bomb_") == nil then
					return false
				end
					if string.find(res_full_name,"arena") then 
						map_preStart.map_type = "Arena"
						map_preStart.map_id = string.gsub(res_full_name, "arena_", "") 
					elseif string.find(res_full_name,"base") then
						map_preStart.map_type = "Base"
						map_preStart.map_id =   string.gsub(string.gsub(res_full_name, "base_", ""), "_bm", "") 
					end				
					map_preStart.map_name = map_preStart.map_type..": "..map_preStart.map_id
					_players[ localPlayer ]:updateStatus(  3, 8 )	
					setElementInterior( localPlayer, getElementData( getElementByIndex ( "root_gm_element",0 ), "interior" ) or 0 ) 
						if getElementInterior( localPlayer) ~= 0 then
							setSkyGradient (  )
						end

					local m_root = getElementsByType ( "Central_Marker",getRootElement() )[1] 
						map_preStart.camCenter = { getElementData( m_root, "posX" ), getElementData( m_root, "posY" ), getElementData( m_root, "posZ" ) }
						
						map_preStart.object =  createMarker ( map_preStart.camCenter[1], map_preStart.camCenter[2], map_preStart.camCenter[3], "cylinder", 2)
						setElementInterior( map_preStart.object,  getElementData( getElementByIndex ( "root_gm_element",0 ), "interior" ) or 0 ) 
						addEventHandler( "onClientElementStreamIn", map_preStart.object, map_load_Stream )
						map_preStart.objectTickCount = getTickCount() + 1000
						setElementAlpha( map_preStart.object, 0 )
						bringBoundSystem( )	
						bringInteriorsSystem( res )
						
				end
			end	
		end
		addEventHandler ( "onClientResourceStart", getRootElement(), onMapLoad)
		
		function map_load_Stream ()
			local _ex_time = 50
			if getTickCount() < map_preStart.objectTickCount then
				_ex_time = _ex_time  +  ( getTickCount() - ( map_preStart.objectTickCount - 1000 ) )
			end
			removeEventHandler( "onClientElementStreamIn", map_preStart.object, map_load_Stream )
				destroyElement( map_preStart.object )
				setTimer( function()

					map_preStart.main_c_timer = setTimer( _onSecCoundtown, 1000, 0 )
					map_preStart.excude_c = 0
				end, _ex_time, 1 )	
		
		end
		
		function _onSecCoundtown()
			if client_global_settings.coundtdown - map_preStart.excude_c <= 0 then
							--	dxUpdateScreenSource( _base_rec.screen, true )
								killTimer( map_preStart.main_c_timer  )

								_slot8_garb = false
							
									sdasddsadsa( 1000 )
									removeEventHandler("onClientPreRender",getRootElement(),preLoadMap_r)
									destroyElement(map_preStart.font)
									destroyElement(map_preStart.dxfont) 
									
									onPlayerRequestSpawn(getPlayerTeam(localPlayer))
									--setCameraTarget( localPlayer )

				return 0
			elseif client_global_settings.coundtdown - map_preStart.excude_c <= 3 and client_global_settings.coundtdown - map_preStart.excude_c >= 1  then
				_base_rec.screen_c = _base_rec.screen_c +1
				dxUpdateScreenSource( _base_rec.screen[ _base_rec.screen_c  ], true ) 
			elseif map_preStart.excude_c == 0  then

					sdasddsadsa( 100 )
					map_preStart.black_b = { screenWidth, scaleIntPercent( screenHeight,25) }
					map_preStart.info1 = ""
					map_preStart.positions.txt2 = { ( screenWidth- dxGetTextWidth ( map_preStart.info1,  0.5, map_preStart.dxfont ))/2,scaleIntPercent(screenHeight,4) }
					addEventHandler("onClientPreRender",getRootElement(),preLoadMap_r)
					destroyElement( map_preStart.infot )
					blur_remote( false )
				
			end
			map_preStart.info1 = "Map will starts in: "..tostring( ( client_global_settings.coundtdown) - map_preStart.excude_c )
			map_preStart.positions.txt2 = { ( screenWidth- dxGetTextWidth ( map_preStart.info1,  0.5, map_preStart.dxfont ))/2,scaleIntPercent(screenHeight,4) }
			map_preStart.excude_c = map_preStart.excude_c + 1
			playSound ( "sounds/beep.wav" )
			
			local cam_cache = { { getCameraMatrix() }, { findClearWay( ) }} 


			smoothMoveCamera ( cam_cache[1][1], cam_cache[1][2], cam_cache[1][3], cam_cache[1][4], cam_cache[1][5], cam_cache[1][6], cam_cache[2][1], cam_cache[2][2], cam_cache[2][3], cam_cache[2][4], cam_cache[2][5], cam_cache[2][6], 950 )
		
		end
		
		
		addCommandHandler('infobase', 
			function( cmd, a1 )
					if not _base_rec.active then
						addEventHandler("onClientRender",getRootElement(), _base_rec.render )
						_base_rec.active = true
						_base_rec.tc = getTickCount() + 5000 
						_base_rec.a = 1 
							if tonumber( a1 ) then
								_base_rec.tc_close = getTickCount() + a1*1000
							end
					else
						removeEventHandler("onClientRender",getRootElement(), _base_rec.render )
						_base_rec.active = false
						_base_rec.tc_close = nil
					end
				end 
			)

		function _base_rec.render( )
			if getTickCount() >  _base_rec.tc then
				_base_rec.tc = getTickCount() + 5000
				_base_rec.a = _base_rec.a + 1
					if _base_rec.a > 3 then
						_base_rec.a = 1 
					end	
			end
			dxDrawRectangle ( screenWidth / 4 - 2, screenHeight / 1.45 - 2, screenWidth / 4 +4, screenHeight / 4 +4, tocolor( 0, 0, 0 ) )
			dxDrawImage ( screenWidth / 4, screenHeight / 1.45, screenWidth / 4, screenHeight / 4, _base_rec.screen[ _base_rec.a ] )
				if _base_rec.tc_close and  getTickCount() > _base_rec.tc_close  then
						removeEventHandler("onClientRender",getRootElement(), _base_rec.render )
						_base_rec.active = false
						_base_rec.tc_close = nil
				end
		end

		function onPlayerRequestSpawn(team)
			local round_type = getElementData(getElementByIndex ( "root_gm_element",0 ),"map_info")
			local team_type = getElementData(team,"t_type")
				if round_type[1] == "Base" then 
						callServer("countdown_sync_request",localPlayer)
					if team_type == "Attack" then
						callServer("spawnOnRound",localPlayer,team)
						onCreateSpawnPointSelector()
					elseif team_type == "Defense" then
						callServer("spawnOnRound",localPlayer,team)
						onWeaponSelector( true )
						showHud()
						changeHudFunctionality( "base", map_preStart.map_name )
					else
						showHud()
						changeHudFunctionality( "base", map_preStart.map_name )
						_players[ localPlayer ]:updateStatus(  2, 3 )	
						enabledSpectate( 1000 )
					end
				elseif round_type[1] == "Arena" then
					if team_type == "Spectator" then
						callServer("countdown_sync_request",localPlayer)
						showHud()
						changeHudFunctionality( "base", map_preStart.map_name )
						_players[ localPlayer ]:updateStatus(  2, 3 )
						enabledSpectate( 1000 )
					else
						callServer("spawnOnRound",localPlayer,team)
						onWeaponSelector( true )
						callServer("countdown_sync_request",localPlayer)
						showHud()
						changeHudFunctionality( "base", map_preStart.map_name )
					end	
				elseif round_type[1] == "Bomb" then
				
				elseif round_type[1] == "Lobby" then
				
				end

				
				
		end
 
 function mapPreStart_r()
	dxUpdateScreenSource( map_preStart.screenSource )
	dxDrawImage( 0,  0,  screenWidth,screenHeight, map_preStart.screenSource,0,0,0,tocolor(255,255,255,125) )
 end
 

 function differenceInPercent( a, b )
	return math.abs ( 100 - ( a / b ) *100 )
 end

  
local _debug_Lines = {}

 
 function findClearWay( )
-- if ( getElementData( getElementByIndex ( "root_gm_element",0 ), "interior" ) or 0 ) 
	local x, y, z = unpack( map_preStart.camCenter )
	local _clear = false
	local x1, y1, z1
	math.randomseed(  getRealTime( ).timestamp   )
	--h = math.min( h, 110 )
	local _count = getTickCount() + 199
	local tX, tY, tZ
		while(  _clear == false ) do
	
			x1, y1, z1 =  getCamPos_cords_rot_dis( x, y, z + math.random( 2, 90 ),  math.random( 0, 360 ) , math.random( 9.5, 85.5 ) )
			tX, tY, tZ = calc_vector( x, y, z, x1, y1, z1, -0.2 )
		--	_clear = isLineOfSightClear ( x, y, z, tX, tY, tZ )
			_clear = isLineOfSightClear ( x1, y1, z1, tX, tY, tZ )
	--		table.insert( _debug_Lines, { x1, y1, z1, tX, tY, tZ , tocolor( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ) ), 3 } ) 
				if getTickCount() > _count then
					_clear  = true
				end	
		end		
		
		
		return x1, y1, z1, x, y, z
 end
 
 function calc_vector(x1,y1,z1,x2,y2,z2,extension)
local dis_t = {x1+((x1-x2)*extension),y1+((y1-y2)*extension),z1+((z1-z2)*extension)}
	return unpack(dis_t)
end
 --[[
addEventHandler( 'onClientRender', getRootElement(), function () 
	for k, v in pairs ( _debug_Lines ) do 
	
		dxDrawLine3D ( unpack ( v ) )
	end

end )

]]
	function licz(a,m )
		if m == 1 then
			return math.abs(( a * 0.256 ) + 768 )* (-1)
		else
			return ( a * 0.256 ) - 768
		end
	end	

--b 0.0018 5.2 0.025

	 
function _core_attack_selector()
	wasFrozenBefore = isElementFrozen( localPlayer )
	callServer( 'setElementFrozen', localPlayer, true )
	callServer( 'setElementAlpha', localPlayer, 0 )
	callServer( 'setElementCollisionsEnabled', localPlayer, false )

	t_spw_a = {r_anim = { rot=0,}, cache_i = {} ,tc=getTickCount(),a_gui={},id=1,anim=1,r_time=false,r_team=1,team=0,slot = 2,target={},scale_ = {348,409,220,35,65,440,0.15,14,202},spawns_t={},spw_r ={},tc=getTickCount(),ce={} }
		setElementInterior( localPlayer, 0 )
		resetSkyGradient( )
		t_spw_a.target = dxCreateRenderTarget( 600, 600 ) 
			local _compresion = 'dxt5'
				if dxGetStatus ( ).VideoMemoryFreeForMTA > 15 then
					_compresion = "argb"
				end
		t_spw_a.texture = dxCreateTexture ( "img/map.jpg", _compresion )
		t_spw_a.spawns = getElementsByType ( 'spwn_',getRootElement())
		t_spw_a.s_data = {}
		local marker_o = getElementsByType ( "Central_Marker",getRootElement() ) 
		local marker_t ={getElementData(marker_o[1], "posX"),getElementData(marker_o[1], "posY"),getElementData(marker_o[1], "posZ")}
		t_spw_a.ce = marker_t
		t_spw_a.pos_r = {licz(  tonumber(marker_t[1]),1),licz(  tonumber(marker_t[2]),2)}
		t_spw_a.pos_w = {(screenWidth/2)+ (((screenWidth/2)-600)/2),(screenHeight-600)/2}
			for k,v in ipairs(t_spw_a.spawns) do
				t_spw_a.spawns_t[k] = {getElementData(v, "posX"),getElementData(v, "posY"),getElementData(v, "posZ")+0.75,getElementData(v, "mode")}
				t_spw_a.spw_r[k] = {300-((tonumber(marker_t[1]) - tonumber ( t_spw_a.spawns_t[k][1] ))*0.256),300+((tonumber(marker_t[2]) - tonumber ( t_spw_a.spawns_t[k][2] ))*0.256)}
		--		table.insert( t_spw_a.cache_i, k, guiCreateStaticImage ( distances[1]+ ( t_spw_a.spw_r[k][1]-64),  distances[2]+(t_spw_a.spw_r[k][2]-64)*1.09,64, 64, "img/capture_bar.png", false))
				
			end
	--	enableDoFBokeh()
	--	setEffectVariables( 150 )
				addEventHandler( "onClientRender", getRootElement(),_core_attack_selector_r )

				showCursor(true)
end


	function waitForMate(  )
		local width = dxGetTextWidth( 'Waiting for player select spawn and vehicle, to back press ESC', 2, "default")
		local higth = dxGetFontHeight( 2, 'default' )

		dxDrawRectangle( ( screenWidth- (width + higth*2) )/2, (screenHeight- higth*2 )/2, width + higth*2, higth*2, tocolor(42,68,105, 75 ) ) 
		dxTextDrawShadow (  'Waiting for player select spawn and vehicle, to back press ESC', ( screenWidth- width )/2, (screenHeight- higth )/2, tocolor( 255, 255, 255 ), 2, 'default', 1  ) 
		
			if getKeyState( 'ESC' ) then
				sdasddsadsa()
				removeEventHandler( 'onClientRender', getRootElement(  ), waitForMate )
				blur_remote( false )
				killTimer( _main_sel.gui.timer )
					removeEventHandler ( "onClientGUIClick", _main_sel.gui.spawn, onClickButtonTeamSpawn )
					removeEventHandler ( "onClientGUIClick", _main_sel.gui.back, onClickButtonTeamSpawn )
					removeEventHandler ( "onClientGUIClick", _main_sel.gui.gridlist, onClickButtonTeamSpawn )
				destroyElement( _main_sel.gui.tabPanel )
				_main_sel.gui = {}
				onCreateSpawnPointSelector()
				return 0
			end	

		local player = _main_sel.player

						if ( _players[ player ]:getStatus( 2 ) == 2 or _players[ player ]:getStatus( 3 ) == 10 ) and getPedOccupiedVehicle( player ) then
								
								
								callServer( 'setElementAlpha', localPlayer, 255 )
								callServer( 'setElementCollisionsEnabled', localPlayer, true )	
								setCameraTarget( player )
								removeEventHandler( 'onClientRender', getRootElement(  ), waitForMate )
								showHud()
								changeHudFunctionality( "base", map_preStart.map_name )
								callServer("spawnOnRound",localPlayer, getPlayerTeam( localPlayer ), false, false )
								--warpPedIntoVehicle( localPlayer, getPedOccupiedVehicle( player ) )
								setCameraTarget( player )
								local x, y,  z = getElementPosition( player )
								setElementPosition( localPlayer, x, y,  z )
								setElementFrozen( localPlayer, true )
								sdasddsadsa()
								setTimer( function ( ) 	
									callServer( 'warpPedIntoVehicle', localPlayer, getPedOccupiedVehicle( player ), #getVehicleOccupants ( getPedOccupiedVehicle( player ) ) + 1  )
									setTimer( onWeaponSelector, 500, 1, true )
								
									setElementFrozen( localPlayer, false )
								end, getPlayerPing( localPlayer ) + 100, 1 )	
						end 	
			

	end	
	

	function onClickButtonTeamSpawn(  )
					


		if source == _main_sel.gui.spawn then
			local playerName
					if guiGridListGetSelectedItem ( _main_sel.gui.gridlist ) ~= -1 then
						playerName = guiGridListGetItemText ( _main_sel.gui.gridlist, guiGridListGetSelectedItem ( _main_sel.gui.gridlist ), 1 )
					end	
						if playerName then
							local player = getPlayerFromName( playerName )
									killTimer( _main_sel.gui.timer )
									removeEventHandler ( "onClientGUIClick", _main_sel.gui.spawn, onClickButtonTeamSpawn )
									removeEventHandler ( "onClientGUIClick", _main_sel.gui.back, onClickButtonTeamSpawn )
									removeEventHandler ( "onClientGUIClick", _main_sel.gui.gridlist, onClickButtonTeamSpawn )
									destroyElement( _main_sel.gui.tabPanel )
									_main_sel.gui = {}

								if ( _players[ player ]:getStatus( 2 ) == 2 or _players[ player ]:getStatus( 3 ) == 10 ) and getPedOccupiedVehicle( player ) then
										sdasddsadsa()
										showHud()
										changeHudFunctionality( "base", map_preStart.map_name )
									--	callServer("spawnOnRound",localPlayer, getPlayerTeam( localPlayer ), false, false )
										--warpPedIntoVehicle( localPlayer, getPedOccupiedVehicle( player ) )

										local x, y,  z = getElementPosition( player )
										setElementPosition( localPlayer, x, y,  z )
										setElementFrozen( localPlayer, true )
										
										setTimer( function ( ) 	
											callServer( 'warpPedIntoVehicle', localPlayer, getPedOccupiedVehicle( player ), #getVehicleOccupants ( getPedOccupiedVehicle( player ) ) + 1  )
											setTimer( onWeaponSelector, 500, 1, true )
											setElementFrozen( localPlayer, false )
										end, getPlayerPing( localPlayer ) + 100, 1 )	

								else 
									_main_sel.player = player
									addEventHandler( 'onClientRender', getRootElement(  ), waitForMate )

								end	
						end 	


			

		elseif source == _main_sel.gui.back then
			sdasddsadsa()
			blur_remote( false )
			killTimer( _main_sel.gui.timer )
				removeEventHandler ( "onClientGUIClick", _main_sel.gui.spawn, onClickButtonTeamSpawn )
				removeEventHandler ( "onClientGUIClick", _main_sel.gui.back, onClickButtonTeamSpawn )
				removeEventHandler ( "onClientGUIClick", _main_sel.gui.gridlist, onClickButtonTeamSpawn )
			destroyElement( _main_sel.gui.tabPanel )
			_main_sel.gui = {}
			onCreateSpawnPointSelector()
		else
			local playerName
			if guiGridListGetSelectedItem ( _main_sel.gui.gridlist ) then
				playerName = guiGridListGetItemText ( _main_sel.gui.gridlist, guiGridListGetSelectedItem ( _main_sel.gui.gridlist ), 1 )
			end	
				if playerName then
					local player = getPlayerFromName( playerName )
						if ( _players[ player ]:getStatus( 2 ) == 2 or _players[ player ]:getStatus( 3 ) == 10 ) then
							setCameraTarget( player )
						end	
				end 	
		end

	end

	function onSecoundUpdate( )
		local playerName
		if guiGridListGetSelectedItem ( _main_sel.gui.gridlist ) then
			playerName = guiGridListGetItemText ( _main_sel.gui.gridlist, guiGridListGetSelectedItem ( _main_sel.gui.gridlist ), 1 )
		end	
		guiGridListClear ( _main_sel.gui.gridlist )

		for k, v in ipairs( getPlayersInTeam( getTeamByType( "Attack" ) )) do 
			if v ~= localPlayer then

				 local row = guiGridListAddRow ( _main_sel.gui.gridlist )
	           	 guiGridListSetItemText ( _main_sel.gui.gridlist, row, 1, getPlayerName ( v ), false, false )

	           	 local _info = 'this player selecting spawn or vehicle'
	           	 	if getPedOccupiedVehicle( v ) then
	           	 		_info = 'In vehicle: '..tostring( getVehicleName( getPedOccupiedVehicle( v ) ) )	
	           	 	end
	           	 		
	           	 guiGridListSetItemText ( _main_sel.gui.gridlist, row, 2, _info, false, false )
	           	 	if playerName and playerName == getPlayerName( v ) then
	           	 		guiGridListSetSelectedItem( _main_sel.gui.gridlist, row, 1 )
	           	 	end	
	        end	 	
		end	

	end		




	function onClick_spawn_select( b, s, x, y )
		if s == "down" then
			return
		end

		if x > img_spawm_teammate[1] and x < img_spawm_teammate[1]+img_spawm_teammate[3] and y > img_spawm_teammate[2] and y < img_spawm_teammate[2]+img_spawm_teammate[4] then

				sdasddsadsa()
				removeEventHandler( "onClientRender", getRootElement(),_core_attack_selector_r )
				removeEventHandler("onClientClick", getRootElement(), onClick_spawn_select)
				destroyElement( t_spw_a.target )
				destroyElement( t_spw_a.texture )
				t_spw_a = { }
				blur_remote( true, 3 )
				_main_sel.gui.tabPanel = guiCreateTabPanel ((screenWidth-620)/2, (screenHeight-460)/2, 620, 460, false )
				_main_sel.gui.window = guiCreateTab ( 'Spawn on your teammate:', _main_sel.gui.tabPanel )
				_main_sel.gui.gridlist = guiCreateGridList ( 0.03, 0.025, 0.94, 0.875, true, _main_sel.gui.window )
				guiGridListAddColumn ( _main_sel.gui.gridlist, 'Name', 0.3 )
				guiGridListAddColumn ( _main_sel.gui.gridlist, 'Information', 0.6 )

					for k, v in ipairs( getPlayersInTeam( getTeamByType( "Attack" ) )) do 
						if v ~= localPlayer then
					
						 local row = guiGridListAddRow ( _main_sel.gui.gridlist )
                       	 guiGridListSetItemText ( _main_sel.gui.gridlist, row, 1, getPlayerName ( v ), false, false )

                       	 local _info = 'this player selecting spawn or vehicle'
                       	 	if getPedOccupiedVehicle( v ) then
                       	 		_info = 'In vehicle: '..tostring( getVehicleName( getPedOccupiedVehicle( v ) ) )	
                       	 	end
                       	 		
                       	 guiGridListSetItemText ( _main_sel.gui.gridlist, row, 2, _info, false, false )
                       	 end	
					end	
				_main_sel.gui.spawn = guiCreateButton( 0.03, 0.92, 0.445, 0.05, 'spawn on this player', true, _main_sel.gui.window )
				_main_sel.gui.back = guiCreateButton( 0.505, 0.92, 0.445, 0.05, 'back to previous menu', true, _main_sel.gui.window )
				_main_sel.gui.timer = setTimer( onSecoundUpdate, 1000, 0 )
				addEventHandler ( "onClientGUIClick", _main_sel.gui.spawn, onClickButtonTeamSpawn, false )
				addEventHandler ( "onClientGUIClick", _main_sel.gui.back, onClickButtonTeamSpawn, false )
				addEventHandler ( "onClientGUIClick", _main_sel.gui.gridlist, onClickButtonTeamSpawn, false )
				return
		end	
		if x > img_spawn[1] and x < img_spawn[1]+img_spawn[3] and y > img_spawn[2] and y < img_spawn[2]+img_spawn[4] then
			sdasddsadsa()
				showHud()
				changeHudFunctionality( "base", map_preStart.map_name )
					local x,y,z = t_spw_a.spawns_t[t_spw_a.id][1],t_spw_a.spawns_t[t_spw_a.id][2],t_spw_a.spawns_t[t_spw_a.id][3]
--					callServer("spawnOnRound",localPlayer, getPlayerTeam( localPlayer ), false, false )
					removeEventHandler( "onClientRender", getRootElement(),_core_attack_selector_r )
					removeEventHandler("onClientClick", getRootElement(), onClick_spawn_select)
					destroyElement( t_spw_a.target )
					destroyElement( t_spw_a.texture )
					t_spw_a = { }
					showCursor(false)
				createVehicleSelector(x,y,z+2 )
			return true
		end
			local mtx = s_o_y/600
				for k,v in pairs( t_spw_a.spw_r ) do
					local f, g = distances[1] + v[1]*mtx,( distances[2] ) +v[2]*mtx
					if x > f - 32 and x < f+32 and y > g - 32 and y < g+32 then
						sdasddsadsa()
						t_spw_a.id = k
						return true
					end
				end
	end

	function forceClose_spawn_select( )
		if not isElement( t_spw_a.target ) then return 0 end
		removeEventHandler( "onClientRender", getRootElement(),_core_attack_selector_r )
		removeEventHandler("onClientClick", getRootElement(), onClick_spawn_select)
		destroyElement( t_spw_a.target )
		t_spw_a = { }
	end
	 
	
	 
setMinuteDuration (100000000 )	 
	 
	 t_spw_a = {tc=getTickCount(),a_gui={},id=1,anim=1,r_time=false,r_team=1,team=0,slot = 2,target={},scale_ = {348,409,220,35,65,440,0.15,14,202},spawns_t={},spw_r ={},tc=getTickCount(),ce={} }
	 		function _core_attack_selector_r()
				dxSetRenderTarget( t_spw_a.target )                  
				dxDrawRectangle(0,0,600,600,tocolor(42,68,105 ))
				dxDrawImage ( t_spw_a.pos_r[1]+300, t_spw_a.pos_r[2]+300, 1536, 1536, t_spw_a.texture )
				dxDrawImage (  300-16, 300-16, 32, 32, "img/flag.png" )
					for k,v in pairs(t_spw_a.spw_r) do
						if k ~= t_spw_a.id then
							dxDrawImage (  v[1]-16, v[2]-16,32, 32, "img/mark_w.png") 
						else
							dxDrawImage (  v[1]-16, v[2]-16,32, 32, "img/mark.png")
						end
					end
				
				dxSetRenderTarget()   
				dxDrawRectangle(distances[1]-3,distances[2]-3, s_o_y+6,  s_o_y+6, tocolor(245, 245 ,245 ))	
				dxDrawImage(distances[1],distances[2],   s_o_y,  s_o_y, t_spw_a.target ,0,0,0,tocolor(255,255,255) ) 
				dxDrawImage( img_spawn[1], img_spawn[2],   img_spawn[3], img_spawn[4], 'img/scoreboard/background_9.png' ,0,0,0,tocolor(255,255,255) ) 
				dxDrawText ( "Spawn", img_spawn[1], img_spawn[2] , img_spawn[1]+img_spawn[3],  img_spawn[2]+img_spawn[4], tocolor( 25,25,25), 1, "default-bold", "center", "center" )

				dxDrawImage( img_spawm_teammate[1], img_spawm_teammate[2],   img_spawm_teammate[3], img_spawm_teammate[4], 'img/scoreboard/background_9.png' ,0,0,0,tocolor(255,255,255) ) 
				dxDrawText ( "Spawn on teammate!", img_spawm_teammate[1], img_spawm_teammate[2] , img_spawm_teammate[1]+img_spawm_teammate[3],  img_spawm_teammate[2]+img_spawm_teammate[4], tocolor( 25,25,25), 1, "default-bold", "center", "center" )
				
			r_b()
				
		end
	
		local frame_buffer = {0,0,0,0,0,0}
		function r_b()
			t_spw_a.r_anim.rot = t_spw_a.r_anim.rot + 0.3
			local count = getTickCount()
			local e_dis = -10
			local clear_ = {true}
			local x1, y1 ,z1 = 0, 0, 0
					while clear_[1] == true do
						x1, y1 ,z1 =  getCamPos_cords_rot_dis( t_spw_a.spawns_t[t_spw_a.id][1], t_spw_a.spawns_t[t_spw_a.id][2], t_spw_a.spawns_t[t_spw_a.id][3], t_spw_a.r_anim.rot, e_dis )
						clear_ = {processLineOfSight ( t_spw_a.spawns_t[t_spw_a.id][1], t_spw_a.spawns_t[t_spw_a.id][2], t_spw_a.spawns_t[t_spw_a.id][3]+0.25, x1, y1, z1, true, false, false, true, false, false, false )}
						e_dis = e_dis + 0.15
						z1 = z1 +1
							if getTickCount() - count > 50 then
								clear_[1] = false
							end
					end
			x1, y1 ,z1 =  getCamPos_cords_rot_dis( x1, y1 ,z1, t_spw_a.r_anim.rot, 0.5 )		
			
			setCameraMatrix ( ( x1 + frame_buffer[1] )/2, ( y1 + frame_buffer[2] )/2, ( z1 + frame_buffer[3] )/2, ( t_spw_a.spawns_t[t_spw_a.id][1] + frame_buffer[4] )/2, (t_spw_a.spawns_t[t_spw_a.id][2] + frame_buffer[5] )/2, ( t_spw_a.spawns_t[t_spw_a.id][3] + frame_buffer[6] )/2 )
			frame_buffer = { x1,y1,z1,t_spw_a.spawns_t[t_spw_a.id][1], t_spw_a.spawns_t[t_spw_a.id][2], t_spw_a.spawns_t[t_spw_a.id][3] }
			dxDrawLine3D  (t_spw_a.spawns_t[t_spw_a.id][1], t_spw_a.spawns_t[t_spw_a.id][2], t_spw_a.spawns_t[t_spw_a.id][3]+0.01, t_spw_a.spawns_t[t_spw_a.id][1], t_spw_a.spawns_t[t_spw_a.id][2], t_spw_a.spawns_t[t_spw_a.id][3] +1.5, tocolor( 0,0,255), 4 )
			dxDrawLine3D  (t_spw_a.spawns_t[t_spw_a.id][1], t_spw_a.spawns_t[t_spw_a.id][2], t_spw_a.spawns_t[t_spw_a.id][3]+0.01, t_spw_a.spawns_t[t_spw_a.id][1]+1, t_spw_a.spawns_t[t_spw_a.id][2], t_spw_a.spawns_t[t_spw_a.id][3]+0.01, tocolor( 255,0,0), 4)
			dxDrawLine3D  (t_spw_a.spawns_t[t_spw_a.id][1], t_spw_a.spawns_t[t_spw_a.id][2], t_spw_a.spawns_t[t_spw_a.id][3]+0.01, t_spw_a.spawns_t[t_spw_a.id][1], t_spw_a.spawns_t[t_spw_a.id][2]+1, t_spw_a.spawns_t[t_spw_a.id][3]+0.01, tocolor( 0,255,0), 4 )
			
		end

		
	_initialLoaded( "spawn_selection.lua" )	

end