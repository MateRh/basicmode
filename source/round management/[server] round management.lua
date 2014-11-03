_p = {}
_p.__index = _p

_players = { }


function gowno ( t )
		for k, v in pairs ( t ) do
			if type( v ) == 'table' and t ~= v then
				 gowno( v )
			else
				print ( tostring( t )..':: '..tostring( k )..' = '..tostring( v ) )
			end	

		end	
end	



function _p:new( source )
 	local self = setmetatable({}, _p)
 	self._ = source
	--local r, g, b =  unpack( colors_scheme [ getElementData( source, '#c' ) ] )	
	--self._c = { r, g, b }
	self._h = 0
	self._a = 0
	self._id = 0
	self._s = { 0, 0, 0 }
	callClient( getRootElement(  ), 'syncClass', source, self )
	_players[ source ] = self;
	return self
end
--[[
function _p.spawn( source )
 	local self = setmetatable({}, _p)
 	self._ = source
	local team = getPlayerTeam( source )
	setElementParent( source, blips[ team ] )
	local r, g, b =  unpack( colors_scheme [ getElementData( source, '#c' ) ] )	
	self._color = { r, g, b }
	self._blip = createBlipAttachedTo ( source, 0, 1, r, g, b, 255, 0, 0, blips[ team ] )
	self._health = 100
	self._status = 0
	callClient( getRootElement(  ), 'syncClass', self )
	setElementData( team, "_#", ( getElementData( team, "_#") or 0 ) + 1 )
	gowno ( self  )

	return self
end]]

function _p:updateStatus(  _i, _v )
  self._s[ _i ] = _v;
  setElementData( self._, '#u', { _i, _v } );
end

function _p:getStatus( _i )
  return self._s[ _i ];
end

function _p:set( _i, _v )
  self[ _i ] = _v;
  setElementData( self._, '#u', { _i, _v } )
end

function _p:get( _i )
  return self[ _i ];
end

function classSyncReq( player )
	callClient( player, 'syncAllClasses', _players )
end	


addEventHandler ( "onElementDataChange", getRootElement(),
function ( dataName )

	if client and dataName == '#u' and _players[ source ] then
		local _e = getElementData( source, '#u' )
			if type( _e[ 1 ] ) == 'number' then
				_players[ source ]._s[ _e[ 1 ] ] = _e[ 2 ];
			else
				_players[ source ][ _e[ 1 ] ] = _e[ 2 ];
			end	
	end	
end )