function isPointInRectangle(x, y, rectX, rectY, rectW, rectH)
	return x > rectX and y > rectY and x < rectX+rectW and y < rectY+rectH
end
function getHighlightColor(isSelected)
	if isSelected then
		return 255,127,0
	else
		return uiR,uiG,uiB
	end
end
function getSignalColor(signalStrength)
    if signalStrength>0 and signalStrength<0.25 then
        return 255,0,0
    elseif signalStrength>=0.25 and signalStrength<0.5 then
        return 250,70,22
    elseif signalStrength>=0.5 and signalStrength<0.75 then
        return 255,255,0
    else
        return 0,255,0
    end
end
function boolToString(boolVal)
	if boolVal==true then
		return "ON"
	else
		return "OFF"
	end
end
screenMode=0 -- 0 - menu, 1 - frequency selector, 2 - bool data, 3 - numerical data, 4 - video data
First=0
Second=0
Third=0
Fourth=0
firstTimer=firstTimer or 0
secondTimer=secondTimer or 0
thirdTimer=thirdTimer or 0
fourthTimer=fourthTimer or 0
k=0
k2=0
sY=0
sY2=0
delayTicks=10
function onTick()
	local inputX=input.getNumber(3)
	local inputY=input.getNumber(4)
	signalStrength=input.getNumber(7)
	rxNum1=input.getNumber(8)
	rxNum2=input.getNumber(9)
	rxNum3=input.getNumber(10)
	rxNum4=input.getNumber(11)
	rxNum5=input.getNumber(12)
	rxNum6=input.getNumber(13)
	rxNum7=input.getNumber(14)
	rxNum8=input.getNumber(15)
	-- Clamp numerical values
	rxNum1=math.max(-9999,math.min(rxNum1,99999))
	rxNum2=math.max(-9999,math.min(rxNum2,99999))
	rxNum3=math.max(-9999,math.min(rxNum3,99999))
	rxNum4=math.max(-9999,math.min(rxNum4,99999))
	rxNum5=math.max(-9999,math.min(rxNum5,99999))
	rxNum6=math.max(-9999,math.min(rxNum6,99999))
	rxNum7=math.max(-9999,math.min(rxNum7,99999))
	rxNum8=math.max(-9999,math.min(rxNum8,99999))
	uiR=property.getNumber("UI Color R")
	uiG=property.getNumber("UI Color G")
	uiB=property.getNumber("UI Color B")
	local isPressed=input.getBool(1)
	local ExternalPTT=input.getBool(3)
	local rxBool1=input.getBool(4)
	local rxBool2=input.getBool(5)
	local rxBool3=input.getBool(6)
	local rxBool4=input.getBool(7)
	local rxBool5=input.getBool(8)
	local rxBool6=input.getBool(9)
	local rxBool7=input.getBool(10)
	local rxBool8=input.getBool(11)
	-- Convert bool inputs into strings
	rxString1=boolToString(rxBool1)
	rxString2=boolToString(rxBool2)
	rxString3=boolToString(rxBool3)
	rxString4=boolToString(rxBool4)
	rxString5=boolToString(rxBool5)
	rxString6=boolToString(rxBool6)
	rxString7=boolToString(rxBool7)
	rxString8=boolToString(rxBool8)

	a,b,c=getSignalColor(signalStrength)
	ReturnButton=isPressed and isPointInRectangle(inputX,inputY,-1,-1,6,6)
	if ReturnButton then
		screenMode=0
	end
	-- This should be in screenMode 1, but then you cant set a default frequency, breaking the wheel slip detection on the DLI Donkey :/
	FrequencySet=First+(Second*10)+(Third*100)+(Fourth*1000)

	if screenMode==0 then
		local FrqButton=isPressed and isPointInRectangle(inputX,inputY,8,0,15,6)
		PTTButton=isPressed and isPointInRectangle(inputX,inputY,8,6,15,6)
		local DataButton=isPressed and isPointInRectangle(inputX,inputY,5,12,20,6)
		local MuteButton=isPressed and isPointInRectangle(inputX,inputY,5,18,20,6)
		if FrqButton then
			screenMode=1
		end
		-- Push to toggle for the mute button
		if MuteButton and not M then
			MuteButtonT=not MuteButtonT
		end
		M=MuteButton
		if DataButton then
			screenMode=2
		end
		-- Restets whatever scroll position was previously
		if not DataButton then k2=0 else k2=k2+1 end
		if k2==1 then DataPulse=true else DataPulse=false end
		if DataPulse then
			sY=0
			sY2=0
		end
		g,h,i=getHighlightColor(PTTButton or ExternalPTT)
		j,k,l=getHighlightColor(MuteButtonT)
	elseif screenMode==1 then
		local FirstUp=isPressed and isPointInRectangle(inputX,inputY,21,7,6,5)
		local FirstDown=isPressed and isPointInRectangle(inputX,inputY,21,17,6,5)
		local SecondUp=isPressed and isPointInRectangle(inputX,inputY,16,7,6,5)
		local SecondDown=isPressed and isPointInRectangle(inputX,inputY,16,17,6,5)
		local ThirdUp=isPressed and isPointInRectangle(inputX,inputY,10,7,6,5)
		local ThirdDown=isPressed and isPointInRectangle(inputX,inputY,10,17,6,5)
		local FourthUp=isPressed and isPointInRectangle(inputX,inputY,5,7,6,5)
		local FourthDown=isPressed and isPointInRectangle(inputX,inputY,5,17,6,5)
		-- First
		if FirstUp or FirstDown then
			firstTimer=firstTimer+1
			if firstTimer>=delayTicks then
				if FirstUp then
					First=First+1
				elseif FirstDown then
					First=First-1
				end
				firstTimer=0
			end
		else
			firstTimer=delayTicks
		end
		First=math.max(-1,math.min(First,10))
		if First==-1 then First=9 end
		if First==10 then First=1 end
		-- Second
		if SecondUp or SecondDown then
			secondTimer=secondTimer+1
			if secondTimer>=delayTicks then
				if SecondUp then
					Second=Second+1
				elseif SecondDown then
					Second=Second-1
				end
				secondTimer=0
			end
		else
			secondTimer=delayTicks
		end
		Second=math.max(-1,math.min(Second,10))
		if Second==-1 then Second=9 end
		if Second==10 then Second=1 end
		-- Third
		if ThirdUp or ThirdDown then
			thirdTimer=thirdTimer+1
			if thirdTimer>=delayTicks then
				if ThirdUp then
					Third=Third+1
				elseif ThirdDown then
					Third=Third-1
				end
				thirdTimer=0
			end
		else
			thirdTimer=delayTicks
		end
		Third=math.max(-1,math.min(Third,10))
		if Third==-1 then Third=9 end
		if Third==10 then Third=1 end
		-- Fourth
		if FourthUp or FourthDown then
			fourthTimer=fourthTimer+1
			if fourthTimer>=delayTicks then
				if FourthUp then
					Fourth=Fourth+1
				elseif FourthDown then
					Fourth=Fourth-1
				end
				fourthTimer=0
			end
		else
			fourthTimer=delayTicks
		end
		Fourth=math.max(-1,math.min(Fourth,10))
		if Fourth==-1 then Fourth=9 end
		if Fourth==10 then Fourth=1 end
	elseif screenMode==2 then
		local scrollUp=isPressed and isPointInRectangle(inputX,inputY,-1,4,32,14)
		local scrollDown=isPressed and isPointInRectangle(inputX,inputY,-1,17,32,14)
		if scrollUp then
			sY=sY+1
		elseif scrollDown then
			sY=sY-1
		end
		sY=math.max(-23,math.min(sY,0))
	elseif screenMode==3 then
		local scrollUp2=isPressed and isPointInRectangle(inputX,inputY,-1,4,32,14)
		local scrollDown2=isPressed and isPointInRectangle(inputX,inputY,-1,17,32,14)
		if scrollUp2 then
			sY2=sY2+1
		elseif scrollDown2 then
			sY2=sY2-1
		end
		sY2=math.max(-23,math.min(sY2,0))
	end
	if screenMode>1 then -- Screen mode cycler, cycles between bool, numerical and (TODO: video) data
		local cycleModes=isPressed and isPointInRectangle(inputX,inputY,7,-1,15,6)
		if not cycleModes then k=0 else k=k+1 end
		if k==1 then cycleModes=true else cycleModes=false end
		if cycleModes then
			screenMode=screenMode+1
		end
		screenMode=math.max(2,math.min(screenMode,5))
		if screenMode==5 then screenMode=2 end
	end
	-- Video switchbox for video passthrough
	if screenMode==4 then
		videoSwitchbox=true
	else
		videoSwitchbox=false
	end
	output.setNumber(1,FrequencySet)
	local PTT=PTTButton or ExternalPTT
	output.setBool(1,PTT)
	output.setBool(2,MuteButtonT)
	output.setBool(3,videoSwitchbox)
