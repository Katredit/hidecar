local global      = exports.global
local hideminute  = 10
local maxDistance = 125

_functions = {}
_functions.__mode = "v"

_functions.timer = function(t,k,v)

    local vehicle = v.vehicle
    local player  = v.player

    if isElement(player) then   

        if getDistanceBetweenPoints3D(player.position , vehicle.position) < maxDistance then 
            t[k].timer = setTimer(self.timer, hideminute*1000*60 , 1 , t , k , v)
        return end

        triggerEvent("addBox" , player , player , "info" , global:getVehicleName(vehicle).." marka aracın farklı bir dünyaya gönderildi! (Çıkartmak için /araclarim ID)")
    end

    vehicle.dimension = getElementType(vehicle) == "vehicle" and vehicle:getData("dbid")+1000 or vehicle.dimension

end

_functions.__newindex = function(t,k,v)

    rawset(t,k,v)
    t[k].timer = setTimer(_functions.timer, hideminute*1000*60 , 1 , t , k , v) 

end

vehicles = setmetatable({} , _functions)

addEventHandler("onVehicleExit" , root , function(player , seat)

    if tonumber(seat) == 0 then 

        vehicles[source] = {
            vehicle = source,
            player = player,
        }

    end

end)

addEventHandler("onVehicleEnter" , root , function(player , seat)

    if seat == 0 then

        if vehicles[source] then

            if isTimer(vehicles[source].timer) then
                killTimer(vehicles[source].timer)
            end

            vehicles[source] = nil
            collectgarbage("collect")

        end

    end

end)

addEventHandler("onPlayerQuit" , root , function()

    if source then

        for k , veh in ipairs(getElementsByType("player")) do 

            if tonumber(veh:getData("owner")) == tonumber(source:getData("dbid")) then

                vehicles[veh] = {
                    vehicle = veh,
                    player = source,
                }

            end

        end

    end

end)

addCommandHandler("araclarim" , function(player , cmd , id)

    if not id then outputChatBox("KULLANIM : /"..cmd.." [Araç ID]",player,254,194,14,true) return end 

    id = tonumber(id)

    for k , v in pairs(vehicles) do 

        if tonumber(v.vehicle:getData("dbid")) == id or v.vehicle.dimension == v.vehicle:getData("dbid")+1000 then

            v.vehicle.dimension = 0
            vehicles[k] = nil
            collectgarbage("collect")

        end

    end

end)