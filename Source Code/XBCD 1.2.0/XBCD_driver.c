/* vim: set sw=8 noet cino=:
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

#include "XBCD_driver.h"

#pragma PAGEDCODE

NTSTATUS DriverEntry(IN PDRIVER_OBJECT pDriverObject, IN PUNICODE_STRING pRegistryPath)
{
	NTSTATUS status = STATUS_SUCCESS;
	HID_MINIDRIVER_REGISTRATION hidMinidriverRegistration;

	pDriverObject->MajorFunction[IRP_MJ_CREATE]						= XBCDCreate;
	pDriverObject->MajorFunction[IRP_MJ_CLOSE]						= XBCDClose;
	pDriverObject->MajorFunction[IRP_MJ_INTERNAL_DEVICE_CONTROL]	= XBCDDispatchIntDevice;
	pDriverObject->MajorFunction[IRP_MJ_DEVICE_CONTROL]				= XBCDDispatchDevice;
	pDriverObject->MajorFunction[IRP_MJ_SYSTEM_CONTROL]				= XBCDDispatchSystem;
	pDriverObject->MajorFunction[IRP_MJ_POWER]						= XBCDDispatchPower;
	pDriverObject->MajorFunction[IRP_MJ_PNP]						= XBCDDispatchPnp;
	pDriverObject->DriverUnload										= XBCDUnload;
	pDriverObject->DriverExtension->AddDevice						= XBCDAddDevice;

	RtlZeroMemory(&hidMinidriverRegistration, sizeof(HID_MINIDRIVER_REGISTRATION));

	hidMinidriverRegistration.Revision				= HID_REVISION;
	hidMinidriverRegistration.DriverObject			= pDriverObject;
	hidMinidriverRegistration.RegistryPath			= pRegistryPath;

	/* The size of this driver's own 'device extension'. With this, enough memory
	will be allocated by the system automatically */

	hidMinidriverRegistration.DeviceExtensionSize	= sizeof(DEVICE_EXTENSION);
	hidMinidriverRegistration.DevicesArePolled		= TRUE;

	status = HidRegisterMinidriver(&hidMinidriverRegistration);

	if (NT_SUCCESS(status))
	{
		KdPrint(("Minidriver Registration Worked"));
		/*RegistryPath.Buffer = (PWSTR) ExAllocatePool(PagedPool, pRegistryPath->Length + sizeof(WCHAR));
		RegistryPath.MaximumLength = pRegistryPath->Length + sizeof(WCHAR);
		RtlCopyUnicodeString(&RegistryPath, pRegistryPath);
		RegistryPath.Buffer[pRegistryPath->Length/sizeof(WCHAR)] = 0;*/
		KdPrint(("%ws", pRegistryPath->Buffer));
	}
	else
	{
		KdPrint(("Minidriver Registration Failed"));
	}
    return status;
}

NTSTATUS XBCDCreate(IN PDEVICE_OBJECT pFdo, IN PIRP pIrp)
{
    NTSTATUS status = STATUS_SUCCESS;

    pIrp->IoStatus.Status = status;
    pIrp->IoStatus.Information = 0;
    IoCompleteRequest(pIrp, IO_NO_INCREMENT);

	KdPrint(("XBCDCreate"));

    return status;
}

NTSTATUS XBCDClose(IN PDEVICE_OBJECT pFdo, IN PIRP pIrp)
{
    pIrp->IoStatus.Status = STATUS_SUCCESS;
    pIrp->IoStatus.Information = 0;
    IoCompleteRequest(pIrp, IO_NO_INCREMENT);

	KdPrint(("XBCDClose"));

    return STATUS_SUCCESS;
}

#pragma PAGEDCODE

NTSTATUS XBCDAddDevice(IN PDRIVER_OBJECT pDriverObject, IN PDEVICE_OBJECT pFdo)
{
    NTSTATUS status = STATUS_SUCCESS;
    PDEVICE_EXTENSION pDevExt = GET_MINIDRIVER_DEVICE_EXTENSION(pFdo);

	KdPrint(("XBCDAddDevice - Entry"));

	PAGED_CODE();

	pDevExt->pPdo = GET_PHYSICAL_DEVICE_OBJECT(pFdo);

	KeInitializeSpinLock(&pDevExt->ReadLock);
	KeInitializeSpinLock(&pDevExt->WriteLock);

	InitializeRemoveLock(&pDevExt->RemoveLock,'XBCD',0,0);

    // Set power management flags in the device object
    pFdo->Flags |= DO_POWER_PAGABLE | DO_DIRECT_IO;

	pDevExt->pLowerPdo = GET_LOWER_DEVICE_OBJECT(pFdo);

	status = STATUS_SUCCESS;

    // Clear the "initializing" flag so that we can get IRPs
    pFdo->Flags &= ~DO_DEVICE_INITIALIZING;

	// Needed for the original Windows 98 so the setup utility can detect the device
	if(!IoIsWdmVersionAvailable(1, 0x05))
	{
		PUNICODE_STRING pSymbolicLink = NULL;

		if(!NT_SUCCESS(IoRegisterDeviceInterface(pDevExt->pPdo, &GUID_DEVINTERFACE_USB_DEVICE, NULL, pSymbolicLink)))
		{
			if(pSymbolicLink)
			{
				RtlFreeUnicodeString(pSymbolicLink);
			}
		}
		else
		{
			KdPrint(("%ws", pSymbolicLink->Buffer));
			RtlFreeUnicodeString(pSymbolicLink);
		}
	}

    return status;
}

#pragma PAGEDCODE

VOID XBCDUnload(IN PDRIVER_OBJECT pDriverObject)
{
	KdPrint(("XBCDUnload"));
	/*if (RegistryPath.Buffer != NULL)
	{
		RtlFreeUnicodeString(&RegistryPath);
	}*/
	return;
}

#pragma PAGEDCODE

