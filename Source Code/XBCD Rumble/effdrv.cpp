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
 *  EffDrv.c
 *
 *  Abstract:
 *
 *      Effect driver.
 *
 *****************************************************************************/
#define INITGUID
#include "effdrv.h"

HANDLE hTimer;
BOOL bTimerOn;
BOOL bStopAllDevices;

/*****************************************************************************
 *
 *      CEffDrv - Effect driver
 *
 *****************************************************************************/

struct CEffDrv : IDirectInputEffectDriver
{
	/*** IUnknown methods ***/
    STDMETHODIMP_(ULONG) AddRef();
    STDMETHODIMP_(ULONG) Release();
	STDMETHODIMP QueryInterface(REFIID riid, LPVOID *ppvOut);

    /*** IDirectInputEffectDriver methods ***/
	STDMETHODIMP DestroyEffect(DWORD dwId, DWORD dwEffect);
	STDMETHODIMP DeviceID(	DWORD dwDirectInputVersion,
							DWORD dwExternalID, DWORD fBegin,
							DWORD dwInternalID, LPVOID pvReserved);
	STDMETHODIMP DownloadEffect(DWORD dwId, DWORD dwEffectId, LPDWORD pdwEffect,
								LPCDIEFFECT peff, DWORD dwFlags);
	STDMETHODIMP Escape(DWORD dwId, DWORD dwEffect, LPDIEFFESCAPE pesc);
	STDMETHODIMP GetEffectStatus(DWORD dwId, DWORD dwEffect, LPDWORD pdwStatus);
	STDMETHODIMP GetForceFeedbackState(DWORD dwId, LPDIDEVICESTATE pds);
	STDMETHODIMP GetVersions(LPDIDRIVERVERSIONS pvers);
	STDMETHODIMP SendForceFeedbackCommand(DWORD dwId, DWORD dwCommand);
	STDMETHODIMP SetGain(DWORD dwId, DWORD dwGain);
	STDMETHODIMP StartEffect(DWORD dwId, DWORD dwEffect,
							 DWORD dwMode, DWORD dwCount);
	STDMETHODIMP StopEffect(DWORD dwId, DWORD dwEffect);

	CEffDrv(VOID);

	ULONG cRef; /* Object reference count */

	VOID StoreCondition(LPCDIEFFECT peff, PHWEFFECT pheff);
	VOID StorePeriodic(LPCDIEFFECT peff, PHWEFFECT pheff);
};

inline CEffDrv::CEffDrv(VOID)
{
	cRef = 1;
}

/*****************************************************************************
 *
 *      CEffDrv_AddRef
 *
 *      Increment our object reference count (thread-safely) and return
 *      the new reference count.
 *
 *****************************************************************************/

ULONG CEffDrv::AddRef()
{
	DebugPrint("Entry");

	DebugPrintP(__FUNCTION__, TEXT("Reference Count = %d"), cRef);

    InterlockedIncrement((LPLONG)&cRef);

	DebugPrintP(__FUNCTION__, TEXT("Reference Count = %d"), cRef);

	DebugPrint("Exit");
    return cRef;
}


/*****************************************************************************
 *
 *      CEffDrv_Release
 *
 *      Decrement our object reference count (thread-safely) and
 *      destroy ourselves if there are no more references.
 *
 *****************************************************************************/

ULONG CEffDrv::Release()
{
	DebugPrint("Entry");

    ULONG ulRc;

	DebugPrintP(__FUNCTION__, TEXT("Reference count = %d"), cRef);

    if(InterlockedDecrement((LPLONG)&cRef) == 0)
	{
		DebugPrint("Reference count = 0");

        delete this;
        ulRc = 0;
    }
	else
	{
        ulRc = cRef;

		DebugPrintP(__FUNCTION__, TEXT("Reference count = %d"), ulRc);
    }

	DebugPrint("Exit");

    return ulRc;
}

/*****************************************************************************
 *
 *      CEffDrv_QueryInterface
 *
 *      Our QI is very simple because we support no interfaces beyond
 *      ourselves.
 *
 *      riid - Interface being requested
 *      ppvOut - receives new interface (if successful)
 *
 *****************************************************************************/

HRESULT CEffDrv::QueryInterface(REFIID riid, LPVOID *ppvOut)
{
	DebugPrint("Entry");

    HRESULT hres;

    if ((riid == IID_IUnknown) || (riid == IID_IDirectInputEffectDriver))
	{
        AddRef();
        *ppvOut = (IDirectInputEffectDriver *)this;
        hres = S_OK;
    } else {
        *ppvOut = 0;
        hres = E_NOINTERFACE;
    }

	DebugPrint("Exit");
    return hres;
}

/*****************************************************************************
 *
 *      CEffDrv_DeviceID
 *
 *          DirectInput uses this method to inform us of
 *          the identity of the device.
 *
 *          For example, if a device driver is passed
 *          dwExternalID = 2 and dwInternalID = 1,
 *          then this means the interface will be used to
 *          communicate with joystick ID number 2, which
 *          corresonds to physical unit 1 in VJOYD.
 *
 *  dwDirectInputVersion
 *
 *          The version of DirectInput that loaded the
 *          effect driver.
 *
 *  dwExternalID
 *
 *          The joystick ID number being used.
 *          The Windows joystick subsystem allocates external IDs.
 *
 *  fBegin
 *
 *          Nonzero if access to the device is beginning.
 *          Zero if the access to the device is ending.
 *
 *  dwInternalID
 *
 *          Internal joystick id.  The device driver manages
 *          internal IDs.
 *
 *  lpReserved
 *
 *          Reserved for future use (HID).
 *
 *  Returns:
 *
 *          S_OK if the operation completed successfully.
 *
 *          Any DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *****************************************************************************/

