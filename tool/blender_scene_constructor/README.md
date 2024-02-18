# Blender Scene Constructor

Prepares a blender scene to be ready for rendering, including sun positioning and camera positioning. This ensures consistency between renders and sprites.

## Why do we need this?

When settings up a scene any manual input is prone to mistake (and also time consuming!). So compiling this into a script allows for quick consistent renders to be created.

## Usage

1. Install [Blender](https://www.blender.org/download/).

**Note 💡**: At the time of writing this document, Blender v4.0.2 was used.

2. [Open](https://docs.blender.org/manual/en/latest/files/blend/open_save.html) the `.blend` file in Blender.

3. Set your Blender workspace to [_Layout_](https://docs.blender.org/manual/en/latest/interface/window_system/workspaces.html).

4. Within your _Layout_ workspace, ensure you have the [_Outliner_](https://docs.blender.org/manual/en/latest/editors/outliner/introduction.html) editor available.

5. Within the [_Outliner_](https://docs.blender.org/manual/en/latest/editors/outliner/introduction.html), create a new [_Collection_](https://docs.blender.org/manual/en/latest/scene_layout/collections/collections.html) named "Subject" with all the planes that make your 3D model.

6. Within your _Layout_ workspace, ensure you have the [_Properties_](https://docs.blender.org/manual/en/latest/editors/properties_editor.html) editor available.

7. Select your newly created "Subject" collection within your [_Outliner_](https://docs.blender.org/manual/en/latest/editors/outliner/introduction.html) editor, and within the [_Properties_](https://docs.blender.org/manual/en/latest/editors/properties_editor.html) ensure the _Transform_ location properties are all set to 0.

8. Now, within Blender, open the [_Scripting_ workspace](https://docs.blender.org/manual/en/latest/interface/window_system/workspaces.html).

9. Within your _Scripting_ workspave, ensure you have the [_Text Editor_](https://docs.blender.org/manual/en/latest/editors/text_editor.html) editor available.

10. Within the [_Text Editor_](https://docs.blender.org/manual/en/latest/editors/text_editor.html), open the [`main.py`](main.py) file.

11. Within the [_Text Editor_](https://docs.blender.org/manual/en/latest/editors/text_editor.html), set the `ONLY_RENDER_SHADOWS` constant variable in `main.py` to `True` or `False` to match your desired outcome.

12. Within the [_Text Editor_](https://docs.blender.org/manual/en/latest/editors/text_editor.html), run the script using the `Play` button, available within the [_Text Editor's header_](https://docs.blender.org/manual/en/latest/editors/text_editor.html#header) or with `Alt-P`.

13. Using the [_Render panel_](https://docs.blender.org/manual/en/2.79/render/output/render_panel.html) or with `F12` render your scene!
