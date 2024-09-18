local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  debugPrint('Hide NUI frame')
  cb({})
end)

-- Plaeto bay 490, 13, 69.51
-- Havering 1857, 3680, 33.79

function PlayerWithinSpawnRange()
  local spawnZones = { vector3(490, 13, 69.51), vector3(1857, 3680, 33.79) }
  local radius = 15
  local playerPosition = GetEntityCoords(PlayerPedId())
  local dstcheck
  local canActivate = false

  for _, i in ipairs(spawnZones) do
    dstcheck = GetDistanceBetweenCoords(playerPosition, i)
    if dstcheck < radius then
      canActivate = true
    end
  end

  return canActivate
end

RegisterNUICallback('spawnVehicle', function(data, cb)
  local playerPed = PlayerPedId()
  local pos = GetEntityCoords(playerPed)
  local vehicleName = data

  print('playercoords', pos)
  print('data sent by react', json.encode(data), data) -- debugPrint

  if not IsModelInCdimage(vehicleName) or not IsModelAVehicle(vehicleName) then
    TriggerEvent('chat:addMessage', {
      args = { vehicleName .. '^* Not found' }
    })
    return
  end

  RequestModel(vehicleName)
  while not HasModelLoaded(vehicleName) do
    Wait(500)
  end

  local oldVehicle = GetVehiclePedIsIn(playerPed, true)
  SetEntityAsMissionEntity(oldVehicle, true, true)
  DeleteEntity(oldVehicle)

  local vehicle = CreateVehicle(vehicleName, pos.x, pos.y, pos.z, GetEntityHeading(playerPed), true, false)
  SetPedIntoVehicle(playerPed, vehicle, -1)
  SetEntityAsNoLongerNeeded(vehicle)

  SetModelAsNoLongerNeeded(vehicleName)
end)

RegisterCommand('spawnCar', function()
  if PlayerWithinSpawnRange() then
    toggleNuiFrame(true)
  end
end, false)

RegisterKeyMapping('spawnCar', 'Spawn Car', 'keyboard', 'F6')
