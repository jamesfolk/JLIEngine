#!/bin/sh

#  jli_engine_swig.sh
#  MazeADay
#
#  Created by James Folk on 1/28/14.
#  Copyright (c) 2014 JFArmy. All rights reserved.
#

#-w325 Warning 325: Nested struct not currently supported
#-w312 Warning 312: Nested union not currently supported
#-w201 Warning 201: Unable to find
#-w402 Warning 402: Base class is incomplete.
#-w402 Warning 402: Only forward declaration was found.
#-w401 Warning 401: Nothing known about base class . Ignored.
#-w401 Warning 401: Maybe you forgot to instantiate using %template.
#-w451 Warning 451: Setting a const char * variable may leak memory.

swig -c++ -lua -includeall -I"/Users/jamesfolk/Dropbox/DEV/Libraries/JLIEngine/src" -I"/Users/jamesfolk/Dropbox/DEV/Libraries/bullet-2.81/src" -I"/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS7.0.sdk/System/Library/Frameworks/OpenGLES.framework/Headers" -features directors,autodoc=1 -ignoremissing -w325 -w312 -w201  -w451 -debug-csymbols -debug-module 4 -DBT_SDK -DBT_SWIG -DBT_NO_NAMESPACE -o /Users/jamesfolk/Dropbox/DEV/Libraries/JLIEngine/src/control/lua/jli_engine_swig.h /Users/jamesfolk/Dropbox/DEV/Libraries/JLIEngine/src/control/lua/interfaces/jli_engine.i > ./log/jli_engine_swig.log
