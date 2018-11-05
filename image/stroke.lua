-- Ensure we can use UI stuff
if not app.isUIAvailable then
  return
end

-- Ensure a sprite is loaded
if sprite == nil then
  app.alert("You must open a sprite first to use this script!")
  return
end

-- Ensure the current layer is a valid one
if not currentLayer.isImage or not currentLayer.isEditable then
  app.alert("You must have an editable image layer selected!")
  return
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

-- Determines if a pixel has any data in it
local function pixelHasData(pixel)
  local rgbaAlpha = pixelColor.rgbaA(pixel)
  local grayAlpha = pixelColor.grayaA(pixel)

  return rgbaAlpha ~= 0 or grayAlpha ~= 0
end

-- Prepare the dialog
local dlg = Dialog()

-- Main inputs
dlg:color{ id="color", label="Color", color=app.fgColor }
dlg:slider{ id="size", label="Width", min=1, max=100, value=1 }

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

-- Get the original image and a new image for the stroke
local image = cel.image
local loopImage = image:clone()
local strokeImage = image:clone()
local blankStrokeImage = Image(image.width, image.height, image.colorMode)

-- Draw the stroke
for i = 1, data.size, 1 do
  for it in loopImage:pixels() do
    local pixel = it()

    -- Only try to stroke if a pixel has data
    if pixelHasData(pixel) then
      local up = strokeImage:getPixel(it.x, it.y - 1)
      local down = strokeImage:getPixel(it.x, it.y + 1)
      local left = strokeImage:getPixel(it.x - 1, it.y)
      local right = strokeImage:getPixel(it.x + 1, it.y)

      if not pixelHasData(up) then
        strokeImage:putPixel(it.x, it.y - 1, chosenPixelColor)
        blankStrokeImage:putPixel(it.x, it.y - 1, chosenPixelColor)
      end
      if not pixelHasData(down) then
        strokeImage:putPixel(it.x, it.y + 1, chosenPixelColor)
        blankStrokeImage:putPixel(it.x, it.y + 1, chosenPixelColor)
      end
      if not pixelHasData(left) then
        strokeImage:putPixel(it.x - 1, it.y, chosenPixelColor)
        blankStrokeImage:putPixel(it.x - 1, it.y, chosenPixelColor)
      end
      if not pixelHasData(right) then
        strokeImage:putPixel(it.x + 1, it.y, chosenPixelColor)
        blankStrokeImage:putPixel(it.x + 1, it.y, chosenPixelColor)
      end
    end
  end

  loopImage:putImage(strokeImage)
end

-- Write the stroke image data in a transaction
app.transaction(
  function()
    -- Create a new layer if requested
    if data.newLayer then
      local newLayer = sprite:newLayer()
      cel = sprite:newCel(newLayer, activeFrame)
      strokeImage = blankStrokeImage
    end
    
    cel.image:putImage(strokeImage)
  end
)
