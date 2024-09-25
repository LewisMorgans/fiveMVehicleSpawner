--- A simple wrapper around SendNUIMessage that you can use to
--- dispatch actions to the React frame.
---
---@param action string The action you wish to target
---@param data any The data you wish to send along with this action
function SendReactMessage(action, data)
  SendNUIMessage({
    action = action,
    data = data
  })
end

local currentResourceName = GetCurrentResourceName()

local debugIsEnabled = GetConvarInt(('%s-debugMode'):format(currentResourceName), 0) == 1

--- A simple debug print function that is dependent on a convar
--- will output a nice prettfied message if debugMode is on
function debugPrint(...)
  if not debugIsEnabled then return end
  local args <const> = { ... }

  local appendStr = ''
  for _, v in ipairs(args) do
    appendStr = appendStr .. ' ' .. tostring(v)
  end
  local msgTemplate = '^3[%s]^0%s'
  local finalMsg = msgTemplate:format(currentResourceName, appendStr)
  print(finalMsg)
end

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
