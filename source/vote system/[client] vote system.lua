
_initialLoading[ "source/vote system/[client] vote system.lua" ] = function ( )

local vote_ = { data = {}, v_gui = { } }


	function vote_.createImg(  )

	local tmp = vote_.tmpData

		for j=1,2 do
			for i=0, tmp.range[ j ] do 
				
					local img = guiCreateStaticImage ( tmp.x[ j ], tmp.y[ j ], vote_.dimesions.img.x, vote_.dimesions.img.y, 'img/vote/'..tmp.patch[ j ]..tostring( i )..tmp.patch_[ j ]..'.png', false, tmp.element[ j ] )

					guiCreateLabel ( 0.05, vote_.dimesions.additional[8], 0.9, 0.5, tmp.name[ j ]..': '..tostring( i ), true, img )
					local img_layer = guiCreateStaticImage ( 0, 0, 1, 1, 'img/transparent.png', true, img )
					vote_.data[ img_layer ] = { name = tmp.name[ j ]..': '..tostring( i ), resource = tmp.patch[ j ] .. i .. tmp.patch_[ j ], status = false }
					tmp.x[ j ] = tmp.x[ j ] + vote_.dimesions.additional[ 1 ]
					if tmp.x[ j ] > vote_.dimesions.additional[ 2 ] then
						tmp.x[ j ] = 5
						tmp.y[ j ] = tmp.y[ j ] + vote_.dimesions.additional[ 3 ]
					end	
				--vote_.coroutineWorker ( int + math.max( 6,  getTickCount(  ) - init ) -1 )	
			--	coroutine.yield()
				checkForYield()
			end
		end	
	end


	function checkForYield()
	if not myTickCount then
		myTickCount = getTickCount()
	end
	if vote_.coroutine and ( getTickCount() > myTickCount + 2500 ) then
		setTimer(function()
			local status = coroutine.status( vote_.coroutine )
			if (status == "suspended") then
				coroutine.resume( vote_.coroutine )
			elseif (status == "dead") then
				vote_.coroutine = nil
			end
		end, 50, 1)
		coroutine.yield()
		myTickCount = getTickCount()


		end
	end



	function vote_.resume ( file, s )
		if file == 'core/voteSystemImages' then
			if s then
				removeEventHandler ( "onClientFileDownloadComplete", getRootElement(), vote_.resume )
				return vote_.convertImages( )
				-- vote_.gui ( )
			else
				downloadFile ( 'core/voteSystemImages' )
			end	
		end
	end

	function vote_.coroutineWorker ( t )
			if coroutine.status( vote_.coroutine )	 == 'dead' then
			--	outputChatBox( 'time: '..( getTickCount(  ) - vote_.coroutineStart ) )
				removeEventHandler ( "onClientRender",  getRootElement(  ), vote_.coroutineWorker )
				addEventHandler ( "onClientGUIClick", vote_.start, vote_.clickCallback )
				addEventHandler ( "onClientGUIClick", vote_.close, vote_.clickCallback )
				addEventHandler ( "onClientGUIClick", vote_.main, vote_.clickCallback )
				addEventHandler ( "onClientGUIClick", vote_.main_a, vote_.clickCallback )
				destroyElement( vote_.loading )
						guiSetAlpha( vote_.window, 0.25 )
						guiSetAlpha( vote_.start, 0.25 )
						guiSetAlpha( vote_.close, 0.25 )
				setTimer( function()
					local alpha = guiGetAlpha( vote_.window ) + 0.25
						guiSetAlpha( vote_.window, alpha )
						guiSetAlpha( vote_.start, alpha )
						guiSetAlpha( vote_.close, alpha )
					end, 50, 3 )		
				showCursor( true )	
					
			end
	end
	

	function vote_.gui ( )
		if not fileExists( 'core/voteSystemImages' ) then
			downloadFile ( 'core/voteSystemImages' )
			addEventHandler ( "onClientFileDownloadComplete", getRootElement(), vote_.resume )
			return false
		end	
			if not client_global_settings.vote[1] then
				return 	outputChatBox(  "#FF0000[ERROR] #c8c8c8 Sorry, but voting has been disabled by admin.", 0, 0, 0, true )
			end	

			vote_.loading = guiCreateLabel ( (screenWidth-100)/2, (screenHeight-30)/2, 300, 30, 'Loading... please wait...', false )

			vote_.window = guiCreateTabPanel ( (screenWidth- vote_.dimesions.main.x )/2, (screenHeight- vote_.dimesions.main.y )/2, vote_.dimesions.main.x, vote_.dimesions.main.y, false )
			
			vote_.tab = guiCreateTab ( "Bases", vote_.window )
			vote_.arena = guiCreateTab ( "Arenas", vote_.window )
			vote_.main = guiCreateScrollPane ( 0, 0, vote_.dimesions.main.x, vote_.dimesions.additional[4], false, vote_.tab )
			vote_.main_a = guiCreateScrollPane ( 0, 0, vote_.dimesions.main.x, vote_.dimesions.additional[4], false, vote_.arena )
			guiSetAlpha( vote_.window, 0 )
			vote_.tmpData = { range = { 124, 81 }, name = { 'Base', 'Arena' }, patch = { 'base_', 'arena_' }, patch_ = { '_bm', '' }, x = { 5, 5 }, y = { 5, 5 }, element = { vote_.main, vote_.main_a } }
		 vote_.coroutineOK = true

		vote_.start = guiCreateButton( (screenWidth- vote_.dimesions.main.x )/2+vote_.dimesions.additional[5], (screenHeight-vote_.dimesions.additional[4])/2 + vote_.dimesions.additional[7], vote_.dimesions.button.x, vote_.dimesions.button.y, 'start vote', false)		
		vote_.close = guiCreateButton( (screenWidth-vote_.dimesions.main.x )/2 +vote_.dimesions.additional[6], (screenHeight-vote_.dimesions.additional[4])/2 + vote_.dimesions.additional[7], vote_.dimesions.button.x, vote_.dimesions.button.y, 'cancel & close', false)		
		guiSetAlpha( vote_.start, 0 )
		guiSetAlpha( vote_.close, 0 )
		guiSetAlpha( vote_.window, 0 )
		vote_.coroutineStart = getTickCount(  )
		vote_.coroutine = coroutine.create( vote_.createImg )
		coroutine.resume( vote_.coroutine )	
		addEventHandler ( "onClientRender",  getRootElement(  ), vote_.coroutineWorker )
		

	end

	function vote_.GuiClose( )
		removeEventHandler ( "onClientGUIClick", vote_.main, vote_.clickCallback )
		removeEventHandler ( "onClientGUIClick", vote_.main_a, vote_.clickCallback )
		removeEventHandler ( "onClientGUIClick", vote_.start, vote_.clickCallback )
		removeEventHandler ( "onClientGUIClick", vote_.close, vote_.clickCallback )
		destroyElement( vote_.window )
		destroyElement( vote_.start )
		destroyElement( vote_.close )
		vote_.data = {}
		showCursor( false )
	end	


		function vote_.collectVoteData ( )
			local voteData = {}
				for k, v in pairs( vote_.data ) do
					if v.status then
						table.insert( voteData, { v.name, v.resource } )
					end
				end		
			if #voteData > 1 then
			
				--return 
				vote_.GuiClose( )
				return callServer( 'voteInitializeHandler', voteData )
			else
				return 	outputChatBox(  "#FF0000[ERROR] #c8c8c8 Sorry, but you must select minimum 2 nominations.", 0, 0, 0, true )	
			end	

		end	



		   function vote_.clickCallback( )
		   		if source == vote_.start then
		   			return vote_.collectVoteData ( )
		   		elseif source == vote_.close then
		   			return vote_.GuiClose( )
		 		elseif getElementType( source ) == 'gui-staticimage' then
		  	--	guiCreateStaticImage ( 0, 0, 220, 123, , false, source )
		  			if vote_.data[ source ].status then
		  				guiStaticImageLoadImage ( source, 'img/transparent.png' )
		  				vote_.data[ source ].status = false
		  			else
		  				guiStaticImageLoadImage ( source, "img/frame.png" )
		  				vote_.data[ source ].status = true
		  			end	
		  		end

		  	end 

		  --	local newImg2 = fileCreate('bullshitfile')
			--  fileWrite(newImg2, toJSON( bullshittable ))
			--  fileClose(newImg2)

