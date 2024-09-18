local function toggleNuiFrame(shouldShow)
  SetNuiFocus(shouldShow, shouldShow)
  SendReactMessage('setVisible', shouldShow)
end

RegisterNUICallback('hideFrame', function(_, cb)
  toggleNuiFrame(false)
  debugPrint('Hide NUI frame')
  cb({})
end)

-- Convert to list once spawn points known. Refactor method to include for loop over array. Possible object requirements.
function PlayerWithinSpawnRange()
  local spawnZone = vector3(1994.004150, 3810.000000, 32.255104)
  local radius = 100
  local playerPosition = GetEntityCoords(PlayerPedId())
  local dstcheck = GetDistanceBetweenCoords(playerPosition, spawnZone)
  local canActivate = false
  if dstcheck < radius then
    canActivate = true
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
