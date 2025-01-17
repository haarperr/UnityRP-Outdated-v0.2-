local attempted = 0

copsonline = nil
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        copsonline = exports['urp-police']:CopsOnline()
    end
end)

local pickup = false
RegisterNetEvent('sec:PickupCash')
AddEventHandler('sec:PickupCash', function()
    pickup = true
    TriggerEvent("sec:PickupCashLoop")
    Wait(180000)
    pickup = false
end)

RegisterNetEvent('sec:PickupCashLoop')
AddEventHandler('sec:PickupCashLoop', function()
    local markerlocation = GetOffsetFromEntityInWorldCoords(attempted, 0.0, -3.7, 0.1)
    SetVehicleHandbrake(attempted,true)
    while pickup do
        Citizen.Wait(1)
        local coords = GetEntityCoords(GetPlayerPed(-1))
        local aDist = GetDistanceBetweenCoords(coords["x"], coords["y"],coords["z"], markerlocation["x"],markerlocation["y"],markerlocation["z"])
        if aDist < 10.0 then
            DrawMarker(27,markerlocation["x"],markerlocation["y"],markerlocation["z"], 0, 0, 0, 0, 0, 0, 1.51, 1.51, 0.3, 212, 189, 0, 30, 0, 0, 2, 0, 0, 0, 0)
            
            if aDist < 2.0 then
                if IsDisabledControlJustReleased(0, 38) then
                    pickUpCash()
                end
                DrawText3Ds(markerlocation["x"],markerlocation["y"],markerlocation["z"], "Press [E] to pick up cash.")
            else
                DrawText3Ds(markerlocation["x"],markerlocation["y"],markerlocation["z"], "Get Closer to pick up the cash.")
            end
        end
    end
end)

function DropItemPedBankCard()

    local pos = GetEntityCoords(PlayerPedId())
    local myluck = math.random(2)

    if myluck == 1 then
        TriggerEvent("player:receiveItem","gruppe63",1)
    elseif myluck == 2 then
        TriggerEvent("player:receiveItem","cb",1)
    end
end


RegisterNetEvent('sec:AddPeds')
AddEventHandler('sec:AddPeds', function(veh)
    local cType = 's_m_m_highsec_01'

    local pedmodel = GetHashKey(cType)
    RequestModel(pedmodel)
    while not HasModelLoaded(pedmodel) do
        RequestModel(pedmodel)
        Citizen.Wait(100)
    end

   
   ped1 = CreatePedInsideVehicle(veh, 4, pedmodel, -1, 1, 0.0)
   ped2 = CreatePedInsideVehicle(veh, 4, pedmodel, 0, 1, 0.0)
   ped3 = CreatePedInsideVehicle(veh, 4, pedmodel, 1, 1, 0.0)
   ped4 = CreatePedInsideVehicle(veh, 4, pedmodel, 2, 1, 0.0)
   
   GiveWeaponToPed(ped1, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)
   GiveWeaponToPed(ped2, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)
   GiveWeaponToPed(ped3, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)
   GiveWeaponToPed(ped4, GetHashKey('WEAPON_SpecialCarbine'), 420, 0, 1)

   
   SetPedDropsWeaponsWhenDead(ped1,false)
   SetPedRelationshipGroupDefaultHash(ped1,GetHashKey('COP'))
   SetPedRelationshipGroupHash(ped1,GetHashKey('COP'))
   SetPedAsCop(ped1,true)
   SetCanAttackFriendly(ped1,false,true)

   SetPedDropsWeaponsWhenDead(ped2,false)
   SetPedRelationshipGroupDefaultHash(ped2,GetHashKey('COP'))
   SetPedRelationshipGroupHash(ped2,GetHashKey('COP'))
   SetPedAsCop(ped2,true)
   SetCanAttackFriendly(ped2,false,true)

   SetPedDropsWeaponsWhenDead(ped3,false)
   SetPedRelationshipGroupDefaultHash(ped3,GetHashKey('COP'))
   SetPedRelationshipGroupHash(ped3,GetHashKey('COP'))
   SetPedAsCop(ped3,true)
   SetCanAttackFriendly(ped3,false,true)
   

   SetPedDropsWeaponsWhenDead(ped4,false)
   SetPedRelationshipGroupDefaultHash(ped4,GetHashKey('COP'))
   SetPedRelationshipGroupHash(ped4,GetHashKey('COP'))
   SetPedAsCop(ped4,true)
   SetCanAttackFriendly(ped4,false,true)

   TaskCombatPed(ped1, GetPlayerPed(-1), 0, 16)
   TaskCombatPed(ped2, GetPlayerPed(-1), 0, 16)
   TaskCombatPed(ped3, GetPlayerPed(-1), 0, 16)
   TaskCombatPed(ped4, GetPlayerPed(-1), 0, 16)
end)

