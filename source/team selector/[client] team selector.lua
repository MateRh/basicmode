
_initialLoading[ "source/team selector/[client] team selector.lua" ] = function ( )

local _load_start = {c=0,max_c=40}

local _team_selector = {
	data = {},
	cam = { x = 2619+math.random(-35,35), y = 2756+math.random(-35,35), z = 50+math.random( -10, 20 ) },
	ped_rotation = 0,
	camera_rotation = 0,
	current = 1,
}
	_team_selector.object = createObject( 16637, _team_selector.cam.x, _team_selector.cam.y, _team_selector.cam.z-0.5, 0, 90, 0 )
	_team_selector.ped = createPed ( 0, _team_selector.cam.x, _team_selector.cam.y, _team_selector.cam.z+0.5 )

setElementAlpha( _team_selector.object, 0 )
setElementAlpha( _team_selector.ped, 0 )

if getElementData ( localPlayer, "wasConnected" ) == true then
	_load_start.max_c = 20
end

	


function _team_selector.applyAnim ()

	if isTimer( _team_selector.timer ) then
	--	return 0
	end	
		

local playIdles = { { 'WUZI', 'Wuzi_stand_loop'}, { 'STRIP', 'PUN_LOOP'}, { 'SMOKING', 'M_smk_loop' },
					{ 'RAPPING', 'RAP_B_Loop'},  {'DEALER', 'DEALER_IDLE' },
					{'DEALER', 'DEALER_IDLE_01' }, {'DEALER', 'DEALER_IDLE_02' }, {'DEALER', 'DEALER_IDLE_03' }, 
					{'DANCING', 'dance_loop'},  {'DANCING', 'DAN_Loop_A'}, {'DANCING', 'DAN_Left_A'}, {'DANCING', 'DAN_Right_A'}, 
					{ 'PLAYIDLES', 'shift'}, { 'PLAYIDLES', 'shldr'}, { 'PLAYIDLES', 'stretch'}, { 'PLAYIDLES', 'strleg'}, { 'PLAYIDLES', 'time'} 
				}


	math.randomseed(  getRealTime( ).timestamp  )	
	local randID = math.random( 1, #playIdles  )
	setPedAnimation ( _team_selector.ped , playIdles[ randID ][1], playIdles[ randID ][2] )			
end	


function _team_selector.initialize( )



_team_selector.snd = sndGlobal

	showPlayerHudComponent ( "area_name",false )
	showPlayerHudComponent ( "clock",false )
	showPlayerHudComponent ( "clock",false )
	showPlayerHudComponent ( "radar",false )
	showPlayerHudComponent ( "wanted",false )
	showPlayerHudComponent ( "money",false )
	showPlayerHudComponent ( "wanted",false )
	showPlayerHudComponent ( "vehicle_name",false )



	PlayerInChoosing = true
	g_open_s.team = true


	_team_selector.data.background = {}
	local _ = _team_selector.data.background
		_.w, _.h, _.color, _.color2 = screenWidth,  math.ceil( scaleInt( 1080, 200 ) ), tocolor( 0, 0, 0,  50 ), tocolor( 0, 0, 0, 100 )
		_.y = screenHeight - _.h
		
		
		local model = { '', 0 }
		
			for k, v in pairs ( { 'Auto Asign', getTeamName( TableTeams[1] ), getTeamName( TableTeams[2] ), 'Spectator' } ) do
				if #v > model[ 2 ] then
					model = { v, #v }		
				end	
			end	
			local widthModel, baseSize = math.ceil ( screenWidth / 5.25 ), math.ceil( scaleInt( 1080, 20 ) ) 
			local modelFont = dxCreateFont( 'fonts/TravelingTypewriter.ttf', baseSize )
			local modelFontWidth =  dxGetTextWidth( model[ 1 ] , 1, modelFont )

			while ( not ( modelFontWidth < widthModel and modelFontWidth > widthModel*0.8 )  ) do 

					if modelFontWidth > widthModel then
						baseSize = baseSize - 1
					else 
						baseSize = baseSize + 1
					end	
					destroyElement( modelFont )
			modelFont = dxCreateFont( 'fonts/TravelingTypewriter.ttf', baseSize )
			modelFontWidth =  dxGetTextWidth( model[ 1 ] , 1, modelFont )

			end 

			_.font = modelFont
			local yForAll =  _.y + ( ( _.h - dxGetFontHeight( 1, modelFont ) ) / 2 )
			_.texts = { }
			local _startM = 0.25
			for k, v in pairs ( { 'Auto Asign', getTeamName( TableTeams[1] ), getTeamName( TableTeams[2] ), 'Spectator' } ) do
				_.texts[ k ] = { txt = v }
				_.texts[ k ].x, _.texts[ k ].y =  math.ceil( widthModel*_startM ) + ( widthModel - dxGetTextWidth( v, 1, modelFont ) ) /2, yForAll
				_startM = _startM + 1.25
				_.texts[ k ].Ex, _.texts[ k ].Ey = _.texts[ k ].x +  dxGetTextWidth( v, 1, modelFont ), _.texts[ k ].y + dxGetFontHeight( 1, modelFont ) 
				_.texts[ k ].color_c = tocolor( 255, 255, 255, 100 )
					if getTeamFromName( v ) then
						local r, g, b = getTeamColor( getTeamFromName( v ) )
						_.texts[ k ].color_m = tocolor( r, g, b, 200 )
					else	
					_.texts[ k ].color_m = tocolor( 255, 255, 255, 200 )	
					end	

			end	
			_team_selector.animTimer = setTimer( _team_selector.applyAnim, 3000, 0 )
			_team_selector.applyAnim()
			_localPlayer:updateStatus(  3, 1 )


end

function _team_selector.begin( )
	local _ = _team_selector.data.background
	blur_remote( true, 4, false, true, 0, _.y, _.w, _.h )

	addEventHandler( 'onClientRender', getRootElement( ), _team_selector.render )
	addEventHandler( "onClientCursorMove", getRootElement( ), _team_selector.onCursorMove )
	addEventHandler( "onClientClick", getRootElement( ), _team_selector.onMouseClick )
	showCursor( true )
	_team_selector.timer = setTimer( _team_selector.updateTimerFunction, 500, 0 )
	_team_selector.updateTimerFunction( )
		dofSwitch( true )
		dofUpdateSettings( 2, nil, nil, nil, nil,  nil, 20, true )

end

teamSelectorInitialize = _team_selector.begin
	
function _team_selector.render( )
	local _ = _team_selector.data.background
	dxDrawImage( 0, _.y, _.w, _.h, 'img/_down.png', 0, 0, 0, _.color )
	dxDrawImage( 0, _.y, _.w, _.h, 'img/_up.png', 0, 0, 0, _.color2 )
		for k, v in pairs( _.texts ) do 
			dxDrawText( v.txt, v.x, v.y, 'left', 'top', v.color_c, 1, _.font )	
		end	
	_team_selector.cameraRender()	
end	


function _team_selector.onCursorMove( __, __, ax, ay )

	for k, v in pairs ( _team_selector.data.background.texts ) do
	
		if ax > v.x and ay > v.y and ax < v.Ex and ay < v.Ey then
				if v.color_c ~= v.color_m then
					v.color_c = v.color_m


				--	setSoundVolume(  playSFX("script", 16, 1, false), 1.0 )
					setSoundVolume(  playSFX("script", 144, 0, false), 1.0 )

					if k ~= 1 then
						if isTimer( _team_selector.timer ) then
							killTimer( _team_selector.timer )
						end	
					end	
					_team_selector.update( k-1 )

				end	
		--	playSFX("script", 144, 0, false)
		else
			v.color_c = tocolor( 255, 255, 255, 100 )
		end	


	end	
end

function _team_selector.onMouseClick( __, __, ax, ay )

	for k, v in pairs ( _team_selector.data.background.texts ) do
	
		if ax > v.x and ay > v.y and ax < v.Ex and ay < v.Ey then
			setSoundVolume(  playSFX("script", 144, 3, false), 1.0 )	
			setElementFrozen ( localPlayer, false )	
			setFogDistance ( 0 )
			setCloudsEnabled ( false )
			sdasddsadsa()
			if isTimer( _team_selector.timer ) then
				killTimer( _team_selector.timer )
			end				
			if isTimer( _team_selector.animTimer ) then
				killTimer( _team_selector.animTimer )
			end	
			if _team_selector.anim_ped_status then
				removeEventHandler("onClientRender",getRootElement(), _team_selector.anim_ped )
			end	
			
			dofSwitch( client_settings.dof.enable )
			dofUpdateSettings( client_settings.dof.dof_blur, client_settings.dof.dof_bri, client_settings.dof.dof_fades, client_settings.dof.dof_fadee, client_settings.dof.dof_briS, client_settings.dof.dof_skyb  )
			callServer("_spawn_in_lobby", localPlayer, ( TableTeams[ k - 1] ) or "auto")	
			_players[ localPlayer ]:updateStatus(  2, 1 )
			_players[ localPlayer ]:updateStatus(  3, 0 )
				removeEventHandler( 'onClientRender', getRootElement( ), _team_selector.render )
				removeEventHandler( "onClientCursorMove", getRootElement( ), _team_selector.onCursorMove )
				removeEventHandler( "onClientClick", getRootElement( ), _team_selector.onMouseClick )
				blur_remote( false )
			destroyElement( _team_selector.ped )
			destroyElement( _team_selector.object )
			destroyElement( _team_selector.data.background.font )
				if isElement( _team_selector.snd ) then
					for i=45, 1, -1 do
						setSoundVolume( _team_selector.snd, i/100 )
					end	
					stopSound( _team_selector.snd )
				end
			_team_selector.data = {}
			PlayerInChoosing = false 
			--g_open_s.team = false
			showPlayerHudComponent (  "radar",true )
		--	showHud()
		--	changeHudFunctionality( "lobby" )
			showCursor( false )
			if getElementData(localPlayer,"Kills") == false then
				setElementData(localPlayer,"Kills", 0 )
				setElementData(localPlayer,"Deaths", 0 )
				setElementData(localPlayer,"Damage", 0 )
				setElementData(localPlayer,"Score", 0 )
			end
			_players[ localPlayer ]:updateStatus(  2, 1 )
			showHud()
			--removeEventHandler( 'onClientRender', getRootElement(), intro.func )

			if not ( ( getElementData( TableTeams[ 1 ], "p_count" ) or 1 ) == 0 or ( getElementData( TableTeams[ 2 ], "p_count" ) or 1 ) == 0 ) then
				enabledSpectate( 2000 )
				changeHudFunctionality( getElementData(getElementByIndex ( "root_gm_element",0 ) ,"map_info")[1], getElementData(getElementByIndex ( "root_gm_element",0 ) ,"map_info")[1]..": "..getElementData(getElementByIndex ( "root_gm_element",0 ) ,"map_info")[2], true ) 	
			end

		end	


	end	


end	


function _team_selector.updateTimerFunction( )

	if _team_selector.current > 1 then
			_team_selector.current = 1
	else
			_team_selector.current = 2
	end	

	_team_selector.update( _team_selector.current )
	playSFX("script", 16, 1, false)

end

	






function _team_selector.update( k )

	if k == 0 then
		if not isTimer( _team_selector.timer ) then
			_team_selector.timer = setTimer( _team_selector.updateTimerFunction, 500, 0 )
			_team_selector.updateTimerFunction( )
		end
	elseif k == 1 then
		if client_global_settings.skins[k] == 0 then
			if getElementModel( _team_selector.ped ) ~= 0 then
				setElementModel( _team_selector.ped, 0 )
			end	
			addPedClothes ( _team_selector.ped, 'bbjackrim', 'bbjack', 0 )
			addPedClothes ( _team_selector.ped, 'hairred', 'head', 1 )
			addPedClothes ( _team_selector.ped, 'denimsred', 'jeans', 2 )
			addPedClothes ( _team_selector.ped, 'sneakerprored', 'sneaker', 3 )
			addPedClothes ( _team_selector.ped, 'hockey', 'hockeymask', 16 )
		else
			setElementModel ( _team_selector.ped, client_global_settings.skins[k-1])
		end	
		
	elseif k == 2 then
		if client_global_settings.skins[k] == 0 then
			if getElementModel( _team_selector.ped ) ~= 0 then
				setElementModel( _team_selector.ped, 0 )
			end	

			addPedClothes ( _team_selector.ped, 'hoodyAblue', 'hoodyA', 0 )
			addPedClothes ( _team_selector.ped, 'hairblue', 'head', 1 )
			addPedClothes ( _team_selector.ped, 'jeansdenim', 'jeans', 2 )
			addPedClothes ( _team_selector.ped, 'sneakerproblu', 'sneaker', 3 )
			addPedClothes ( _team_selector.ped, 'hockey', 'hockeymask', 16 )
		else
			setElementModel ( _team_selector.ped, client_global_settings.skins[k])
		end
	elseif k == 3 then	
		setElementModel ( _team_selector.ped, client_global_settings.skins[k])

	end
		if not _team_selector.anim_ped_status then
			addEventHandler("onClientRender",getRootElement(), _team_selector.anim_ped )
			_team_selector.anim_ped_status = true 
		end	

end	

	local ratio = screenWidth / screenHeight

function _team_selector.cameraRender()

	local cX, cY, wX, wY, wZ = getCursorPosition ( )

	cX, cY = ( cX-0.5 ) / 10*ratio, ( cY-0.5 ) / 10
	_team_selector.camera_rotation = _team_selector.camera_rotation + 0.27
--	_team_selector.ped_rotation = _team_selector.ped_rotation - 1.99
	local x,y,z = getCamPos_cords_rot_dis( _team_selector.cam.x, _team_selector.cam.y, _team_selector.cam.z +0.75 + 0.2 ,_team_selector.camera_rotation ,2.025*ratio )	
	local x1,y1,z1 = getCamPos_cords_rot_dis( _team_selector.cam.x , _team_selector.cam.y, _team_selector.cam.z +0.275 + 0.2,_team_selector.camera_rotation ,1 )	

	local rotation = findRotation( x, y, x1, y1 )
	x1,y1,z1 = getCamPos_cords_rot_dis( x1,y1,z1 - cY, rotation-90 , cX )

	setCameraMatrix ( x,y,z,x1,y1,z1  )
--	setPedRotation( _team_selector.ped, _team_selector.ped_rotation ) 
	setPedRotation( _team_selector.ped, _team_selector.camera_rotation ) 


end


function _team_selector.anim_ped()
	setElementAlpha( _team_selector.ped, getElementAlpha( _team_selector.ped )+25)
	if getElementAlpha( _team_selector.ped ) >= 225 then
		setElementAlpha( _team_selector.ped, 255)
		_team_selector.anim_ped_status = false
		removeEventHandler("onClientRender",getRootElement(), _team_selector.anim_ped )
	end
end

function findRotation(x1,y1,x2,y2)
 
  local t = -math.deg(math.atan2(x2-x1,y2-y1))
  if t < 0 then t = t + 360 end;
  return t;
 
end

TableTeams = {}
setTimer(function()
	for id, teams in ipairs(getElementsByType ( "team" )) do
		TableTeams[id] = teams
	end		
	_team_selector.initialize( )
end,100,1)




	bindKey( "F4", "down", function ()
			if _players[ localPlayer ]:getStatus( 2 ) == 1 then
				sdasddsadsa(150)
				hideHud()
				showPlayerHudComponent( "radar", false )
					_team_selector.data = {}
					_team_selector.cam = { x = 2619+math.random(-35,35), y = 2756+math.random(-35,35), z = 50+math.random( -10, 20 ) }
					_team_selector.ped_rotation = 0
					_team_selector.camera_rotation = 0
					_team_selector.current = 1
					_team_selector.object = createObject( 16637, _team_selector.cam.x, _team_selector.cam.y, _team_selector.cam.z-0.5, 0, 90, 0 )
					_team_selector.ped = createPed ( 0, _team_selector.cam.x, _team_selector.cam.y, _team_selector.cam.z+0.5 )

				setElementAlpha( _team_selector.object, 0 )
				setElementAlpha( _team_selector.ped, 0 )
				_team_selector.initialize( )
					setTimer(function()
						_team_selector.begin( )
				end,100,1)
			end
	end )

	_initialLoaded( "source/team selector/[client] team selector.lua" )	

end