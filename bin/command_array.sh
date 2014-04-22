echo on
for var in "$@"
do
	FILENAME=${var%%.png}
	FIXEDFILENAME="$FILENAME".pvr
	echo "$FIXEDFILENAME"
	/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin/texturetool -m -f PVR -e PVRTC "$var" -o "$FIXEDFILENAME"
done