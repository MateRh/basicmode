
_initialLoading[ "team_selection.lua" ] = function ( )


fadeCamera ( true ,0)
math.randomseed(  getRealTime( ).timestamp)
screenWidth, screenHeight  = guiGetScreenSize ( ) -- Get the screen resolution (width and height)
	local lobby_cam = { x = 2619+math.random(-35,35), y = 2756+math.random(-35,35), z = 50+math.random( 0, 50 ) }

TableTeams = {}
game_settings = {skins={312,303,310}}
colors_g = { 
			yellow = tocolor( 255, 255, 0 ),
			gold=tocolor(238,180,34,255),
			gray=tocolor(200,200,200,255),
			dgreen=tocolor(34,139,34,255),
			green=tocolor(0,215,0),
			black=tocolor(0,0,0,255),
			black2=tocolor(20,20,20,255),
			black3=tocolor(35,35,35,255),
			lblue=tocolor(77,152,205,255),
			lgray=tocolor(162,170,175,255),
			red=tocolor(225,25,25,255),
			white=tocolor(225,225,225,255),
			white=tocolor(255,255,255,255)
		}

function _get_camera()
	local saddsa = {getCameraMatrix ( )}
		for k,v in ipairs(saddsa) do
		end	
	
	
end
addCommandHandler("getcamera",_get_camera)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function callClient(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do arg[key] = tonumber(value) or value end
    end
    loadstring("return "..funcname)()(unpack(arg))
end
addEvent("on_client_call", true)
addEventHandler("on_client_call", root, callClient)

function callServer(funcname, ...)
    local arg = { ... }
    if (arg[1]) then
        for key, value in next, arg do
            if (type(value) == "number") then arg[key] = tostring(value) end
        end
    end
    triggerServerEvent("on_server_call", root, funcname, unpack(arg))
end

function scaleInt( h ,s ,i )
local mn = s/h
return tonumber(string.format("%."..( i or 1 ).."f", screenHeight*mn))
end

function scaleByWidth ( w, s, i )
	return tonumber( string.format( "%."..( i or 1 ).."f", screenWidth*( s / w ) ) )
end

function scaleIntPercent(h,s)
local mn = h * ( s / 100 )
return tonumber(string.format("%.0f", mn))
end

function math.format(number)
return tonumber(string.format("%.4f", number))
end

function getScreenPositionByRelativeViaElement(x,y,element)
	local xE,yE = guiGetSize(element,false)
		local xsE,ysE = guiGetPosition(element,false)
		local nX,nY =x*xE,y*yE
	return math.format(nX+xsE),math.format(nY+ysE)
end

function getCamPos_cords_rot_dis( x,y,z,obrot ,dystans )	
    obrot = obrot/180*3.14159265358979
    x = x - ( math.sin(obrot) * dystans )
    y = y + ( math.cos(obrot) * dystans )
	return x, y, z
end


g_open_s ={team=false}
local t_select_d = {size1 = 1.4,size2 = math.max(0.8,scaleInt(900,1.3)),team=1}

	
	
	
	

colors_ = {black=tocolor(0,0,0,255),white=tocolor(255,255,255,255)}

function drawBorderText(text, x, y, color, scale, font, outlinesize, postGUI)
		for offsetX=-outlinesize,outlinesize,outlinesize do
			for offsetY=-outlinesize,outlinesize,outlinesize do
				if not (offsetX == 0 and offsetY == 0) then
					dxDrawText(text, x + offsetX, y + offsetY, x + offsetX, y + offsetY,colors_.black, scale, font,"left", "top", false, false, postGUI)
				end
			end
		end
	dxDrawText(text, x, y, x, y, color, scale, font,"left", "top", false, false, postGUI)
end

--selector_main()




--[[ p_status
1st Value:
0 - not active in round
1 - active in round

2nd Value:
0 - none
1 - team selector
2 - in lobby
3 - weapon selector
4 - spawn selector
5 - vehicle selector
6 - playing
7 - coundtodnw pre-round
]]
--[[ p_status NOWE
a: 
1 - none
b:
2 - team select
3 - veh select
4 - weapon select
5 - map loading
c:
6 - playing
d: 
7 - lobby
8 - dead
]]


function spawn_anim_ped()
	setElementAlpha(t_select.ped, getElementAlpha(t_select.ped)+25)
	if getElementAlpha(t_select.ped) >= 225 then
	setElementAlpha(t_select.ped, 255)
		removeEventHandler("onClientRender",getRootElement(),spawn_anim_ped)
	end
end




	_initialLoaded( "team_selection.lua" )	

end