HRESULT CEffDrv::DeviceID(DWORD dwDirectInputVersion,
							DWORD dwExternalID, DWORD fBegin,
							DWORD dwInternalID, LPVOID pvReserved)
{
	DebugPrint("Entry");

    HRESULT hres;
	DevMap::iterator di;

	DebugPrintP(__FUNCTION__, TEXT("Internal ID = %d"), dwInternalID);
	DebugPrintP(__FUNCTION__, TEXT("External ID = %d"), dwExternalID);

	// See if the ID we are being passed is in the array
	// of devices found
	if((di = Devices.find(dwExternalID)) == Devices.end())
	{
		DebugPrint("DEVICE NOT FOUND");
		return E_FAIL;
	}

	di->second->rwHandle = CreateFile((LPCTSTR)di->second->rwPath,
							GENERIC_READ | GENERIC_WRITE,
							FILE_SHARE_READ | FILE_SHARE_WRITE,
							(LPSECURITY_ATTRIBUTES)NULL,
							OPEN_EXISTING,
							0,
							NULL);
							
	if(di->second->rwHandle == INVALID_HANDLE_VALUE)
	{
		DebugPrint("Opening handle to device failed");
	}

	if(pDI)
	{
		if(di->second->bDIReady)
		{
			di->second->diHandle->Unacquire();
			di->second->diHandle = NULL;
			di->second->bDIReady = FALSE;
		}

		hres = pDI->CreateDevice(di->second->diGUID, &di->second->diHandle, NULL);
		if(hres == DI_OK)
		{
			hres = di->second->diHandle->SetCooperativeLevel(0, DISCL_NONEXCLUSIVE | DISCL_BACKGROUND);
			if(hres == DI_OK)
			{
				hres = di->second->diHandle->SetDataFormat(&c_dfDIJoystick);
				if(hres == DI_OK)
				{
					DIPROPRANGE diRange;

					diRange.diph.dwSize = sizeof(DIPROPRANGE);
					diRange.diph.dwHeaderSize = sizeof(DIPROPHEADER);
					diRange.diph.dwHow = DIPH_BYOFFSET;
					diRange.diph.dwObj = DIJOFS_X;
					diRange.lMin = -127;
					diRange.lMax = 127;

					hres = di->second->diHandle->SetProperty(DIPROP_RANGE, &diRange.diph);
					if((hres == DI_OK) || (hres == DI_PROPNOEFFECT))
					{
						diRange.diph.dwSize = sizeof(DIPROPRANGE);
						diRange.diph.dwHeaderSize = sizeof(DIPROPHEADER);
						diRange.diph.dwHow = DIPH_BYOFFSET;
						diRange.diph.dwObj = DIJOFS_Y;
						diRange.lMin = -127;
						diRange.lMax = 127;

						hres = di->second->diHandle->SetProperty(DIPROP_RANGE, &diRange.diph);
						if((hres == DI_OK) || (hres == DI_PROPNOEFFECT))
						{
							hres = di->second->diHandle->Acquire();
							if(hres == DI_OK)
							{
								di->second->bDIReady = TRUE;
							}
							else
							{
								DebugPrint("Acquire failed");
								di->second->diHandle = NULL;
							}
						}
						else
						{
							DebugPrint("Setting range for Y failed");
						}
					}
					else
					{
						DebugPrint("Setting range for X failed");
					}
				}
				else
					DebugPrint("SetDataFormat failed");
			}
			else
				DebugPrint("SetCooperativeLevel failed");
		}
		else
			DebugPrint("CreateDevice failed");
	}

	hres = S_OK;

	DebugPrint("Exit");

    return hres;
}

/*****************************************************************************
 *
 *      CEffDrv_GetVersions
 *
 *          Obtain version information about the force feedback
 *          hardware and driver.
 *
 *  pvers
 *
 *          A structure which should be filled in with version information
 *          describing the hardware, firmware, and driver.
 *
 *          DirectInput will set the dwSize field
 *          to sizeof(DIDRIVERVERSIONS) before calling this method.
 *
 *  Returns:
 *
 *          S_OK if the operation completed successfully.
 *
 *          E_NOTIMPL to indicate that DirectInput should retrieve
 *          version information from the VxD driver instead.
 *
 *          Any DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *****************************************************************************/

HRESULT CEffDrv::GetVersions(LPDIDRIVERVERSIONS pvers)
{
	DebugPrint("Entry");

    HRESULT hres;

	//hres = E_NOTIMPL;
	if (pvers->dwSize >= sizeof(DIDRIVERVERSIONS))
	{
		//  Tell DirectInput how much of the structure we filled in.
        pvers->dwSize = sizeof(DIDRIVERVERSIONS);

        //  In real life, we would detect the version of the hardware
        //  that is connected to unit number this->dwUnit.
        pvers->dwFirmwareRevision = 3;
        pvers->dwHardwareRevision = 5;
        pvers->dwFFDriverVersion = 3871;
        hres = S_OK;
    }
	else
	{
        hres = E_INVALIDARG;
    }

	DebugPrint("Exit");

    return hres;
}

