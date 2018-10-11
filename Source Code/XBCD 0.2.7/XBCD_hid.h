/*	
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
*/

#include "hidclass.h"

#define HID_USAGE_JOYSTICK 0x04
#define HID_USAGE_GAMEPAD 0x05

typedef struct _HID_DEVICE_EXTENSION {

    PDEVICE_OBJECT  PhysicalDeviceObject;
	PDEVICE_OBJECT  NextDeviceObject;
	PVOID           MiniDeviceExtension;

} HID_DEVICE_EXTENSION, *PHID_DEVICE_EXTENSION;


#define GET_MINIDRIVER_DEVICE_EXTENSION(DO)  \
    ((PDEVICE_EXTENSION) (((PHID_DEVICE_EXTENSION)(DO)->DeviceExtension)->MiniDeviceExtension))

#define GET_LOWER_DEVICE_OBJECT(DO) (((PHID_DEVICE_EXTENSION) ((DO)->DeviceExtension)) \
  ->NextDeviceObject)

#define GET_PHYSICAL_DEVICE_OBJECT(DO) (((PHID_DEVICE_EXTENSION) ((DO)->DeviceExtension)) \
  ->PhysicalDeviceObject)


typedef struct _HID_MINIDRIVER_REGISTRATION {

    ULONG           Revision;
	PDRIVER_OBJECT  DriverObject;
	PUNICODE_STRING RegistryPath;
	ULONG           DeviceExtensionSize;
	BOOLEAN         DevicesArePolled;
    UCHAR           Reserved[3];

} HID_MINIDRIVER_REGISTRATION, *PHID_MINIDRIVER_REGISTRATION;


NTSTATUS HidRegisterMinidriver(IN PHID_MINIDRIVER_REGISTRATION  MinidriverRegistration);


#include <pshpack1.h>
typedef struct _HID_DESCRIPTOR
{
    UCHAR   bLength;
    UCHAR   bDescriptorType;
    USHORT  bcdHID;
    UCHAR   bCountry;
    UCHAR   bNumDescriptors;

	// This is an array of one OR MORE descriptors.
   
    struct _HID_DESCRIPTOR_DESC_LIST
	{
       UCHAR   bReportType;
       USHORT  wReportLength;
    } DescriptorList [1];

} HID_DESCRIPTOR, * PHID_DESCRIPTOR;
#include <poppack.h>


typedef struct _HID_DEVICE_ATTRIBUTES {

    ULONG           Size;
    USHORT          VendorID;
    USHORT          ProductID;
    USHORT          VersionNumber;
    USHORT          Reserved[11];

} HID_DEVICE_ATTRIBUTES, * PHID_DEVICE_ATTRIBUTES;


#define IOCTL_HID_GET_DEVICE_DESCRIPTOR     HID_CTL_CODE(0)
#define IOCTL_HID_GET_REPORT_DESCRIPTOR     HID_CTL_CODE(1)
#define IOCTL_HID_READ_REPORT               HID_CTL_CODE(2)
#define IOCTL_HID_WRITE_REPORT              HID_CTL_CODE(3)
//#define IOCTL_HID_GET_STRING                HID_CTL_CODE(4)
//#define IOCTL_HID_ACTIVATE_DEVICE           HID_CTL_CODE(7)
//#define IOCTL_HID_DEACTIVATE_DEVICE         HID_CTL_CODE(8)
#define IOCTL_HID_GET_DEVICE_ATTRIBUTES     HID_CTL_CODE(9)

#define HID_HID_DESCRIPTOR_TYPE             0x21
#define HID_REPORT_DESCRIPTOR_TYPE          0x22
