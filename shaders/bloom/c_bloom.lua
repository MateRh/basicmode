
_initialLoading[ "shaders/bloom/c_bloom.lua" ] = function ( )


local scx, scy = guiGetScreenSize ()

-----------------------------------------------------------------------------------
-- Pool of render targets
-----------------------------------------------------------------------------------
local RTPool = {}
RTPool.list = {}

function RTPool.frameStart()
	for rt,info in pairs(RTPool.list) do
		info.bInUse = false
	end
end

function RTPool.GetUnused( sx, sy )
	-- Find unused existing
	for rt,info in pairs(RTPool.list) do
		if not info.bInUse and info.sx == sx and info.sy == sy then
			info.bInUse = true
			return rt
		end
	end
	-- Add new

	local rt = dxCreateRenderTarget( sx, sy )
	if rt then
		RTPool.list[rt] = { bInUse = true, sx = sx, sy = sy }
	end
	return rt
end

function RTPool.clear()
	for rt,info in pairs(RTPool.list) do
		destroyElement(rt)
	end
	RTPool.list = {}
end



--
-- c_bloom.lua
--
local orderPriority = "-1.0"	-- The lower this number, the later the effect is applied

local Settings = {}
Settings.var = {}
local bEffectEnabled, myScreenSource, blurHShader, blurVShader, brightPassShader, addBlendShader, effectParts, bAllValid
----------------------------------------------------------------
-- enableBloom
----------------------------------------------------------------



---------------------------------
-- Settings for effect
---------------------------------
local function setEffectVariables()
    local v = Settings.var
    -- Bloom
    v.cutoff = 0.08
    v.power = 1.0
	v.blur = 0.0
    v.bloom = 0.5
    v.blendR = 204
    v.blendG = 153
    v.blendB = 130
    v.blendA = 100

	-- Debugging
    v.PreviewEnable=0
    v.PreviewPosY=0
    v.PreviewPosX=100
    v.PreviewSize=70
end


local function applyDownsample( Src, amount )
	if not Src then return nil end
	amount = amount or 2
	local mx,my = dxGetMaterialSize( Src )
	mx = mx / amount
	my = my / amount
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT )
	dxDrawImage( 0, 0, mx, my, Src )
	return newRT
end

local function applyGBlurH( Src, bloom, blur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurHShader, "TEX0", Src )
	dxSetShaderValue( blurHShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurHShader, "BLOOM", bloom )
	dxSetShaderValue( blurHShader, "BLUR", blur )
	dxDrawImage( 0, 0, mx, my, blurHShader )
	return newRT
end

local function applyGBlurV( Src, bloom, blur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurVShader, "TEX0", Src )
	dxSetShaderValue( blurVShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurVShader, "BLOOM", bloom )
	dxSetShaderValue( blurVShader, "BLUR", blur )
	dxDrawImage( 0, 0, mx,my, blurVShader )
	return newRT
end

local function applyBrightPass( Src, cutoff, power )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( brightPassShader, "TEX0", Src )
	dxSetShaderValue( brightPassShader, "CUTOFF", cutoff )
	dxSetShaderValue( brightPassShader, "POWER", power )
	dxDrawImage( 0, 0, mx,my, brightPassShader )
	return newRT
end

-----------------------------------------------------------------------------------
-- onClientHUDRender
-----------------------------------------------------------------------------------

    function bloomRender()
		if not bAllValid or not Settings.var then return end
		local v = Settings.var	
			
		-- Reset render target pool
		RTPool.frameStart()
		-- Update screen
		dxUpdateScreenSource( myScreenSource, true )
			
		-- Start with screen
		local current = myScreenSource

		-- Apply all the effects, bouncing from one render target to another
		current = applyBrightPass( current, v.cutoff, v.power )
		current = applyDownsample( current )
		current = applyDownsample( current )
		current = applyGBlurH( current, v.bloom, v.blur )
		current = applyGBlurV( current, v.bloom, v.blur )

		-- When we're done, turn the render target back to default
		dxSetRenderTarget()

		-- Mix result onto the screen using 'add' rather than 'alpha blend'
		if current then
			dxSetShaderValue( addBlendShader, "TEX0", current )
			local col = tocolor(v.blendR, v.blendG, v.blendB, v.blendA)
			dxDrawImage( 0, 0, scx, scy, addBlendShader, 0,0,0, col )
		end
		-- Debug stuff

	end



-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------


----------------------------------------------------------------
-- Avoid errors messages when memory is low
----------------------------------------------------------------
_dxDrawImage = dxDrawImage
local function xdxDrawImage(posX, posY, width, height, image, ... )
	if not image then return false end
	return _dxDrawImage( posX, posY, width, height, image, ... )
end

local function enableBloom()
	if bEffectEnabled then return end
	-- Create things
	myScreenSource = dxCreateScreenSource( scx/2, scy/2 )

	blurHShader,tecName = dxCreateShader( "shaders/bloom/fx/blurH.fx" )
--	outputDebugString( "blurHShader is using technique " .. tostring(tecName) )

	blurVShader,tecName = dxCreateShader( "shaders/bloom/fx/blurV.fx" )
--	outputDebugString( "blurVShader is using technique " .. tostring(tecName) )

	brightPassShader,tecName = dxCreateShader( "shaders/bloom/fx/brightPass.fx" )
--	outputDebugString( "brightPassShader is using technique " .. tostring(tecName) )

    addBlendShader,tecName = dxCreateShader( "shaders/bloom/fx/addBlend.fx" )
--	outputDebugString( "addBlendShader is using technique " .. tostring(tecName) )

	-- Get list of all elements used
	effectParts = {
						myScreenSource,
						blurVShader,
						blurHShader,
						brightPassShader,
						addBlendShader,
					}

	-- Check list of all elements used
	bAllValid = true
	for _,part in ipairs(effectParts) do
		bAllValid = part and bAllValid
	end
	
	setEffectVariables ()
	bEffectEnabled = true
	
	if not bAllValid then
		--outputChatBox( "Bloom: Could not create some things. Please use debugscript 3" )
		disableBloom()
	else
		addEventHandler( "onClientHUDRender", root, bloomRender,true ,"low" .. orderPriority )	
	end	
end

-----------------------------------------------------------------------------------
-- disableBloom
-----------------------------------------------------------------------------------
local function disableBloom()
	if not bEffectEnabled then return end
	-- Destroy all shaders
	removeEventHandler( "onClientHUDRender", root, bloomRender )	
	for _,part in ipairs(effectParts) do
		if part then
			destroyElement( part )
		end
	end
	effectParts = {}
	bAllValid = false
	RTPool.clear()
	
	-- Flag effect as stopped
	bEffectEnabled = false
end



--------------------------------
-- Switch effect on or off
--------------------------------
function switchBloom( blOn )

	if blOn then
		enableBloom()
	else
		disableBloom()
	end
end


	_initialLoaded( "shaders/bloom/c_bloom.lua" )	

end