/*****************************************************************************
 *
 *      CEffDrv_Escape
 *
 *          DirectInput uses this method to communicate
 *          IDirectInputDevice2::Escape and
 *          IDirectInputEFfect::Escape methods to the driver.
 *
 *  dwId
 *
 *          The joystick ID number being used.
 *
 *  dwEffect
 *
 *          If the application invoked the
 *          IDirectInputEffect::Escape method, then
 *          dwEffect contains the handle (returned by
 *          mf IDirectInputEffectDriver::DownloadEffect)
 *          of the effect at which the command is directed.
 *
 *          If the application invoked the
 *          mf IDirectInputDevice2::Escape method, then
 *          dwEffect is zero.
 *
 *  pesc
 *
 *          Pointer to a DIEFFESCAPE structure which describes
 *          the command to be sent.  On success, the
 *          cbOutBuffer field contains the number
 *          of bytes of the output buffer actually used.
 *
 *          DirectInput has already validated that the
 *          lpvOutBuffer and lpvInBuffer and fields
 *          point to valid memory.
 *
 *  Returns:
 *
 *          S_OK if the operation completed successfully.
 *
 *          Any DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *****************************************************************************/

HRESULT CEffDrv::Escape(DWORD dwId, DWORD dwEffect, LPDIEFFESCAPE pesc)
{
	DebugPrint("");

	/*
	 *  Escapes are not implemented.
	 */

    return E_NOTIMPL;
}

/*****************************************************************************
 *
 *      CEffDrv_SetGain
 *
 *          Set the overall device gain.
 *
 *  dwId
 *
 *          The joystick ID number being used.
 *
 *  dwGain
 *
 *          The new gain value.
 *
 *          If the value is out of range for the device, the device
 *          should use the nearest supported value and return
 *          DI_TRUNCATED.
 *
 *  Returns:
 *
 *
 *          S_OK if the operation completed successfully.
 *
 *          DI_TRUNCATED if the value was out of range and was
 *          changed to the nearest supported value.
 *
 *          Any DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *****************************************************************************/

HRESULT CEffDrv::SetGain(DWORD dwId, DWORD dwGain)
{
	DebugPrint("Entry");

    HRESULT hres;

	DevMap::iterator di;
	if((di = Devices.find(dwId)) == Devices.end())
	{
		DebugPrint("DEVICE NOT FOUND");
		return E_INVALIDARG;
	}

	DebugPrintP(__FUNCTION__, TEXT("dwGain = %d"), dwGain);

	/*
	/ Device gains are not being used
	*/

	hres = S_OK;

	DebugPrint("Exit");

    return hres;
}

/*****************************************************************************
 *
 *      CEffDrv_SendForceFeedbackCommand
 *
 *          Send a command to the device.
 *
 *  dwId
 *
 *          The external joystick number being addressed.
 *
 *  dwCommand
 *
 *          A DISFFC_* value specifying the command to send.
 *
 *  Returns:
 *
 *          S_OK on success.
 *
 *          Any DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *****************************************************************************/


HRESULT CEffDrv::SendForceFeedbackCommand(DWORD dwId, DWORD dwCommand)
{
	DebugPrint("Entry");

    HRESULT hres;
	
	DevMap::iterator di;
	if((di = Devices.find(dwId)) == Devices.end())
	{
		DebugPrint("DEVICE NOT FOUND");
		return E_INVALIDARG;
	}

    /*
     *  Our device is pretty simple.  It does not support Pause
     *  (and therefore not Continue either), nor can you enable
     *  or disable the actuators.
     */

    switch (dwCommand)
	{
		case DISFFC_RESET:
			{
				DebugPrint("Command - Reset");

				//Mark all effects as no longer busy (hence "free").
				EffMap::iterator ei;
				for(ei = di->second->Effects.begin(); ei != di->second->Effects.end(); ei++)
				{
					ei->second->bPlay = FALSE;
					ei->second->bBusy = FALSE;
				}

				hres = S_OK;
				break;
			}

		case DISFFC_STOPALL:
			{
				DebugPrint("Command - Stop All");

				EffMap::iterator ei;
				for(ei = di->second->Effects.begin(); ei != di->second->Effects.end(); ei++)
				{
					ei->second->bPlay = FALSE;
				}

				hres = S_OK;
				break;
			}

		case DISFFC_SETACTUATORSON:
			DebugPrint("Command - Set Actuators On");
			hres = S_OK;
			break;

		case DISFFC_SETACTUATORSOFF:
			DebugPrint("Command - Set Actuators Off");
			hres = S_OK;
			break;

		default:
			DebugPrint("Command - Not Implemented");
			hres = E_NOTIMPL;
			break;
    }

	DebugPrint("Exit");

    return hres;
}

/*****************************************************************************
 *
 *      CEffDrv_GetForceFeedbackState
 *
 *          Retrieve the force feedback state for the device.
 *
 *  dwId
 *
 *          The external joystick number being addressed.
 *
 *  pds
 *
 *          Receives device state.
 *
 *          DirectInput will set the dwSize field
 *          to sizeof(DIDEVICESTATE) before calling this method.
 *
 *  Returns:
 *
 *          S_OK on success.
 *
 *          Any DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *****************************************************************************/

