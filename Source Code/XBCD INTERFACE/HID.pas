{******************************************************************}
{                                                                  }
{       Borland Delphi Runtime Library                             }
{       Public Definitions of HID functions from HID.DLL           }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file are: hidsdi.h, hidpi.h, released March 1999.   }
{ The original Pascal code is: Hid.pas, released 29 Jan 2000.      }
{ The initial developer of the Pascal code is Robert Marquardt     }
{ (robert_marquardt@gmx.de)                                        }
{                                                                  }
{ Portions created by Robert Marquardt are                         }
{ Copyright (C) 1999, 2000 Robert Marquardt.                       }
{                                                                  }
{ Contributor(s): Marcel van Brakel (brakelm@bart.nl)              }
{                                                                  }
{ Obtained through:                                                }
{ Joint Endeavour of Delphi Innovators (Project JEDI)              }
{                                                                  }
{ You may retrieve the latest version of this file at the Project  }
{ JEDI home page, located at http://delphi-jedi.org                }
{                                                                  }
{ The contents of this file are used with permission, subject to   }
{ the Mozilla Public License Version 1.1 (the "License"); you may  }
{ not use this file except in compliance with the License. You may }
{ obtain a copy of the License at                                  }
{ http://www.mozilla.org/NPL/NPL-1_1Final.html                     }
{                                                                  }
{ Software distributed under the License is distributed on an      }
{ "AS IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or   }
{ implied. See the License for the specific language governing     }
{ rights and limitations under the License.                        }
{                                                                  }
{******************************************************************}

unit Hid;

{$WEAKPACKAGEUNIT}

interface

(*$HPPEMIT ''*)
(*$HPPEMIT '#include "hidusage.h"'*)
(*$HPPEMIT '#include "hidpi.h"'*)
(*$HPPEMIT ''*)

uses
  Windows;

type
  // (rom) moved from HidUsage.pas
  PUsage = ^TUsage;
  TUsage = Word;

  // (rom) from WINNT.H
  NTSTATUS = LongInt;
  {$EXTERNALSYM NTSTATUS}

// FACILITY_HID_ERROR_CODE defined in ntstatus.h
const
  FACILITY_HID_ERROR_CODE = $11;
  {$EXTERNALSYM FACILITY_HID_ERROR_CODE}

  //
  // Define NT Status codes with Facility Code of FACILITY_HID_ERROR_CODE
  // (rom)                                           vv
  HIDP_STATUS_SUCCESS                  = NTSTATUS($00110000);
  {$EXTERNALSYM HIDP_STATUS_SUCCESS}
  HIDP_STATUS_NULL                     = NTSTATUS($80110001);
  {$EXTERNALSYM HIDP_STATUS_NULL}
  HIDP_STATUS_INVALID_PREPARSED_DATA   = NTSTATUS($C0110001);
  {$EXTERNALSYM HIDP_STATUS_INVALID_PREPARSED_DATA}
  HIDP_STATUS_INVALID_REPORT_TYPE      = NTSTATUS($C0110002);
  {$EXTERNALSYM HIDP_STATUS_INVALID_REPORT_TYPE}
  HIDP_STATUS_INVALID_REPORT_LENGTH    = NTSTATUS($C0110003);
  {$EXTERNALSYM HIDP_STATUS_INVALID_REPORT_LENGTH}
  HIDP_STATUS_USAGE_NOT_FOUND          = NTSTATUS($C0110004);
  {$EXTERNALSYM HIDP_STATUS_USAGE_NOT_FOUND}
  HIDP_STATUS_VALUE_OUT_OF_RANGE       = NTSTATUS($C0110005);
  {$EXTERNALSYM HIDP_STATUS_VALUE_OUT_OF_RANGE}
  HIDP_STATUS_BAD_LOG_PHY_VALUES       = NTSTATUS($C0110006);
  {$EXTERNALSYM HIDP_STATUS_BAD_LOG_PHY_VALUES}
  HIDP_STATUS_BUFFER_TOO_SMALL         = NTSTATUS($C0110007);
  {$EXTERNALSYM HIDP_STATUS_BUFFER_TOO_SMALL}
  HIDP_STATUS_INTERNAL_ERROR           = NTSTATUS($C0110008);
  {$EXTERNALSYM HIDP_STATUS_INTERNAL_ERROR}
  HIDP_STATUS_I8042_TRANS_UNKNOWN      = NTSTATUS($C0110009);
  {$EXTERNALSYM HIDP_STATUS_I8042_TRANS_UNKNOWN}
  HIDP_STATUS_INCOMPATIBLE_REPORT_ID   = NTSTATUS($C011000A);
  {$EXTERNALSYM HIDP_STATUS_INCOMPATIBLE_REPORT_ID}
  HIDP_STATUS_NOT_VALUE_ARRAY          = NTSTATUS($C011000B);
  {$EXTERNALSYM HIDP_STATUS_NOT_VALUE_ARRAY}
  HIDP_STATUS_IS_VALUE_ARRAY           = NTSTATUS($C011000C);
  {$EXTERNALSYM HIDP_STATUS_IS_VALUE_ARRAY}
  HIDP_STATUS_DATA_INDEX_NOT_FOUND     = NTSTATUS($C011000D);
  {$EXTERNALSYM HIDP_STATUS_DATA_INDEX_NOT_FOUND}
  HIDP_STATUS_DATA_INDEX_OUT_OF_RANGE  = NTSTATUS($C011000E);
  {$EXTERNALSYM HIDP_STATUS_DATA_INDEX_OUT_OF_RANGE}
  HIDP_STATUS_BUTTON_NOT_PRESSED       = NTSTATUS($C011000F);
  {$EXTERNALSYM HIDP_STATUS_BUTTON_NOT_PRESSED}
  HIDP_STATUS_REPORT_DOES_NOT_EXIST    = NTSTATUS($C0110010);
  {$EXTERNALSYM HIDP_STATUS_REPORT_DOES_NOT_EXIST}
  HIDP_STATUS_NOT_IMPLEMENTED          = NTSTATUS($C0110020);
  {$EXTERNALSYM HIDP_STATUS_NOT_IMPLEMENTED}
  //
  // We blundered this status code.
  //
  HIDP_STATUS_I8242_TRANS_UNKNOWN      = HIDP_STATUS_I8042_TRANS_UNKNOWN;
  {$EXTERNALSYM HIDP_STATUS_I8242_TRANS_UNKNOWN}

  // Special Link collection values for using the query functions
  //
  // Root collection references the collection at the base of the link
  // collection tree.
  // Unspecifies, references all collections in the link collection tree.

  HIDP_LINK_COLLECTION_ROOT        = -1;
  {$EXTERNALSYM HIDP_LINK_COLLECTION_ROOT}
  HIDP_LINK_COLLECTION_UNSPECIFIED =  0;
  {$EXTERNALSYM HIDP_LINK_COLLECTION_UNSPECIFIED}

  // A bitmap of the current shift state of the keyboard when using the
  // below keyboard usages to i8042 translation function.

const
  // (rom) values for the bits of THIDPKeyboardModifierState
  kmsLeftControl  = $0001;
  kmsLeftShift    = $0002;
  kmsLeftAlt      = $0004;
  kmsLeftGUI      = $0008;
  kmsRightControl = $0010;
  kmsRightShift   = $0020;
  kmsRightAlt     = $0040;
  kmsRightGUI     = $0080;
  kmsCapsLock     = $0100;
  kmsScollLock    = $0200;
  kmsNumLock      = $0400;
type
  THIDPKeyboardModifierState = DWORD;
  {$EXTERNALSYM THIDPKeyboardModifierState}

  // (rom) bit value to check IsAlias of THIDPLinkCollectionNode
const
  lcnIsAlias = 1;

type
  // (rom) to represent the union names
  THIDVariantFlags = (Range, NotRange);

  PHIDDConfiguration = ^THIDDConfiguration;
  _HIDD_CONFIGURATION = packed record
    cookie:         Pointer;
    size:           ULONG;
    RingBufferSize: ULONG;
  end;
  {$EXTERNALSYM _HIDD_CONFIGURATION}
  THIDDConfiguration = _HIDD_CONFIGURATION;

  PHIDDAttributes = ^THIDDAttributes;
  _HIDD_ATTRIBUTES = packed record
    Size:          ULONG; // size of structure (set before call)
    VendorID:      Word;
    ProductID:     Word;
    VersionNumber: Word;
    //
    // Additional fields will be added to the end of this structure.
    //
  end;
  {$EXTERNALSYM _HIDD_ATTRIBUTES}
  THIDDAttributes = _HIDD_ATTRIBUTES;

  // (rom) should be Pointer but Delphi 4 objects if used as published property
  PHIDPPreparsedData = DWORD;
  {$EXTERNALSYM PHIDPPreparsedData}

const
  HidP_Input   = 0;
  {$EXTERNALSYM HidP_Input}
  HidP_Output  = 1;
  {$EXTERNALSYM HidP_Output}
  HidP_Feature = 2;
  {$EXTERNALSYM HidP_Feature}

type
  PHIDPReportType = ^THIDPReportType;
  THIDPReportType = DWORD;

const
  // Produce Make or Break Codes
  HidP_Keyboard_Break = 0;
  {$EXTERNALSYM HidP_Keyboard_Break}
  HidP_Keyboard_Make  = 1;
  {$EXTERNALSYM HidP_Keyboard_Make}
type
  PHIDPKeyboardDirection = ^THIDPKeyboardDirection;
  THIDPKeyboardDirection = DWORD;

  PUsageAndPage = ^TUsageAndPage;
  _USAGE_AND_PAGE = packed record
    Usage:     TUsage;
    UsagePage: TUsage;
  end;
  {$EXTERNALSYM _USAGE_AND_PAGE}
  TUsageAndPage = _USAGE_AND_PAGE;

  PHIDPButtonCaps = ^THIDPButtonCaps;
  _HIDP_BUTTON_CAPS = packed record
    UsagePage:         TUsage;
    ReportID:          BYTE;
    IsAlias:           ByteBool;

    BitField:          Word;
    LinkCollection:    Word;   // A unique internal index pointer

    LinkUsage:         TUsage;
    LinkUsagePage:     TUsage;

    IsRange:           ByteBool;
    IsStringRange:     ByteBool;
    IsDesignatorRange: ByteBool;
    IsAbsolute:        ByteBool;

    Reserved:          array [0..9] of ULONG;

  case THIDVariantFlags of
    Range:
      ( UsageMin,         UsageMax:      TUsage;
        StringMin,        StringMax,
        DesignatorMin,    DesignatorMax,
        DataIndexMin,     DataIndexMax:  Word );
    NotRange:
      ( Usage,            Reserved1:     TUsage;
        StringIndex,      Reserved2,
        DesignatorIndex,  Reserved3,
        DataIndex,        Reserved4:     Word );
  end;
  {$EXTERNALSYM _HIDP_BUTTON_CAPS}
  THIDPButtonCaps = _HIDP_BUTTON_CAPS;

  PHIDPValueCaps = ^THIDPValueCaps;
  _HIDP_VALUE_CAPS = packed record
    UsagePage:         TUsage;
    ReportID:          BYTE;
    IsAlias:           ByteBool;

    BitField:          Word;
    LinkCollection:    Word;   // A unique internal index pointer

    LinkUsage:         TUsage;
    LinkUsagePage:     TUsage;

    IsRange:           ByteBool;
    IsStringRange:     ByteBool;
    IsDesignatorRange: ByteBool;
    IsAbsolute:        ByteBool;

    HasNull:           ByteBool;        // Does this channel have a null report   union
    Reserved:          BYTE;
    BitSize:           Word;            // How many bits are devoted to this value?

    ReportCount:       Word;            // See Note below.  Usually set to 1.
    Reserved_:         array [0..4] of Word;
                                        // (rom) name change Reserved2 gives name clash in Pascal
    UnitsExp:          ULONG;
    Units:             ULONG;

    LogicalMin:        Integer;
    LogicalMax:        Integer;
    PhysicalMin:       Integer;
    PhysicalMax:       Integer;

  case THIDVariantFlags of
    Range:
      ( UsageMin,         UsageMax:      TUsage;
        StringMin,        StringMax,
        DesignatorMin,    DesignatorMax,
        DataIndexMin,     DataIndexMax:  Word );
    NotRange:
      ( Usage,            Reserved1:     TUsage;
        StringIndex,      Reserved2,
        DesignatorIndex,  Reserved3,
        DataIndex,        Reserved4:     Word );
  end;
  {$EXTERNALSYM _HIDP_VALUE_CAPS}
  THIDPValueCaps = _HIDP_VALUE_CAPS;

//
// Notes:
//
// ReportCount:  When a report descriptor declares an Input, Output, or
// Feature main item with fewer usage declarations than the report count, then
// the last usage applies to all remaining unspecified count in that main item.
// (As an example you might have data that required many fields to describe,
// possibly buffered bytes.)  In this case, only one value cap structure is
// allocated for these associtated fields, all with the same usage, and Report
// Count reflects the number of fields involved.  Normally ReportCount is 1.
// To access all of the fields in such a value structure would require using
// HidP_GetUsageValueArray and HidP_SetUsageValueArray.   HidP_GetUsageValue/
// HidP_SetScaledUsageValue will also work, however, these functions will only
// work with the first field of the structure.
//

//
// The link collection tree consists of an array of LINK_COLLECTION_NODES
// where the index into this array is the same as the collection number.
//
// Given a collection A which contains a subcollection B, A is defined to be
// the parent B, and B is defined to be the child.
//
// Given collections A, B, and C where B and C are children of A, and B was
// encountered before C in the report descriptor, B is defined as a sibling of
// C.  (This implies, of course, that if B is a sibling of C, then C is NOT a
// sibling of B).
//
// B is defined as the NextSibling of C if and only if there exists NO
// child collection of A, call it D, such that B is a sibling of D and D
// is a sibling of C.
//
// E is defined to be the FirstChild of A if and only if for all children of A,
// F, that are not equivalent to E, F is a sibling of E.
// (This implies, of course, that the does not exist a child of A, call it G,
// where E is a sibling of G).  In other words the first sibling is the last
// link collection found in the list.
//
// In other words, if a collection B is defined within the definition of another
// collection A, B becomes a child of A.  All collections with the same parent
// are considered siblings.  The FirstChild of the parent collection, A, will be
// last collection defined that has A as a parent.  The order of sibling pointers
// is similarly determined.  When a collection B is defined, it becomes the
// FirstChild of it's parent collection.  The previously defined FirstChild of the
// parent collection becomes the NextSibling of the new collection.  As new
// collections with the same parent are discovered, the chain of sibling is built.
//
// With that in mind, the following describes conclusively a data structure
// that provides direct traversal up, down, and accross the link collection
// tree.

  PHIDPLinkCollectionNode = ^THIDPLinkCollectionNode;
  _HIDP_LINK_COLLECTION_NODE = packed record
    LinkUsage:        TUsage;
    LinkUsagePage:    TUsage;
    Parent:           Word;
    NumberOfChildren: Word;
    NextSibling:      Word;
    FirstChild:       Word;
    CollectionType:   BYTE;    // As defined in 6.2.2.6 of HID spec
    IsAlias:          BYTE;    // This link node is an alias of the next link node.
    Reserved:         Word;    // (rom) bitfields
    UserContext:      Pointer; // The user can hang his coat here.
  end;
  {$EXTERNALSYM _HIDP_LINK_COLLECTION_NODE}
  THIDPLinkCollectionNode = _HIDP_LINK_COLLECTION_NODE;

//
// When a link collection is described by a delimiter, alias link collection
// nodes are created.  (One for each usage within the delimiter).
// The parser assigns each capability description listed above only one
// link collection.
//
// If a control is defined within a collection defined by
// delimited usages, then that control is said to be within multiple link
// collections, one for each usage within the open and close delimiter tokens.
// Such multiple link collecions are said to be aliases.  The first N-1 such
// collections, listed in the link collection node array, have their IsAlias
// bit set.  The last such link collection is the link collection index used
// in the capabilities described above.
// Clients wishing to set a control in an aliased collection, should walk the
// collection array once for each time they see the IsAlias flag set, and use
// the last link collection as the index for the below accessor functions.
//
// NB: if IsAlias is set, then NextSibling should be one more than the current
// link collection node index.

  PHIDPReportDescriptor = PChar;

  PHIDPCaps = ^THIDPCaps;
  _HIDP_CAPS = packed record
    Usage:                     TUsage;
    UsagePage:                 TUsage;
    InputReportByteLength:     Word;
    OutputReportByteLength:    Word;
    FeatureReportByteLength:   Word;
    Reserved:                  array [0..16] of Word;

    NumberLinkCollectionNodes: Word;

    NumberInputButtonCaps:     Word;
    NumberInputValueCaps:      Word;
    NumberInputDataIndices:    Word;

    NumberOutputButtonCaps:    Word;
    NumberOutputValueCaps:     Word;
    NumberOutputDataIndices:   Word;

    NumberFeatureButtonCaps:   Word;
    NumberFeatureValueCaps:    Word;
    NumberFeatureDataIndices:  Word;
  end;
  {$EXTERNALSYM _HIDP_CAPS}
  THIDPCaps = _HIDP_CAPS;

  PHIDPData = ^THIDPData;
  _HIDP_DATA = packed record
    DataIndex: Word;
    Reserved:  Word;
  case Integer of
    0: (RawValue: ULONG);      // for values
    1: (On_:      ByteBool);   // for buttons MUST BE TRUE for buttons.
                               // (rom) name change On is reserved in Pascal
  end;
  {$EXTERNALSYM _HIDP_DATA}
  THIDPData = _HIDP_DATA;

// The HIDP_DATA structure is used with HidP_GetData and HidP_SetData
// functions.
//
// The parser contiguously assigns every control (button or value) in a hid
// device a unique data index from zero to NumberXXXDataIndices -1 , inclusive.
// This value is found in the HIDP_BUTTON_CAPS and HIDP_VALUE_CAPS structures.
//
// Most clients will find the Get/Set Buttons / Value accessor functions
// sufficient to their needs, as they will allow the clients to access the
// data known to them while ignoring the other controls.
//
// More complex clients, which actually read the Button / Value Caps, and which
// do a value add service to these routines (EG Direct Input), will need to
// access all the data in the device without interest in the individual usage
// or link collection location.  These are the clients that will find
// HidP_Data useful.

  PHIDPUnknownToken = ^THIDPUnknownToken;
  {$EXTERNALSYM PHIDPUnknownToken}
  _HIDP_UNKNOWN_TOKEN = packed record
    Token:    BYTE;
    Reserved: array [0..2] of BYTE;
    BitField: DWORD;
  end;
  {$EXTERNALSYM _HIDP_UNKNOWN_TOKEN}
  THIDPUnknownToken = _HIDP_UNKNOWN_TOKEN;

  PHIDPExtendedAttributes = ^THIDPExtendedAttributes;
  _HIDP_EXTENDED_ATTRIBUTES = packed record
    NumGlobalUnknowns: BYTE;
    Reserved:          array [0..2] of BYTE;
    GlobalUnknowns:    PHIDPUnknownToken;
    // ... Additional attributes
    Data:              array [0..0] of ULONG; // variableLength  DO NOT ACCESS THIS FIELD
  end;
  {$EXTERNALSYM _HIDP_EXTENDED_ATTRIBUTES}
  THIDPExtendedAttributes = _HIDP_EXTENDED_ATTRIBUTES;

  // (rom) callback function type for HidP_TranslateUsagesToI8042ScanCodes param
  // (rom) maybe calling convention is incorrect
  THIDPInsertScanCodes = function(
    Context:      Pointer; // Some caller supplied context
    NewScanCodes: PChar;   // A list of i8042 scan codes
    Length:       ULONG    // the length of the scan code list
   ): Boolean; stdcall;

// (rom) undocumented easter egg function
// (rom) fills buffer with "Hello\nI hate Jello\n"
// (rom) returns number of bytes filled in == strlen(Buffer)+1 == 20
// (rom) bugs: handing in nil as buffer gives access violation.
// (rom)       always returns 20 even if buffer length is less than 20
// (rom)       but does not produce buffer overflow

function HidD_Hello(Buffer: PChar; BufferLength: ULONG): ULONG; stdcall;

procedure HidD_GetHidGuid(var HidGuid: TGUID) stdcall;
{$EXTERNALSYM HidD_GetHidGuid}

function HidD_GetPreparsedData(HidDeviceObject: THandle;
  var PreparsedData: PHIDPPreparsedData): LongBool; stdcall;
{$EXTERNALSYM HidD_GetPreparsedData}

function HidD_FreePreparsedData(PreparsedData: PHIDPPreparsedData): LongBool; stdcall;
{$EXTERNALSYM HidD_FreePreparsedData}

// Routine Description:
//     Get the configuration information for this Hid device
//
// Arguments:
//    HidDeviceObject      A handle to a Hid Device Object.
//
//    Configuration        A configuration structure.  HidD_GetConfiguration MUST
//                         be called before the configuration can be modified and
//                         set using HidD_SetConfiguration
//
//    ConfigurationLength  That is ``sizeof (HIDD_CONFIGURATION)''. Using this
//                         parameter, we can later increase the length of the
//                         configuration array and not break older apps.
//
// Return Value:
//    TRUE if successful
//    FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_GetConfiguration(HidDeviceObject: THandle;
  var HidConfig: THIDDConfiguration; Size: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_GetConfiguration}

// Routine Description:
//    Set the configuration information for this Hid device...
//
//    NOTE: HidD_GetConfiguration must be called to retrieve the current
//          configuration information before this information can be modified
//          and set.
//
// Arguments:
//     HidDeviceObject      A handle to a Hid Device Object.
//
//     Configuration        A configuration structure.  HidD_GetConfiguration MUST
//                          be called before the configuration can be modified and
//                          set using HidD_SetConfiguration
//
//     ConfigurationLength  That is ``sizeof (HIDD_CONFIGURATION)''. Using this
//                          parameter, we can later increase the length of the
//                          configuration array and not break older apps.
//
// Return Value:
//     TRUE if successful
//     FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_SetConfiguration(HidDeviceObject: THandle;
  var HidConfig: THIDDConfiguration; Size: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_SetConfiguration}

// Routine Description:
//     Flush the input queue for the given HID device.
//
// Arguments:
//    HidDeviceObject A handle to a Hid Device that the client obtains using
//                    a call to CreateFile on a valid Hid device string name.
//                    The string name can be obtained using standard PnP calls.
//
// Return Value:
//    TRUE if successful
//    FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_FlushQueue(HidDeviceObject: THandle): LongBool; stdcall;
{$EXTERNALSYM HidD_FlushQueue}

// Routine Description:
//     Retrieve a feature report from a HID device.
//
// Arguments:
//     HidDeviceObject      A handle to a Hid Device Object.
//
//     ReportBuffer         The buffer that the feature report should be placed
//                          into.  The first byte of the buffer should be set to
//                          the report ID of the desired report
//
//     ReportBufferLength   The size (in bytes) of ReportBuffer.  This value
//                          should be greater than or equal to the
//                          FeatureReportByteLength field as specified in the
//                          HIDP_CAPS structure for the device
// Return Value:
//     TRUE if successful
//     FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_GetFeature(HidDeviceObject: THandle;
  var Report; Size: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_GetFeature}

