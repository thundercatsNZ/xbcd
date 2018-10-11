// RemoveLock.cpp -- Portable implementation for remove-lock functions
// Copyright (C) 1999 by Walter Oney
// All rights reserved

#include "XBCD_driver.h"

///////////////////////////////////////////////////////////////////////////////

#pragma PAGEDCODE

VOID IntInitializeRemoveLock(PIO_REMOVE_LOCK lock, ULONG tag, ULONG minutes, ULONG maxcount)
	{							// InitializeRemoveLock
	//PAGED_CODE();
	KeInitializeEvent(&lock->Common.RemoveEvent, NotificationEvent, FALSE);
	lock->Common.IoCount = 1;
	lock->Common.Removed = FALSE;
	}							// InitializeRemoveLock

///////////////////////////////////////////////////////////////////////////////

#pragma LOCKEDCODE

NTSTATUS IntAcquireRemoveLock(PIO_REMOVE_LOCK lock, PVOID tag)
	{							// AcquireRemoveLock
	LONG usage = InterlockedIncrement(&lock->Common.IoCount);
	if (lock->Common.Removed)
		{						// removal in progress
		if (InterlockedDecrement(&lock->Common.IoCount) == 0)
			KeSetEvent(&lock->Common.RemoveEvent, 0, FALSE);
		return STATUS_DELETE_PENDING;
		}						// removal in progress
	return STATUS_SUCCESS;
	}							// AcquireRemoveLock

///////////////////////////////////////////////////////////////////////////////

VOID IntReleaseRemoveLock(PIO_REMOVE_LOCK lock, PVOID tag)
	{							// ReleaseRemoveLock
	if (InterlockedDecrement(&lock->Common.IoCount) == 0)
		KeSetEvent(&lock->Common.RemoveEvent, 0, FALSE);
	}							// ReleaseRemoveLock

///////////////////////////////////////////////////////////////////////////////

#pragma PAGEDCODE

VOID IntReleaseRemoveLockAndWait(PIO_REMOVE_LOCK lock, PVOID tag)
	{							// ReleaseRemoveLockAndWait
	//PAGED_CODE();
	lock->Common.Removed = TRUE;
	IntReleaseRemoveLock(lock, tag);
	IntReleaseRemoveLock(lock, NULL);
	KeWaitForSingleObject(&lock->Common.RemoveEvent, Executive, KernelMode, FALSE, NULL);
	}							// ReleaseRemoveLockAndWait
