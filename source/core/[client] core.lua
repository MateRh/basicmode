screenWidth, screenHeight  = guiGetScreenSize ( )
local intro = {}
local currentfile, fileName 

local f_anim = {}
alphat = 255
loadingTitle = 'Downloading...'
local _introDx = { }
function r_fadeanimation()
	local tc = getTickCount()
	dxDrawImage( 0, 0,  screenWidth, screenHeight, myScreenSource2,0,0,0,tocolor(255,255,255,alphat) )
	alphat = 255 - (  tc -f_anim.start)*f_anim.add
	
		if tc > f_anim.end_ then
		removeEventHandler( "onClientRender", root,r_fadeanimation )
		destroyElement( myScreenSource2 )
		end
end


	function sdasddsadsa(time, screen)
		if not isElement( myScreenSource2 ) then
			time = time or 1000
			f_anim = {start=getTickCount(),end_=getTickCount()+time,add=255/time}
			myScreenSource2 = screen or dxCreateScreenSource (  screenWidth, screenHeight ) 
			dxUpdateScreenSource( myScreenSource2 ,true) 
			alphat = 255
			addEventHandler( "onClientRender", root,r_fadeanimation )
		end	
	end

	
	function spawnAgain( )
		sdasddsadsa()
		callServer("_spawn_in_lobby", localPlayer, getPlayerTeam( localPlayer ) )	
	end
	

function scaleByWidth ( w, s, i )
	return tonumber( string.format( "%."..( i or 1 ).."f", screenWidth*( s / w ) ) )
end

function scaleInt( h ,s ,i )
	return tonumber( string.format( "%."..( i or 1 ).."f", screenHeight*( s/h ) ) )
end

function getCamPos_cords_rot_dis( x,y,z,obrot ,dystans )	
    obrot = obrot/180*3.14159265358979
    x = x - ( math.sin(obrot) * dystans )
    y = y + ( math.cos(obrot) * dystans )
	return x, y, z
end



local files =  {
				"shaders/colorcorrection/shader.fx",
				"shaders/colorcorrection/sharpen.fx",
				"shaders/r_blur/blurH.fx",
				"shaders/r_blur/blurV.fx",
				"shaders/r_blur/mta-helper.fx",
				"shaders/depth_of_field/fx/dBlurH.fx",
				"shaders/depth_of_field/fx/dBlurV.fx",
				"shaders/depth_of_field/fx/getDepth.fx",
				"shaders/depth_of_field/fx/mta-helper.fx",
				"shaders/car_reflect/fx/car_refgrun.fx",
				"shaders/car_reflect/fx/car_refgene.fx",
				"shaders/car_reflect/fx/mta-helper.fx",
				"shaders/water/fx/water_ref.fx",
				"shaders/water/fx/mta-helper.fx",
				"shaders/bump/shader_bump.fx",
				"shaders/bump/mta-helper.fx",
				"shaders/bump/blurH.fx",
				"shaders/bump/blurV.fx",
				"shaders/bloom/fx/addBlend.fx",
				"shaders/bloom/fx/blurH.fx",
				"shaders/bloom/fx/blurV.fx",
				"shaders/bloom/fx/brightPass.fx",
				"shaders/bloom/fx/mta-helper.fx",	
				"shaders/detail/fx/detail.fx",
				"shaders/detail/fx/mta-helper.fx",
				 "fonts/TravelingTypewriter.ttf" ,
				 "fonts/visitor.ttf" ,
				 "fonts/squarethings.ttf" ,
				 "fonts/TallLean.ttf" ,
				 "fonts/Inconsolata.otf" ,
				 "fonts/PTM55F.ttf" ,
				 "img/scoreboard/background_9.png" ,
				 "img/scoreboard/bg_shadow_hor.png" ,
				 "img/scoreboard/bg_shadow_ver.png" ,
				 "img/scoreboard/bg_shadow_cor.png" ,
				 "img/back.png" ,
				 "img/bound.png" ,
				 "img/colors_palette.png" ,
				 "img/cross.png" ,
				 "img/no_avatar.png" ,
				 "img/hud.png" ,
				 "img/dead.png" ,
				 "img/scorebg.png" ,
				 "img/scorebg_rev.png" ,
				 "img/frame.png" ,
				 "img/white_pixel.png" ,
				 "img/green_pixel.png" ,
				 "img/mark.png" ,
				 "img/mark_w.png" ,
				 "img/flag.png" ,
				 "img/capture_bar_bg.png" ,
				 "img/capture_flag.png" ,
				 "img/capture_bar.png" ,
				 "img/bar.png" ,
				 "img/transparent.png" ,
				 "img/_up.png" ,
				 "img/_down.png" ,
				 "img/blip.png" ,
				 "core/grenade.dff" ,
				 "core/grenade.txd" 
		}	

