
_initialLoading[ "round_finish_client.lua" ] = function ( )

local finish_round_t = {data={},gui={}}

function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end
 -- pousuwac wszytskie fonty
function finishRoundAnimation( team1,team2, reson, rounds, skip)
		if type( reson ) == 'string' and string.find( reson, 'By using the command /end') ~= nil then
			_event_class.main( 'round_end_cmd', -1 )
		else
			_event_class.main( 'round_end', -1 )
		end
	blur_remote( true, 2.5, true )
	disableBoundSystem( )
	destroyInteriorsSystem(  )
	finish_round_t.screenSource = dxCreateScreenSource ( screenWidth, screenHeight )
	dxUpdateScreenSource ( finish_round_t.screenSource, true )
	finish_round_t.f_anim = {start=getTickCount(),end_=getTickCount()+500,add=255/500}
	finish_round_t.fonts = { dxCreateFont ( "fonts/TravelingTypewriter.ttf",string.format("%.0f",scaleInt(480,14)),false) or "bankgothic", dxCreateFont ( "fonts/TravelingTypewriter.ttf",string.format("%.0f",scaleInt(480,11)),false) or "default-bold" }
	finish_round_t.alpha = 255
	finish_round_t.finish = getTickCount() + 2000
	
	finish_round_t.arg = {team1,team2, reson, rounds, skip} 
		if skip == true then
			finish_round_t.pre_r = {"Round has been discontinued", reson, dxGetTextWidth ( "Round has been discontinued", 1 ,finish_round_t.fonts[1] ), dxGetTextWidth ( reson, 1, finish_round_t.fonts[2] ), "Round has been discontinued" }
		else
			finish_round_t.pre_r = {RGBToHex( getTeamColor( team1 ) )..getTeamName(team1)..RGBToHex( 225,225,225 ).." wins the round", reson, dxGetTextWidth ( getTeamName(team1).." wins the round", 1 ,finish_round_t.fonts[1] ), dxGetTextWidth ( reson, 1, finish_round_t.fonts[2] ), getTeamName(team1).." wins the round" }
		end
	finish_round_t.pre_r.main = {scaleIntPercent(screenWidth,50) - (finish_round_t.pre_r[3]/2), scaleIntPercent(screenHeight,47)}
	finish_round_t.pre_r.nd = {scaleIntPercent(screenWidth,50) - (finish_round_t.pre_r[4]/2), scaleIntPercent(screenHeight,53)}
	addEventHandler( "onClientRender", root, r_finishRoundPreAnimation )
	hideHud()
	if isElement( flashing_area ) then destroyElement( flashing_area ) end
end

function finishRoundCloseButton ( executed )
	if not isElement( finish_round_t.gui.button ) then return 0 end
	showCursor( false )
	removeEventHandler ( "onClientGUIClick", finish_round_t.gui.button, finishRoundCloseButton )
	if getTeamName( getPlayerTeam( localPlayer ) ) == 'Spectator' then
		disableSpecate ( )
	end	
	if executed ~= -9 then	
		sdasddsadsa(1000)
		callServer("_spawn_in_lobby", localPlayer, getPlayerTeam( localPlayer ))	
	end
	for k,v in ipairs( finish_round_t.gui.font ) do	
		destroyElement( v )
	end
	for k,v in ipairs( finish_round_t.fonts ) do	
		destroyElement( v )
	end	
	destroyElement ( finish_round_t.gui.tabpanel )
	finish_round_t = {data={},gui={}}
	blur_remote( false )
	countdown_stop()
	
		showHud()
		changeHudFunctionality( "lobby" )
	if executed ~= -9 then	
		showPlayerHudComponent( 'radar', true )
	end
	if executed == -9 then
		_players[ localPlayer ]:updateStatus(  2, 1 )
	end
end

