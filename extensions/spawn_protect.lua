_initialLoading[ "extensions/spawn_protect.lua" ] = function ( )


local _protect = { render_ = {},  anim_sts_r = {}, anim_r_list = {}, was_enabled = false, slienttc = 0 }

function _protect_enable(  )
	if getElementData( localPlayer, ":_protec" ) == 1 then
		return 0
	end	
	setElementData( localPlayer, ":_protec", 1 )
	_protect.was_enabled = true
	_protect.render_.tick = getTickCount()
	--playSFX("script", 16, 5, false)
	setSoundVolume( playSFX("script", 62, 7, false), 1 )
--	_protect.render_.fontsize = math.max( 0.5, 1*( screenWidth  * ( 1 / 1920 )  ) )
	_protect.render_.fontsize =  1*( screenWidth  * ( 1 / 1920 )  ) 
	_protect.render_.lenght = dxGetTextWidth ( "[ SPAWN PROTECTION: ENABLED ]", _protect.render_.fontsize,  "bankgothic")
	_protect.render_.high = dxGetFontHeight ( _protect.render_.fontsize, "bankgothic" )
	_protect.render_.x = ( screenWidth - _protect.render_.lenght ) / 2
	_protect.render_.x_2 = ( screenWidth - dxGetTextWidth ( "[ 00:00 ]",  1, "clear") ) / 2
	_protect.render_.y =  screenHeight * 0.05
	_protect.render_.y_2 =  _protect.render_.y + _protect.render_.high*1.5
	local time_s =  (client_settings_t[ string.lower( getElementData(getElementByIndex ( "root_gm_element",0 ),"map_info")[1] ) ][1][2] )* 1000
	time_s = time_s - (  math.max( 0, getTickCount(  ) - _protect.slienttc )  )
	time_s = math.max( 3000, time_s )
	_protect.render_.time = time_s
	_protect.render_.tick = getTickCount() + time_s 
	addEventHandler ( "onClientRender", getRootElement(), _protect.render, false, "low" )
	_protect.timer_ = setTimer( _protect.disable,time_s, 1 )
	_protect.slienttc = 0
end

addEventHandler ( "onClientPlayerSpawn", getLocalPlayer(), function (  )
	_protect.slienttc = getTickCount(  )
end )


function _protect.render( )
	if ( _players[ localPlayer ]:getStatus( 2 ) == 2 ) then
		local _time = getRealTime( string.format( "%d", (_protect.render_.tick - getTickCount ()  ) / 1000 ))
		dxDrawTextBaQ_c( "[ SPAWN PROTECTION: ENABLED ]", _protect.render_.x ,_protect.render_.y,screenWidth, screenHeight, colors_g.white, _protect.render_.fontsize, "bankgothic",colors_g.black) 
		dxDrawTextBaQ_c( "[ ".. string.format( "%.2i:%.2i",_time.minute, _time.second).." ]", _protect.render_.x_2 ,_protect.render_.y_2, screenWidth, screenHeight, colors_g.white, 1, "clear",colors_g.black) 
	end
end

function _protect.disable(  )
	setElementData( localPlayer, ":_protec", 0 )
	removeEventHandler ( "onClientRender", getRootElement(), _protect.render, false, "low" )
	_protect.render_ = {}
	setSoundVolume( playSFX("script", 62, 6, false), 1 )
	setElementAlpha( localPlayer, 255 )
	_protect.was_enabled = false
end

function _protect_ForceDisable(  )
	if not isTimer( _protect.timer_  ) then return 0 end
	setElementData( localPlayer, ":_protec", 0 )
	removeEventHandler ( "onClientRender", getRootElement(), _protect.render, false, "low" )
	killTimer( _protect.timer_  )
	_protect.render_ = {}
	_protect.was_enabled = false
	
end

function _protect.onDamageRemote( a ,w ,b, l )
	if getElementData( source, ":_protec" ) == 1 then
		if source == localPlayer then
			cancelEvent()
		end	
		if _protect.anim_sts_r[source] == nil then
			setElementAlpha( source, 1 )
			_protect.anim_sts_r[source] = 1
			table.insert( _protect.anim_r_list, source )
		end
	end
end
addEventHandler ( "onClientPlayerDamage", getRootElement() , _protect.onDamageRemote )
	
function _protect.animaion_remote( )
	for k, v in pairs( _protect.anim_r_list ) do 
		setElementAlpha( v, math.min( 255, getElementAlpha( v) + 10 ) )
		if getElementAlpha( v )  == 255 then
			_protect.anim_sts_r[v] = nil
			table.remove( _protect.anim_r_list, k )
		end
	end	
end
	addEventHandler ( "onClientRender", getRootElement(), _protect.animaion_remote, false, "low" )
	
	--if getElementData( localPlayer, ":_protec" ) == 1 then
		 setElementData( localPlayer, ":_protec", 0 )
	--end	

	_initialLoaded( "extensions/spawn_protect.lua" )	

end	