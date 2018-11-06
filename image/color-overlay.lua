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

-- Prepare the dialog
local dlg = Dialog()

-- Main inputs
dlg:color{ id="color", label="Color", color=app.fgColor }

-- Buttons
dlg:button{ id="currentLayer", text="Apply to current layer" }
dlg:button{ id="newLayer", text="Apply to new layer" }
dlg:button{ id="cancel", text="Cancel" }

-- Show the dialog
dlg:show()

-- Get dialog data
local data = dlg.data
local chosenPixelColor = pixelColor.rgba(data.color.red, data.color.green, data.color.blue, data.color.alpha)

-- Stop on cancel
if data.cancel then
  return
end

-- Stop on X
if not data.currentLayer and not data.newLayer then
  return
end

-- Get original image coordinates
local imageCoords = {
  x = cel.bounds.x,
  y = cel.bounds.y
}

-- Get the original image and clone it
local image = cel.image
local copy = image:clone()

-- Overwrite the pixels on the clone
for it in copy:pixels() do
  local pixel = it()

  -- Only overwrite a pixel if it has data in it
  if pixelHasData(pixel) then
    copy:putPixel(it.x, it.y, chosenPixelColor)
  end
end

-- Replace the original with a copy in a transaction
app.transaction(
  function()
    -- Create a new layer if requested
    if data.newLayer then
      local newLayer = sprite:newLayer()
      cel = sprite:newCel(newLayer, activeFrame)
      cel.image = copy
      cel.position = imageCoords
    else
      cel.image:putImage(copy)
    end
  end
)