NTSTATUS XBCDDispatchPnp(IN PDEVICE_OBJECT pFdo, IN PIRP pIrp)
{
    PDEVICE_EXTENSION pDevExt = GET_MINIDRIVER_DEVICE_EXTENSION(pFdo);
    PIO_STACK_LOCATION stack;
    NTSTATUS status = STATUS_SUCCESS;
	KEVENT event;

	PAGED_CODE();

	status = AcquireRemoveLock(&pDevExt->RemoveLock, pIrp);

	if (!NT_SUCCESS(status))
	{
		pIrp->IoStatus.Information = 0;
		pIrp->IoStatus.Status = status;
		IoCompleteRequest(pIrp, IO_NO_INCREMENT);
		return status;
	}

	status = XBCDIncRequestCount(pDevExt);
	if (!NT_SUCCESS(status))
	{
		pIrp->IoStatus.Information = 0;
		pIrp->IoStatus.Status = status;
		IoCompleteRequest(pIrp, IO_NO_INCREMENT);
		return status;
	}

	stack = IoGetCurrentIrpStackLocation(pIrp);

	switch (stack->MinorFunction)
	{
		case IRP_MN_START_DEVICE:
		{
			KdPrint(("XBCDDispatchPnp - IRP_MN_START_DEVICE entry"));

			KeInitializeEvent(&event, NotificationEvent, FALSE);

			IoCopyCurrentIrpStackLocationToNext(pIrp);
			IoSetCompletionRoutine(pIrp, XBCDPnPComplete, &event, TRUE, TRUE, TRUE);
			status = IoCallDriver(pDevExt->pLowerPdo, pIrp);

			if (status == STATUS_PENDING)
			{
				status = KeWaitForSingleObject(&event, Executive, KernelMode, FALSE, NULL);
			}

			if(NT_SUCCESS(status))
			{
				status = XBCDStartDevice(pFdo, pIrp);
			}

			pIrp->IoStatus.Information = 0;
			pIrp->IoStatus.Status = status;
			IoCompleteRequest(pIrp, IO_NO_INCREMENT);

			ReleaseRemoveLock(&pDevExt->RemoveLock, pIrp);

			KdPrint(("XBCDDispatchPnp - IRP_MN_START_DEVICE exit"));

			break;
		}

		case IRP_MN_REMOVE_DEVICE:
		{
			KdPrint(("XBCDDispatchPnp - IRP_MN_REMOVE_DEVICE entry"));

			pDevExt->DeviceRemoved = TRUE;

			if (!pDevExt->SurpriseRemoved)
			{
				StopInterruptUrb(pDevExt);

				KdPrint(("XBCDDispatchPnp - release and wait removelock"));
				ReleaseRemoveLockAndWait(&pDevExt->RemoveLock, pIrp);

				KdPrint(("XBCDDispatchPnp - Stop device"));

				XBCDStopDevice(pFdo, pIrp);

				KdPrint(("XBCDDispatchPnp - Call removedevice"));

				XBCDRemoveDevice(pFdo, pIrp);
			}

			pIrp->IoStatus.Status = STATUS_SUCCESS;

			KdPrint(("XBCDDispatchPnp - Pass irp down"));

			IoSkipCurrentIrpStackLocation(pIrp);
			status = IoCallDriver(pDevExt->pLowerPdo, pIrp);

			if (InterlockedDecrement(&pDevExt->RequestCount) > 0)
			{
				KeWaitForSingleObject(&pDevExt->RemoveEvent, Executive, KernelMode, FALSE, NULL );
			}

			status = STATUS_SUCCESS;

			KdPrint(("XBCDDispatchPnp - IRP_MN_REMOVE_DEVICE exit"));

			return status;
		}
		case IRP_MN_STOP_DEVICE:
		{
			KdPrint(("XBCDDispatchPnp - IRP_MN_STOP_DEVICE"));

			StopInterruptUrb(pDevExt);

			ReleaseRemoveLockAndWait(&pDevExt->RemoveLock, pIrp);

			XBCDStopDevice(pFdo, pIrp);

			pIrp->IoStatus.Status = STATUS_SUCCESS;
			IoSkipCurrentIrpStackLocation(pIrp);
			status = IoCallDriver(pDevExt->pLowerPdo, pIrp);

			break;
		}
		case IRP_MN_QUERY_CAPABILITIES:
		{
			KdPrint(("XBCDDispatchPnp - IRP_MN_QUERY_CAPABILITIES"));

			stack->Parameters.DeviceCapabilities.Capabilities->SurpriseRemovalOK = TRUE;
			stack->Parameters.DeviceCapabilities.Capabilities->EjectSupported = FALSE;
			stack->Parameters.DeviceCapabilities.Capabilities->Removable = TRUE;
			stack->Parameters.DeviceCapabilities.Capabilities->DockDevice = FALSE;
			stack->Parameters.DeviceCapabilities.Capabilities->LockSupported = FALSE;
			stack->Parameters.DeviceCapabilities.Capabilities->D1Latency = 0;
			stack->Parameters.DeviceCapabilities.Capabilities->D2Latency = 0;
			stack->Parameters.DeviceCapabilities.Capabilities->D3Latency = 0;

			pIrp->IoStatus.Information = 0;
			pIrp->IoStatus.Status = STATUS_SUCCESS;
			IoCompleteRequest(pIrp, IO_NO_INCREMENT);

			ReleaseRemoveLock(&pDevExt->RemoveLock, pIrp);

			break;
		}
		case IRP_MN_SURPRISE_REMOVAL:
		{
			KdPrint(("XBCDDispatchPnp - IRP_MN_SURPRISE_REMOVAL entry"));

			pDevExt->SurpriseRemoved = TRUE;

			StopInterruptUrb(pDevExt);

			KdPrint(("XBCDDispatchPnp - release and wait removelock"));
			ReleaseRemoveLockAndWait(&pDevExt->RemoveLock, pIrp);

			XBCDStopDevice(pFdo, pIrp);

			KdPrint(("XBCDDispatchPnp - Call removedevice"));

			XBCDRemoveDevice(pFdo, pIrp);

			pIrp->IoStatus.Status = STATUS_SUCCESS;
			IoSkipCurrentIrpStackLocation(pIrp);
			status = IoCallDriver(pDevExt->pLowerPdo, pIrp);

			KdPrint(("XBCDDispatchPnp - IRP_MN_SURPRISE_REMOVAL exit"));

			break;
		}
		default:
		{
			KdPrint(("XBCDDispatchPnp - Irp %d not supported", stack->MinorFunction));

			IoSkipCurrentIrpStackLocation (pIrp);
			status = IoCallDriver(pDevExt->pLowerPdo, pIrp);
			ReleaseRemoveLock(&pDevExt->RemoveLock, pIrp);

			break;
		}
	}
		
	XBCDDecRequestCount(pDevExt);

	return status;
}

