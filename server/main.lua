ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent('lt:remove')
AddEventHandler('lt:remove', function(car)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    if xPlayer.getMoney() >= 250 then
        xPlayer.removeMoney(250)
        TriggerClientEvent('lt:spawn', _source, car) 
    else 
        TriggerClientEvent("notification", _source, "You do not have enough money", 2)
    end
end)

