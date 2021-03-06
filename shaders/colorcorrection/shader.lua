
_initialLoading[ "shaders/colorcorrection/shader.lua" ] = function ( )


	local screenWidth, screenHeight = guiGetScreenSize()
	local screenSourceTexture = dxCreateScreenSource(screenWidth, screenHeight)
	local shader_color = false;


	        

	function createColorCorrectionShader( color, b, c, h )
		if not shader_color  then
			shader_color = dxCreateShader( "shaders/colorcorrection/shader.fx" )
				if shader_color then
					dxSetShaderValue( shader_color, "Saturation", color or 1)
					dxSetShaderValue( shader_color, "Brightness", b or 0 )
					dxSetShaderValue( shader_color, "Contrast", c or 0 )
					dxSetShaderValue( shader_color, "Hue", h or 0 )
					addEventHandler( "onClientPreRender", getRootElement(), updateShader )
				end
		else
			updateColorCorrectionShader( color, b, c, h )
		end	
	end

	function disableColorCorrectionShader(  )     
		if client_settings.correction.enable then
			updateColorCorrectionShader( client_settings.correction.satur, client_settings.correction.bright, client_settings.correction.contr, client_settings.correction.hue )
				return 0
		end	

		if isElement( shader_color ) then
			removeEventHandler( "onClientPreRender", getRootElement(), updateShader )
			destroyElement( shader_color )
			destroyElement( myScreenSource )
			shader_color = false
		end
	end

	function updateColorCorrectionShader( color, b, c, h )
		if isElement( shader_color ) then
			dxSetShaderValue( shader_color, "Saturation", color or 1)
			dxSetShaderValue( shader_color, "Brightness", b or 0 )
			dxSetShaderValue( shader_color, "Contrast", c or 0 )
			dxSetShaderValue( shader_color, "Hue", h or 0 )
		end	
	end

	function updateShader()

		dxUpdateScreenSource( screenSourceTexture )
		dxSetShaderValue( shader_color, "ScreenTexture", screenSourceTexture );
	    dxDrawImage( 0, 0, screenWidth, screenHeight, shader_color )

	end

	_initialLoaded( "shaders/colorcorrection/shader.lua" )	

end