// Routine Description:
//     Send a feature report to a HID device.
//
// Arguments:
//     HidDeviceObject      A handle to a Hid Device Object.
//
//     ReportBuffer         The buffer of the feature report to send to the device
//
//     ReportBufferLength   The size (in bytes) of ReportBuffer.  This value
//                          should be greater than or equal to the
//                          FeatureReportByteLength field as specified in the
//                          HIDP_CAPS structure for the device
// Return Value:
//     TRUE if successful
//     FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_SetFeature(HidDeviceObject: THandle;
  var Report; Size: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_SetFeature}

// Routine Description:
//     This function returns the number of input buffers used by the specified
//     file handle to the Hid device.  Each file object has a number of buffers
//     associated with it to queue reports read from the device but which have
//     not yet been read by the user-mode app with a handle to that device.
//
// Arguments:
//     HidDeviceObject      A handle to a Hid Device Object.
//
//     NumberBuffers        Number of buffers currently being used for this file
//                          handle to the Hid device
//
// Return Value:
//     TRUE if successful
//     FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_GetNumInputBuffers(HidDeviceObject: THandle;
  var NumBufs: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_GetNumInputBuffers}

// Routine Description:
//     This function sets the number of input buffers used by the specified
//     file handle to the Hid device.  Each file object has a number of buffers
//     associated with it to queue reports read from the device but which have
//     not yet been read by the user-mode app with a handle to that device.
//
// Arguments:
//     HidDeviceObject      A handle to a Hid Device Object.
//
//     NumberBuffers        New number of buffers to use for this file handle to
//                          the Hid device
//
// Return Value:
//     TRUE if successful
//     FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_SetNumInputBuffers(HidDeviceObject: THandle;
  NumBufs: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_SetNumInputBuffers}

