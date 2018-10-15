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

#include <wdm.h>
#include "XBCD_hid.h"

#include "SemiAxis.h"

#define PAGEDCODE code_seg("PAGE")
#define LOCKEDCODE code_seg()

#ifndef DBG
#define DBG 0
#endif
#define WIN98 0

#define VER_MAJOR 1
#define VER_MINOR 0
#define VER_RELEASE 8

#define MAX_INTERFACES 4	// the maximum number of interfaces we expect a supported gamepad to have

#if WIN98
	#include <usbioctl.h>
	#include <usbdi.h>
	#include <usbdlib.h>

	static const GUID GUID_DEVINTERFACE_USB_DEVICE = {0xA5DCBF10L, 0x6530, 0x11D2, 0x90, 0x1F, 0x00, 0xC0, 0x4F, 0xB9, 0x51, 0xED};

	typedef struct _IO_REMOVE_LOCK_TRACKING_BLOCK * PIO_REMOVE_LOCK_TRACKING_BLOCK;

	typedef struct _IO_REMOVE_LOCK_COMMON_BLOCK {
		BOOLEAN     Removed;
		BOOLEAN     Reserved [3];
		LONG        IoCount;
		KEVENT      RemoveEvent;

	} IO_REMOVE_LOCK_COMMON_BLOCK;

	typedef struct _IO_REMOVE_LOCK_DBG_BLOCK {
		LONG        Signature;
		LONG        HighWatermark;
		LONGLONG    MaxLockedTicks;
		LONG        AllocateTag;
		LIST_ENTRY  LockList;
		KSPIN_LOCK  Spin;
		LONG        LowMemoryCount;
		ULONG       Reserved1[4];
		PVOID       Reserved2;
		PIO_REMOVE_LOCK_TRACKING_BLOCK Blocks;
	} IO_REMOVE_LOCK_DBG_BLOCK;

	typedef struct _IO_REMOVE_LOCK {
		IO_REMOVE_LOCK_COMMON_BLOCK Common;
	#if DBG
		IO_REMOVE_LOCK_DBG_BLOCK Dbg;
	#endif
	} IO_REMOVE_LOCK, *PIO_REMOVE_LOCK;

	#define InitializeRemoveLock(lock, tag, minutes, maxcount) IntInitializeRemoveLock(lock, tag, minutes, maxcount)
	#define AcquireRemoveLock(lock, tag) IntAcquireRemoveLock(lock, tag)
	#define ReleaseRemoveLock(lock, tag) IntReleaseRemoveLock(lock, tag)
	#define ReleaseRemoveLockAndWait(lock, tag) IntReleaseRemoveLockAndWait(lock, tag)
#else
	#include <usbdrivr.h>
	#define InitializeRemoveLock(Lock, Tag, Maxmin, HighWater) IoInitializeRemoveLock(Lock, Tag, Maxmin, HighWater)
	#define AcquireRemoveLock(RemoveLock, Tag) IoAcquireRemoveLock(RemoveLock, Tag)
	#define ReleaseRemoveLock(RemoveLock, Tag) IoReleaseRemoveLock(RemoveLock, Tag)
	#define ReleaseRemoveLockAndWait(RemoveLock, Tag) IoReleaseRemoveLockAndWait(RemoveLock, Tag)
	static const GUID GUID_DEVINTERFACE_USB_DEVICE = {0xA5DCBF10L, 0x6530, 0x11D2, 0x90, 0x1F, 0x00, 0xC0, 0x4F, 0xB9, 0x51, 0xED};
#endif

//#define WIN32NAME  L"\\DosDevices\\XBCD"
//#define DEVICENAME L"\\Device\\XBCD"

/*****************************************************************************/
//UNICODE_STRING RegistryPath;

// A value used to perform more precise calculations without the use of floating-point math
#define MAX_VALUE 35000

// The absolute maximum number of button/axis layouts
#define MAX_NR_LAYOUTS 8

// The size of a MapMatrix array (=NR_OUT_BUTTONS+2*NR_OUT_AXES+NR_OUT_POVS)
#define MAP_MATRIX_SIZE 24

// Defines for the output buffer length and data locations
#define OUT_BUFFER_LEN 40

// The number of buttons on the output (i.e. Windows) side
#define NR_OUT_BUTTONS 24

// The number of POV directions (!) on the output (i.e. Windows) side
#define NR_OUT_POVS 4

// Output scale factor for axes
#define OUT_AXIS_SCALE 32767

// Index of the POV in output buffer
#define OUT_POV1_INDEX 18

// The number of semiaxes, the standard XBox gamepad has 24 semiaxes
#define NR_SEMIAXES 25

#define NR_WINCONTROLS 42

// The number of axes on the output (i.e. Windows) side
#define NR_OUT_AXES 7

#define XBCD_SIGNATURE 0x58425355l //(XBSU)

#define FEATURE_CODE_SET_CONFIG		3
#define FEATURE_CODE_GET_VERSION	4
#define FEATURE_CODE_GET_IS360		5

