import os, sys, zipfile
import math, mathutils
import bpy
import struct
from json import dumps, load

scene_name = bpy.data.scenes[0].name.lower()
mesh_dir_name = "meshs"
curve_dir_name = "curves"
camera_dir_name = "cameras"
lamp_dir_name = "lamps"
material_dir_name = "materials"
image_dir_name = "images"


# export to blend file location
basedir = os.path.dirname(bpy.data.filepath)
scenedir = basedir + "/../scenes"
compress_directory = scenedir + "/" + scene_name
compress_file = compress_directory + ".zip"

luadir = basedir + "/../scripts"
#luadir = "/usr/local/lib/lua/5.1"
lua_file = luadir + "/" + scene_name + ".lua"












lua_string = "\n\
local " + scene_name.upper() + " = {}\n\
" + scene_name.upper() + ".__index = " + scene_name.upper() + "\n\
\n\
\n\
function " + scene_name.upper() + ".new(init)\n\
    local self = setmetatable({}, " + scene_name.upper() + ")\n\
    self.textureIDs = {}\n\
    self.meshIDs = {}\n\
    \n\
"
lua_object_string = ""
lua_image_string = ""
lua_collision_response_string = ""
lua_state_string = ""

#    self.textureIDs[\"bricks\"] = jli.TextureFactory_createTextureFromData(\"bricks\")\n\
#    self.meshIDs[\"icosphere\"] = jli.ViewObjectFactory_createViewObject(\"icosphere\", self.textureIDs[\"bricks\"]);\n\















def write_lua_file():
    writeString(lua_string, lua_file)
#end def

#system_command = "\
#cd " + basedir + "\n\
#cd ../scenes\n\
#mkdir " + scene_name + "\n\
#cd " + scene_name + "\n\
#mkdir " + mesh_dir_name + "\n\
#mkdir " + curve_dir_name + "\n\
#mkdir " + camera_dir_name + "\n\
#mkdir " + lamp_dir_name + "\n\
#mkdir " + material_dir_name + "\n\
#mkdir " + image_dir_name + "\n\
#"

directory = scenedir + "/" + scene_name
if not os.path.exists(directory):
    os.makedirs(directory)

directory = compress_directory + "/" + mesh_dir_name
if not os.path.exists(directory):
    os.makedirs(directory)

directory = compress_directory + "/" + curve_dir_name
if not os.path.exists(directory):
    os.makedirs(directory)

directory = compress_directory + "/" + camera_dir_name
if not os.path.exists(directory):
    os.makedirs(directory)

directory = compress_directory + "/" + lamp_dir_name
if not os.path.exists(directory):
    os.makedirs(directory)

directory = compress_directory + "/" + material_dir_name
if not os.path.exists(directory):
    os.makedirs(directory)

directory = compress_directory + "/" + image_dir_name
if not os.path.exists(directory):
    os.makedirs(directory)

#os.system(system_command)

if not basedir:
    raise Exception("Blend file is not saved")

















def formatFloat(_float):
    return "{:.3f}".format(_float)
#end def

def formatInt(_int):
    return "{:d}".format(_int)
#end def

def printDelimeter():
    return ","
#end def

def populateUVImageName(object, uv_layer_index):
    path_raw   = object.uv_textures[uv_layer_index].data[0].image.filepath_raw
    
    path_split = path_raw.split('/')
    
    return path_split[len(path_split) - 1];

#end def