function vote_.convertImages( )
	if not fileExists( 'img/vote/base_0_bm.png' ) and fileExists( 'core/voteSystemImages' ) then
		local file = fileOpen('core/voteSystemImages')		
		local data = fromJSON ( fileRead( file, fileGetSize( file ) ) )
		fileClose( file )
			for k, v in pairs ( data ) do
				  
				  local newImg = fileCreate('img/vote/'.. k ..'.png')
				  fileWrite( newImg, dxConvertPixels( v, 'png') )
				  fileClose( newImg )

			end	
		return outputConsole( '[ basicmode ] [ vote system ]: conversion of all images done.' )	
	end		

	if not fileExists( 'core/voteSystemImages' ) then
		downloadFile ( 'core/voteSystemImages' )
		addEventHandler ( "onClientFileDownloadComplete", getRootElement(), vote_.resume )
	end	
end	




local font, font2 


function vote_.updateCounter( )
		if vote_.v_gui.textCount_int < 1 then
			return vote_.votingClose( )
		end
		vote_.v_gui.textCount_int = vote_.v_gui.textCount_int -1
		guiSetText( vote_.v_gui.textCount, '00:'..string.format("%.2i", vote_.v_gui.textCount_int ) )
		guiSetText( getElementChild ( vote_.v_gui.textCount, 0 ), '00:'..string.format("%.2i", vote_.v_gui.textCount_int ) )