// Routine Description:
//     Given a handle to a valid Hid Class Device Object, retrieve the preparsed
//     data for the device.  This routine will allocate the appropriately
//     sized buffer to hold this preparsed data.  It is up to client to call
//     HidD_FreePreparsedData to free the memory allocated to this structure when
//     it is no longer needed.
//
// Arguments:
//    HidDeviceObject A handle to a Hid Device that the client obtains using
//                    a call to CreateFile on a valid Hid device string name.
//                    The string name can be obtained using standard PnP calls.
//
//    PreparsedData   An opaque data structure used by other functions in this
//                    library to retrieve information about a given device.
//
// Return Value:
//    TRUE if successful.
//    FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_GetAttributes(HidDeviceObject: THandle;
  var HidAttrs: THIDDAttributes): LongBool; stdcall;
{$EXTERNALSYM HidD_GetAttributes}

// Routine Description:
//     This function retrieves the manufacturer string from the specified
//     Hid device.
//
// Arguments:
//     HidDeviceObject      A handle to a Hid Device Object.
//
//     Buffer               Buffer which on return will contain the manufacturer
//                          string returned from the device.  This string is a
//                          wide-character string
//
//     BufferLength         Length of Buffer (in bytes)
//
// Return Value:
//     TRUE if successful
//     FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_GetManufacturerString(HidDeviceObject: THandle;
  Buffer: PWideChar; BufferLength: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_GetManufacturerString}

// Routine Description:
//     This function retrieves the product string from the specified
//     Hid device.
//
// Arguments:
//     HidDeviceObject      A handle to a Hid Device Object.
//
//     Buffer               Buffer which on return will contain the product
//                          string returned from the device.  This string is a
//                          wide-character string
//
//     BufferLength         Length of Buffer (in bytes)
//
// Return Value:
//     TRUE if successful
//     FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_GetProductString(HidDeviceObject: THandle;
  Buffer: PWideChar; BufferLength: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_GetProductString}

// Routine Description:
//     This function retrieves the serial number string from the specified
//     Hid device.
//
// Arguments:
//     HidDeviceObject      A handle to a Hid Device Object.
//
//     Buffer               Buffer which on return will contain the serial number
//                          string returned from the device.  This string is a
//                          wide-character string
//
//     BufferLength         Length of Buffer (in bytes)
//
// Return Value:
//     TRUE if successful
//     FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_GetSerialNumberString(HidDeviceObject: THandle;
  Buffer: PWideChar; BufferLength: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_GetSerialNumberString}

// Routine Description:
//     This function retrieves the raw physical descriptor for the specified
//     Hid device.
//
// Arguments:
//     HidDeviceObject      A handle to a Hid Device Object.
//
//     Buffer               Buffer which on return will contain the physical
//                          descriptor if one exists for the specified device
//                          handle
//
//     BufferLength         Length of buffer (in bytes)
//
// Return Value:
//     TRUE if successful
//     FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_GetPhysicalDescriptor(HidDeviceObject: THandle;
  var Buffer; BufferLength: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_GetPhysicalDescriptor}

// Routine Description:
//     This function retrieves a string from the specified Hid device that is
//     specified with a certain string index.
//
// Arguments:
//     HidDeviceObject      A handle to a Hid Device Object.
//
//     StringIndex          Index of the string to retrieve
//
//     Buffer               Buffer which on return will contain the product
//                          string returned from the device.  This string is a
//                          wide-character string
//
//     BufferLength         Length of Buffer (in bytes)
//
// Return Value:
//     TRUE if successful
//     FALSE otherwise  -- Use GetLastError() to get extended error information

function HidD_GetIndexedString(HidDeviceObject: THandle;
  Index: Integer; Buffer: PWideChar; BufferLength: Integer): LongBool; stdcall;
{$EXTERNALSYM HidD_GetIndexedString}

// Routine Description:
//    Returns a list of capabilities of a given hid device as described by its
//    preparsed data.
// 
// Arguments:
//    PreparsedData    The preparsed data returned from HIDCLASS.
//    Capabilities     a HIDP_CAPS structure
// 
// Return Value:
// -  HIDP_STATUS_SUCCESS
// -  HIDP_STATUS_INVALID_PREPARSED_DATA

function HidP_GetCaps(PreparsedData: PHIDPPreparsedData;
  var Capabilities: THIDPCaps): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetCaps}

// Routine Description:
//    Return a list of PHIDP_LINK_COLLECTION_NODEs used to describe the link
//    collection tree of this hid device.  See the above description of
//    struct _HIDP_LINK_COLLECTION_NODE.
// 
// Arguments:
//    LinkCollectionNodes - a caller allocated array into which
//                  HidP_GetLinkCollectionNodes will store the information
// 
//    LinkCollectionNodesLength - the caller sets this value to the length of the
//                  the array in terms of number of elements.
//                  HidP_GetLinkCollectionNodes sets this value to the actual
//                  number of elements set. The total number of nodes required to
//                  describe this HID device can be found in the
//                  NumberLinkCollectionNodes field in the HIDP_CAPS structure.

function HidP_GetLinkCollectionNodes(LinkCollectionNodes: PHIDPLinkCollectionNode;
  var LinkCollectionNodesLength: ULONG; PreparsedData: PHIDPPreparsedData): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetLinkCollectionNodes}

function HidP_GetSpecificButtonCaps(ReportType: THIDPReportType;
  UsagePage: TUsage; LinkCollection: Word; Usage: TUsage; ButtonCaps: PHIDPButtonCaps;
  var ButtonCapsLength: Word; PreparsedData: PHIDPPreparsedData): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetSpecificButtonCaps}

