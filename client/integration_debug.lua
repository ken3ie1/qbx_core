print('[qbx_core-debug] integration_debug.lua loaded')

-- Print resource states and listen for key events so you can debug which resources are present
local function logStates(prefix)
    prefix = prefix or 'debug'
    print(('[qbx_core-debug] %s: um-spawn=%s, um-multicharacter=%s, qbx_spawn=%s, qbx_apartments=%s'):
        format(prefix,
               tostring(GetResourceState('um-spawn')),
               tostring(GetResourceState('um-multicharacter')),
               tostring(GetResourceState('qbx_spawn')),
               tostring(GetResourceState('qbx_apartments'))))
end

CreateThread(function()
    Wait(1000)
    logStates('startup')

    -- print states periodically to help debugging
    for i = 1, 12 do -- print for ~1 minute
        Wait(5000)
        logStates('periodic')
    end
end)

-- Event listeners to confirm events are firing
RegisterNetEvent('um-spawn:client:startSpawnUI', function()
    print('[qbx_core-debug] EVENT: um-spawn:client:startSpawnUI received on client')
end)

RegisterNetEvent('um-multicharacter:client:start', function()
    print('[qbx_core-debug] EVENT: um-multicharacter:client:start received on client')
end)
RegisterNetEvent('um_multicharacter:client:start', function()
    print('[qbx_core-debug] EVENT: um_multicharacter:client:start received on client')
end)

RegisterNetEvent('qbx_core:client:chooseCharacter', function()
    print('[qbx_core-debug] EVENT: qbx_core:client:chooseCharacter invoked (redirector)')
    logStates('chooseCharacter')
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    print('[qbx_core-debug] EVENT: QBCore:Client:OnPlayerLoaded received')
    logStates('onPlayerLoaded')
    if GetResourceState('um-spawn') == 'started' then
        print('[qbx_core-debug] Triggering um-spawn:client:startSpawnUI from QBCore:Client:OnPlayerLoaded')
        TriggerEvent('um-spawn:client:startSpawnUI')
    else
        print('[qbx_core-debug] um-spawn not started; not triggering')
    end
end)

RegisterCommand('qbx_debug_states', function()
    logStates('command')
end, false)
