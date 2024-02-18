# Blender Scene Constructor

Prepares a blender scene to be ready for rendering, including sun positioning and camera positioning. This ensures consistency between renders and sprites.

## Why do we need this?

When settings up a scene any manual input is prone to mistake (and also time consuming!). So compiling this into a script allows for quick consistent renders to be created

## Usage

1. Place the subject in a collection called `Subject`
2. Ensure the subject is at (0,0,0)
3. Press `Scripting` at the top of blender
4. Open this file
5. Change `ONLY_RENDER_SHADOWS` to match your desired outcome
6. Press the play button
7. Render the scene!