function r_finishRoundPreAnimation()
	if getTickCount() > finish_round_t.finish then
	global_client_data = {}
	resetSkyGradient()
		if finish_round_t.arg[5] == true then
			removeEventHandler( "onClientRender", root, r_finishRoundPreAnimation )
				sdasddsadsa(1000)
					callServer("_spawn_in_lobby", localPlayer, getPlayerTeam( localPlayer ))	
							for k,v in ipairs( finish_round_t.fonts ) do	
								destroyElement( v )
							end	
							finish_round_t = {data={},gui={}}
								countdown_stop()
							blur_remote( false )
						showHud()
					changeHudFunctionality( "lobby" )
				showPlayerHudComponent( 'radar', true )
			return 
		end
			finish_round_t.f_anim = {start=getTickCount(),end_=getTickCount()+500,add=255/500}
			finish_round_t.alpha = 255
			local round_type = getElementData(getElementByIndex ( "root_gm_element",0 ),"map_info")
			createFinishRoundGui( finish_round_t.arg[1],finish_round_t.arg[2], tostring(round_type[1]).." "..tostring(round_type[2]), finish_round_t.arg[3], finish_round_t.arg[4])
			removeEventHandler( "onClientRender", root, r_finishRoundPreAnimation )
			addEventHandler( "onClientRender", root, r_finishRoundAnimation )
	end
	
	local tc = getTickCount()
	dxDrawImage( 0, 0,  screenWidth, screenHeight, finish_round_t.screenSource,0,0,0,tocolor(255,255,255,255 -finish_round_t.alpha) )
	finish_round_t.alpha = math.min( 255,  (  tc -finish_round_t.f_anim.start)*finish_round_t.f_anim.add )
	dxDrawBorderTextColored( finish_round_t.pre_r[1], finish_round_t.pre_r[5], finish_round_t.pre_r.main[1], finish_round_t.pre_r.main[2], tocolor( 225,225,225,finish_round_t.alpha ) , 1, finish_round_t.fonts[1] ,false, tocolor( 0, 0, 0,finish_round_t.alpha ),2,2)	
	dxDrawBorderText( finish_round_t.pre_r[2], finish_round_t.pre_r.nd[1], finish_round_t.pre_r.nd[2], tocolor( 225,225,225,finish_round_t.alpha ) ,1, finish_round_t.fonts[2],false, tocolor( 0, 0, 0,finish_round_t.alpha ),2,2)	
end


function r_finishRoundAnimation()
	local tc = getTickCount()
--	dxDrawImage( 0, 0,  screenWidth, screenHeight, finish_round_t.screenSource,0,0,0,tocolor(255,255,255,255 -finish_round_t.alpha) )
	finish_round_t.alpha =  (  tc -finish_round_t.f_anim.start)*finish_round_t.f_anim.add 
	guiSetAlpha( finish_round_t.gui.tabpanel, finish_round_t.alpha/255 )
	
		if tc > finish_round_t.f_anim.end_ then
		removeEventHandler( "onClientRender", root,r_finishRoundAnimation )
		destroyElement( finish_round_t.screenSource )
		resetSkyGradient()
		end
end





function getRelativeByScreenPositionViaElement(x,y,element)
	local xE,yE = guiGetSize(element,false)
	local nX,nY =x/xE,y/yE
	return nX,nY
end

function guiCreateShadowLabel ( x, y, width, height, text, relative, pattern, color, offset, font)
	local offX, offY = getRelativeByScreenPositionViaElement(offset,offset, pattern)
	local main = guiCreateLabel ( x +offX, y +offY, width, height, text, relative, pattern )
		guiLabelSetColor ( main, 0, 0, 0 )
		guiSetFont (  main, font )
	local colored = guiCreateLabel ( x, y, width, height, text, relative, pattern )	
		guiLabelSetColor ( colored, unpack(color) )
		guiSetFont (  colored, font )
		setElementParent ( colored, main )
	return main, colored
end	

