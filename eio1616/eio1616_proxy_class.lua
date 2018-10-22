--[[=============================================================================
    EIO Proxy Class

    Copyright 2018 Hiwise Corporation. All Rights Reserved.
===============================================================================]]

-- This macro is utilized to identify the version string of the driver template version used.
if (TEMPLATE_VERSION ~= nil) then
	TEMPLATE_VERSION.eio_proxy_class = "2018.05.23"
end

EioProxy = inheritsFrom(nil)

function EioProxy:construct(bindingID)
	-- member variables
	self._BindingID = bindingID

	self:Initialize()

end

function EioProxy:Initialize()
	-- create and initialize member variables

	self._TcpPort = Properties["TcpPort"]
	self._UdpServerPort = Properties["UdpPort"]
	self._BindList = {}
	self._EioModeHex = 0x00 
	self._EioDeviceAddr = 1
--[[    self._EioMode = {IO1 = "INPUT",IO2 = "INPUT",IO3 = "INPUT",IO4 = "INPUT",
                     IO5 = "INPUT",IO6 = "INPUT",IO7 = "INPUT",IO8 = "INPUT",
                     IO9 = "INPUT",IO10 = "INPUT",IO11 = "INPUT",IO12 = "INPUT",
                     IO13 = "INPUT",IO14 = "INPUT",IO15 = "INPUT",IO16 = "INPUT"}  ]]
    self._EioNormalStatus = 0xffff
    self._EioNowStatus = 0xffff
    self._EioKeepAliveCmd = nil
    self._EioKeepAliveTimer = CreateTimer("EioKeepAlive", 90, "SECONDS", EioKeepAliveCallback, true, nil)
--[[    self._EioStatus = {IO1 = 1,IO2 = 1,IO3 = 1,IO4 = 1,
                       IO5 = 1,IO6 = 1,IO7 = 1,IO8 = 1,
                       IO9 = 1,IO10 = 1,IO11 = 1,IO12 = 1,
                       IO13 = 1,IO14 = 1,IO15 = 1,IO16 = 1}   ]]
end

function EioKeepAliveCallback()
    LogTrace("EioKeepAliveCallback")
    if(gCon._IsConnected) then
        if(gCon._IsOnline) then
            if(gEioProxy._EioKeepAliveCmd ~= nil) then
                hexdump(gEioProxy._EioKeepAliveCmd)
                gCon:SendCommand(gEioProxy._EioKeepAliveCmd,1,"SECONDS","CONTROL_CMD")
            end
        end
    end
end


function EioProxy:CommandPack(command,reg_addr,reg_num)
    LogTrace("EioProxy:CommandPack")
    local cmd = string.pack("bb>H>H",self._EioDeviceAddr,command,reg_addr,reg_num)
    local crccode = usMBCRC16(cmd,#cmd)
    cmd = cmd .. string.pack("H",crccode)
    return cmd
end

function EioProxy:UdpServerCreate()
    LogTrace("EioProxy:UdpServerCreate ")
    C4:CreateServer(self._UdpServerPort, "", true)
end

function EioProxy:UdpServerDestroy()
    LogTrace("EioProxy:UdpServerDestroy ")
    C4:DestroyServer(self._UdpServerPort)
end


function EioProxy:SyncPropertiesIO(eiomodehex)
    LogTrace("EioProxy:SyncPropertiesIO")
    local temp = 0x0001
    if(eiomodehex == self._EioModeHex) then
        return
    end
    for i=0,15 do
        if(bit.band(eiomodehex,bit.lshift(temp,i)) == 0) then
            UpdateProperty("IO" .. (i+1) .. "_MODE","INPUT")
        else
            UpdateProperty("IO" .. (i+1) .. "_MODE","OUTPUT")
        end
    end
    self._EioModeHex = eiomodehex
end

function EioProxy:AlarmHandle(eiostatushex)
    LogTrace("EioProxy:AlarmHandle")
    local status = bit.bxor(self._EioNowStatus,eiostatushex)
    local temp = 0x0001
    self._EioNowStatus = eiostatushex
    if(status ~= 0) then
        for i=0,15 do
            if(bit.band(status,bit.lshift(temp,i)) ~= 0) then
                LogTrace("C4:FireEvent")
                C4:FireEventByID(i+1)
                if(self._BindList[i+1] ~= nil) then
                    local message = bit.band(bit.rshift(eiostatushex,i),0x0001)
                    if(message == 1) then
                        SendSimpleNotify("OPENED",i+1)
                    elseif(message == 0) then
                        SendSimpleNotify("CLOSED",i+1)
                    end
                   -- C4:SendToDevice(self._BindList[i+1],"ALARM",{MESSAGE = message})
                end
            end
        end                
    else
        return
    end
end



function EioProxy:HandleMessage(message)
    LogTrace("EioProxy:HandleMessage")
    hexdump(message)
    local msglen = #message
    local cmddata = ""
    local crccode = usMBCRC16(message,msglen-2)
    if(bit.rshift(crccode,8) == string.byte(message,msglen-2+2) and bit.band(crccode,0xff) == string.byte(message,msglen-2+1)) then
--        local pos,devid,cmd,len,mode_reg,state_reg = string.unpack(message,"bbb>H>H")
        local pos,devid,cmd = string.unpack(message,"bb")
        cmddata = string.sub(message,pos)
        if(cmd == 0x03) then
            local pos,len,mode_reg,state_reg = string.unpack(cmddata,"b>H>H")
            self:SyncPropertiesIO(mode_reg)
            self:AlarmHandle(state_reg)
        elseif(cmd == 0x10) then
            local pos,start_reg,reg_num,len,high_reg,low_reg = string.unpack(cmddata,">H>Hb>H>H")
            self:AlarmHandle(high_reg)
        end
    else
        LogTrace("HandleMessage data error!!")
    end
end