// Description:
//    HidP_GetButtonCaps returns all the buttons (binary values) that are a part
//    of the given report type for the Hid device represented by the given
//    preparsed data.
// 
// Parameters:
//    ReportType  One of HidP_Input, HidP_Output, or HidP_Feature.
// 
//    UsagePage   A usage page value used to limit the button caps returned to
//                 those on a given usage page.  If set to 0, this parameter is
//                 ignored.  Can be used with LinkCollection and Usage parameters
//                 to further limit the number of button caps structures returned.
// 
//    LinkCollection HIDP_LINK_COLLECTION node array index used to limit the
//                   button caps returned to those buttons in a given link
//                   collection.  If set to 0, this parameter is
//                   ignored.  Can be used with UsagePage and Usage parameters
//                   to further limit the number of button caps structures
//                   returned.
// 
//    Usage      A usage value used to limit the button caps returned to those
//                with the specified usage value.  If set to 0, this parameter
//                is ignored.  Can be used with LinkCollection and UsagePage
//                parameters to further limit the number of button caps
//                structures returned.
// 
//    ButtonCaps A _HIDP_BUTTON_CAPS array containing information about all the
//                binary values in the given report.  This buffer is provided by
//                the caller.
// 
//    ButtonLength   As input, this parameter specifies the length of the
//                   ButtonCaps parameter (array) in number of array elements.
//                   As output, this value is set to indicate how many of those
//                   array elements were filled in by the function.  The maximum number of
//                   button caps that can be returned is found in the HIDP_CAPS
//                   structure.  If HIDP_STATUS_BUFFER_TOO_SMALL is returned,
//                   this value contains the number of array elements needed to
//                   successfully complete the request.
// 
//    PreparsedData  The preparsed data returned from HIDCLASS.
// 
// 
// Return Value
// HidP_GetSpecificButtonCaps returns the following error codes:
// - HIDP_STATUS_SUCCESS.
// - HIDP_STATUS_INVALID_REPORT_TYPE
// - HIDP_STATUS_INVALID_PREPARSED_DATA
// - HIDP_STATUS_BUFFER_TOO_SMALL (all given entries however have been filled in)
// - HIDP_STATUS_USAGE_NOT_FOUND

function HidP_GetButtonCaps(ReportType: THIDPReportType; ButtonCaps: PHIDPButtonCaps;
  var ButtonCapsLength: Word; PreparsedData: PHIDPPreparsedData): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetButtonCaps}

function HidP_GetSpecificValueCaps(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; Usage: TUsage; ValueCaps: PHIDPValueCaps;
  var ValueCapsLength: Word; PreparsedData: PHIDPPreparsedData): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetSpecificValueCaps}

// Description:
//    HidP_GetValueCaps returns all the values (non-binary) that are a part
//    of the given report type for the Hid device represented by the given
//    preparsed data.
// 
// Parameters:
//    ReportType  One of HidP_Input, HidP_Output, or HidP_Feature.
// 
//    UsagePage   A usage page value used to limit the value caps returned to
//                 those on a given usage page.  If set to 0, this parameter is
//                 ignored.  Can be used with LinkCollection and Usage parameters
//                 to further limit the number of value caps structures returned.
// 
//    LinkCollection HIDP_LINK_COLLECTION node array index used to limit the
//                   value caps returned to those buttons in a given link
//                   collection.  If set to 0, this parameter is
//                   ignored.  Can be used with UsagePage and Usage parameters
//                   to further limit the number of value caps structures
//                   returned.
// 
//    Usage      A usage value used to limit the value caps returned to those
//                with the specified usage value.  If set to 0, this parameter
//                is ignored.  Can be used with LinkCollection and UsagePage
//                parameters to further limit the number of value caps
//                structures returned.
// 
//    ValueCaps  A _HIDP_VALUE_CAPS array containing information about all the
//                non-binary values in the given report.  This buffer is provided
//                by the caller.
// 
//    ValueLength   As input, this parameter specifies the length of the ValueCaps
//                   parameter (array) in number of array elements.  As output,
//                   this value is set to indicate how many of those array elements
//                   were filled in by the function.  The maximum number of
//                   value caps that can be returned is found in the HIDP_CAPS
//                   structure.  If HIDP_STATUS_BUFFER_TOO_SMALL is returned,
//                   this value contains the number of array elements needed to
//                   successfully complete the request.
// 
//    PreparsedData  The preparsed data returned from HIDCLASS.
// 
// 
// Return Value
// HidP_GetValueCaps returns the following error codes:
// - HIDP_STATUS_SUCCESS.
// - HIDP_STATUS_INVALID_REPORT_TYPE
// - HIDP_STATUS_INVALID_PREPARSED_DATA
// - HIDP_STATUS_BUFFER_TOO_SMALL (all given entries however have been filled in)
// - HIDP_STATUS_USAGE_NOT_FOUND

function HidP_GetValueCaps(ReportType: THIDPReportType; ValueCaps: PHIDPValueCaps;
  var ValueCapsLength: Word; PreparsedData: PHIDPPreparsedData): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetValueCaps}

// Routine Description:
// 
//     Please Note: For obvious reasons HidP_SetData and HidP_GetData will not
//     access UsageValueArrays.
// 
// Parameters:
//     ReportType  One of HidP_Input, HidP_Output, or HidP_Feature.
// 
//     DataList    Array of HIDP_DATA structures that will receive the data
//                 values that are set in the given report
// 
//     DataLength  As input, length in array elements of DataList.  As output,
//                 contains the number of data elements that were successfully
//                 set by HidP_GetData.  The maximum size necessary for DataList
//                 can be determined by calling HidP_MaxDataListLength
// 
//     PreparasedData  Preparsed data structure returned by HIDCLASS
// 
//     Report      Buffer which to set the data into.
// 
//     ReportLength Length of Report...Report should be at least as long as the
//                 value indicated in the HIDP_CAPS structure for the device and
//                 the corresponding ReportType
// 
// Return Value
//     HidP_GetData returns the following error codes.
// 
// - HIDP_STATUS_SUCCESS                -- upon successful retrieval of all data
//                                         from the report packet.
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not equal
//                                         to the length specified in HIDP_CAPS
//                                         structure for the given ReportType
// - HIDP_STATUS_REPORT_DOES_NOT_EXIST  -- if there are no reports on this device
//                                         for the given ReportType
// - HIDP_STATUS_BUFFER_TOO_SMALL       -- if there are not enough array entries in
//                                         DataList to store all the indice values
//                                         in the given report.  DataLength will
//                                         contain the number of array entries
//                                         required to hold all data

function HidP_GetData(ReportType: THIDPReportType; DataList: PHIDPData;
  var DataLength: ULONG; PreparsedData: PHIDPPreparsedData;
  var Report; ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetData}

// Routine Description:
// 
//     Please Note: Since usage value arrays deal with multiple fields for
//                  for one usage value, they cannot be used with HidP_SetData
//                  and HidP_GetData.  In this case,
//                  HIDP_STATUS_IS_USAGE_VALUE_ARRAY will be returned.
// 
// Parameters:
// 
//     ReportType  One of HidP_Input, HidP_Output, or HidP_Feature.
// 
//     DataList    Array of HIDP_DATA structures that contains the data values
//                 that are to be set into the given report
// 
//     DataLength  As input, length in array elements of DataList.  As output,
//                 contains the number of data elements set on successful
//                 completion or an index into the DataList array to identify
//                 the faulting HIDP_DATA value if an error code is returned.
// 
//     PreparasedData  Preparsed data structure returned by HIDCLASS
// 
//     Report      Buffer which to set the data into.
// 
//     ReportLength Length of Report...Report should be at least as long as the
//                 value indicated in the HIDP_CAPS structure for the device and
//                 the corresponding ReportType
// 
// Return Value
//     HidP_SetData returns the following error codes.  The report packet will
//         have all the data set up until the HIDP_DATA structure that caused the
//         error.  DataLength, in the error case, will return this problem index.
// 
// - HIDP_STATUS_SUCCESS                -- upon successful insertion of all data
//                                         into the report packet.
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_DATA_INDEX_NOT_FOUND   -- if a HIDP_DATA structure referenced a
//                                         data index that does not exist for this
//                                         device's ReportType
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not equal
//                                         to the length specified in HIDP_CAPS
//                                         structure for the given ReportType
// - HIDP_STATUS_REPORT_DOES_NOT_EXIST  -- if there are no reports on this device
//                                         for the given ReportType
// - HIDP_STATUS_IS_USAGE_VALUE_ARRAY   -- if one of the HIDP_DATA structures
//                                         references a usage value array.
//                                         DataLength will contain the index into
//                                         the array that was invalid
// - HIDP_STATUS_BUTTON_NOT_PRESSED     -- if a HIDP_DATA structure attempted
//                                         to unset a button that was not already
//                                         set in the Report
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- a HIDP_DATA structure was found with
//                                         a valid index value but is contained
//                                         in a different report than the one
//                                         currently being processed
// - HIDP_STATUS_BUFFER_TOO_SMALL       -- if there are not enough entries in
//                                         a given Main Array Item to report all
//                                         buttons that have been requested to be
//                                         set

function HidP_SetData(ReportType: THIDPReportType; DataList: PHIDPData;
  var DataLength: ULONG; PreparsedData: PHIDPPreparsedData;
  var Report; ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_SetData}

// Routine Description:
// 
//     This function returns the maximum length of HIDP_DATA elements that
//     HidP_GetData could return for the given report type.
// 
// Parameters:
// 
//     ReportType  One of HidP_Input, HidP_Output or HidP_Feature.
// 
//     PreparsedData    Preparsed data structure returned by HIDCLASS
// 
// Return Value:
// 
//     The length of the data list array required for the HidP_GetData function
//     call.  If an error occurs (either HIDP_STATUS_INVALID_REPORT_TYPE or
//     HIDP_STATUS_INVALID_PREPARSED_DATA), this function returns 0.

function HidP_MaxDataListLength(ReportType: THIDPReportType;
  PreparsedData: PHIDPPreparsedData): ULONG; stdcall;
{$EXTERNALSYM HidP_MaxDataListLength}

