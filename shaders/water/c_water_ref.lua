
_initialLoading[ "shaders/water/c_water_ref.lua" ] = function ( )


--
-- c_water_ref.lua
--

---------------------------------
-- Version check
---------------------------------
local function isMTAUpToDate()
	local mtaVer = getVersion().sortable
	if getVersion ().sortable < "1.3.4-9.05899" then
		return false
	else
		return true
	end
end

---------------------------------
-- DepthBuffer access
---------------------------------
local function isDepthBufferAccessible()
	local info = dxGetStatus()
	local depthStatus = false
		for k,v in pairs(info) do
			if string.find(k, "DepthBufferFormat") then
				depthStatus=true
				if tostring(v)=='unknown' then depthStatus = false end
			end
		end
	return depthStatus
end

local downloading, dTimer = false, false
local onFileDownFinished 
local myShader, textureVol, textureCube, watTimer, wrEffectEnabled

local function startWaterRefract()
	if wrEffectEnabled then return end
	
	
		local _return = false
		for k, v in pairs( { 'cube_env.dds', 'wavemap.png' } ) do 
			if not fileExists( 'shaders/water/images/'..v ) then
				if not downloading then
				--	initiateFileTransfer( 'shaders/water/images/'..v, 250000 )
					downloadFile( 'shaders/water/images/'..v )
				end	
				_return = true
			end	
		end	
		
		if _return then
			downloading = true
				addEventHandler ( "onClientFileDownloadComplete", getRootElement(), onFileDownFinished )
			return 0;
		end	
	
		-- Create shader
		myShader, tec = dxCreateShader ( "shaders/water/fx/water_ref.fx" )
		if not myShader  then return end
			-- Set textures
			textureVol = dxCreateTexture ( "shaders/water/images/wavemap.png" )
			if not isDepthBufferAccessible() then 
				textureCube = dxCreateTexture ( "shaders/water/images/cube_env.dds" )
				dxSetShaderValue ( myShader, "sReflectionTexture", textureCube )
			end
			dxSetShaderValue ( myShader, "sRandomTexture", textureVol )
		--	dxSetShaderValue ( myShader, "normalMult", 0.5 )
		--	dxSetShaderValue ( myShader, "gBuffAlpha", 0.30)
		--	dxSetShaderValue ( myShader, "gDepthFactor", 0.06)
			
			dxSetShaderValue ( myShader, "normalMult", 0.24 )
			dxSetShaderValue ( myShader, "gBuffAlpha", 0.30)
			dxSetShaderValue ( myShader, "gDepthFactor", 0.03)
			-- Apply to global txd 13
			engineApplyShaderToWorldTexture ( myShader, "waterclear256" )
			
			-- Update water color incase it gets changed by persons unknown
			watTimer = setTimer(function()
							if myShader then
								local r,g,b,a = getWaterColor()
								dxSetShaderValue ( myShader, "sWaterColor", r/255, g/255, b/255, a/255 );
								local rSkyTop,gSkyTop,bSkyTop,rSkyBott,gSkyBott,bSkyBott = getSkyGradient ()
								dxSetShaderValue ( myShader, "sSkyColorTop", rSkyTop/255, gSkyTop/255, bSkyTop/255)
								dxSetShaderValue ( myShader, "sSkyColorBott", rSkyBott/255, gSkyBott/255, bSkyBott/255)
							end
						end
						,100,0 )
	wrEffectEnabled = true
end

local function onFileDownFinished_( file, success )

	if file == "shaders/water/images/wavemap.png" or file == "shaders/water/images/cube_env.dds" then
		if success then
			for k, v in pairs( { 'cube_env.dds', 'wavemap.png' } ) do 
				if not fileExists( 'shaders/water/images/'..v ) then
					return false
				end
			end		
			removeEventHandler ( "onClientFileDownloadComplete", getRootElement(), onFileDownFinished )
			setTimer( startWaterRefract, 500, 1 )
			downloading = false

		else
			downloadFile( file )
		end	
	end
end	

onFileDownFinished = onFileDownFinished_



local function stopWaterRefract()
	if not wrEffectEnabled then return end
	if myShader then
		killTimer(watTimer)
		engineRemoveShaderFromWorldTexture ( myShader, "waterclear256" )
		destroyElement(myShader)
		myShader = nil
		destroyElement(textureVol)
		textureVol = nil
		if textureCube then 
			destroyElement(textureCube)
			textureCube = nil
		end
	end
		wrEffectEnabled = false
end




function switchWaterShine( wsOn )
	if wsOn then
		startWaterRefract()
	else
		stopWaterRefract()
	end
end


	_initialLoaded( "shaders/water/c_water_ref.lua" )	

end