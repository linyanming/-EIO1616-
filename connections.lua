--[[=============================================================================
    Functions for managing the status of the drivers bindings and connection state
 
    Copyright 2016 Control4 Corporation. All Rights Reserved.
===============================================================================]]
require "common.c4_network_connection"
require "common.c4_serial_connection"
require "common.c4_ir_connection"
require "common.c4_url_connection"

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.connections = "2016.08.15"
end

-- constants
COM_USE_ACK = false
COM_COMMAND_DELAY_MILLISECONDS = 250
COM_COMMAND_RESPONSE_TIMEOUT_SECONDS = 4

NETWORK_PORT = 502
NETWORK_BINDING_ID = 6001

EIO_MIN_ID = 1
EIO_MAX_ID = 16

function OnEioBingdingChanged(idBinding, class, bIsBound)
    LogTrace("OnEioBingdingChanged")
    local devid = C4:GetDeviceID()     
    local devs = C4:GetBoundConsumerDevices(devid , idBinding)  
    if(devs ~= nil) then
        for id,name in pairs(devs) do
            print("id = " .. id .. " ".. type(id) .. "name = " .. name)
            gEioProxy._BindList[idBinding] = id
        end
    else
        gEioProxy._BindList[idBinding] = nil
    end
end

--[[=============================================================================
    OnSerialConnectionChanged(idBinding, class, bIsBound)
  
    Description:
    Function called when a serial binding changes state(bound or unbound).
  
    Parameters:
    idBinding(int) - ID of the binding whose state has changed (SERIAL_BINDING_ID).
    class(string)  - Class of binding that has changed.
                     A single binding can have multiple classes(i.e. COMPONENT,
                     STEREO, RS_232, etc).
                     This indicates which has been bound or unbound.
    bIsBound(bool) - Whether the binding has been bound or unbound.
  
    Returns:
    None
===============================================================================]]
function OnSerialConnectionChanged(idBinding, class, bIsBound)
	
end

--[[=============================================================================
    OnIRConnectionChanged(idBinding, class, bIsBound)
  
    Description:
    Function called when an IR binding changes state(bound or unbound).
  
    Parameters:
    idBinding(int) - ID of the binding whose state has changed (SERIAL_BINDING_ID).
    class(string)  - Class of binding that has changed.
                     A single binding can have multiple classes(i.e. COMPONENT,
                     STEREO, RS_232, etc).
                     This indicates which has been bound or unbound.
    bIsBound(bool) - Whether the binding has been bound or unbound.
  
    Returns:
    None
===============================================================================]]
function OnIRConnectionChanged(idBinding, class, bIsBound)
	
end

--[[=============================================================================
    OnNetworkConnectionChanged(idBinding, bIsBound)
  
    Description:
    Function called when a network binding changes state(bound or unbound).
  
    Parameters:
    idBinding(int) - ID of the binding whose state has changed.
    bIsBound(bool) - Whether the binding has been bound or unbound.
  
    Returns:
    None
===============================================================================]]
function OnNetworkConnectionChanged(idBinding, bIsBound)
	
end

--[[=============================================================================
    OnNetworkStatusChanged(idBinding, nPort, sStatus)
  
    Description:
    Called when the network connection status changes. Sets the updated status of the specified binding
  
    Parameters:
    idBinding(int)  - ID of the binding whose status has changed
    nPort(int)      - The communication port of the specified bindings connection
    sStatus(string) - "ONLINE" if the connection status is to be set to Online,
                      any other value will set the status to Offline
  
    Returns:
    None
===============================================================================]]
function OnNetworkStatusChanged(idBinding, nPort, sStatus)
	
end

--[[=============================================================================
    OnServerConnectionStatusChanged(nHandle, nPort, strStatus)
  
    Description:
    Called when the network server connection status changes. Sets the updated status of the specified binding
  
    Parameters:
    nHandle(int)  	- Handle of the connection whose status has changed
    nPort(int)      - The communication port of the specified bindings connection
    sStatus(string) - "ONLINE" if the connection status is to be set to Online,
                      any other value will set the status to Offline
  
    Returns:
    None
===============================================================================]]
function OnServerConnectionStatusChanged(nHandle, nPort, strStatus)
    LogTrace("Server Connection Established: %s  %s  %s", tostring(nHandle),tostring(nPort),tostring(strStatus))
--	if (strStatus == "ONLINE") then
--		LogTrace("Server Connection Established: %s", tostring(nHandle))
--	else
--		LogTrace("Server Connection Disconnected: %s", tostring(nHandle))
--	end
end

--[[=============================================================================
    OnURLConnectionChanged(url)
  
    Description:
    Function called when the c4_url_connection is created.
  
    Parameters:
    url - url used by the url connection.
  
    Returns:
    None
===============================================================================]]
function OnURLConnectionChanged(url)
	
end

--[[=============================================================================
    DoEvents()
  
    Description:
    
  
    Parameters:
    None
  
    Returns:
    None
===============================================================================]]
function DoEvents()
    LogTrace("DoEvents")
end

--[[=============================================================================
    SendKeepAlivePollingCommand()
  
    Description:
    Sends a driver specific polling command to the connected system
  
    Parameters:
    None
  
    Returns:
    None
===============================================================================]]
function SendKeepAlivePollingCommand()
	--TODO: Implement the keep alive command for the network connected system if required.
end

