# 📹 Blender Scene Constructor

Prepares a Blender scene to be ready for rendering by adjusting the sun positioning and camera positioning.

**Note 💡**: This process ensures consistency between all our in-game sprites.

## Why do we need this?

Automatically configuring the scene eradicates those errors derived from manual input. Scripting the configuration, allows for quick and consistent renders to be created.

## Usage

1. Install [Blender](https://www.blender.org/download/).

**Note 💡**: At the time of writing this document Blender v4.0.2 was used.

2. [Open](https://docs.blender.org/manual/en/latest/files/blend/open_save.html) the `.blend` file in Blender.

3. Set your Blender workspace to [_Layout_](https://docs.blender.org/manual/en/latest/interface/window_system/workspaces.html).

4. Within your _Layout_ workspace, ensure you have the [_Outliner_](https://docs.blender.org/manual/en/latest/editors/outliner/introduction.html) editor available.

5. Within the [_Outliner_](https://docs.blender.org/manual/en/latest/editors/outliner/introduction.html), create a new [_Collection_](https://docs.blender.org/manual/en/latest/scene_layout/collections/collections.html) named "Subject" with all the planes that make your 3D model.

6. Within your _Layout_ workspace, ensure you have the [_Properties_](https://docs.blender.org/manual/en/latest/editors/properties_editor.html) editor available.

7. Select your newly created "Subject" collection within your [_Outliner_](https://docs.blender.org/manual/en/latest/editors/outliner/introduction.html) editor, and within the [_Properties_](https://docs.blender.org/manual/en/latest/editors/properties_editor.html) editor ensure the _Transform_ location properties are all set to 0.

8. Now, within Blender, open the [_Scripting_](https://docs.blender.org/manual/en/latest/interface/window_system/workspaces.html) workspace.

9. Within your _Scripting_ workspace, ensure you have the [_Text Editor_](https://docs.blender.org/manual/en/latest/editors/text_editor.html) editor available.

10. Within the [_Text Editor_](https://docs.blender.org/manual/en/latest/editors/text_editor.html), open the [`main.py`](main.py) file.

11. In the recently opened `main.py` file, set the `ONLY_RENDER_SHADOWS` constant variable to `True` or `False` to accomodate for your desired outcome.

12. Run the script using the `Play` button, available within the [_Text Editor's header_](https://docs.blender.org/manual/en/latest/editors/text_editor.html#header), or with `Alt-P`.

13. Check the camera viewfinder, you may find that the camera is pointing too far down, in this case modify the _y_ position to move it up or down until it is in frame. It may also be the case that if you are capturing a shadow that the shadow is predominantly on one side of the image, in this case modify the _x_ position so that the entire shadow is captured without any wasted whitespace (be warned, shadows go extremely soft towards the edge, so you may need more space than you think!)

14. Then modify the output resolution in the _Output Properties_ tab to match the ratio of the subject.

15. You may also need to change the _Orthographic Scale_ on the _Camera's Lens_ data property (This will change how zoomed in the camera is). To find this, select the camera in the _Outliner_ and then select the camera icon in the _Properties_ tab.

16. Using the [_Render panel_](https://docs.blender.org/manual/en/2.79/render/output/render_panel.html), or with `F12`, render your scene!