HRESULT CEffDrv::GetForceFeedbackState(DWORD dwId, LPDIDEVICESTATE pds)
{
	DebugPrint("Entry");

    HRESULT hres;

	DevMap::iterator di;
	if((di = Devices.find(dwId)) == Devices.end())
	{
		DebugPrint("DEVICE NOT FOUND");
		return E_INVALIDARG;
	}

    if (pds->dwSize >= sizeof(DIDEVICESTATE))
	{
        HARDWAREINFO info;

		//Tell DirectInput how much of the structure we filled in.
        pds->dwSize = sizeof(DIDEVICESTATE);

		info.wTotalMemory = MAX_EFFECTS;
		info.wMemoryInUse = 0;

		EffMap::iterator ei;
		for(ei = di->second->Effects.begin(); ei != di->second->Effects.end(); ei++)
		{
			if(ei->second->bBusy)
			{
				info.wMemoryInUse++;
			}
		}

		//Start out empty and then work our way up.
        pds->dwState = 0;

		//If there are no effects, then DIGFFS_EMPTY.
        if (info.wMemoryInUse == 0) {
            pds->dwState |= DIGFFS_EMPTY;
        }

		//Our actuators are always on, for simplicity.
        pds->dwState |= DIGFFS_ACTUATORSON;

		//We can't report any of the other states.

		//MulDiv handles the overflow and divide-by-zero cases.
        pds->dwLoad = MulDiv(100, info.wMemoryInUse, info.wTotalMemory);

    } else {
        hres = E_INVALIDARG;
    }

	DebugPrint("Exit");

    return hres;
}

VOID CEffDrv::StoreCondition(LPCDIEFFECT peff, PHWEFFECT pheff)
{
	DWORD dwAxis;

	pheff->effect = *peff;
	pheff->bBusy = TRUE;
	CopyMemory(&pheff->fcondition[0], pheff->effect.lpvTypeSpecificParams, sizeof(DICONDITION)*pheff->effect.cAxes);
	pheff->effect.lpvTypeSpecificParams = NULL;

	for (dwAxis = 0; dwAxis < pheff->effect.cAxes; dwAxis++)
	{
		pheff->fcondition[dwAxis].lPositiveCoefficient = 255 * abs(pheff->fcondition[dwAxis].lPositiveCoefficient)/DI_FFNOMINALMAX;

		if(pheff->fcondition[dwAxis].lPositiveCoefficient > 255)
			pheff->fcondition[dwAxis].lPositiveCoefficient = 255;

		pheff->fcondition[dwAxis].lNegativeCoefficient = 255 * abs(pheff->fcondition[dwAxis].lNegativeCoefficient)/DI_FFNOMINALMAX;

		if(pheff->fcondition[dwAxis].lNegativeCoefficient > 255)
			pheff->fcondition[dwAxis].lNegativeCoefficient = 255;

		pheff->fcondition[dwAxis].lOffset = 127 * pheff->fcondition[dwAxis].lOffset/DI_FFNOMINALMAX;

		pheff->fcondition[dwAxis].dwPositiveSaturation = 255 * pheff->fcondition[dwAxis].dwPositiveSaturation/DI_FFNOMINALMAX;

		if(pheff->fcondition[dwAxis].dwPositiveSaturation > 255)
			pheff->fcondition[dwAxis].dwPositiveSaturation = 255;

		pheff->fcondition[dwAxis].dwNegativeSaturation = 255 * pheff->fcondition[dwAxis].dwNegativeSaturation/DI_FFNOMINALMAX;

		if(pheff->fcondition[dwAxis].dwNegativeSaturation > 255)
			pheff->fcondition[dwAxis].dwNegativeSaturation = 255;

		DebugPrintP(__FUNCTION__, TEXT("Axis %d, lOffset = %d"), dwAxis, pheff->fcondition[dwAxis].lOffset);

		DebugPrintP(__FUNCTION__, TEXT("Axis %d, lPositiveCoefficient = %d"), dwAxis, pheff->fcondition[dwAxis].lPositiveCoefficient);

		DebugPrintP(__FUNCTION__, TEXT("Axis %d, lNegativeCoefficient = %d"), dwAxis, pheff->fcondition[dwAxis].lNegativeCoefficient);

		DebugPrintP(__FUNCTION__, TEXT("Axis %d, dwPositiveSaturation = %d"), dwAxis, pheff->fcondition[dwAxis].dwPositiveSaturation);

		DebugPrintP(__FUNCTION__, TEXT("Axis %d, dwNegativeSaturation = %d"), dwAxis, pheff->fcondition[dwAxis].dwNegativeSaturation);

		DebugPrintP(__FUNCTION__, TEXT("Axis %d, lDeadBand = %d"), dwAxis, pheff->fcondition[dwAxis].lDeadBand);
	}
	return;
}

VOID CEffDrv::StorePeriodic(LPCDIEFFECT peff, PHWEFFECT pheff)
{
	pheff->effect = *peff;
	pheff->bBusy = TRUE;

	CopyMemory(&pheff->fperiodic, pheff->effect.lpvTypeSpecificParams, sizeof(DIPERIODIC));
	pheff->effect.lpvTypeSpecificParams = NULL;

	pheff->fperiodic.dwMagnitude = 255 * (abs((LONG)pheff->fperiodic.dwMagnitude) * abs((LONG)pheff->effect.dwGain)/DI_FFNOMINALMAX)/DI_FFNOMINALMAX;

	if(pheff->fperiodic.dwMagnitude > 255)
		pheff->fperiodic.dwMagnitude = 255;

	DebugPrintP(__FUNCTION__, TEXT("Magnitude = %d"), pheff->fperiodic.dwMagnitude);

	DebugPrintP(__FUNCTION__, TEXT("lOffset = %d"), pheff->fperiodic.lOffset);

	DebugPrintP(__FUNCTION__, TEXT("dwPeriod = %d"), pheff->fperiodic.dwPeriod);

	DebugPrintP(__FUNCTION__, TEXT("dwPhase = %d"), pheff->fperiodic.dwPhase);

	return;
}