#pragma LOCKEDCODE

NTSTATUS XBCDPnPComplete(PDEVICE_OBJECT pFdo, PIRP pIrp, PVOID Context)
{
    NTSTATUS status = STATUS_MORE_PROCESSING_REQUIRED;

    PAGED_CODE();

    UNREFERENCED_PARAMETER(pFdo);
    KeSetEvent((PKEVENT) Context, 0, FALSE);

	/* If the lower driver returned PENDING, mark our stack location as
	pending also. This prevents the IRP's thread from being freed if
	the client's call returns pending. */
    if(pIrp->PendingReturned)
    {
        IoMarkIrpPending(pIrp);
    }

    return status;
}

#pragma LOCKEDCODE

NTSTATUS XBCDIncRequestCount(PDEVICE_EXTENSION pDevExt)
{
    NTSTATUS Status;

    InterlockedIncrement( &pDevExt->RequestCount );
    ASSERT(pDevExt->RequestCount > 0);
    
    if(pDevExt->DeviceRemoved)
    {
		/* PnP has already told us to remove the device so fail and make 
		sure that the event has been set. */
        if (0 == InterlockedDecrement(&pDevExt->RequestCount))
        {
            KeSetEvent(&pDevExt->RemoveEvent, IO_NO_INCREMENT, FALSE);
        }
        Status = STATUS_DELETE_PENDING;
    }
    else
    {
        Status = STATUS_SUCCESS;
    }

    return Status;
}

VOID XBCDDecRequestCount(PDEVICE_EXTENSION pDevExt)
{
    LONG LocalCount;

    LocalCount = InterlockedDecrement(&pDevExt->RequestCount);

    ASSERT(pDevExt->RequestCount >= 0);
    
    if(LocalCount == 0)
    {
		/* PnP has already told us to remove the device so the PnP remove 
		code should have set device as removed and should be waiting on
		the event. */
		if(pDevExt->DeviceRemoved)
		{
			KeSetEvent(&pDevExt->RemoveEvent, IO_NO_INCREMENT, FALSE);
		}
    }

    return;
}

#pragma PAGEDCODE