/*******************************************************************************/
#include <PSHPACK1.H>

typedef struct _FEATURE_GET_VERSION
{
	UCHAR id;			//Report ID
	ULONG Signature;	//Should be XBCD_SIGNATURE when data is received
	UCHAR Major;
	UCHAR Minor;
	UCHAR Release;
} FEATURE_GET_VERSION, *PFEATURE_GET_VERSION;

typedef struct _FEATURE_SET_CONFIG
{
	UCHAR id;			//Report ID
	ULONG Signature;	//Should be XBCD_SIGNATURE when data is received
} FEATURE_SET_CONFIG, *PFEATURE_SET_CONFIG;

typedef struct _FEATURE_GET_IS360
{
	UCHAR id;			//Report ID
	ULONG Signature;	//Should be XBCD_SIGNATURE when data is received
	UCHAR is360;		//Nonzero if controller is Xbox 360
} FEATURE_GET_IS360, *PFEATURE_GET_IS360;

#include <POPPACK.H>
/*******************************************************************************/

typedef struct _READ_INFO
{
	PIRP pIrp;
	PURB pUrb;
} READ_INFO, *PREAD_INFO;

typedef struct _WRITE_INFO
{
	PIRP pIrp;
	PURB pUrb;
} WRITE_INFO, *PWRITE_INFO;

/* The minidriver-specific portion of the device extension.
This will be referenced by the 'PVOID MiniDeviceExtension' pointer from
the 'HID_DEVICE_EXTENSION' structure.
A pointer to a so-called 'functional device object' is passed to most
functions (PDEVICE_OBJECT pFdo). The pointer to this DEVICE_EXTENSION
structure can be extracted from it with the
'GET_MINIDRIVER_DEVICE_EXTENSION(pFdo)' macro.

Apparently a variable of this structure type is never directly instantiated
(...inside this driver code). Instead, only the size is given, when
registering the minidriver:
  hidMinidriverRegistration.DeviceExtensionSize=sizeof(DEVICE_EXTENSION);
With that information, according to the DDK documentation, (nonpaged) memory
is allocated sometime by the system's IO manager (using 'IoCreateDevice') and
the pointer is stored in the FDO.
When accessing that memory through the above mentioned macro, it will be cast
to a pointer of the right type (i.e. '*PDEVICE_EXTENSION'), so all data can
be accessed 'by name'.

In here is all kind of data used for XBCD. This kind of makes storing and
passing data around different functions easier. */

typedef struct _DEVICE_EXTENSION{
	PDEVICE_OBJECT pFdo;
	PDEVICE_OBJECT pLowerPdo;
	PDEVICE_OBJECT pPdo;
	BOOLEAN DeviceStarted;

	// Overall number of layouts
	unsigned int NrOfLayouts;

	// The number of the currently selected layout (zero-based)
	unsigned int LayoutNr;

	// The current mapping matrix
	unsigned int MapMatrix[8][MAP_MATRIX_SIZE];

	// Semiaxis array.
	GamepadSemiAxis SemiAxes[NR_SEMIAXES];

	// Xbox 360 pad or not
	BOOLEAN is360;

	// LED display (360 only). See http://www.free60.org/wiki/Gamepad for values
	UCHAR LedSetting;

	/* This is set to true, when both analog sticks are pressed to cycle layouts,
	and set to false, once both sticks are released again. Thus it assures
	switching only to the next layout and avoids cycling wildly, whenever the
	driver is entered.*/

	BOOLEAN LayoutSwitch;

	LONG RequestCount;
	BOOLEAN DeviceRemoved;
	BOOLEAN SurpriseRemoved;
	KEVENT RemoveEvent;
	BOOLEAN PowerDown;
	USB_DEVICE_DESCRIPTOR dd;
	USBD_CONFIGURATION_HANDLE hconfig;
	USBD_PIPE_HANDLE hInPipe;
	USBD_PIPE_HANDLE hOutPipe;
	PUSB_CONFIGURATION_DESCRIPTOR pcd;
	BOOLEAN bHasMotors;
	READ_INFO ReadInfo;
	WRITE_INFO WriteInfo;

	BOOLEAN isWin9x;

	/* These 20 bytes are the data that comes from the controller.
	Description, see "Inside Xbox Controller" and http://www.free60.org/wiki/Gamepad */
	UCHAR hwInData[20];

	/* These 20 bytes contain the data that goes to the contoller.
	Description, see "Inside Xbox Controller" and http://www.free60.org/wiki/Gamepad */
	UCHAR hwOutData[20];

	// Last message from light being set OK.
	UCHAR LightStatus;

	// Force feedback / rumble actuator proportional factors
	UCHAR LaFactor;
	UCHAR RaFactor;

	LONG TThreshold;
	LONG BThreshold;
	LONG AThreshold;

	LONG LStickDZ;
	LONG RStickDZ;

	LONG AxesScale[NR_OUT_AXES];

	BOOLEAN bFullRange[2]; //Extend the range of the analog sticks. 0-Left, 1-Right

	UCHAR nButtons;

	UCHAR AxesOn;

	UCHAR DevUsage; //Used to select Gamepad or Joystick usage

	//Used for the Thrustmaster Modena 360 Steering Wheel
	BOOLEAN isWheel;

	BOOLEAN bReadPending;
	BOOLEAN bWritePending;
	KSPIN_LOCK ReadLock;
	KSPIN_LOCK WriteLock;
	IO_REMOVE_LOCK RemoveLock;
	KDPC timeDPC;
	KTIMER timer;
	BOOLEAN timerEnabled;
} DEVICE_EXTENSION, *PDEVICE_EXTENSION;

