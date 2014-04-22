import bpy
import array
import sys
import math
import os
import mathutils
from json import dumps, load
from collections import namedtuple

#from euclid import *

def writeString(file, string):
    file.write(bytes(string, 'UTF-8'))
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


def distance( v1, v2 ):
    v = []
    
    v.append( v1[0] - v2[0] )
    v.append( v1[1] - v2[1] )
    v.append( v1[2] - v2[2] )
    
    return math.sqrt( ( v[0] * v[0] ) + ( v[1] * v[1] ) + ( v[2] * v[2] ) )
#end def

def max( n1, n2 ):
    if n1 > n2:
        return n1
    return n2
#end def

def min( n1, n2 ):
    if n1 < n2:
        return n1
    return n2
#end def

def buildHalfExtends(vertex_list):
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

def populateUVImageName(object, uv_layer_index):
    path_raw   = object.uv_textures[uv_layer_index].data[0].image.filepath_raw

    path_split = path_raw.split('/')

    return path_split[len(path_split) - 1];

#end def

#it is assummed that the values in the indice_list are in sequential order
#and have a 1 to 1 correspondece with the values in the vertice_list
def removeDuplicateVerticesAndFixIndices(indices_list,
                                         vertice_list,
                                         normal_list,
                                         color_list,
                                         uv0_list,
                                         uv1_list):
#    indices_list = indices_list[:]
#    vertice_list = vertice_list[:]
#    normal_list = normal_list[:]
#    color_list = color_list[:]
#    uv0_list = uv0_list[:]
#    uv1_list = uv1_list[:]
    
    #the lists have to be equal length to fulfill the assumption
    if(len(vertice_list) == len(indices_list)):
        #cycle through all of the indices in indices_list
        for index1 in range(len(indices_list)):
            #remember the indice being compared with
            indice = indices_list[index1]
            
            #cycle through all of the indices in the indices_list
            for index2 in range(len(indices_list)):
                #remember the indice being compared to
                indice_compare = indices_list[index2]

                #if the indices are not the same and the values stored at the two different indices are equal
                if((indice_compare != indice) and (vertice_list[indice_compare] == vertice_list[indice])):
                    #set the indice at indice_compare in the indices_list to the indice being compared with
                    indices_list[indice_compare] = indice
                    #set the value stored at this position in the vertice_list to be empty
#vertice_list[indice_compare] = []
                #end if
            #end for
        #end for

        #we removed the duplicates in the vertice_list and the indices_list reflects this fact.
        #We must now clean up the vertice_list by removing the empty lists and adjusting the indices_list to reflect this

#        for i in range(len(vertice_list) - 1, 0, -1):
#            if vertice_list[i] == []:
#                vertice_list.pop(i)
#                
#                if normal_list:
#                    normal_list.pop(i)
#                if color_list:
#                    color_list.pop(i)
#                if uv0_list:
#                    uv0_list.pop(i)
#                if uv1_list:
#                    uv1_list.pop(i)
#
#                current_indice = i
#                
#                for j in range(len(indices_list)):
#                    if indices_list[j] >= current_indice:
#                        indices_list[j] =  indices_list[j] - 1
#                    #end if
#                #end for
#            #end if
#        #end for
    #end if

#    return [indices_list,
#            vertice_list,
#            normal_list,
#            color_list,
#            uv0_list,
#            uv1_list]
#end def










#private void drawCasteljau(List<point> points) {
#    Point tmp;
#    for (double t = 0; t <= 1; t += 0.001) {
#        tmp = getCasteljauPoint(points.Count-1, 0, t);
#        image.SetPixel(tmp.X, tmp.Y, color);
#}
#}
#
#
#private Point getCasteljauPoint(int r, int i, double t) {
#    if(r == 0) return points[i];
#    
#    Point p1 = getCasteljauPoint(r - 1, i, t);
#    Point p2 = getCasteljauPoint(r - 1, i + 1, t);
#    
#    return new Point((int) ((1 - t) * p1.X + t * p2.X), (int) ((1 - t) * p1.Y + t * p2.Y));
#}
#    
#
#
#function deCasteljau(i,j)
#begin
#    if i = 0 then
#        return P0,j
#    else
#        return (1-u)* deCasteljau(i-1,j) + u* deCasteljau(i-1,j+1)
#end



