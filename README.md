# Aseprite Scripts
A collection of Lua scripts I've made to extend Aseprite.

To use any of the scripts in this repo, download the script you want (or just clone the whole repo) directly into your Aseprite script directory. You can open the scripts folder by doing `File > Scripts > Open Scripts Folder` from within Aseprite.

Learn about Aseprite scripting [here](https://github.com/aseprite/api).

## Scripts

### image/color-overlay.lua
Overwrites all non-transparent pixels in the current layer with any given color/opacity. Can be applied to the current layer or to a new layer.

### image/stroke.lua
Outlines all non-transparent pixels in the current layer with any color and width. Can be applied to the current layer or to a new layer. 

### timeline/add-frame-background.lua
Adds a new frame to the timeline, copying cels from every layer but the active one. Useful when working on animations with a background.

### misc/midi.lua
Generates a piece of music based on the colors in the current cel image, and outputs the result into a midi file. RGB color to musical note relationships were derived from the principles outlined in [this](https://medium.com/@topherlicious/photism-making-music-from-pictures-3a413eff289f) article. Note octave and duration are completely arbitrary, and follow this chart:

| count | duration | octave |
|-------|----------|--------|
| 1     | 16       | 4      |
| 2     | 8        | 4      |
| 3     | 4        | 4      |
| 4     | 2        | 4      |
| 5     | 1        | 4      |
| 6     | 16       | 5      |
| 7     | 8        | 5      |
| 8     | 4        | 5      |
| 9     | 2        | 5      |
| 10    | 1        | 5      |
| 11    | 16       | 6      |
| 12    | 8        | 6      |
| 13    | 4        | 6      |
| 14    | 2        | 6      |
| 15    | 1        | 6      |
| 16+   | 1        | 3      |

Count represents the consecutive occurrences of a given color, with the image data being read left to right and top to bottom. Duration is equal to note value in a 4/4 time signature.

This script uses a custom compacted version [LuaMidi](https://github.com/PedroAlvesV/LuaMidi) to generate the MIDI files.
