local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  debugPrint('Hide NUI frame')
  cb({})
end)

function PlayerWithinSpawnRange()
  local spawnZones = Config.SpawnZones
  local radius = 15.0
  local playerPosition = GetEntityCoords(PlayerPedId())

  for _, zoneCoords in ipairs(spawnZones) do
    local distanceSquared = #(playerPosition - zoneCoords) ^ 2
    local radiusSquared = radius ^ 2

    if distanceSquared <= radiusSquared then
      return true
    end
  end

  return false
end

Citizen.CreateThread(function()
  RegisterKeyMapping('spawnCar', 'Spawn Car', 'keyboard', Config.SpawnKey)

  while true do
    Citizen.Wait(0)
    if PlayerWithinSpawnRange() and Config.StaticSpawnZonesEnabled == true then
      DrawTextOnScreen("Press " .. Config.SpawnKey .. " to spawn a vehicle", 0.90, 0.5)
    end
  end
end)

RegisterNUICallback('spawnVehicle', function(data, cb)
  local playerPed = PlayerPedId()
  local pos = GetEntityCoords(playerPed)
  local vehicleName = data
  if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
    TriggerEvent('chat:addMessage', {
      args = { vehicleName .. '^* Not found' }
    })
    return
  end

  RequestModel(vehicleName)
  while not HasModelLoaded(vehicleName) do
    Wait(0)
  end

  local oldVehicle = GetVehiclePedIsIn(playerPed, true)
  SetEntityAsMissionEntity(oldVehicle, true, true)
  DeleteEntity(oldVehicle)

  local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
  SetPedIntoVehicle(playerPed, vehicle, -1)
  SetEntityAsNoLongerNeeded(vehicle)

  SetModelAsNoLongerNeeded(vehicleName)
end)

RegisterNuiCallback('vehicleList', function(data, cb)
  debugPrint('Data sent by React', json.encode(data))
  cb(VehicleDictionary)
end)

RegisterCommand('spawnCar', function()
  if Config.StaticSpawnZonesEnabled == false then
    toggleNuiFrame(true)
  end
  if PlayerWithinSpawnRange() then
    toggleNuiFrame(true)
  end
end, false)