def deCasteljau(r, i, t, control_points):
    print("i == " + str(r) + ", j == " + str(i) + ", t == " + str(t))
    
    if r == 0:
        return control_points[i]
    
    vec1 = deCasteljau(r - 1, i + 0, t, control_points)
    vec2 = deCasteljau(r - 1, i + 1, t, control_points)

    
    return [((1.0 - t) * vec1[0] + t * vec2[0]),
            ((1.0 - t) * vec1[1] + t * vec2[1]),
            ((1.0 - t) * vec1[2] + t * vec2[2]),
            1.0]
#end def

def calculateBezierPointList(t, control_points):
    return deCasteljau(len(control_points) - 1, 0, t, control_points)
#end def

def calculateBezierPoint4(t, p0, p1, p2, p3):
    u =   (1.0 - t);
    tt =  (t * t);
    uu =  (u * u);
    uuu = (u * u * u);
    ttt = (t * t * t);
    
    p = [0.0, 0.0, 0.0, 1.0]
    
    p[0] += uuu * p0[0]
    p[1] += uuu * p0[1]
    p[2] += uuu * p0[2]
    
    p[0] += 3.0 * uu * t * p1[0]
    p[1] += 3.0 * uu * t * p1[1]
    p[2] += 3.0 * uu * t * p1[2]
    
    p[0] += 3.0 * u * tt * p2[0]
    p[1] += 3.0 * u * tt * p2[1]
    p[2] += 3.0 * u * tt * p2[2]
    
    p[0] += ttt * p3[0]
    p[1] += ttt * p3[1]
    p[2] += ttt * p3[2]
    
    return p;
#end def

def get_combined_length(p_list):
    edge_length = 0
    for idx in range(len(p_list)-1):
        edge_length += (p_list[idx] - p_list[idx+1]).length
    
    return edge_length
#end def








def exportCurve(curve):
    mat_x90 = mathutils.Matrix.Rotation(math.pi/2, 4, 'X')
    empty_list = []
    empty_string = "NONE"
    
    
    
    for spline in curve.data.splines:
        control_points = []
        
        for index in range(len(spline.bezier_points)):
            vec = spline.bezier_points[index].handle_right * mat_x90
            
            verts = [vec[0],
					 vec[1],
					 vec[2],
                     1.0]
            control_points.append(verts)
            
            vec = spline.bezier_points[index].handle_left * mat_x90
            verts = [vec[0],
					 vec[1],
					 vec[2],
                     1.0]
            control_points.append(verts)
        #end for
        
        vertices = []
        if len(spline.bezier_points) >= 2:
            r = spline.resolution_u + 1
            segments = len(spline.bezier_points)
            if not spline.use_cyclic_u:
                segments -= 1
            
            for i in range(0, segments):
                inext = (i + 1) % len(spline.bezier_points)
                
                knot1 = spline.bezier_points[i].co * mat_x90
                handle1 = spline.bezier_points[i].handle_right * mat_x90
                handle2 = spline.bezier_points[inext].handle_left * mat_x90
                knot2 = spline.bezier_points[inext].co * mat_x90
                
                points = mathutils.geometry.interpolate_bezier(knot1, handle1, handle2, knot2, r)
    
                for point_index in range(len(points)):
                    vec = points[point_index]
                    
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
    half_extends = buildHalfExtends(control_points)
    
    
    json_data = {'object_type':curve.type.lower(),
                 'object_name':curve.name.lower(),
                 'half_extends':half_extends,
                 'world_transform':object_transform,
                 'vertice_list':vertices,
                 'normal_list':empty_list,
                 'color_list':empty_list,
                 'uv0_list':empty_list,
                 'uv1_list':empty_list,
                 'uv0_image':empty_string,
                 'uv1_image':empty_string,
                 'indices_list':empty_list,
                 'control_points':control_points}
    return json_data
#end if

def exportObject(o):
    empty_list = []
    me_ob = triangulateNMesh(o)
    mat_x90 = mathutils.Matrix.Rotation(math.pi/2, 4, 'X')
    
    mesh = me_ob.to_mesh(bpy.context.scene, False, 'PREVIEW')
    mesh.transform(mat_x90)
    #mesh.transform(mat_z90)
    
    num_vertex_colors = len(mesh.vertex_colors)
    num_uv_layers = len(mesh.uv_layers)
    
    indices_list = populateIndicesList(mesh)
    vertice_list = populateVertexList(mesh)
    normal_list = populateNormalList(mesh)
    
    color_list = []
    
    if num_vertex_colors > 0:
        color_list = populateVertexColorsList(mesh, 0)
    #endif
    
    uv0_image = ""
    uv0_list = []
    uv1_image = ""
    uv1_list = []
    
    if num_uv_layers > 0:
        uv0_list = populateUVLayersList(mesh, 0)
        uv0_image = populateUVImageName(mesh, 0)
    #end if
    
    if num_uv_layers > 1:
        uv1_list = populateUVLayersList(mesh, 1)
        uv1_image = populateUVImageName(mesh, 1)
    #end if

    half_extends = buildHalfExtends(vertice_list)
    object_transform = objectTranform(o)
    
    object_name = o.name.capitalize()