function createFinishRoundGui( team1, team2, roundname, reson, rounds )
		if screenHeight > 600 then
			finish_round_t.gui.window_size = { 800, 600, "default-normal", 36, 46, 13 }
		else
			finish_round_t.gui.window_size = { 640, 480, "default-small", 29, 36, 11}
		end
	finish_round_t.gui.font = {}
	table.insert( finish_round_t.gui.font, 1,  guiCreateFont ( "fonts/TravelingTypewriter.ttf", finish_round_t.gui.window_size[4] ) )
	table.insert( finish_round_t.gui.font, 2,  guiCreateFont ( "fonts/TravelingTypewriter.ttf", finish_round_t.gui.window_size[5] )  )
	table.insert( finish_round_t.gui.font, 3,  guiCreateFont ( "fonts/TravelingTypewriter.ttf", finish_round_t.gui.window_size[6] ) )
		local _repeat_c = 0
	while ( not ( finish_round_t.gui.font[1] and finish_round_t.gui.font[2] and finish_round_t.gui.font[3] ) ) do 
		_repeat_c = _repeat_c + 1
		if _repeat_c > 2 then
			local _r_fonts = { 'sa-header', 'sa-gothic', 'default-bold-small' }
			for i=1, 3 do 
				if finish_round_t.gui.font [ i ] == false then
					finish_round_t.gui.font [ i ] = _r_fonts[ i ]
				end
			end	
			break;
		end
		for i=1, 3 do 
			if finish_round_t.gui.font [ i ] == false then
				finish_round_t.gui.font [ i ] = guiCreateFont ( "fonts/TravelingTypewriter.ttf", finish_round_t.gui.window_size[ 3 + i ] )
			end
		end
	end
	
	finish_round_t.gui.tabpanel = guiCreateTabPanel (  (screenWidth-finish_round_t.gui.window_size[1]) / 2, ( screenHeight - finish_round_t.gui.window_size[2] ) / 2, finish_round_t.gui.window_size[1], finish_round_t.gui.window_size[2], false )
	guiSetAlpha( finish_round_t.gui.tabpanel, 0 )
	finish_round_t.gui.tmain = guiCreateTab ( "Final Results",finish_round_t.gui.tabpanel )
	finish_round_t.gui.tabpanel_inside = guiCreateTabPanel (   0.02, 0.2, 0.96, 0.7, true, finish_round_t.gui.tmain )
	finish_round_t.gui.tscore = guiCreateTab ( "Score",finish_round_t.gui.tabpanel_inside )
	finish_round_t.gui.t1_t = guiCreateShadowLabel ( 0.05, 0.03, 0.2, 0.1, getTeamName( team1 ), true, finish_round_t.gui.tmain , {24,82,201}, 3.5, finish_round_t.gui.font[1])
	finish_round_t.gui.t2_t = { guiCreateShadowLabel ( 0.9475, 0.03, 0.2, 0.1, getTeamName( team2 ), true, finish_round_t.gui.tmain , {7,132,39}, 3.5, finish_round_t.gui.font[1]) }
	finish_round_t.gui.t1_t_t = guiCreateShadowLabel ( 0.06, 0.12, 0.2, 0.05,"( ".. getElementData(team1,"t_type") .." )",true, finish_round_t.gui.tmain , {225,225,225}, 2, finish_round_t.gui.font[3])
	finish_round_t.gui.t2_t_t = { guiCreateShadowLabel ( 0.9375, 0.12, 0.2, 0.05,"( ".. getElementData(team2,"t_type") .." )",true, finish_round_t.gui.tmain , {225,225,225}, 2, finish_round_t.gui.font[3]) }
		for k, v in pairs ( finish_round_t.gui.t2_t_t ) do
			local x,y = guiGetPosition ( v, false )
			guiSetPosition ( v,x - guiLabelGetTextExtent ( v ), y, false )
		end	
		for k, v in pairs ( finish_round_t.gui.t2_t ) do
			local x,y = guiGetPosition ( v, false )
			guiSetPosition ( v,x - guiLabelGetTextExtent ( v ), y, false )
		end

	finish_round_t.gui.score_t = { guiCreateShadowLabel ( 0.485, 0.06, 0.35, 0.2,(getElementData(team1,"Score")+1).." : "..getElementData(team2,"Score"),true, finish_round_t.gui.tmain , {225,225,225}, 4, finish_round_t.gui.font[2]) }
		for k, v in pairs ( finish_round_t.gui.score_t ) do
			local x,y = guiGetPosition ( v, false )
			guiSetPosition ( v,x - (guiLabelGetTextExtent ( v )/2), y, false )
		end
	finish_round_t.gui.round_t = { guiCreateShadowLabel ( 0.485, 0.02, 0.5, 0.1,"Round: "..roundname,true, finish_round_t.gui.tmain , {225,225,225}, 2, finish_round_t.gui.font[3]) }
		for k, v in pairs ( finish_round_t.gui.round_t ) do
			local x,y = guiGetPosition ( v, false )
			guiSetPosition ( v,x - (guiLabelGetTextExtent ( v )/2), y, false )
		end
	finish_round_t.gui.round_i = { guiCreateShadowLabel ( 0.485, 0.185, 0.5, 0.1,reson,true, finish_round_t.gui.tmain , {225,225,225}, 2, finish_round_t.gui.font[3]) }
		for k, v in pairs ( finish_round_t.gui.round_i ) do
			local x,y = guiGetPosition ( v, false )
			guiSetPosition ( v,x - (guiLabelGetTextExtent ( v )/2), y, false )
		end
	finish_round_t.gui.spect_t = { guiCreateShadowLabel ( 0.02, 0.915, 0.7, 0.1,"Spectators: ",true, finish_round_t.gui.tmain , {225,225,225}, 1, "normal") }	
	local pxX,pxY = getRelativeByScreenPositionViaElement(1,1,finish_round_t.gui.tabpanel_inside)
	finish_round_t.gui.grid1 = guiCreateGridList ( 0.0+pxX, 0.0+pxY, 0.5-(2*pxX), 1-(pxY*2), true, finish_round_t.gui.tscore )	
	guiGridListAddColumn ( finish_round_t.gui.grid1 ,"Name",0.4)
	guiGridListAddColumn ( finish_round_t.gui.grid1 ,"Kills",0.16)
	guiGridListAddColumn ( finish_round_t.gui.grid1 ,"Deaths",0.16)
	guiGridListAddColumn ( finish_round_t.gui.grid1 ,"Damage",0.16)

	for k, v in ipairs ( getPlayersInTeam ( team1 ) ) do
		if getElementData( v, "Kills") ~= false then
			local row = guiGridListAddRow ( finish_round_t.gui.grid1 )
			guiGridListSetItemText (  finish_round_t.gui.grid1, row, 1, getPlayerName( v ), false,false )
			guiGridListSetItemText (  finish_round_t.gui.grid1, row, 2, getElementData( v, "Kills" ), false,false )
			guiGridListSetItemText (  finish_round_t.gui.grid1, row, 3, getElementData( v, "Deaths" ), false,false )
			guiGridListSetItemText (  finish_round_t.gui.grid1, row, 4, getElementData( v, "Damage" ), false,false )
		end	
	end
	guiSetFont ( finish_round_t.gui.grid1, finish_round_t.gui.window_size[3])
	finish_round_t.gui.grid2 = guiCreateGridList ( 0.5+pxX ,0.0+pxY, 0.5-(2*pxX), 1-(2*pxY), true, finish_round_t.gui.tscore )
	guiGridListAddColumn ( finish_round_t.gui.grid2 ,"Name",0.4)
	guiGridListAddColumn ( finish_round_t.gui.grid2 ,"Kills",0.16)
	guiGridListAddColumn ( finish_round_t.gui.grid2 ,"Deaths",0.16)
	guiGridListAddColumn ( finish_round_t.gui.grid2 ,"Damage",0.16)
	for k, v in ipairs ( getPlayersInTeam ( team2 ) ) do
		if getElementData( v, "Kills") ~= false then
			local row = guiGridListAddRow ( finish_round_t.gui.grid2 )
			guiGridListSetItemText (  finish_round_t.gui.grid2, row, 1, getPlayerName( v ), false,false )
			guiGridListSetItemText (  finish_round_t.gui.grid2, row, 2, getElementData( v, "Kills" ), false,false )
			guiGridListSetItemText (  finish_round_t.gui.grid2, row, 3, getElementData( v, "Deaths" ), false,false )
			guiGridListSetItemText (  finish_round_t.gui.grid2, row, 4, getElementData( v, "Damage" ), false,false )
		end	
	end
	guiSetFont ( finish_round_t.gui.grid2, finish_round_t.gui.window_size[3])
	finish_round_t.gui.trounds = guiCreateTab ( "Rounds", finish_round_t.gui.tabpanel_inside )
	finish_round_t.gui.grid3 = guiCreateGridList ( 0+pxX, 0+pxY, 1-(2*pxX), 1-(2*pxY), true, finish_round_t.gui.trounds )	
	guiSetFont ( finish_round_t.gui.grid3, finish_round_t.gui.window_size[3])
	guiGridListAddColumn ( finish_round_t.gui.grid3 ,"Round Name",0.125)
	guiGridListAddColumn ( finish_round_t.gui.grid3 ,"Winner",0.15)
	guiGridListAddColumn ( finish_round_t.gui.grid3 ,"Loser",0.15)
	guiGridListAddColumn ( finish_round_t.gui.grid3 ,"Score",0.1)
	guiGridListAddColumn ( finish_round_t.gui.grid3 ,"Time",0.075)
	guiGridListAddColumn ( finish_round_t.gui.grid3 ,"Info",0.37)
	for k, v in ipairs ( rounds ) do
		local row = guiGridListAddRow ( finish_round_t.gui.grid3 )
			for k1, v1 in ipairs ( v ) do
				guiGridListSetItemText (  finish_round_t.gui.grid3, row, k1, v1, false,false )
			end
	end	
	finish_round_t.gui.button = guiCreateButton ( 0.79, 0.915, 0.18, 0.065, "3", true, finish_round_t.gui.tmain )
	
	guiSetEnabled(finish_round_t.gui.button, false )
	addEventHandler ( "onClientGUIClick", finish_round_t.gui.button, finishRoundCloseButton, false )
	showCursor( true ) 
	setTimer( function () setTimer( function () local num = tonumber( guiGetText ( finish_round_t.gui.button ) ) num = num - 1  guiSetText ( finish_round_t.gui.button, num ) if num == 0 then guiSetText ( finish_round_t.gui.button,"Close" ) guiSetEnabled(finish_round_t.gui.button, true ) end  end,1000,3) end,1000,1)
end


	_initialLoaded( "round_finish_client.lua" )	

end