def triangulateNMesh(object):
	bneedtri = False
	scene = bpy.context.scene
	bpy.ops.object.mode_set(mode='OBJECT')
	for i in scene.objects: i.select = False #deselect all objects
	object.select = True
	scene.objects.active = object #set the mesh object to current
	print("Checking mesh if needs to convert quad to Tri...")
	for face in object.data.tessfaces:
		if (len(face.vertices) > 3):
			bneedtri = True
			break
    
	bpy.ops.object.mode_set(mode='OBJECT')
	if bneedtri == True:
		print("Converting quad to tri mesh...")
		me_da = object.data.copy() #copy data
		me_ob = object.copy() #copy object
		#note two copy two types else it will use the current data or mesh
		me_ob.data = me_da
		bpy.context.scene.objects.link(me_ob)#link the object to the scene #current object location
		for i in scene.objects: i.select = False #deselect all objects
		me_ob.select = True
		scene.objects.active = me_ob #set the mesh object to current
		bpy.ops.object.mode_set(mode='EDIT') #Operators
		bpy.ops.mesh.select_all(action='SELECT')#select all the face/vertex/edge
		bpy.ops.mesh.quads_convert_to_tris() #Operators
		bpy.context.scene.update()
		bpy.ops.object.mode_set(mode='OBJECT') # set it in object
		print("Triangulate Mesh Done!")
		print("Remove Merge tmp Mesh [ " ,object.name, " ] from scene!" )
		bpy.ops.object.mode_set(mode='OBJECT') # set it in object
		bpy.context.scene.objects.unlink(object)
	else:
		print("No need to convert tri mesh.")
		me_ob = object
	return me_ob
#end def

def populateIndicesList(object):
    indices = []
    
    #    if(noVertexColorsAndUVLayers(object)):
    #        indices = []
    #        for poly in object.polygons:
    #            for vertice_index in poly.vertices:
    #                indices.append(vertice_index)
    #        #end for
    #        #end for
    #
    #        return indices
    #	#end if
    
    for poly in object.polygons:
        i = 0
        for loop_index in range(poly.loop_start, poly.loop_start + poly.loop_total):
            current_index = (poly.loop_total * poly.index) + i
            i = i + 1
            indices.append(current_index)
    #end for
	#end for
    
    return indices
#end populateIndicesList

def populateVertexList(object):
    vertex_list = []
    
    #    if(noVertexColorsAndUVLayers(object)):
    #        vertex_list = []
    #        for vertex in object.vertices:
    #            verts = [vertex.co[0], vertex.co[1], vertex.co[2]]
    #            vertex_list.append(verts)
    #        #end for
    #        return vertex_list
    #    #end if
    
    for poly in object.polygons:
        for loop_index in range(poly.loop_start, poly.loop_start + poly.loop_total):
            verts = [object.vertices[object.loops[loop_index].vertex_index].co[0],
					 object.vertices[object.loops[loop_index].vertex_index].co[1],
					 object.vertices[object.loops[loop_index].vertex_index].co[2],
                     1.0]
            vertex_list.append(verts)
    #end for
	#end for
    
    return vertex_list
#end populateVertexList

def populateNormalList(object):
    list = []
    
    #    if(noVertexColorsAndUVLayers(object)):
    #        list = []
    #        for vertex in object.vertices:
    #            verts = [vertex.normal[0], vertex.normal[1], vertex.normal[2]]
    #            list.append(verts)
    #        #end for
    #        return list
    #    #end if
	
    for poly in object.polygons:
        for loop_index in range(poly.loop_start, poly.loop_start + poly.loop_total):
            norm = [object.vertices[object.loops[loop_index].vertex_index].normal[0],
					object.vertices[object.loops[loop_index].vertex_index].normal[1],
					object.vertices[object.loops[loop_index].vertex_index].normal[2],
                    0.0]
            list.append(norm)
    #end for
	#end for
    
    return list
#end populateNormalList

def populateVertexColorsList(object, vertex_color_index):
    list = []
    
    for poly in object.polygons:
        for loop_index in range(poly.loop_start, poly.loop_start + poly.loop_total):
            vert_colors = [object.vertex_colors[vertex_color_index].data[loop_index].color[0], object.vertex_colors[vertex_color_index].data[loop_index].color[1], object.vertex_colors[vertex_color_index].data[loop_index].color[2], 1.0]
            list.append(vert_colors)
    return list
#end populateVertexColorsList

def populateUVLayersList(object, uv_layer_index):
    list = []
    
    #if len(object.uv_layers) < uv_layer_index:
    for poly in object.polygons:
        for loop_index in range(poly.loop_start, poly.loop_start + poly.loop_total):
            u = object.uv_layers[uv_layer_index].data[loop_index].uv[0]
            v = object.uv_layers[uv_layer_index].data[loop_index].uv[1]
            uv_coords = [u, v]
            list.append(uv_coords)
    return list
#end populateUVLayersList