#removeDuplicateVerticesAndFixIndices(indices_list, vertice_list, normal_list, color_list, uv0_list, uv1_list)

    
    json_data = {'object_type':o.type.lower(),
                 'object_name':object_name.lower(),
                 'half_extends':half_extends,
                 'world_transform':object_transform,
                 'vertice_list':vertice_list,
                 'normal_list':normal_list,
                 'color_list':color_list,
                 'uv0_list':uv0_list,
                 'uv1_list':uv1_list,
                 'uv0_image':uv0_image,
                 'uv1_image':uv1_image,
                 'indices_list':indices_list,
                 'control_points':empty_list}
    return json_data
#end def

















json_list = []

# export to blend file location
basedir = os.path.dirname(bpy.data.filepath)

if not basedir:
    raise Exception("Blend file is not saved")

selection = bpy.context.selected_objects

bpy.ops.object.select_all(action='DESELECT')

view_object_name_list = []


for obj in selection:
    
    obj.select = True
    
    name = bpy.path.clean_name(obj.name)
    fn = os.path.join(basedir, name)
    
    if (obj.type == "MESH"):
        json_data = exportObject(obj)
    elif(obj.type == "CURVE"):
        json_data = exportCurve(obj)
    #end if
    
    json_list.append(json_data)
    view_object_name_list.append(name.lower())

    obj.select = False

json_data = {'object_name_list':view_object_name_list}
json_list.append(json_data)

json_string = dumps([bpy.context.scene.name, json_list], indent=4)
json_filename = basedir + "/" + bpy.context.scene.name + "ViewObjects.json"
with open(json_filename, "w") as file:
    file.write(json_string)
file.close()

for obj in selection:
    obj.select = True







#enumFilePath = basedir + "/" + bpy.context.scene.name.capitalize() + "ViewObjectTypes.h"
#enumFile = open(enumFilePath, 'wb')
#
#enumData = "\n\
##ifndef GameAsteroids_"+bpy.context.scene.name.capitalize()+"ViewObjectTypes_h\n\
##define GameAsteroids_"+bpy.context.scene.name.capitalize()+"ViewObjectTypes_h\n\
#enum ViewObjectType\n\
#{\n\
#\tViewObjectType_NONE,\n\t\
#"
#
#enumLine = ""
#for object_name in view_object_name_list:
#    enumLine = "%s" % (object_name)
#    enumLine = ''.join(e for e in enumLine if e.isalnum())
#    
#    enumLine = ("ViewObjectType_%s,\n\t" % (enumLine))
#    
#    enumData += enumLine
##end for
##end for
#
#
#enumData += "ViewObjectType_MAX\n\
#};\n\
#\n\
#\n\
#struct ViewObjectStruct\n\
#{\n\
#\tViewObjectType type;\n\
#\tconst char *object_name;\n\
#};\n\
#\n\
#ViewObjectStruct g_ViewObjectStructData[] =\n\
#{\n\
#\t{ViewObjectType_NONE, \"Invalid\"},\n\
#"
#
#font_name_fixed = ""
#for object_name in view_object_name_list:
#    object_name_fixed = ''.join(e for e in object_name if e.isalnum())
#    
#    enumValue = "ViewObjectType_%s" % (object_name_fixed)
#    
#    enumData += "   {%s, \"%s\"},\n" % (enumValue, object_name_fixed)
##end for
##end for
#
##    enumData += "    {TextViewObjectType_Helvetica_8pt, \"Helvetica\", 8}\n
#enumData += "};\n\
#\n\
#\n\
##endif\n\
#"
#
#writeString(enumFile, enumData)
#
#print("written:", enumFilePath)
#enumFile.flush()
#enumFile.close()



##Animation code snippet...
#KeyframeCount = bpy.context.scene.frame_end - bpy.context.scene.frame_start + 1
#
#for Object in Config.ObjectList:
#    for Frame in range(0, KeyframeCount):
#        bpy.context.scene.frame_set(Frame + bpy.context.scene.frame_start)
#        #get the current object position, rotation, scale, armature etc.. at the current framekey position process to store in your format