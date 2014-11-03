		function dxTextDrawoutline ( text, x, y, color, size, font )
		local outline = 2
		dxDrawText ( text, x-outline, y-outline , 0, 0, tocolor( 0, 0, 0 ), size, font )
		dxDrawText ( text, x, y-outline , 0, 0, tocolor( 0, 0, 0 ), size, font )
		dxDrawText ( text, x+outline, y+outline , 0, 0, tocolor( 0, 0, 0 ), size, font )
		dxDrawText ( text, x, y+outline , 0, 0, tocolor( 0, 0, 0 ), size, font )
		dxDrawText ( text, x-outline, y+outline , 0, 0, tocolor( 0, 0, 0 ), size, font )
		dxDrawText ( text, x+outline, y-outline , 0, 0, tocolor( 0, 0, 0 ), size, font )
		dxDrawText ( text, x-outline, y , 0, 0, tocolor( 0, 0, 0 ), size, font )
		dxDrawText ( text, x+outline, y , 0, 0, tocolor( 0, 0, 0 ), size, font )
		
		
		dxDrawText ( text, x, y , 0, 0, color, size, font )
	end
	
	local sx, sy = guiGetScreenSize( )
	 function render_bullshit()
	
			local e_ = getElementsByType ( "Central_Marker",getRootElement() )[1]		
				if e_ then
			local x, y, z = getElementData( e_, "posX"), getElementData( e_, "posY"), getElementData( e_, "posZ")
			local a, b, c = getCameraMatrix( )
			dxTextDrawoutline( string.format("%.0f", getDistanceBetweenPoints3D( x, y, z, a, b, c ) ) ..' m.',  sx*0.1, sy*0.65, tocolor( 255, 255, 255 ), 1, 'default' )
				end
		end 
		
		function onStart() --Callback triggered by edf
			addEventHandler ( "onClientRender", getRootElement(), render_bullshit )
			outputDebugString( 'bullshit render started' )
		end
		function onStop()
			removeEventHandler ( "onClientRender", getRootElement(), render_bullshit )
		end