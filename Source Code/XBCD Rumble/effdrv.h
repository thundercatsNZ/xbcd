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

/*****************************************************************************
 *
 *  EffDrv.h
 *
 *  Abstract:
 *
 *      Common header file for the template effect driver.
 *
 *****************************************************************************/
#ifndef _EFFDRV_H
#define _EFFDRV_H

#define _WIN32_WINDOWS 0x0410

#define WINVER 0x0410

#define DIRECTINPUT_VERSION         0x0800

#define STRICT
#define WIN32_LEAN_AND_MEAN

#ifdef _MSC_VER
	#if (_MSC_VER < 1300)
		//Definitions for MSVC 6
		#define __FUNCTION__ ""
	#else
		//Definitions for MSVC 7.x
		
		#ifdef _DEBUG
			//Define the following to find memory leaks
			//Only works with .NET libraries 
			//#define DBG_MEMLEAK
		#endif
	#endif
#else
	//Define for debug build. Needed for MinGW
	//#define _DEBUG
#endif

#ifdef DBG_MEMLEAK
	#include <afx.h>
#endif

#include <windows.h>
#include <mmsystem.h>
#include <dinput.h>
#include <dinputd.h>
#include <math.h>
#include <map>

using namespace std;

/*
 /  Effects and conditions supported by the device.
 /  These are random numbers that are passed back to
 /  us when an application wants to create an effect.
 /  Numbers must match the ones in our device's
 /  OEMForceFeedback registry key.
*/

#define EFFECT_CONSTANT     371 //0x0173
#define EFFECT_SINE         723 //0x02D3

#define EFFECT_RAMP         125 //0x007D
#define EFFECT_SQUARE       285 //0x011D
#define EFFECT_TRIANGLE     459 //0x01CB
#define EFFECT_SAWTOOTHUP   542 //0x021E
#define EFFECT_SAWTOOTHDOWN 863 //0x035F

#define CONDITION_SPRING	916 //0x0394
#define CONDITION_FRICTION	215 //0x00D7
#define CONDITION_DAMPER	624 //0x0270
#define CONDITION_INERTIA	591 //0x024F

#define EFFECT_CUSTOM		307 //0x0133

#ifndef M_PI
	#define M_PI	3.14159265358979323846
#endif

//Debugging related stuff
#ifdef _DEBUG
	#include <stdarg.h>

	#ifdef DBG_MEMLEAK
		#define new DEBUG_NEW
		extern CMemoryState oldMemState, newMemState, diffMemState;
	#endif

	#define DebugPrint(params_in_parentheses) \
    { \
		char msgbuf[4096]; \
		sprintf(msgbuf, "XBCDR> %s: %s\n", __FUNCTION__, params_in_parentheses); \
        OutputDebugString(msgbuf); \
    }

	static void OutputDebug(const char * func, const char * format, ...)
	{
		char msgbuf1[2048];
		char msgbuf2[2048];
		va_list ap;

		va_start(ap, format);

		_vsnprintf(msgbuf1, sizeof(msgbuf1), format, ap);

		va_end(ap);

		_snprintf(msgbuf2, sizeof(msgbuf2), "XBCDR> %s: %s", func, msgbuf1);
		OutputDebugString(msgbuf2);
	}

	#define DebugPrintP OutputDebug
	#define CToStr wsprintf
#else
	#define DebugPrint
	#define DebugPrintP
	#define CToStr
#endif

/*****************************************************************************
 *
 *      Declare our structures as packed so the compiler won't pad them.
 *
 *****************************************************************************/

#include <pshpack1.h>

/*****************************************************************************
 *
 *      We report information about our imaginary hardware's memory usage
 *      with the following private structure.
 *
 *****************************************************************************/

typedef struct HARDWAREINFO {
    WORD   wTotalMemory;
    WORD   wMemoryInUse;
} HARDWAREINFO;

/*****************************************************************************
 *
 *      Structure holding the vendor and product IDs for a device.
 *
 *****************************************************************************/
struct DEVICEVPID {
    WORD   vid;
    WORD   pid;
};

/*****************************************************************************
 *
 *      Finished with our structures.  Restore original packing.
 *
 *****************************************************************************/

#include <poppack.h>

/*****************************************************************************
 *
 *      Internal helper functions that talk to our hardware.
 *
 *****************************************************************************/

typedef struct HWEFFECT {
    DWORD dwType;
	BOOL bBusy;
	DWORD dwStartTime;
	//DWORD dwEndTime;
	BOOL bPlay;
    DIEFFECT effect;
	DWORD dwAxes[2]; //Stores the order of the axes
	DICONSTANTFORCE fconstant;
	DIPERIODIC fperiodic;
	DIRAMPFORCE framp;
	DICONDITION fcondition[2]; //One for each axis
	DICUSTOMFORCE fcustom;
} HWEFFECT, *PHWEFFECT;

typedef map<DWORD, PHWEFFECT> EffMap;

class CDevice {
public:
	INT ID;	//External ID of the DirectInput device
	LPTSTR rwPath;	//File path to the HID device
	HANDLE rwHandle;	//File handle for writing to the device
	BYTE LastLVal;	//Last value sent to the left motor
	BYTE LastRVal;	//Last value sent to the right motor
	CHAR LastAxisVal[2];	//Last value of the X(0) and Y(1) axes
	EffMap Effects;	//Downloaded effects
	GUID diGUID;	//DirectInput device GUID
	LPDIRECTINPUTDEVICE8 diHandle;	//DirectInput device for reading axes
	BOOL bDIReady;	//Is the DirectInput device ready
	BOOL bDevWheel; //Is a steering wheel

	CDevice(PTCHAR path, DWORD dwID, GUID didGUID);
	~CDevice();
};

typedef map<DWORD, CDevice*> DevMap;

extern DevMap Devices;

extern HANDLE hTimer;
extern BOOL bTimerOn;
extern BOOL bStopAllDevices;

extern LPDIRECTINPUT8 pDI;

void WriteReport(HANDLE hDevice, BYTE lVal, BYTE rVal);
BOOL ReadAxes(CDevice *pDev, PCHAR cX, PCHAR cY);
DWORD WINAPI TimeProc(LPVOID lpParam);

#define MAX_EFFECTS		16
#define MAX_UNITS		16

/*****************************************************************************
 *
 *      Static globals:  Initialized at PROCESS_ATTACH and never modified.
 *
 *****************************************************************************/

extern HINSTANCE g_hinst;       /* This DLL's instance handle */

/*****************************************************************************
 *
 *      Dll global functions
 *
 *****************************************************************************/

STDAPI_(ULONG) DllAddRef(void);
STDAPI_(ULONG) DllRelease(void);

/*****************************************************************************
 *
 *      Class factory
 *
 *****************************************************************************/

STDAPI CClassFactory_New(REFIID riid, LPVOID *ppvObj);

/*****************************************************************************
 *
 *      Effect driver
 *
 *****************************************************************************/

STDAPI CEffDrv_New(REFIID riid, LPVOID *ppvObj);

//EXPORT HRESULT DllGetClassObject(REFCLSID rclsid, REFIID riid, LPVOID *ppvObj);
//EXPORT ULONG DllCanUnloadNow(void);

#endif //_EFFDRV_H