local script = {
	"shaders/colorcorrection/shader.lua",
	"shaders/depth_of_field/c_dof.lua",
	"shaders/car_reflect/c_car_reflect.lua",
	"shaders/water/c_water_ref.lua",
	"shaders/bump/c_shader_bump.lua",
	"shaders/bloom/c_bloom.lua",
	"shaders/detail/c_detail.lua",
	"client.lua",
	"round_finish_client.lua",
	"team_selection.lua",
	"spawn_selection.lua",
	"vehicle_selection.lua",
	"weapon_selection.lua",
	"admin_panel_client.lua",
	"hud_code.lua",
	"modes/base_client.lua",
	"source/round management/[client] round management.lua",	
	"maps_code_c.lua" ,
	"utilities/_clientSettings.lua",
	"extensions/spawn_protect.lua",
	"extensions/_cbug.lua",
	"extensions/bounds_c.lua",
	"extensions/restore_c.lua",
	"extensions/spectator_c.lua",
	"extensions/c_hud.lua",
	"extensions/interiors_client.lua",
	"source/weapon drop/[client] weapon drop.lua",	
	"source/files transfer/[client] file transfer.lua",
	"source/scoreboard/[client] scoreboard.lua",	
	"source/modern hud/[client] modern hud.lua",	
	"source/vote system/[client] vote system.lua",		
	"source/team selector/[client] team selector.lua",	
	"source/backup system/[client] backup system.lua",	
	"source/avatar upload/[client] avatar upload.lua",	
}


onebar = 2020 / #files


function isOnList( f )
	for _, file in ipairs( files ) do
		if f == file then
			return true
		end	
	end	
	return false
end	

function returnNextElement( f )
	for _, file in ipairs( script ) do
		if f == file then
			return script[ _+1 ]
		end	
	end	
end	