def populateUVImageName(object, uv_layer_index):
    path_raw   = object.uv_textures[uv_layer_index].data[0].image.filepath_raw
    
    path_split = path_raw.split('/')
    
    return path_split[len(path_split) - 1];

#end def

def writeString(string, outfile):
    file = open(outfile, 'wb')
    
    file.write(bytes(string, 'UTF-8'))
    
    file.flush()
    file.close()
#end def

def writeJSONFILE(json_data, outfile):
    json_list = []
    
    outfile_lower = outfile.lower()
    
    json_list.append(json_data)
    json_string = dumps([bpy.context.scene.name, json_list], indent=4)
    
    
    
    with open(outfile_lower, "w") as file:
        file.write(json_string)
    file.close()
    
    print("Wrote file: " + outfile_lower)

#end def

def distance( v1, v2 ):
    v = []
    
    v.append( v1[0] - v2[0] )
    v.append( v1[1] - v2[1] )
    v.append( v1[2] - v2[2] )
    
    return math.sqrt( ( v[0] * v[0] ) + ( v[1] * v[1] ) + ( v[2] * v[2] ) )
#end def

def objectHalfExtends(vertex_list):
    half_extends = [0.0, 0.0, 0.0 ]
    ubound = [ sys.float_info.min, sys.float_info.min, sys.float_info.min ]
    lbound = [ sys.float_info.max,  sys.float_info.max,  sys.float_info.max ]
    
    for index in range(len(vertex_list)):
        vertex_loc = [vertex_list[index][0], vertex_list[index][1], vertex_list[index][2]]
        
        # min
        lbound[0] = min(vertex_loc[0], lbound[0])
        lbound[1] = min(vertex_loc[1], lbound[1])
        lbound[2] = min(vertex_loc[2], lbound[2])
        
        ubound[0] = max(vertex_loc[0], ubound[0])
        ubound[1] = max(vertex_loc[1], ubound[1])
        ubound[2] = max(vertex_loc[2], ubound[2])
    #end for
    
    # DimX
    a = [ ubound[0], ubound[1], ubound[2] ]
    b = [ lbound[0], ubound[1], ubound[2] ]
    half_extends[0] = distance( a, b ) * 0.5
    
    # DimY
    a = [ ubound[0], ubound[1], ubound[2] ]
    b = [ ubound[0], lbound[1], ubound[2] ]
    half_extends[1] = distance( a, b ) * 0.5
    
    # DimZ
    a = [ ubound[0], ubound[1], ubound[2] ]
    b = [ ubound[0], ubound[1], lbound[2] ]
    half_extends[2] = distance( a, b ) * 0.5
    
    return half_extends

#end def

def objectTranform(object):
    transform = []
    
    localTransform_T = object.matrix_local.copy()
    localTransform_T.transpose()
    for row in localTransform_T.row:
        transform.append(row[0])
        transform.append(row[1])
        transform.append(row[2])
        transform.append(row[3])
    return transform
#end def