NTSTATUS XBCDStartDevice(PDEVICE_OBJECT pFdo, PIRP pIrp)
{
	NTSTATUS status;
	PDEVICE_EXTENSION pDevExt = GET_MINIDRIVER_DEVICE_EXTENSION(pFdo);
	ULONG size;
	PURB urb; // URB for use in this subroutine
	USB_CONFIGURATION_DESCRIPTOR tcd;
	PUSB_CONFIGURATION_DESCRIPTOR pcd;
	PUSB_INTERFACE_DESCRIPTOR pid;
	USBD_INTERFACE_LIST_ENTRY interfaces[MAX_INTERFACES + 1];
	PURB selurb;
	PUSBD_INTERFACE_INFORMATION pii;
	int i;

	//PAGED_CODE();

	urb = (PURB)ExAllocatePool(NonPagedPool, sizeof(struct _URB_CONTROL_DESCRIPTOR_REQUEST));

	if(!urb)
	{
		KdPrint(("XBCDStartDevice - Unable to allocate memory for URB"));
		return STATUS_INSUFFICIENT_RESOURCES;
	}

	/* Read our device descriptor. The only real purpose to this would be to find out how many
	configurations there are so we can read their descriptors. There's only one configuration.*/

	KdPrint(("XBCDStartDevice - getting device descriptor"));
	UsbBuildGetDescriptorRequest(urb, sizeof(struct _URB_CONTROL_DESCRIPTOR_REQUEST), USB_DEVICE_DESCRIPTOR_TYPE, 0, 0, &pDevExt->dd, NULL, sizeof(pDevExt->dd), NULL);
	status = SendAwaitUrb(pFdo, urb);
	if(!NT_SUCCESS(status))
	{
		//ExFreePool(urb);
		KdPrint(("XBCDStartDevice - Error %X trying to read device descriptor", status));
		//return status;
	}
	else
	{
		KdPrint(("VendorID %X, ProductID %X, Version %X", pDevExt->dd.idVendor, pDevExt->dd.idProduct, pDevExt->dd.bcdDevice));
	}

	/* Read the descriptor of the first configuration. This requires two steps. The first step
	reads the fixed-size configuration descriptor alone. The second step reads the
	configuration descriptor plus all imbedded interface and endpoint descriptors. */

	KdPrint(("XBCDStartDevice - getting configuration descriptor"));
	UsbBuildGetDescriptorRequest(urb, sizeof(struct _URB_CONTROL_DESCRIPTOR_REQUEST), USB_CONFIGURATION_DESCRIPTOR_TYPE, 0, 0, &tcd, NULL, sizeof(tcd), NULL);
	status = SendAwaitUrb(pFdo, urb);

	if(!NT_SUCCESS(status))
	{
		ExFreePool(urb);
		KdPrint(("XBCDStartDevice - Error %X trying to read configuration descriptor 1", status));
		return status;
	}

	size = tcd.wTotalLength;
	pcd = (PUSB_CONFIGURATION_DESCRIPTOR) ExAllocatePool(NonPagedPool, size);
	if(!pcd)
	{
		ExFreePool(urb);
		KdPrint(("XBCDStartDevice - Unable to allocate %X bytes for configuration descriptor", size));
		return STATUS_INSUFFICIENT_RESOURCES;
	}

	KdPrint(("XBCDStartDevice - Getting second part of configuration descriptor"));
	UsbBuildGetDescriptorRequest(urb, sizeof(struct _URB_CONTROL_DESCRIPTOR_REQUEST), USB_CONFIGURATION_DESCRIPTOR_TYPE,
		0, 0, pcd, NULL, size, NULL);
	status = SendAwaitUrb(pFdo, urb);

	if(!NT_SUCCESS(status))
	{
		ExFreePool(urb);
		ExFreePool(pcd);
		KdPrint(("XBCDStartDevice - Error %X trying to read configuration descriptor 2", status));
		return status;
	}

	if(pcd->bNumInterfaces > MAX_INTERFACES)
	{
		ExFreePool(urb);
		ExFreePool(pcd);
		KdPrint(("XBCDStartDevice - Device has %d interfaces. Expected no more than %d.", pcd->bNumInterfaces, MAX_INTERFACES));
		return STATUS_DEVICE_CONFIGURATION_ERROR;
	}

	// Get the descriptors for the proper interfaces
	for(i = 0; i < pcd->bNumInterfaces; ++i)
	{
		interfaces[i].InterfaceDescriptor = USBD_ParseConfigurationDescriptorEx(pcd, pcd, i, -1, -1, -1, -1);
		interfaces[i].Interface = NULL;
	}
	interfaces[i].InterfaceDescriptor = NULL;
	interfaces[i].Interface = NULL;

	pid = interfaces[0].InterfaceDescriptor;

	// Check for Xbox 360 gamepad
	if(pid->bInterfaceClass == 0xFF
		&& pid->bInterfaceSubClass == 0x5D
		&& pid->bInterfaceProtocol == 0x01)
	{
		pDevExt->is360 = TRUE;
		KdPrint(("XBCDStartDevice - Detected Xbox 360 gamepad"));
	}

	KdPrint(("XBCDStartDevice - Selecting the configuration"));
	// Create a URB to use in selecting a configuration.
	selurb = USBD_CreateConfigurationRequestEx(pcd, interfaces);
	if(!selurb)
	{
		ExFreePool(urb);
		ExFreePool(pcd);
		KdPrint(("XBCDStartDevice - Unable to create configuration request"));
		return STATUS_INSUFFICIENT_RESOURCES;
	}

	pii = interfaces[0].Interface;
	if(pii->NumberOfPipes != pid->bNumEndpoints)
	{
		ExFreePool(urb);
		ExFreePool(pcd);
		ExFreePool(selurb);
		KdPrint(("XBCDStartDevice - NumberOfPipes %d does not match bNumEndpoints %d",pii->NumberOfPipes, pid->bNumEndpoints));
		return STATUS_DEVICE_CONFIGURATION_ERROR;
	}
	switch(pid->bNumEndpoints)
	{
		case 1:
			{
				pDevExt->bHasMotors = FALSE;

				KdPrint(("Pipe 0 : MaxTransfer %d, MaxPckSize %d, PipeType %d, Interval %d, Handle %d Address %d", pii->Pipes[0].MaximumTransferSize, pii->Pipes[0].MaximumPacketSize, pii->Pipes[0].PipeType, pii->Pipes[0].Interval, pii->Pipes[0].PipeHandle, pii->Pipes[0].EndpointAddress));

				/*pii->Pipes[0].MaximumTransferSize = 0x0020;
				pii->Pipes[0].MaximumPacketSize = 0x0020;
				pii->Pipes[0].PipeType = UsbdPipeTypeInterrupt;
				pii->Pipes[0].Interval = 0x04; */

				break;
			}
		case 2:
			{
				pDevExt->bHasMotors = TRUE;

				KdPrint(("Pipe 0 : MaxTransfer %d, MaxPckSize %d, PipeType %d, Interval %d, Handle %d Address %d", pii->Pipes[0].MaximumTransferSize, pii->Pipes[0].MaximumPacketSize, pii->Pipes[0].PipeType, pii->Pipes[0].Interval, pii->Pipes[0].PipeHandle, pii->Pipes[0].EndpointAddress));

				/*pii->Pipes[0].MaximumTransferSize = 0x0020;
				pii->Pipes[0].MaximumPacketSize = 0x0020;
				pii->Pipes[0].PipeType = UsbdPipeTypeInterrupt;
				pii->Pipes[0].Interval = 0x04;*/

				KdPrint(("Pipe 1 : MaxTransfer %d, MaxPckSize %d, PipeType %d, Interval %d, Handle %d Address %d", pii->Pipes[1].MaximumTransferSize, pii->Pipes[1].MaximumPacketSize, pii->Pipes[1].PipeType, pii->Pipes[1].Interval, pii->Pipes[1].PipeHandle, pii->Pipes[1].EndpointAddress));

				/*pii->Pipes[1].MaximumTransferSize = 0x0006;
				pii->Pipes[1].MaximumPacketSize = 0x0020;
				pii->Pipes[1].PipeType = UsbdPipeTypeInterrupt;
				pii->Pipes[1].Interval = 0x04; */
				break;
			}
		default:
			{
				ExFreePool(urb);
				ExFreePool(pcd);
				ExFreePool(selurb);
				KdPrint(("XBCDStartDevice - %d is the wrong number of endpoints", pid->bNumEndpoints));
				return STATUS_DEVICE_CONFIGURATION_ERROR;
			}
	}

	// Submit the set-configuration request
	status = SendAwaitUrb(pFdo, selurb);
	if(!NT_SUCCESS(status))
	{
		ExFreePool(urb);
		ExFreePool(pcd);
		ExFreePool(selurb);
		KdPrint(("XBCDStartDevice - Error %X trying to select configuration", status));
		return status;
	}

	// Save the configuration and pipe handles
	pDevExt->hconfig = selurb->UrbSelectConfiguration.ConfigurationHandle;
	pDevExt->hInPipe = pii->Pipes[0].PipeHandle;
	if(pDevExt->bHasMotors)
		pDevExt->hOutPipe = pii->Pipes[1].PipeHandle;

	/*ResetPipe(pFdo,pii->Pipes[0].PipeHandle);
	ResetPipe(pFdo,pii->Pipes[1].PipeHandle); */

	// Transfer ownership of the configuration descriptor to the device extension		
	pDevExt->pcd = pcd;
	pcd = NULL;

	// Initialize the variable for data read from the device
	RtlZeroMemory(&pDevExt->hwInData, sizeof(pDevExt->hwInData));

	// Initialize the variable for data written to the device
	RtlZeroMemory(&pDevExt->hwOutData, sizeof(pDevExt->hwOutData));

	ExFreePool(selurb);
	ExFreePool(urb);

	if(pcd)
	{
		ExFreePool(pcd);
	}

	if(!NT_SUCCESS(CreateInterruptUrb(pFdo)))
	{
		KdPrint(("XBCDStartDevice - Could not create interrupt urb"));
	}

	KeInitializeDpc(&pDevExt->timeDPC, timerDPCProc, pDevExt);
	KeInitializeTimer(&pDevExt->timer);

	pDevExt->isWin9x = !IoIsWdmVersionAvailable(1, 0x10);

	// First time initialization of the configuration and layout(s).

	{
		unsigned int index;

		pDevExt->DevUsage = HID_USAGE_GAMEPAD;

		pDevExt->nButtons = NR_OUT_BUTTONS;
		pDevExt->LayoutNr=0;
		pDevExt->NrOfLayouts=1;
		setDefaultMapMatrix(pDevExt->MapMatrix[pDevExt->LayoutNr], pDevExt->isWin9x, pDevExt->is360);
		pDevExt->LedSetting=pDevExt->LightStatus=0x01;  // set to 0x01 (blinking) initially
		pDevExt->LaFactor=255;
		pDevExt->RaFactor=255;

		pDevExt->BThreshold = MAX_VALUE * 10/255;
		pDevExt->TThreshold = MAX_VALUE * 10/255;
		pDevExt->AThreshold = MAX_VALUE * 100/255;

		pDevExt->LStickDZ = 0;
		pDevExt->RStickDZ = 0;

		if(pDevExt->isWin9x)
			pDevExt->AxesOn = 27; //no RY axis
		else
			pDevExt->AxesOn = 31;

		for(index=0; index<NR_OUT_AXES; ++index)
		{
			pDevExt->AxesScale[index] = MAX_VALUE;
		}

		pDevExt->bFullRange[0] = FALSE;
		pDevExt->bFullRange[1] = FALSE;
	}

	//Read the configuration from the registry
	XBCDReadConfig(pFdo);

	pDevExt->DeviceStarted = TRUE;
    return STATUS_SUCCESS;
}

