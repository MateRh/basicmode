
--
-- c_blur.lua
--
 blur_enabled = false
local scx, scy = guiGetScreenSize()
local cache_frames_count = 0
-----------------------------------------------------------------------------------
-- Le settings
-----------------------------------------------------------------------------------
local Settings = {}
Settings.var = {}
Settings.var.blur = 2
Settings.var.static = false
Settings.var.partial = false
local myScreenSource, blurHShader, blurVShader, tecName, bAllValid


-----------------------------------------------------------------------------------
-- Pool of render targets
-----------------------------------------------------------------------------------
local RTPool = {}
RTPool.list = {}

function RTPool.frameStart()
local rt, info
	for rt,info in pairs(RTPool.list) do
		info.bInUse = false
	end
end

function RTPool.GetUnused( mx, my )
	-- Find unused existing
	local rt, info
	for rt,info in pairs(RTPool.list) do
		if not info.bInUse and info.mx == mx and info.my == my then
			info.bInUse = true
			return rt
		end
	end
	-- Add new
	local rt = dxCreateRenderTarget( mx, my )
	if rt then
		RTPool.list[rt] = { bInUse = true, mx = mx, my = my }
	end
	return rt
end

local function createShader()

		-- Create things
        myScreenSource = dxCreateScreenSource( scx, scy )

        blurHShader,tecName = dxCreateShader( "shaders/r_blur/blurH.fx" )

        blurVShader,tecName = dxCreateShader( "shaders/r_blur/blurV.fx" )

		-- Check everything is ok
		bAllValid = myScreenSource and blurHShader and blurVShader 

		if not bAllValid then
			outputChatBox( "Could not create some things. Please use debugscript 3" )
		end
end
-----------------------------------------------------------------------------------
-- onClientHUDRender
-----------------------------------------------------------------------------------



-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------
local function applyGBlurH( Src, blur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurHShader, "TEX0", Src )
	dxSetShaderValue( blurHShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurHShader, "BLUR", blur )
	dxDrawImage( 0, 0, mx, my, blurHShader )
	return newRT
end

local function applyGBlurV( Src, blur )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurVShader, "TEX0", Src )
	dxSetShaderValue( blurVShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurVShader, "BLUR", blur )
	dxDrawImage( 0, 0, mx,my, blurVShader )
	return newRT
end



local function blur_render ()
		if not Settings.var then
			return
		end
        if bAllValid then

		
			-- Reset render target pool
			RTPool.frameStart()
			--[[if Settings.var.static == true and  cache_frames_count > 0 then
				
			else	
				if Settings.var.static == true then
					cache_frames_count= cache_frames_count+1
				end]]
				
				
			-- Update screen
			if Settings.var.static == false then
				dxUpdateScreenSource( myScreenSource, true )
			end
			-- Start with screen
			local current = myScreenSource

			-- Apply all the effects, bouncing from one render target to another
			current = applyGBlurH( current, Settings.var.blur )
			current = applyGBlurV( current, Settings.var.blur )
		
			-- When we're done, turn the render target back to default
			dxSetRenderTarget()

			-- Mix result onto the screen using 'add' rather than 'alpha blend'
			if current then
				local col = tocolor(255, 255, 255, 255)
					if Settings.var.partial == false then
						dxDrawImage( 0, 0, scx, scy, current, 0,0,0, col )
					else
						local v = Settings.var.partial_data
						dxDrawImageSection ( v.x, v.y, v.w, v.h, v.x, v.y, v.w, v.h, current, 0,0,0, col )
					end
			end
        end
end


function blur_remote(bool, value, static, partial, x, y, w, h)
--outputChatBox( tostring( bool )..', '.. tostring( value )..', '.. tostring( static )..', '.. tostring( partial )..', '..tostring( bool )..', '..tostring( bool ) )
	if bool == true then
			if isElement (blurHShader) and isElement (blurVShader) then
				return false
			end	
			cache_frames_count = 0
			createShader()
			Settings.var.static = static or false
			Settings.var.partial = partial or false
			Settings.var.partial_data = { x = x, y = y, w = w, h = h }
			Settings.var.blur = value or 1
			dxUpdateScreenSource( myScreenSource, true )
			dxUpdateScreenSource( myScreenSource, true )
			addEventHandler( "onClientHUDRender", root,	blur_render)
			blur_enabled = true
			return true
		elseif bool == false then
			cache_frames_count = 0
			if isElement (blurHShader) and isElement (blurVShader) then
				destroyElement (blurVShader)
				destroyElement (blurHShader)
			end
			removeEventHandler( "onClientHUDRender", root,	blur_render)
			if isElement( myScreenSource ) then
				destroyElement( myScreenSource )
			end	
			cache_frames_count = 0
			blur_enabled = false
		else
			if isElement (blurHShader) and isElement (blurVShader) then
				Settings.var.static = static or false
				Settings.var.blur = value or 1
				dxSetShaderValue( blurVShader, "BLUR", Settings.var.blur )
				dxSetShaderValue( blurHShader, "BLUR", Settings.var.blur )
			end	
		end
	end

function blur_removeUpdate( var )
	Settings.var.blur = var or 1
end	