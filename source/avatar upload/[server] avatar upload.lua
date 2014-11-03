function initializeDownload( url, player )
    fetchRemote ( url, reciveData, "", false, player )
end

	local avatars_binaryC = { }

function reciveData ( data, erro, player )
    if erro == 0 then
		callClient( player, 'reciveAvatarConver', data )
    end
end

function reciveDataNext ( data, player )

	local _file = fileCreate ( ':basicmode-core/avatars/'..md5( getPlayerSerial( player ) )..'.png' ) or fileOpen ( ':basicmode-core/avatars/'..md5( getPlayerSerial( player ) )..'.png' )  
	fileSetPos ( _file, 0 )
	fileWrite ( _file, data )
	fileClose ( _file )
	avatars_binaryC [ player ] = { data, md5( data ) } 
	synchronizeAvatars_sync ( data, player )

end


function sendFromDisc ( data, player )
	local _file = fileCreate ( ':basicmode-core/avatars/'..md5( getPlayerSerial( player ) )..'.png' ) or fileOpen ( ':basicmode-core/avatars/'..md5( getPlayerSerial( player ) )..'.png' )  
    fileSetPos ( _file, 0 )
	fileWrite ( _file, data )
	fileClose ( _file )
	avatars_binaryC [ player ] = { data, md5( data ) } 
	synchronizeAvatars_sync ( data, player )
end


function synchronizeAvatars_sync ( data, player )
	
	for k, v in ipairs( getElementsByType( 'player' ) ) do

	--if v ~= player then
			callClient( v, 'pre_getAvatar', data[2], getPlayerSerial( player ), player )
	--	end	
		
	end
	
end


function avatarrSsend ( player, aPlayer )
	
	callClient( player, 'getAvatar', avatars_binaryC [ aPlayer ][ 1 ], getPlayerSerial( aPlayer ), aPlayer )

end





function asyncRequest ( player )
	local _avatarsCache = { }
	
	for k, v in ipairs( getElementsByType( 'player' ) ) do

			if  avatars_binaryC [ v ] then
				local oneT = { avatars_binaryC [ v ][2], md5( getPlayerSerial( v ) ),  v   }
				table.insert( _avatarsCache, oneT )
			end
	end
	callClient( player, 'pre_syncWholeAvatars', _avatarsCache )

end

function synchronizeAvatars_async ( player, players )
	local _avatarsCache = { }
	
	for k, v in pairs( players ) do
--	v = getPlayerByID( v )
		if v ~= player then
			table.insert( _avatarsCache, { avatars_binaryC [ v ][1],  getPlayerSerial( v )  } )
		end	

	end
	callClient( player, 'syncWholeAvatars', _avatarsCache )
	
end


function loadAvatarCache( v )

	local patch = ':basicmode-core/avatars/'..md5( getPlayerSerial( v ) )..'.png'
	if fileExists( patch ) then

		local _file = fileOpen ( patch )  
		fileSetPos ( _file, 0 )
		local data = fileRead( _file,  fileGetSize ( _file ) + 1 )
		fileClose ( _file )

		avatars_binaryC [ v ] = { data, md5( data ) } 
		return true
	else
		return false	
	end
	
end

	for k, v in ipairs( getElementsByType( 'player' ) ) do
			if loadAvatarCache( v ) then
				synchronizeAvatars_sync ( avatars_binaryC [ v ], v )
			end	
	end

	addEventHandler ( "onPlayerJoin", getRootElement(), function ( )
		loadAvatarCache( source )	
		synchronizeAvatars_sync ( avatars_binaryC [ source ], source )
	end	)
	
	addEventHandler ( "onPlayerQuit", getRootElement(), function ( )
		
		if avatars_binaryC [ source ] ~= nil then
			avatars_binaryC [ source ] = nil
		end
	
	end )
