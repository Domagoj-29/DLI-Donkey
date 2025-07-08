MenuT=false
PosChangeT=false
zoom=1
w=0
h=0
function getHighlightColor(isSelected)
	if isSelected then
		return 255,127,0
	else
		return uiR,uiG,uiB
	end
end
function onTick()
	gN=input.getNumber
-- Properties
	uiR=property.getNumber("UI Color R")
	uiG=property.getNumber("UI Color G")
	uiB=property.getNumber("UI Color B")
	poR=property.getNumber("Pointer R")
	poG=property.getNumber("Pointer G")
	poB=property.getNumber("Pointer B")
	liR=property.getNumber("Line R")
	liG=property.getNumber("Line G")
	liB=property.getNumber("Line B")
	local propertyMultiplierX=property.getNumber("X Movement Multiplier")
	local propertyMultiplierY=property.getNumber("Y Movement Multiplier")
	local zoomMultiplier=property.getNumber("Zoom Multiplier")
	overlay=property.getBool("Compass Overlay")
	pointer=property.getBool("Pointer")
	squarepc=property.getBool("Square Pointer during PosChange")
-- Inputs
	x=gN(1)
	y=gN(3)
	speed=gN(9)
	compass=gN(17)
	compassD=(-compass*360+360)%360
	inputX=gN(18)
	inputY=gN(19)
	wpX=gN(20)
	wpY=gN(21)
	isPressed=input.getBool(1)
-- Waypoint Distance Calculation
	Dx=wpX-x
	Dy=wpY-y
	distance=math.sqrt(Dx*Dx+Dy*Dy)/1000
	distance=math.max(0,math.min(distance,256))
	estimate=(distance/(speed*3.6))*60
	estimate=math.max(0,math.min(estimate,999))
-- Buttons
	if not (wpX==0 and wpY==0) then
		Line=isPressed and isPointInRectangle(inputX,inputY,w-33,h-8,7,9)
	end
	Menu=isPressed and isPointInRectangle(inputX,inputY,w-27,h-8,7,9)
	PosChange=isPressed and isPointInRectangle(inputX,inputY,w-21,h-8,8,9)
	Plus=isPressed and isPointInRectangle(inputX,inputY,w-14,h-8,8,9)
	Minus=isPressed and isPointInRectangle(inputX,inputY,w-7,h-8,8,9)
-- Movement buttons
	Left=isPressed and isPointInRectangle(inputX,inputY,-1,-1,w/2-1,h-6)
	Right=isPressed and isPointInRectangle(inputX,inputY,w/2+1,-1,w+1,h-6)
	Up=isPressed and isPointInRectangle(inputX,inputY,-1,-1,w+1,h/2-1)
	Down=isPressed and isPointInRectangle(inputX,inputY,-1,h/2+1,w+1,h/2-8)
-- Toggle Line
	if Line and not L then
		LineT=not LineT
	end
	L=Line
-- Toggle Menu
	if Menu and not M then
		MenuT=not MenuT
	end
	M=Menu
-- Toggle Position Change
	if PosChange and not PC then
		PosChangeT=not PosChangeT
	end
	PC=PosChange
-- Initialize memory if nil
	if MemoryX==nil or not PosChangeT then MemoryX=x end
	if MemoryY==nil or not PosChangeT then MemoryY=y end
-- Movement multipliers
	Xmultiplier=math.abs((w/2-inputX)*propertyMultiplierX)
	Ymultiplier=math.abs((h/2-inputY)*propertyMultiplierY)
-- Movement left/right, up/down
	local dx,dy=0,0
	if Right then dx=0.5*Xmultiplier end
	if Left then dx=-0.5*Xmultiplier end
	if Up then dy=0.5*Ymultiplier end
	if Down then dy=-0.5*Ymultiplier end
-- Position Change stuff
	if PosChangeT then
		MemoryX=MemoryX+dx
		MemoryY=MemoryY+dy
	end