#pragma PAGEDCODE

VOID XBCDRemoveDevice(PDEVICE_OBJECT pFdo, PIRP pIrp)
{
	PDEVICE_EXTENSION pDevExt = GET_MINIDRIVER_DEVICE_EXTENSION(pFdo);
	NTSTATUS status;

	pDevExt->PowerDown = TRUE;

	KdPrint(("XBCDRemoveDevice - Trying to delete the interrupt urb"));
	DeleteInterruptUrb(pFdo);

	return;
}

VOID XBCDStopDevice(PDEVICE_OBJECT pFdo, PIRP pIrp)
{
	NTSTATUS status;
	PDEVICE_EXTENSION pDevExt = GET_MINIDRIVER_DEVICE_EXTENSION(pFdo);
	PURB urb;

	/*Cancel the URB in case it's currently active
	KdPrint(("XBCDStopDevice - About to stop the interrupt urb"));
	StopInterruptUrb(pDevExt);
	KdPrint(("XBCDStopDevice - Stopped the interrupt urb"));

	pDevExt->timerEnabled = FALSE;
	KeCancelTimer(&pDevExt->timer);*/

	KdPrint(("XBCDStopDevice - freeing pcd"));
	if(pDevExt->pcd)
		ExFreePool(pDevExt->pcd);
	pDevExt->pcd = NULL;

	if(pDevExt->DeviceStarted)
	{
		pDevExt->DeviceStarted = FALSE;

		urb = ExAllocatePool(NonPagedPool, sizeof(struct _URB_SELECT_CONFIGURATION));

		if(!urb)
		{
			KdPrint(("XBCDStopDevice - Could not allocate memory for URB"));
			return;
		}

		KdPrint(("XBCDStopDevice - Starting to deconfigure device"));
		UsbBuildSelectConfigurationRequest(urb, sizeof(struct _URB_SELECT_CONFIGURATION), NULL);
		status = SendAwaitUrb(pFdo, urb);
		KdPrint(("XBCDStopDevice - Deconfiguring device"));
		if(!NT_SUCCESS(status))
		{
			KdPrint(("XBCDStopDevice - Error %X trying to deconfigure device", status));
		}

		ExFreePool(urb);
	}
	
	KdPrint(("XBCDStopDevice - returning"));
	return;
}

#pragma PAGEDCODE

NTSTATUS XBCDDispatchPower(IN PDEVICE_OBJECT pFdo, IN PIRP pIrp)
{
	PIO_STACK_LOCATION stack = IoGetCurrentIrpStackLocation(pIrp);
	PDEVICE_EXTENSION pDevExt = GET_MINIDRIVER_DEVICE_EXTENSION(pFdo);
  NTSTATUS status = STATUS_SUCCESS;

	// If power is being restored to a 360 device, reset the LEDs
	if(stack->MinorFunction == IRP_MN_SET_POWER
    && stack->Parameters.Power.Type == DevicePowerState
    && stack->Parameters.Power.State.DeviceState == PowerDeviceD0
    && pDevExt->is360)
	{
		status = AcquireRemoveLock(&pDevExt->RemoveLock, pIrp);
		
		if(NT_SUCCESS(status))
		{	
		  IoMarkIrpPending(pIrp);
		  IoCopyCurrentIrpStackLocationToNext(pIrp);
		  IoSetCompletionRoutine(pIrp, XBCDPowerOn360, NULL, TRUE, TRUE, TRUE);
		  PoCallDriver(pDevExt->pLowerPdo, pIrp);

		  KdPrint(("XBCDDispatchPower: 360 DevicePowerD0"));
		  return STATUS_PENDING;
    }
	}

  // Default handling; pass the IRP on to lower drivers
	PoStartNextPowerIrp(pIrp);
	IoSkipCurrentIrpStackLocation(pIrp);

  KdPrint(("XBCDDispatchPower: Default"));
	return PoCallDriver(pDevExt->pLowerPdo, pIrp);
}

#pragma LOCKEDCODE