// Routine Description:
//     This function returns the binary values (buttons) that are set in a HID
//     report.  Given a report packet of correct length, it searches the report
//     packet for each usage for the given usage page and returns them in the
//     usage list.
// 
// Parameters:
//     ReportType One of HidP_Input, HidP_Output or HidP_Feature.
// 
//     UsagePage  All of the usages in the usage list, which HidP_GetUsages will
//                retrieve in the report, refer to this same usage page.
//                If the client wishes to get usages in a packet for multiple
//                usage pages then that client needs to make multiple calls
//                to HidP_GetUsages.
// 
//     LinkCollection  An optional value which can limit which usages are returned
//                     in the UsageList to those usages that exist in a specific
//                     LinkCollection.  A non-zero value indicates the index into
//                     the HIDP_LINK_COLLECITON_NODE list returned by
//                     HidP_GetLinkCollectionNodes of the link collection the
//                     usage should belong to.  A value of 0 indicates this
//                     should value be ignored.
// 
//     UsageList  The usage array that will contain all the usages found in
//                the report packet.
// 
//     UsageLength The length of the given usage array in array elements.
//                 On input, this value describes the length of the usage list.
//                 On output, HidP_GetUsages sets this value to the number of
//                 usages that was found.  Use HidP_MaxUsageListLength to
//                 determine the maximum length needed to return all the usages
//                 that a given report packet may contain.
// 
//     PreparsedData Preparsed data structure returned by HIDCLASS
// 
//     Report       The report packet.
// 
//     ReportLength  Length (in bytes) of the given report packet
// 
// 
// Return Value
//     HidP_GetUsages returns the following error codes:
// 
// - HIDP_STATUS_SUCCESS                -- upon successfully retrieving all the
//                                         usages from the report packet
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not
//                                         equal to the length specified in
//                                         the HIDP_CAPS structure for the given
//                                         ReportType
// - HIDP_STATUS_REPORT_DOES_NOT_EXIST  -- if there are no reports on this device
//                                         for the given ReportType
// - HIDP_STATUS_BUFFER_TOO_SMALL       -- if the UsageList is not big enough to
//                                         hold all the usages found in the report
//                                         packet.  If this is returned, the buffer
//                                         will contain UsageLength number of
//                                         usages.  Use HidP_MaxUsageListLength to
//                                         find the maximum length needed
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- if no usages were found but usages
//                                         that match the UsagePage and
//                                         LinkCollection specified could be found
//                                         in a report with a different report ID
// - HIDP_STATUS_USAGE_NOT_FOUND        -- if there are no usages in a reports for
//                                         the device and ReportType that match the
//                                         UsagePage and LinkCollection that were
//                                         specified

function HidP_GetUsages(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; UsageList: PUsage; var UsageLength: ULONG;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetUsages}

function HidP_GetButtons(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; UsageList: PUsage; var UsageLength: ULONG;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetButtons}

// Routine Description:
//     This function returns the binary values (buttons) in a HID report.
//     Given a report packet of correct length, it searches the report packet
//     for all buttons and returns the UsagePage and Usage for each of the buttons
//     it finds.
// 
// Parameters:
//     ReportType  One of HidP_Input, HidP_Output or HidP_Feature.
// 
//     LinkCollection  An optional value which can limit which usages are returned
//                     in the ButtonList to those usages that exist in a specific
//                     LinkCollection.  A non-zero value indicates the index into
//                     the HIDP_LINK_COLLECITON_NODE list returned by
//                     HidP_GetLinkCollectionNodes of the link collection the
//                     usage should belong to.  A value of 0 indicates this
//                     should value be ignored.
// 
//     ButtonList  An array of USAGE_AND_PAGE structures describing all the
//                 buttons currently ``down'' in the device.
// 
//     UsageLength The length of the given array in terms of elements.
//                 On input, this value describes the length of the list.  On
//                 output, HidP_GetUsagesEx sets this value to the number of
//                 usages that were found.  Use HidP_MaxUsageListLength to
//                 determine the maximum length needed to return all the usages
//                 that a given report packet may contain.
// 
//     PreparsedData Preparsed data returned by HIDCLASS
// 
//     Report       The report packet.
// 
//     ReportLength Length (in bytes) of the given report packet.
// 
// 
// Return Value
//     HidP_GetUsagesEx returns the following error codes:
// 
// - HIDP_STATUS_SUCCESS                -- upon successfully retrieving all the
//                                         usages from the report packet
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not
//                                         equal to the length specified in
//                                         the HIDP_CAPS structure for the given
//                                         ReportType
// - HIDP_STATUS_REPORT_DOES_NOT_EXIST  -- if there are no reports on this device
//                                         for the given ReportType
// - HIDP_STATUS_BUFFER_TOO_SMALL       -- if ButtonList is not big enough to
//                                         hold all the usages found in the report
//                                         packet.  If this is returned, the buffer
//                                         will contain UsageLength number of
//                                         usages.  Use HidP_MaxUsageListLength to
//                                         find the maximum length needed
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- if no usages were found but usages
//                                         that match the specified LinkCollection
//                                         exist in report with a different report
//                                         ID.
// - HIDP_STATUS_USAGE_NOT_FOUND        -- if there are no usages in any reports that
//                                         match the LinkCollection parameter

function HidP_GetUsagesEx(ReportType: THIDPReportType; LinkCollection: Word;
  UsageList: PUsageAndPage; var UsageLength: ULONG;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetUsagesEx}

function HidP_GetButtonsEx(ReportType: THIDPReportType; LinkCollection: Word;
  UsageList: PUsageAndPage; var UsageLength: ULONG;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetButtonsEx}

// Routine Description:
//     This function sets binary values (buttons) in a report.  Given an
//     initialized packet of correct length, it modifies the report packet so that
//     each element in the given list of usages has been set in the report packet.
//     For example, in an output report with 5 LED’s, each with a given usage,
//     an application could turn on any subset of these lights by placing their
//     usages in any order into the usage array (UsageList).  HidP_SetUsages would,
//     in turn, set the appropriate bit or add the corresponding byte into the
//     HID Main Array Item.
// 
//     A properly initialized Report packet is one of the correct byte length,
//     and all zeros.
// 
//     NOTE: A packet that has already been set with a call to a HidP_Set routine
//           can also be passed in.  This routine then sets processes the UsageList
//           in the same fashion but verifies that the ReportID already set in
//           Report matches the report ID for the given usages.
// 
// Parameters:
//     ReportType  One of HidP_Input, HidP_Output or HidP_Feature.
// 
//     UsagePage   All of the usages in the usage array, which HidP_SetUsages will
//                 set in the report, refer to this same usage page.
//                 If a client wishes to set usages in a report for multiple
//                 usage pages then that client needs to make multiple calls to
//                 HidP_SetUsages for each of the usage pages.
// 
//     UsageList   A usage array containing the usages that HidP_SetUsages will set in
//                 the report packet.
// 
//     UsageLength The length of the given usage array in array elements.
//                 The parser will set this value to the position in the usage
//                 array where it stopped processing.  If successful, UsageLength
//                 will be unchanged.  In any error condition, this parameter
//                 reflects how many of the usages in the usage list have
//                 actually been set by the parser.  This is useful for finding
//                 the usage in the list which caused the error.
// 
//     PreparsedData The preparsed data recevied from HIDCLASS
// 
//     Report      The report packet.
// 
//     ReportLength   Length of the given report packet...Must be equal to the
//                    value reported in the HIDP_CAPS structure for the device
//                    and corresponding report type.
// 
// Return Value
//     HidP_SetUsages returns the following error codes.  On error, the report packet
//     will be correct up until the usage element that caused the error.
// 
// - HIDP_STATUS_SUCCESS                -- upon successful insertion of all usages
//                                         into the report packet.
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not
//                                         equal to the length specified in
//                                         the HIDP_CAPS structure for the given
//                                         ReportType
// - HIDP_STATUS_REPORT_DOES_NOT_EXIST  -- if there are no reports on this device
//                                         for the given ReportType
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- if a usage was found that exists in a
//                                         different report.  If the report is
//                                         zero-initialized on entry the first
//                                         usage in the list will determine which
//                                         report ID is used.  Otherwise, the
//                                         parser will verify that usage matches
//                                         the passed in report's ID
// - HIDP_STATUS_USAGE_NOT_FOUND        -- if the usage does not exist for any
//                                         report (no matter what the report ID)
//                                         for the given report type.
// - HIDP_STATUS_BUFFER_TOO_SMALL       -- if there are not enough entries in a
//                                         given Main Array Item to list all of
//                                         the given usages.  The caller needs
//                                         to split his request into more than
//                                         one call

function HidP_SetUsages(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; UsageList: PUsage; var UsageLength: ULONG;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_SetUsages}

function HidP_SetButtons(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; ButtonList: PUsage; var ButtonLength: ULONG;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_SetButtons}

// Routine Description:
//     This function unsets (turns off) binary values (buttons) in the report.  Given
//     an initialized packet of correct length, it modifies the report packet so
//     that each element in the given list of usages has been unset in the
//     report packet.
// 
//     This function is the "undo" operation for SetUsages.  If the given usage
//     is not already set in the Report, it will return an error code of
//     HIDP_STATUS_BUTTON_NOT_PRESSED.  If the button is pressed, HidP_UnsetUsages
//     will unset the appropriate bit or remove the corresponding index value from
//     the HID Main Array Item.
// 
//     A properly initialized Report packet is one of the correct byte length,
//     and all zeros..
// 
//     NOTE: A packet that has already been set with a call to a HidP_Set routine
//           can also be passed in.  This routine then processes the UsageList
//           in the same fashion but verifies that the ReportID already set in
//           Report matches the report ID for the given usages.
// 
// Parameters:
//     ReportType  One of HidP_Input, HidP_Output or HidP_Feature.
// 
//     UsagePage   All of the usages in the usage array, which HidP_UnsetUsages will
//                 unset in the report, refer to this same usage page.
//                 If a client wishes to unset usages in a report for multiple
//                 usage pages then that client needs to make multiple calls to
//                 HidP_UnsetUsages for each of the usage pages.
// 
//     UsageList   A usage array containing the usages that HidP_UnsetUsages will
//                 unset in the report packet.
// 
//     UsageLength The length of the given usage array in array elements.
//                 The parser will set this value to the position in the usage
//                 array where it stopped processing.  If successful, UsageLength
//                 will be unchanged.  In any error condition, this parameter
//                 reflects how many of the usages in the usage list have
//                 actually been unset by the parser.  This is useful for finding
//                 the usage in the list which caused the error.
// 
//     PreparsedData The preparsed data recevied from HIDCLASS
// 
//     Report      The report packet.
// 
//     ReportLength   Length of the given report packet...Must be equal to the
//                    value reported in the HIDP_CAPS structure for the device
//                    and corresponding report type.
// 
// Return Value
//     HidP_UnsetUsages returns the following error codes.  On error, the report
//     packet will be correct up until the usage element that caused the error.
// 
// - HIDP_STATUS_SUCCESS                -- upon successful "unsetting" of all usages
//                                         in the report packet.
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not
//                                         equal to the length specified in
//                                         the HIDP_CAPS structure for the given
//                                         ReportType
// - HIDP_STATUS_REPORT_DOES_NOT_EXIST  -- if there are no reports on this device
//                                         for the given ReportType
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- if a usage was found that exists in a
//                                         different report.  If the report is
//                                         zero-initialized on entry the first
//                                         usage in the list will determine which
//                                         report ID is used.  Otherwise, the
//                                         parser will verify that usage matches
//                                         the passed in report's ID
// - HIDP_STATUS_USAGE_NOT_FOUND        -- if the usage does not exist for any
//                                         report (no matter what the report ID)
//                                         for the given report type.
// - HIDP_STATUS_BUTTON_NOT_PRESSED     -- if a usage corresponds to a button that
//                                         is not already set in the given report