/*****************************************************************************
 *
 *      CEffDrv_DownloadEffect
 *
 *          Send an effect to the device.
 *
 *  dwId
 *
 *          The external joystick number being addressed.
 *
 *  dwEffectId
 *
 *          Internal identifier for the effect, taken from
 *          the DIEFFECTATTRIBUTES structure for the effect
 *          as stored in the registry.
 *
 *  pdwEffect
 *
 *          On entry, contains the handle of the effect being
 *          downloaded.  If the value is zero, then a new effect
 *          is downloaded.  If the value is nonzero, then an
 *          existing effect is modified.
 *
 *          On exit, contains the new effect handle.
 *
 *          On failure, set to zero if the effect is lost,
 *          or left alone if the effect is still valid with
 *          its old parameters.
 *
 *          Note that zero is never a valid effect handle.
 *
 *  peff
 *
 *          The new parameters for the effect.  The axis and button
 *          values have been converted to object identifiers
 *          as follows:
 *
 *          - One type specifier:
 *
 *              DIDFT_RELAXIS,
 *              DIDFT_ABSAXIS,
 *              DIDFT_PSHBUTTON,
 *              DIDFT_TGLBUTTON,
 *              DIDFT_POV.
 *
 *          - One instance specifier:
 *
 *              DIDFT_MAKEINSTANCE(n).
 *
 *          Other bits are reserved and should be ignored.
 *
 *          For example, the value 0x0200104 corresponds to
 *          the type specifier DIDFT_PSHBUTTON and
 *          the instance specifier DIDFT_MAKEINSTANCE(1),
 *          which together indicate that the effect should
 *          be associated with button 1.  Axes, buttons, and POVs
 *          are each numbered starting from zero.
 *
 *  dwFlags
 *
 *          Zero or more DIEP_* flags specifying which
 *          portions of the effect information has changed from
 *          the effect already on the device.
 *
 *          This information is passed to drivers to allow for
 *          optimization of effect modification.  If an effect
 *          is being modified, a driver may be able to update
 *          the effect in situ and transmit to the device
 *          only the information that has changed.
 *
 *          Drivers are not, however, required to implement this
 *          optimization.  All fields in the DIEFFECT structure
 *          pointed to by the peff parameter are valid, and
 *          a driver may choose simply to update all parameters of
 *          the effect at each download.
 *
 *  Returns:
 *
 *          S_OK on success.
 *
 *          DI_TRUNCATED if the parameters of the effect were
 *          successfully downloaded, but some of them were
 *          beyond the capabilities of the device and were truncated.
 *
 *          DI_EFFECTRESTARTED if the parameters of the effect
 *          were successfully downloaded, but in order to change
 *          the parameters, the effect needed to be restarted.
 *
 *          DI_TRUNCATEDANDRESTARTED if both DI_TRUNCATED and
 *          DI_EFFECTRESTARTED apply.
 *
 *          Any other DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *****************************************************************************/

