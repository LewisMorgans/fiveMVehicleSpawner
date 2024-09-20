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
  while true do
    Citizen.Wait(0)
    if PlayerWithinSpawnRange() then
      DrawTextOnScreen("Press F6 to spawn a vehicle", 0.90, 0.5)     -- Center of the screen
    end
  end
end)

function DrawTextOnScreen(text, x, y)
  SetTextFont(0)                    -- Set the font
  SetTextProportional(1)            -- Make the text proportional
  SetTextScale(0.0, 0.3)            -- Text scale
  SetTextColour(255, 255, 255, 255) -- Text color (white)
  SetTextOutline()                  -- Text outline
  SetTextEntry("STRING")            -- Prepare the text entry
  AddTextComponentString(text)      -- Add the text to display
  DrawText(x, y)                    -- Draw the text at coordinates (x, y)
end

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

RegisterCommand('spawnCar', function()
  if PlayerWithinSpawnRange() then
    toggleNuiFrame(true)
  end
end, false)

RegisterKeyMapping('spawnCar', 'Spawn Car', 'keyboard', 'F6')