def export_mesh_string(mesh,
                       indices_list,
                       vertice_list,
                       normal_list,
                       color_list,
                       uv_list,
                       uv_image_list,
                       half_extends,
                       object_transform):
    
    string_delimeter = printDelimeter()
    string = ""
    
    
    use_vertex_normals = "0"
    if(len(normal_list) > 0):
        use_vertex_normals = "1"
    #end if
    string += use_vertex_normals + string_delimeter
    
    
    use_vertex_colors = "0"
    if(len(mesh.vertex_colors) > 0):
        use_vertex_colors = "1"
    #end if
    string += use_vertex_colors + string_delimeter

    for index in range(32):
        if(index < len(mesh.uv_layers)):
            string += "1" + string_delimeter
        else:
            string += "0" + string_delimeter
        #end if
    #end for

    string += formatInt(len(indices_list)) + string_delimeter

    string += formatInt(len(vertice_list)) + string_delimeter

    for index in range(32):
        if(index < len(mesh.uv_layers)):
            _uv_image_list_list = uv_image_list[index].split(".")
            string += _uv_image_list_list[0].lower() + string_delimeter
        #end if
    #end for

    

    half_extends_list = [formatFloat(0.0), formatFloat(0.0), formatFloat(0.0)]
    for index in range(3):
        half_extends_list[index] = formatFloat(half_extends[index])
        string += half_extends_list[index] + string_delimeter
    #end for
    
    world_transform_list = [formatFloat(0.0), formatFloat(0.0), formatFloat(0.0), formatFloat(0.0),
                            formatFloat(0.0), formatFloat(0.0), formatFloat(0.0), formatFloat(0.0),
                            formatFloat(0.0), formatFloat(0.0), formatFloat(0.0), formatFloat(0.0),
                            formatFloat(0.0), formatFloat(0.0), formatFloat(0.0), formatFloat(0.0)]
    for index in range(16):
        world_transform_list[index] = formatFloat(object_transform[index])
        string += world_transform_list[index] + string_delimeter
    #end for

    for index in range(len(indices_list)):
        string += formatInt(indices_list[index]) + string_delimeter
    #end for
    
    for index in range(len(vertice_list)):
        vertex = vertice_list[index]
        string += formatFloat(vertex[0]) + string_delimeter + formatFloat(vertex[1]) + string_delimeter + formatFloat(vertex[2]) + string_delimeter
        
        if(0 < len(normal_list)):
            normal = normal_list[index]
            string += formatFloat(normal[0]) + string_delimeter + formatFloat(normal[1]) + string_delimeter + formatFloat(normal[2]) + string_delimeter
        #end if
        
        if(0 < len(color_list)):
            color = color_list[index]
            string += formatFloat(color[0]) + string_delimeter + formatFloat(color[1]) + string_delimeter + formatFloat(color[2]) + string_delimeter + formatFloat(color[3]) + string_delimeter
        #end if
        
        for uv_index in range(32):
            if uv_index < len(mesh.uv_layers):
                uv = uv_list[uv_index][index]
                string += formatFloat(uv[0]) + string_delimeter + formatFloat(uv[1]) + string_delimeter
            #end if
        #end for
    #end for

    return string
#end def

def export_mesh(object):
    empty_list = []
    me_ob=object#me_ob = triangulateNMesh(object)
    mat_x90 = mathutils.Matrix.Rotation(math.pi/2, 4, 'X')
    
    mesh = me_ob.to_mesh(bpy.context.scene, False, 'PREVIEW')
    mesh.transform(mat_x90)
    
    indices_list = populateIndicesList(mesh)
    vertice_list = populateVertexList(mesh)
    normal_list = populateNormalList(mesh)
    
    color_list = []
    
    if (len(mesh.vertex_colors) > 0):
        color_list = populateVertexColorsList(mesh, 0)
    #endif
    
    
    uv_list = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [],
               [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]

    uv_image_list = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "",
                     "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]

    for index in range(32):
        if index < len(mesh.uv_layers):
            uv_list[index] = populateUVLayersList(mesh, index)
            uv_image_list[index] = populateUVImageName(mesh, index)
        #end if
    #end for

    half_extends = objectHalfExtends(vertice_list)
    object_transform = objectTranform(me_ob)

    string = export_mesh_string(mesh,
                                indices_list,
                                vertice_list,
                                normal_list,
                                color_list,
                                uv_list,
                                uv_image_list,
                                half_extends,
                                object_transform)

    name = bpy.path.clean_name(object.name)
    outfile = compress_directory + "/" + mesh_dir_name + "/" + name

    writeString(string, outfile.lower())

#end def



def export_curve_string(curve,
                        vertice_list,
                        half_extends,
                        object_transform):
    
    string_delimeter = printDelimeter()
    
    string = ""
    
    string += str(formatInt(len(vertice_list))) + string_delimeter

    half_extends_list = [formatFloat(0.0), formatFloat(0.0), formatFloat(0.0)]
    for index in range(3):
        half_extends_list[index] = formatFloat(half_extends[index])
        string += str(half_extends_list[index]) + string_delimeter
    #end for
    
    world_transform_list = [formatFloat(0.0), formatFloat(0.0), formatFloat(0.0), formatFloat(0.0),
                            formatFloat(0.0), formatFloat(0.0), formatFloat(0.0), formatFloat(0.0),
                            formatFloat(0.0), formatFloat(0.0), formatFloat(0.0), formatFloat(0.0),
                            formatFloat(0.0), formatFloat(0.0), formatFloat(0.0), formatFloat(0.0)]
    for index in range(16):
        world_transform_list[index] = formatFloat(object_transform[index])
        string += str(world_transform_list[index]) + string_delimeter
    #end for
            
    for index in range(len(vertice_list)):
        vertex = vertice_list[index]
        string += formatFloat(vertex[0]) + string_delimeter + formatFloat(vertex[1]) + string_delimeter + formatFloat(vertex[2]) + string_delimeter
    #end for

    return string
