
_initialLoading[ "shaders/bump/c_shader_bump.lua" ] = function ( )


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

function RTPool.GetUnused( mx, my )
	-- Find unused existing
	for rt,info in pairs(RTPool.list) do
		if not info.bInUse and info.mx == mx and info.my == my then
			info.bInUse = true
			return rt
		end
	end
	-- Add new
	local rt = dxCreateRenderTarget( mx, my )
	if rt then
--		outputDebugString( "creating new RT " .. tostring(mx) .. " x " .. tostring(mx) )
		RTPool.list[rt] = { bInUse = true, mx = mx, my = my }
	end
	return rt
end

-----------------------------------------------------------------------------------
-- Shader code
-----------------------------------------------------------------------------------

local scx, scy = guiGetScreenSize()
scx=scx/2
scy=scy/2
-----------------------------------------------------------------------------------
-- Le settings
-----------------------------------------------------------------------------------
local Settings = {}
Settings.var = {}

Settings.var.bloom = 1.176
Settings.var.xzoom = 1
Settings.var.yzoom = 0.78
Settings.var.bFac = 0.24
Settings.var.xval = 1.03
Settings.var.yval = 1.05
Settings.var.efInte = 0.5 -- 0.56
Settings.var.brFac = 0.5 -- 0.32
local myScreenSource, blurHShader, blurVShader, fakeBumpMapShader, bAllValid
-- List of world textures to exclude from this effect
				
					
					local removeList = {
						"",		-- unnamed
						"sitem16",							-- unnamed
						"gunshell",							-- unnamed
						"snipercrosshair",							-- unnamed
						"siterocket",							-- unnamed
						"lock*",							-- unnamed
						"basketball2","skybox_tex",	   				    -- other
						"*muzzle*",								-- guns
						"*sphere*",								-- guns
						"*sparks*",								-- guns
						"flame*",								-- guns
						"blaze*",								-- guns
						"gunflash*",								-- guns
						"font*","radar*",								-- hud
						"fireba*",
						"vehicle*", "?emap*", "?hite*",					-- vehicles
						"*92*", "*wheel*", "*interior*",				-- vehicles
						"*handle*", "*body*", "*decal*",				-- vehicles
						"*8bit*", "*logos*", "*badge*",					-- vehicles
						"*plate*", "*sign*", "*headlight*",				-- vehicles
						"vehiclegeneric256","vehicleshatter128", 		-- vehicles
						"*shad*",										-- shadows
						"coronastar","coronamoon","coronaringa",
						"coronaheadlightline",							-- coronas
						"lunar",										-- moon
						"tx*",											-- grass effect
						"lod*",										-- lod models
						"cj_w_grad",									-- checkpoint texture
						"*cloud*",										-- clouds
						"*smoke*",										-- smoke
						"sphere_cj",									-- nitro heat haze mask
						"particle*",									-- particle skid and maybe others
						"water*","newaterfal1_256",
						"splash*",
						
						"sw_sand", "coral",							-- sea
						"boatwake*","splash_up","carsplash_*",			-- splash
						"gensplash","wjet4","bubbles","blood*",			-- splash
						"sm_des_bush*", "*tree*", "*ivy*", "*pine*",	-- trees and shrubs
						"veg_*", "*largefur*", "hazelbr*", "weeelm",
						"*branch*", "cypress*", "plant*", "sm_josh_leaf",
						"trunk3", "*bark*", "gen_log", "trunk5","veg_bush2", 
						"fist","*icon","headlight*",
						"unnamed",
						"gun*",
						"*tree*",
					}	
					
					

									
