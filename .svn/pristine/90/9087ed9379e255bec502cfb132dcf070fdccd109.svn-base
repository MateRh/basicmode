
--[[
local _radar = { 	
					scale = 1,
					x = scaleIntPercent( screenWidth, 4.5 ),
					y = scaleIntPercent( screenHeight, 50 ),
					wRT = scaleIntPercent( screenWidth, 17.5 ),
					hRT = scaleIntPercent( screenHeight, 20.0 ),
					texture = dxCreateTexture ( 'img/map.jpg', 'dxt1' ),
					zoom = 1.5,
				 }
	 
	_radar.w = _radar.wRT*1.5
	_radar.h = _radar.wRT
	_radar.pre = { ( ( _radar.w- _radar.wRT )*-1 ) / 2, ( ( _radar.w- _radar.hRT)*-1 ) / 2 }
	_radar.mapRT = dxCreateRenderTarget ( 	1536, 1536, true ); 	 
	_radar.rt = dxCreateRenderTarget ( 	_radar.wRT, _radar.hRT, true ); 	 
local mark1, mark2 = createMarker ( 0, 0, 0 , "cylinder", 0.005, 255, 0, 0 ), createMarker ( 0, 0, 0 , "cylinder", 0.005, 0, 0, 255 )
	addEventHandler( 'onClientRender', getRootElement(), 
		function( )

		

			dxDrawRectangle ( _radar.x-5, _radar.y-5, 5, _radar.hRT+10, tocolor( 0, 0, 0, 105 ) )
			dxDrawRectangle ( _radar.x, _radar.y-5, _radar.wRT+5, 5, tocolor( 0, 0, 0, 105 ) )
			dxDrawRectangle ( _radar.x+_radar.wRT, _radar.y, 5, _radar.hRT, tocolor( 0, 0, 0, 105 ) )
			dxDrawRectangle ( _radar.x, _radar.y+_radar.hRT, _radar.wRT+5, 5, tocolor( 0, 0, 0, 105 ) )
			local x, y = getElementPosition( localPlayer )
			x, y = 3000 + x, 3000 + y 
			x, y = x*0.256, y*-0.256
		--	outputChatBox( x..', '..y )
			dxSetRenderTarget( _radar.rt, true  )
			dxDrawImageSection ( _radar.pre[1], _radar.pre[2], _radar.w, _radar.w, x - ((_radar.h/_radar.zoom)/2 ) , y - ((_radar.h/_radar.zoom)/2 ), _radar.h/_radar.zoom, _radar.h/_radar.zoom, _radar.texture, getPedCameraRotation( localPlayer )*-1 )
			dxDrawRectangle(   _radar.wRT/2 - 2,  _radar.hRT/2 - 2, 4, 4, tocolor( 0, 0, 0, 255 ) )
			dxDrawRectangle(   _radar.wRT/2 - 1,  _radar.hRT/2 - 1, 2, 2, tocolor( math.random( 0, 255 ), math.random( 0, 255 ), math.random( 0, 255 ), 255 ) )
			

			dxSetRenderTarget(  )
		--	dxDrawImage( 0, 0, 1536, 1536, _radar.mapRT )
			dxDrawImage( _radar.x, _radar.y, _radar.wRT, _radar.hRT, _radar.rt, 0, 0, 0, tocolor( 255, 255, 255, 225 ) )

				
		end 
	)
	]]
