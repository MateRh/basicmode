
_initialLoading[ "modes/base_client.lua" ] = function ( )
	

local scale_ = {}
	if screenHeight > 1024 then
		scale_ = { 1*2, 128*2, 126*2, 8*2, 256*2, 32*2, 16*2, 248*2, 3 }
	else
		scale_ = { 1, 128, 126, 8, 256, 32, 16, 248, 6 }
	end



local capture_bar = {left=0,width = dxGetTextWidth ( "199%", scale_[1], "clear" ),finish=0,bg_pos= { scaleIntPercent(screenWidth,50)-scale_[2], scaleIntPercent(screenHeight,scale_[9]) }, lay_pos= { scaleIntPercent(screenWidth,50)-scale_[3], scaleIntPercent(screenHeight,scale_[9])+scale_[4] }, }

function onCaptureBarRender( )
	local percent =   ( getTickCount()-capture_bar.start)*capture_bar.percent
	dxDrawImage ( capture_bar.bg_pos[1],  capture_bar.bg_pos[2], scale_[5], scale_[6], "img/capture_bar_bg.png")
	dxDrawImage ( capture_bar.lay_pos[1],  capture_bar.lay_pos[2], percent, scale_[7], "img/capture_bar.png")
	dxDrawImage ( capture_bar.lay_pos[1]+percent,  capture_bar.lay_pos[2], scale_[7], scale_[7], "img/capture_flag.png")
	dxDrawText (   string.format("%i", (( getTickCount()-capture_bar.start)/capture_bar.limit)*100 ).."%" , math.max(capture_bar.lay_pos[1],capture_bar.lay_pos[1]+ percent -capture_bar.width) ,  capture_bar.lay_pos[2], 0, 0,colors_g.white,scale_[1], "clear" )
		if percent > scale_[8]-1 then
			removeEventHandler ( "onClientRender", getRootElement(),onCaptureBarRender )
			capture_bar.finish = 0
			return
		end
end

function _captureReset( )
	capture_bar = {left=0,width = dxGetTextWidth ( "199%", scale_[1], "clear" ),finish=0,bg_pos= { scaleIntPercent(screenWidth,50)-scale_[2], scaleIntPercent(screenHeight,scale_[9]) }, lay_pos= { scaleIntPercent(screenWidth,50)-scale_[3], scaleIntPercent(screenHeight,scale_[9])+scale_[4] }, }
end

	
	
function stopCaptureAnim( limit )
	removeEventHandler ( "onClientRender", getRootElement(),onCaptureBarRender )
	 capture_bar.left= getTickCount()
end

function beginCaptureAnim( limit,type )
	if type == "intermittent" or capture_bar.finish == 0 then
		capture_bar.start = getTickCount()
		capture_bar.finish  =  ( getTickCount() ) + ( limit * 1000 ) 
		capture_bar.limit  =  ( limit * 1000 ) 
		capture_bar.percent =  scale_[8] / ( limit * 1000 ) 
	else
		local difference =  getTickCount() - capture_bar.left
		capture_bar.start = capture_bar.start +  difference
		capture_bar.finish  =  capture_bar.finish + difference
	end
	addEventHandler ( "onClientRender", getRootElement(),onCaptureBarRender )
end

	_initialLoaded( "modes/base_client.lua" )	

end