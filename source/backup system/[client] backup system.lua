
_initialLoading[ "source/backup system/[client] backup system.lua" ] = function ( )

engineImportTXD ( engineLoadTXD ( "core/grenade.txd" ), 342 )

engineReplaceModel ( engineLoadDFF ( "core/grenade.dff", 0 ), 342 )



local filesToBackup = {
	[ "gta_tree_bevhills.txd" ] = { 737, 717 },
	[ "aw_streettree3.dff" ] = 737,
	[ "gta_proc_bush.txd" ] = { 9153, 800, 803, 805, 647, 762 },
	[ "bush14_lvs.dff" ] = 9153,
	[ "tree2.txd" ] = { 773, 781 },
	[ "Elmdead_hi.dff" ] = 773,
	[ "tree1.txd" ] = { 772, 782, 767, 780, 774, 778 },
	[ "Elmred_hi.dff" ] = 772,
--	[ "tree1.txd" ] = 778,
	[ "Elmred_hism.dff" ] = 778,
--	[ "tree1.txd" ] = 774,
	[ "Elmsparse_hi.dff" ] = 774,
--	[ "tree1.txd" ] = 780,
	[ "Elmsparse_hism.dff" ] = 780,
--	[ "tree1.txd" ] = 767,
	[ "Elmtreegrn_hi.dff" ] = 767,
--	[ "tree1.txd" ] = 782,
	[ "Elmtreegrn_hism.dff" ] = 782,
--	[ "tree2.txd" ] = 781,
	[ "Elmwee_hism.dff" ] = 781,
	--[ "gta_proc_bush.txd" ] = 800,
	[ "genVEG_bush07.dff" ] = 800,
--	[ "gta_proc_bush.txd" ] = 803,
	[ "genVEG_bush09.dff" ] = 803,
	--[ "gta_proc_bush.txd" ] = 805,
	[ "genVEG_bush11.dff" ] = 805,
	[ "hotelbackpool_sfs.txd" ] = 10445,
	[ "hotelback2.dff" ] = 10445,
	[ "veg_leavesplnt.txd" ] = { 638, 640 }, 
	[ "kb_planter+bush.dff" ] = 638,
	--[ "veg_leavesplnt.txd" ] = 640,
	[ "kb_planter+bush2.dff" ] = 640,
	--[ "gta_proc_bush.txd" ] = 647,
	[ "new_bushsm.dff" ] = 647,
	--[ "gta_proc_bush.txd" ] = 762,
	[ "new_bushtest.dff" ] = 762,
	[ "wiresetc_las2.txd" ] = 5150,
	[ "SCUMWIRES1_las2.dff" ] = 5150,
	[ "gta_tree_boak.txd" ] = { 673, 669, 708, 672, 700, 703, 705, 709 },
	[ "sm_bevhiltree.dff" ] = 673,
--	[ "gta_tree_bevhills.txd" ] = 717,
	[ "sm_bevhiltreepv.dff" ] = 717,
	[ "gta_deserttrees.txd" ] = { 678, 692, 679, 682 },
	[ "sm_des_agave2.dff" ] = 678,
--	[ "gta_deserttrees.txd" ] = 692,
	[ "sm_des_bush1.dff" ] = 692,
--	[ "gta_deserttrees.txd" ] = 679,
	[ "sm_des_cact_bsh.dff" ] = 679,
	--[ "gta_deserttrees.txd" ] = 682,
	[ "sm_des_cactflr.dff" ] = 682,
	--[ "gta_tree_boak.txd" ] = 669,
	[ "sm_veg_tree4.dff" ] = 669,
	--[ "gta_tree_boak.txd" ] = 708,
	[ "sm_veg_tree4_vbig.dff" ] = 708,
	--[ "gta_tree_boak.txd" ] = 672,
	[ "sm_veg_tree5.dff" ] = 672,
	--[ "gta_tree_boak.txd" ] = 700,
	[ "sm_veg_tree6.dff" ] = 700,
	--[ "gta_tree_boak.txd" ] = 703,
	[ "sm_veg_tree7_big.dff" ] = 703,
	--[ "gta_tree_boak.txd" ] = 705,
	[ "sm_veg_tree7vbig.dff" ] = 705,
	--[ "gta_tree_boak.txd" ] = 709,
	[ "sm_vegvbbigbrn.dff" ] = 709,
	[ "stormd_filllas2.txd" ] = 5322,
	[ "stormd_fill1_LAS2.dff" ] = 5322,
	[ "gtatreeshi.txd" ] = 728,
	[ "tree_hipoly06.dff" ] = 728,
	[ "gta_tree_palm.txd" ] = { 620, 641, 712 },
	[ "veg_palm04.dff" ] = 620,
	[ "gta_potplantsaa.txd" ] = 625,
	[ "veg_palmkb1.dff" ] = 625,
	[ "gta_potplants2.txd" ] = 626,
	[ "veg_palmkb2.dff" ] = 626,
--	[ "gta_tree_palm.txd" ] = 641,
	[ "veg_palmkb13.dff" ] = 641,
--	[ "gta_tree_palm.txd" ] = 712,
	[ "vgs_palm03.dff" ] = 712
}


function checkFilesToApplyBackup ( list )

	for k, v in pairs ( filesToBackup ) do
		for _, f in pairs ( list ) do
		--	outputConsole( tostring( k )..' =? '..tostring( f ) )
			if k == f then
				downloadFile( 'media/files/'..k )
			end	
		end	
	end

end

function backuCopyDownload( file, status )
	if string.find( file, 'media/files/') then

		file = string.gsub( file, 'media/files/', '' )
	else
		return
	end		

	for k, v in pairs ( filesToBackup ) do
		if file == k then
				if status then
					applyBackup( 'media/files/'..file, v )
				else
					downloadFile( 'media/files/'..file )
				end
			return 
		end
	end		
end	

addEventHandler ( "onClientFileDownloadComplete", getRootElement(),  backuCopyDownload )



function applyBackup( name, id )
--	outputChatBox( tostring( name ))
	if string.find( name, '.txd' ) then
		if type( id ) == 'table' then
			local material =  engineLoadTXD( name )
			for k, v in pairs ( id ) do
				engineImportTXD( material, v )
			end	
			return
		else
			return engineImportTXD( engineLoadTXD( name ), id )
		end
	elseif 	string.find( name, '.dff' ) then
		engineReplaceModel( engineLoadDFF( name, 0 ), id )
		return engineSetModelLODDistance( id, 2000 )
	end	
end

callServer( 'resendPlayerModInfo', localPlayer )

	_initialLoaded( "source/backup system/[client] backup system.lua" )	

end