NTSTATUS XBCDPowerOn360(PDEVICE_OBJECT pFdo, PIRP pIrp, PVOID Context)
{
  PIO_STACK_LOCATION stack = IoGetCurrentIrpStackLocation(pIrp);
	PDEVICE_EXTENSION pDevExt = GET_MINIDRIVER_DEVICE_EXTENSION(pFdo);

  PAGED_CODE();
	
	/* This is the main point of our power management function. When the
  computer comes out of standby, it simply restores context. Thus the
  driver state is unchanged. However, from the device perspective, it
  has been powered on after being turned off; thus, the LED resets to
  the default blinking state. */
  XBCDUpdate360Leds(pDevExt);
	
	PoSetPowerState(pFdo, DevicePowerState, stack->Parameters.Power.State);
	PoStartNextPowerIrp(pIrp);	
	ReleaseRemoveLock(&pDevExt->RemoveLock, pIrp);

	/* If the lower driver returned PENDING, mark our stack location as
	pending also. This prevents the IRP's thread from being freed if
	the client's call returns pending. */
  if(pIrp->PendingReturned)
  {
    IoMarkIrpPending(pIrp);
  }

  return STATUS_SUCCESS;
}

#pragma PAGEDCODE

/*****************************************************************************/

/* Read configuration and layout from the registry.

Parameters:
IN PDEVICE_OBJECT pFdo : Pointer to functional device object */

