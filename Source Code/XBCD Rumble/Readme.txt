    Copyright 2005 Helder Acevedo

    This file is part of XBCD.

    XBCD is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    XBCD is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with XBCD; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

XBCD - XBox Controller Driver
================================
XBCDR - Rumble DLL version 0.80
================================
Windows 98/2000/XP

To test a force feedback device, get the Fedit utility
from the DirectX SDK.

Project files for Visual C++ 6, 8, and Dev-Cpp are included.

For more information about Force Feedback drivers,
see the ffdrv sample in the Windows DDK.  This driver
is based on that code.


clsfact.cpp	- OLE Class Factory
effdrv.cpp	- Contains the functions that are called by DirectInput
effdrv.h	- Global variables and functions for the driver
hwint.cpp	- Contains the functions for sending data to the device
main.cpp	- Startup and shutdown functions of the dll
rdevice.cpp	- Contains the rumble device class
DevCpp\XBCDR.def	- List of exported functions
DevCpp\XBCDR.dev	- Dev-Cpp Project file
MSVC6\XBCDR.def		- List of exported functions
MSVC6\XBCDR.dsp		- Visual C++ 6.0 Project file
MSVC6\XBCDR.dsw		- Visual C++ 6.0 Workspace file
MSVC6\XBCDR.rc		- Resource file for version information
MSVC71\XBCDR.def	- List of exported functions
MSVC71\XBCDR.rc		- Resource file for version information
MSVC71\XBCDR.sln	- Visual Studio 7.10 solution file
MSVC71\XBCDR.vcproj	- Visual C++ 7.10 project file



---------------------------
Redcl0ud
http://phaseone.sytes.net