//XBCD_driver.c

NTSTATUS DriverEntry(IN PDRIVER_OBJECT pDriverObject, IN PUNICODE_STRING pRegistryPath);
NTSTATUS XBCDCreate(IN PDEVICE_OBJECT pFdo, IN PIRP Irp);
NTSTATUS XBCDClose(IN PDEVICE_OBJECT pFdo, IN PIRP Irp);
VOID XBCDUnload(IN PDRIVER_OBJECT pDriverObject);
VOID XBCDRemoveDevice(PDEVICE_OBJECT pFdo, PIRP pIrp);
VOID XBCDStopDevice(PDEVICE_OBJECT pFdo, PIRP pIrp);
NTSTATUS XBCDPnPComplete(PDEVICE_OBJECT pFdo, PIRP pIrp, PVOID Context);
NTSTATUS XBCDPowerOn360(PDEVICE_OBJECT pFdo, PIRP pIrp, PVOID Context);
NTSTATUS XBCDIncRequestCount(PDEVICE_EXTENSION pDevExt);
VOID XBCDDecRequestCount(PDEVICE_EXTENSION pDevExt);
NTSTATUS XBCDDispatchPnp(IN PDEVICE_OBJECT pFdo, IN PIRP pIrp);
NTSTATUS XBCDDispatchPower(IN PDEVICE_OBJECT pFdo, IN PIRP pIrp);
NTSTATUS XBCDAddDevice(IN PDRIVER_OBJECT pDriverObject, IN PDEVICE_OBJECT pFdo);
NTSTATUS XBCDStartDevice(PDEVICE_OBJECT pFdo, PIRP pIrp);
NTSTATUS XBCDUpdate360Leds(PDEVICE_EXTENSION pDevExt);
void setDefaultMapMatrix(unsigned int* pMapMatrix, BOOLEAN bWin9x, BOOLEAN is360);
void setDefaultThresholds(GamepadSemiAxis* pSemiAxes);
int ReadRegistry(HANDLE hKey, PCWSTR entry, PUCHAR Values, unsigned int BufSize);
void XBCDReadConfig(IN PDEVICE_OBJECT pFdo);

//XBCD_control.c

NTSTATUS XBCDDispatchIntDevice(IN PDEVICE_OBJECT pFdo, IN PIRP pIrp);
NTSTATUS XBCDDispatchDevice(IN PDEVICE_OBJECT pFdo, IN PIRP pIrp);
NTSTATUS XBCDDispatchSystem(IN PDEVICE_OBJECT pFdo, IN PIRP pIrp);
NTSTATUS XBCDReadData(PDEVICE_OBJECT pFdo, PIRP pIrp);
VOID timerDPCProc(IN PKDPC Dpc, IN PVOID DeferredContext, IN PVOID SystemArgument1, IN PVOID SystemArgument2);

//XBCD_report.c
USHORT GetRepDesc(PDEVICE_EXTENSION pDevExt, PUCHAR Buffer);

//XBCD_usb.c

NTSTATUS SendAwaitUrb(PDEVICE_OBJECT pFdo, PURB pUrb);
NTSTATUS CreateInterruptUrb(PDEVICE_OBJECT pFdo);
VOID DeleteInterruptUrb(PDEVICE_OBJECT pFdo);
NTSTATUS DeviceRead(PDEVICE_EXTENSION pDevExt);
NTSTATUS DeviceWrite(PDEVICE_EXTENSION pDevExt, ULONG size/*, PIRP pIrp*/);
NTSTATUS ReadCompletion(PDEVICE_OBJECT junk, PIRP pIrp, PVOID Context);
NTSTATUS WriteCompletion(PDEVICE_OBJECT junk, PIRP pIrp, PVOID Context);
VOID StopInterruptUrb(PDEVICE_EXTENSION pDevExt);
//NTSTATUS ResetPipe(IN PDEVICE_OBJECT DeviceObject, IN USBD_PIPE_HANDLE *PipeHandle);

//RemoveLock.c

VOID IntInitializeRemoveLock(PIO_REMOVE_LOCK lock, ULONG tag, ULONG minutes, ULONG maxcount);
NTSTATUS IntAcquireRemoveLock(PIO_REMOVE_LOCK lock, PVOID tag);
VOID IntReleaseRemoveLock(PIO_REMOVE_LOCK lock, PVOID tag);
VOID IntReleaseRemoveLockAndWait(PIO_REMOVE_LOCK lock, PVOID tag);