#end def



def export_curve(object):
    curve = object
    
    name = bpy.path.clean_name(curve.name)
    
    mat_x90 = mathutils.Matrix.Rotation(math.pi/2, 4, 'X')
    #mat_x90 = mathutils.Matrix.Rotation(math.pi/2, 4, 'X')
    #mat_rot = mat_x90
    
    empty_list = []
    empty_string = "NONE"
    
    for spline in curve.data.splines:
        
        vertices = []
        if len(spline.bezier_points) >= 2:
            r = spline.resolution_u + 1
            segments = len(spline.bezier_points)
            if not spline.use_cyclic_u:
                segments -= 1
            
            for i in range(0, segments):
                inext = (i + 1) % len(spline.bezier_points)
                
                knot1 = spline.bezier_points[i].co
                handle1 = spline.bezier_points[i].handle_right
                handle2 = spline.bezier_points[inext].handle_left
                knot2 = spline.bezier_points[inext].co
                
                points = mathutils.geometry.interpolate_bezier(knot1, handle1, handle2, knot2, r)
                
                for point_index in range(len(points)):
                    vec =  points[point_index] * mat_x90
                    
                    vert = [vec[0],
                            vec[1],
                            vec[2],
                            1.0]
                    vertices.append(vert)
                #end for
            #end for
        #end if
    
    #end for
    
    object_transform = objectTranform(curve)
    half_extends = objectHalfExtends(vertices)

    
    string = export_curve_string(curve,
                                 vertices,
                                 half_extends,
                                 object_transform)

    name = bpy.path.clean_name(curve.name).lower()
    outfile = compress_directory + "/" + curve_dir_name + "/" + name
    
    print("The filename: " + outfile)

    writeString(string, outfile)
#end def





def export_camera(object):
    print("TODO: write export_camera")
#end def

def export_lamp(object):
    print("TODO: write export_lamp")
#end def

def export_surface(material):
    print("TODO: write material")
#end def

def clean_image_filename(image):
    name = bpy.path.clean_name(image.name)
    
    clean_name_replacement = "_png"
    
    if(image.file_format == "PNG"):
        clean_name_replacement = "_png"
    elif(image.file_format == "TIFF"):
        clean_name_replacement = "_tiff"
    elif(image.file_format == "JPG"):
        clean_name_replacement = "_jpg"
    #end if
    
    name = name.lower().replace(clean_name_replacement, "")

    return name
#end def

def export_image(image):
#    name = bpy.path.clean_name(image.name)
#    
#    clean_name_replacement = "_png"
#    
#    if(image.file_format == "PNG"):
#        clean_name_replacement = "_png"
#    elif(image.file_format == "TIFF"):
#        clean_name_replacement = "_tiff"
#    elif(image.file_format == "JPG"):
#        clean_name_replacement = "_jpg"
#    #end if
#    
#    name = name.lower().replace(clean_name_replacement, "")

    name = clean_image_filename(image)

    infile = basedir + image.filepath
    outfile = compress_directory + "/images/" + name + ".pvr"
    previewfile = compress_directory + "/images/" + name + ".png"
    
    system_command = "/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/texturetool -m -f PVR -e PVRTC " + infile + " -o " + outfile

    os.system(system_command) 
#end def

def create_zip( directory, filename ):
    output = zipfile.ZipFile( filename, "w", compression = zipfile.ZIP_DEFLATED )

    for( apath, dir_names, fil_names ) in os.walk( directory ):
        for f in fil_names:
            fpath = os.path.join( apath, f )
            dpath = fpath.replace( directory + "/", "" )
            output.write( fpath, dpath )
    output.printdir()
    output.close()
#end def