end
function onDraw()
	if screenMode~=4 then
	screen.setColor(15,15,15)
	screen.drawClear()
	end
	-- Shading
	screen.setColor(0,0,0)
	if screenMode==0 then
		screen.drawText(10,1,"FRQ")
		screen.drawText(10,7,"PTT")
		screen.drawText(7,13,"DATA")
		screen.drawText(7,19,"MUTE")
		screen.drawText(23,27,"V3")
	elseif screenMode==1 then
		-- First
		screen.drawText(23,13,string.format("%.0f",First))
		-- Second
		screen.drawText(18,13,string.format("%.0f",Second))
		-- Third
		screen.drawText(12,13,string.format("%.0f",Third))
		-- Fourth
		screen.drawText(7,13,string.format("%.0f",Fourth))
		-- First Up Arrow
		screen.drawLine(23,11,27,11)
		screen.drawLine(24,10,26,10)
		-- First Down Arrow
		screen.drawLine(23,19,27,19)
		screen.drawLine(24,20,26,20)
		-- Second Up Arrow
		screen.drawLine(18,11,22,11)
		screen.drawLine(19,10,21,10)
		-- Second Down Arrow
		screen.drawLine(18,19,22,19)
		screen.drawLine(19,20,21,20)
		-- Third Up Arrow
		screen.drawLine(12,11,16,11)
		screen.drawLine(13,10,15,10)
		-- Third Down Arrow
		screen.drawLine(12,19,16,19)
		screen.drawLine(13,20,15,20)
		-- Fourth Up Arrow
		screen.drawLine(7,11,11,11)
		screen.drawLine(8,10,10,10)
		-- Fourth Down Arrow
		screen.drawLine(7,19,11,19)
		screen.drawLine(8,20,10,20)
	elseif screenMode==2 then
		screen.drawText(1,6+sY,"1")
		screen.drawRectF(6,7+sY,1,1)
		screen.drawRectF(6,9+sY,1,1)
		screen.drawText(8,6+sY,rxString1)
		screen.drawText(1,12+sY,"2")
		screen.drawRectF(6,13+sY,1,1)
		screen.drawRectF(6,15+sY,1,1)
		screen.drawText(8,12+sY,rxString2)
		screen.drawText(1,18+sY,"3")
		screen.drawRectF(6,19+sY,1,1)
		screen.drawRectF(6,21+sY,1,1)
		screen.drawText(8,18+sY,rxString3)
		screen.drawText(1,24+sY,"4")
		screen.drawRectF(6,25+sY,1,1)
		screen.drawRectF(6,27+sY,1,1)
		screen.drawText(8,24+sY,rxString4)
		screen.drawText(1,30+sY,"5")
		screen.drawRectF(6,31+sY,1,1)
		screen.drawRectF(6,33+sY,1,1)
		screen.drawText(8,30+sY,rxString5)
		screen.drawText(1,36+sY,"6")
		screen.drawRectF(6,37+sY,1,1)
		screen.drawRectF(6,39+sY,1,1)
		screen.drawText(8,36+sY,rxString6)
		screen.drawText(1,42+sY,"7")
		screen.drawRectF(6,43+sY,1,1)
		screen.drawRectF(6,45+sY,1,1)
		screen.drawText(8,42+sY,rxString7)
		screen.drawText(1,48+sY,"8")
		screen.drawRectF(6,49+sY,1,1)
		screen.drawRectF(6,51+sY,1,1)
		screen.drawText(8,48+sY,rxString8)
	elseif screenMode==3 then
		screen.drawText(1,6+sY2,"1")
		screen.drawRectF(6,7+sY2,1,1)
		screen.drawRectF(6,9+sY2,1,1)
		screen.drawText(8,6+sY2,string.format("%.0f",rxNum1))
		screen.drawText(1,12+sY2,"2")
		screen.drawRectF(6,13+sY2,1,1)
		screen.drawRectF(6,15+sY2,1,1)
		screen.drawText(8,12+sY2,string.format("%.0f",rxNum2))
		screen.drawText(1,18+sY2,"3")
		screen.drawRectF(6,19+sY2,1,1)
		screen.drawRectF(6,21+sY2,1,1)
		screen.drawText(8,18+sY2,string.format("%.0f",rxNum3))
		screen.drawText(1,24+sY2,"4")
		screen.drawRectF(6,25+sY2,1,1)
		screen.drawRectF(6,27+sY2,1,1)
		screen.drawText(8,24+sY2,string.format("%.0f",rxNum4))
		screen.drawText(1,30+sY2,"5")
		screen.drawRectF(6,31+sY2,1,1)
		screen.drawRectF(6,33+sY2,1,1)
		screen.drawText(8,30+sY2,string.format("%.0f",rxNum5))
		screen.drawText(1,36+sY2,"6")
		screen.drawRectF(6,37+sY2,1,1)
		screen.drawRectF(6,39+sY2,1,1)
		screen.drawText(8,36+sY2,string.format("%.0f",rxNum6))
		screen.drawText(1,42+sY2,"7")
		screen.drawRectF(6,43+sY2,1,1)
		screen.drawRectF(6,45+sY2,1,1)
		screen.drawText(8,42+sY2,string.format("%.0f",rxNum7))
		screen.drawText(1,48+sY2,"8")
		screen.drawRectF(6,49+sY2,1,1)
		screen.drawRectF(6,51+sY2,1,1)
		screen.drawText(8,48+sY2,string.format("%.0f",rxNum8))
	end
	if screenMode==0 then
		-- Frequency Button
		screen.setColor(uiR,uiG,uiB)
		screen.drawText(9,1,"FRQ")
		-- Push to talk
		screen.setColor(g,h,i)
		screen.drawText(9,7,"PTT")
		-- Data
		screen.setColor(255,255,255)
		screen.drawText(6,13,"DATA")
		-- Mute
		screen.setColor(j,k,l)
		screen.drawText(6,19,"MUTE")
		-- V3
		screen.setColor(uiR,uiG,uiB)
        screen.drawText(22,27,"V3")
	elseif screenMode==1 then
		screen.setColor(uiR,uiG,uiB)
		-- First
		screen.drawText(22,13,string.format("%.0f",First))
		-- Second
		screen.drawText(17,13,string.format("%.0f",Second))
		-- Third
		screen.drawText(11,13,string.format("%.0f",Third))
		-- Fourth
		screen.drawText(6,13,string.format("%.0f",Fourth))
		-- First Up Arrow
		screen.drawLine(22,11,26,11)
		screen.drawLine(23,10,25,10)
		-- First Down Arrow
		screen.drawLine(22,19,26,19)
		screen.drawLine(23,20,25,20)
		-- Second Up Arrow
		screen.drawLine(17,11,21,11)
		screen.drawLine(18,10,20,10)
		-- Second Down Arrow
		screen.drawLine(17,19,21,19)
		screen.drawLine(18,20,20,20)
		-- Third Up Arrow
		screen.drawLine(11,11,15,11)
		screen.drawLine(12,10,14,10)
		-- Third Down Arrow
		screen.drawLine(11,19,15,19)
		screen.drawLine(12,20,14,20)
		-- Fourth Up Arrow
		screen.drawLine(6,11,10,11)
		screen.drawLine(7,10,9,10)
		-- Fourth Down Arrow
		screen.drawLine(6,19,10,19)
		screen.drawLine(7,20,9,20)
	elseif screenMode==2 then
		-- Data
		screen.setColor(255,255,255)
		--1:
		screen.drawText(0,6+sY,"1")
		screen.drawRectF(5,7+sY,1,1)
		screen.drawRectF(5,9+sY,1,1)
		screen.drawText(7,6+sY,rxString1)
		--2:
		screen.drawText(0,12+sY,"2")
		screen.drawRectF(5,13+sY,1,1)
		screen.drawRectF(5,15+sY,1,1)
		screen.drawText(7,12+sY,rxString2)
		--3:
		screen.drawText(0,18+sY,"3")
		screen.drawRectF(5,19+sY,1,1)
		screen.drawRectF(5,21+sY,1,1)
		screen.drawText(7,18+sY,rxString3)
		--4:
		screen.drawText(0,24+sY,"4")
		screen.drawRectF(5,25+sY,1,1)
		screen.drawRectF(5,27+sY,1,1)
		screen.drawText(7,24+sY,rxString4)
		--5:
		screen.drawText(0,30+sY,"5")
		screen.drawRectF(5,31+sY,1,1)
		screen.drawRectF(5,33+sY,1,1)
		screen.drawText(7,30+sY,rxString5)
		--6:
		screen.drawText(0,36+sY,"6")
		screen.drawRectF(5,37+sY,1,1)
		screen.drawRectF(5,39+sY,1,1)
		screen.drawText(7,36+sY,rxString6)
		--7:
		screen.drawText(0,42+sY,"7")
		screen.drawRectF(5,43+sY,1,1)
		screen.drawRectF(5,45+sY,1,1)
		screen.drawText(7,42+sY,rxString7)
		--8:
		screen.drawText(0,48+sY,"8")
		screen.drawRectF(5,49+sY,1,1)
		screen.drawRectF(5,51+sY,1,1)
		screen.drawText(7,48+sY,rxString8)
		-- Invisible background rectangle
		screen.setColor(15,15,15)
		screen.drawRectF(0,0,31,6)
		-- Another invisible background rectangle
		screen.drawRectF(0,30,31,2)
		-- Shaded text
		screen.setColor(0,0,0)
		screen.drawText(9,0,"LOG")
		-- Normal text
		screen.setColor(255,255,255)
		screen.drawText(8,0,"LOG")
	elseif screenMode==3 then
		-- Numerical Data
		screen.setColor(255,255,255)
		--1:
		screen.drawText(0,6+sY2,"1")
		screen.drawRectF(5,7+sY2,1,1)
		screen.drawRectF(5,9+sY2,1,1)
		screen.drawText(7,6+sY2,string.format("%.0f",rxNum1))
		--2:
		screen.drawText(0,12+sY2,"2")
		screen.drawRectF(5,13+sY2,1,1)
		screen.drawRectF(5,15+sY2,1,1)
		screen.drawText(7,12+sY2,string.format("%.0f",rxNum2))
		--3:
		screen.drawText(0,18+sY2,"3")
		screen.drawRectF(5,19+sY2,1,1)
		screen.drawRectF(5,21+sY2,1,1)
		screen.drawText(7,18+sY2,string.format("%.0f",rxNum3))
		--4:
		screen.drawText(0,24+sY2,"4")
		screen.drawRectF(5,25+sY2,1,1)
		screen.drawRectF(5,27+sY2,1,1)
		screen.drawText(7,24+sY2,string.format("%.0f",rxNum4))
		--5:
		screen.drawText(0,30+sY2,"5")
		screen.drawRectF(5,31+sY2,1,1)
		screen.drawRectF(5,33+sY2,1,1)
		screen.drawText(7,30+sY2,string.format("%.0f",rxNum5))
		--6:
		screen.drawText(0,36+sY2,"6")
		screen.drawRectF(5,37+sY2,1,1)
		screen.drawRectF(5,39+sY2,1,1)
		screen.drawText(7,36+sY2,string.format("%.0f",rxNum6))
		--7:
		screen.drawText(0,42+sY2,"7")
		screen.drawRectF(5,43+sY2,1,1)
		screen.drawRectF(5,45+sY2,1,1)
		screen.drawText(7,42+sY2,string.format("%.0f",rxNum7))
		--8:
		screen.drawText(0,48+sY2,"8")
		screen.drawRectF(5,49+sY2,1,1)
		screen.drawRectF(5,51+sY2,1,1)
		screen.drawText(7,48+sY2,string.format("%.0f",rxNum8))
		-- Invisible background rectangle
		screen.setColor(15,15,15)
		screen.drawRectF(0,0,31,6)
		-- Another invisible background rectangle
		screen.drawRectF(0,30,31,2)
		-- Shaded text
		screen.setColor(0,0,0)
		screen.drawText(9,0,"NUM")
		-- Normal text
		screen.setColor(255,255,255)
		screen.drawText(8,0,"NUM")
	elseif screenMode==4 then
		-- Shaded text
		screen.setColor(0,0,0)
		screen.drawText(9,0,"VID")
		-- Normal text
		screen.setColor(255,255,255)
		screen.drawText(8,0,"VID")
	end
	if not (screenMode==0) then
		-- Shading
		screen.setColor(0,0,0)
		screen.drawLine(2,1,4,-1)
		screen.drawLine(1,2,6,2)
		screen.drawLine(2,3,4,5)
		-- Return arrow
		screen.setColor(255,255,255)
		screen.drawLine(1,1,3,-1)
		screen.drawLine(0,2,5,2)
		screen.drawLine(1,3,3,5)
	end
	screen.setColor(a,b,c)
	-- Signal strength display
	if signalStrength>0 then
		screen.drawRectF(25,4,1,1)
	end
	if signalStrength>0.25 then
		screen.drawRectF(27,3,1,2)
	end
	if signalStrength>0.5 then
		screen.drawRectF(29,2,1,3)
	end
	if signalStrength>0.75 then
		screen.drawRectF(31,1,1,4)
	end
end