-- Zoom controls
	if Minus then zoom=zoom+0.03*zoomMultiplier end
	if Plus then zoom=zoom-0.03*zoomMultiplier end
	zoom=math.max(0.1,math.min(zoom,50))
-- Button colors
	lR,lG,lB=getHighlightColor(LineT)
	mR,mG,mB=getHighlightColor(MenuT)
	cR,cG,cB=getHighlightColor(PosChangeT)
	pR,pG,pB=getHighlightColor(Plus)
	nR,nG,nB=getHighlightColor(Minus)
end
function onDraw()
	sC=screen.setColor
	dT=screen.drawText
	dRF=screen.drawRectF
	dL=screen.drawLine
	w=screen.getWidth()
	h=screen.getHeight()
	if MenuT then
-- Compass variable X
		local cx=16
		if compassD<9.5 then
			cx=6
		elseif compassD<99.5 then
			cx=11
		end
-- Background Color
		sC(15,15,15)
		screen.drawClear()
-- Shading
		sC(0,0,0)
		dT(1,2,string.format("%.0f",x))
		dT(1,9,string.format("%.0f",y))
		dT(1,16,string.format("%.0f",compassD))
		if h>32 and not (wpX==0 and wpY==0) then
			dT(1,23,string.format("%.1f",distance).."km")
			if speed>2.7 then
				dT(1,30,string.format("%.0f",estimate).."m")
			end
		end
		screen.drawCircle(cx+1,16,1)
-- X and Y coordinates
		sC(uiR,uiG,uiB)
		dT(0,2,string.format("%.0f",x))
		dT(0,9,string.format("%.0f",y))
-- Compass Heading
		dT(0,16,string.format("%.0f",compassD))
-- Distance and time estimate
		if h>32 and not (wpX==0 and wpY==0) then
			dT(0,23,string.format("%.1f",distance).."km")
			if speed>2.7 then
				dT(0,30,string.format("%.0f",estimate).."m")
			end
		end
-- Circle as a symbol for degrees of the compass
		screen.drawCircle(cx,16,1)
	else
-- Map Colors
		screen.setMapColorOcean(0,0,0,2)
		screen.setMapColorShallows(0,0,0,40)
		screen.setMapColorLand(0,0,0,100)
		screen.setMapColorGrass(0,0,0,100)
		screen.setMapColorSand(0,0,0,100)
		screen.setMapColorSnow(0,0,0,200)
		screen.setMapColorRock(0,0,0,60)
		screen.setMapColorGravel(0,0,0,120)
		screen.drawMap(MemoryX,MemoryY,zoom)
-- Draw line to waypoint
		if LineT then
			sC(liR,liG,liB)
			dL(Px,Py,wppX,wppY)
		end
-- Waypoint
		wppX,wppY=map.mapToScreen(MemoryX,MemoryY,zoom,w,h,wpX,wpY)
		if not (wpX==0 and wpY==0) then
			sC(255,127,0)
			dRF(wppX,wppY,2,2)
		end
-- Current position on map to screen
		Px,Py=map.mapToScreen(MemoryX,MemoryY,zoom,w,h,x,y)
		sC(poR,poG,poB)
-- Triangular Pointer
		if pointer then
			if PosChangeT then
				drawPointer(Px,Py,compass)
			else
				drawPointer(w/2,h/2,compass)
			end
-- Rectangular Pointer
		else
			if PosChangeT then
				dRF(Px,Py,2,2)
			else
				dRF(w/2-1,h/2-1,2,2)
			end
		end
-- Toggleable center screen pointer during PosChange
		if PosChangeT and squarepc then
			dRF(w/2-1,h/2-1,2,2)
		end
-- Shaded Buttons
		sC(0,0,0)
		if not (wpX==0 and wpY==0) then
			dT(w-30,h-6,"L")
		end
		dRF(w-18,h-4,1,1)
		dRF(w-16,h-6,1,1)
		dRF(w-14,h-4,1,1)
		dRF(w-16,h-2,1,1)
		dL(w-11,h-4,w-6,h-4)
		dL(w-9,h-6,w-9,h-1)
		dL(w-4,h-4,w,h-4)
