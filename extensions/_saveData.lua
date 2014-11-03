
function initialize_data_base( )
	if fileExists ( ":basicmode-core/g_stats.db" ) then
		return 0;
	end	
	local db = dbConnect( "sqlite", ":basicmode-core/g_stats.db", "", "", "share=0" )
	dbExec( db, "CREATE TABLE IF NOT EXISTS player (serial TEXT, Kills INTEGER, Deaths INTEGER, Damage INTEGER)")
destroyElement( db )

end

function clean_data_base( )
	if fileExists ( ":basicmode-core/g_stats.db" ) then
		fileDelete (  ":basicmode-core/g_stats.db" )
	end	
	initialize_data_base( )
end

function insert_player_data( player )
	if not fileExists ( ":basicmode-core/g_stats.db" ) then
		return 0;
	end	
	local serial, kills, deaths, damage = getPlayerSerial( player ), getElementData ( player,"Kills"), getElementData ( player,"Deaths"), getElementData ( player,"Damage")
	local db = dbConnect( "sqlite", ":basicmode-core/g_stats.db", "", "", "share=0" )
	local qh = dbQuery( db, "SELECT * FROM player WHERE serial=\""..tostring( serial).."\"" )
	local result = dbPoll( qh, -1 )
	if #result == 0 then
		dbExec(db, "INSERT INTO player(serial,Kills,Deaths,Damage) VALUES(?,?,?,?)", tostring( serial ), kills, deaths, damage )
	else
		dbExec(db, "UPDATE player SET Kills = "..kills..", Deaths = "..deaths..", Damage = "..damage.." WHERE serial=\""..tostring( serial).."\"" )
		 
	end
destroyElement( db )
end

function read_player_data( player )
	if not fileExists ( ":basicmode-core/g_stats.db" ) then
		return 0;
	end	
	local serial = getPlayerSerial( player )
	local db = dbConnect( "sqlite", ":basicmode-core/g_stats.db", "", "", "share=0" )
	local qh = dbQuery( db, "SELECT * FROM player WHERE serial=\""..tostring( serial).."\"" )
	local result = dbPoll( qh, -1 )
	if #result == 0 then
	destroyElement( db )
		return 0;
	end
		for k, v in pairs( result[1] ) do
			if k ~= serial then
				setElementData( player, k, v )
			end	
		end

	destroyElement( db )
end

initialize_data_base( )
clean_data_base( )

	

	
	
	
