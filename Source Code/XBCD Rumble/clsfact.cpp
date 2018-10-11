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
 *  CFact.c
 *
 *  Abstract:
 *
 *      Class factory.
 *
 *****************************************************************************/

#include "effdrv.h"

struct CClassFactory : IClassFactory
{
	/*** IUnknown methods ***/
    STDMETHODIMP QueryInterface(REFIID, LPVOID*);
    STDMETHODIMP_(ULONG) AddRef(VOID);
    STDMETHODIMP_(ULONG) Release(VOID);

	/*** IClassFactory methods ***/
	STDMETHODIMP CreateInstance(IUnknown*, REFIID, LPVOID*);
	STDMETHODIMP LockServer(BOOL);

	CClassFactory(VOID);

	ULONG cRef; /* Object reference count */
};

inline CClassFactory::CClassFactory(VOID)
{
	cRef = 1;
}

/*****************************************************************************
 *
 *      CClassFactory_AddRef
 *
 *      Optimization: Since the class factory is static, reference
 *      counting can be shunted to the DLL itself.
 *
 *****************************************************************************/

ULONG CClassFactory::AddRef()
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
 *      CClassFactory_Release
 *
 *      Optimization: Since the class factory is static, reference
 *      counting can be shunted to the DLL itself.
 *
 *****************************************************************************/

ULONG CClassFactory::Release()
{
	ULONG ulRc;

	DebugPrint("Entry");

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
 *      CClassFactory_QueryInterface
 *
 *      Our QI is very simple because we support no interfaces beyond
 *      ourselves.
 *
 *****************************************************************************/

HRESULT CClassFactory::QueryInterface(REFIID riid, LPVOID *ppvOut)
{
    HRESULT hres;

	DebugPrint("Entry");

    if ((riid == IID_IUnknown) || (riid == IID_IClassFactory))
	{
        AddRef();
        *ppvOut = (IClassFactory *)this;
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
 *      CClassFactory_CreateInstance
 *
 *      Create the effect driver object itself.
 *
 *****************************************************************************/

HRESULT CClassFactory::CreateInstance(IUnknown *punkOuter, REFIID riid, LPVOID *ppvObj)
{
    HRESULT hres;

	DebugPrint("Entry");

    if (punkOuter == 0) {
        hres = CEffDrv_New(riid, ppvObj);
    } else {
        /*
         *  We don't support aggregation.
         */
        hres = CLASS_E_NOAGGREGATION;
    }

	DebugPrint("Exit");

    return hres;
}

/*****************************************************************************
 *
 *      CClassFactory_LockServer
 *
 *****************************************************************************/

HRESULT CClassFactory::LockServer(BOOL fLock)
{

	DebugPrint("Entry");

    if (fLock) {
		InterlockedIncrement((LPLONG)&cRef);
    } else {
		InterlockedDecrement((LPLONG)&cRef);
    }

	DebugPrint("Exit");

    return S_OK;
}

/*****************************************************************************
 *
 *      CClassFactory_New
 *
 *****************************************************************************/

STDMETHODIMP
CClassFactory_New(REFIID riid, LPVOID *ppvOut)
{
    HRESULT hres;
	CClassFactory *ppvNew;

	DebugPrint("Entry");

	*ppvOut = 0;

	ppvNew = new CClassFactory;

	if(ppvNew)
	{
		/*
		*  Attempt to obtain the desired interface.  QueryInterface
		*  will do an AddRef if it succeeds.
		*/
		hres = ppvNew->QueryInterface(riid, ppvOut);
		ppvNew->Release();
		hres = NOERROR;
	}
	else
	{
		hres = E_OUTOFMEMORY;
		DebugPrint("Out of Memory");
	}

	DebugPrint("Exit");

    return hres;

}