HRESULT CEffDrv::DownloadEffect(DWORD dwId, DWORD dwEffectId, LPDWORD pdwEffect,
								LPCDIEFFECT peff, DWORD dwFlags)
{
	DebugPrint("Entry");

    HRESULT hres;
	DWORD dwAxis;

	DevMap::iterator di;
	if((di = Devices.find(dwId)) == Devices.end())
	{
		DebugPrint("DEVICE NOT FOUND");
		return E_INVALIDARG;
	}

    /*
     *  !!IHV!! Write code here.
     *
     *  Remember to call DllEnterCrit and DllLeaveCrit as necessary
     *  to remain thread-safe.
     */

    /*
     *  If the user is changing the trigger button, then validate it.
     *  It must be a button, and it must be button 0.  We do not
     *  support triggers on button 1.  (Simple imaginary hardware.)
     */

    if (dwFlags & DIEP_TRIGGERBUTTON)
	{     /* User is changing trigger */
        if (peff->dwTriggerButton == DIEB_NOTRIGGER)
		{
            /*
             *  No trigger, so vacuously valid.
             */
        }
		else if ((peff->dwTriggerButton & DIDFT_PSHBUTTON) &&
                   DIDFT_GETINSTANCE(peff->dwTriggerButton) == 0)
		{
            /*
             *  Button 0.  Good; that's the only one we support.
             */
        }
		else
		{
            /*
             *  Somehow a bad trigger button got through.
             *  Probably a corrupted registry entry.
             */
			DebugPrint("Bad trigger button");
            return E_NOTIMPL;
        }
    }

    /*
     *  We don't support trigger autorepeat.
     */
    if (dwFlags & DIEP_TRIGGERREPEATINTERVAL)
	{
        if (peff->dwTriggerButton != DIEB_NOTRIGGER &&
            peff->dwTriggerRepeatInterval != INFINITE)
		{
			DebugPrint("Trigger autorepeat is not supported");
            return E_NOTIMPL;
        }
    }

    /*
     *  If the user is changing the axes, then validate them.
     *  We have only two axes, X (0) and Y (1).
     */

    if (dwFlags & DIEP_AXES)
	{              /* User is changing axes */
        for (dwAxis = 0; dwAxis < peff->cAxes; dwAxis++)
		{
            if ((peff->rgdwAxes[dwAxis] & DIDFT_ABSAXIS) &&
                DIDFT_GETINSTANCE(peff->rgdwAxes[dwAxis]) < 2)
			{
				/* Axis is valid */
			}
			else
			{
                /*
                 *  Somehow a bad axis got through.
                 *  Probably a corrupt registry entry.
                 */
				DebugPrint("Axis is not supported");
				return E_NOTIMPL;
            }
        }
    }

    /*
     *  If DIEP_NODOWNLOAD is set, then we are merely being asked
     *  to validate parameters, so we're done.
     */
    if (dwFlags & DIEP_NODOWNLOAD)
	{
		DebugPrint("Not Downloading");
        return S_OK;
    }

    /*
     *  Figure out which effect is being updated.
     *
     *  If we are downloading a brand new effect, then find a new effect
     *  id number for it.
     */

    DWORD dwEffect = *pdwEffect;
	EffMap::iterator ei;
    if(dwEffect == 0)
	{
		for(ei = di->second->Effects.begin(); ei != di->second->Effects.end(); ei++)
		{
			if(!ei->second->bBusy)
			{
				ZeroMemory(ei->second, sizeof(HWEFFECT));
				dwEffect = ei->first;
				break;
			}
		}

		if(dwEffect == 0)
		{
			if(di->second->Effects.size() == MAX_EFFECTS)
			{
				DebugPrintP(__FUNCTION__, TEXT("No more effects allowed on device %d "), di->first);
				return DIERR_DEVICEFULL;
			}

			PHWEFFECT pEffect = new HWEFFECT;

			dwEffect = di->second->Effects.size() + 1;

			di->second->Effects[dwEffect] = pEffect;

			DebugPrintP(__FUNCTION__, TEXT("Device ID = %d, Number of Effects = %d, New effect = %d"), di->first, di->second->Effects.size(), dwEffect);
		}
    }

	DebugPrintP(__FUNCTION__, TEXT("Effect ID = %d"), dwEffectId);

	if((ei = di->second->Effects.find(dwEffect)) == di->second->Effects.end())
	{
		DebugPrintP(__FUNCTION__, TEXT("Effect %d not found on device %d"), dwEffect, di->first);
		return E_HANDLE;
	}

	ei->second->dwType = dwEffectId;

    for(dwAxis = 0; dwAxis < peff->cAxes; dwAxis++)
	{
		ei->second->dwAxes[dwAxis] = DIDFT_GETINSTANCE(peff->rgdwAxes[dwAxis]);    
	}

    switch (dwEffectId)
	{
		case EFFECT_CONSTANT:
			{
				DebugPrint("Constant");
				ei->second->effect = *peff;
				ei->second->bBusy = TRUE;
				CopyMemory(&ei->second->fconstant, ei->second->effect.lpvTypeSpecificParams, sizeof(DICONSTANTFORCE));
				ei->second->effect.lpvTypeSpecificParams = NULL;

				ei->second->fconstant.lMagnitude = 255 * (ei->second->fconstant.lMagnitude * abs((LONG)ei->second->effect.dwGain)/DI_FFNOMINALMAX)/DI_FFNOMINALMAX;
				if(ei->second->fconstant.lMagnitude > 255)
					ei->second->fconstant.lMagnitude = 255;
				if(ei->second->fconstant.lMagnitude < -255)
					ei->second->fconstant.lMagnitude = -255;

				DebugPrintP(__FUNCTION__, TEXT("Magnitude = %d"), ei->second->fconstant.lMagnitude);

				hres = S_OK;
				break;
			}

		case EFFECT_SINE:
			{
				DebugPrint("Sine");
				
				StorePeriodic(peff, ei->second);

				hres = S_OK;
				break;
			}

		case EFFECT_RAMP:
			{
				DebugPrint("Ramp");
				ei->second->effect = *peff;
				ei->second->bBusy = TRUE;
				CopyMemory(&ei->second->framp, ei->second->effect.lpvTypeSpecificParams, sizeof(DIRAMPFORCE));
				ei->second->effect.lpvTypeSpecificParams = NULL;
				
				ei->second->framp.lStart = 255 * (ei->second->framp.lStart * abs((LONG)ei->second->effect.dwGain)/DI_FFNOMINALMAX)/DI_FFNOMINALMAX;
				if(ei->second->framp.lStart > 255)
					ei->second->framp.lStart = 255;
				if(ei->second->framp.lStart < -255)
					ei->second->framp.lStart = -255;
				ei->second->framp.lEnd = 255 * (ei->second->framp.lEnd * abs((LONG)ei->second->effect.dwGain)/DI_FFNOMINALMAX)/DI_FFNOMINALMAX;
				if(ei->second->framp.lEnd > 255)
					ei->second->framp.lEnd = 255;
				if(ei->second->framp.lEnd < -255)
					ei->second->framp.lEnd = -255;

				hres = S_OK;
				break;
			}

		case EFFECT_SQUARE:
			{
				DebugPrint("Square");
				
				StorePeriodic(peff, ei->second);

				hres = S_OK;
				break;
			}

		case EFFECT_TRIANGLE:
			{
				DebugPrint("Triangle");
				
				StorePeriodic(peff, ei->second);

				hres = S_OK;
				break;
			}

		case EFFECT_SAWTOOTHUP:
			{
				DebugPrint("Sawtooth Up");
				
				StorePeriodic(peff, ei->second);

				hres = S_OK;
				break;
			}

		case EFFECT_SAWTOOTHDOWN:
			{
				DebugPrint("Sawtooth Down");
				
				StorePeriodic(peff, ei->second);

				hres = S_OK;
				break;
			}

		case CONDITION_SPRING:
			{
				DebugPrint("Spring");
				
				StoreCondition(peff, ei->second);

				hres = S_OK;
				break;
			}

		case CONDITION_FRICTION:
			{
				DebugPrint("Friction");
				
				StoreCondition(peff, ei->second);

				hres = S_OK;
				break;
			}

		case CONDITION_DAMPER:
			{
				DebugPrint("Damper");
				
				StoreCondition(peff, ei->second);

				hres = S_OK;
				break;
			}

		case CONDITION_INERTIA:
			{
				DebugPrint("Inertia");

				StoreCondition(peff, ei->second);

				hres = S_OK;
				break;
			}

		case EFFECT_CUSTOM:
			{
				DebugPrint("Custom");

				ei->second->effect = *peff;
				ei->second->bBusy = TRUE;
				CopyMemory(&ei->second->fcustom, ei->second->effect.lpvTypeSpecificParams, sizeof(DICUSTOMFORCE));
				ei->second->effect.lpvTypeSpecificParams = NULL;

				hres = S_OK;
				break;
			}

		default:
			{
				DebugPrint("Not Supported Type");
				hres = E_NOTIMPL;
				break;
			}
    }

    if (SUCCEEDED(hres))
	{
        *pdwEffect = dwEffect;

        /*
         *  If the DIEP_START flag is set, then start the effect too.
         *  Our imaginary hardware doesn't have a download-and-start
         *  feature, so we just do it separately.
         */
        if ((dwFlags & DIEP_START) && (!ei->second->bPlay))
		{
			StartEffect(dwId, dwEffect, 0, 1);
        }
    }
	else
	{
		DestroyEffect(dwId, dwEffect);
    }

	DebugPrintP(__FUNCTION__, TEXT("Exiting with %d, pdwEffect %d"), hres, *pdwEffect);

    return hres;
}

