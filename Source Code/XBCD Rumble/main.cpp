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
 *  Main.c
 *
 *  Abstract:
 *
 *      Template effect driver that doesn't actually do anything.
 *
 *****************************************************************************/

#include "effdrv.h"

HINSTANCE g_hinst;
LPDIRECTINPUT8 pDI;

DevMap Devices;

#ifdef DBG_MEMLEAK
	CMemoryState oldMemState, newMemState, diffMemState;
#endif

/*****************************************************************************
 *
 *      Constant globals:  Never change.  Ever.
 *
 *****************************************************************************/

/*
 * !!IHV!! You must run GUIDGEN or UUIDGEN to generate your own GUID/CLSID
 */

CLSID CLSID_MyServer =
{ 0x5a31ddde, 0x75c8, 0x4678, 0x8d, 0xfb, 0x87, 0xd, 0xe5, 0x4e, 0xdd, 0xad };

/*****************************************************************************
 *
 *      List of steering wheel device IDs.
 *
 *****************************************************************************/

static const int n_wheels = 1;
static const DEVICEVPID wheels[] = { { 0x0E8F, 0x0201 } };

/*****************************************************************************
 *
 *      Dynamic Globals.  There should be as few of these as possible.
 *
 *****************************************************************************/

ULONG g_cRef;                   /* Global reference count */

/*****************************************************************************
 *
 *      DllAddRef / DllRelease
 *
 *      Adjust the DLL reference count.
 *
 *****************************************************************************/

STDAPI_(ULONG)
DllAddRef(void)
{
    return (ULONG)InterlockedIncrement((LPLONG)&g_cRef);
}

STDAPI_(ULONG)
DllRelease(void)
{
    return (ULONG)InterlockedDecrement((LPLONG)&g_cRef);
}

/*****************************************************************************
 *
 *      DllGetClassObject
 *
 *      OLE entry point.  Produces an IClassFactory for the indicated GUID.
 *
 *****************************************************************************/

STDAPI
DllGetClassObject(REFCLSID rclsid, REFIID riid, LPVOID *ppvObj)
{
	DebugPrint("Entry");
	HRESULT hres;

    if (rclsid == CLSID_MyServer) {
        hres = CClassFactory_New(riid, ppvObj);
    } else {
        *ppvObj = 0;
        hres = CLASS_E_CLASSNOTAVAILABLE;
    }

	DebugPrint("Exit");

    return hres;
}

/*****************************************************************************
 *
 *      DllCanUnloadNow
 *
 *      OLE entry point.  Fail if there are outstanding refs.
 *
 *****************************************************************************/

STDAPI
DllCanUnloadNow(void)
{
	DebugPrint("");

    return g_cRef ? S_FALSE : S_OK;
}

/*****************************************************************************
 *
 *      DllOnProcessAttach
 *
 *      Initialize the DLL.
 *
 *****************************************************************************/

