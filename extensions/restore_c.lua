_initialLoading[ "extensions/restore_c.lua" ] = function ( )



local restore_data = { render = {}, gui = {} }

function createRestoreSceneWindow( places_data, player )
	if #places_data == 0 then
	--	return
	end	
	restore_data.data = places_data
	restore_data.player = player

	restore_data.gui.window = guiCreateTabPanel ( screenWidth-510, screenHeight-315, 500, 280, false )
	restore_data.gui.tab = guiCreateTab ( "Restore player:", restore_data.gui.window )
	restore_data.gui.grid = guiCreateGridList ( 0.025, 0.05, 0.95, 0.8, true, restore_data.gui.tab )
	guiGridListAddColumn ( restore_data.gui.grid , "Name", 0.5 )
	guiGridListAddColumn ( restore_data.gui.grid , "Time", 0.1 )
	guiGridListAddColumn ( restore_data.gui.grid , "Health", 0.15 )
	guiGridListAddColumn ( restore_data.gui.grid , "Vehicle", 0.2 )
	restore_data.gui.button1 = guiCreateButton( 0.025, 0.875, 0.4625, 0.1, "Cancel", true , restore_data.gui.tab )
	restore_data.gui.button2 = guiCreateButton( 0.5125, 0.875, 0.4625, 0.1, "select spawn", true , restore_data.gui.tab )
	local i = 0
			for k1,v1 in pairs( places_data ) do
				for k,v in ipairs( v1 ) do
					local row = guiGridListAddRow ( restore_data.gui.grid )

					guiGridListSetItemText ( restore_data.gui.grid, row, 1, v.name.." ( "..k.." )", false, false )
					guiGridListSetItemText ( restore_data.gui.grid, row, 2, v.time, false, false )
					guiGridListSetItemText ( restore_data.gui.grid, row, 3, math.round( v.hp, 1 ).."%", false, false )
					guiGridListSetItemText ( restore_data.gui.grid, row, 4, getVehicleName( v.vehicle.veh) or " No ", false, false )
						if i == 0 then
							guiGridListSetSelectedItem ( restore_data.gui.grid, row, 1 )
						end	
					i = i + 1
						if i == 1 then
							local cache = "\n"
							for k1,v1 in pairs( v.weapons ) do
								cache = cache..getWeaponNameFromID( v1[1])..":  "..v1[2]+v1[3].."\n"
							end
							restore_data.render = {  dx = {}, pos = v.pos, rot = 0, info = "#22d16c"..tostring( v.name ).."\n\nX: #ebebeb"..math.round(v.pos[1], 1 ).."#22d16c Y: #ebebeb"..math.round( v.pos[2], 1 ).." #22d16cZ:#ebebeb "..math.round( v.pos[3], 1 ).."\n\n#22d16cWeapons:#ebebeb\n"..cache	, fix = "X: "..math.round(v.pos[1], 1 ).." Y: "..math.round( v.pos[2], 1 ).." Z: "..math.round( v.pos[3], 1 )	}
						end
				end		
			end
		sdasddsadsa( 250 )	
		addEventHandler ( "onClientGUIClick", restore_data.gui.grid,  onGuiSelect )
		addEventHandler ( "onClientGUIClick", restore_data.gui.button1,  onGuiSelect )
		addEventHandler ( "onClientGUIClick", restore_data.gui.button2,  onGuiSelect )
		addEventHandler ( "onClientRender", getRootElement(), r_restore )
		showCursor( true )