/*****************************************************************************
 *
 *      CEffDrv_DestroyEffect
 *
 *          Remove an effect from the device.
 *
 *          If the effect is playing, the driver should stop it
 *          before unloading it.
 *
 *  dwId
 *
 *          The external joystick number being addressed.
 *
 *  dwEffect
 *
 *          The effect to be destroyed.
 *
 *  Returns:
 *
 *          S_OK on success.
 *
 *          Any other DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *****************************************************************************/

HRESULT CEffDrv::DestroyEffect(DWORD dwId, DWORD dwEffect)
{
    DebugPrint("Entry");

	DevMap::iterator di;
	if((di = Devices.find(dwId)) == Devices.end())
	{
		DebugPrint("DEVICE NOT FOUND");
		return E_INVALIDARG;
	}

    DebugPrintP(__FUNCTION__, TEXT("dwId %d, dwEffect %d"), dwId, dwEffect);

	EffMap::iterator ei;
	if((ei = di->second->Effects.find(dwEffect)) == di->second->Effects.end())
	{
		DebugPrintP(__FUNCTION__, TEXT("Effect %d not found on device %d"), dwEffect, di->first);
		return E_HANDLE;
	}

	if(ei->second->bBusy)
	{
		ei->second->bBusy = FALSE;
	}
	else
	{
		return E_HANDLE;
	}

	DebugPrint("Exit");

    return S_OK;
}

/*****************************************************************************
 *
 *      CEffDrv_StartEffect
 *
 *          Begin playback of an effect.
 *
 *          If the effect is already playing, then it is restarted
 *          from the beginning.
 *
 *  @cwrap  LPDIRECTINPUTEFFECTDRIVER | lpEffectDriver
 *
 *  @parm   DWORD | dwId |
 *
 *          The external joystick number being addressed.
 *
 *  @parm   DWORD | dwEffect |
 *
 *          The effect to be played.
 *
 *  @parm   DWORD | dwMode |
 *
 *          How the effect is to affect other effects.
 *
 *          This parameter consists of zero or more
 *          DIES_* flags.  Note, however, that the driver
 *          will never receive the DIES_NODOWNLOAD flag;
 *          the DIES_NODOWNLOAD flag is managed by
 *          DirectInput and not the driver.
 *
 *  @parm   DWORD | dwCount |
 *
 *          Number of times the effect is to be played.
 *
 *  Returns:
 *
 *          S_OK on success.
 *
 *          Any other DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *
 *****************************************************************************/