void XBCDReadConfig(IN PDEVICE_OBJECT pFdo)
{
	HANDLE hKey;
	NTSTATUS ntstatus;
	int ReceivedDataLen;
	unsigned int index, index2;
	PDEVICE_EXTENSION pDevExt = GET_MINIDRIVER_DEVICE_EXTENSION(pFdo);

	// Temporary data buffer
	UCHAR TempRegData[MAP_MATRIX_SIZE];

	/* Unicode strings of the layouts' names in the registry
	(The 'L' in front of the string is for unicode) */

	WCHAR LayoutNames[8][11] =
	{
		L"MapMatrix0",
		L"MapMatrix1",
		L"MapMatrix2",
		L"MapMatrix3",
		L"MapMatrix4",
		L"MapMatrix5",
		L"MapMatrix6",
		L"MapMatrix7"
	};

	/* DDK Quote: 'The IoOpenDeviceRegistryKey routine returns a handle to a
	device-specific or a driver-specific registry key for a particular
	device instance.'
	ZwOpenKey is used to open existing registry keys, but apparently it does
	not have to be done here since IoOpenDeviceRegistryKey already does it. */

	ntstatus = IoOpenDeviceRegistryKey(GET_PHYSICAL_DEVICE_OBJECT(pFdo),
									 PLUGPLAY_REGKEY_DEVICE, KEY_ALL_ACCESS, &hKey);
	if(NT_SUCCESS(ntstatus))
	{
		KdPrint(("XBCDReadConfig: IoOpenDeviceRegistryKey"));

		ReceivedDataLen = ReadRegistry(hKey, L"DevType", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: DevType not found in registry. Using default."));
			pDevExt->DevUsage = HID_USAGE_GAMEPAD;
		}
		else
		{
			pDevExt->DevUsage = TempRegData[0];
			if((pDevExt->DevUsage != HID_USAGE_GAMEPAD) && (pDevExt->DevUsage != HID_USAGE_JOYSTICK))
			{
				pDevExt->DevUsage = HID_USAGE_GAMEPAD;
			}
		}

		// Get overall number of layouts from registry.

		ReceivedDataLen = ReadRegistry(hKey, L"NrOfLayouts", TempRegData, sizeof(TempRegData));
		pDevExt->NrOfLayouts = (int)TempRegData[0];
		if((ReceivedDataLen != 4) || (pDevExt->NrOfLayouts > MAX_NR_LAYOUTS))
			pDevExt->NrOfLayouts = 1;

		// Check if desired layout can be retrieved (i.e. 'is in range')
		if(pDevExt->LayoutNr >= pDevExt->NrOfLayouts)
			pDevExt->LayoutNr = 0;

		KdPrint(("XBCDReadConfig: NrOfLayouts %i, LayoutNr %i",
				pDevExt->NrOfLayouts, pDevExt->LayoutNr));

		for(index=0; index != pDevExt->NrOfLayouts; ++index)
		{
			// Try to get layout. If anything goes wrong, use default layout
			ReceivedDataLen = ReadRegistry(hKey, LayoutNames[index], TempRegData, sizeof(TempRegData));
			if(ReceivedDataLen != MAP_MATRIX_SIZE)
			{
				KdPrint(("XBCDReadConfig: MapMatrix%i not found in registry. Using default layout.", index));
				setDefaultMapMatrix(pDevExt->MapMatrix[index], pDevExt->isWin9x, pDevExt->is360);
			}

			/* Write retrieved data to the map matrix array used in XBCD_control.
			Also, check range of the numbers. */

			else
			{
				for(index2=0; index2 != MAP_MATRIX_SIZE; ++index2)
				{
					pDevExt->MapMatrix[index][index2] = (int)(TempRegData[index2]>NR_WINCONTROLS ? 0 : TempRegData[index2]);
					KdPrint(("XBCDReadConfig: MapMatrix[%i]=%i", index2, pDevExt->MapMatrix[index][index2]));
				}
			}
		}

		/* Get left and right actuator scale factors.
		The entire 8 Bits are used, so no range check is necessary.

		Modified registry names so there's no conflict with the old driver names */

		ReceivedDataLen = ReadRegistry(hKey, L"ALFactor", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: ALFactor not found in registry. Using default."));
			pDevExt->LaFactor=255;
		}
		else
			pDevExt->LaFactor=TempRegData[0];

		ReceivedDataLen = ReadRegistry(hKey, L"ARFactor", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: ARFactor not found in registry. Using default."));
			pDevExt->RaFactor=255;
		}
		else
			pDevExt->RaFactor = TempRegData[0];

		ReceivedDataLen = ReadRegistry(hKey, L"AxesOn", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: AxesOn not found in registry. Using default."));
			if(pDevExt->isWin9x)
				pDevExt->AxesOn = 27; //no RY axis
			else
				pDevExt->AxesOn = 31;
		}
		else
		{
			if(pDevExt->isWin9x)
				pDevExt->AxesOn = TempRegData[0] & 27; //no RY axis
			else
				pDevExt->AxesOn = TempRegData[0] & 31;
		}

		/*****************************************************************************/

		ReceivedDataLen = ReadRegistry(hKey, L"BThreshold", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: BThreshold not found in registry. Using default."));
			pDevExt->BThreshold = MAX_VALUE * 10/255;
		}
		else
		{
			pDevExt->BThreshold = MAX_VALUE * TempRegData[0]/255;
			if((pDevExt->BThreshold > MAX_VALUE) || (pDevExt->BThreshold == 0))
				pDevExt->BThreshold = MAX_VALUE * 10/255;
		}

		ReceivedDataLen = ReadRegistry(hKey, L"TThreshold", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: TThreshold not found in registry. Using default."));
			pDevExt->TThreshold = MAX_VALUE * 10/255;
		}
		else
		{
			pDevExt->TThreshold = MAX_VALUE * TempRegData[0]/255;
			if((pDevExt->TThreshold > MAX_VALUE) || (pDevExt->TThreshold == 0))
				pDevExt->TThreshold = MAX_VALUE * 10/255;
		}

		ReceivedDataLen = ReadRegistry(hKey, L"AThreshold", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: AThreshold not found in registry. Using default."));
			pDevExt->AThreshold = MAX_VALUE * 100/255;
		}
		else
		{
			pDevExt->AThreshold = MAX_VALUE * TempRegData[0]/255;
			if((pDevExt->AThreshold > MAX_VALUE) || (pDevExt->AThreshold == 0))
				pDevExt->AThreshold = MAX_VALUE * 100/255;
		}

		ReceivedDataLen = ReadRegistry(hKey, L"LStickDZ", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: LStickDZ not found in registry. Using default."));
			pDevExt->LStickDZ = 0;
		}
		else
		{
			pDevExt->LStickDZ = MAX_VALUE * TempRegData[0]/100;
			if(pDevExt->LStickDZ > MAX_VALUE)
				pDevExt->LStickDZ = MAX_VALUE;
		}

		ReceivedDataLen = ReadRegistry(hKey, L"RStickDZ", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: RStickDZ not found in registry. Using default."));
			pDevExt->RStickDZ = 0;
		}
		else
		{
			pDevExt->RStickDZ = MAX_VALUE * TempRegData[0]/100;
			if(pDevExt->RStickDZ > MAX_VALUE)
				pDevExt->RStickDZ = MAX_VALUE;
		}

		ReceivedDataLen = ReadRegistry(hKey, L"AxesScale", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != NR_OUT_AXES)
		{
			KdPrint(("XBCDReadConfig: AxesScale not found in registry. Using default."));
			for(index=0; index<NR_OUT_AXES; ++index)
			{
				pDevExt->AxesScale[index] = MAX_VALUE;
			}
		}
		else
		{
			for(index=0; index<NR_OUT_AXES; ++index)
			{
				pDevExt->AxesScale[index] = MAX_VALUE * TempRegData[index]/100;
				if(pDevExt->AxesScale[index] > MAX_VALUE)
					pDevExt->AxesScale[index] = MAX_VALUE;
			}
		}

		ReceivedDataLen = ReadRegistry(hKey, L"LFullRange", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: LFullRange not found in registry. Using default."));
			pDevExt->bFullRange[0] = FALSE;
		}
		else
		{
			pDevExt->bFullRange[0] = (BOOLEAN)TempRegData[0];
		}

		ReceivedDataLen = ReadRegistry(hKey, L"RFullRange", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: RFullRange not found in registry. Using default."));
			pDevExt->bFullRange[1] = FALSE;
		}
		else
		{
			pDevExt->bFullRange[1] = (BOOLEAN)TempRegData[0];
		}

		ReceivedDataLen = ReadRegistry(hKey, L"NButtons", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: NButtons not found in registry. Using default."));
			pDevExt->nButtons = NR_OUT_BUTTONS;
		}
		else
		{
			pDevExt->nButtons = (UCHAR)TempRegData[0];
			if(pDevExt->nButtons > NR_OUT_BUTTONS)
				pDevExt->nButtons = NR_OUT_BUTTONS;
			if(pDevExt->nButtons < 1)
				pDevExt->nButtons = 1;
		}

		ReceivedDataLen = ReadRegistry(hKey, L"LedSetting", TempRegData, sizeof(TempRegData));
		if(ReceivedDataLen != 4)
		{
			KdPrint(("XBCDReadConfig: LedSetting not found in registry. Using default."));
			pDevExt->LedSetting=6;
		}
		else
		{
			if (TempRegData[0]<0x01||TempRegData[0]>0x0D)
			{
				KdPrint(("XBCDReadConfig: LedSetting has invalid value. Using default."));
				pDevExt->LedSetting=6;
			}	
			else
				pDevExt->LedSetting=TempRegData[0];
		}

		/**********************************************************************/

		/* Close registry key opened by IoOpenDeviceRegistryKey */
		ZwClose(hKey);

		/* Update the LEDs on a 360 controller*/
		XBCDUpdate360Leds(pDevExt);
	}
	else
	{
		//Do nothing.  Keep the configuration already loaded.
	}
}

/* Read values from the registry.

Parameters:
HANDLE hKey          : Handle to the key containing the value
PCWSTR entry         : Unicode string specifying the value to retrieve
PUCHAR Values: Pointer to data buffer
unsigned int BufSize : Size of buffer in bytes

Returns: Number of bytes read if successful, -1 otherwise. */

