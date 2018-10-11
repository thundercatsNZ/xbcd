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
All Digital Buttons Version 1.07
================================
Windows 98/2000/XP

Exports ~32 controls to Windows:

 	- Up to 24 digital buttons.
 	- 7 axes(X, Y, Z, RZ, Slider, RX, RY) in Windows 2000/XP.
   	  6 axes(X, Y, Z, RZ, Slider, RX) in 98/ME.
 	- POV hat switch with 8 directions

Controller buttons, axes, and the digital pad can be mapped to any of the
controls exported to Windows.

Supports up to 8 different configurations.
The active configuration can be selected by pressing both Analog Sticks simultaneously.

Controller can be reported to Windows as a gamepad or a joystick.

Threshold settings for Buttons, Triggers, and Axes.

Deadzone settings for Analog Sticks.

Scaling of axes for sensitivity.

Configuration of buttons and axes supported through Game Controllers in Control Panel for XP
and XBCD Setup in Control Panel for 98/2000.

Gamepad settings can be saved to a file for later use.

Rumble support.  Adjustable maximum force for each actuator.


-------------------
Source Code
-------------------

RemoveLock.c 	- Functions which replace missing removelock functions in Win98.
resource.h 	- Needed for driver binary properties.
SemiAxis.h	- Definition of semi-axes for controls
sources 	- Lists Files to include for compiling and linking.
XBCD.inf	- Installation file.
XBCD.rc 	- Contains properties for driver binary (Version, Company, etc.).
XBCD_control.c 	- Takes care of IOCTL's received.
XBCD_driver.c 	- Main parts of the driver.
XBCD_driver.h 	- Definitions of functions and some structs.
XBCD_hid.h 	- Definitions of constants and macros related to the HID interface.
XBCD_report.c 	- Definition of report descriptor.
XBCD_usb.c 	- USB interface work.


If building with Windows 98 DDK:
	Set WIN98 = 1 in XBCD_driver.h
	Set DBG in XBCD_driver.h to 1 for debug build or 0 for release build


---------------------------
Redcl0ud
http://phaseone.sytes.net