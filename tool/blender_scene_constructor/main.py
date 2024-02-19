import bpy
import math

# Get the active camera in the scene
camera = bpy.context.scene.camera

# ----------------------------------------------------
# THESE SETTINGS NEED TO BE THE SAME FOR ALL RENDERS

SHADOW_SIZE = 2
CAMERA_ANGLE = 45
OBJECT_COLLECTION_NAME = "Subject"
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
    
# Set render engine to Cycles
bpy.context.scene.render.engine = 'CYCLES'

def setup_only_render_shadows(only_render_shadows=True):
    plane = bpy.data.objects["ShadowCatcherPlane"]
    plane.hide_render = not only_render_shadows
    # Create a new material
    material = bpy.data.materials.new(name="ShadowOnlyMaterial")

    # Check if the material already has a node tree
    if not material.node_tree:
        material.use_nodes = True

    # Create nodes
    nodes = material.node_tree.nodes
    links = material.node_tree.links

    # Clear default nodes
    for node in nodes:
        nodes.remove(node)

    # Create Principled BSDF node
    principled_node = nodes.new(type='ShaderNodeBsdfPrincipled')
    principled_node.location = (0,0)

    # Create Transparent BSDF node
    transparent_node = nodes.new(type='ShaderNodeBsdfTransparent')
    transparent_node.location = (-400,0)

    # Create Mix Shader node
    mix_shader_node = nodes.new(type='ShaderNodeMixShader')
    mix_shader_node.location = (400,0)

    # Create Material Output node
    output_node = nodes.new(type='ShaderNodeOutputMaterial')
    output_node.location = (800,0)

    # Create Light Path node
    light_path_node = None
    if only_render_shadows:
        light_path_node = nodes.new(type='ShaderNodeLightPath')
        light_path_node.location = (-200,200)

    # Link nodes
    links.new(principled_node.outputs['BSDF'], mix_shader_node.inputs[1])
    links.new(transparent_node.outputs['BSDF'], mix_shader_node.inputs[2])
    if only_render_shadows:
        links.new(light_path_node.outputs['Is Camera Ray'], mix_shader_node.inputs['Fac'])
    links.new(mix_shader_node.outputs['Shader'], output_node.inputs['Surface'])

    # Get the collection
    collection = bpy.data.collections.get(OBJECT_COLLECTION_NAME)

    # If the collection exists
    if collection:
        # Iterate over all objects in the collection
        for obj in collection.objects:
            # Check if the object has a material slot
            if obj.material_slots:
                # Assign the material to the object
                obj.material_slots[0].material = material
            else:
                # If the object doesn't have a material slot, create one and assign the material
                bpy.context.view_layer.objects.active = obj
                bpy.ops.object.material_slot_add()
                obj.material_slots[0].material = material
                

if camera is not None:
    setup_camera(camera)
    add_shadow_catcher_plane()
    add_or_move_area(camera)
    setup_only_render_shadows(ONLY_RENDER_SHADOWS)
    
else:
    print("No active camera found in the scene.")