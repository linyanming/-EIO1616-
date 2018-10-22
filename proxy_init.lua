--[[=============================================================================
    Initialization Functions

    Copyright 2017 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "eio1616.eio1616_proxy_class"
require "eio1616.eio1616_proxy_commands"
require "eio1616.eio1616_proxy_notifies"

IP_DEVICES_ADDR = {}
DEVICE_ADDR = {}
-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.proxy_init = "2017.01.13"
end

function ON_DRIVER_EARLY_INIT.proxy_init()
	-- declare and initialize global variables
end

function ON_DRIVER_INIT.proxy_init()
	-- connect the url connection
	--ConnectURL()
	gIsNetworkConnected = true
	SetControlMethod()

	-- instantiate the camera proxy class
	gEioProxy = EioProxy:new(DEFAULT_PROXY_BINDINGID)
	gEioProxy._EioKeepAliveCmd = gEioProxy:CommandPack(0x03,0x0000,0x0002)
end

function ON_DRIVER_LATEINIT.proxy_init()
    StartTimer(gEioProxy._EioKeepAliveTimer)
    gEioProxy:UdpServerCreate()
end

function IP_DEVICES_ADDR.init()

    local i = 0
    local devid = C4:GetDeviceID()     
    local devs = C4:GetBoundConsumerDevices(devid , 1)   
    if (devs ~= nil) then
    for id,name in pairs(devs) do
	   print ("id " .. id .. " name " .. name)
	   DEVICE_ADDR[i] = id
	   i = i + 1
    end
    end
end

function TestCondition(name, tParams)
    LogTrace("TestCondition()")
    LogTrace("name = " .. name)
    LogTrace("tParams = ")
    LogTrace(tParams)
    local retVal = false
    local temp = 0
    if(tParams["VALUE"] == "False") then
        temp = 0
    elseif(tParams["VALUE"] == "True") then
        temp = 1
    end
    if(name == "BOOL_CHENNEL1") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,0),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL2") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,1),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL3") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,2),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL4") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,3),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL5") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,4),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL6") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,5),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL7") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,6),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL8") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,7),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL9") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,8),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL10") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,9),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL11") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,10),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL12") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,11),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL13") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,12),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL14") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,13),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL15") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,14),0x01) == temp) then
            retVal = true
        end
    elseif(name == "BOOL_CHENNEL16") then
        if(bit.band(bit.rshift(gEioProxy._EioNowStatus,15),0x01) == temp) then
            retVal = true
        end
    end
    
    LogTrace("Result=" .. tostring(retVal))
    return retVal
end