HRESULT CEffDrv::StartEffect(DWORD dwId, DWORD dwEffect,
							 DWORD dwMode, DWORD dwCount)
{
    HRESULT hres;

	DebugPrint("Entry");

	DevMap::iterator di;
	if((di = Devices.find(dwId)) == Devices.end())
	{
		DebugPrint("DEVICE NOT FOUND");
		return E_INVALIDARG;
	}

	EffMap::iterator ei;
	if((ei = di->second->Effects.find(dwEffect)) == di->second->Effects.end())
	{
		DebugPrintP(__FUNCTION__, TEXT("Effect %d not found on device %d"), dwEffect, di->first);
		return E_HANDLE;
	}

	DebugPrintP(__FUNCTION__, TEXT("dwCount = %d"), dwCount);

	//We don't support hardware DIES_SOLO, so we fake it by manually
	//stopping all other effects first.
    if (dwMode & DIES_SOLO)
	{
        SendForceFeedbackCommand(dwId, DISFFC_STOPALL);
    }

	//If we are actually being asked to play the effect, then play it.
    if(dwCount)
	{
		ei->second->dwStartTime = timeGetTime() + (ei->second->effect.dwStartDelay/1000);

		ei->second->bPlay = TRUE;

		//Start the timer only if it's not on already
		if(!bTimerOn)
		{
			DWORD threadId;

			DebugPrint("Starting Timer");

			//Close the handle to the timer thread
			CloseHandle(hTimer);
			//Create a new thread and set TimeProc as its starting function
			hTimer = CreateThread(NULL, 0, TimeProc, NULL, 0, &threadId);
			//Set the thread's priority to critical.  Might not be needed
			SetThreadPriority(hTimer, THREAD_PRIORITY_TIME_CRITICAL);
		}
    }

    return S_OK;

	DebugPrint("Exit");
    return hres;
}

/*****************************************************************************
 *
 *      CEffDrv_StopEffect
 *
 *          Halt playback of an effect.
 *
 *  dwId
 *
 *          The external joystick number being addressed.
 *
 *  dwEffect
 *
 *          The effect to be stopped.
 *
 *  Returns:
 *
 *          S_OK on success.
 *
 *          Any other DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *
 *****************************************************************************/

HRESULT CEffDrv::StopEffect(DWORD dwId, DWORD dwEffect)
{
	DebugPrint("Entry");

	DevMap::iterator di;
	if((di = Devices.find(dwId)) == Devices.end())
	{
		DebugPrint("DEVICE NOT FOUND");
		return E_INVALIDARG;
	}

	EffMap::iterator ei;
	if((ei = di->second->Effects.find(dwEffect)) == di->second->Effects.end())
	{
		DebugPrintP(__FUNCTION__, TEXT("Effect %d not found on device %d"), dwEffect, di->first);
		return E_HANDLE;
	}

	//Set the bPlay flag to false so that the timer doesn't play
	//the effect
	ei->second->bPlay = FALSE;

	DebugPrint("Exit");

    return S_OK;
}

/*****************************************************************************
 *
 *      CEffDrv_GetEffectStatus
 *
 *          Obtain information about an effect.
 *
 *  dwId
 *
 *          The external joystick number being addressed.
 *
 *  dwEffect
 *
 *          The effect to be queried.
 *
 *  pdwStatus
 *
 *          Receives the effect status in the form of zero
 *          or more DIEGES_* flags.
 *
 *  Returns:
 *
 *          S_OK on success.
 *
 *          Any other DIERR_* error code may be returned.
 *
 *          Private driver-specific error codes in the range
 *          DIERR_DRIVERFIRST through DIERR_DRIVERLAST
 *          may be returned.
 *
 *
 *****************************************************************************/

HRESULT CEffDrv::GetEffectStatus(DWORD dwId, DWORD dwEffect, LPDWORD pdwStatus)
{
	DebugPrint("Entry");

	DevMap::iterator di;
	if((di = Devices.find(dwId)) == Devices.end())
	{
		DebugPrint("DEVICE NOT FOUND");
		return E_INVALIDARG;
	}

	EffMap::iterator ei;
	if((ei = di->second->Effects.find(dwEffect)) == di->second->Effects.end())
	{
		DebugPrintP(__FUNCTION__, TEXT("Effect %d not found on device %d"), dwEffect, di->first);
		return E_HANDLE;
	}

	//Check the bPlay flag for this effect to see if it's
	//being played
    if (ei->second->bPlay) {
        *pdwStatus = DIEGES_PLAYING;
    } else {
        *pdwStatus = 0;
    }

	DebugPrint("Exit");

    return S_OK;
}

/*****************************************************************************
 *
 *      CEffDrv_New
 *
 *****************************************************************************/

STDMETHODIMP
CEffDrv_New(REFIID riid, LPVOID *ppvOut)
{
	DebugPrint("Entry");

    HRESULT hres;
    CEffDrv *ppvNew;

	*ppvOut = 0;

	ppvNew = new CEffDrv;
    if(ppvNew)
	{
        DllAddRef();

        /*
         *  !!IHV!! Do instance initialization here.
         *
         *  (e.g., open the driver you are going to IOCTL to)
         *
         *  DO NOT RESET THE DEVICE IN YOUR CONSTRUCTOR!
         *
         *  Wait for the SendForceFeedbackCommand(SFFC_RESET)
         *  to reset the device.  Otherwise, you may reset
         *  a device that another application is still using.
         */

        /*
         *  Attempt to obtain the desired interface.  QueryInterface
         *  will do an AddRef if it succeeds.
         */
        hres = ppvNew->QueryInterface(riid, ppvOut);
		ppvNew->Release();
		hres = NOERROR;

    } else {
        hres = E_OUTOFMEMORY;
		DebugPrint("Out of Memory");
    }

	DebugPrint("Exit");
    return hres;

}
