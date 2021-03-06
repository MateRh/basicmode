
_initialLoading[ "source/files transfer/[client] file transfer.lua" ] = function ( )


local file_transfer = { startint = 0 }
	
	function file_transfer.getFile( patch, stream )
		onTransferFinish( patch ) 
		if not stream then
			return 0;
		end
		local file 
			if fileExists ( patch ) then
				file = fileOpen ( patch )
			else
				file = fileCreate ( patch )
			end	
		fileSetPos( file, 0 )
		fileWrite ( file, stream )
		fileClose( file )
		outputConsole( '* file: '..patch..' ( '..tostring( string.format("%.3f",#stream/1048576) ) ..' MB ) downloaded in '.. string.format( "%.2f",( getTickCount() - file_transfer.startint) / 1000 )..' s.' )
	end
	
	
	addEvent ( 'downloadFileLatent', true )
	addEventHandler ( 'downloadFileLatent', getRootElement(), file_transfer.getFile )

	
	function initiateFileTransfer( patch, limit )
			
		local file, md5hash
			if fileExists ( patch ) then
				file = fileOpen ( patch, true )
				fileSetPos( file, 0 )
				md5hash =  md5( fileRead ( file, fileGetSize( file ) ) )
				fileClose( file )
			else
				md5hash = nil
			end	
		callServer( 'file_transfer_sendFile', patch, localPlayer, limit or 1000000, md5hash )
		file_transfer.startint = getTickCount()
	end
	
local main_gm_files = { "sounds/blip.wav", "sounds/end.wav" ,"sounds/help.wav", "sounds/beep.wav", "img/map.jpg" }
	local _index = 1
	
		function onTransferFinish( patch ) 
			if _index+1 > #main_gm_files then
				return 0;
			end	
			for k, v in ipairs( main_gm_files ) do 
				if v == patch then
					_index = _index + 1
						if  main_gm_files [ _index ] then
							initiateFileTransfer( main_gm_files [ _index ] )
						end	
					return 0;
				end
			end
		end
		
	--	initiateFileTransfer( main_gm_files [ _index ] )
	
	for k, v in ipairs( main_gm_files ) do 
		downloadFile ( v )
	end	


	_initialLoaded( "source/files transfer/[client] file transfer.lua" )	

end	