function onDownloadFinish ( file, success )
    if ( source == resourceRoot ) and isOnList( file ) then
    	currentfile = currentfile +1
    	fileName = files[ currentfile ]
     	
     		if ( currentfile > #files ) then
     			removeEventHandler ( "onClientFileDownloadComplete", getRootElement(), onDownloadFinish )
     			onebar = 2020 / #script
     			currentfile = 0
     			loadingTitle = 'Loading...'
     			fileName = '...'
     			
     			
	     			currentfile = 1
	     			fileName = script[ 1 ]
	     			_initialLoading[ script[ 1 ] ] ()
     		else
     			downloadFile( files[ currentfile ] )
     		end	
    end
end
addEventHandler ( "onClientFileDownloadComplete", getRootElement(), onDownloadFinish )




	
local white = tocolor(255,255,255,255)



function  _onCoreStart( )
	removeEventHandler( "onClientResourceStart", getResourceRootElement( getThisResource(  ) ), _onCoreStart )

  	local _ = _introDx
	local tmpScale =  math.min( 1024, scaleInt( 1024, 1080 ) )
	_.logo = { scale = tmpScale, x = ( screenWidth - tmpScale )/2, y = ( screenHeight - ( tmpScale*1.25 ) )/2,  start = getTickCount()+20000, end_ = getTickCount()+40000, add = 255/20000  }
	_.download = { x = _.logo.x, y = _.logo.y + tmpScale/1.1, w = tmpScale, h = string.format( "%.0f", tmpScale / 10 )}
	_.renderT = dxCreateRenderTarget( 2048, 2048/10, true  )
	currentfile = 1
	fileName = files[ currentfile ]
	sdasddsadsa( 200 )
	addEventHandler( 'onClientRender', getRootElement(), intro.func )
	
	setElementInterior( localPlayer, 0 )
	setElementDimension( localPlayer, 0 )
	setAmbientSoundEnabled( "general", false )
	setAmbientSoundEnabled( "gunfire", false )
	resetSkyGradient()
	
		downloadFile( files[ currentfile ] )
end 


_initialLoading = { }

 function _initialLoaded( _ )
	 _initialLoading.argument = _
	 _initialLoading.tick = getTickCount(  ) + 15
	 addEventHandler( 'onClientRender', getRootElement(), _initialOneFrame )
 end	


 function _initialOneFrame( )
 	removeEventHandler( 'onClientRender', getRootElement(), _initialOneFrame )
 	local nextF = returnNextElement(  _initialLoading.argument ) 
 		if not nextF then
 			local _ = _introDx
			_.logo.start = getTickCount()
			_.logo.end_ = getTickCount()+1500
			_.logo.add = 255/1500 
	 			return setTimer( function( )
						 			sdasddsadsa( 200 )	
						 			removeEventHandler( 'onClientRender', getRootElement(), intro.func )
						 			blur_remote( false )	
						 			teamSelectorInitialize( ) 
	 							end, 3000, 1 )
 		end	
 	fileName = nextF
	currentfile = currentfile + 1
 	_initialLoading [ nextF ] ()
 end	


function intro.func( )

	dxSetRenderTarget( _introDx.renderT, true )

		dxDrawText( loadingTitle , 0, 0, 0, 0, tocolor( 255, 255, 255 ), 2.5, "bankgothic" )
		dxDrawText( "current file: '".. fileName .."'" , 0, 30, 2048, 0, tocolor( 255, 255, 255 ), 3, "default", "right", "top", false, false, false, false, true )
		dxDrawImage ( 14, 100, 2020, 92, "img/capture_bar.png",0, 0, 0, tocolor( 120, 120, 120))
		dxDrawImage ( 14, 100, onebar *  currentfile, 92, "img/capture_bar.png" )
		local white = tocolor( 200, 200, 200 )
		dxDrawLine ( 0, 90, 2048, 90, white, 4)
		dxDrawLine ( 0, 202, 2048, 202, white, 4)
		dxDrawLine ( 2, 90, 2, 204, white, 4)
		dxDrawLine ( 2046, 90,  2046, 206, white, 4)

	dxSetRenderTarget( nil )


		local _, tc = _introDx.logo, getTickCount(  )
		if tc >_.start  then
			if tc > _.end_  then
				dxDrawImage( _.x, _.y, _.scale, _.scale, 'core/1BB87D41D15FE27B500A4BFCDE01BB0E.png', 0, 0, 0, tocolor( 255, 255, 255, math.min( 255, math.abs( 255 - (  tc - _.start)*_.add ) ) ) )
			else
				dxDrawImage( _.x, _.y, _.scale, _.scale, 'core/1BB87D41D15FE27B500A4BFCDE01BB0E', 0, 0, 0, tocolor( 255, 255, 255, math.max( 0,  255 - (  tc - _.start)*_.add ) ) )
			end
		else
			dxDrawImage( _.x, _.y, _.scale, _.scale, 'core/1BB87D41D15FE27B500A4BFCDE01BB0E' )
			_ = _introDx.download
			dxDrawImage( _.x, _.y, _.w, _.h, _introDx.renderT )	
		end

end 



	
setCameraMatrix( 2592.4489746094 , 2790.0314941406, 69.949996948242, 2589.9697265625, 2789.2475585938, 69.426483154297, math.random( -180, 180 ), 110 )
	
setPlayerHudComponentVisible ( 'area_name', false )
setPlayerHudComponentVisible ( 'radar', false )

local usable = { 124, 138, 89, 75 }
math.randomseed( ( getRealTime( ).timestamp - 1411500000 )^2 )
local id_r = usable[ math.random( 1, #usable ) ]
	sndGlobal = playSFX( "radio", "Radio X", id_r )
	setSoundVolume( sndGlobal, 0 )

setTimer( function() setSoundVolume( sndGlobal, getSoundVolume( sndGlobal ) + 0.0225 ) end, 50, 20)

blur_remote( true, 10 )
local farClip = 0
local blurC = 15
local farClipD = getFarClipDistance(  )-10
	function farClipfun( )
		farClip = farClip + 10

		if farClip > farClipD then
			 removeEventHandler( 'onClientRender', getRootElement(  ), farClipfun )
			 removeEventHandler( 'onClientPreRender', getRootElement(  ),  farClipfun)
			 resetFarClipDistance(  )
			return
		end
		setFarClipDistance( farClip )	
		
			if blurC > 2 then
				blurC = blurC - 0.05
			end		

		blur_removeUpdate( blurC )	
	end	
fadeCamera( true, 0.5 )
			

addEventHandler( 'onClientResourceStart', getResourceRootElement( ), _onCoreStart )
addEventHandler( 'onClientRender', getRootElement(  ), farClipfun )
addEventHandler( 'onClientPreRender', getRootElement(  ),  farClipfun )

--[[
setTimer( function() 
addEventHandler( 'onClientRender', getRootElement(  ), function ( )
	-- body

	dxDrawText( '1: '..tostring( _localPlayer:getStatus( 1 ) ), 100, 500)
	dxDrawText( '2: '..tostring( _localPlayer:getStatus( 2 ) ), 100, 550)
	dxDrawText( '3: '..tostring( _localPlayer:getStatus( 3 ) ), 100, 600)
end ) end, 3000, 1 )]]