def create_lua_collision_response_function(name):
    
    ret = "\n-- Start " + name + " Collision Response Functions -----------------------------------------------\n"
    
    ret += "\
function " + name + "CollisionResponse(currentEntity, otherEntity, point)\n\
\tprint(\"" + name + "CollisionResponse\")\n\
\tlocal cr = currentEntity:getCollisionResponseBehavior()\n\
\tprint(\"collide \" .. currentEntity:getName())\n\
end\n"

    ret += "-- End   " + name + " Collision Response Functions -----------------------------------------------\n"

    return ret;
#end def

def create_lua_enter_state_function(name):
    return "\
function " + name + "EnterState(currentEntity)\n\
\tprint(\"" + name + "EnterState\")\n\
end\n"
#end def

def create_lua_update_state_function(name):
    return "\
function " + name + "UpdateState(currentEntity, deltaTimeStep)\n\
\tprint(\"" + name + "UpdateState\")\n\
end\n"
#end def

def create_lua_exit_state_function(name):
    return "\
function " + name + "ExitState(currentEntity)\n\
\tprint(\"" + name + "ExitState\")\n\
end\n"
#end def

def create_lua_onMessage_function(name):
    return "\
function " + name + "OnMessage(currentEntity, telegram)\n\
\tprint(\"" + name + "OnMessage\")\n\
end\n"
#end def



def create_lua_state_function(name):
    
    ret = "\n-- Start " + name + " State Functions -----------------------------------------------\n"
    
    ret += create_lua_enter_state_function(name) + create_lua_update_state_function(name) + create_lua_exit_state_function(name) + create_lua_onMessage_function(name)
    
    ret += "-- End   " + name + " State Functions -----------------------------------------------\n"
    
    return ret;

#end def















objects = bpy.data.objects
print("There are " + str(len(objects)) + " objects")
for object in objects:
    if (object.type == "MESH"):
        export_mesh(object)
        name = bpy.path.clean_name(object.name).lower()
        name_image = populateUVImageName(object.to_mesh(bpy.context.scene, False, 'PREVIEW'), 0)
        
        
        
        
        clean_name_replacement = "_png"
    
        if("PNG" in name_image.upper()):
            clean_name_replacement = ".png"
        elif("TIFF" in name_image.upper()):
            clean_name_replacement = ".tiff"
        elif("JPG" in name_image.upper()):
            clean_name_replacement = ".jpg"
        #end if
        
        name_image = name_image.lower().replace(clean_name_replacement, "")
        
        lua_object_string += "    self.meshIDs[\"" + name + "\"] = jli.ViewObjectFactory_createViewObject(\"" + name + "\", self.textureIDs[\"" + name_image + "\"]);\n"
        
        lua_collision_response_string += create_lua_collision_response_function(name)
        lua_state_string += create_lua_state_function(name)
    elif(object.type == "CURVE"):
        export_curve(object)
    elif(object.type == "CAMERA"):
        export_camera(object)
    elif(object.type == "LAMP"):
        export_lamp(object)
#end for

materials = bpy.data.materials
print("There are " + str(len(materials)) + " materials")
for material in materials:
    if (material.type == "SURFACE"):
        export_surface(material)
    #endif
#end for


bpy.ops.file.unpack_all(method='WRITE_LOCAL')
images = bpy.data.images
print("There are " + str(len(images)) + " images")
for image in images:
    export_image(image)
    name = clean_image_filename(image)
    lua_image_string += "    self.textureIDs[\"" + name + "\"] = jli.TextureFactory_createTextureFromData(\"" + name + "\")\n"
#end for
bpy.ops.file.pack_all()


print("uncompressing directory: " + compress_directory)
print("compressed directory: " + compress_file)
create_zip(compress_directory, compress_file )

lua_string += lua_image_string
lua_string += "\n"
lua_string += lua_object_string
lua_string += "\n\
    return self\n\
end\n\
\n\
function " + scene_name.upper() + ".getTextureID(self, name)\n\
    return self.textureIDs[name]\n\
end\n\
\n\
function " + scene_name.upper() + ".getMeshID(self, name)\n\
    return self.meshIDs[name]\n\
end\n\
"

lua_string += lua_collision_response_string
lua_string += lua_state_string

write_lua_file()

system_command = "\
cd " + basedir + "\n\
cd ../scenes\n\
"
os.system(system_command)

