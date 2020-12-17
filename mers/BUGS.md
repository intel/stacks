# Known Issues

## MeRS `v0.3.0`

* No Known Issues

## MeRS `v0.2.0`

vaapi sink:

* Vaapisink is causing SIGSEGV when vaapi transcode required through this sink, i.e. gst-launch-1.0 filesrc location=relax.jpg ! jpegparse ! vaapijpegdec ! imagefreeze ! vaapisink 

  The fix is at [libva 2.7.0](https://github.com/intel/libva/releases/tag/2.7.0) available at the release moment of MeRS v0.2.0 series hence, this component bump will be included in the next release.

gst-vaapi:

* The gst-vaapi*dec elements crash when fake-sinking on headless enviroments, i.e. vaapih264dec ! fakesink.

  The patch is available at release moment of this version hence, this fix will be included in the next minor release. The workaround is to
	use the vaapisink element. Issue is being tracked upstream at https://gitlab.freedesktop.org/gstreamer/gstreamer-vaapi/-/issues/247

## MeRS `v0.1.0`