function HidP_UnsetUsages(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; UsageList: PUsage; var UsageLength: ULONG;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_UnsetUsages}

function HidP_UnsetButtons(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; ButtonList: PUsage; var ButtonLength: ULONG;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_UnsetButtons}

// Routine Description:
//     This function returns the maximum number of usages that a call to
//     HidP_GetUsages or HidP_GetUsagesEx could return for a given HID report.
//     If calling for number of usages returned by HidP_GetUsagesEx, use 0 as
//     the UsagePage value.
// 
// Parameters:
//     ReportType  One of HidP_Input, HidP_Output or HidP_Feature.
// 
//     UsagePage   Specifies the optional UsagePage to query for.  If 0, will
//                 return all the maximum number of usage values that could be
//                 returned for a given ReportType.   If non-zero, will return
//                 the maximum number of usages that would be returned for the
//                 ReportType with the given UsagePage.
// 
//     PreparsedData Preparsed data returned from HIDCLASS
// 
// Return Value:
//     The length of the usage list array required for the HidP_GetUsages or
//     HidP_GetUsagesEx function call.  If an error occurs (such as
//     HIDP_STATUS_INVALID_REPORT_TYPE or HIDP_INVALID_PREPARSED_DATA, this
//     returns 0.

function HidP_MaxUsageListLength(ReportType: THIDPReportType; UsagePage: TUsage;
  PreparsedData: PHIDPPreparsedData): ULONG; stdcall;
{$EXTERNALSYM HidP_MaxUsageListLength}

function HidP_MaxButtonListLength(ReportType: THIDPReportType; UsagePage: TUsage;
  PreparsedData: PHIDPPreparsedData): ULONG; stdcall;
{$EXTERNALSYM HidP_MaxButtonListLength}

// Description
//     HidP_GetUsageValue retrieves the value from the HID Report for the usage
//     specified by the combination of usage page, usage and link collection.
//     If a report packet contains two different fields with the same
//     Usage and UsagePage, they can be distinguished with the optional
//     LinkCollection field value.
// 
// Parameters:
// 
//     ReportType  One of HidP_Input or HidP_Feature.
// 
//     UsagePage   The usage page to which the given usage refers.
// 
//     LinkCollection  (Optional)  This value can be used to differentiate
//                                 between two fields that may have the same
//                                 UsagePage and Usage but exist in different
//                                 collections.  If the link collection value
//                                 is zero, this function will set the first field
//                                 it finds that matches the usage page and
//                                 usage.
// 
//     Usage       The usage whose value HidP_GetUsageValue will retrieve
// 
//     UsageValue  The raw value that is set for the specified field in the report
//                 buffer. This value will either fall within the logical range
//                 or if NULL values are allowed, a number outside the range to
//                 indicate a NULL
// 
//     PreparsedData The preparsed data returned for HIDCLASS
// 
//     Report      The report packet.
// 
//     ReportLength Length (in bytes) of the given report packet.
// 
// 
// Return Value:
//     HidP_GetUsageValue returns the following error codes:
// 
// - HIDP_STATUS_SUCCESS                -- upon successfully retrieving the value
//                                         from the report packet
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not
//                                         equal to the length specified in
//                                         the HIDP_CAPS structure for the given
//                                         ReportType
// - HIDP_STATUS_REPORT_DOES_NOT_EXIST  -- if there are no reports on this device
//                                         for the given ReportType
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- the specified usage page, usage and
//                                         link collection exist but exists in
//                                         a report with a different report ID
//                                         than the report being passed in.  To
//                                         set this value, call HidP_GetUsageValue
//                                         again with a different report packet
// - HIDP_STATUS_USAGE_NOT_FOUND        -- if the usage page, usage, and link
//                                         collection combination does not exist
//                                         in any reports for this ReportType

function HidP_GetUsageValue(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; Usage: TUsage; var UsageValue: ULONG;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetUsageValue}

// Description
//     HidP_GetScaledUsageValue retrieves a UsageValue from the HID report packet
//     in the field corresponding to the given usage page and usage.  If a report
//     packet contains two different fields with the same Usage and UsagePage,
//     they can be distinguished with the optional LinkCollection field value.
// 
//     If the specified field has a defined physical range, this function converts
//     the logical value that exists in the report packet to the corresponding
//     physical value.  If a physical range does not exist, the function will
//     return the logical value.  This function will check to verify that the
//     logical value in the report falls within the declared logical range.
// 
//     When doing the conversion between logical and physical values, this
//     function assumes a linear extrapolation between the physical max/min and
//     the logical max/min. (Where logical is the values reported by the device
//     and physical is the value returned by this function).  If the data field
//     size is less than 32 bits, then HidP_GetScaledUsageValue will sign extend
//     the value to 32 bits.
// 
//     If the range checking fails but the field has NULL values, the function
//     will set UsageValue to 0 and return HIDP_STATUS_NULL.  Otherwise, it
//     returns a HIDP_STATUS_OUT_OF_RANGE error.
// 
// Parameters:
// 
//     ReportType  One of HidP_Output or HidP_Feature.
// 
//     UsagePage   The usage page to which the given usage refers.
// 
//     LinkCollection  (Optional)  This value can be used to differentiate
//                                 between two fields that may have the same
//                                 UsagePage and Usage but exist in different
//                                 collections.  If the link collection value
//                                 is zero, this function will retrieve the first
//                                 field it finds that matches the usage page
//                                 and usage.
// 
//     Usage       The usage whose value HidP_GetScaledUsageValue will retrieve
// 
//     UsageValue  The value retrieved from the report buffer.  See the routine
//                 description above for the different interpretations of this
//                 value
// 
//     PreparsedData The preparsed data returned from HIDCLASS
// 
//     Report      The report packet.
// 
//     ReportLength Length (in bytes) of the given report packet.
// 
// 
// Return Value:
//    HidP_GetScaledUsageValue returns the following error codes:
// 
// - HIDP_STATUS_SUCCESS                -- upon successfully retrieving the value
//                                         from the report packet
// - HIDP_STATUS_NULL                   -- if the report packet had a NULL value
//                                         set
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not
//                                         equal to the length specified in
//                                         the HIDP_CAPS structure for the given
//                                         ReportType
// - HIDP_STATUS_VALUE_OUT_OF_RANGE     -- if the value retrieved from the packet
//                                         falls outside the logical range and
//                                         the field does not support NULL values
// - HIDP_STATUS_BAD_LOG_PHY_VALUES     -- if the field has a physical range but
//                                         either the logical range is invalid
//                                         (max <= min) or the physical range is
//                                         invalid
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- the specified usage page, usage and
//                                         link collection exist but exists in
//                                         a report with a different report ID
//                                         than the report being passed in.  To
//                                         set this value, call
//                                         HidP_GetScaledUsageValue with a
//                                         different report packet
// - HIDP_STATUS_USAGE_NOT_FOUND        -- if the usage page, usage, and link
//                                         collection combination does not exist
//                                         in any reports for this ReportType

function HidP_GetScaledUsageValue(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; Usage: TUsage; var UsageValue: Integer;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetScaledUsageValue}

// Routine Descripton:
//     A usage value array occurs when the last usage in the list of usages
//     describing a main item must be repeated because there are less usages defined
//     than there are report counts declared for the given main item.  In this case
//     a single value cap is allocated for that usage and the report count of that
//     value cap is set to reflect the number of fields to which that usage refers.
// 
//     HidP_GetUsageValueArray returns the raw bits for that usage which spans
//     more than one field in a report.
// 
//     NOTE: This function currently does not support value arrays where the
//           ReportSize for each of the fields in the array is not a multiple
//           of 8 bits.
// 
//           The UsageValue buffer will have the raw values as they are set
//           in the report packet.
// 
// Parameters:
// 
//     ReportType  One of HidP_Input, HidP_Output or HidP_Feature.
// 
//     UsagePage   The usage page to which the given usage refers.
// 
//     LinkCollection  (Optional)  This value can be used to differentiate
//                                 between two fields that may have the same
//                                 UsagePage and Usage but exist in different
//                                 collections.  If the link collection value
//                                 is zero, this function will set the first field
//                                 it finds that matches the usage page and
//                                 usage.
// 
//    Usage       The usage whose value HidP_GetUsageValueArray will retreive.
// 
//    UsageValue  A pointer to an array of characters where the value will be
//                placed.  The number of BITS required is found by multiplying the
//                BitSize and ReportCount fields of the Value Cap for this
//                control.  The least significant bit of this control found in the
//                given report will be placed in the least significant bit location
//                of the buffer (little-endian format), regardless of whether
//                or not the field is byte aligned or if the BitSize is a multiple
//                of sizeof (CHAR).
// 
//                See note above about current implementation limitations
// 
//    UsageValueByteLength
//                the length of the given UsageValue buffer.
// 
//    PreparsedData The preparsed data returned by the HIDCLASS
// 
//    Report      The report packet.
// 
//    ReportLength   Length of the given report packet.
// 
// Return Value:
// 
// - HIDP_STATUS_SUCCESS                -- upon successfully retrieving the value
//                                         from the report packet
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not
//                                         equal to the length specified in
//                                         the HIDP_CAPS structure for the given
//                                         ReportType
// - HIDP_STATUS_NOT_VALUE_ARRAY        -- if the control specified is not a
//                                         value array -- a value array will have
//                                         a ReportCount field in the
//                                         HIDP_VALUE_CAPS structure that is > 1
//                                         Use HidP_GetUsageValue instead
// - HIDP_STATUS_BUFFER_TOO_SMALL       -- if the size of the passed in buffer in
//                                         which to return the array is too small
//                                         (ie. has fewer values than the number of
//                                         fields in the array
// - HIDP_STATUS_NOT_IMPLEMENTED        -- if the usage value array has field sizes
//                                         that are not multiples of 8 bits, this
//                                         error code is returned since the function
//                                         currently does not handle getting values
//                                         from such arrays.
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- the specified usage page, usage and
//                                         link collection exist but exists in
//                                         a report with a different report ID
//                                         than the report being passed in.  To
//                                         set this value, call
//                                         HidP_GetUsageValueArray with a
//                                         different report packet
// - HIDP_STATUS_USAGE_NOT_FOUND        -- if the usage page, usage, and link
//                                         collection combination does not exist
//                                         in any reports for this ReportType

