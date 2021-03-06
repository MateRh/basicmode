
_initialLoading[ "shaders/depth_of_field/c_dof.lua" ] = function ( )


-----------------------------------------------------------------------------------
-- Pool of render targets
-----------------------------------------------------------------------------------
local RTPool = { list = {} }

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
--	outputDebugString( "creating new RT " .. tostring(sx) .. " x " .. tostring(sx) )
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



local orderPriority = "-2.7"	-- The lower this number, the later the effect is applied

local Settings = { var = {} }

local scx, scy = guiGetScreenSize ()
local dEffectEnabled
local myScreenSource_dof
local dBlurHShader
local dBlurVShader
local dBShader
local bAllValid
local distTimer
local effectParts = {}
local _dxDrawImage 

local function getDepthBuffer(Src, fadeStart, fadeEnd, farClip, maxCut, maxCutBlur ) 
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	
	dxSetShaderValue( dBShader, "gFadeStart", fadeStart )
	dxSetShaderValue( dBShader, "gFadeEnd",fadeEnd )
	dxSetShaderValue( dBShader, "sFarClip", farClip )
	dxSetShaderValue( dBShader, "sMaxCut", maxCut )
	dxSetShaderValue( dBShader, "sMaxCutBlur", maxCutBlur )
	dxDrawImage( 0, 0, mx, my, dBShader )
--	DebugResults.addItem( newRT, "GetDepthValues" )
	return newRT
end

