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
