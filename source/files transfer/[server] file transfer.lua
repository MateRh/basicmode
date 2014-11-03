local files_md5cache = {}
	
	function file_transfer_sendFile( patch, player, limit, md5hash )
		if fileExists ( patch ) then
			if files_md5cache[ patch ] then
				if files_md5cache[ patch ] == md5hash then
					return triggerClientEvent ( player, 'downloadFileLatent', player, patch, nil )
				end	
			end
			local file = fileOpen ( patch )
			fileSetPos( file, 0 )
			local _stream =  fileRead ( file, fileGetSize( file ) )
			fileClose( file )
			files_md5cache[ patch ] = md5( _stream )
				if  md5hash ~= files_md5cache[ patch ] then
					outputConsole( '* file download initialized: '..patch..' ( '..tostring( string.format("%.3f",#_stream/1048576) ) ..' MB ) with '..tostring( string.format("%.3f",limit/1000)..' kB limit.' ), player )
					triggerLatentClientEvent ( player, 'downloadFileLatent', limit, true, player, patch, _stream )
				else
					return triggerClientEvent ( player, 'downloadFileLatent', player, patch, nil )
				end	
		end	
	end
	
