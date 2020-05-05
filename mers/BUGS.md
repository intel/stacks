# Known Bugs 

## MeRS `v0.2.0`

gst-vaapi:

* The gst-vaapi*dec elements crash when fake-sinking on headless enviroments, i.e. vaapih264dec ! fakesink.

  The patch is available at release moment of this version hence, this fix will be included in the next minor release. The workaround is to
	use the vaapisink element. Issue is being tracked upstream at https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi/-/issues/247

## MeRS `v0.1.0`