local function applyBumpToTexture(fakeBumpMapShader)

	engineApplyShaderToWorldTexture ( fakeBumpMapShader, "*" )
	-- Apply settings
	dxSetShaderValue( fakeBumpMapShader, "xzoom", Settings.var.xzoom )
	dxSetShaderValue( fakeBumpMapShader, "yzoom", Settings.var.yzoom )
	dxSetShaderValue( fakeBumpMapShader, "bFac", Settings.var.bFac )	
	dxSetShaderValue( fakeBumpMapShader, "xval", Settings.var.xval )
	dxSetShaderValue( fakeBumpMapShader, "yval", Settings.var.yval )	
    dxSetShaderValue( fakeBumpMapShader, "efInte", Settings.var.efInte )	
    dxSetShaderValue( fakeBumpMapShader, "brFac", Settings.var.brFac )
	-- Process remove list
	for _,removeMatch in ipairs(removeList) do
		engineRemoveShaderFromWorldTexture ( fakeBumpMapShader, removeMatch )
	end
	
end

----------------------------------------------------------------
-- onClientResourceStart
----------------------------------------------------------------
local bEnabledEffect = false



-----------------------------------------------------------------------------------
-- Apply the different stages
-----------------------------------------------------------------------------------

local function applyGBlurH( Src, bloom )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurHShader, "TEX0", Src )
	dxSetShaderValue( blurHShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurHShader, "BLOOM", bloom )
	dxDrawImage( 0, 0, mx, my, blurHShader )
	return newRT
end

local function applyGBlurV( Src, bloom )
	if not Src then return nil end
	local mx,my = dxGetMaterialSize( Src )
	local newRT = RTPool.GetUnused(mx,my)
	if not newRT then return nil end
	dxSetRenderTarget( newRT, true ) 
	dxSetShaderValue( blurVShader, "TEX0", Src )
	dxSetShaderValue( blurVShader, "TEX0SIZE", mx,my )
	dxSetShaderValue( blurVShader, "BLOOM", bloom )
	dxDrawImage( 0, 0, mx,my, blurVShader )
	return newRT
end


-----------------------------------------------------------------------------------
-- onClientHUDRender
-----------------------------------------------------------------------------------

local function onBumpHudRender()
		if not Settings.var then
			return
		end
			-- Reset render target pool
			RTPool.frameStart()
			-- Update screen
			dxUpdateScreenSource( myScreenSource )
			-- Start with screen
			local current = myScreenSource
			-- Apply all the effects, bouncing from one render target to another
			current = applyGBlurH( current, Settings.var.bloom )
			current = applyGBlurV( current, Settings.var.bloom )
			-- When we're done, turn the render target back to default
			dxSetRenderTarget()
			dxSetShaderValue ( fakeBumpMapShader, "sReflectionTexture", current );
    end


local function startBumbMaping()

		if bEnabledEffect then
			return false
		end
		
        myScreenSource = dxCreateScreenSource( scx, scy )
		
        blurHShader = dxCreateShader( "shaders/bump/blurH.fx" )

        blurVShader = dxCreateShader( "shaders/bump/blurV.fx" )
		fakeBumpMapShader,tecName = dxCreateShader ( "shaders/bump/shader_bump.fx",1,400,false,"world,object" )
		if not fakeBumpMapShader then return end
		applyBumpToTexture(fakeBumpMapShader)
		-- Check everything is ok
		if myScreenSource and blurHShader and blurVShader and fakeBumpMapShader then
			bEnabledEffect = true
			addEventHandler( "onClientHUDRender", root, onBumpHudRender )
		end	


	
	end
	
local function stopBumbMaping()

		if not bEnabledEffect then
			return false
		end
		for k, v in pairs( { myScreenSource, blurHShader, blurVShader, fakeBumpMapShader} ) do 
			if isElement( v ) then
				destroyElement( v )
			end
		end
		removeEventHandler( "onClientHUDRender", root, onBumpHudRender )
		bEnabledEffect = false
end


function switchBumpMapping( wsOn )
	if wsOn then
		startBumbMaping()
	else
		stopBumbMaping()
	end
end






	_initialLoaded( "shaders/bump/c_shader_bump.lua" )	

end
