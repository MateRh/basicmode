
_initialLoading[ "source/avatar upload/[client] avatar upload.lua" ] = function  ( )

local avatar_upload = { }

	function avatar_upload.gui ( ) 
	
		avatar_upload.window = guiCreateTabPanel ( (screenWidth-620)/2, (screenHeight-440)/2, 620, 440, false )
		avatar_upload.main = guiCreateTab ( "Avatar upload", avatar_upload.window )
		
		avatar_upload.image = guiCreateStaticImage( 35, 40, 64, 64, 'img/no_avatar.png', false, avatar_upload.main )
		avatar_upload.preview = guiCreateLabel (  25, 15, 100, 15, 'Preview:', false, avatar_upload.main )
		avatar_upload.url = guiCreateLabel (  0.275, 0.1, 0.7, 0.05, 'URL:', true, avatar_upload.main )
		avatar_upload.size = guiCreateLabel (  0.275, 0.175, 0.5, 0.05, 'Size:', true, avatar_upload.main )
		avatar_upload.upload = guiCreateLabel (  0.045, 0.3, 0.3, 0.05, 'Upload:', true, avatar_upload.main )
		avatar_upload.patchtext = guiCreateLabel (  0.07, 0.355, 0.1, 0.05, 'Patch:', true, avatar_upload.main )
		avatar_upload.patch = guiCreateEdit ( 0.15, 0.35, 0.7, 0.05, '', true, avatar_upload.main )
		avatar_upload.fromweb = guiCreateRadioButton ( 0.07, 0.44, 0.25, 0.05, ' Upload from internet', true, avatar_upload.main )
		avatar_upload.fromweb_info = guiCreateLabel (  0.15, 0.5, 0.7, 0.2, 'Select this option to upload image from web, by giving direct link to image,\n you can type it manually or paste by shorcut CTRL + V.', true, avatar_upload.main )
		avatar_upload.fromdisck_info = guiCreateLabel (  0.15, 0.66, 0.7, 0.2, 'Select this option to upload image from hard drive, by giving name of file\n contained in \\mods\\deathmatch\\resources\\basicmode.', true, avatar_upload.main )
		avatar_upload.fromdisck = guiCreateRadioButton ( 0.07, 0.6, 0.25, 0.05, ' Upload from hard drive', true, avatar_upload.main )
		avatar_upload.send = guiCreateButton( 0.07, 0.8, 0.25, 0.05, 'Upload',  true, avatar_upload.main )
		avatar_upload.remove = guiCreateButton( 0.38, 0.8, 0.25, 0.05, 'Remove',  true, avatar_upload.main )
		avatar_upload.close = guiCreateButton( 0.69, 0.8, 0.25, 0.05, 'Close',  true, avatar_upload.main )
		avatar_upload.console = guiCreateMemo ( 0.07, 0.875, 0.87, 0.09, 'Logs:', true, avatar_upload.main )
		guiMemoSetReadOnly ( avatar_upload.console, true )
		guiRadioButtonSetSelected ( avatar_upload.fromweb, true )
		addEventHandler ( "onClientGUIClick", avatar_upload.send, avatar_upload.action, false )
		addEventHandler ( "onClientGUIClick", avatar_upload.close, avatar_upload.action, false )
		showCursor( true )
	end
	addCommandHandler( 'avatar', avatar_upload.gui )
	
	
	
	function avatar_upload.action (  )
		if source == avatar_upload.close then
			removeEventHandler ( "onClientGUIClick", avatar_upload.close, avatar_upload.action )
			removeEventHandler ( "onClientGUIClick", avatar_upload.send, avatar_upload.action )
			destroyElement( avatar_upload.window )
			showCursor( false )
		elseif source == avatar_upload.send then
			local _patch = string.gsub( guiGetText( avatar_upload.patch ), 'https', 'http')
				if not ( string.find( _patch, '.png' ) or string.find( _patch, '.PNG' ) or string.find( _patch, '.jpg' ) or string.find( _patch, '.jpeg' ) or string.find( _patch, '.JPG' ) or string.find( _patch, '.JPEG' )  ) then
					return guiSetText( avatar_upload.console, 'Image must be png or jpg/jpeg!' )
				end
		
			if guiRadioButtonGetSelected( avatar_upload.fromweb ) then

				guiSetText( avatar_upload.url, 'URL: '.._patch )
				callServer( 'initializeDownload', _patch, localPlayer )
			else
				if fileExists( _patch ) then
					guiSetText( avatar_upload.url, 'URL: \\mods\\deathmatch\\resources\\basicmode\\'.._patch )
					local _file = fileOpen ( _patch )  
					fileSetPos ( _file, 0 )
					local data = fileRead( _file,  fileGetSize ( _file ) + 1 )
					fileClose ( _file )
					callServer( 'sendFromDisc', data, localPlayer )
					reciveAvatar ( data )
					
				end
			
			end
		
		end


	end
	
	
	function reciveAvatar ( data )
		local _file =  fileCreate ( 'avatars/'..md5( getPlayerSerial( localPlayer ) )..'.png' )
        fileSetPos ( _file, 0 )
		fileWrite ( _file, data )
		fileClose ( _file )
		
		guiStaticImageLoadImage( avatar_upload.image,  'avatars/'..md5( getPlayerSerial( localPlayer ) )..'.png' )
		setElementData( localPlayer, 'avatar', md5( getPlayerSerial( v ) )..'.png' )
		local w, h = guiStaticImageGetNativeSize ( avatar_upload.image )
		guiSetText( avatar_upload.size, 'Size: '..w..' x '..h..' px  ' ..#data..' bytes' )
		guiSetText( avatar_upload.console, 'Image uploaded successfully!' )
	end	

	function reciveAvatarConver ( data )
			local tmp_textures = { dxCreateRenderTarget ( 64, 64, true ), dxCreateTexture ( data ) }

            dxSetRenderTarget( tmp_textures[1] ) 
           		dxDrawImage( 0, 0, 64, 64, tmp_textures[2] ) 
           dxSetRenderTarget()      

			data = dxGetTexturePixels ( tmp_textures[1], 0, 0, 64, 64  )
				data = dxConvertPixels ( data, 'png' )
				destroyElement( tmp_textures[1] )
				destroyElement( tmp_textures[2] )
			callServer( 'reciveDataNext', data, localPlayer )
		reciveAvatar ( data )
	end	
	
	function pre_syncWholeAvatars( avatarsd )
	local avSyncList = { }
		for k, v in pairs( avatarsd ) do 
			if fileExists( 'avatars/'..v[ 2 ]..'.png' )  then
				local _file = fileOpen ( 'avatars/'..v[ 2 ]..'.png' ) 
				fileSetPos ( _file, 0 )
				local data = fileRead( _file,  fileGetSize ( _file ) + 1 )
				fileClose ( _file )
					if md5( data ) ~= v[ 1 ] then
						table.insert( avSyncList, v[ 3 ] )
					end
			else
				table.insert( avSyncList, v[ 3 ] )
			end
		end
		if #avSyncList > 0 then
			callServer( 'synchronizeAvatars_async', localPlayer, avSyncList )
		end
	
	end
	
	
	function syncWholeAvatars( avatars )
		for k, v in pairs( avatars ) do 
			getAvatar ( unpack( v ) )
		end
	end

	
	function pre_getAvatar ( md5_, serial, player )
			if fileExists( 'avatars/'..md5( serial )..'.png' )  then
				local _file = fileOpen ( 'avatars/'..md5( serial )..'.png' ) 
				fileSetPos ( _file, 0 )
				local data = fileRead( _file,  fileGetSize ( _file ) + 1 )
				fileClose ( _file )
					if md5_ ~= md5( data ) then
						callServer( 'avatarrSsend', localPlayer, player )
					end
			else
				callServer( 'avatarrSsend', localPlayer, player )
			end	
		
	end
	
	
	function getAvatar ( data, serial, player )
		local _file  = fileCreate ( 'avatars/'..md5( serial )..'.png' )		
        fileSetPos ( _file, 0 )
		fileWrite ( _file, data )
		fileFlush( _file )
		fileClose ( _file )
		hudReVerify( player )
	end


setTimer( function () 	callServer( 'asyncRequest', localPlayer ) end, 1000, 1 )

	_initialLoaded( "source/avatar upload/[client] avatar upload.lua" )	

end