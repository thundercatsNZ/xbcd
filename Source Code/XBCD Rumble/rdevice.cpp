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

#include "effdrv.h"

CDevice::CDevice(PTCHAR path, DWORD dwID, GUID didGUID)
{
	LastLVal = 0;
	LastRVal = 0;
	LastAxisVal[0] = 0;
	LastAxisVal[1] = 0;

	ID = dwID;
	rwPath = path;
	diGUID = didGUID;
	diHandle = NULL;
	bDIReady = FALSE;
  bDevWheel = FALSE;

	Devices[dwID] = this;
}

CDevice::~CDevice()
{
	EffMap::iterator ei;
	for(ei = Effects.begin(); ei != Effects.end(); ei++)
	{
		delete ei->second;
	}
	delete[] rwPath;
	rwPath = NULL;

	if(rwHandle != INVALID_HANDLE_VALUE)
	{
		CloseHandle(rwHandle);
		rwHandle = INVALID_HANDLE_VALUE;
	}

	if(diHandle)
	{
		diHandle->Unacquire();
		diHandle = NULL;
	}
}