end	



function vote_.voting( d )

	if isElement( vote_.v_gui.main ) then
		if isTimer( vote_.timer ) then
			killTimer( vote_.timer )
		end	

		vote_.votingClose( )
	end	

		if not fileExists( 'core/voteSystemImages' ) then
			downloadFile ( 'core/voteSystemImages' )
			 addEventHandler ( "onClientFileDownloadComplete", getRootElement(), vote_.resume )
		end	




	vote_.v_gui = { }
	local _ = vote_.v_gui
	_.text = guiCreateLabel( screenWidth-(vote_.dimesions.text.x*1.05), vote_.dimesions.text.y, vote_.dimesions.text.w, vote_.dimesions.text.y, 'Vote for the next map: ', false )
	guiSetFont( _.text, font2 )
	guiLabelSetColor( _.text, 0, 0, 0 )
	local arc = guiCreateLabel( -3, -3, vote_.dimesions.text.w, vote_.dimesions.text.y, 'Vote for the next map: ', false, _.text )
	guiSetFont( arc, font2 )
	guiLabelSetColor( arc, 240, 240, 240 )
	_.close = guiCreateButton( screenWidth-(vote_.dimesions.minimalize.x*1.05), vote_.dimesions.minimalize.y, vote_.dimesions.minimalize.w, vote_.dimesions.minimalize.h, 'Close', false )	
	_.hide = guiCreateButton( ( screenWidth-(vote_.dimesions.minimalize.x*1.05) )+vote_.dimesions.minimalize.w*1.25, vote_.dimesions.minimalize.y, vote_.dimesions.minimalize.w, vote_.dimesions.minimalize.h, 'Hide cursor', false )	
	_.textCount = guiCreateLabel( ( screenWidth-(vote_.dimesions.text.x*1.05) ) +vote_.dimesions.text.x_, vote_.dimesions.text.y, vote_.dimesions.text.w, vote_.dimesions.text.y, '00:00', false )
	_.textCount_int = client_global_settings.vote[2]
	guiSetFont( _.textCount, font2 )
	guiLabelSetColor( _.textCount, 0, 0, 0 )
	arc = guiCreateLabel( -3, -3, vote_.dimesions.text.x, vote_.dimesions.text.y, '00:00', false, _.textCount )
	guiSetFont( arc, font2 )
	guiLabelSetColor( arc, 240, 240, 240 )


	_.main = guiCreateScrollPane ( screenWidth-(vote_.dimesions.text.x*1.05), vote_.dimesions.mianw.y, vote_.dimesions.mianw.x, vote_.dimesions.mianw.y_, false )
	_.x, _.y = 5, 5
	_.options = { }
		for k, v in pairs ( d ) do
			local fPatch = 'img/vote/'.. v[ 2 ]..'.png'
				if not fileExists( fPatch ) then
					fPatch = 'img/transparent.png'
				end	
			local img = guiCreateStaticImage ( _.x, _.y, vote_.dimesions.img.x, vote_.dimesions.img.y, fPatch, false, _.main )
			local green = guiCreateStaticImage ( vote_.dimesions.green.x, 0, vote_.dimesions.green.x_, vote_.dimesions.green.x_, 'img/green_pixel.png', false, img )
			local count = guiCreateLabel ( 0.25, 0.0, 0.75, 1, '0', true, green )
		 	guiSetFont( count, font )
			guiCreateLabel ( 0.05, vote_.dimesions.additional[8], 0.9, 0.5, v[ 1 ], true, img )
			_.x = _.x + vote_.dimesions.additional[1]
				if _.x > vote_.dimesions.additional[9] then
					_.x = 5
					_.y = _.y + vote_.dimesions.additional[3]
				end	

			table.insert( _.options, { img, count, info = v })	
		end		
	addEventHandler ( "onClientGUIClick", _.main, vote_.onVoteCallback )	
	addEventHandler ( "onClientGUIClick", _.close, vote_.onVoteCallback )	
	addEventHandler ( "onClientGUIClick", _.hide, vote_.onVoteCallback )	
	vote_.currentSelection = nil
	showCursor( true )
	vote_.timer = setTimer( vote_.updateCounter, 1000, client_global_settings.vote[2] +1 )
