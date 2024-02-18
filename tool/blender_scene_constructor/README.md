# Blender Scene Constructor

Prepares a blender scene to be ready for rendering, including sun positioning and camera positioning. This ensures consistency between renders and sprites.

## Why do we need this?

When settings up a scene any manual input is prone to mistake (and also time consuming!). So compiling this into a script allows for quick consistent renders to be created.

## Usage

1. Install [Blender](https://www.blender.org/download/).

**Note 💡**: At the time of writing this document, Blender v4.0.2 was used.

2. [Open](https://docs.blender.org/manual/en/latest/files/blend/open_save.html) the `.blend` file in Blender.

3. Set your Blender workspace to [_Layout_](https://docs.blender.org/manual/en/latest/interface/window_system/workspaces.html).

4. Within your workspace, ensure you have the [_Outliner_](https://docs.blender.org/manual/en/latest/editors/outliner/introduction.html) editor available.

5. Place the subject in a collection called `Subject`
6. Ensure the subject is at (0,0,0)
7. Press `Scripting` at the top of blender
8. Open this file
9. Change `ONLY_RENDER_SHADOWS` to match your desired outcome
10. Press the play button
11. Render the scene!