local pickingup = false
function pickUpCash()
    local gotcard = false
    if not pickingup then
        TriggerEvent("alert:noPedCheck", "banktruck")
        local coords = GetEntityCoords(GetPlayerPed(-1))
       -- Citizen.Trace("Doing Animation")
        local length = 2
        pickingup = true
        RequestAnimDict("anim@mp_snowball")
        
        while not HasAnimDictLoaded("anim@mp_snowball") do
            Citizen.Wait(0)
        end

        while pickingup do

            local coords2 = GetEntityCoords(GetPlayerPed(-1))
            local aDist = GetDistanceBetweenCoords(coords["x"], coords["y"],coords["z"], coords2["x"],coords2["y"],coords2["z"])
            if aDist > 1.0 or not pickup then
                pickingup = false
            end

            if IsEntityPlayingAnim(GetPlayerPed(-1), "anim@mp_snowball", "pickup_snowball", 3) then
                --ClearPedSecondaryTask(player)
            else
                TaskPlayAnim(GetPlayerPed(-1), "anim@mp_snowball", "pickup_snowball", 8.0, -8, -1, 49, 0, 0, 0, 0)
            end 

            local chance = math.random(1,60)

            if chance > 35 and not gotcard then
                gotcard = true
                TriggerEvent("alert:noPedCheck", "banktruck")
                DropItemPedBankCard()
            end

            if chance < 10 then
                TriggerEvent("alert:noPedCheck", "banktruck")
                TriggerEvent("player:receiveItem","band",math.random(length))
            end

            TriggerEvent("player:receiveItem","rollcash",math.random(length))
            
            Wait(math.random(4000,6000))

            length = length + 1

            if length > 15 then
                length = 15
            end

        end

        ClearPedTasks(GetPlayerPed(-1))
        
    end
end


RegisterNetEvent('sec:usegroup6card')
AddEventHandler('sec:usegroup6card', function()
    if copsonline >= 6 then
        TriggerEvent('inventory:removeItem', 'Gruppe6Card', 1)
        local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
        local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 100.0, 0.0)
        --local countpolice = exports["isPed"]:isPed("countpolice")
        local targetVehicle = getVehicleInDirection(coordA, coordB)
        if targetVehicle ~= 0 and GetHashKey("stockade") == GetEntityModel(targetVehicle) then
            local entityCreatePoint = GetOffsetFromEntityInWorldCoords(targetVehicle, 0.0, -4.0, 0.0)
            local coords = GetEntityCoords(GetPlayerPed(-1))
            local aDist = GetDistanceBetweenCoords(coords["x"], coords["y"],coords["z"], entityCreatePoint["x"], entityCreatePoint["y"],entityCreatePoint["z"])
            if aDist < 2.0 then
                TriggerEvent("alert:noPedCheck", "banktruck")
                FreezeEntityPosition(GetPlayerPed(-1), true)
                local finished = exports["urp-taskbar"]:taskBar(45000, "Unlocking Vehicle")
                if finished == 100 then
                    FreezeEntityPosition(GetPlayerPed(-1), false)
                    TriggerEvent("sec:AttemptHeist", targetVehicle)
                else
                    FreezeEntityPosition(GetPlayerPed(-1), false)
                    TriggerEvent("DoLongHudText","You need to do this from behind the vehicle.")
                end
            end
        end
    else
        TriggerEvent('DoLongHudText', 'There are not enough cops around', 2)
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000)
        jobname = exports['isPed']:isPed('job')
        TriggerServerEvent('urp-securityheists:gatherjob', jobname)
    end
end)


RegisterNetEvent('sec:AttemptHeist')
AddEventHandler('sec:AttemptHeist', function(veh)
    attempted = veh
    SetEntityAsMissionEntity(attempted,true,true)
    local plate = GetVehicleNumberPlateText(veh)
    TriggerServerEvent("sec:checkRobbed",plate)

end)
RegisterNetEvent('sec:AllowHeist')
AddEventHandler('sec:AllowHeist', function()
    TriggerEvent("sec:AddPeds",attempted)
    SetVehicleDoorOpen(attempted, 2, 0, 0)
    SetVehicleDoorOpen(attempted, 3, 0, 0)
    TriggerEvent("sec:PickupCash")

end)



function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)

    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.015+ factor, 0.03, 41, 11, 41, 68)
end


 --TaskCombatPed(ped, GetPlayerPed(-1), 0, 16)  
function FindEndPointCar(x,y)   
	local randomPool = 50.0
	while true do

		if (randomPool > 2900) then
			return
		end
	    local vehSpawnResult = {}
	    vehSpawnResult["x"] = 0.0
	    vehSpawnResult["y"] = 0.0
	    vehSpawnResult["z"] = 30.0
	    vehSpawnResult["x"] = x + math.random(randomPool - (randomPool * 2),randomPool) + 1.0  
	    vehSpawnResult["y"] = y + math.random(randomPool - (randomPool * 2),randomPool) + 1.0  
	    roadtest, vehSpawnResult, outHeading = GetClosestVehicleNode(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"],  0, 55.0, 55.0)

        Citizen.Wait(1000)        
        if vehSpawnResult["z"] ~= 0.0 then
            local caisseo = GetClosestVehicle(vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], 20.000, 0, 70)
            if not DoesEntityExist(caisseo) then

                return vehSpawnResult["x"], vehSpawnResult["y"], vehSpawnResult["z"], outHeading
            end
            
        end

        randomPool = randomPool + 50.0
	end
    --endResult["x"], endResult["y"], endResult["z"]
end