function HidP_GetUsageValueArray(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; Usage: TUsage; UsageValue: PChar;
  UsageValueByteLength: Word; PreparsedData: PHIDPPreparsedData;
  var Report; ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetUsageValueArray}

// Description:
//     HidP_SetUsageValue inserts a value into the HID Report Packet in the field
//     corresponding to the given usage page and usage.  HidP_SetUsageValue
//     casts this value to the appropriate bit length.  If a report packet
//     contains two different fields with the same Usage and UsagePage,
//     they can be distinguished with the optional LinkCollection field value.
//     Using this function sets the raw value into the report packet with
//     no checking done as to whether it actually falls within the logical
//     minimum/logical maximum range.  Use HidP_SetScaledUsageValue for this...
// 
//     NOTE: Although the UsageValue parameter is a ULONG, any casting that is
//           done will preserve or sign-extend the value.  The value being set
//           should be considered a LONG value and will be treated as such by
//           this function.
// 
// Parameters:
// 
//     ReportType  One of HidP_Output or HidP_Feature.
// 
//     UsagePage   The usage page to which the given usage refers.
// 
//     LinkCollection  (Optional)  This value can be used to differentiate
//                                 between two fields that may have the same
//                                 UsagePage and Usage but exist in different
//                                 collections.  If the link collection value
//                                 is zero, this function will set the first field
//                                 it finds that matches the usage page and
//                                 usage.
// 
//     Usage       The usage whose value HidP_SetUsageValue will set.
// 
//     UsageValue  The raw value to set in the report buffer.  This value must be within
//                 the logical range or if a NULL value this value should be the
//                 most negative value that can be represented by the number of bits
//                 for this field.
// 
//     PreparsedData The preparsed data returned for HIDCLASS
// 
//     Report      The report packet.
// 
//     ReportLength Length (in bytes) of the given report packet.
// 
// 
// Return Value:
//     HidP_SetUsageValue returns the following error codes:
// 
// - HIDP_STATUS_SUCCESS                -- upon successfully setting the value
//                                         in the report packet
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not
//                                         equal to the length specified in
//                                         the HIDP_CAPS structure for the given
//                                         ReportType
// - HIDP_STATUS_REPORT_DOES_NOT_EXIST  -- if there are no reports on this device
//                                         for the given ReportType
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- the specified usage page, usage and
//                                         link collection exist but exists in
//                                         a report with a different report ID
//                                         than the report being passed in.  To
//                                         set this value, call HidP_SetUsageValue
//                                         again with a zero-initizialed report
//                                         packet
// - HIDP_STATUS_USAGE_NOT_FOUND        -- if the usage page, usage, and link
//                                         collection combination does not exist
//                                         in any reports for this ReportType

function HidP_SetUsageValue(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; Usage: TUsage; UsageValue: ULONG;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_SetUsageValue}

// Description:
//     HidP_SetScaledUsageValue inserts the UsageValue into the HID report packet
//     in the field corresponding to the given usage page and usage.  If a report
//     packet contains two different fields with the same Usage and UsagePage,
//     they can be distinguished with the optional LinkCollection field value.
// 
//     If the specified field has a defined physical range, this function converts
//     the physical value specified to the corresponding logical value for the
//     report.  If a physical value does not exist, the function will verify that
//     the value specified falls within the logical range and set according.
// 
//     If the range checking fails but the field has NULL values, the function will
//     set the field to the defined NULL value (most negative number possible) and
//     return HIDP_STATUS_NULL.  In other words, use this function to set NULL
//     values for a given field by passing in a value that falls outside the
//     physical range if it is defined or the logical range otherwise.
// 
//     If the field does not support NULL values, an out of range error will be
//     returned instead.
// 
// Parameters:
// 
//     ReportType  One of HidP_Output or HidP_Feature.
// 
//     UsagePage   The usage page to which the given usage refers.
// 
//     LinkCollection  (Optional)  This value can be used to differentiate
//                                 between two fields that may have the same
//                                 UsagePage and Usage but exist in different
//                                 collections.  If the link collection value
//                                 is zero, this function will set the first field
//                                 it finds that matches the usage page and
//                                 usage.
// 
//     Usage       The usage whose value HidP_SetScaledUsageValue will set.
// 
//     UsageValue  The value to set in the report buffer.  See the routine
//                 description above for the different interpretations of this
//                 value
// 
//     PreparsedData The preparsed data returned from HIDCLASS
// 
//     Report      The report packet.
// 
//     ReportLength Length (in bytes) of the given report packet.
// 
// 
// Return Value:
//    HidP_SetScaledUsageValue returns the following error codes:
// 
// - HIDP_STATUS_SUCCESS                -- upon successfully setting the value
//                                         in the report packet
// - HIDP_STATUS_NULL                   -- upon successfully setting the value
//                                         in the report packet as a NULL value
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not
//                                         equal to the length specified in
//                                         the HIDP_CAPS structure for the given
//                                         ReportType
// - HIDP_STATUS_VALUE_OUT_OF_RANGE     -- if the value specified failed to fall
//                                         within the physical range if it exists
//                                         or within the logical range otherwise
//                                         and the field specified by the usage
//                                         does not allow NULL values
// - HIDP_STATUS_BAD_LOG_PHY_VALUES     -- if the field has a physical range but
//                                         either the logical range is invalid
//                                         (max <= min) or the physical range is
//                                         invalid
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- the specified usage page, usage and
//                                         link collection exist but exists in
//                                         a report with a different report ID
//                                         than the report being passed in.  To
//                                         set this value, call
//                                         HidP_SetScaledUsageValue again with
//                                         a zero-initialized report packet
// - HIDP_STATUS_USAGE_NOT_FOUND        -- if the usage page, usage, and link
//                                         collection combination does not exist
//                                         in any reports for this ReportType

function HidP_SetScaledUsageValue(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; Usage: TUsage; UsageValue: Integer;
  PreparsedData: PHIDPPreparsedData; var Report;
  ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_SetScaledUsageValue}

// Routine Descripton:
//     A usage value array occurs when the last usage in the list of usages
//     describing a main item must be repeated because there are less usages defined
//     than there are report counts declared for the given main item.  In this case
//     a single value cap is allocated for that usage and the report count of that
//     value cap is set to reflect the number of fields to which that usage refers.
// 
//     HidP_SetUsageValueArray sets the raw bits for that usage which spans
//     more than one field in a report.
// 
//     NOTE: This function currently does not support value arrays where the
//           ReportSize for each of the fields in the array is not a multiple
//           of 8 bits.
// 
//           The UsageValue buffer should have the values set as they would appear
//           in the report buffer.  If this function supported non 8-bit multiples
//           for the ReportSize then caller should format the input buffer so that
//           each new value begins at the bit immediately following the last bit
//           of the previous value
// 
// Parameters:
// 
//     ReportType  One of HidP_Output or HidP_Feature.
// 
//     UsagePage   The usage page to which the given usage refers.
// 
//     LinkCollection  (Optional)  This value can be used to differentiate
//                                 between two fields that may have the same
//                                 UsagePage and Usage but exist in different
//                                 collections.  If the link collection value
//                                 is zero, this function will set the first field
//                                 it finds that matches the usage page and
//                                 usage.
// 
//     Usage       The usage whose value array HidP_SetUsageValueArray will set.
// 
//     UsageValue  The buffer with the values to set into the value array.
//                 The number of BITS required is found by multiplying the
//                 BitSize and ReportCount fields of the Value Cap for this
//                 control.  The least significant bit of this control found in the
//                 given report will be placed in the least significan bit location
//                 of the array given (little-endian format), regardless of whether
//                 or not the field is byte alligned or if the BitSize is a multiple
//                 of sizeof (CHAR).
// 
//                 See the above note for current implementation limitations.
// 
//     UsageValueByteLength  Length of the UsageValue buffer (in bytes)
// 
//     PreparsedData The preparsed data returned from HIDCLASS
// 
//     Report      The report packet.
// 
//     ReportLength Length (in bytes) of the given report packet.
// 
// 
// Return Value:
// - HIDP_STATUS_SUCCESS                -- upon successfully setting the value
//                                         array in the report packet
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not
//                                         equal to the length specified in
//                                         the HIDP_CAPS structure for the given
//                                         ReportType
// - HIDP_STATUS_REPORT_DOES_NOT_EXIST  -- if there are no reports on this device
//                                         for the given ReportType
// - HIDP_STATUS_NOT_VALUE_ARRAY        -- if the control specified is not a
//                                         value array -- a value array will have
//                                         a ReportCount field in the
//                                         HIDP_VALUE_CAPS structure that is > 1
//                                         Use HidP_SetUsageValue instead
// - HIDP_STATUS_BUFFER_TOO_SMALL       -- if the size of the passed in buffer with
//                                         the values to set is too small (ie. has
//                                         fewer values than the number of fields in
//                                         the array
// - HIDP_STATUS_NOT_IMPLEMENTED        -- if the usage value array has field sizes
//                                         that are not multiples of 8 bits, this
//                                         error code is returned since the function
//                                         currently does not handle setting into
//                                         such arrays.
// - HIDP_STATUS_INCOMPATIBLE_REPORT_ID -- the specified usage page, usage and
//                                         link collection exist but exists in
//                                         a report with a different report ID
//                                         than the report being passed in.  To
//                                         set this value, call
//                                         HidP_SetUsageValueArray again with
//                                         a zero-initialized report packet
// - HIDP_STATUS_USAGE_NOT_FOUND        -- if the usage page, usage, and link
//                                         collection combination does not exist
//                                         in any reports for this ReportType

function HidP_SetUsageValueArray(ReportType: THIDPReportType; UsagePage: TUsage;
  LinkCollection: Word; Usage: TUsage; UsageValue: PChar;
  UsageValueByteLength: Word; PreparsedData: PHIDPPreparsedData;
  var Report; ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_SetUsageValueArray}