end



	function onGuiSelect( )
		local select, cell = guiGridListGetSelectedItem ( restore_data.gui.grid )
			if select ~= -1 then
			local name = guiGridListGetItemText ( restore_data.gui.grid, select , 1  )
				if name then
					if source == restore_data.gui.grid then
						sdasddsadsa( 300 )
					for k1,v1 in pairs( restore_data.data ) do
						for k,v in ipairs( v1 ) do
								if v.name.." ( "..k.." )" == name then
									local cache = "\n"
									for k2,v2 in pairs( v.weapons ) do
										cache = cache..getWeaponNameFromID( v2[1])..":   "..v2[2]+v2[3].."\n"
									end
								restore_data.render = {  dx = {}, pos = v.pos, rot = 0, info = "#22d16c"..tostring( v.name ).."\n\nX: #ebebeb"..math.round(v.pos[1], 1 ).."#22d16c Y: #ebebeb"..math.round( v.pos[2], 1 ).." #22d16cZ:#ebebeb "..math.round( v.pos[3], 1 ).."\n\n#22d16cWeapons:#ebebeb\n"..cache	, fix = "X: "..math.round(v.pos[1], 1 ).." Y: "..math.round( v.pos[2], 1 ).." Z: "..math.round( v.pos[3], 1 )	}						
								end
							end
						end	
					elseif source == restore_data.gui.button1 then
						sdasddsadsa( 500 )
						
						removeEventHandler ( "onClientRender", getRootElement(), r_restore )
						removeEventHandler ( "onClientGUIClick", restore_data.gui.grid,  onGuiSelect )
						removeEventHandler ( "onClientGUIClick", restore_data.gui.button1,  onGuiSelect )
						removeEventHandler ( "onClientGUIClick", restore_data.gui.button2,  onGuiSelect )
						destroyElement( restore_data.gui.window )
						setCameraTarget( localPlayer )
						callServer( "restore_unfreze", localPlayer )
						restore_data = { render = {}, gui = {} }
						showCursor( false) 
					elseif source == restore_data.gui.button2 then
						for k1,v1 in pairs( restore_data.data ) do
							for k,v in ipairs( v1 ) do
								if v.name.." ( "..k.." )" == name then
									sdasddsadsa( 500 )
									
									removeEventHandler ( "onClientRender", getRootElement(), r_restore )
									removeEventHandler ( "onClientGUIClick", restore_data.gui.grid,  onGuiSelect )
									removeEventHandler ( "onClientGUIClick", restore_data.gui.button1,  onGuiSelect )
									removeEventHandler ( "onClientGUIClick", restore_data.gui.button2,  onGuiSelect )
									destroyElement( restore_data.gui.window )
									setCameraTarget( localPlayer )
									callServer( "restore_unfreze", localPlayer )
									callServer( "applyRestoreData", restore_data.player, k1, k )
									restore_data = { render = {}, gui = {} }
									showCursor( false) 
							end	
						end
						end	
					end		
				end
			end
	end

	function restore_forceDisable( )
		if not isElement( restore_data.gui.window ) then return 0 end
			
		removeEventHandler ( "onClientRender", getRootElement(), r_restore )
		removeEventHandler ( "onClientGUIClick", restore_data.gui.grid,  onGuiSelect )
		removeEventHandler ( "onClientGUIClick", restore_data.gui.button1,  onGuiSelect )
		removeEventHandler ( "onClientGUIClick", restore_data.gui.button2,  onGuiSelect )
		destroyElement( restore_data.gui.window )
		setCameraTarget( localPlayer )
		callServer( "restore_unfreze", localPlayer )
		restore_data = { render = {}, gui = {} }
	end

local frame_buffer = {0,0,0,0,0,0}
function r_restore()
	restore_data.render.rot = restore_data.render.rot + 0.3
	local count = getTickCount()
	local e_dis = -10
	local clear_ = {true}
	local x1, y1 ,z1 = 0, 0, 0
			while clear_[1] == true do
				x1, y1 ,z1 =  getCamPos_cords_rot_dis( restore_data.render.pos[1], restore_data.render.pos[2], restore_data.render.pos[3], restore_data.render.rot, e_dis )
				clear_ = {processLineOfSight ( restore_data.render.pos[1], restore_data.render.pos[2], restore_data.render.pos[3]+0.25, x1, y1, z1, true, false, false, false, false, false, false )}
				e_dis = e_dis + 0.15
				z1 = z1 +1
					if getTickCount() - count > 50 then
						clear_[1] = false
					end
			end
	x1, y1 ,z1 =  getCamPos_cords_rot_dis( x1, y1 ,z1, restore_data.render.rot, 0.5 )		
	
	setCameraMatrix ( ( x1 + frame_buffer[1] )/2, ( y1 + frame_buffer[2] )/2, ( z1 + frame_buffer[3] )/2, ( restore_data.render.pos[1] + frame_buffer[4] )/2, ( restore_data.render.pos[2] + frame_buffer[5] )/2, ( restore_data.render.pos[3] + frame_buffer[6] )/2 )
	frame_buffer = { x1,y1,z1,restore_data.render.pos[1],restore_data.render.pos[2],restore_data.render.pos[3] }
	dxDrawLine3D  (restore_data.render.pos[1], restore_data.render.pos[2], restore_data.render.pos[3]+0.01, restore_data.render.pos[1], restore_data.render.pos[2], restore_data.render.pos[3] +1.5, tocolor( 0,0,255), 4 )
	dxDrawLine3D  (restore_data.render.pos[1], restore_data.render.pos[2], restore_data.render.pos[3]+0.01, restore_data.render.pos[1] + 1, restore_data.render.pos[2], restore_data.render.pos[3]+0.01, tocolor( 255,0,0), 4)
	dxDrawLine3D  (restore_data.render.pos[1], restore_data.render.pos[2], restore_data.render.pos[3]+0.01, restore_data.render.pos[1] , restore_data.render.pos[2] +1, restore_data.render.pos[3]+0.01, tocolor( 0,255,0), 4 )
	local w, s = getScreenFromWorldPosition(restore_data.render.pos[1] , restore_data.render.pos[2] , restore_data.render.pos[3] +1.4 )
		if w and s then
			dxDrawTextBackground( restore_data.render.info,  w + 15, s, tocolor( 235, 235, 235 ) , 1 , "clear", false, true, 9, restore_data.render.fix )
		end	
	
end
	_initialLoaded( "extensions/restore_c.lua" )	

end