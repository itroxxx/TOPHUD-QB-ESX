local isHudSettingsEnabled = false

if Config.Framework == 'ESX' then
    ESX = exports['es_extended']:getSharedObject()
elseif Config.Framework == 'QBCore' then
    QBCore = exports['qb-core']:GetCoreObject()
end

CreateThread(function()
    while true do
        local ped = PlayerPedId()
        if ped and ped ~= -1 then
            local sleep = 1000

            -- Update health and armor
            local health = GetEntityHealth(ped) - 100 -- Health is offset by 100
            local armor = GetPedArmour(ped)

            SendNUIMessage({
                action = 'sethp',
                hp = health,
                armour = armor
            })

            Wait(sleep)
        else
            Wait(100) -- Wait for the player entity to be available
        end
    end
end)

-- Update top HUD with ESX or QBCore data
CreateThread(function()
    while true do
        Wait(1000) -- Update every second
        if Config.Framework == 'ESX' then
            ESX.TriggerServerCallback('esx:getPlayerData', function(data)
                updateHud(data)
            end)
        elseif Config.Framework == 'QBCore' then
            QBCore.Functions.GetPlayerData(function(data)
                updateHud(data)
            end)
        end
    end
end)

function updateHud(data)
    local cash = 0
    local bank = 0
    local job = 'Unemployed'
    local grade = ''

    for _, account in ipairs(data.accounts) do
        if Config.Framework == 'ESX' then
            if account.name == 'money' then
                cash = account.money
            elseif account.name == 'bank' then
                bank = account.money
            end
        elseif Config.Framework == 'QBCore' then
            if account.name == 'cash' then
                cash = account.money
            elseif account.name == 'bank' then
                bank = account.money
            end
        end
    end

    if data.job then
        job = data.job.label
        grade = data.job.grade_label
    end

    SendNUIMessage({
        action = 'updateTopHud',
        cash = cash,
        bank = bank,
        job = job,
        grade = grade
    })
end

RegisterCommand('tophud', function()
    isHudSettingsEnabled = not isHudSettingsEnabled
    SendNUIMessage({
        action = isHudSettingsEnabled and 'openHudStyling' or 'closeHudStyling',
        enable = isHudSettingsEnabled
    })
    SetNuiFocus(isHudSettingsEnabled, isHudSettingsEnabled) -- Enable or disable cursor mode
end, false)

RegisterNUICallback('closeHudStyling', function(data, cb)
    isHudSettingsEnabled = false
    SetNuiFocus(false, false) -- Disable cursor mode
    SendNUIMessage({
        action = 'closeHudStyling'
    })
    cb('ok')
end)

RegisterNUICallback('saveHudSettings', function(data, cb)
    isHudSettingsEnabled = false
    SetNuiFocus(false, false) -- Disable cursor mode
    SendNUIMessage({
        action = 'closeHudStyling'
    })
    -- Save the settings to the server or local storage
    TriggerServerEvent('saveHudSettings', data)
    cb('ok')
end)

RegisterNetEvent('loadHudSettings')
AddEventHandler('loadHudSettings', function(settings)
    SendNUIMessage({
        action = 'loadHudSettings',
        settings = settings
    })
end)