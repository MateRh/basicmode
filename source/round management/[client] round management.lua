_initialLoading[ "source/round management/[client] round management.lua" ] = function ( )


local _p = {}
_p.__index = _p

_players = { }

local locked = { }

function gowno ( t )
		for k, v in pairs ( t ) do
			if type( v ) == 'table' and t ~= v then
				 gowno( v )
			else
				outputConsole ( tostring( t )..':: '..tostring( k )..' = '..tostring( v ) )
			end	

		end	
end	


function _p:updateStatus(  _i, _v )
  self._s[ _i ] = _v;
  locked[ self._ ] = true;
  setElementData( self._, '#u', { _i, _v } );
end

function _p:getStatus( _i )
  return self._s[ _i ];
end

function _p:set( _i, _v )
  self[ _i ] = _v;
  locked[ self._ ] = true;
  setElementData( self._, '#u', { _i, _v } )
end

function _p:get( _i )
  return self[ _i ];
end


function syncClass ( source, _ )
	local self = setmetatable(_, _p)
	_players[ source ] = self;
end	

function syncAllClasses (  t )
	for k, v in pairs( t ) do
	--[[	local source = v._
		local self = setmetatable( v, _p)
		_players[ source ] = self;
	]]
		syncClass ( v._, v )
	end	
	_localPlayer = _players[ localPlayer ]
	_localPlayer:updateStatus(  1, 1 )
end	

addEventHandler ( "onClientElementDataChange", getRootElement(),
function ( dataName )
	if locked[ source ] then
		locked[ source ] = nil;
		return;
	end
	if dataName == '#u' and _players[ source ] then
		local _e = getElementData( source, '#u' )
			if type( _e[ 1 ] ) == 'number' then
				_players[ source ]._s[ _e[ 1 ] ] = _e[ 2 ];
			else
				_players[ source ][ _e[ 1 ] ] = _e[ 2 ];
			end	
	end	
end )

	callServer( 'classSyncReq', localPlayer );


	_initialLoaded( "source/round management/[client] round management.lua" )	

end