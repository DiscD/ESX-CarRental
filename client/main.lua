ESX              = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

local blips = {
     {title="Car Rental", colour=26, id=290, x = 157.2131, y = -1012.327, z = 29.3939}
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
      info.blip = AddBlipForCoord(info.x, info.y, info.z)
      SetBlipSprite(info.blip, info.id)
      SetBlipDisplay(info.blip, 4)
      SetBlipScale(info.blip, 0.7)
      SetBlipColour(info.blip, info.colour)
      SetBlipAsShortRange(info.blip, true)
	  BeginTextCommandSetBlipName("STRING")
      AddTextComponentString(info.title)
      EndTextCommandSetBlipName(info.blip)
    end
end)

function CarMenu()
    ESX.UI.Menu.CloseAll()
    local vehicles = {}
    table.insert(vehicles, {label = "blista", value = "Blista"})
    table.insert(vehicles, {label = "sanchez", value = "Sanchez"})
    table.insert(vehicles, {label = "Phoenix", value = "Phoenix"})
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'VehiclesMenu', {
        title    = 'Rental Vehicles',
        align    = 'top-left',
        elements = vehicles
    }, function(data, menu)
        if data.current.value == "Blista" then
            TriggerServerEvent("lt:remove", "Blista")
            ESX.UI.Menu.CloseAll()
        elseif data.current.value == "Sanchez" then
            TriggerServerEvent("lt:remove", "Sanchez")
            ESX.UI.Menu.CloseAll()
        elseif data.current.value == "Phoenix" then
            TriggerServerEvent("lt:remove", "Phoenix")
            ESX.UI.Menu.CloseAll()
        end
    end, function(data, menu)
        ESX.UI.Menu.CloseAll()
    end)
end

RegisterNetEvent("lt:spawn")
AddEventHandler("lt:spawn", function(car)
	local playerPed = PlayerPedId()
	local coords    = vector3(157.2131, -1012.327, 29.3939)

	ESX.Game.SpawnVehicle(car, coords, 90.0, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
		SetVehicleNumberPlateText(vehicle, "RENTAL")
	end)
end)






function DrawText3Ds(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if isNear then
        local coords = vector3(163.3035, -1006.263, 29.4087)
        local player = ESX.GetPlayerData()
        local ped = PlayerPedId()
		DrawText3Ds(coords.x, coords.y, coords.z+0.3, "~g~E~w~ To rental a vehicle [250$]")
		DrawMarker(2, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.3, 0.2, 22, 155, 29, 155, 0, 0, 0, 1, 0, 0, 0)
        if player.job ~= nil and player.job.name ~= "police" and player.job.name ~= "ambulance" then
            if Vdist2(coords) and IsControlJustPressed(1, 38) then
                if IsPedInAnyVehicle(ped, false) then
                    TriggerEvent("notification", "You can not rental cars while you are sitting in vehicle.")
                else
                    CarMenu()
                end
            end
        end
	end
	end
end)


Citizen.CreateThread(function()
	local ped = PlayerPedId()
	while true do
		local coords = GetEntityCoords(ped)
		local coordsRent = vector3(163.3035, -1006.263, 29.4087)
		Citizen.Wait(500)
		if Vdist(coords, coordsRent) < 15 then
			isNear = true
		else
			isNear = false
		end
	end
end)