// Routine Description:
//     This function will return the difference between a two lists of usages
//     (as might be returned from HidP_GetUsages),  In other words, it will return
//     return a list of usages that are in the current list but not the previous
//     list as well as a list of usages that are in the previous list but not
//     the current list.
// 
// Parameters:
// 
//     PreviousUsageList   The list of usages before.
//     CurrentUsageList    The list of usages now.
//     BreakUsageList      Previous - Current.
//     MakeUsageList       Current - Previous.
//     UsageListLength     Represents the length of the usage lists in array
//                         elements.  If comparing two lists with a differing
//                         number of array elements, this value should be
//                         the size of the larger of the two lists.  Any
//                         zero found with a list indicates an early termination
//                         of the list and any usages found after the first zero
//                         will be ignored.

function HidP_UsageListDifference(PreviousUsageList: PUsage;
  CurrentUsageList: PUsage; BreakUsageList: PUsage;
  MakeUsageList: PUsage; UsageListLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_UsageListDifference}

// (rom) these two functions are prototyped in hidpi.h
// (rom) but are missing in all HID.DLL versions

// function HidP_UsageAndPageListDifference(PreviousUsageList: PUsageAndPage;
//   CurrentUsageList: PUsageAndPage; BreakUsageList: PUsageAndPage;
//   MakeUsageList: PUsageAndPage; UsageListLength: ULONG):NTSTATUS; stdcall;
// {$EXTERNALSYM HidP_UsageAndPageListDifference}

// function HidP_TranslateUsageAndPagesToI8042ScanCodes(ChangedUsageList: PUsageAndPage;
//   UsageListLength: ULONG; KeyAction: THIDPKeyboardDirection;
//   var ModifierState: THIDPKeyboardModifierState;
//   InsertCodesProcedure: THIDPInsertScanCodes;
//   InsertCodesContext: Pointer): NTSTATUS; stdcall;
// {$EXTERNALSYM HidP_TranslateUsageAndPagesToI8042ScanCodes}

function HidP_TranslateUsagesToI8042ScanCodes(ChangedUsageList: PUsage;
  UsageListLength: ULONG; KeyAction: THIDPKeyboardDirection;
  var ModifierState: THIDPKeyboardModifierState;
  InsertCodesProcedure: THIDPInsertScanCodes;
  InsertCodesContext: Pointer): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_TranslateUsagesToI8042ScanCodes}

function HidP_IsSameUsageAndPage(u1: TUsageAndPage;
  u2: TUsageAndPage): Boolean; stdcall;
{$EXTERNALSYM HidP_IsSameUsageAndPage}

// Description:
//     Given a data index from the value or button capabilities of a given control
//     return any extended attributes for the control if any exist.
// 
// Parameters:
//     ReportType  One of HidP_Input, HidP_Output, or HidP_Feature.
// 
//     DataIndex   The data index for the given control, found in the capabilities
//                 structure for that control
// 
//     PreparsedData   The preparsed data returned from HIDCLASS.
// 
//     Attributes  Pointer to a buffer into which the extended attribute data will
//                 be copied.
// 
//     LengthAttributes    Length of the given buffer in bytes.
// 
// Return Value
//     HIDP_STATUS_SUCCESS
//     HIDP_STATUS_DATA_INDEX_NOT_FOUND

{$IFDEF WIN2000}

// (rom) This function is not in the HID.DLL of Windows 98
// (rom) never call it unless you have Windows 98 SE or Windows 2000

function HidP_GetExtendedAttributes(ReportType: THIDPReportType;
  DataIndex: Word; PreparsedData: PHIDPPreparsedData;
  Attributes: PHIDPExtendedAttributes;
  var LengthAttributes: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_GetExtendedAttributes}

// Routine Description:
// 
//     Initialize a report based on the given report ID.
// 
// Parameters:
// 
//     ReportType  One of HidP_Input, HidP_Output, or HidP_Feature.
// 
//     PreparsedData  Preparsed data structure returned by HIDCLASS
// 
//     Report      Buffer which to set the data into.
// 
//     ReportLength Length of Report...Report should be at least as long as the
//                 value indicated in the HIDP_CAPS structure for the device and
//                 the corresponding ReportType
// 
// Return Value
// 
// - HIDP_STATUS_INVALID_REPORT_TYPE    -- if ReportType is not valid.
// - HIDP_STATUS_INVALID_PREPARSED_DATA -- if PreparsedData is not valid
// - HIDP_STATUS_INVALID_REPORT_LENGTH  -- the length of the report packet is not equal
//                                         to the length specified in HIDP_CAPS
//                                         structure for the given ReportType
// - HIDP_STATUS_REPORT_DOES_NOT_EXIST  -- if there are no reports on this device
//                                         for the given ReportType

// (rom) This function is not in the HID.DLL of Windows 98
// (rom) never call it unless you have Windows 98 SE or Windows 2000

function HidP_InitializeReportForID(ReportType: THIDPReportType;
  ReportID: BYTE; PreparsedData: PHIDPPreparsedData;
  var Report; ReportLength: ULONG): NTSTATUS; stdcall;
{$EXTERNALSYM HidP_InitializeReportForID}

{$ENDIF}

implementation

const
  hiddll = 'hid.dll';

// (rom) simply adds three 0 params on call

function HidP_GetButtonCaps( ReportType: THIDPReportType;
  ButtonCaps: PHIDPButtonCaps; var ButtonCapsLength: Word;
  PreparsedData: PHIDPPreparsedData): NTSTATUS; stdcall;
begin
  HidP_GetButtonCaps :=
    HidP_GetSpecificButtonCaps(ReportType, 0, 0, 0, ButtonCaps,
      ButtonCapsLength, PreparsedData);
end;

// (rom) simply adds three 0 params on call

function HidP_GetValueCaps(ReportType: THIDPReportType;
   ValueCaps: PHIDPValueCaps; var ValueCapsLength: Word;
   PreparsedData: PHIDPPreparsedData): NTSTATUS; stdcall;
begin
  HidP_GetValueCaps :=
    HidP_GetSpecificValueCaps(ReportType, 0, 0, 0, ValueCaps,
      ValueCapsLength, PreparsedData);
end;

// (rom) implements HidP_IsSameUsageAndPage macro
// (rom) the original macro is a really dirty trick

function HidP_IsSameUsageAndPage(u1: TUsageAndPage;
  u2: TUsageAndPage): Boolean; stdcall;
begin
  Result := (u1.Usage = u2.Usage) and (u1.UsagePage = u2.UsagePage);
end;

function HidD_Hello; external hiddll name 'HidD_Hello';
procedure HidD_GetHidGuid; external hiddll name 'HidD_GetHidGuid';
function HidD_GetPreparsedData; external hiddll name 'HidD_GetPreparsedData';
function HidD_FreePreparsedData; external hiddll name 'HidD_FreePreparsedData';
function HidD_GetConfiguration; external hiddll name 'HidD_GetConfiguration';
function HidD_SetConfiguration; external hiddll name 'HidD_SetConfiguration';
function HidD_FlushQueue; external hiddll name 'HidD_FlushQueue';
function HidD_GetFeature; external hiddll name 'HidD_GetFeature';
function HidD_SetFeature; external hiddll name 'HidD_SetFeature';
function HidD_GetNumInputBuffers; external hiddll name 'HidD_GetNumInputBuffers';
function HidD_SetNumInputBuffers; external hiddll name 'HidD_SetNumInputBuffers';
function HidD_GetAttributes; external hiddll name 'HidD_GetAttributes';
function HidD_GetManufacturerString; external hiddll name 'HidD_GetManufacturerString';
function HidD_GetProductString; external hiddll name 'HidD_GetProductString';
function HidD_GetSerialNumberString; external hiddll name 'HidD_GetSerialNumberString';
function HidD_GetPhysicalDescriptor; external hiddll name 'HidD_GetPhysicalDescriptor';
function HidD_GetIndexedString; external hiddll name 'HidD_GetIndexedString';
function HidP_GetCaps; external hiddll name 'HidP_GetCaps';
function HidP_GetLinkCollectionNodes; external hiddll name 'HidP_GetLinkCollectionNodes';
function HidP_GetSpecificButtonCaps; external hiddll name 'HidP_GetSpecificButtonCaps';
function HidP_GetSpecificValueCaps; external hiddll name 'HidP_GetSpecificValueCaps';
function HidP_GetData; external hiddll name 'HidP_GetData';
function HidP_SetData; external hiddll name 'HidP_SetData';
function HidP_MaxDataListLength; external hiddll name 'HidP_MaxDataListLength';
function HidP_GetUsages; external hiddll name 'HidP_GetUsages';
function HidP_GetButtons; external hiddll name 'HidP_GetUsages';
function HidP_GetUsagesEx; external hiddll name 'HidP_GetUsagesEx';
function HidP_GetButtonsEx; external hiddll name 'HidP_GetUsagesEx';
function HidP_SetUsages; external hiddll name 'HidP_SetUsages';
function HidP_SetButtons; external hiddll name 'HidP_SetUsages';
function HidP_UnsetUsages; external hiddll name 'HidP_UnsetUsages';
function HidP_UnsetButtons; external hiddll name 'HidP_UnsetUsages';
function HidP_MaxUsageListLength; external hiddll name 'HidP_MaxUsageListLength';
function HidP_MaxButtonListLength; external hiddll name 'HidP_MaxUsageListLength';
function HidP_GetUsageValue; external hiddll name 'HidP_GetUsageValue';
function HidP_GetScaledUsageValue; external hiddll name 'HidP_GetScaledUsageValue';
function HidP_GetUsageValueArray; external hiddll name 'HidP_GetUsageValueArray';
function HidP_SetUsageValue; external hiddll name 'HidP_SetUsageValue';
function HidP_SetScaledUsageValue; external hiddll name 'HidP_SetScaledUsageValue';
function HidP_SetUsageValueArray; external hiddll name 'HidP_SetUsageValueArray';
function HidP_UsageListDifference; external hiddll name 'HidP_UsageListDifference';
function HidP_TranslateUsagesToI8042ScanCodes; external hiddll name 'HidP_TranslateUsagesToI8042ScanCodes';
// function HidP_UsageAndPageListDifference; external hiddll name 'function HidP_UsageAndPageListDifference';
// function HidP_TranslateUsageAndPagesToI8042ScanCodes; external hiddll name 'HidP_TranslateUsageAndPagesToI8042ScanCodes';
{$IFDEF WIN2000}
function HidP_GetExtendedAttributes; external hiddll name 'HidP_GetExtendedAttributes';
function HidP_InitializeReportForID; external hiddll name 'HidP_InitializeReportForID';
{$ENDIF}

end.

