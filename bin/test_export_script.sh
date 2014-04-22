#!/bin/bash

cd ~/
Dropbox/DEV/Libraries/Blender/blender.app/Contents/MacOS/blender Dropbox/DEV/Libraries/iOSGames/BaseProject/assets/blender/Asteroids.blend --background --python Dropbox/DEV/Libraries/JLIEngine/bin/python/export_view_objects.py

Dropbox/DEV/Libraries/Blender/blender.app/Contents/MacOS/blender Dropbox/DEV/Libraries/JLIEngine/assets/blender/BaseScene.blend --background --python Dropbox/DEV/Libraries/JLIEngine/bin/python/export_view_objects.py
