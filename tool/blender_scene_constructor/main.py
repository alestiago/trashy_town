import bpy
import math

# Get the active camera in the scene
camera = bpy.context.scene.camera

# ----------------------------------------------------
# THESE SETTINGS NEED TO BE THE SAME FOR ALL RENDERS

SHADOW_SIZE = 2
CAMERA_ANGLE = 45
OBJECT_COLLECTION_NAME = "Subject"
SHADOW_GROUP_NAME = "ShadowToggleable"
# ----------------------------------------------------

# Set this to True if you want to render only the shadows
ONLY_RENDER_SHADOWS = True

def setup_camera(camera):
    # Set the camera to orthographic mode
    camera.data.type = 'ORTHO'

    # Set the background to transparent
    bpy.context.scene.render.film_transparent = True

    # Place the camera at the specified location
    camera.location = (0, -8, 8)

    # Set the rotation on the X-axis to 45 degrees (converted to radians)
    camera.rotation_euler[0] = math.radians(CAMERA_ANGLE)
    
# Function to add a plane and set it as a shadow catcher
def add_shadow_catcher_plane(): 
    # Check if a shadow catcher plane with the specific name already exists
    if "ShadowCatcherPlane" not in bpy.data.objects:
        bpy.ops.mesh.primitive_plane_add(size=30, location=(0, 0, 0))
        plane = bpy.context.object
        plane.is_shadow_catcher = True
        plane.name = "ShadowCatcherPlane"
        # Move the plane to the scene collection
        try:
            bpy.context.scene.collection.objects.link(plane)
            # Unlink from the Subject collection if it exists
            if bpy.data.collections.get("Subject"):
                bpy.data.collections["Subject"].objects.unlink(plane)
        except:
            pass

# Function to delete all sun lamps
def delete_all_sun_lamps():
    sun_lamps = [obj for obj in bpy.context.scene.objects if obj.type == 'LIGHT' and obj.data.type == 'SUN']
    for sun in sun_lamps:
        bpy.data.objects.remove(sun, do_unlink=True)

# Function to add or move the area lamp
def add_or_move_area(camera):
    # Delete all sun lamps
    delete_all_sun_lamps()
    area = bpy.data.objects.get("Area")
    
    if area is None:
        # Add a new area lamp
        bpy.ops.object.light_add(type='AREA', location=(camera.location.x - 3, camera.location.y, camera.location.z))
        # Fetch the newly created area lamp
        area = bpy.context.object
        area.name = "Area"
    
    # Set the strength of the area lamp to 2
    area.data.energy = 100
    
    # Position the area lamp 3 units to the left of the camera and at the same Y position
    area.location.x = camera.location.x - SHADOW_SIZE
    area.location.y = camera.location.y
    area.location.z = camera.location.z
    
    # Calculate the direction vector from area lamp location to origin
    direction = -area.location
    # Align the area lamp to point in the calculated direction
    area.rotation_euler = direction.to_track_quat('-Z', 'Y').to_euler()
    
def modify_or_create_shadow_toggleable_node_group():
    # Check if the group already exists
    if SHADOW_GROUP_NAME in bpy.data.node_groups:
        # Get the existing group
        group = bpy.data.node_groups[SHADOW_GROUP_NAME]
        # Clear existing nodes
        group.nodes.clear()
    else:
        # Create a new node group
        group = bpy.data.node_groups.new(type="ShaderNodeTree", name=SHADOW_GROUP_NAME)
        
        # Add the Input Sockets and change their Default Values
        group.interface.new_socket(name="Shader",in_out ="INPUT", socket_type="NodeSocketShader")

        # Add the Output Sockets and change their Default Value
        group.interface.new_socket(name="Shader",in_out ="OUTPUT", socket_type="NodeSocketShader")

    input_node = group.nodes.new(type='NodeGroupInput')
    input_node.location = (-200, 0)

    output_node = group.nodes.new(type='NodeGroupOutput')
    output_node.location = (200, 0)

    # Add mixer node
    mixer_node = group.nodes.new(type='ShaderNodeMixShader')
    mixer_node.location = (0, 100)
    mixer_node.inputs[0].default_value = int(not ONLY_RENDER_SHADOWS)

    # Add Transparent BSDF node
    transparent_node = group.nodes.new(type='ShaderNodeBsdfTransparent')
    transparent_node.location = (-200, 200)
    
     # Connect Transparent node to the mixer
    group.links.new(transparent_node.outputs["BSDF"], mixer_node.inputs[1])

    # Connect Input to the mixer
    group.links.new(input_node.outputs["Shader"], mixer_node.inputs[2])

    # Connect mixer to Output
    group.links.new(mixer_node.outputs["Shader"], output_node.inputs["Shader"])

  
    print("ShadowToggleable node group modified or created.")


def add_shadow_toggleable_node_to_materials(collection_name):
    collection = bpy.data.collections.get(collection_name)
    if not collection:
        print(f"Collection '{collection_name}' not found.")
        return

    # Get the node group
    shadow_toggleable_group = bpy.data.node_groups.get("ShadowToggleable")
    if not shadow_toggleable_group:
        print("Node group 'ShadowToggleable' not found.")
        return
    
    # Iterate over each material in the collection
    for obj in collection.objects:
        if obj.type != 'MESH':
            continue
        
        for slot in obj.material_slots:
            material = slot.material
            if material:
                # Check if the node group is already added to the material
                is_already_added = False
                for node in material.node_tree.nodes:
                    if node.type == 'GROUP' and node.node_tree == shadow_toggleable_group:
                        is_already_added = True
                        break
                
                if not is_already_added:
                    # Create a new node group instance
                    shadow_toggleable_node = material.node_tree.nodes.new('ShaderNodeGroup')
                    shadow_toggleable_node.node_tree = shadow_toggleable_group
                    # Position the node in the material node editor
                    shadow_toggleable_node.location = (0, 0)
                    
                    # Find the output node in the material node tree
                    output_node = None
                    linked_node = None
                    for node in material.node_tree.nodes:
                        if node.type == 'OUTPUT_MATERIAL':
                            output_node = node
                        elif node.outputs and node.outputs[0].links:
                            linked_node = node

                    if output_node:
                        # Link the node to the output node
                        material.node_tree.links.new(shadow_toggleable_node.outputs[0], output_node.inputs[0])
                    else:
                        print(f"Material Output node not found in material '{material.name}'.")

                    if linked_node:
                        # Relink the previously linked node to the ShadowToggleable node
                        material.node_tree.links.new(linked_node.outputs[0], shadow_toggleable_node.inputs[0])
                    else:
                        print("No previously linked node found.")

if camera is not None:
    setup_camera(camera)
    add_shadow_catcher_plane()
    add_or_move_area(camera)
    modify_or_create_shadow_toggleable_node_group()
    add_shadow_toggleable_node_to_materials(OBJECT_COLLECTION_NAME)
#    setup_only_render_shadows(ONLY_RENDER_SHADOWS)
    
else:
    print("No active camera found in the scene.")