#pragma PAGEDCODE
int ReadRegistry(HANDLE hKey, PCWSTR entry, PUCHAR Values, unsigned int BufSize)
{
	/* Since the length of data stored in the registry is unknown and cannot be
	queried in an elegant way, Vpi will be used as a dummy to find out the
	right amount of memory to allocate (the value will be written to the last
	parameter of ZwQueryValueKey). The pointer Pvpi will then be used to
	retrieve data. */

	KEY_VALUE_PARTIAL_INFORMATION Vpi;
	PKEY_VALUE_PARTIAL_INFORMATION Pvpi;

	NTSTATUS ntstatus;
	ULONG size = 0;
	UNICODE_STRING valname;
	int RawDataLen = -1;

	RtlInitUnicodeString(&valname, entry);

	/* DDK Quote: 'The ZwQueryValueKey routine returns the value entries for an
	open registry key.'
	Do a dummy request to find out the right size */

	ntstatus = ZwQueryValueKey(hKey, &valname, KeyValuePartialInformation, &Vpi, sizeof(Vpi), &size);

	// The minimum size is 16 bytes (length of the naked structure)
	if(size < sizeof(Vpi))
	{
		KdPrint(("ReadRegistry: Can't access value or get size."));
		return RawDataLen;
	}

	/* Determine the size of the 'raw' data. The value returned by
	ZwQueryValueKey is the size of the entire structure. Thus, the
	size of the other members has to be subtracted. */

	RawDataLen = size - sizeof(Pvpi->TitleIndex) - sizeof(Pvpi->Type) - sizeof(Pvpi->DataLength);

	/* Make sure the supplied buffer is big enough.
	(Comparing signed and unsigned int is not very pretty, though.) */

	if((int)BufSize >= RawDataLen)
	{
		// Try again with correct size. Yes, this IS weird.
		Pvpi = (PKEY_VALUE_PARTIAL_INFORMATION)ExAllocatePool(PagedPool, size);
		ntstatus = ZwQueryValueKey(hKey, &valname, KeyValuePartialInformation, Pvpi, size, &size);

		if(NT_SUCCESS(ntstatus))
		{
			RtlCopyMemory(Values, &Pvpi->Data, RawDataLen);
		}
		else RawDataLen = -1;

		ExFreePool(Pvpi);
	}
	else RawDataLen = -1;
	
	KdPrint(("ReadRegistry: Read %i bytes.", RawDataLen));
	return RawDataLen;
}

/* Insert default MapMatrix layout.

Parameters:
unsigned int* pMapMatrix : Pointer to MapMatrix array */

void setDefaultMapMatrix(unsigned int* pMapMatrix, BOOLEAN bWin9x, BOOLEAN b360)
{
	/* The mapping 'matrix' default layout.
	The philosophy is to map output items FROM semiaxes. Makes programming
	easy, since like that, the more special output items are generated
	from the uniform semiaxes.

	Anyway, this results in three things to take care of or keep in mind:
	  a. One output item can be assigned to one OR MORE semiaxes (e.g. different
		 buttons on the gamepad could trigger the same button in Windows)
	  b. The values in MapMatrix MUST NOT exceed the number of Windows controls!!!

    The default layout will be used, whenever retrieving data from the
	registry fails in any way. */

	static unsigned int DefMapMatrixNT[] =
	{
		// Dpad-Up
		39, //POV Up

		// Dpad-Down
		41, //POV Down

		// Dpad-Left
		42, //POV Left

		// Dpad-Right
		40, //POV Right

		// Start
		7, //Button 7

		// Back
		8, //Button 8

		// LS-Press
		9, //Button 9

		// RS-Press
		10, //Button 10

		// A
		1, //Button 1

		// B
		2, //Button 2

		// X
		3, //Button 3

		// Y
		4, //Button 4

		// Black/L-Bumper
		5, //Button 5

		// White/R-Bumper
		6, //Button 6

		// L-Trigger
		11, //Button 11

		// R-Trigger
		12, //Button 12

		// LS-X(-)
		25, //X-

		// LS-X(+)
		26, //X+

		// LS-Y(-)
		28, //Y+

		// LS-Y(+)
		27, //Y-

		// RS-X(-)
		31, //RX-

		// RS-X(+)
		32, //RX+

		// RS-Y(-)
		34, //RY+

		// RS-Y(+)
		33  //RY-
	};

	static unsigned int DefMapMatrix9x[] =
	{
		// Dpad-Up
		39, //POV Up

		// Dpad-Down
		41, //POV Down

		// Dpad-Left
		42, //POV Left

		// Dpad-Right
		40, //POV Right

		// Start
		7, //Button 7

		// Back
		8, //Button 8

		// LS-Press
		9, //Button 9

		// RS-Press
		10, //Button 10

		// A
		1, //Button 1

		// B
		2, //Button 2

		// X
		3, //Button 3

		// Y
		4, //Button 4

		// Black/L-Bumper
		5, //Button 5

		// White/R-Bumper
		6, //Button 6

		// L-Trigger
		11, //Button 11

		// R-Trigger
		12, //Button 12

		// LS-X(-)
		25, //X-

		// LS-X(+)
		26, //X+

		// LS-Y(-)
		28, //Y+

		// LS-Y(+)
		27, //Y-

		// RS-X(-)
		35, //RZ-

		// RS-X(+)
		36, //RZ+

		// RS-Y(-)
		30, //Z+

		// RS-Y(+)
		29  //Z-
	};

	unsigned int index;

	if(bWin9x)
	{
		for(index=0; index!=MAP_MATRIX_SIZE; ++index)
		{
			pMapMatrix[index] = DefMapMatrix9x[index];
		}
	}
	else
	{
		for(index=0; index!=MAP_MATRIX_SIZE; ++index)
		{
			pMapMatrix[index] = DefMapMatrixNT[index];
		}
	}
}

NTSTATUS XBCDUpdate360Leds (PDEVICE_EXTENSION pDevExt)
{
	NTSTATUS status=STATUS_SUCCESS;
	// if this is a 360 pad, mess with the leds
	if(pDevExt->is360)
	{
		// hardwired values
		pDevExt->hwOutData[0]=0x01;
		pDevExt->hwOutData[1]=0x03;

		// set the led mode
		pDevExt->hwOutData[2]=pDevExt->LedSetting;

		status = DeviceWrite(pDevExt, 3/*, pIrp*/);
		if(!NT_SUCCESS(status))
		{
			KdPrint(("XBCDStartDevice - Could not set controller LEDs"));
			KdPrint(("XBCDStartDevice - DeviceWrite returned %X", status));
		}
	}
	return status;
}

#pragma LOCKEDCODE
