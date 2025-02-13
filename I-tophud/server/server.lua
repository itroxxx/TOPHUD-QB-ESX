if Config.Framework == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

RegisterServerEvent('saveHudSettings')
AddEventHandler('saveHudSettings', function(settings)
    local src = source
    local identifier = GetPlayerIdentifier(src)
    MySQL.Async.execute('REPLACE INTO hud_settings (identifier, settings) VALUES (@identifier, @settings)', {
        ['@settings'] = json.encode(settings),
        ['@identifier'] = identifier
    })
end)

RegisterServerEvent('closeHudStyling')
AddEventHandler('closeHudStyling', function()
    local src = source
end)

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local src = source
    local identifier = GetPlayerIdentifier(src)
    MySQL.Async.fetchScalar('SELECT settings FROM hud_settings WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(settings)
        if settings then
            TriggerClientEvent('loadHudSettings', src, json.decode(settings))
        end
    end)
end)

AddEventHandler('playerSpawned', function()
    local src = source
    local identifier = GetPlayerIdentifier(src)
    MySQL.Async.fetchScalar('SELECT settings FROM hud_settings WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(settings)
        if settings then
            TriggerClientEvent('loadHudSettings', src, json.decode(settings))
        end
    end)
end)