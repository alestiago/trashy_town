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

5. Within the [_Outliner_](https://docs.blender.org/manual/en/latest/editors/outliner/introduction.html), create a new [_Collection_](https://docs.blender.org/manual/en/latest/scene_layout/collections/collections.html) named "Subject" with all the planes that make your 3D model.

6. Within your workspace, ensure you have the [_Properties_](https://docs.blender.org/manual/en/latest/editors/properties_editor.html) editor available.

7. Select your newly created "Subject" collection within your [_Outliner_](https://docs.blender.org/manual/en/latest/editors/outliner/introduction.html) editor, and within the [_Properties_](https://docs.blender.org/manual/en/latest/editors/properties_editor.html) ensure the _Transform_ location properties are all set to 0.

8. Press `Scripting` at the top of blender
9. Open this file
10. Change `ONLY_RENDER_SHADOWS` to match your desired outcome
11. Press the play button
12. Render the scene!
