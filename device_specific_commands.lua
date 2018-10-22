--[[=============================================================================
    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.device_specific_commands = "2016.01.08"
end

--[[=============================================================================
    ExecuteCommand Code

    Define any functions for device specific commands (EX_CMD.<command>)
    received from ExecuteCommand that need to be handled by the driver.
===============================================================================]]
--function EX_CMD.NEW_COMMAND(tParams)
--	LogTrace("EX_CMD.NEW_COMMAND")
--	LogTrace(tParams)
--end

function EX_CMD.SYNCSTATUS(tParams)
	LogTrace("EX_CMD.SYNCSTATUS")
	LogTrace(tParams)
	local dev_io = tParams["IO"]
	local status = tParams["STATUS"]
	print("dev_io type = " .. type(dev_io))
	local nowstatus = bit.band(bit.rshift(gEioProxy._EioNormalStatus,dev_io-1),0x01)
	if(nowstatus ~= status) then
    	if(status == 0) then
            gEioProxy._EioNormalStatus = gEioProxy._EioNormalStatus - bit.lshift(1,dev_io-1)
    	elseif(status == 1) then
            gEioProxy._EioNormalStatus = bit.bor(gEioProxy._EioNormalStatus,bit.lshift(1,dev_io-1))
    	end
    else
        LogTrace("status same!")
    end
end