-- Draw line button
		if not (wpX==0 and wpY==0) then
			sC(lR,lG,lB)
			dT(w-31,h-6,"L")
		end
-- Position Change
		sC(cR,cG,cB)
		dRF(w-19,h-4,1,1)
		dRF(w-17,h-6,1,1)
		dRF(w-15,h-4,1,1)
		dRF(w-17,h-2,1,1)
-- Plus
		sC(pR,pG,pB)
		dL(w-12,h-4,w-7,h-4)
		dL(w-10,h-6,w-10,h-1)
-- Minus
		sC(nR,nG,nB)
		dL(w-5,h-4,w-1,h-4)
-- Compass Heading Overlay Shading
		if overlay then
			sC(0,0,0)
			if 340<=compassD and compassD<360 or 0<=compassD and compassD<20 then
			dT(w/2-1,2,"N")
			elseif 20<=compassD and compassD<70 then
				dT(w/2-4,2,"N")
				dT(w/2+2,2,"E")
			elseif 70<=compassD and compassD<110 then
				dT(w/2-1,2,"E")
			elseif 110<=compassD and compassD<160 then
				dT(w/2-4,2,"S")
				dT(w/2+2,2,"E")
			elseif 160<=compassD and compassD<200 then
				dT(w/2-1,2,"S")
			elseif 200<=compassD and compassD<250 then
				dT(w/2-4,2,"S")
				dT(w/2+2,2,"W")
			elseif 250<=compassD and compassD<290 then
				dT(w/2-1,2,"W")
			else
				dT(w/2-4,2,"N")
				dT(w/2+2,2,"W")
			end
-- Compass Heading Overlay
			sC(uiR,uiG,uiB)
			if 340<=compassD and compassD<360 or 0<=compassD and compassD<20 then
				dT(w/2-2,2,"N")
			elseif 20<=compassD and compassD<70 then
				dT(w/2-5,2,"N")
				dT(w/2+1,2,"E")
			elseif 70<=compassD and compassD<110 then
				dT(w/2-2,2,"E")
			elseif 110<=compassD and compassD<160 then
				dT(w/2-5,2,"S")
				dT(w/2+1,2,"E")
			elseif 160<=compassD and compassD<200 then
				dT(w/2-2,2,"S")
			elseif 200<=compassD and compassD<250 then
				dT(w/2-5,2,"S")
				dT(w/2+1,2,"W")
			elseif 250<=compassD and compassD<290 then
				dT(w/2-2,2,"W")
			else
				dT(w/2-5,2,"N")
				dT(w/2+1,2,"W")
			end
		end
	end
	-- Menu
	sC(0,0,0)
	dT(w-24,h-6,"M")
	sC(mR,mG,mB)
	dT(w-25,h-6,"M")
end
-- For the Touch Screen
function isPointInRectangle(x,y,rectX,rectY,rectW,rectH)
	return x>rectX and y>rectY and x<rectX+rectW and y<rectY+rectH
end
-- Triangular Pointer
triangle = {
	{0, -5},
	{-3, 3},
	{3, 3}
}
function rotatePoint(x,y,angle)
	local cosA=math.cos(angle)
	local sinA=math.sin(angle)
	return x*cosA-y*sinA,x*sinA+y*cosA
end
function drawPointer(x,y,heading)
	local angle=-heading*math.pi*2
	local p1x,p1y=rotatePoint(triangle[1][1],triangle[1][2],angle)
	local p2x,p2y=rotatePoint(triangle[2][1],triangle[2][2],angle)
	local p3x,p3y=rotatePoint(triangle[3][1],triangle[3][2],angle)
	sC(uiR,uiG,uiB)
	screen.drawTriangleF(x+p1x,y+p1y,x+p2x,y+p2y,x+p3x,y+p3y)
end