-- Donkey primary controller
k=0
spotlightMode=0
function onTick()
	local brake=input.getNumber(1)
	local throttle=input.getNumber(2)
	local headlightR=property.getNumber("Headlights R")
	local headlightG=property.getNumber("Headlights G")
	local headlightB=property.getNumber("Headlights B")
	local rearlightR=property.getNumber("Rearlights R")
	local rearlightG=0
	local rearlightB=0
	local engine=input.getBool(1)
	local reverse=input.getBool(2)
	local wheelSlipProtection=input.getBool(3)
	local cabinLight=input.getBool(8)
	local backlights=input.getBool(11)
	local cycleSpotlightModes=input.getBool(14)
	local frontSlip=input.getBool(15)
	local middleSlip=input.getBool(16)
	local rearSlip=input.getBool(17)
	local frontIsConnected=input.getBool(18)
	local rearIsConnected=input.getBool(19)
	local engineMU=input.getBool(20)
	local reverseMU=input.getBool(21)
	local engineCutoff=input.getBool(22)

	-- Disable engine if cutoff is activated
	if engineCutoff then
		engine=false
		engineT=false
		engineMU=false
	end

	-- Engine & Reverse push-to-toggles
	if engine and not E then
		engineT=not engineT
	end
	E=engine

	if reverse and not R then
		reverseT=not reverseT
	end
	R=reverse

	-- Headlights
	local frontLightR=0
	local frontLightG=0
	local frontLightB=0
	local rearLightR=0
	local rearLightG=0
	local rearLightB=0
	-- Checking what direction the locomotive is going in and setting headlight color accordingly
	if (engineT or engineMU) and (reverseT or reverseMU) then
		frontLightR=rearlightR
		frontLightG=rearlightG
		frontLightB=rearlightB
		rearLightR=headlightR
		rearLightG=headlightG
		rearLightB=headlightB
	elseif (engineT or engineMU) then
		frontLightR=headlightR
		frontLightG=headlightG
		frontLightB=headlightB
		rearLightR=rearlightR
		rearLightG=rearlightG
		rearLightB=rearlightB
	end
	-- Checking if locomotive is connected to train cars, and if it is, turn off headlights in that direction
	if frontIsConnected then
		frontLightR=0
		frontLightG=0
		frontLightB=0
	end
	if rearIsConnected then
		rearLightR=0
		rearLightG=0
		rearLightB=0
	end
	-- Spotlights
	-- LOW BEAM: -0.5
	-- HIGH BEAM: 0.25

	-- Pulse for the up counter
	if not cycleSpotlightModes then k=0 else k=k+1 end
	if k==1 then cycleSpotlightModes=true else cycleSpotlightModes=false end
	-- Up counter
	if cycleSpotlightModes then
		spotlightMode=spotlightMode+1
	end
	-- Clamp
	spotlightMode=math.max(0,math.min(spotlightMode,3))

	local frontSpotlight=false
	local rearSpotlight=false
	-- Default, aka LOW BEAM spotlight y pivot position
	spotlightPivot=-0.5
	-- Reset counter when it reaches 3
	if spotlightMode==3 then spotlightMode=0 end
	-- Turning on front or rear spotlights depending on the spotlightMode counter and reverseT button
	if spotlightMode==1 and reverseT then
		rearSpotlight=true
	elseif spotlightMode==2 and reverseT then
		rearSpotlight=true
		spotlightPivot=0.25
	elseif spotlightMode==1 then
		frontSpotlight=true
	elseif spotlightMode==2 then
		frontSpotlight=true
		spotlightPivot=0.25
	end
	-- Checking if locomotive is connected to train cars, and if it is, turn off the spotlight in that direction
	if frontIsConnected then
		frontSpotlight=false
		spotlightMode=0
	end
	if rearIsConnected then
		rearSpotlight=false
		spotlightMode=0
	end

	-- Wheel slip protection
	local wheelSlip=false
	if frontSlip or middleSlip or rearSlip then
		wheelSlip=true
	end
	local throttleDown=false
	if wheelSlip and wheelSlipProtection then
		throttleDown=true
	end

	output.setNumber(1,brake)
	output.setNumber(2,throttle)
	output.setNumber(3,frontLightR)
	output.setNumber(4,frontLightG)
	output.setNumber(5,frontLightB)
	output.setNumber(6,rearLightR)
	output.setNumber(7,rearLightG)
	output.setNumber(8,rearLightB)
	output.setNumber(9,spotlightPivot)
	output.setBool(1,engineT)
    output.setBool(2,reverseT)
    output.setBool(3,backlights)
    output.setBool(4,cabinLight)
    output.setBool(5,frontSpotlight)
    output.setBool(6,rearSpotlight)
	output.setBool(7,throttleDown)
end