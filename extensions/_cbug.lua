_initialLoading[ "extensions/_cbug.lua" ] = function ( )

local _t_crouch = { count =  0, bool = false, c_pool = { }, c_pool_c = 1, enable = true }

function c_poolInsert( v )
	_t_crouch.c_pool_c = _t_crouch.c_pool_c + 1
	if _t_crouch.c_pool_c == 3 then
		_t_crouch.c_pool_c = 1 
	end	
	 _t_crouch.c_pool[ _t_crouch.c_pool_c ] = v 
end

function c_poolReturnOppositive( v )
	if v == 1 then
		return 2
	else
		return 1
	end	
end


addEventHandler ( "onClientPlayerWeaponFire", localPlayer, function( )
	if not isPedDucked ( localPlayer ) then
		_t_crouch.count = getTickCount() + 600
		c_poolInsert( getTickCount() )
		_t_crouch.enable = true
	end
end )

function reenableCrouch( )
	toggleControl( 'crouch', true )
	_t_crouch.bool = false
end

local _g_tc = getTickCount()
bindKey ( 'crouch', 'down', function ( )
	
	if not client_global_settings.c_bug_lim then
		return 0
	end	


	if ( not isControlEnabled( 'crouch' ) ) or _t_crouch.bool == true then
		setControlState( 'crouch', false )
		setSoundVolume( playSFX("script", 205, 0, false), 0.5 )
		return 0;
	end	

	
local c_tickCount = getTickCount()
	if not isPedDucked ( localPlayer ) then
	
		if _t_crouch.count > c_tickCount then
				 _t_crouch.bool = true
				
				setTimer( function ()
					setControlState( 'crouch', false )
					setTimer( reenableCrouch, 340, 1 )
				end, 50, 1 )
		end
	end

end )

toggleControl( 'crouch', true )

	_initialLoaded( "extensions/_cbug.lua" )	

end