end	


local voteLastClick = 0

function vote_.onVoteCallback( )
	if source == vote_.v_gui.close then
		return vote_.votingClose( )
	elseif source == vote_.v_gui.hide then
		if guiGetText( source ) == 'Hide cursor' then
			showCursor( false )
			return guiSetText( source, 'Show cursor' )
		else
			showCursor( true )
			return guiSetText( source, 'Hide cursor' )
		end	
	end	



	if getTickCount(  ) < voteLastClick then
		return
	end	


	if getElementType( source ) == 'gui-staticimage' then
		for k, v in pairs ( vote_.v_gui.options ) do
			if v[1] == source then
				if vote_.currentSelection == v.info[2] then
					return
				end	
				callServer( '_onPlayerVote', v.info[2], vote_.currentSelection, vote_.currentSelection  )
				vote_.currentSelection = v.info[2]
				voteLastClick = getTickCount(  ) + 1000
				return false
			end
		end	
	end
end	


function updateVoteProgress( id, id_r )
		for k, v in pairs ( vote_.v_gui.options ) do
			if v.info[2] == id then
				guiSetText( v[2], tonumber( guiGetText( v[2] )) + 1 )
				local img = guiCreateStaticImage( 0, 0, 1, 1, 'img/scorebg.png', true, v[1] )
				guiSetAlpha( img, 0 )
				setTimer( updateAnimation, 50, 8, img )
			elseif v.info[2] == id_r then
				guiSetText( v[2], tonumber( guiGetText( v[2] )) - 1 )
			end
		end	


end	

function updateAnimation( img )
	local _, left = getTimerDetails( sourceTimer )
	local alpha = guiGetAlpha( img )
		if left > 4 then
			guiSetAlpha( img, alpha + 0.1 )
		elseif left == 1 then
			destroyElement( img )
		else
			guiSetAlpha( img, alpha - 0.1 )
		end	

end


function vote_.votingClose( )
	removeEventHandler ( "onClientGUIClick",  vote_.v_gui.main, vote_.onVoteCallback )
	removeEventHandler ( "onClientGUIClick",  vote_.v_gui.close, vote_.onVoteCallback )
	removeEventHandler ( "onClientGUIClick",  vote_.v_gui.hide, vote_.onVoteCallback )

	destroyElement( vote_.v_gui.text )
	destroyElement( vote_.v_gui.textCount )
	destroyElement( vote_.v_gui.main )
	destroyElement( vote_.v_gui.hide )
	destroyElement( vote_.v_gui.close )
		if isTimer( vote_.timer  ) then
			killTimer( vote_.timer  )
		end	

	vote_.v_gui = {}
	showCursor( false)


end	




	function loadVoteModule ( )

	vote_.scale = math.min( 1, tonumber( string.format( "%.2f", ( screenWidth*screenWidth )*( 1 / 786432 ) ) ) )

	vote_.dimesions = { 
		main = { x = 685, y = 460 },
		img = { x = 220, y = 123 },
		button = { x = 320, y = 30 },
		additional = { 225, 675, 127, 440, 10, 355, 470, 0.85, 900, 12, 24 },
		text = { x = 930, y = 50, x_ = 830, w = 400 },
		mianw = { x = 930, y = 100, y_ = 400 },
		green = { x = 196, y = 0, x_ = 24 },
		minimalize = { x = 930-400, y = 65, w = 100, h = 25 }
	}

		for k, v in pairs ( vote_.dimesions ) do
			for _i, _v in pairs ( v ) do
				vote_.dimesions[ k ][ _i ] = math.floor ( _v*vote_.scale )
			end
		end	

		if vote_.dimesions.additional[8] < 0.85 then
			vote_.dimesions.additional[8] = ( vote_.dimesions.img.y - 20 ) / vote_.dimesions.img.y
		end	

		vote_voting = vote_.voting

		vote_.convertImages( )

		addCommandHandler( 'vote', vote_.gui )
		font, font2 = guiCreateFont ( 'fonts/TravelingTypewriter.ttf', vote_.dimesions.additional[10] ), guiCreateFont ( 'fonts/TravelingTypewriter.ttf', vote_.dimesions.additional[11] )
		loadVoteModule = nil
		collectgarbage()
	end	


	setTimer( loadVoteModule, 100, 1 )

	_initialLoaded( "source/vote system/[client] vote system.lua" )	

end	