STDAPI_(BOOL)
DllOnProcessAttach(HINSTANCE hinst)
{
	DebugPrint("Entry");

#ifdef DBG_MEMLEAK
		oldMemState.Checkpoint();
#endif

	HRESULT hres;
	BOOL bResult = FALSE;
	g_hinst = hinst;
	CDevice* Device;

    /*
     *  Performance tweak: We do not need thread notifications.
     */
    DisableThreadLibraryCalls(hinst);

    /*
     *  !!IHV!! Initialize your DLL here.
     */

	hres = DirectInput8Create(GetModuleHandle(NULL), DIRECTINPUT_VERSION, IID_IDirectInput8, (LPVOID*)&pDI, NULL);

	if(hres == DI_OK)
	{
		IDirectInputJoyConfig8* pDIJC;
		DIJOYCONFIG diJoyConfig;
		LPDIRECTINPUTDEVICE8 pDID;
		
		DebugPrint("DInputCreate Success");

		hres = pDI->QueryInterface(IID_IDirectInputJoyConfig8, (LPVOID*)&pDIJC);
		if(hres == S_OK)
		{
			int iDevCount = 0;
			BOOLEAN LastDevice = FALSE;

			diJoyConfig.dwSize = sizeof(DIJOYCONFIG);

			do{
				hres = pDIJC->GetConfig(iDevCount, &diJoyConfig, DIJC_REGHWCONFIGTYPE | DIJC_GUIDINSTANCE);
				if(hres == DI_OK)
				{
					hres = pDI->CreateDevice(diJoyConfig.guidInstance, &pDID, NULL);
					if(hres == DI_OK)
					{
						DIPROPGUIDANDPATH dpgp;
						DIPROPSTRING dps;

						memset(&dpgp, 0, sizeof(DIPROPGUIDANDPATH));
						memset(&dps, 0, sizeof(DIPROPSTRING));

						dpgp.diph.dwSize = sizeof(DIPROPGUIDANDPATH);
						dpgp.diph.dwHeaderSize = sizeof(DIPROPHEADER);
						dpgp.diph.dwObj = 0;
						dpgp.diph.dwHow = DIPH_DEVICE;

						dps.diph.dwSize = sizeof(DIPROPSTRING);
						dps.diph.dwHeaderSize = sizeof(DIPROPHEADER);
						dps.diph.dwObj = 0;
						dps.diph.dwHow = DIPH_DEVICE;

						hres = pDID->GetProperty(DIPROP_PRODUCTNAME, &dps.diph);
						hres &= pDID->GetProperty(DIPROP_GUIDANDPATH, &dpgp.diph);
						
						if(hres == DI_OK)
						{
							DIPROPDWORD dpdw;
							dpdw.diph.dwSize = sizeof(DIPROPDWORD);
							dpdw.diph.dwHeaderSize = sizeof(DIPROPHEADER);
							dpdw.diph.dwObj = 0;
							dpdw.diph.dwHow = DIPH_DEVICE;

							hres = pDID->GetProperty(DIPROP_JOYSTICKID, &dpdw.diph);
							if(hres == DI_OK)
							{
								LPTSTR path = new TCHAR[260];
								if(path)
								{
									wcstombs(path, dpgp.wszPath, sizeof(dpgp.wszPath));
									DebugPrint(path);

                  Device = new CDevice(path, dpdw.dwData, diJoyConfig.guidInstance);

                  hres = pDID->GetProperty(DIPROP_VIDPID, &dpdw.diph);
                  if(hres == DI_OK)
                  {
                    int i;
                    for (i = 0; i < n_wheels; ++i)
                    {
                      if ((wheels[i].vid == LOWORD(dpdw.dwData))
                        && (wheels[i].pid == HIWORD(dpdw.dwData)))
                      {
                        Device->bDevWheel = TRUE;
      			            break;
                      }
                    }
                  }

									//Return TRUE if any controllers are stored
									bResult = TRUE;
								}

								DebugPrintP(__FUNCTION__, TEXT("VPID = %d"), dpdw.dwData);
#ifdef _DEBUG
								TCHAR tsz[260];
								wcstombs(tsz, dps.wsz, sizeof(dps.wsz));
								DebugPrint(tsz);
#endif
							}
							else
							{
								DebugPrint("Failed 5");
							}
						}
						else
						{
							DebugPrint("Failed 4");
						}

						pDID->Release();
					}
					else
					{
						DebugPrint("Failed 3");
					}
				}
				else
				{
					LastDevice = TRUE;
					DebugPrint("Failed 2");
				}
				iDevCount += 1;
			}
			while(!LastDevice);

			pDIJC->Release();
		}
		else
		{
			DebugPrint("Failed 1");
		}
	}
	else
	{
		DebugPrint("DInputCreate Failed");
		pDI = NULL;
	}

	if(!bResult)
	{
		DebugPrint("No Devices found");

		DevMap::iterator di;
		for(di = Devices.begin(); di != Devices.end(); di++)
		{
			delete di->second;
		}

		if(pDI)
		{
			pDI->Release();
			pDI = NULL;
		}
	}

	DebugPrint("Exit");

    return bResult;

}

/*****************************************************************************
 *
 *      DllOnProcessDetach
 *
 *      De-initialize the DLL.
 *
 *****************************************************************************/

STDAPI_(void)
DllOnProcessDetach(void)
{
	DebugPrint("Entry");
    /*
     *  !!IHV!! De-initialize your DLL here.
     */

	//Tell the timer to stop the effects on all devices
	bStopAllDevices = TRUE;
	//Wait up to 5 seconds for the timer to finish
	WaitForSingleObject(hTimer, 5000);
	//Close the handle to the timer thread
	CloseHandle(hTimer);

	DevMap::iterator di;
	for(di = Devices.begin(); di != Devices.end(); di++)
	{
		delete di->second;
	}

	if(pDI)
	{
		pDI->Release();
		pDI = NULL;
	}

#ifdef DBG_MEMLEAK
		newMemState.Checkpoint();
		if(diffMemState.Difference(oldMemState, newMemState))
		{
			DebugPrint("POSSIBLE MEMORY LEAK DETECTED");
			diffMemState.DumpStatistics();
		}
#endif

	DebugPrint("Exit");
}

/*****************************************************************************
 *
 *      DllEntryPoint
 *
 *      DLL entry point.
 *
 *****************************************************************************/
extern "C"
{
#ifdef _MSC_VER
	BOOL WINAPI _CRT_INIT(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpReserved);

	STDAPI_(BOOL)
	DllEntryPoint(HINSTANCE hinst, DWORD dwReason, LPVOID lpReserved)
#else
	STDAPI_(BOOL)
	DllMain(HINSTANCE hinst, DWORD dwReason, LPVOID lpReserved)
#endif
{
	DebugPrint("Entry");

    switch(dwReason)
	{
    case DLL_PROCESS_ATTACH:
		{
#ifdef _MSC_VER
			if (!_CRT_INIT(hinst, dwReason, lpReserved))
				return FALSE;
#endif

			return DllOnProcessAttach(hinst);
			break;
		}
	case DLL_PROCESS_DETACH:
		{
			DllOnProcessDetach();

#ifdef _MSC_VER
			if (!_CRT_INIT(hinst, dwReason, lpReserved))
				return FALSE;
#endif

			return TRUE;
			break;
		}
    }

	DebugPrint("Exit");

	return FALSE;
}
}