local function applyGDepthBlurH( Src,getDepth,blur,brightBlur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( dBlurHShader, "TEX0", Src )
	dxSetShaderValue( dBlurHShader, "TEX1", getDepth )
	dxSetShaderValue( dBlurHShader, "tex0size", mx,my )
	dxSetShaderValue( dBlurVShader, "gblurFactor",blur )
	dxSetShaderValue( dBlurVShader, "gBrightBlur",brightBlur )
	dxDrawImage( 0, 0, mx, my, dBlurHShader )
--	DebugResults.addItem( newRT, "DepthBlurH" )
	return newRT
end

local function applyGDepthBlurV( Src,getDepth,blur,brightBlur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( dBlurVShader, "TEX0", Src )
	dxSetShaderValue( dBlurVShader, "TEX1", getDepth )
	dxSetShaderValue( dBlurVShader, "tex0size", mx,my )
	dxSetShaderValue( dBlurVShader, "gblurFactor",blur )
	dxDrawImage( 0, 0, mx,my, dBlurVShader )
	--DebugResults.addItem( newRT, "DepthBlurV" )
	return newRT
end

----------------------------------------------------------------
-- Avoid errors messages when memory is low
----------------------------------------------------------------

_dxDrawImage = dxDrawImage
local function xdxDrawImage(posX, posY, width, height, image, ... )
	if not image then return false end
	return _dxDrawImage( posX, posY, width, height, image, ... )
end


---------------------------------
-- DepthBuffer access
---------------------------------
local function isDepthBufferAccessible()
	local info=dxGetStatus()
	local depthStatus=false
		for k,v in pairs(info) do
			if string.find(k, "DepthBufferFormat") then
			--	outputDebugString("DepthBufferFormat: "..tostring(v))
				depthStatus=true
				if tostring(v)=='unknown' then depthStatus=false end
			end
		end
	return depthStatus
end


----------------------------------------------------------------
-- enableDoF
----------------------------------------------------------------


local function setEffectVariables()
    local v = Settings.var
    -- DoF
    v.blurFactor = 0.9 -- blur ammount
    v.brightBlur = false -- should darker pixel get less blur
	-- Depth Spread
    v.fadeStart = 1
    v.fadeEnd = 700
    v.maxCut = true -- should the sky not to be blured
    v.locked = false
    v.farClip = getFarClipDistance () * 0.9995
    v.maxCutBlur = 0.5 -- max sky blur (percentage of orig blur)

	-- Debugging
    v.PreviewEnable=0
    v.PreviewPosY=0
    v.PreviewPosX=100
    v.PreviewSize=70
end

local function disableDoF()
	if not dEffectEnabled then return end
	-- Destroy all shaders

		if isTimer( distTimer ) then
			killTimer( distTimer )
		end	
	removeEventHandler( "onClientHUDRender", root, dofRender, true ,"low" .. orderPriority )
	for _,part in ipairs(effectParts) do
		if part then
			destroyElement( part )
		end
	end
	effectParts = {}
	bAllValid = false
	RTPool.clear()
	
	-- Flag effect as stopped
	dEffectEnabled = false
end




local function enableDoF()
	if dEffectEnabled then return end
	-- Create things
	myScreenSource_dof = dxCreateScreenSource( scx, scy )
	local tecName
	dBlurHShader,tecName = dxCreateShader( "shaders/depth_of_field/fx/dBlurH.fx" )
--	outputDebugString( "blurHShader is using technique " .. tostring(tecName) )

	dBlurVShader,tecName = dxCreateShader( "shaders/depth_of_field/fx/dBlurV.fx" )
--	outputDebugString( "blurVShader is using technique " .. tostring(tecName) )
	
	dBShader,tecName = dxCreateShader( "shaders/depth_of_field/fx/getDepth.fx" )
--	outputDebugString( "dBShader is using technique " .. tostring(tecName) )
	
	-- Get list of all elements used
	effectParts = {
						myScreenSource_dof,
						dBlurHShader,
						dBlurVShader,
						dBShader,
					}

	-- Check list of all elements used
	bAllValid = true
	for _,part in ipairs(effectParts) do
		bAllValid = part and bAllValid
	end
	
	setEffectVariables ()
	dEffectEnabled = true
	
	if not bAllValid then
	--	outputChatBox( "DoF: Could not create some things. Please use debugscript 3" )
		disableDoF()
	else
		distTimer = setTimer(function()
				if not Settings.var.locked then
					Settings.var.farClip = getFarClipDistance () * 0.9995
				end	
		end,1000,0 )
		addEventHandler( "onClientHUDRender", root, dofRender, true ,"low" .. orderPriority )
	end	
end

----------------------------------------------------------------
-- disableDoF
----------------------------------------------------------------


---------------------------------
-- Settings for effect
---------------------------------

--[[
local function setEffectVariables()
    local v = Settings.var
    -- DoF
    v.blurFactor = 0.9 -- blur ammount
    v.brightBlur = true -- should darker pixel get less blur
	-- Depth Spread
    v.fadeStart = 1
    v.fadeEnd = 700
    v.maxCut = true -- should the sky not to be blured
    v.farClip = 1000 -- changes depending on the farClip
    v.maxCutBlur = 0.5 -- max sky blur (percentage of orig blur)

	-- Debugging
    v.PreviewEnable=0
    v.PreviewPosY=0
    v.PreviewPosX=100
    v.PreviewSize=70
end]]

-----------------------------------------------------------------------------------
-- onClientHUDRender
-----------------------------------------------------------------------------------

    function dofRender()
			if not bAllValid or not Settings.var then return end
			
			local v = Settings.var	
			-- Reset render target pool
			RTPool.frameStart()
			--DebugResults.frameStart()
			-- Update screen
			dxUpdateScreenSource( myScreenSource_dof, true )
			-- Start with screen
			local current = myScreenSource_dof

			-- Apply all the effects, bouncing from one render target to another

			local getDepth = getDepthBuffer( current,v.fadeStart,v.fadeEnd ,v.farClip,v.maxCut,v.maxCutBlur ) 
			current = applyGDepthBlurH( current,getDepth,v.blurFactor,v.brightBlur )
			current = applyGDepthBlurV( current,getDepth,v.blurFactor,v.brightBlur )

			-- When we're done, turn the render target back to default
			dxSetRenderTarget()
			
			if current then dxDrawImage( 0, 0, scx, scy, current, 0, 0, 0, tocolor(255,255,255,255) ) end
			--if getDepth then dxDrawImage( 0.75*scx, 0, scx/4, scy/4, getDepth, 0, 0, 0, tocolor(255,255,255,255) ) end
			-- Debug stuff
		--	Settings.var.farClip = getFarClipDistance () * 0.9995

		end


-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------


function dofSwitch( bool )
	if bool then
		if not dEffectEnabled then
			enableDoF()
		end
	else
		if dEffectEnabled then
			disableDoF()
		end
	end
end

function dofUpdateSettings( bFactor, bBlur, fStart, fEnd, mCut,  mCutBlur, mFar, mLocked )
    local v = Settings.var

    v.blurFactor = bFactor or  v.blurFactor 
    v.brightBlur = bBlur or v.brightBlur 

    v.fadeStart = fStart or v.fadeStart
    v.fadeEnd = fEnd or v.fadeEnd
    v.maxCut = mCut or v.maxCut
    v.farClip = mFar or  v.farClip 
    v.locked = mLocked or false
    v.maxCutBlur = mCutBlur or v.maxCutBlur 


end


setEffectVariables()


	_initialLoaded( "shaders/depth_of_field/c_dof.lua" )	

end