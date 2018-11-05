-- Ensure we can use UI stuff
if not app.isUIAvailable then
  return
end

-- Ensure a sprite is loaded
if app.activeSprite == nil then
  app.alert("You must open a sprite first to use this script!")
  return
end

-- Ensure the current layer is a valid one
if not app.activeLayer.isImage or not app.activeLayer.isEditable then
  app.alert("You must have an editable image layer selected!")
  return
end

-- Determines if a pixel has any data in it
local function pixelHasData(pixel)
  local rgbaAlpha = app.pixelColor.rgbaA(pixel)
  local grayAlpha = app.pixelColor.grayaA(pixel)

  return rgbaAlpha ~= 0 or grayAlpha ~= 0
end

-- Polyfil for active frame
local function activeFrameNumber()
  local f = app.activeFrame
  if f == nil then
    return 1
  else
    return f
  end
end

-- Returns the cel in the given layer and frame
local function getActiveCel(layer, frame)
  -- Loop through cels
  for i,cel in ipairs(layer.cels) do

    -- Find the cell in the given frame
    if cel.frame == frame then
      return cel
    end
  end
end

-- Get sprite data
local sprite = app.activeSprite
local currentLayer = app.activeLayer
local activeFrame = activeFrameNumber()
local pixelColor = app.pixelColor
local cel = getActiveCel(currentLayer, activeFrame)

local function addFrameBackground()
  -- Prepare the dialog
  local dlg = Dialog()

  -- Buttons
  dlg:button{ id="add", text="Add frame with non-active layers" }
  dlg:button{ id="cancel", text="Done" }

  -- Show the dialog
  dlg:show()

  -- Get dialog data
  local data = dlg.data

  -- Stop on cancel
  if data.cancel then
    return
  end

  -- Stop on X
  if not data.add then
    return
  end

  app.transaction(
    function()
      -- New frame!
      local newFrame = sprite:newFrame(activeFrame + 1)
      local newCel = getActiveCel(currentLayer, newFrame.frameNumber)

      -- Delete the cel in the new frame of the active layer
      sprite:deleteCel(newCel)
    end
  )

  addFrameBackground()
end

-- Trigger again if they want to add multiple
addFrameBackground()
