NOTE: When compiling for 64-bit Windows with these drivers, the "Full Range" option
does not work.  It is because I didn't bother coming up with a method to add that
option.

------------------------------------

Files updated from 0.2.5:

XBCD_control.c	(all integer math stuff)
XBCD.rc		(use "winres" instead of "stdafx", and changed the version)

------------------------------------

To build, start either of these build environments:

Windows Server 2003 Free x64 Build Environment
Windows Vista and Windows Server Longhorn x64 Free Build Environment

The Windows Server 2003 build environment is used to build drivers for Windows
XP Pro x64, since XP Pro x64 runs off of the Windows 2003 kernel.

To compile the driver, browse to the directory the source is in and type:
build -amd64

Also, make sure you copy hidclass.lib and usbd.lib to the directory your source
files are under.  Windows Vista uses files from the "wlh" directory in the Windows
DDL, while XP x64 uses "wnet".
