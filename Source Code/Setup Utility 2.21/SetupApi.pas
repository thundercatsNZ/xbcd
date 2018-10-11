{******************************************************************}
{                                                                  }
{       Borland Delphi Runtime Library                             }
{       Setup and Device Installer API interface unit              }
{                                                                  }
{ Portions created by Microsoft are                                }
{ Copyright (C) 1995-1999 Microsoft Corporation.                   }
{ All Rights Reserved.                                             }
{                                                                  }
{ The original file is: setupapi.h, released March 1999.           }
{ The original Pascal code is: SetupApi.pas, released 29 Jan 2000. }
{ The initial developer of the Pascal code is Robert Marquardt     }
{ (robert_marquardt@gmx.de)                                        }
{                                                                  }
{ Portions created by Robert Marquardt are                         }
{ Copyright (C) 1999 Robert Marquardt.                             }
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

unit SetupApi;

{$WEAKPACKAGEUNIT}

interface

(*$HPPEMIT ''*)
(*$HPPEMIT '#include "setupapi.h"'*)
(*$HPPEMIT ''*)

uses
  Windows, Commctrl;

type
  PPWSTR    = ^PWideChar;
  PPASTR    = ^PAnsiChar;
  PPSTR     = ^PChar;
  PHICON    = ^HICON;
  ULONG_PTR = DWORD;
  DWORD_PTR = DWORD;
  UINT_PTR  = DWORD;

const
  ANYSIZE_ARRAY = 1;

//
// Define maximum string length constants as specified by
// Windows 95.
//
const
  LINE_LEN = 256;                 // Win95-compatible maximum for displayable
  {$EXTERNALSYM LINE_LEN}
                                  // strings coming from a device INF.
  MAX_INF_STRING_LENGTH = 4096;   // Actual maximum size of an INF string
  {$EXTERNALSYM MAX_INF_STRING_LENGTH}
                                  // (including string substitutions).
  MAX_TITLE_LEN         = 60;
  {$EXTERNALSYM MAX_TITLE_LEN}
  MAX_INSTRUCTION_LEN   = 256;
  {$EXTERNALSYM MAX_INSTRUCTION_LEN}
  MAX_LABEL_LEN         = 30;
  {$EXTERNALSYM MAX_LABEL_LEN}
  MAX_SERVICE_NAME_LEN  = 256;
  {$EXTERNALSYM MAX_SERVICE_NAME_LEN}
  MAX_SUBTITLE_LEN      = 256;
  {$EXTERNALSYM MAX_SUBTITLE_LEN}

//
// Define maximum length of a machine name in the format expected by ConfigMgr32
// CM_Connect_Machine (i.e., "\\\\MachineName\0").
//

  SP_MAX_MACHINENAME_LENGTH = (MAX_PATH + 3);
  {$EXTERNALSYM SP_MAX_MACHINENAME_LENGTH}

//
// Define type for reference to loaded inf file
//

type
  HINF = Pointer;
  {$EXTERNALSYM HINF}

//
// Inf context structure. Applications must not interpret or
// overwrite values in these structures.
//
  PInfContext = ^TInfContext;
  _INFCONTEXT = packed record
    Inf: Pointer;
    CurrentInf: Pointer;
    Section: UINT;
    Line: UINT;
  end;
  {$EXTERNALSYM _INFCONTEXT}
  TInfContext = _INFCONTEXT;

//
// Inf file information structure.
//
  PSPInfInformation = ^TSPInfInformation;
  _SP_INF_INFORMATION = packed record
    InfStyle: DWORD;
    InfCount: DWORD;
    VersionData: array [0..ANYSIZE_ARRAY - 1] of Byte;
  end;
  {$EXTERNALSYM _SP_INF_INFORMATION}
  TSPInfInformation = _SP_INF_INFORMATION;

//
// Define structure for passing alternate platform info into
// SetupSetFileQueueAlternatePlatform and SetupQueryInfOriginalFileInformation.
//
  PSPAltPlatformInfo = ^TSPAltPlatformInfo;
  _SP_ALTPLATFORM_INFO = packed record
    cbSize: DWORD;
    //
    // platform to use (VER_PLATFORM_WIN32_WINDOWS or VER_PLATFORM_WIN32_NT)
    //
    Platform: DWORD;
    //
    // major and minor version numbers to use
    //
    MajorVersion: DWORD;
    MinorVersion: DWORD;
    //
    // processor architecture to use (PROCESSOR_ARCHITECTURE_INTEL,
    // PROCESSOR_ARCHITECTURE_ALPHA, PROCESSOR_ARCHITECTURE_IA64, or
    // PROCESSOR_ARCHITECTURE_ALPHA64)
    //
    ProcessorArchitecture: Word;
    Reserved: Word; // must be zero.
  end;
  {$EXTERNALSYM _SP_ALTPLATFORM_INFO}
  TSPAltPlatformInfo = _SP_ALTPLATFORM_INFO;

//
// Define structure that is filled in by SetupQueryInfOriginalFileInformation
// to indicate the INF's original name and the original name of the (potentially
// platform-specific) catalog file specified by that INF.
//
  PSPOriginalFileInfoA = ^TSPOriginalFileInfoA;
  PSPOriginalFileInfoW = ^TSPOriginalFileInfoW;
  PSPOriginalFileInfo = PSPOriginalFileInfoA;
  _SP_ORIGINAL_FILE_INFO_A = packed record
    cbSize: DWORD;
    OriginalInfName: array [0..MAX_PATH - 1] of AnsiChar;
    OriginalCatalogName: array [0..MAX_PATH - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _SP_ORIGINAL_FILE_INFO_A}
  _SP_ORIGINAL_FILE_INFO_W = packed record
    cbSize: DWORD;
    OriginalInfName: array [0..MAX_PATH - 1] of WideChar;
    OriginalCatalogName: array [0..MAX_PATH - 1] of WideChar;
  end;
  {$EXTERNALSYM _SP_ORIGINAL_FILE_INFO_W}
  _SP_ORIGINAL_FILE_INFO_ = _SP_ORIGINAL_FILE_INFO_A;
  TSPOriginalFileInfoA = _SP_ORIGINAL_FILE_INFO_A;
  TSPOriginalFileInfoW = _SP_ORIGINAL_FILE_INFO_W;
  TSPOriginalFileInfo = TSPOriginalFileInfoA;

//
// SP_INF_INFORMATION.InfStyle values
//
const
  INF_STYLE_NONE  = $00000000; // unrecognized or non-existent
  {$EXTERNALSYM INF_STYLE_NONE}
  INF_STYLE_OLDNT = $00000001; // winnt 3.x
  {$EXTERNALSYM INF_STYLE_OLDNT}
  INF_STYLE_WIN4  = $00000002; // Win95
  {$EXTERNALSYM INF_STYLE_WIN4}

//
// Additional InfStyle flags that may be specified when calling SetupOpenInfFile.
//
//
  INF_STYLE_CACHE_ENABLE  = $00000010; // always cache INF, even outside of %windir%\Inf
  {$EXTERNALSYM INF_STYLE_CACHE_ENABLE}
  INF_STYLE_CACHE_DISABLE = $00000020; // delete cached INF information
  {$EXTERNALSYM INF_STYLE_CACHE_DISABLE}

//
// Target directory specs.
//
  DIRID_ABSOLUTE       = DWORD(-1); // real 32-bit -1
  {$EXTERNALSYM DIRID_ABSOLUTE}
  DIRID_ABSOLUTE_16BIT = $FFFF; // 16-bit -1 for compat w/setupx
  {$EXTERNALSYM DIRID_ABSOLUTE_16BIT}
  DIRID_NULL           = 0;
  {$EXTERNALSYM DIRID_NULL}
  DIRID_SRCPATH        = 1;
  {$EXTERNALSYM DIRID_SRCPATH}
  DIRID_WINDOWS        = 10;
  {$EXTERNALSYM DIRID_WINDOWS}
  DIRID_SYSTEM         = 11; // system32
  {$EXTERNALSYM DIRID_SYSTEM}
  DIRID_DRIVERS        = 12;
  {$EXTERNALSYM DIRID_DRIVERS}
  DIRID_IOSUBSYS       = DIRID_DRIVERS;
  {$EXTERNALSYM DIRID_IOSUBSYS}
  DIRID_INF            = 17;
  {$EXTERNALSYM DIRID_INF}
  DIRID_HELP           = 18;
  {$EXTERNALSYM DIRID_HELP}
  DIRID_FONTS          = 20;
  {$EXTERNALSYM DIRID_FONTS}
  DIRID_VIEWERS        = 21;
  {$EXTERNALSYM DIRID_VIEWERS}
  DIRID_COLOR          = 23;
  {$EXTERNALSYM DIRID_COLOR}
  DIRID_APPS           = 24;
  {$EXTERNALSYM DIRID_APPS}
  DIRID_SHARED         = 25;
  {$EXTERNALSYM DIRID_SHARED}
  DIRID_BOOT           = 30;
  {$EXTERNALSYM DIRID_BOOT}

  DIRID_SYSTEM16       = 50;
  {$EXTERNALSYM DIRID_SYSTEM16}
  DIRID_SPOOL          = 51;
  {$EXTERNALSYM DIRID_SPOOL}
  DIRID_SPOOLDRIVERS   = 52;
  {$EXTERNALSYM DIRID_SPOOLDRIVERS}
  DIRID_USERPROFILE    = 53;
  {$EXTERNALSYM DIRID_USERPROFILE}
  DIRID_LOADER         = 54;
  {$EXTERNALSYM DIRID_LOADER}
  DIRID_PRINTPROCESSOR = 55;
  {$EXTERNALSYM DIRID_PRINTPROCESSOR}

  DIRID_DEFAULT        = DIRID_SYSTEM;
  {$EXTERNALSYM DIRID_DEFAULT}

//
// The following DIRIDs are for commonly-used shell "special folders".  The
// complete list of such folders is contained in shlobj.h.  In that headerfile,
// each folder is assigned a CSIDL_* value.  The DIRID values below are created
// by taking the CSIDL value in shlobj.h and OR'ing it with 0x4000.  Thus, if
// an INF needs to reference other special folders not defined below, it may
// generate one using the above mechanism, and setupapi will automatically deal
// with it and use the corresponding shell's path where appropriate.  (Remember
// that DIRIDs must be specified in decimal, not hex, in an INF when used for
// string substitution.)
//
  DIRID_COMMON_STARTMENU        = 16406; // All Users\Start Menu
  {$EXTERNALSYM DIRID_COMMON_STARTMENU}
  DIRID_COMMON_PROGRAMS         = 16407; // All Users\Start Menu\Programs
  {$EXTERNALSYM DIRID_COMMON_PROGRAMS}
  DIRID_COMMON_STARTUP          = 16408; // All Users\Start Menu\Programs\Startup
  {$EXTERNALSYM DIRID_COMMON_STARTUP}
  DIRID_COMMON_DESKTOPDIRECTORY = 16409; // All Users\Desktop
  {$EXTERNALSYM DIRID_COMMON_DESKTOPDIRECTORY}
  DIRID_COMMON_FAVORITES        = 16415; // All Users\Favorites
  {$EXTERNALSYM DIRID_COMMON_FAVORITES}
  DIRID_COMMON_APPDATA          = 16419; // All Users\Application Data
  {$EXTERNALSYM DIRID_COMMON_APPDATA}

  DIRID_PROGRAM_FILES           = 16422; // Program Files
  {$EXTERNALSYM DIRID_PROGRAM_FILES}
  DIRID_SYSTEM_X86              = 16425; // system32 on RISC
  {$EXTERNALSYM DIRID_SYSTEM_X86}
  DIRID_PROGRAM_FILES_X86       = 16426; // Program Files on RISC
  {$EXTERNALSYM DIRID_PROGRAM_FILES_X86}
  DIRID_PROGRAM_FILES_COMMON    = 16427; // Program Files\Common
  {$EXTERNALSYM DIRID_PROGRAM_FILES_COMMON}
  DIRID_PROGRAM_FILES_COMMONX86 = 16428; // x86 Program Files\Common on RISC
  {$EXTERNALSYM DIRID_PROGRAM_FILES_COMMONX86}

  DIRID_COMMON_TEMPLATES        = 16429; // All Users\Templates
  {$EXTERNALSYM DIRID_COMMON_TEMPLATES}
  DIRID_COMMON_DOCUMENTS        = 16430; // All Users\Documents
  {$EXTERNALSYM DIRID_COMMON_DOCUMENTS}

//
// First user-definable dirid. See SetupSetDirectoryId().
//
  DIRID_USER = $8000;
  {$EXTERNALSYM DIRID_USER}

//
// Setup callback notification routine type
//
type
  TSPFileCallbackA = function (Context: Pointer; Notification: UINT;
    Param1, Param2: UINT_PTR): UINT; stdcall;
  TSPFileCallbackW = function (Context: Pointer; Notification: UINT;
    Param1, Param2: UINT_PTR): UINT; stdcall;
  TSPFileCallback = TSPFileCallbackA;

//
// Operation/queue start/end notification. These are ordinal values.
//
const
  SPFILENOTIFY_STARTQUEUE    = $00000001;
  {$EXTERNALSYM SPFILENOTIFY_STARTQUEUE}
  SPFILENOTIFY_ENDQUEUE      = $00000002;
  {$EXTERNALSYM SPFILENOTIFY_ENDQUEUE}
  SPFILENOTIFY_STARTSUBQUEUE = $00000003;
  {$EXTERNALSYM SPFILENOTIFY_STARTSUBQUEUE}
  SPFILENOTIFY_ENDSUBQUEUE   = $00000004;
  {$EXTERNALSYM SPFILENOTIFY_ENDSUBQUEUE}
  SPFILENOTIFY_STARTDELETE   = $00000005;
  {$EXTERNALSYM SPFILENOTIFY_STARTDELETE}
  SPFILENOTIFY_ENDDELETE     = $00000006;
  {$EXTERNALSYM SPFILENOTIFY_ENDDELETE}
  SPFILENOTIFY_DELETEERROR   = $00000007;
  {$EXTERNALSYM SPFILENOTIFY_DELETEERROR}
  SPFILENOTIFY_STARTRENAME   = $00000008;
  {$EXTERNALSYM SPFILENOTIFY_STARTRENAME}
  SPFILENOTIFY_ENDRENAME     = $00000009;
  {$EXTERNALSYM SPFILENOTIFY_ENDRENAME}
  SPFILENOTIFY_RENAMEERROR   = $0000000a;
  {$EXTERNALSYM SPFILENOTIFY_RENAMEERROR}
  SPFILENOTIFY_STARTCOPY     = $0000000b;
  {$EXTERNALSYM SPFILENOTIFY_STARTCOPY}
  SPFILENOTIFY_ENDCOPY       = $0000000c;
  {$EXTERNALSYM SPFILENOTIFY_ENDCOPY}
  SPFILENOTIFY_COPYERROR     = $0000000d;
  {$EXTERNALSYM SPFILENOTIFY_COPYERROR}
  SPFILENOTIFY_NEEDMEDIA     = $0000000e;
  {$EXTERNALSYM SPFILENOTIFY_NEEDMEDIA}
  SPFILENOTIFY_QUEUESCAN     = $0000000f;
  {$EXTERNALSYM SPFILENOTIFY_QUEUESCAN}

//
// These are used with SetupIterateCabinet().
//
  SPFILENOTIFY_CABINETINFO    = $00000010;
  {$EXTERNALSYM SPFILENOTIFY_CABINETINFO}
  SPFILENOTIFY_FILEINCABINET  = $00000011;
  {$EXTERNALSYM SPFILENOTIFY_FILEINCABINET}
  SPFILENOTIFY_NEEDNEWCABINET = $00000012;
  {$EXTERNALSYM SPFILENOTIFY_NEEDNEWCABINET}
  SPFILENOTIFY_FILEEXTRACTED  = $00000013;
  {$EXTERNALSYM SPFILENOTIFY_FILEEXTRACTED}
  SPFILENOTIFY_FILEOPDELAYED  = $00000014;
  {$EXTERNALSYM SPFILENOTIFY_FILEOPDELAYED}

//
// These are used for backup operations
//
  SPFILENOTIFY_STARTBACKUP = $00000015;
  {$EXTERNALSYM SPFILENOTIFY_STARTBACKUP}
  SPFILENOTIFY_BACKUPERROR = $00000016;
  {$EXTERNALSYM SPFILENOTIFY_BACKUPERROR}
  SPFILENOTIFY_ENDBACKUP   = $00000017;
  {$EXTERNALSYM SPFILENOTIFY_ENDBACKUP}

//
// Extended notification for SetupScanFileQueue(Flags=SPQ_SCAN_USE_CALLBACKEX)
//
  SPFILENOTIFY_QUEUESCAN_EX = $00000018;
  {$EXTERNALSYM SPFILENOTIFY_QUEUESCAN_EX}

//
// Copy notification. These are bit flags that may be combined.
//
  SPFILENOTIFY_LANGMISMATCH = $00010000;
  {$EXTERNALSYM SPFILENOTIFY_LANGMISMATCH}
  SPFILENOTIFY_TARGETEXISTS = $00020000;
  {$EXTERNALSYM SPFILENOTIFY_TARGETEXISTS}
  SPFILENOTIFY_TARGETNEWER  = $00040000;
  {$EXTERNALSYM SPFILENOTIFY_TARGETNEWER}

//
// File operation codes and callback outcomes.
//
  FILEOP_COPY   = 0;
  {$EXTERNALSYM FILEOP_COPY}
  FILEOP_RENAME = 1;
  {$EXTERNALSYM FILEOP_RENAME}
  FILEOP_DELETE = 2;
  {$EXTERNALSYM FILEOP_DELETE}
  FILEOP_BACKUP = 3;
  {$EXTERNALSYM FILEOP_BACKUP}

  FILEOP_ABORT   = 0;
  {$EXTERNALSYM FILEOP_ABORT}
  FILEOP_DOIT    = 1;
  {$EXTERNALSYM FILEOP_DOIT}
  FILEOP_SKIP    = 2;
  {$EXTERNALSYM FILEOP_SKIP}
  FILEOP_RETRY   = FILEOP_DOIT;
  {$EXTERNALSYM FILEOP_RETRY}
  FILEOP_NEWPATH = 4;
  {$EXTERNALSYM FILEOP_NEWPATH}

//
// Flags in inf copy sections
//
  COPYFLG_WARN_IF_SKIP         = $00000001; // warn if user tries to skip file
  {$EXTERNALSYM COPYFLG_WARN_IF_SKIP}
  COPYFLG_NOSKIP               = $00000002; // disallow skipping this file
  {$EXTERNALSYM COPYFLG_NOSKIP}
  COPYFLG_NOVERSIONCHECK       = $00000004; // ignore versions and overwrite target
  {$EXTERNALSYM COPYFLG_NOVERSIONCHECK}
  COPYFLG_FORCE_FILE_IN_USE    = $00000008; // force file-in-use behavior
  {$EXTERNALSYM COPYFLG_FORCE_FILE_IN_USE}
  COPYFLG_NO_OVERWRITE         = $00000010; // do not copy if file exists on target
  {$EXTERNALSYM COPYFLG_NO_OVERWRITE}
  COPYFLG_NO_VERSION_DIALOG    = $00000020; // do not copy if target is newer
  {$EXTERNALSYM COPYFLG_NO_VERSION_DIALOG}
  COPYFLG_OVERWRITE_OLDER_ONLY = $00000040; // leave target alone if version same as source
  {$EXTERNALSYM COPYFLG_OVERWRITE_OLDER_ONLY}
  COPYFLG_REPLACEONLY          = $00000400; // copy only if file exists on target
  {$EXTERNALSYM COPYFLG_REPLACEONLY}
  COPYFLG_NODECOMP             = $00000800; // don't attempt to decompress file; copy as-is
  {$EXTERNALSYM COPYFLG_NODECOMP}
  COPYFLG_REPLACE_BOOT_FILE    = $00001000; // file must be present upon reboot (i.e., it's
  {$EXTERNALSYM COPYFLG_REPLACE_BOOT_FILE}  // needed by the loader); this flag implies a reboot
  COPYFLG_NOPRUNE              = $00002000; // never prune this file
  {$EXTERNALSYM COPYFLG_NOPRUNE}

//
// Flags in inf delete sections
// New flags go in high word
//
  DELFLG_IN_USE  = $00000001; // queue in-use file for delete
  {$EXTERNALSYM DELFLG_IN_USE}
  DELFLG_IN_USE1 = $00010000; // high-word version of DELFLG_IN_USE
  {$EXTERNALSYM DELFLG_IN_USE1}

//
// Source and file paths. Used when notifying queue callback
// of SPFILENOTIFY_STARTxxx, SPFILENOTIFY_ENDxxx, and SPFILENOTIFY_xxxERROR.
//
type
  PFilePathsA = ^TFilePathsA;
  PFilePathsW = ^TFilePathsW;
  PFilePaths = PFilePathsA;
  _FILEPATHS_A = packed record
    Target: PAnsiChar;
    Source: PAnsiChar; // not used for delete operations
    Win32Error: UINT;
    Flags: DWORD; // such as SP_COPY_NOSKIP for copy errors
  end;
  {$EXTERNALSYM _FILEPATHS_A}
  _FILEPATHS_W = packed record
    Target: PWideChar;
    Source: PWideChar; // not used for delete operations
    Win32Error: UINT;
    Flags: DWORD; // such as SP_COPY_NOSKIP for copy errors
  end;
  {$EXTERNALSYM _FILEPATHS_W}
  _FILEPATHS_ = _FILEPATHS_A;
  TFilePathsA = _FILEPATHS_A;
  TFilePathsW = _FILEPATHS_W;
  TFilePaths = TFilePathsA;

//
// Structure used with SPFILENOTIFY_NEEDMEDIA
//
  PSourceMediaA = ^TSourceMediaA;
  PSourceMediaW = ^TSourceMediaW;
  PSourceMedia = PSourceMediaA;
  _SOURCE_MEDIA_A = packed record
    Reserved: PAnsiChar;
    Tagfile: PAnsiChar; // may be NULL
    Description: PAnsiChar;
    //
    // Pathname part and filename part of source file
    // that caused us to need the media.
    //
    SourcePath: PAnsiChar;
    SourceFile: PAnsiChar;
    Flags: DWORD; // subset of SP_COPY_xxx
  end;
  {$EXTERNALSYM _SOURCE_MEDIA_A}
  _SOURCE_MEDIA_W = packed record
    Reserved: PWideChar;
    Tagfile: PWideChar; // may be NULL
    Description: PWideChar;
    //
    // Pathname part and filename part of source file
    // that caused us to need the media.
    //
    SourcePath: PWideChar;
    SourceFile: PWideChar;
    Flags: DWORD; // subset of SP_COPY_xxx
  end;
  {$EXTERNALSYM _SOURCE_MEDIA_W}
  _SOURCE_MEDIA_ = _SOURCE_MEDIA_A;
  TSourceMediaA = _SOURCE_MEDIA_A;
  TSourceMediaW = _SOURCE_MEDIA_W;
  TSourceMedia = TSourceMediaA;

//
// Structure used with SPFILENOTIFY_CABINETINFO and
// SPFILENOTIFY_NEEDNEWCABINET
//
  PCabinetInfoA = ^TCabinetInfoA;
  PCabinetInfoW = ^TCabinetInfoW;
  PCabinetInfo = PCabinetInfoA;
  _CABINET_INFO_A = packed record
    CabinetPath: PAnsiChar;
    CabinetFile: PAnsiChar;
    DiskName: PAnsiChar;
    SetId: Word;
    CabinetNumber: Word;
  end;
  {$EXTERNALSYM _CABINET_INFO_A}
  _CABINET_INFO_W = packed record
    CabinetPath: PWideChar;
    CabinetFile: PWideChar;
    DiskName: PWideChar;
    SetId: Word;
    CabinetNumber: Word;
  end;
  {$EXTERNALSYM _CABINET_INFO_W}
  _CABINET_INFO_ = _CABINET_INFO_A;
  TCabinetInfoA = _CABINET_INFO_A;
  TCabinetInfoW = _CABINET_INFO_W;
  TCabinetInfo = TCabinetInfoA;

//
// Structure used with SPFILENOTIFY_FILEINCABINET
//
  PFileInCabinetInfoA = ^TFileInCabinetInfoA;
  PFileInCabinetInfoW = ^TFileInCabinetInfoW;
  PFileInCabinetInfo = PFileInCabinetInfoA;
  _FILE_IN_CABINET_INFO_A = packed record
    NameInCabinet: PAnsiChar;
    FileSize: DWORD;
    Win32Error: DWORD;
    DosDate: Word;
    DosTime: Word;
    DosAttribs: Word;
    FullTargetName: array [0..MAX_PATH - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _FILE_IN_CABINET_INFO_A}
  _FILE_IN_CABINET_INFO_W = packed record
    NameInCabinet: PWideChar;
    FileSize: DWORD;
    Win32Error: DWORD;
    DosDate: Word;
    DosTime: Word;
    DosAttribs: Word;
    FullTargetName: array [0..MAX_PATH - 1] of WideChar;
  end;
  {$EXTERNALSYM _FILE_IN_CABINET_INFO_W}
  _FILE_IN_CABINET_INFO_ = _FILE_IN_CABINET_INFO_A;
  TFileInCabinetInfoA = _FILE_IN_CABINET_INFO_A;
  TFileInCabinetInfoW = _FILE_IN_CABINET_INFO_W;
  TFileInCabinetInfo = TFileInCabinetInfoA;

//
// Define type for setup file queue
//
  HSPFILEQ = Pointer;
  {$EXTERNALSYM HSPFILEQ}

//
// Structure used with SetupQueueCopyIndirect
//
  PSPFileCopyParamsA = ^TSPFileCopyParamsA;
  PSPFileCopyParamsW = ^TSPFileCopyParamsW;
  PSPFileCopyParams = PSPFileCopyParamsA;
  _SP_FILE_COPY_PARAMS_A = packed record
    cbSize: DWORD;
    QueueHandle: HSPFILEQ;
    SourceRootPath: PAnsiChar;
    SourcePath: PAnsiChar;
    SourceFilename: PAnsiChar;
    SourceDescription: PAnsiChar;
    SourceTagfile: PAnsiChar;
    TargetDirectory: PAnsiChar;
    TargetFilename: PAnsiChar;
    CopyStyle: DWORD;
    LayoutInf: HINF;
    SecurityDescriptor: PAnsiChar;
  end;
  {$EXTERNALSYM _SP_FILE_COPY_PARAMS_A}
  _SP_FILE_COPY_PARAMS_W = packed record
    cbSize: DWORD;
    QueueHandle: HSPFILEQ;
    SourceRootPath: PWideChar;
    SourcePath: PWideChar;
    SourceFilename: PWideChar;
    SourceDescription: PWideChar;
    SourceTagfile: PWideChar;
    TargetDirectory: PWideChar;
    TargetFilename: PWideChar;
    CopyStyle: DWORD;
    LayoutInf: HINF;
    SecurityDescriptor: PWideChar;
  end;
  {$EXTERNALSYM _SP_FILE_COPY_PARAMS_W}
  _SP_FILE_COPY_PARAMS_ = _SP_FILE_COPY_PARAMS_A;
  TSPFileCopyParamsA = _SP_FILE_COPY_PARAMS_A;
  TSPFileCopyParamsW = _SP_FILE_COPY_PARAMS_W;
  TSPFileCopyParams = TSPFileCopyParamsA;

//
// Define type for setup disk space list
//
  HDSKSPC = Pointer;
  {$EXTERNALSYM HDSKSPC}

//
// Define type for reference to device information set
//
  HDEVINFO = Pointer;
  {$EXTERNALSYM HDEVINFO}

//
// Device information structure (references a device instance
// that is a member of a device information set)
//
  PSPDevInfoData = ^TSPDevInfoData;
  _SP_DEVINFO_DATA = packed record
    cbSize: DWORD;
    ClassGuid: TGUID;
    DevInst: DWORD; // DEVINST handle
    Reserved: ULONG_PTR;
  end;
  {$EXTERNALSYM _SP_DEVINFO_DATA}
  TSPDevInfoData = _SP_DEVINFO_DATA;

//
// Device interface information structure (references a device
// interface that is associated with the device information
// element that owns it).
//
  PSPDeviceInterfaceData = ^TSPDeviceInterfaceData;
  _SP_DEVICE_INTERFACE_DATA = packed record
    cbSize: DWORD;
    InterfaceClassGuid: TGUID;
    Flags: DWORD;
    Reserved: ULONG_PTR;
  end;
  {$EXTERNALSYM _SP_DEVICE_INTERFACE_DATA}
  TSPDeviceInterfaceData = _SP_DEVICE_INTERFACE_DATA;

//
// Flags for SP_DEVICE_INTERFACE_DATA.Flags field.
//
const
  SPINT_ACTIVE  = $00000001;
  {$EXTERNALSYM SPINT_ACTIVE}
  SPINT_DEFAULT = $00000002;
  {$EXTERNALSYM SPINT_DEFAULT}
  SPINT_REMOVED = $00000004;
  {$EXTERNALSYM SPINT_REMOVED}

//
// Backward compatibility--do not use.
//

type
  TSPInterfaceDeviceData = TSPDeviceInterfaceData;
  PSPInterfaceDeviceData = PSPDeviceInterfaceData;

const
  SPID_ACTIVE  = SPINT_ACTIVE;
  {$EXTERNALSYM SPID_ACTIVE}
  SPID_DEFAULT = SPINT_DEFAULT;
  {$EXTERNALSYM SPID_DEFAULT}
  SPID_REMOVED = SPINT_REMOVED;
  {$EXTERNALSYM SPID_REMOVED}

type
  PSPDeviceInterfaceDetailDataA = ^TSPDeviceInterfaceDetailDataA;
  PSPDeviceInterfaceDetailDataW = ^TSPDeviceInterfaceDetailDataW;
  PSPDeviceInterfaceDetailData = PSPDeviceInterfaceDetailDataA;
  _SP_DEVICE_INTERFACE_DETAIL_DATA_A = packed record
    cbSize: DWORD;
    DevicePath: array [0..ANYSIZE_ARRAY - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _SP_DEVICE_INTERFACE_DETAIL_DATA_A}
  _SP_DEVICE_INTERFACE_DETAIL_DATA_W = packed record
    cbSize: DWORD;
    DevicePath: array [0..ANYSIZE_ARRAY - 1] of WideChar;
  end;
  {$EXTERNALSYM _SP_DEVICE_INTERFACE_DETAIL_DATA_W}
  _SP_DEVICE_INTERFACE_DETAIL_DATA_ = _SP_DEVICE_INTERFACE_DETAIL_DATA_A;
  TSPDeviceInterfaceDetailDataA = _SP_DEVICE_INTERFACE_DETAIL_DATA_A;
  TSPDeviceInterfaceDetailDataW = _SP_DEVICE_INTERFACE_DETAIL_DATA_W;
  TSPDeviceInterfaceDetailData = TSPDeviceInterfaceDetailDataA;

//
// Backward compatibility--do not use.
//

  TSPInterfaceDeviceDetailDataA = TSPDeviceInterfaceDetailDataA;
  TSPInterfaceDeviceDetailDataW = TSPDeviceInterfaceDetailDataW;
  TSPInterfaceDeviceDetailData = TSPInterfaceDeviceDetailDataA;
  PSPInterfaceDeviceDetailDataA = PSPDeviceInterfaceDetailDataA;
  PSPInterfaceDeviceDetailDataW = PSPDeviceInterfaceDetailDataW;
  PSPInterfaceDeviceDetailData = PSPInterfaceDeviceDetailDataA;

//
// Structure for detailed information on a device information set (used for
// SetupDiGetDeviceInfoListDetail which supercedes the functionality of
// SetupDiGetDeviceInfoListClass).
//
  PSPDevInfoListDetailDataA = ^TSPDevInfoListDetailDataA;
  PSPDevInfoListDetailDataW = ^TSPDevInfoListDetailDataW;
  PSPDevInfoListDetailData = PSPDevInfoListDetailDataA;
  _SP_DEVINFO_LIST_DETAIL_DATA_A = packed record
    cbSize: DWORD;
    ClassGuid: TGUID;
    RemoteMachineHandle: THandle;
    RemoteMachineName: array [0..SP_MAX_MACHINENAME_LENGTH - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _SP_DEVINFO_LIST_DETAIL_DATA_A}
  _SP_DEVINFO_LIST_DETAIL_DATA_W = packed record
    cbSize: DWORD;
    ClassGuid: TGUID;
    RemoteMachineHandle: THandle;
    RemoteMachineName: array [0..SP_MAX_MACHINENAME_LENGTH - 1] of WideChar;
  end;
  {$EXTERNALSYM _SP_DEVINFO_LIST_DETAIL_DATA_W}
  _SP_DEVINFO_LIST_DETAIL_DATA_ = _SP_DEVINFO_LIST_DETAIL_DATA_A;
  TSPDevInfoListDetailDataA = _SP_DEVINFO_LIST_DETAIL_DATA_A;
  TSPDevInfoListDetailDataW = _SP_DEVINFO_LIST_DETAIL_DATA_W;
  TSPDevInfoListDetailData = TSPDevInfoListDetailDataA;

//
// Class installer function codes
//
const
  DIF_SELECTDEVICE                  = $00000001;
  {$EXTERNALSYM DIF_SELECTDEVICE}
  DIF_INSTALLDEVICE                 = $00000002;
  {$EXTERNALSYM DIF_INSTALLDEVICE}
  DIF_ASSIGNRESOURCES               = $00000003;
  {$EXTERNALSYM DIF_ASSIGNRESOURCES}
  DIF_PROPERTIES                    = $00000004;
  {$EXTERNALSYM DIF_PROPERTIES}
  DIF_REMOVE                        = $00000005;
  {$EXTERNALSYM DIF_REMOVE}
  DIF_FIRSTTIMESETUP                = $00000006;
  {$EXTERNALSYM DIF_FIRSTTIMESETUP}
  DIF_FOUNDDEVICE                   = $00000007;
  {$EXTERNALSYM DIF_FOUNDDEVICE}
  DIF_SELECTCLASSDRIVERS            = $00000008;
  {$EXTERNALSYM DIF_SELECTCLASSDRIVERS}
  DIF_VALIDATECLASSDRIVERS          = $00000009;
  {$EXTERNALSYM DIF_VALIDATECLASSDRIVERS}
  DIF_INSTALLCLASSDRIVERS           = $0000000A;
  {$EXTERNALSYM DIF_INSTALLCLASSDRIVERS}
  DIF_CALCDISKSPACE                 = $0000000B;
  {$EXTERNALSYM DIF_CALCDISKSPACE}
  DIF_DESTROYPRIVATEDATA            = $0000000C;
  {$EXTERNALSYM DIF_DESTROYPRIVATEDATA}
  DIF_VALIDATEDRIVER                = $0000000D;
  {$EXTERNALSYM DIF_VALIDATEDRIVER}
  DIF_MOVEDEVICE                    = $0000000E;
  {$EXTERNALSYM DIF_MOVEDEVICE}
  DIF_DETECT                        = $0000000F;
  {$EXTERNALSYM DIF_DETECT}
  DIF_INSTALLWIZARD                 = $00000010;
  {$EXTERNALSYM DIF_INSTALLWIZARD}
  DIF_DESTROYWIZARDDATA             = $00000011;
  {$EXTERNALSYM DIF_DESTROYWIZARDDATA}
  DIF_PROPERTYCHANGE                = $00000012;
  {$EXTERNALSYM DIF_PROPERTYCHANGE}
  DIF_ENABLECLASS                   = $00000013;
  {$EXTERNALSYM DIF_ENABLECLASS}
  DIF_DETECTVERIFY                  = $00000014;
  {$EXTERNALSYM DIF_DETECTVERIFY}
  DIF_INSTALLDEVICEFILES            = $00000015;
  {$EXTERNALSYM DIF_INSTALLDEVICEFILES}
  DIF_UNREMOVE                      = $00000016;
  {$EXTERNALSYM DIF_UNREMOVE}
  DIF_SELECTBESTCOMPATDRV           = $00000017;
  {$EXTERNALSYM DIF_SELECTBESTCOMPATDRV}
  DIF_ALLOW_INSTALL                 = $00000018;
  {$EXTERNALSYM DIF_ALLOW_INSTALL}
  DIF_REGISTERDEVICE                = $00000019;
  {$EXTERNALSYM DIF_REGISTERDEVICE}
  DIF_NEWDEVICEWIZARD_PRESELECT     = $0000001A;
  {$EXTERNALSYM DIF_NEWDEVICEWIZARD_PRESELECT}
  DIF_NEWDEVICEWIZARD_SELECT        = $0000001B;
  {$EXTERNALSYM DIF_NEWDEVICEWIZARD_SELECT}
  DIF_NEWDEVICEWIZARD_PREANALYZE    = $0000001C;
  {$EXTERNALSYM DIF_NEWDEVICEWIZARD_PREANALYZE}
  DIF_NEWDEVICEWIZARD_POSTANALYZE   = $0000001D;
  {$EXTERNALSYM DIF_NEWDEVICEWIZARD_POSTANALYZE}
  DIF_NEWDEVICEWIZARD_FINISHINSTALL = $0000001E;
  {$EXTERNALSYM DIF_NEWDEVICEWIZARD_FINISHINSTALL}
  DIF_UNUSED1                       = $0000001F;
  {$EXTERNALSYM DIF_UNUSED1}
  DIF_INSTALLINTERFACES             = $00000020;
  {$EXTERNALSYM DIF_INSTALLINTERFACES}
  DIF_DETECTCANCEL                  = $00000021;
  {$EXTERNALSYM DIF_DETECTCANCEL}
  DIF_REGISTER_COINSTALLERS         = $00000022;
  {$EXTERNALSYM DIF_REGISTER_COINSTALLERS}
  DIF_ADDPROPERTYPAGE_ADVANCED      = $00000023;
  {$EXTERNALSYM DIF_ADDPROPERTYPAGE_ADVANCED}
  DIF_ADDPROPERTYPAGE_BASIC         = $00000024;
  {$EXTERNALSYM DIF_ADDPROPERTYPAGE_BASIC}
  DIF_RESERVED1                     = $00000025;
  {$EXTERNALSYM DIF_RESERVED1}
  DIF_TROUBLESHOOTER                = $00000026;
  {$EXTERNALSYM DIF_TROUBLESHOOTER}
  DIF_POWERMESSAGEWAKE              = $00000027;
  {$EXTERNALSYM DIF_POWERMESSAGEWAKE}

type
  DI_FUNCTION = UINT;    // Function type for device installer
  {$EXTERNALSYM DI_FUNCTION}

//
// Device installation parameters structure (associated with a
// particular device information element, or globally with a device
// information set)
//
  PSPDevInstallParamsA = ^TSPDevInstallParamsA;
  PSPDevInstallParamsW = ^TSPDevInstallParamsW;
  PSPDevInstallParams = PSPDevInstallParamsA;
  _SP_DEVINSTALL_PARAMS_A = packed record
    cbSize: DWORD;
    Flags: DWORD;
    FlagsEx: DWORD;
    hwndParent: HWND;
    InstallMsgHandler: TSPFileCallback;
    InstallMsgHandlerContext: Pointer;
    FileQueue: HSPFILEQ;
    ClassInstallReserved: ULONG_PTR;
    Reserved: DWORD;
    DriverPath: array [0..MAX_PATH - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _SP_DEVINSTALL_PARAMS_A}
  _SP_DEVINSTALL_PARAMS_W = packed record
    cbSize: DWORD;
    Flags: DWORD;
    FlagsEx: DWORD;
    hwndParent: HWND;
    InstallMsgHandler: TSPFileCallback;
    InstallMsgHandlerContext: Pointer;
    FileQueue: HSPFILEQ;
    ClassInstallReserved: ULONG_PTR;
    Reserved: DWORD;
    DriverPath: array [0..MAX_PATH - 1] of WideChar;
  end;
  {$EXTERNALSYM _SP_DEVINSTALL_PARAMS_W}
  _SP_DEVINSTALL_PARAMS_ = _SP_DEVINSTALL_PARAMS_A;
  TSPDevInstallParamsA = _SP_DEVINSTALL_PARAMS_A;
  TSPDevInstallParamsW = _SP_DEVINSTALL_PARAMS_W;
  TSPDevInstallParams = TSPDevInstallParamsA;

//
// SP_DEVINSTALL_PARAMS.Flags values
//
// Flags for choosing a device
//
const
  DI_SHOWOEM       = $00000001; // support Other... button
  {$EXTERNALSYM DI_SHOWOEM}
  DI_SHOWCOMPAT    = $00000002; // show compatibility list
  {$EXTERNALSYM DI_SHOWCOMPAT}
  DI_SHOWCLASS     = $00000004; // show class list
  {$EXTERNALSYM DI_SHOWCLASS}
  DI_SHOWALL       = $00000007; // both class & compat list shown
  {$EXTERNALSYM DI_SHOWALL}
  DI_NOVCP         = $00000008; // don't create a new copy queue--use
  {$EXTERNALSYM DI_NOVCP}     // caller-supplied FileQueue
  DI_DIDCOMPAT     = $00000010; // Searched for compatible devices
  {$EXTERNALSYM DI_DIDCOMPAT}
  DI_DIDCLASS      = $00000020; // Searched for class devices
  {$EXTERNALSYM DI_DIDCLASS}
  DI_AUTOASSIGNRES = $00000040; // No UI for resources if possible
  {$EXTERNALSYM DI_AUTOASSIGNRES}

// flags returned by DiInstallDevice to indicate need to reboot/restart
  DI_NEEDRESTART = $00000080; // Reboot required to take effect
  {$EXTERNALSYM DI_NEEDRESTART}
  DI_NEEDREBOOT  = $00000100; // ""
  {$EXTERNALSYM DI_NEEDREBOOT}

// flags for device installation
  DI_NOBROWSE = $00000200; // no Browse... in InsertDisk
  {$EXTERNALSYM DI_NOBROWSE}

// Flags set by DiBuildDriverInfoList
  DI_MULTMFGS = $00000400;   // Set if multiple manufacturers in
  {$EXTERNALSYM DI_MULTMFGS} // class driver list

// Flag indicates that device is disabled
  DI_DISABLED = $00000800; // Set if device disabled
  {$EXTERNALSYM DI_DISABLED}

// Flags for Device/Class Properties
  DI_GENERALPAGE_ADDED  = $00001000;
  {$EXTERNALSYM DI_GENERALPAGE_ADDED}
  DI_RESOURCEPAGE_ADDED = $00002000;
  {$EXTERNALSYM DI_RESOURCEPAGE_ADDED}

// Flag to indicate the setting properties for this Device (or class) caused a change
// so the Dev Mgr UI probably needs to be updatd.
  DI_PROPERTIES_CHANGE = $00004000;
  {$EXTERNALSYM DI_PROPERTIES_CHANGE}

// Flag to indicate that the sorting from the INF file should be used.
  DI_INF_IS_SORTED = $00008000;
  {$EXTERNALSYM DI_INF_IS_SORTED}

// Flag to indicate that only the the INF specified by SP_DEVINSTALL_PARAMS.DriverPath
// should be searched.
  DI_ENUMSINGLEINF = $00010000;
  {$EXTERNALSYM DI_ENUMSINGLEINF}

// Flag that prevents ConfigMgr from removing/re-enumerating devices during device
// registration, installation, and deletion.
  DI_DONOTCALLCONFIGMG = $00020000;
  {$EXTERNALSYM DI_DONOTCALLCONFIGMG}

// The following flag can be used to install a device disabled
  DI_INSTALLDISABLED = $00040000;
  {$EXTERNALSYM DI_INSTALLDISABLED}

// Flag that causes SetupDiBuildDriverInfoList to build a device's compatible driver
// list from its existing class driver list, instead of the normal INF search.
  DI_COMPAT_FROM_CLASS = $00080000;
  {$EXTERNALSYM DI_COMPAT_FROM_CLASS}

// This flag is set if the Class Install params should be used.
  DI_CLASSINSTALLPARAMS = $00100000;
  {$EXTERNALSYM DI_CLASSINSTALLPARAMS}

// This flag is set if the caller of DiCallClassInstaller does NOT
// want the internal default action performed if the Class installer
// returns ERROR_DI_DO_DEFAULT.
  DI_NODI_DEFAULTACTION = $00200000;
  {$EXTERNALSYM DI_NODI_DEFAULTACTION}

// The setupx flag, DI_NOSYNCPROCESSING (0x00400000L) is not support in the Setup APIs.

// flags for device installation
  DI_QUIETINSTALL        = $00800000; // don't confuse the user with
  {$EXTERNALSYM DI_QUIETINSTALL}      // questions or excess info
  DI_NOFILECOPY          = $01000000; // No file Copy necessary
  {$EXTERNALSYM DI_NOFILECOPY}
  DI_FORCECOPY           = $02000000; // Force files to be copied from install path
  {$EXTERNALSYM DI_FORCECOPY}
  DI_DRIVERPAGE_ADDED    = $04000000; // Prop provider added Driver page.
  {$EXTERNALSYM DI_DRIVERPAGE_ADDED}
  DI_USECI_SELECTSTRINGS = $08000000; // Use Class Installer Provided strings in the Select Device Dlg
  {$EXTERNALSYM DI_USECI_SELECTSTRINGS}
  DI_OVERRIDE_INFFLAGS   = $10000000; // Override INF flags
  {$EXTERNALSYM DI_OVERRIDE_INFFLAGS}
  DI_PROPS_NOCHANGEUSAGE = $20000000; // No Enable/Disable in General Props
  {$EXTERNALSYM DI_PROPS_NOCHANGEUSAGE}

  DI_NOSELECTICONS       = $40000000; // No small icons in select device dialogs
  {$EXTERNALSYM DI_NOSELECTICONS}

  DI_NOWRITE_IDS         = DWORD($80000000); // Don't write HW & Compat IDs on install
  {$EXTERNALSYM DI_NOWRITE_IDS}

//
// SP_DEVINSTALL_PARAMS.FlagsEx values
//
  DI_FLAGSEX_USEOLDINFSEARCH          = $00000001; // Inf Search functions should not use Index Search
  {$EXTERNALSYM DI_FLAGSEX_USEOLDINFSEARCH}
  DI_FLAGSEX_AUTOSELECTRANK0          = $00000002; // SetupDiSelectDevice doesn't prompt user if rank 0 match
  {$EXTERNALSYM DI_FLAGSEX_AUTOSELECTRANK0}
  DI_FLAGSEX_CI_FAILED                = $00000004; // Failed to Load/Call class installer
  {$EXTERNALSYM DI_FLAGSEX_CI_FAILED}

  DI_FLAGSEX_DIDINFOLIST              = $00000010; // Did the Class Info List
  {$EXTERNALSYM DI_FLAGSEX_DIDINFOLIST}
  DI_FLAGSEX_DIDCOMPATINFO            = $00000020; // Did the Compat Info List
  {$EXTERNALSYM DI_FLAGSEX_DIDCOMPATINFO}

  DI_FLAGSEX_FILTERCLASSES            = $00000040;
  {$EXTERNALSYM DI_FLAGSEX_FILTERCLASSES}
  DI_FLAGSEX_SETFAILEDINSTALL         = $00000080;
  {$EXTERNALSYM DI_FLAGSEX_SETFAILEDINSTALL}
  DI_FLAGSEX_DEVICECHANGE             = $00000100;
  {$EXTERNALSYM DI_FLAGSEX_DEVICECHANGE}
  DI_FLAGSEX_ALWAYSWRITEIDS           = $00000200;
  {$EXTERNALSYM DI_FLAGSEX_ALWAYSWRITEIDS}
  DI_FLAGSEX_PROPCHANGE_PENDING       = $00000400; // One or more device property sheets have had changes made
  {$EXTERNALSYM DI_FLAGSEX_PROPCHANGE_PENDING}     // to them, and need to have a DIF_PROPERTYCHANGE occur.

  DI_FLAGSEX_ALLOWEXCLUDEDDRVS        = $00000800;
  {$EXTERNALSYM DI_FLAGSEX_ALLOWEXCLUDEDDRVS}
  DI_FLAGSEX_NOUIONQUERYREMOVE        = $00001000;
  {$EXTERNALSYM DI_FLAGSEX_NOUIONQUERYREMOVE}
  DI_FLAGSEX_USECLASSFORCOMPAT        = $00002000; // Use the device's class when building compat drv list.
  {$EXTERNALSYM DI_FLAGSEX_USECLASSFORCOMPAT}      // (Ignored if DI_COMPAT_FROM_CLASS flag is specified.)
  DI_FLAGSEX_OLDINF_IN_CLASSLIST      = $00004000; // Search legacy INFs when building class driver list.
  {$EXTERNALSYM DI_FLAGSEX_OLDINF_IN_CLASSLIST}
  DI_FLAGSEX_NO_DRVREG_MODIFY         = $00008000; // Don't run AddReg and DelReg for device's software (driver) key.
  {$EXTERNALSYM DI_FLAGSEX_NO_DRVREG_MODIFY}
  DI_FLAGSEX_IN_SYSTEM_SETUP          = $00010000; // Installation is occurring during initial system setup.
  {$EXTERNALSYM DI_FLAGSEX_IN_SYSTEM_SETUP}
  DI_FLAGSEX_INET_DRIVER              = $00020000; // Driver came from Windows Update
  {$EXTERNALSYM DI_FLAGSEX_INET_DRIVER}
  DI_FLAGSEX_APPENDDRIVERLIST         = $00040000; // Cause SetupDiBuildDriverInfoList to append
  {$EXTERNALSYM DI_FLAGSEX_APPENDDRIVERLIST}       // a new driver list to an existing list.
  DI_FLAGSEX_PREINSTALLBACKUP         = $00080000; // backup all files required by old inf before install
  {$EXTERNALSYM DI_FLAGSEX_PREINSTALLBACKUP}
  DI_FLAGSEX_BACKUPONREPLACE          = $00100000; // backup files required by old inf as they are replaced
  {$EXTERNALSYM DI_FLAGSEX_BACKUPONREPLACE}
  DI_FLAGSEX_DRIVERLIST_FROM_URL      = $00200000; // build driver list from INF(s) retrieved from URL specified
  {$EXTERNALSYM DI_FLAGSEX_DRIVERLIST_FROM_URL}
                                                   // in SP_DEVINSTALL_PARAMS.DriverPath (empty string means
                                                   // Windows Update website)
  DI_FLAGSEX_RESERVED1                = $00400000;
  {$EXTERNALSYM DI_FLAGSEX_RESERVED1}
  DI_FLAGSEX_EXCLUDE_OLD_INET_DRIVERS = $00800000; // Don't include old Internet drivers when building
  {$EXTERNALSYM DI_FLAGSEX_EXCLUDE_OLD_INET_DRIVERS}
                                                   // a driver list.
  DI_FLAGSEX_POWERPAGE_ADDED          = $01000000; // class installer added their own power page
  {$EXTERNALSYM DI_FLAGSEX_POWERPAGE_ADDED}

//
// Class installation parameters header.  This must be the first field of any
// class install parameter structure.  The InstallFunction field must be set to
// the function code corresponding to the structure, and the cbSize field must
// be set to the size of the header structure.  E.g.,
//
// SP_ENABLECLASS_PARAMS EnableClassParams;
//
// EnableClassParams.ClassInstallHeader.cbSize = sizeof(SP_CLASSINSTALL_HEADER);
// EnableClassParams.ClassInstallHeader.InstallFunction = DIF_ENABLECLASS;
//
type
  PSPClassInstallHeader = ^TSPClassInstallHeader;
  _SP_CLASSINSTALL_HEADER = packed record
    cbSize: DWORD;
    InstallFunction: DI_FUNCTION;
  end;
  {$EXTERNALSYM _SP_CLASSINSTALL_HEADER}
  TSPClassInstallHeader = _SP_CLASSINSTALL_HEADER;

//
// Structure corresponding to a DIF_ENABLECLASS install function.
//
  PSPEnableClassParams = ^TSPEnableClassParams;
  _SP_ENABLECLASS_PARAMS = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    ClassGuid: TGUID;
    EnableMessage: DWORD;
  end;
  {$EXTERNALSYM _SP_ENABLECLASS_PARAMS}
  TSPEnableClassParams = _SP_ENABLECLASS_PARAMS;

const
  ENABLECLASS_QUERY   = 0;
  {$EXTERNALSYM ENABLECLASS_QUERY}
  ENABLECLASS_SUCCESS = 1;
  {$EXTERNALSYM ENABLECLASS_SUCCESS}
  ENABLECLASS_FAILURE = 2;
  {$EXTERNALSYM ENABLECLASS_FAILURE}

//
// Structure corresponding to a DIF_MOVEDEVICE install function.
//
type
  PSPMoveDevParams = ^TSPMoveDevParams;
  _SP_MOVEDEV_PARAMS = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    SourceDeviceInfoData: TSPDevInfoData;
  end;
  {$EXTERNALSYM _SP_MOVEDEV_PARAMS}
  TSPMoveDevParams = _SP_MOVEDEV_PARAMS;

//
// Values indicating a change in a device's state
//
const
  DICS_ENABLE     = $00000001;
  {$EXTERNALSYM DICS_ENABLE}
  DICS_DISABLE    = $00000002;
  {$EXTERNALSYM DICS_DISABLE}
  DICS_PROPCHANGE = $00000003;
  {$EXTERNALSYM DICS_PROPCHANGE}
  DICS_START      = $00000004;
  {$EXTERNALSYM DICS_START}
  DICS_STOP       = $00000005;
  {$EXTERNALSYM DICS_STOP}

//
// Values specifying the scope of a device property change
//
  DICS_FLAG_GLOBAL         = $00000001;  // make change in all hardware profiles
  {$EXTERNALSYM DICS_FLAG_GLOBAL}
  DICS_FLAG_CONFIGSPECIFIC = $00000002;  // make change in specified profile only
  {$EXTERNALSYM DICS_FLAG_CONFIGSPECIFIC}
  DICS_FLAG_CONFIGGENERAL  = $00000004;  // 1 or more hardware profile-specific
  {$EXTERNALSYM DICS_FLAG_CONFIGGENERAL} // changes to follow.

//
// Structure corresponding to a DIF_PROPERTYCHANGE install function.
//
type
  PSPPropChangeParams = ^TSPPropChangeParams;
  _SP_PROPCHANGE_PARAMS = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    StateChange: DWORD;
    Scope: DWORD;
    HwProfile: DWORD;
  end;
  {$EXTERNALSYM _SP_PROPCHANGE_PARAMS}
  TSPPropChangeParams = _SP_PROPCHANGE_PARAMS;

//
// Structure corresponding to a DIF_REMOVE install function.
//
  PSPRemoveDeviceParams = ^TSPRemoveDeviceParams;
  _SP_REMOVEDEVICE_PARAMS = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    Scope: DWORD;
    HwProfile: DWORD;
  end;
  {$EXTERNALSYM _SP_REMOVEDEVICE_PARAMS}
  TSPRemoveDeviceParams = _SP_REMOVEDEVICE_PARAMS;

const
  DI_REMOVEDEVICE_GLOBAL         = $00000001;
  {$EXTERNALSYM DI_REMOVEDEVICE_GLOBAL}
  DI_REMOVEDEVICE_CONFIGSPECIFIC = $00000002;
  {$EXTERNALSYM DI_REMOVEDEVICE_CONFIGSPECIFIC}

//
// Structure corresponding to a DIF_UNREMOVE install function.
//
type
  PSPUnremoveDeviceParams = ^TSPUnremoveDeviceParams;
  _SP_UNREMOVEDEVICE_PARAMS = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    Scope: DWORD;
    HwProfile: DWORD;
  end;
  {$EXTERNALSYM _SP_UNREMOVEDEVICE_PARAMS}
  TSPUnremoveDeviceParams = _SP_UNREMOVEDEVICE_PARAMS;

const
  DI_UNREMOVEDEVICE_CONFIGSPECIFIC = $00000002;
  {$EXTERNALSYM DI_UNREMOVEDEVICE_CONFIGSPECIFIC}

//
// Structure corresponding to a DIF_SELECTDEVICE install function.
//
type
  PSPSelectDeviceParamsA = ^TSPSelectDeviceParamsA;
  PSPSelectDeviceParamsW = ^TSPSelectDeviceParamsW;
  PSPSelectDeviceParams = PSPSelectDeviceParamsA;
  _SP_SELECTDEVICE_PARAMS_A = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    Title: array [0..MAX_TITLE_LEN - 1] of AnsiChar;
    Instructions: array [0..MAX_INSTRUCTION_LEN - 1] of AnsiChar;
    ListLabel: array [0..MAX_LABEL_LEN - 1] of AnsiChar;
    SubTitle: array [0..MAX_SUBTITLE_LEN - 1] of AnsiChar;
    Reserved: array [0..1] of Byte; // DWORD size alignment
  end;
  {$EXTERNALSYM _SP_SELECTDEVICE_PARAMS_A}
  _SP_SELECTDEVICE_PARAMS_W = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    Title: array [0..MAX_TITLE_LEN - 1] of WideChar;
    Instructions: array [0..MAX_INSTRUCTION_LEN - 1] of WideChar;
    ListLabel: array [0..MAX_LABEL_LEN - 1] of WideChar;
    SubTitle: array [0..MAX_SUBTITLE_LEN - 1] of WideChar;
    Reserved: array [0..1] of Byte; // DWORD size alignment
  end;
  {$EXTERNALSYM _SP_SELECTDEVICE_PARAMS_W}
  _SP_SELECTDEVICE_PARAMS_ = _SP_SELECTDEVICE_PARAMS_A;
  TSPSelectdeviceParamsA = _SP_SELECTDEVICE_PARAMS_A;
  TSPSelectdeviceParamsW = _SP_SELECTDEVICE_PARAMS_W;
  TSPSelectdeviceParams = TSPSelectdeviceParamsA;

//
// Callback routine for giving progress notification during detection
//
  PDetectProgressNotify = function (ProgressNotifyParam: Pointer; DetectComplete: DWORD): BOOL; stdcall;

// where:
//     ProgressNotifyParam - value supplied by caller requesting detection.
//     DetectComplete - Percent completion, to be incremented by class
//                      installer, as it steps thru its detection.
//
// Return Value - If TRUE, then detection is cancelled.  Allows caller
//                requesting detection to stop detection asap.
//

//
// Structure corresponding to a DIF_DETECT install function.
//
  PSPDetectDeviceParams = ^TSPDetectDeviceParams;
  _SP_DETECTDEVICE_PARAMS = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    DetectProgressNotify: PDetectProgressNotify;
    ProgressNotifyParam: Pointer;
  end;
  {$EXTERNALSYM _SP_DETECTDEVICE_PARAMS}
  TSPDetectDeviceParams = _SP_DETECTDEVICE_PARAMS;

//
// 'Add New Device' installation wizard structure (backward-compatibility
// only--respond to DIF_NEWDEVICEWIZARD_* requests instead).
//
// Structure corresponding to a DIF_INSTALLWIZARD install function.
// (NOTE: This structure is also applicable for DIF_DESTROYWIZARDDATA,
// but DIF_INSTALLWIZARD is the associated function code in the class
// installation parameter structure in both cases.)
//
// Define maximum number of dynamic wizard pages that can be added to
// hardware install wizard.
//
const
  MAX_INSTALLWIZARD_DYNAPAGES = 20;
  {$EXTERNALSYM MAX_INSTALLWIZARD_DYNAPAGES}

type
  PSPInstallWizardData = ^TSPInstallWizardData;
  _SP_INSTALLWIZARD_DATA = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    Flags: DWORD;
    DynamicPages: array [0..MAX_INSTALLWIZARD_DYNAPAGES - 1] of HPROPSHEETPAGE;
    NumDynamicPages: DWORD;
    DynamicPageFlags: DWORD;
    PrivateFlags: DWORD;
    PrivateData: LPARAM;
    hwndWizardDlg: HWND;
  end;
  {$EXTERNALSYM _SP_INSTALLWIZARD_DATA}
  TSPInstallWizardData = _SP_INSTALLWIZARD_DATA;

//
// SP_INSTALLWIZARD_DATA.Flags values
//
const
  NDW_INSTALLFLAG_DIDFACTDEFS        = $00000001;
  {$EXTERNALSYM NDW_INSTALLFLAG_DIDFACTDEFS}
  NDW_INSTALLFLAG_HARDWAREALLREADYIN = $00000002;
  {$EXTERNALSYM NDW_INSTALLFLAG_HARDWAREALLREADYIN}
  NDW_INSTALLFLAG_NEEDRESTART        = DI_NEEDRESTART;
  {$EXTERNALSYM NDW_INSTALLFLAG_NEEDRESTART}
  NDW_INSTALLFLAG_NEEDREBOOT         = DI_NEEDREBOOT;
  {$EXTERNALSYM NDW_INSTALLFLAG_NEEDREBOOT}
  NDW_INSTALLFLAG_NEEDSHUTDOWN       = $00000200;
  {$EXTERNALSYM NDW_INSTALLFLAG_NEEDSHUTDOWN}
  NDW_INSTALLFLAG_EXPRESSINTRO       = $00000400;
  {$EXTERNALSYM NDW_INSTALLFLAG_EXPRESSINTRO}
  NDW_INSTALLFLAG_SKIPISDEVINSTALLED = $00000800;
  {$EXTERNALSYM NDW_INSTALLFLAG_SKIPISDEVINSTALLED}
  NDW_INSTALLFLAG_NODETECTEDDEVS     = $00001000;
  {$EXTERNALSYM NDW_INSTALLFLAG_NODETECTEDDEVS}
  NDW_INSTALLFLAG_INSTALLSPECIFIC    = $00002000;
  {$EXTERNALSYM NDW_INSTALLFLAG_INSTALLSPECIFIC}
  NDW_INSTALLFLAG_SKIPCLASSLIST      = $00004000;
  {$EXTERNALSYM NDW_INSTALLFLAG_SKIPCLASSLIST}
  NDW_INSTALLFLAG_CI_PICKED_OEM      = $00008000;
  {$EXTERNALSYM NDW_INSTALLFLAG_CI_PICKED_OEM}
  NDW_INSTALLFLAG_PCMCIAMODE         = $00010000;
  {$EXTERNALSYM NDW_INSTALLFLAG_PCMCIAMODE}
  NDW_INSTALLFLAG_PCMCIADEVICE       = $00020000;
  {$EXTERNALSYM NDW_INSTALLFLAG_PCMCIADEVICE}
  NDW_INSTALLFLAG_USERCANCEL         = $00040000;
  {$EXTERNALSYM NDW_INSTALLFLAG_USERCANCEL}
  NDW_INSTALLFLAG_KNOWNCLASS         = $00080000;
  {$EXTERNALSYM NDW_INSTALLFLAG_KNOWNCLASS}

//
// SP_INSTALLWIZARD_DATA.DynamicPageFlags values
//
// This flag is set if a Class installer has added pages to the install wizard.
//
  DYNAWIZ_FLAG_PAGESADDED = $00000001;
  {$EXTERNALSYM DYNAWIZ_FLAG_PAGESADDED}

//
// Set this flag if you jump to the analyze page, and want it to
// handle conflicts for you.  NOTE.  You will not get control back
// in the event of a conflict if you set this flag.
//
  DYNAWIZ_FLAG_ANALYZE_HANDLECONFLICT = $00000008;
  {$EXTERNALSYM DYNAWIZ_FLAG_ANALYZE_HANDLECONFLICT}

//
// The following flags are not used by the Windows NT hardware wizard.
//
  DYNAWIZ_FLAG_INSTALLDET_NEXT = $00000002;
  {$EXTERNALSYM DYNAWIZ_FLAG_INSTALLDET_NEXT}
  DYNAWIZ_FLAG_INSTALLDET_PREV = $00000004;
  {$EXTERNALSYM DYNAWIZ_FLAG_INSTALLDET_PREV}

//
// Reserve a range of wizard page resource IDs for internal use.  Some of
// these IDs are for use by class installers that respond to the obsolete
// DIF_INSTALLWIZARD/DIF_DESTROYWIZARDDATA messages.  These IDs are listed
// below.
//
  MIN_IDD_DYNAWIZ_RESOURCE_ID = 10000;
  {$EXTERNALSYM MIN_IDD_DYNAWIZ_RESOURCE_ID}
  MAX_IDD_DYNAWIZ_RESOURCE_ID = 11000;
  {$EXTERNALSYM MAX_IDD_DYNAWIZ_RESOURCE_ID}

//
// Define wizard page resource IDs to be used when adding custom pages to the
// hardware install wizard via DIF_INSTALLWIZARD.  Pages marked with
// (CLASS INSTALLER PROVIDED) _must_ be supplied by the class installer if it
// responds to the DIF_INSTALLWIZARD request.
//

//
// Resource ID for the first page that the install wizard will go to after
// adding the class installer pages.  (CLASS INSTALLER PROVIDED)
//
  IDD_DYNAWIZ_FIRSTPAGE = 10000;
  {$EXTERNALSYM IDD_DYNAWIZ_FIRSTPAGE}

//
// Resource ID for the page that the Select Device page will go back to.
// (CLASS INSTALLER PROVIDED)
//
  IDD_DYNAWIZ_SELECT_PREVPAGE = 10001;
  {$EXTERNALSYM IDD_DYNAWIZ_SELECT_PREVPAGE}

//
// Resource ID for the page that the Select Device page will go forward to.
// (CLASS INSTALLER PROVIDED)
//
  IDD_DYNAWIZ_SELECT_NEXTPAGE = 10002;
  {$EXTERNALSYM IDD_DYNAWIZ_SELECT_NEXTPAGE}

//
// Resource ID for the page that the Analyze dialog should go back to
// This will only be used in the event that there is a problem, and the user
// selects Back from the analyze proc. (CLASS INSTALLER PROVIDED)
//
  IDD_DYNAWIZ_ANALYZE_PREVPAGE = 10003;
  {$EXTERNALSYM IDD_DYNAWIZ_ANALYZE_PREVPAGE}

//
// Resource ID for the page that the Analyze dialog should go to if it
// continues from the analyze proc. (CLASS INSTALLER PROVIDED)
//
  IDD_DYNAWIZ_ANALYZE_NEXTPAGE = 10004;
  {$EXTERNALSYM IDD_DYNAWIZ_ANALYZE_NEXTPAGE}

//
// Resource ID of the hardware install wizard's select device page.
// This ID can be used to go directly to the hardware install wizard's select
// device page.  (This is the resource ID of the Select Device wizard page
// retrieved via SetupDiGetWizardPage when SPWPT_SELECTDEVICE is the requested
// PageType.)
//
  IDD_DYNAWIZ_SELECTDEV_PAGE = 10009;
  {$EXTERNALSYM IDD_DYNAWIZ_SELECTDEV_PAGE}

//
// Resource ID of the hardware install wizard's device analysis page.
// This ID can be use to go directly to the hardware install wizard's analysis
// page.
//
  IDD_DYNAWIZ_ANALYZEDEV_PAGE = 10010;
  {$EXTERNALSYM IDD_DYNAWIZ_ANALYZEDEV_PAGE}

//
// Resource ID of the hardware install wizard's install detected devices page.
// This ID can be use to go directly to the hardware install wizard's install
// detected devices page.
//
  IDD_DYNAWIZ_INSTALLDETECTEDDEVS_PAGE = 10011;
  {$EXTERNALSYM IDD_DYNAWIZ_INSTALLDETECTEDDEVS_PAGE}

//
// Resource ID of the hardware install wizard's select class page.
// This ID can be use to go directly to the hardware install wizard's select
// class page.
//
  IDD_DYNAWIZ_SELECTCLASS_PAGE = 10012;
  {$EXTERNALSYM IDD_DYNAWIZ_SELECTCLASS_PAGE}

//
// The following class installer-provided wizard page resource IDs are not used
// by the Windows NT hardware wizard.
//
  IDD_DYNAWIZ_INSTALLDETECTED_PREVPAGE = 10006;
  {$EXTERNALSYM IDD_DYNAWIZ_INSTALLDETECTED_PREVPAGE}
  IDD_DYNAWIZ_INSTALLDETECTED_NEXTPAGE = 10007;
  {$EXTERNALSYM IDD_DYNAWIZ_INSTALLDETECTED_NEXTPAGE}
  IDD_DYNAWIZ_INSTALLDETECTED_NODEVS   = 10008;
  {$EXTERNALSYM IDD_DYNAWIZ_INSTALLDETECTED_NODEVS}

//
// Structure corresponding to the following DIF_NEWDEVICEWIZARD_* install
// functions:
//
//     DIF_NEWDEVICEWIZARD_PRESELECT
//     DIF_NEWDEVICEWIZARD_SELECT
//     DIF_NEWDEVICEWIZARD_PREANALYZE
//     DIF_NEWDEVICEWIZARD_POSTANALYZE
//     DIF_NEWDEVICEWIZARD_FINISHINSTALL
//
type
  PSPNewDeviceWizardData = ^TSPNewDeviceWizardData;
  _SP_NEWDEVICEWIZARD_DATA = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    Flags: DWORD; // presently unused--must be zero.
    DynamicPages: array [0..MAX_INSTALLWIZARD_DYNAPAGES - 1] of HPROPSHEETPAGE;
    NumDynamicPages: DWORD;
    hwndWizardDlg: HWND;
  end;
  {$EXTERNALSYM _SP_NEWDEVICEWIZARD_DATA}
  TSPNewDeviceWizardData = _SP_NEWDEVICEWIZARD_DATA;

//
// Structure corresponding to the DIF_TROUBLESHOOTER install function
//
  PSPTroubleShooterParamsA = ^TSPTroubleShooterParamsA;
  PSPTroubleShooterParamsW = ^TSPTroubleShooterParamsW;
  PSPTroubleShooterParams = PSPTroubleShooterParamsA;
  _SP_TROUBLESHOOTER_PARAMS_A = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    ChmFile: array [0..MAX_PATH - 1] of AnsiChar;
    HtmlTroubleShooter: array [0..MAX_PATH - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _SP_TROUBLESHOOTER_PARAMS_A}
  _SP_TROUBLESHOOTER_PARAMS_W = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    ChmFile: array [0..MAX_PATH - 1] of WideChar;
    HtmlTroubleShooter: array [0..MAX_PATH - 1] of WideChar;
  end;
  {$EXTERNALSYM _SP_TROUBLESHOOTER_PARAMS_W}
  _SP_TROUBLESHOOTER_PARAMS_ = _SP_TROUBLESHOOTER_PARAMS_A;
  TSPTroubleShooterParamsA = _SP_TROUBLESHOOTER_PARAMS_A;
  TSPTroubleShooterParamsW = _SP_TROUBLESHOOTER_PARAMS_W;
  TSPTroubleShooterParams = TSPTroubleShooterParamsA;

//
// Structure corresponding to the DIF_POWERMESSAGEWAKE install function
//
  PSPPowerMessageWakeParamsA = ^TSPPowerMessageWakeParamsA;
  PSPPowerMessageWakeParamsW = ^TSPPowerMessageWakeParamsW;
  PSPPowerMessageWakeParams = PSPPowerMessageWakeParamsA;
  _SP_POWERMESSAGEWAKE_PARAMS_A = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    PowerMessageWake: array [0..(LINE_LEN * 2) - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _SP_POWERMESSAGEWAKE_PARAMS_A}
  _SP_POWERMESSAGEWAKE_PARAMS_W = packed record
    ClassInstallHeader: TSPClassInstallHeader;
    PowerMessageWake: array [0..(LINE_LEN * 2) - 1] of WideChar;
  end;
  {$EXTERNALSYM _SP_POWERMESSAGEWAKE_PARAMS_W}
  _SP_POWERMESSAGEWAKE_PARAMS_ = _SP_POWERMESSAGEWAKE_PARAMS_A;
  TSPPowerMessageWakeParamsA = _SP_POWERMESSAGEWAKE_PARAMS_A;
  TSPPowerMessageWakeParamsW = _SP_POWERMESSAGEWAKE_PARAMS_W;
  TSPPowerMessageWakeParams = TSPPowerMessageWakeParamsA;

//
// Driver information structure (member of a driver info list that may be associated
// with a particular device instance, or (globally) with a device information set)
//
  PSPDrvInfoDataV2A = ^TSPDrvInfoDataV2A;
  PSPDrvInfoDataV2W = ^TSPDrvInfoDataV2W;
  PSPDrvInfoDataV2 = PSPDrvInfoDataV2A;
  _SP_DRVINFO_DATA_V2_A = packed record
    cbSize: DWORD;
    DriverType: DWORD;
    Reserved: ULONG_PTR;
    Description: array [0..LINE_LEN - 1] of AnsiChar;
    MfgName: array [0..LINE_LEN - 1] of AnsiChar;
    ProviderName: array [0..LINE_LEN - 1] of AnsiChar;
    DriverDate: TFileTime;
    DriverVersion: Int64;
  end;
  {$EXTERNALSYM _SP_DRVINFO_DATA_V2_A}
  _SP_DRVINFO_DATA_V2_W = packed record
    cbSize: DWORD;
    DriverType: DWORD;
    Reserved: ULONG_PTR;
    Description: array [0..LINE_LEN - 1] of WideChar;
    MfgName: array [0..LINE_LEN - 1] of WideChar;
    ProviderName: array [0..LINE_LEN - 1] of WideChar;
    DriverDate: TFileTime;
    DriverVersion: Int64;
  end;
  {$EXTERNALSYM _SP_DRVINFO_DATA_V2_W}
  _SP_DRVINFO_DATA_V2_ = _SP_DRVINFO_DATA_V2_A;
  TSPDrvInfoDataV2A = _SP_DRVINFO_DATA_V2_A;
  TSPDrvInfoDataV2W = _SP_DRVINFO_DATA_V2_W;
  TSPDrvInfoDataV2 = TSPDrvInfoDataV2A;

//
// Version 1 of the SP_DRVINFO_DATA structures, used only for compatibility
// with Windows NT 4.0/Windows 95/98 SETUPAPI.DLL
//
  PSPDrvInfoDataV1A = ^TSPDrvInfoDataV1A;
  PSPDrvInfoDataV1W = ^TSPDrvInfoDataV1W;
  PSPDrvInfoDataV1 = PSPDrvInfoDataV1A;
  _SP_DRVINFO_DATA_V1_A = packed record
    cbSize: DWORD;
    DriverType: DWORD;
    Reserved: ULONG_PTR;
    Description: array [0..LINE_LEN - 1] of AnsiChar;
    MfgName: array [0..LINE_LEN - 1] of AnsiChar;
    ProviderName: array [0..LINE_LEN - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _SP_DRVINFO_DATA_V1_A}
  _SP_DRVINFO_DATA_V1_W = packed record
    cbSize: DWORD;
    DriverType: DWORD;
    Reserved: ULONG_PTR;
    Description: array [0..LINE_LEN - 1] of WideChar;
    MfgName: array [0..LINE_LEN - 1] of WideChar;
    ProviderName: array [0..LINE_LEN - 1] of WideChar;
  end;
  {$EXTERNALSYM _SP_DRVINFO_DATA_V1_W}
  _SP_DRVINFO_DATA_V1_ = _SP_DRVINFO_DATA_V1_A;
  TSPDrvInfoDataV1A = _SP_DRVINFO_DATA_V1_A;
  TSPDrvInfoDataV1W = _SP_DRVINFO_DATA_V1_W;
  TSPDrvInfoDataV1 = TSPDrvInfoDataV1A;

{$IFDEF USE_SP_DRVINFO_DATA_V1}
  TSPDrvInfoDataA = TSPDrvInfoDataV1A;
  TSPDrvInfoDataW = TSPDrvInfoDataV1W;
  TSPDrvInfoData = TSPDrvInfoDataA;
  PSPDrvInfoDataA = PSPDrvInfoDataV1A;
  PSPDrvInfoDataW = PSPDrvInfoDataV1W;
  PSPDrvInfoData = PSPDrvInfoDataA;
{$ELSE}
  TSPDrvInfoDataA = TSPDrvInfoDataV2A;
  TSPDrvInfoDataW = TSPDrvInfoDataV2W;
  TSPDrvInfoData = TSPDrvInfoDataA;
  PSPDrvInfoDataA = PSPDrvInfoDataV2A;
  PSPDrvInfoDataW = PSPDrvInfoDataV2W;
  PSPDrvInfoData = PSPDrvInfoDataA;
{$ENDIF}

//
// Driver information details structure (provides detailed information about a
// particular driver information structure)
//
  PSPDrvInfoDetailDataA = ^TSPDrvInfoDetailDataA;
  PSPDrvInfoDetailDataW = ^TSPDrvInfoDetailDataW;
  PSPDrvInfoDetailData = PSPDrvInfoDetailDataA;
  _SP_DRVINFO_DETAIL_DATA_A = packed record
    cbSize: DWORD;
    InfDate: TFileTime;
    CompatIDsOffset: DWORD;
    CompatIDsLength: DWORD;
    Reserved: ULONG_PTR;
    SectionName: array [0..LINE_LEN - 1] of AnsiChar;
    InfFileName: array [0..MAX_PATH - 1] of AnsiChar;
    DrvDescription: array [0..LINE_LEN - 1] of AnsiChar;
    HardwareID: array [0..ANYSIZE_ARRAY - 1] of AnsiChar;
  end;
  {$EXTERNALSYM _SP_DRVINFO_DETAIL_DATA_A}
  _SP_DRVINFO_DETAIL_DATA_W = packed record
    cbSize: DWORD;
    InfDate: TFileTime;
    CompatIDsOffset: DWORD;
    CompatIDsLength: DWORD;
    Reserved: ULONG_PTR;
    SectionName: array [0..LINE_LEN - 1] of WideChar;
    InfFileName: array [0..MAX_PATH - 1] of WideChar;
    DrvDescription: array [0..LINE_LEN - 1] of WideChar;
    HardwareID: array [0..ANYSIZE_ARRAY - 1] of WideChar;
  end;
  {$EXTERNALSYM _SP_DRVINFO_DETAIL_DATA_W}
  _SP_DRVINFO_DETAIL_DATA_ = _SP_DRVINFO_DETAIL_DATA_A;
  TSPDrvInfoDetailDataA = _SP_DRVINFO_DETAIL_DATA_A;
  TSPDrvInfoDetailDataW = _SP_DRVINFO_DETAIL_DATA_W;
  TSPDrvInfoDetailData = TSPDrvInfoDetailDataA;

//
// Driver installation parameters (associated with a particular driver
// information element)
//
  PSPDrvInstallParams = ^TSPDrvInstallParams;
  _SP_DRVINSTALL_PARAMS = packed record
    cbSize: DWORD;
    Rank: DWORD;
    Flags: DWORD;
    PrivateData: DWORD_PTR;
    Reserved: DWORD;
  end;
  {$EXTERNALSYM _SP_DRVINSTALL_PARAMS}
  TSPDrvInstallParams = _SP_DRVINSTALL_PARAMS;

//
// SP_DRVINSTALL_PARAMS.Flags values
//
const
  DNF_DUPDESC           = $00000001; // Multiple providers have same desc
  {$EXTERNALSYM DNF_DUPDESC}
  DNF_OLDDRIVER         = $00000002; // Driver node specifies old/current driver
  {$EXTERNALSYM DNF_OLDDRIVER}
  DNF_EXCLUDEFROMLIST   = $00000004; // If set, this driver node will not be
  {$EXTERNALSYM DNF_EXCLUDEFROMLIST} // displayed in any driver select dialogs.
  DNF_NODRIVER          = $00000008; // if we want to install no driver
  {$EXTERNALSYM DNF_NODRIVER}        // (e.g no mouse drv)
  DNF_LEGACYINF         = $00000010; // this driver node comes from an old-style INF
  {$EXTERNALSYM DNF_LEGACYINF}
  DNF_CLASS_DRIVER      = $00000020; // Driver node represents a class driver
  {$EXTERNALSYM DNF_CLASS_DRIVER}
  DNF_COMPATIBLE_DRIVER = $00000040; // Driver node represents a compatible driver
  {$EXTERNALSYM DNF_COMPATIBLE_DRIVER}
  DNF_INET_DRIVER       = $00000080; // Driver comes from an internet source
  {$EXTERNALSYM DNF_INET_DRIVER}
  DNF_UNUSED1           = $00000100;
  {$EXTERNALSYM DNF_UNUSED1}
  DNF_INDEXED_DRIVER    = $00000200; // Driver is contained in the Windows Driver Index
  {$EXTERNALSYM DNF_INDEXED_DRIVER}
  DNF_OLD_INET_DRIVER   = $00000400; // Driver came from the Internet, but we don't currently
  {$EXTERNALSYM DNF_OLD_INET_DRIVER} // have access to it's source files.  Never attempt to
                                     // install a driver with this flag!
  DNF_BAD_DRIVER        = $00000800; // Driver node should not be used at all
  {$EXTERNALSYM DNF_BAD_DRIVER}
  DNF_DUPPROVIDER       = $00001000; // Multiple drivers have the same provider and desc
  {$EXTERNALSYM DNF_DUPPROVIDER}

//
//Rank values (the lower the Rank number, the better the Rank)
//
  DRIVER_HARDWAREID_RANK = $00000FFF;   // Any rank less than or equal to
  {$EXTERNALSYM DRIVER_HARDWAREID_RANK} // this value is a HardwareID match

//
// Setup callback routine for comparing detection signatures
//
type
  TSPDetsigCmpProc = function (DeviceInfoSet: HDEVINFO; NewDeviceData,
    ExistingDeviceData: PSPDevInfoData; CompareContext: Pointer): DWORD; stdcall;

//
// Define context structure handed to co-installers
//
  PCoInstallerContextData = ^TCoInstallerContextData;
  _COINSTALLER_CONTEXT_DATA = packed record
    PostProcessing: BOOL;
    InstallResult: DWORD;
    PrivateData: Pointer;
  end;
  {$EXTERNALSYM _COINSTALLER_CONTEXT_DATA}
  TCoInstallerContextData = _COINSTALLER_CONTEXT_DATA;

//
// Structure containing class image list information.
//
  PSPClassImageListData = ^TSPClassImageListData;
  _SP_CLASSIMAGELIST_DATA = packed record
    cbSize: DWORD;
    ImageList: HIMAGELIST;
    Reserved: ULONG_PTR;
  end;
  {$EXTERNALSYM _SP_CLASSIMAGELIST_DATA}
  TSPClassImageListData = _SP_CLASSIMAGELIST_DATA;

//
// Structure to be passed as first parameter (LPVOID lpv) to ExtensionPropSheetPageProc
// entry point in setupapi.dll or to "EnumPropPages32" or "BasicProperties32" entry
// points provided by class/device property page providers.  Used to retrieve a handle
// (or, potentially, multiple handles) to property pages for a specified property page type.
//
  PSPPropSheetPageRequest = ^TSPPropSheetPageRequest;
  _SP_PROPSHEETPAGE_REQUEST = packed record
    cbSize: DWORD;
    PageRequested: DWORD;
    DeviceInfoSet: HDEVINFO;
    DeviceInfoData: PSPDevInfoData;
  end;
  {$EXTERNALSYM _SP_PROPSHEETPAGE_REQUEST}
  TSPPropSheetPageRequest = _SP_PROPSHEETPAGE_REQUEST;

//
// Property sheet codes used in SP_PROPSHEETPAGE_REQUEST.PageRequested
//
const
  SPPSR_SELECT_DEVICE_RESOURCES      = 1; // supplied by setupapi.dll
  {$EXTERNALSYM SPPSR_SELECT_DEVICE_RESOURCES}
  SPPSR_ENUM_BASIC_DEVICE_PROPERTIES = 2; // supplied by device's BasicProperties32 provider
  {$EXTERNALSYM SPPSR_ENUM_BASIC_DEVICE_PROPERTIES}
  SPPSR_ENUM_ADV_DEVICE_PROPERTIES   = 3; // supplied by class and/or device's EnumPropPages32 provider
  {$EXTERNALSYM SPPSR_ENUM_ADV_DEVICE_PROPERTIES}

//
// Structure used with SetupGetBackupQueue
//
type
  PSPBackupQueueParamsA = ^TSPBackupQueueParamsA;
  PSPBackupQueueParamsW = ^TSPBackupQueueParamsW;
  PSPBackupQueueParams = PSPBackupQueueParamsA;
  _SP_BACKUP_QUEUE_PARAMS_A = packed record
    cbSize: DWORD;
    FullInfPath: array [0..MAX_PATH - 1] of AnsiChar; // buffer to hold ANSI pathname of INF file
    FilenameOffset: Integer; // offset in CHAR's of filename part (after '\')
  end;
  {$EXTERNALSYM _SP_BACKUP_QUEUE_PARAMS_A}
  _SP_BACKUP_QUEUE_PARAMS_W = packed record
    cbSize: DWORD;
    FullInfPath: array [0..MAX_PATH - 1] of WideChar; // buffer to hold ANSI pathname of INF file
    FilenameOffset: Integer; // offset in CHAR's of filename part (after '\')
  end;
  {$EXTERNALSYM _SP_BACKUP_QUEUE_PARAMS_W}
  _SP_BACKUP_QUEUE_PARAMS_ = _SP_BACKUP_QUEUE_PARAMS_A;
  TSPBackupQueueParamsA = _SP_BACKUP_QUEUE_PARAMS_A;
  TSPBackupQueueParamsW = _SP_BACKUP_QUEUE_PARAMS_W;
  TSPBackupQueueParams = TSPBackupQueueParamsA;

//
// Setupapi-specific error codes
//
// Inf parse outcomes
//
const
  APPLICATION_ERROR_MASK = DWORD($20000000); // from WINNT.h
  {$EXTERNALSYM APPLICATION_ERROR_MASK}
  ERROR_SEVERITY_ERROR   = DWORD($C0000000); // from WINNT.h
  {$EXTERNALSYM ERROR_SEVERITY_ERROR}

  ERROR_EXPECTED_SECTION_NAME       = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or 0);
  {$EXTERNALSYM ERROR_EXPECTED_SECTION_NAME}
  ERROR_BAD_SECTION_NAME_LINE       = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or 1);
  {$EXTERNALSYM ERROR_BAD_SECTION_NAME_LINE}
  ERROR_SECTION_NAME_TOO_LONG       = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or 2);
  {$EXTERNALSYM ERROR_SECTION_NAME_TOO_LONG}
  ERROR_GENERAL_SYNTAX              = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or 3);
  {$EXTERNALSYM ERROR_GENERAL_SYNTAX}

//
// Inf runtime errors
//
  ERROR_WRONG_INF_STYLE             = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $100);
  {$EXTERNALSYM ERROR_WRONG_INF_STYLE}
  ERROR_SECTION_NOT_FOUND           = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $101);
  {$EXTERNALSYM ERROR_SECTION_NOT_FOUND}
  ERROR_LINE_NOT_FOUND              = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $102);
  {$EXTERNALSYM ERROR_LINE_NOT_FOUND}
  ERROR_NO_BACKUP                   = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $103);
  {$EXTERNALSYM ERROR_NO_BACKUP}

//
// Device Installer/other errors
//
  ERROR_NO_ASSOCIATED_CLASS         = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $200);
  {$EXTERNALSYM ERROR_NO_ASSOCIATED_CLASS}
  ERROR_CLASS_MISMATCH              = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $201);
  {$EXTERNALSYM ERROR_CLASS_MISMATCH}
  ERROR_DUPLICATE_FOUND             = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $202);
  {$EXTERNALSYM ERROR_DUPLICATE_FOUND}
  ERROR_NO_DRIVER_SELECTED          = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $203);
  {$EXTERNALSYM ERROR_NO_DRIVER_SELECTED}
  ERROR_KEY_DOES_NOT_EXIST          = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $204);
  {$EXTERNALSYM ERROR_KEY_DOES_NOT_EXIST}
  ERROR_INVALID_DEVINST_NAME        = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $205);
  {$EXTERNALSYM ERROR_INVALID_DEVINST_NAME}
  ERROR_INVALID_CLASS               = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $206);
  {$EXTERNALSYM ERROR_INVALID_CLASS}
  ERROR_DEVINST_ALREADY_EXISTS      = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $207);
  {$EXTERNALSYM ERROR_DEVINST_ALREADY_EXISTS}
  ERROR_DEVINFO_NOT_REGISTERED      = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $208);
  {$EXTERNALSYM ERROR_DEVINFO_NOT_REGISTERED}
  ERROR_INVALID_REG_PROPERTY        = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $209);
  {$EXTERNALSYM ERROR_INVALID_REG_PROPERTY}
  ERROR_NO_INF                      = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $20A);
  {$EXTERNALSYM ERROR_NO_INF}
  ERROR_NO_SUCH_DEVINST             = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $20B);
  {$EXTERNALSYM ERROR_NO_SUCH_DEVINST}
  ERROR_CANT_LOAD_CLASS_ICON        = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $20C);
  {$EXTERNALSYM ERROR_CANT_LOAD_CLASS_ICON}
  ERROR_INVALID_CLASS_INSTALLER     = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $20D);
  {$EXTERNALSYM ERROR_INVALID_CLASS_INSTALLER}
  ERROR_DI_DO_DEFAULT               = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $20E);
  {$EXTERNALSYM ERROR_DI_DO_DEFAULT}
  ERROR_DI_NOFILECOPY               = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $20F);
  {$EXTERNALSYM ERROR_DI_NOFILECOPY}
  ERROR_INVALID_HWPROFILE           = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $210);
  {$EXTERNALSYM ERROR_INVALID_HWPROFILE}
  ERROR_NO_DEVICE_SELECTED          = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $211);
  {$EXTERNALSYM ERROR_NO_DEVICE_SELECTED}
  ERROR_DEVINFO_LIST_LOCKED         = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $212);
  {$EXTERNALSYM ERROR_DEVINFO_LIST_LOCKED}
  ERROR_DEVINFO_DATA_LOCKED         = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $213);
  {$EXTERNALSYM ERROR_DEVINFO_DATA_LOCKED}
  ERROR_DI_BAD_PATH                 = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $214);
  {$EXTERNALSYM ERROR_DI_BAD_PATH}
  ERROR_NO_CLASSINSTALL_PARAMS      = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $215);
  {$EXTERNALSYM ERROR_NO_CLASSINSTALL_PARAMS}
  ERROR_FILEQUEUE_LOCKED            = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $216);
  {$EXTERNALSYM ERROR_FILEQUEUE_LOCKED}
  ERROR_BAD_SERVICE_INSTALLSECT     = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $217);
  {$EXTERNALSYM ERROR_BAD_SERVICE_INSTALLSECT}
  ERROR_NO_CLASS_DRIVER_LIST        = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $218);
  {$EXTERNALSYM ERROR_NO_CLASS_DRIVER_LIST}
  ERROR_NO_ASSOCIATED_SERVICE       = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $219);
  {$EXTERNALSYM ERROR_NO_ASSOCIATED_SERVICE}
  ERROR_NO_DEFAULT_DEVICE_INTERFACE = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $21A);
  {$EXTERNALSYM ERROR_NO_DEFAULT_DEVICE_INTERFACE}
  ERROR_DEVICE_INTERFACE_ACTIVE     = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $21B);
  {$EXTERNALSYM ERROR_DEVICE_INTERFACE_ACTIVE}
  ERROR_DEVICE_INTERFACE_REMOVED    = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $21C);
  {$EXTERNALSYM ERROR_DEVICE_INTERFACE_REMOVED}
  ERROR_BAD_INTERFACE_INSTALLSECT   = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $21D);
  {$EXTERNALSYM ERROR_BAD_INTERFACE_INSTALLSECT}
  ERROR_NO_SUCH_INTERFACE_CLASS     = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $21E);
  {$EXTERNALSYM ERROR_NO_SUCH_INTERFACE_CLASS}
  ERROR_INVALID_REFERENCE_STRING    = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $21F);
  {$EXTERNALSYM ERROR_INVALID_REFERENCE_STRING}
  ERROR_INVALID_MACHINENAME         = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $220);
  {$EXTERNALSYM ERROR_INVALID_MACHINENAME}
  ERROR_REMOTE_COMM_FAILURE         = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $221);
  {$EXTERNALSYM ERROR_REMOTE_COMM_FAILURE}
  ERROR_MACHINE_UNAVAILABLE         = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $222);
  {$EXTERNALSYM ERROR_MACHINE_UNAVAILABLE}
  ERROR_NO_CONFIGMGR_SERVICES       = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $223);
  {$EXTERNALSYM ERROR_NO_CONFIGMGR_SERVICES}
  ERROR_INVALID_PROPPAGE_PROVIDER   = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $224);
  {$EXTERNALSYM ERROR_INVALID_PROPPAGE_PROVIDER}
  ERROR_NO_SUCH_DEVICE_INTERFACE    = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $225);
  {$EXTERNALSYM ERROR_NO_SUCH_DEVICE_INTERFACE}
  ERROR_DI_POSTPROCESSING_REQUIRED  = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $226);
  {$EXTERNALSYM ERROR_DI_POSTPROCESSING_REQUIRED}
  ERROR_INVALID_COINSTALLER         = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $227);
  {$EXTERNALSYM ERROR_INVALID_COINSTALLER}
  ERROR_NO_COMPAT_DRIVERS           = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $228);
  {$EXTERNALSYM ERROR_NO_COMPAT_DRIVERS}
  ERROR_NO_DEVICE_ICON              = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $229);
  {$EXTERNALSYM ERROR_NO_DEVICE_ICON}
  ERROR_INVALID_INF_LOGCONFIG       = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $22A);
  {$EXTERNALSYM ERROR_INVALID_INF_LOGCONFIG}
  ERROR_DI_DONT_INSTALL             = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $22B);
  {$EXTERNALSYM ERROR_DI_DONT_INSTALL}
  ERROR_INVALID_FILTER_DRIVER       = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $22C);
  {$EXTERNALSYM ERROR_INVALID_FILTER_DRIVER}
  ERROR_NON_WINDOWS_NT_DRIVER       = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $22D);
  {$EXTERNALSYM ERROR_NON_WINDOWS_NT_DRIVER}
  ERROR_NON_WINDOWS_DRIVER          = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $22E);
  {$EXTERNALSYM ERROR_NON_WINDOWS_DRIVER}
  ERROR_NO_CATALOG_FOR_OEM_INF      = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $22F);
  {$EXTERNALSYM ERROR_NO_CATALOG_FOR_OEM_INF}
  ERROR_DEVINSTALL_QUEUE_NONNATIVE  = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $230);
  {$EXTERNALSYM ERROR_DEVINSTALL_QUEUE_NONNATIVE}
  ERROR_NOT_DISABLEABLE             = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $231);
  {$EXTERNALSYM ERROR_NOT_DISABLEABLE}
  ERROR_CANT_REMOVE_DEVINST         = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $232);
  {$EXTERNALSYM ERROR_CANT_REMOVE_DEVINST}

//
// Backward compatibility--do not use.
//
  ERROR_NO_DEFAULT_INTERFACE_DEVICE = ERROR_NO_DEFAULT_DEVICE_INTERFACE;
  {$EXTERNALSYM ERROR_NO_DEFAULT_INTERFACE_DEVICE}
  ERROR_INTERFACE_DEVICE_ACTIVE     = ERROR_DEVICE_INTERFACE_ACTIVE;
  {$EXTERNALSYM ERROR_INTERFACE_DEVICE_ACTIVE}
  ERROR_INTERFACE_DEVICE_REMOVED    = ERROR_DEVICE_INTERFACE_REMOVED;
  {$EXTERNALSYM ERROR_INTERFACE_DEVICE_REMOVED}
  ERROR_NO_SUCH_INTERFACE_DEVICE    = ERROR_NO_SUCH_DEVICE_INTERFACE;
  {$EXTERNALSYM ERROR_NO_SUCH_INTERFACE_DEVICE}

//
// Win9x migration DLL error code
//
  ERROR_NOT_INSTALLED = DWORD(APPLICATION_ERROR_MASK or ERROR_SEVERITY_ERROR or $1000);
  {$EXTERNALSYM ERROR_NOT_INSTALLED}

function CM_Get_Parent(pdnDevInst: PDWORD; dnDevInst: DWORD; ulFlags: ULONG): DWORD; stdcall;
{$EXTERNALSYM CM_Get_Parent}
function CM_Get_Child(pdnDevInst: PDWORD; dnDevInst: DWORD; ulFlags: ULONG): DWORD; stdcall;
{$EXTERNALSYM CM_Get_Child}
function CM_Get_Device_IDA(dnDevInst: DWORD; Buffer: PCHAR; BufferLen: ULONG; ulFlags: ULONG): DWORD; stdcall;
{$EXTERNALSYM CM_Get_Device_IDA}
function CM_Get_Device_IDW(dnDevInst: DWORD; Buffer: PCHAR; BufferLen: ULONG; ulFlags: ULONG): DWORD; stdcall;
{$EXTERNALSYM CM_Get_Device_IDW}
function CM_Get_Device_ID_Size(pulLen: PULONG; dnDevInst: DWORD; ulFlags: ULONG): DWORD; stdcall;
{$EXTERNALSYM CM_Get_Device_ID_Size}
function SetupGetInfInformationA(InfSpec: Pointer; SearchControl: DWORD;
  ReturnBuffer: PSPInfInformation; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetInfInformationA}
function SetupGetInfInformationW(InfSpec: Pointer; SearchControl: DWORD;
  ReturnBuffer: PSPInfInformation; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetInfInformationW}
function SetupGetInfInformation(InfSpec: Pointer; SearchControl: DWORD;
  ReturnBuffer: PSPInfInformation; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetInfInformation}

//
// SearchControl flags for SetupGetInfInformation
//
const
  INFINFO_INF_SPEC_IS_HINF       = 1;
  {$EXTERNALSYM INFINFO_INF_SPEC_IS_HINF}
  INFINFO_INF_NAME_IS_ABSOLUTE   = 2;
  {$EXTERNALSYM INFINFO_INF_NAME_IS_ABSOLUTE}
  INFINFO_DEFAULT_SEARCH         = 3;
  {$EXTERNALSYM INFINFO_DEFAULT_SEARCH}
  INFINFO_REVERSE_DEFAULT_SEARCH = 4;
  {$EXTERNALSYM INFINFO_REVERSE_DEFAULT_SEARCH}
  INFINFO_INF_PATH_LIST_SEARCH   = 5;
  {$EXTERNALSYM INFINFO_INF_PATH_LIST_SEARCH}

function SetupQueryInfFileInformationA(var InfInformation: TSPInfInformation;
  InfIndex: UINT; ReturnBuffer: PAnsiChar; ReturnBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryInfFileInformationA}
function SetupQueryInfFileInformationW(var InfInformation: TSPInfInformation;
  InfIndex: UINT; ReturnBuffer: PWideChar; ReturnBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryInfFileInformationW}
function SetupQueryInfFileInformation(var InfInformation: TSPInfInformation;
  InfIndex: UINT; ReturnBuffer: PChar; ReturnBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryInfFileInformation}

function SetupQueryInfOriginalFileInformationA(var InfInformation: TSPInfInformation;
  InfIndex: UINT; AlternatePlatformInfo: PSPAltPlatformInfo;
  var OriginalFileInfo: TSPOriginalFileInfoA): LongBool; stdcall;
{$EXTERNALSYM SetupQueryInfOriginalFileInformationA}
function SetupQueryInfOriginalFileInformationW(var InfInformation: TSPInfInformation;
  InfIndex: UINT; AlternatePlatformInfo: PSPAltPlatformInfo;
  var OriginalFileInfo: TSPOriginalFileInfoW): LongBool; stdcall;
{$EXTERNALSYM SetupQueryInfOriginalFileInformationW}
function SetupQueryInfOriginalFileInformation(var InfInformation: TSPInfInformation;
  InfIndex: UINT; AlternatePlatformInfo: PSPAltPlatformInfo;
  var OriginalFileInfo: TSPOriginalFileInfoA): LongBool; stdcall;
{$EXTERNALSYM SetupQueryInfOriginalFileInformation}

function SetupQueryInfVersionInformationA(var InfInformation: TSPInfInformation;
  InfIndex: UINT; const Key, ReturnBuffer: PAnsiChar; ReturnBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryInfVersionInformationA}
function SetupQueryInfVersionInformationW(var InfInformation: TSPInfInformation;
  InfIndex: UINT; const Key, ReturnBuffer: PWideChar; ReturnBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryInfVersionInformationW}
function SetupQueryInfVersionInformation(var InfInformation: TSPInfInformation;
  InfIndex: UINT; const Key, ReturnBuffer: PChar; ReturnBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryInfVersionInformation}

function SetupGetInfFileListA(const DirectoryPath: PAnsiChar; InfStyle: DWORD;
  ReturnBuffer: PAnsiChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetInfFileListA}
function SetupGetInfFileListW(const DirectoryPath: PWideChar; InfStyle: DWORD;
  ReturnBuffer: PWideChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetInfFileListW}
function SetupGetInfFileList(const DirectoryPath: PChar; InfStyle: DWORD;
  ReturnBuffer: PChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetInfFileList}

function SetupOpenInfFileA(const FileName: PAnsiChar; const InfClass: PAnsiChar;
  InfStyle: DWORD; ErrorLine: PUINT): HINF; stdcall;
{$EXTERNALSYM SetupOpenInfFileA}
function SetupOpenInfFileW(const FileName: PWideChar; const InfClass: PWideChar;
  InfStyle: DWORD; ErrorLine: PUINT): HINF; stdcall;
{$EXTERNALSYM SetupOpenInfFileW}
function SetupOpenInfFile(const FileName: PChar; const InfClass: PChar;
  InfStyle: DWORD; ErrorLine: PUINT): HINF; stdcall;
{$EXTERNALSYM SetupOpenInfFile}

function SetupOpenMasterInf: HINF; stdcall;
{$EXTERNALSYM SetupOpenMasterInf}

function SetupOpenAppendInfFileA(const FileName: PAnsiChar; InfHandle: HINF;
  ErrorLine: PUINT): LongBool; stdcall;
{$EXTERNALSYM SetupOpenAppendInfFileA}
function SetupOpenAppendInfFileW(const FileName: PWideChar; InfHandle: HINF;
  ErrorLine: PUINT): LongBool; stdcall;
{$EXTERNALSYM SetupOpenAppendInfFileW}
function SetupOpenAppendInfFile(const FileName: PChar; InfHandle: HINF;
  ErrorLine: PUINT): LongBool; stdcall;
{$EXTERNALSYM SetupOpenAppendInfFile}

procedure SetupCloseInfFile(InfHandle: HINF); stdcall;
{$EXTERNALSYM SetupCloseInfFile}

function SetupFindFirstLineA(InfHandle: HINF; Section, Key: PAnsiChar;
  var Context: TInfContext): LongBool; stdcall;
{$EXTERNALSYM SetupFindFirstLineA}
function SetupFindFirstLineW(InfHandle: HINF; Section, Key: PWideChar;
  var Context: TInfContext): LongBool; stdcall;
{$EXTERNALSYM SetupFindFirstLineW}
function SetupFindFirstLine(InfHandle: HINF; Section, Key: PChar;
  var Context: TInfContext): LongBool; stdcall;
{$EXTERNALSYM SetupFindFirstLine}

function SetupFindNextLine(var ContextIn, ContextOut: TInfContext): LongBool; stdcall;
{$EXTERNALSYM SetupFindNextLine}

function SetupFindNextMatchLineA(var ContextIn: TInfContext; Key: PAnsiChar;
  var ContextOut: TInfContext): LongBool; stdcall;
{$EXTERNALSYM SetupFindNextMatchLineA}
function SetupFindNextMatchLineW(var ContextIn: TInfContext; Key: PWideChar;
  var ContextOut: TInfContext): LongBool; stdcall;
{$EXTERNALSYM SetupFindNextMatchLineW}
function SetupFindNextMatchLine(var ContextIn: TInfContext; Key: PChar;
  var ContextOut: TInfContext): LongBool; stdcall;
{$EXTERNALSYM SetupFindNextMatchLine}

function SetupGetLineByIndexA(InfHandle: HINF; Section: PAnsiChar; Index: DWORD;
  var Context: TInfContext): LongBool; stdcall;
{$EXTERNALSYM SetupGetLineByIndexA}
function SetupGetLineByIndexW(InfHandle: HINF; Section: PWideChar; Index: DWORD;
  var Context: TInfContext): LongBool; stdcall;
{$EXTERNALSYM SetupGetLineByIndexW}
function SetupGetLineByIndex(InfHandle: HINF; Section: PChar; Index: DWORD;
  var Context: TInfContext): LongBool; stdcall;
{$EXTERNALSYM SetupGetLineByIndex}

function SetupGetLineCountA(InfHandle: HINF; Section: PAnsiChar): Integer; stdcall;
{$EXTERNALSYM SetupGetLineCountA}
function SetupGetLineCountW(InfHandle: HINF; Section: PWideChar): Integer; stdcall;
{$EXTERNALSYM SetupGetLineCountW}
function SetupGetLineCount(InfHandle: HINF; Section: PChar): Integer; stdcall;
{$EXTERNALSYM SetupGetLineCount}

function SetupGetLineTextA(Context: PInfContext; InfHandle: HINF; Section,
  Key, ReturnBuffer: PAnsiChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetLineTextA}
function SetupGetLineTextW(Context: PInfContext; InfHandle: HINF; Section,
  Key, ReturnBuffer: PWideChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetLineTextW}
function SetupGetLineText(Context: PInfContext; InfHandle: HINF; Section,
  Key, ReturnBuffer: PChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetLineText}

function SetupGetFieldCount(var Context: TInfContext): DWORD; stdcall;
{$EXTERNALSYM SetupGetFieldCount}

function SetupGetStringFieldA(var Context: TInfContext; FieldIndex: DWORD;
  ReturnBuffer: PAnsiChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetStringFieldA}
function SetupGetStringFieldW(var Context: TInfContext; FieldIndex: DWORD;
  ReturnBuffer: PWideChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetStringFieldW}
function SetupGetStringField(var Context: TInfContext; FieldIndex: DWORD;
  ReturnBuffer: PChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetStringField}

function SetupGetIntField(var Context: TInfContext; FieldIndex: DWORD;
  var IntegerValue: Integer): LongBool; stdcall;
{$EXTERNALSYM SetupGetIntField}

function SetupGetMultiSzFieldA(var Context: TInfContext; FieldIndex: DWORD;
  ReturnBuffer: PAnsiChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetMultiSzFieldA}
function SetupGetMultiSzFieldW(var Context: TInfContext; FieldIndex: DWORD;
  ReturnBuffer: PWideChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetMultiSzFieldW}
function SetupGetMultiSzField(var Context: TInfContext; FieldIndex: DWORD;
  ReturnBuffer: PChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetMultiSzField}

function SetupGetBinaryField(var Context: TInfContext; FieldIndex: DWORD;
  ReturnBuffer: PBYTE; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetBinaryField}

function SetupGetFileCompressionInfoA(const SourceFileName: PAnsiChar;
  var ActualSourceFileName: PAnsiChar; var SourceFileSize: DWORD;
  var TargetFileSize: DWORD; var CompressionType: UINT): DWORD; stdcall;
{$EXTERNALSYM SetupGetFileCompressionInfoA}
function SetupGetFileCompressionInfoW(const SourceFileName: PWideChar;
  var ActualSourceFileName: PWideChar; var SourceFileSize: DWORD;
  var TargetFileSize: DWORD; var CompressionType: UINT): DWORD; stdcall;
{$EXTERNALSYM SetupGetFileCompressionInfoW}
function SetupGetFileCompressionInfo(const SourceFileName: PChar;
  var ActualSourceFileName: PChar; var SourceFileSize: DWORD;
  var TargetFileSize: DWORD; var CompressionType: UINT): DWORD; stdcall;
{$EXTERNALSYM SetupGetFileCompressionInfo}

//
// Compression types
//
const
  FILE_COMPRESSION_NONE   = 0;
  {$EXTERNALSYM FILE_COMPRESSION_NONE}
  FILE_COMPRESSION_WINLZA = 1;
  {$EXTERNALSYM FILE_COMPRESSION_WINLZA}
  FILE_COMPRESSION_MSZIP  = 2;
  {$EXTERNALSYM FILE_COMPRESSION_MSZIP}
  FILE_COMPRESSION_NTCAB  = 3;
  {$EXTERNALSYM FILE_COMPRESSION_NTCAB}

function SetupDecompressOrCopyFileA(const SourceFileName, TargetFileName: PAnsiChar;
  var CompressionType: UINT): DWORD; stdcall;
{$EXTERNALSYM SetupDecompressOrCopyFileA}
function SetupDecompressOrCopyFileW(const SourceFileName, TargetFileName: PWideChar;
  var CompressionType: UINT): DWORD; stdcall;
{$EXTERNALSYM SetupDecompressOrCopyFileW}
function SetupDecompressOrCopyFile(const SourceFileName, TargetFileName: PChar;
  var CompressionType: UINT): DWORD; stdcall;
{$EXTERNALSYM SetupDecompressOrCopyFile}

function SetupGetSourceFileLocationA(InfHandle: HINF; InfContext: PInfContext;
  const FileName: PAnsiChar; var SourceId: UINT; ReturnBuffer: PAnsiChar;
  ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetSourceFileLocationA}
function SetupGetSourceFileLocationW(InfHandle: HINF; InfContext: PInfContext;
  const FileName: PWideChar; var SourceId: UINT; ReturnBuffer: PWideChar;
  ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetSourceFileLocationW}
function SetupGetSourceFileLocation(InfHandle: HINF; InfContext: PInfContext;
  const FileName: PChar; var SourceId: UINT; ReturnBuffer: PChar;
  ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetSourceFileLocation}

function SetupGetSourceFileSizeA(InfHandle: HINF; InfContext: PInfContext;
  const FileName: PAnsiChar; const Section: PAnsiChar; var FileSize: DWORD;
  RoundingFactor: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupGetSourceFileSizeA}
function SetupGetSourceFileSizeW(InfHandle: HINF; InfContext: PInfContext;
  const FileName: PWideChar; const Section: PWideChar; var FileSize: DWORD;
  RoundingFactor: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupGetSourceFileSizeW}
function SetupGetSourceFileSize(InfHandle: HINF; InfContext: PInfContext;
  const FileName: PChar; const Section: PChar; var FileSize: DWORD;
  RoundingFactor: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupGetSourceFileSize}

function SetupGetTargetPathA(InfHandle: HINF; InfContext: PInfContext;
  const Section: PAnsiChar; ReturnBuffer: PAnsiChar; ReturnBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetTargetPathA}
function SetupGetTargetPathW(InfHandle: HINF; InfContext: PInfContext;
  const Section: PWideChar; ReturnBuffer: PWideChar; ReturnBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetTargetPathW}
function SetupGetTargetPath(InfHandle: HINF; InfContext: PInfContext;
  const Section: PChar; ReturnBuffer: PChar; ReturnBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetTargetPath}

//
// Define flags for SourceList APIs.
//
const
  SRCLIST_TEMPORARY       = $00000001;
  {$EXTERNALSYM SRCLIST_TEMPORARY}
  SRCLIST_NOBROWSE        = $00000002;
  {$EXTERNALSYM SRCLIST_NOBROWSE}
  SRCLIST_SYSTEM          = $00000010;
  {$EXTERNALSYM SRCLIST_SYSTEM}
  SRCLIST_USER            = $00000020;
  {$EXTERNALSYM SRCLIST_USER}
  SRCLIST_SYSIFADMIN      = $00000040;
  {$EXTERNALSYM SRCLIST_SYSIFADMIN}
  SRCLIST_SUBDIRS         = $00000100;
  {$EXTERNALSYM SRCLIST_SUBDIRS}
  SRCLIST_APPEND          = $00000200;
  {$EXTERNALSYM SRCLIST_APPEND}
  SRCLIST_NOSTRIPPLATFORM = $00000400;
  {$EXTERNALSYM SRCLIST_NOSTRIPPLATFORM}

function SetupSetSourceListA(Flags: DWORD; SourceList: PPASTR;
  SourceCount: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupSetSourceListA}
function SetupSetSourceListW(Flags: DWORD; SourceList: PPWSTR;
  SourceCount: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupSetSourceListW}
function SetupSetSourceList(Flags: DWORD; SourceList: PPSTR;
  SourceCount: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupSetSourceList}

function SetupCancelTemporarySourceList: LongBool; stdcall;
{$EXTERNALSYM SetupCancelTemporarySourceList}

function SetupAddToSourceListA(Flags: DWORD; const Source: PAnsiChar): LongBool; stdcall;
{$EXTERNALSYM SetupAddToSourceListA}
function SetupAddToSourceListW(Flags: DWORD; const Source: PWideChar): LongBool; stdcall;
{$EXTERNALSYM SetupAddToSourceListW}
function SetupAddToSourceList(Flags: DWORD; const Source: PChar): LongBool; stdcall;
{$EXTERNALSYM SetupAddToSourceList}

function SetupRemoveFromSourceListA(Flags: DWORD; const Source: PAnsiChar): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveFromSourceListA}
function SetupRemoveFromSourceListW(Flags: DWORD; const Source: PWideChar): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveFromSourceListW}
function SetupRemoveFromSourceList(Flags: DWORD; const Source: PChar): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveFromSourceList}

function SetupQuerySourceListA(Flags: DWORD; var List: PPASTR;
  var Count: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupQuerySourceListA}
function SetupQuerySourceListW(Flags: DWORD; var List: PPWSTR;
  var Count: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupQuerySourceListW}
function SetupQuerySourceList(Flags: DWORD; var List: PPSTR;
  var Count: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupQuerySourceList}

function SetupFreeSourceListA(var List: PPASTR; Count: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupFreeSourceListA}
function SetupFreeSourceListW(var List: PPWSTR; Count: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupFreeSourceListW}
function SetupFreeSourceList(var List: PPSTR; Count: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupFreeSourceList}

function SetupPromptForDiskA(hwndParent: HWND; const DialogTitle, DiskName,
  PathToSource, FileSought, TagFile: PAnsiChar; DiskPromptStyle: DWORD;
  PathBuffer: PAnsiChar; PathBufferSize: DWORD; var PathRequiredSize: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupPromptForDiskA}
function SetupPromptForDiskW(hwndParent: HWND; const DialogTitle, DiskName,
  PathToSource, FileSought, TagFile: PWideChar; DiskPromptStyle: DWORD;
  PathBuffer: PWideChar; PathBufferSize: DWORD; var PathRequiredSize: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupPromptForDiskW}
function SetupPromptForDisk(hwndParent: HWND; const DialogTitle, DiskName,
  PathToSource, FileSought, TagFile: PChar; DiskPromptStyle: DWORD;
  PathBuffer: PChar; PathBufferSize: DWORD; var PathRequiredSize: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupPromptForDisk}

function SetupCopyErrorA(hwndParent: HWND; const DialogTitle, DiskName,
  PathToSource, SourceFile, TargetPathFile: PAnsiChar; Win32ErrorCode: UINT; Style: DWORD;
  PathBuffer: PAnsiChar; PathBufferSize: DWORD; PathRequiredSize: PDWORD): UINT; stdcall;
{$EXTERNALSYM SetupCopyErrorA}
function SetupCopyErrorW(hwndParent: HWND; const DialogTitle, DiskName,
  PathToSource, SourceFile, TargetPathFile: PWideChar; Win32ErrorCode: UINT; Style: DWORD;
  PathBuffer: PWideChar; PathBufferSize: DWORD; PathRequiredSize: PDWORD): UINT; stdcall;
{$EXTERNALSYM SetupCopyErrorW}
function SetupCopyError(hwndParent: HWND; const DialogTitle, DiskName,
  PathToSource, SourceFile, TargetPathFile: PChar; Win32ErrorCode: UINT; Style: DWORD;
  PathBuffer: PChar; PathBufferSize: DWORD; PathRequiredSize: PDWORD): UINT; stdcall;
{$EXTERNALSYM SetupCopyError}

function SetupRenameErrorA(hwndParent: HWND; const DialogTitle, SourceFile,
  TargetFile: PAnsiChar; Win32ErrorCode: UINT; Style: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupRenameErrorA}
function SetupRenameErrorW(hwndParent: HWND; const DialogTitle, SourceFile,
  TargetFile: PWideChar; Win32ErrorCode: UINT; Style: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupRenameErrorW}
function SetupRenameError(hwndParent: HWND; const DialogTitle, SourceFile,
  TargetFile: PChar; Win32ErrorCode: UINT; Style: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupRenameError}

function SetupDeleteErrorA(hwndParent: HWND; const DialogTitle, File_: PAnsiChar;
  Win32ErrorCode: UINT; Style: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupDeleteErrorA}
function SetupDeleteErrorW(hwndParent: HWND; const DialogTitle, File_: PWideChar;
  Win32ErrorCode: UINT; Style: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupDeleteErrorW}
function SetupDeleteError(hwndParent: HWND; const DialogTitle, File_: PChar;
  Win32ErrorCode: UINT; Style: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupDeleteError}

function SetupBackupErrorA(hwndParent: HWND; const DialogTitle, BackupFile,
  TargetFile: PAnsiChar; Win32ErrorCode: UINT; Style: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupBackupErrorA}
function SetupBackupErrorW(hwndParent: HWND; const DialogTitle, BackupFile,
  TargetFile: PWideChar; Win32ErrorCode: UINT; Style: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupBackupErrorW}
function SetupBackupError(hwndParent: HWND; const DialogTitle, BackupFile,
  TargetFile: PChar; Win32ErrorCode: UINT; Style: DWORD): UINT; stdcall;
{$EXTERNALSYM SetupBackupError}

//
// Styles for SetupPromptForDisk, SetupCopyError,
// SetupRenameError, SetupDeleteError
//
const
  IDF_NOBROWSE     = $00000001;
  {$EXTERNALSYM IDF_NOBROWSE}
  IDF_NOSKIP       = $00000002;
  {$EXTERNALSYM IDF_NOSKIP}
  IDF_NODETAILS    = $00000004;
  {$EXTERNALSYM IDF_NODETAILS}
  IDF_NOCOMPRESSED = $00000008;
  {$EXTERNALSYM IDF_NOCOMPRESSED}
  IDF_CHECKFIRST   = $00000100;
  {$EXTERNALSYM IDF_CHECKFIRST}
  IDF_NOBEEP       = $00000200;
  {$EXTERNALSYM IDF_NOBEEP}
  IDF_NOFOREGROUND = $00000400;
  {$EXTERNALSYM IDF_NOFOREGROUND}
  IDF_WARNIFSKIP   = $00000800;
  {$EXTERNALSYM IDF_WARNIFSKIP}
  IDF_OEMDISK      = DWORD($80000000);
  {$EXTERNALSYM IDF_OEMDISK}

//
// Return values for SetupPromptForDisk, SetupCopyError,
// SetupRenameError, SetupDeleteError, SetupBackupError
//
const
  DPROMPT_SUCCESS        = 0;
  {$EXTERNALSYM DPROMPT_SUCCESS}
  DPROMPT_CANCEL         = 1;
  {$EXTERNALSYM DPROMPT_CANCEL}
  DPROMPT_SKIPFILE       = 2;
  {$EXTERNALSYM DPROMPT_SKIPFILE}
  DPROMPT_BUFFERTOOSMALL = 3;
  {$EXTERNALSYM DPROMPT_BUFFERTOOSMALL}
  DPROMPT_OUTOFMEMORY    = 4;
  {$EXTERNALSYM DPROMPT_OUTOFMEMORY}

function SetupSetDirectoryIdA(InfHandle: HINF; Id: DWORD; const Directory: PAnsiChar): LongBool; stdcall;
{$EXTERNALSYM SetupSetDirectoryIdA}
function SetupSetDirectoryIdW(InfHandle: HINF; Id: DWORD; const Directory: PWideChar): LongBool; stdcall;
{$EXTERNALSYM SetupSetDirectoryIdW}
function SetupSetDirectoryId(InfHandle: HINF; Id: DWORD; const Directory: PChar): LongBool; stdcall;
{$EXTERNALSYM SetupSetDirectoryId}

function SetupSetDirectoryIdExA(InfHandle: HINF; Id: DWORD; const Directory: PAnsiChar;
  Flags: DWORD; Reserved1: DWORD; Reserved2: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupSetDirectoryIdExA}
function SetupSetDirectoryIdExW(InfHandle: HINF; Id: DWORD; const Directory: PWideChar;
  Flags: DWORD; Reserved1: DWORD; Reserved2: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupSetDirectoryIdExW}
function SetupSetDirectoryIdEx(InfHandle: HINF; Id: DWORD; const Directory: PChar;
  Flags: DWORD; Reserved1: DWORD; Reserved2: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupSetDirectoryIdEx}

//
// Flags for SetupSetDirectoryIdEx
//
const
  SETDIRID_NOT_FULL_PATH = $00000001;
  {$EXTERNALSYM SETDIRID_NOT_FULL_PATH}

function SetupGetSourceInfoA(InfHandle: HINF; SourceId, InfoDesired: UINT;
  ReturnBuffer: PAnsiChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetSourceInfoA}
function SetupGetSourceInfoW(InfHandle: HINF; SourceId, InfoDesired: UINT;
  ReturnBuffer: PWideChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetSourceInfoW}
function SetupGetSourceInfo(InfHandle: HINF; SourceId, InfoDesired: UINT;
  ReturnBuffer: PChar; ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupGetSourceInfo}

//
// InfoDesired values for SetupGetSourceInfo
//
const
  SRCINFO_PATH        = 1;
  {$EXTERNALSYM SRCINFO_PATH}
  SRCINFO_TAGFILE     = 2;
  {$EXTERNALSYM SRCINFO_TAGFILE}
  SRCINFO_DESCRIPTION = 3;
  {$EXTERNALSYM SRCINFO_DESCRIPTION}
  SRCINFO_FLAGS       = 4;
  {$EXTERNALSYM SRCINFO_FLAGS}

function SetupInstallFileA(InfHandle: HINF; InfContext: PInfContext;
  const SourceFile, SourcePathRoot, DestinationName: PAnsiChar; CopyStyle: DWORD;
  CopyMsgHandler: TSPFileCallbackA; Context: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFileA}
function SetupInstallFileW(InfHandle: HINF; InfContext: PInfContext;
  const SourceFile, SourcePathRoot, DestinationName: PWideChar; CopyStyle: DWORD;
  CopyMsgHandler: TSPFileCallbackW; Context: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFileW}
function SetupInstallFile(InfHandle: HINF; InfContext: PInfContext;
  const SourceFile, SourcePathRoot, DestinationName: PChar; CopyStyle: DWORD;
  CopyMsgHandler: TSPFileCallbackA; Context: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFile}

function SetupInstallFileExA(InfHandle: HINF; InfContext: PInfContext;
  const SourceFile, SourcePathRoot, DestinationName: PAnsiChar; CopyStyle: DWORD;
  CopyMsgHandler: TSPFileCallbackA; Context: Pointer; var FileWasInUse: LongBool): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFileExA}
function SetupInstallFileExW(InfHandle: HINF; InfContext: PInfContext;
  const SourceFile, SourcePathRoot, DestinationName: PWideChar; CopyStyle: DWORD;
  CopyMsgHandler: TSPFileCallbackW; Context: Pointer; var FileWasInUse: LongBool): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFileExW}
function SetupInstallFileEx(InfHandle: HINF; InfContext: PInfContext;
  const SourceFile, SourcePathRoot, DestinationName: PChar; CopyStyle: DWORD;
  CopyMsgHandler: TSPFileCallbackA; Context: Pointer; var FileWasInUse: LongBool): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFileEx}

//
// CopyStyle values for copy and queue-related APIs
//
const
  SP_COPY_DELETESOURCE        = $0000001; // delete source file on successful copy
  {$EXTERNALSYM SP_COPY_DELETESOURCE}
  SP_COPY_REPLACEONLY         = $0000002; // copy only if target file already present
  {$EXTERNALSYM SP_COPY_REPLACEONLY}
  SP_COPY_NEWER               = $0000004; // copy only if source newer than or same as target
  {$EXTERNALSYM SP_COPY_NEWER}
  SP_COPY_NEWER_OR_SAME       = SP_COPY_NEWER;
  {$EXTERNALSYM SP_COPY_NEWER_OR_SAME}
  SP_COPY_NOOVERWRITE         = $0000008; // copy only if target doesn't exist
  {$EXTERNALSYM SP_COPY_NOOVERWRITE}
  SP_COPY_NODECOMP            = $0000010; // don't decompress source file while copying
  {$EXTERNALSYM SP_COPY_NODECOMP}
  SP_COPY_LANGUAGEAWARE       = $0000020; // don't overwrite file of different language
  {$EXTERNALSYM SP_COPY_LANGUAGEAWARE}
  SP_COPY_SOURCE_ABSOLUTE     = $0000040; // SourceFile is a full source path
  {$EXTERNALSYM SP_COPY_SOURCE_ABSOLUTE}
  SP_COPY_SOURCEPATH_ABSOLUTE = $0000080; // SourcePathRoot is the full path
  {$EXTERNALSYM SP_COPY_SOURCEPATH_ABSOLUTE}
  SP_COPY_IN_USE_NEEDS_REBOOT = $0000100; // System needs reboot if file in use
  {$EXTERNALSYM SP_COPY_IN_USE_NEEDS_REBOOT}
  SP_COPY_FORCE_IN_USE        = $0000200; // Force target-in-use behavior
  {$EXTERNALSYM SP_COPY_FORCE_IN_USE}
  SP_COPY_NOSKIP              = $0000400; // Skip is disallowed for this file or section
  {$EXTERNALSYM SP_COPY_NOSKIP}
  SP_FLAG_CABINETCONTINUATION = $0000800; // Used with need media notification
  {$EXTERNALSYM SP_FLAG_CABINETCONTINUATION}
  SP_COPY_FORCE_NOOVERWRITE   = $0001000; // like NOOVERWRITE but no callback nofitication
  {$EXTERNALSYM SP_COPY_FORCE_NOOVERWRITE}
  SP_COPY_FORCE_NEWER         = $0002000; // like NEWER but no callback nofitication
  {$EXTERNALSYM SP_COPY_FORCE_NEWER}
  SP_COPY_WARNIFSKIP          = $0004000; // system critical file: warn if user tries to skip
  {$EXTERNALSYM SP_COPY_WARNIFSKIP}
  SP_COPY_NOBROWSE            = $0008000; // Browsing is disallowed for this file or section
  {$EXTERNALSYM SP_COPY_NOBROWSE}
  SP_COPY_NEWER_ONLY          = $0010000; // copy only if source file newer than target
  {$EXTERNALSYM SP_COPY_NEWER_ONLY}
  SP_COPY_SOURCE_SIS_MASTER   = $0020000; // source is single-instance store master
  {$EXTERNALSYM SP_COPY_SOURCE_SIS_MASTER}
  SP_COPY_OEMINF_CATALOG_ONLY = $0040000; // (SetupCopyOEMInf only) don't copy INF--just catalog
  {$EXTERNALSYM SP_COPY_OEMINF_CATALOG_ONLY}
  SP_COPY_REPLACE_BOOT_FILE   = $0080000; // file must be present upon reboot (i.e., it's
  {$EXTERNALSYM SP_COPY_REPLACE_BOOT_FILE}// needed by the loader); this flag implies a reboot
  SP_COPY_NOPRUNE             = $0100000; // never prune this file
  {$EXTERNALSYM SP_COPY_NOPRUNE}

function SetupOpenFileQueue: HSPFILEQ; stdcall;
{$EXTERNALSYM SetupOpenFileQueue}

function SetupCloseFileQueue(QueueHandle: HSPFILEQ): LongBool; stdcall;
{$EXTERNALSYM SetupCloseFileQueue}

function SetupSetFileQueueAlternatePlatformA(QueueHandle: HSPFILEQ;
  AlternatePlatformInfo: PSPAltPlatformInfo;
  const AlternateDefaultCatalogFile: PAnsiChar): LongBool; stdcall;
{$EXTERNALSYM SetupSetFileQueueAlternatePlatformA}
function SetupSetFileQueueAlternatePlatformW(QueueHandle: HSPFILEQ;
  AlternatePlatformInfo: PSPAltPlatformInfo;
  const AlternateDefaultCatalogFile: PWideChar): LongBool; stdcall;
{$EXTERNALSYM SetupSetFileQueueAlternatePlatformW}
function SetupSetFileQueueAlternatePlatform(QueueHandle: HSPFILEQ;
  AlternatePlatformInfo: PSPAltPlatformInfo;
  const AlternateDefaultCatalogFile: PChar): LongBool; stdcall;
{$EXTERNALSYM SetupSetFileQueueAlternatePlatform}

function SetupSetPlatformPathOverrideA(const Override_: PAnsiChar): LongBool; stdcall;
{$EXTERNALSYM SetupSetPlatformPathOverrideA}
function SetupSetPlatformPathOverrideW(const Override_: PWideChar): LongBool; stdcall;
{$EXTERNALSYM SetupSetPlatformPathOverrideW}
function SetupSetPlatformPathOverride(const Override_: PChar): LongBool; stdcall;
{$EXTERNALSYM SetupSetPlatformPathOverride}

function SetupQueueCopyA(QueueHandle: HSPFILEQ; const SourceRootPath, SourcePath,
  SourceFilename, SourceDescription, SourceTagfile, TargetDirectory,
  TargetFilename: PAnsiChar; CopyStyle: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueueCopyA}
function SetupQueueCopyW(QueueHandle: HSPFILEQ; const SourceRootPath, SourcePath,
  SourceFilename, SourceDescription, SourceTagfile, TargetDirectory,
  TargetFilename: PWideChar; CopyStyle: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueueCopyW}
function SetupQueueCopy(QueueHandle: HSPFILEQ; const SourceRootPath, SourcePath,
  SourceFilename, SourceDescription, SourceTagfile, TargetDirectory,
  TargetFilename: PChar; CopyStyle: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueueCopy}

function SetupQueueCopyIndirectA(var CopyParams: TSPFileCopyParamsA): LongBool; stdcall;
{$EXTERNALSYM SetupQueueCopyIndirectA}
function SetupQueueCopyIndirectW(var CopyParams: TSPFileCopyParamsW): LongBool; stdcall;
{$EXTERNALSYM SetupQueueCopyIndirectW}
function SetupQueueCopyIndirect(var CopyParams: TSPFileCopyParamsA): LongBool; stdcall;
{$EXTERNALSYM SetupQueueCopyIndirect}

function SetupQueueDefaultCopyA(QueueHandle: HSPFILEQ; InfHandle: HINF;
  const SourceRootPath, SourceFilename, TargetFilename: PAnsiChar;
  CopyStyle: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueueDefaultCopyA}
function SetupQueueDefaultCopyW(QueueHandle: HSPFILEQ; InfHandle: HINF;
  const SourceRootPath, SourceFilename, TargetFilename: PWideChar;
  CopyStyle: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueueDefaultCopyW}
function SetupQueueDefaultCopy(QueueHandle: HSPFILEQ; InfHandle: HINF;
  const SourceRootPath, SourceFilename, TargetFilename: PChar;
  CopyStyle: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueueDefaultCopy}

function SetupQueueCopySectionA(QueueHandle: HSPFILEQ; const SourceRootPath: PAnsiChar;
  InfHandle: HINF; ListInfHandle: HINF; const Section: PAnsiChar; CopyStyle: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueueCopySectionA}
function SetupQueueCopySectionW(QueueHandle: HSPFILEQ; const SourceRootPath: PWideChar;
  InfHandle: HINF; ListInfHandle: HINF; const Section: PWideChar; CopyStyle: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueueCopySectionW}
function SetupQueueCopySection(QueueHandle: HSPFILEQ; const SourceRootPath: PChar;
  InfHandle: HINF; ListInfHandle: HINF; const Section: PChar; CopyStyle: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueueCopySection}

function SetupQueueDeleteA(QueueHandle: HSPFILEQ; const PathPart1, PathPart2: PAnsiChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueDeleteA}
function SetupQueueDeleteW(QueueHandle: HSPFILEQ; const PathPart1, PathPart2: PWideChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueDeleteW}
function SetupQueueDelete(QueueHandle: HSPFILEQ; const PathPart1, PathPart2: PChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueDelete}

function SetupQueueDeleteSectionA(QueueHandle: HSPFILEQ; InfHandle: HINF;
  ListInfHandle: HINF; const Section: PAnsiChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueDeleteSectionA}
function SetupQueueDeleteSectionW(QueueHandle: HSPFILEQ; InfHandle: HINF;
  ListInfHandle: HINF; const Section: PWideChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueDeleteSectionW}
function SetupQueueDeleteSection(QueueHandle: HSPFILEQ; InfHandle: HINF;
  ListInfHandle: HINF; const Section: PChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueDeleteSection}

function SetupQueueRenameA(QueueHandle: HSPFILEQ; const SourcePath,
  SourceFilename, TargetPath, TargetFilename: PAnsiChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueRenameA}
function SetupQueueRenameW(QueueHandle: HSPFILEQ; const SourcePath,
  SourceFilename, TargetPath, TargetFilename: PWideChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueRenameW}
function SetupQueueRename(QueueHandle: HSPFILEQ; const SourcePath,
  SourceFilename, TargetPath, TargetFilename: PChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueRename}

function SetupQueueRenameSectionA(QueueHandle: HSPFILEQ; InfHandle: HINF;
  ListInfHandle: HINF; const Section: PAnsiChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueRenameSectionA}
function SetupQueueRenameSectionW(QueueHandle: HSPFILEQ; InfHandle: HINF;
  ListInfHandle: HINF; const Section: PWideChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueRenameSectionW}
function SetupQueueRenameSection(QueueHandle: HSPFILEQ; InfHandle: HINF;
  ListInfHandle: HINF; const Section: PChar): LongBool; stdcall;
{$EXTERNALSYM SetupQueueRenameSection}

function SetupCommitFileQueueA(Owner: HWND; QueueHandle: HSPFILEQ;
  MsgHandler: TSPFileCallbackA; Context: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupCommitFileQueueA}
function SetupCommitFileQueueW(Owner: HWND; QueueHandle: HSPFILEQ;
  MsgHandler: TSPFileCallbackW; Context: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupCommitFileQueueW}
function SetupCommitFileQueue(Owner: HWND; QueueHandle: HSPFILEQ;
  MsgHandler: TSPFileCallbackA; Context: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupCommitFileQueue}

function SetupScanFileQueueA(FileQueue: HSPFILEQ; Flags: DWORD; Window: HWND;
  CallbackRoutine: TSPFileCallbackA; CallbackContext: Pointer; var Result: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupScanFileQueueA}
function SetupScanFileQueueW(FileQueue: HSPFILEQ; Flags: DWORD; Window: HWND;
  CallbackRoutine: TSPFileCallbackW; CallbackContext: Pointer; var Result: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupScanFileQueueW}
function SetupScanFileQueue(FileQueue: HSPFILEQ; Flags: DWORD; Window: HWND;
  CallbackRoutine: TSPFileCallbackA; CallbackContext: Pointer; var Result: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupScanFileQueue}

//
// Define flags for SetupScanFileQueue.
//
const
  SPQ_SCAN_FILE_PRESENCE    = $00000001;
  {$EXTERNALSYM SPQ_SCAN_FILE_PRESENCE}
  SPQ_SCAN_FILE_VALIDITY    = $00000002;
  {$EXTERNALSYM SPQ_SCAN_FILE_VALIDITY}
  SPQ_SCAN_USE_CALLBACK     = $00000004;
  {$EXTERNALSYM SPQ_SCAN_USE_CALLBACK}
  SPQ_SCAN_USE_CALLBACKEX   = $00000008;
  {$EXTERNALSYM SPQ_SCAN_USE_CALLBACKEX}
  SPQ_SCAN_INFORM_USER      = $00000010;
  {$EXTERNALSYM SPQ_SCAN_INFORM_USER}
  SPQ_SCAN_PRUNE_COPY_QUEUE = $00000020;
  {$EXTERNALSYM SPQ_SCAN_PRUNE_COPY_QUEUE}

//
// Define flags used with Param2 for SPFILENOTIFY_QUEUESCAN
//
  SPQ_DELAYED_COPY = $00000001; // file was in use; registered for delayed copy
  {$EXTERNALSYM SPQ_DELAYED_COPY}

//
// Define OEM Source Type values for use in SetupCopyOEMInf.
//
  SPOST_NONE = 0;
  {$EXTERNALSYM SPOST_NONE}
  SPOST_PATH = 1;
  {$EXTERNALSYM SPOST_PATH}
  SPOST_URL  = 2;
  {$EXTERNALSYM SPOST_URL}
  SPOST_MAX  = 3;
  {$EXTERNALSYM SPOST_MAX}

function SetupCopyOEMInfA(const SourceInfFileName, OEMSourceMediaLocation: PAnsiChar;
  OEMSourceMediaType, CopyStyle: DWORD; DestinationInfFileName: PAnsiChar;
  DestinationInfFileNameSize: DWORD; RequiredSize: PDWORD;
  DestinationInfFileNameComponent: PPASTR): LongBool; stdcall;
{$EXTERNALSYM SetupCopyOEMInfA}
function SetupCopyOEMInfW(const SourceInfFileName, OEMSourceMediaLocation: PWideChar;
  OEMSourceMediaType, CopyStyle: DWORD; DestinationInfFileName: PWideChar;
  DestinationInfFileNameSize: DWORD; RequiredSize: PDWORD;
  DestinationInfFileNameComponent: PPWSTR): LongBool; stdcall;
{$EXTERNALSYM SetupCopyOEMInfW}
function SetupCopyOEMInf(const SourceInfFileName, OEMSourceMediaLocation: PChar;
  OEMSourceMediaType, CopyStyle: DWORD; DestinationInfFileName: PChar;
  DestinationInfFileNameSize: DWORD; RequiredSize: PDWORD;
  DestinationInfFileNameComponent: PPSTR): LongBool; stdcall;
{$EXTERNALSYM SetupCopyOEMInf}

//
// Disk space list APIs
//
function SetupCreateDiskSpaceListA(Reserved1: Pointer; Reserved2: DWORD;
  Flags: UINT): HDSKSPC; stdcall;
{$EXTERNALSYM SetupCreateDiskSpaceListA}
function SetupCreateDiskSpaceListW(Reserved1: Pointer; Reserved2: DWORD;
  Flags: UINT): HDSKSPC; stdcall;
{$EXTERNALSYM SetupCreateDiskSpaceListW}
function SetupCreateDiskSpaceList(Reserved1: Pointer; Reserved2: DWORD;
  Flags: UINT): HDSKSPC; stdcall;
{$EXTERNALSYM SetupCreateDiskSpaceList}

//
// Flags for SetupCreateDiskSpaceList
//
const
  SPDSL_IGNORE_DISK              = $00000001; // ignore deletes and on-disk files in copies
  {$EXTERNALSYM SPDSL_IGNORE_DISK}
  SPDSL_DISALLOW_NEGATIVE_ADJUST = $00000002;
  {$EXTERNALSYM SPDSL_DISALLOW_NEGATIVE_ADJUST}

function SetupDuplicateDiskSpaceListA(DiskSpace: HDSKSPC; Reserved1: Pointer;
  Reserved2: DWORD; Flags: UINT): HDSKSPC; stdcall;
{$EXTERNALSYM SetupDuplicateDiskSpaceListA}
function SetupDuplicateDiskSpaceListW(DiskSpace: HDSKSPC; Reserved1: Pointer;
  Reserved2: DWORD; Flags: UINT): HDSKSPC; stdcall;
{$EXTERNALSYM SetupDuplicateDiskSpaceListW}
function SetupDuplicateDiskSpaceList(DiskSpace: HDSKSPC; Reserved1: Pointer;
  Reserved2: DWORD; Flags: UINT): HDSKSPC; stdcall;
{$EXTERNALSYM SetupDuplicateDiskSpaceList}

function SetupDestroyDiskSpaceList(DiskSpace: HDSKSPC): LongBool; stdcall;
{$EXTERNALSYM SetupDestroyDiskSpaceList}

function SetupQueryDrivesInDiskSpaceListA(DiskSpace: HDSKSPC; ReturnBuffer: PAnsiChar;
  ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryDrivesInDiskSpaceListA}
function SetupQueryDrivesInDiskSpaceListW(DiskSpace: HDSKSPC; ReturnBuffer: PWideChar;
  ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryDrivesInDiskSpaceListW}
function SetupQueryDrivesInDiskSpaceList(DiskSpace: HDSKSPC; ReturnBuffer: PChar;
  ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryDrivesInDiskSpaceList}

function SetupQuerySpaceRequiredOnDriveA(DiskSpace: HDSKSPC; const DriveSpec: PAnsiChar;
  var SpaceRequired: Int64; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupQuerySpaceRequiredOnDriveA}
function SetupQuerySpaceRequiredOnDriveW(DiskSpace: HDSKSPC; const DriveSpec: PWideChar;
  var SpaceRequired: Int64; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupQuerySpaceRequiredOnDriveW}
function SetupQuerySpaceRequiredOnDrive(DiskSpace: HDSKSPC; const DriveSpec: PChar;
  var SpaceRequired: Int64; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupQuerySpaceRequiredOnDrive}

function SetupAdjustDiskSpaceListA(DiskSpace: HDSKSPC; const DriveRoot: PAnsiChar;
  Amount: Int64; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAdjustDiskSpaceListA}
function SetupAdjustDiskSpaceListW(DiskSpace: HDSKSPC; const DriveRoot: PWideChar;
  Amount: Int64; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAdjustDiskSpaceListW}
function SetupAdjustDiskSpaceList(DiskSpace: HDSKSPC; const DriveRoot: PChar;
  Amount: Int64; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAdjustDiskSpaceList}

function SetupAddToDiskSpaceListA(DiskSpace: HDSKSPC; const TargetFilespec: PAnsiChar;
  FileSize: Int64; Operation: UINT; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAddToDiskSpaceListA}
function SetupAddToDiskSpaceListW(DiskSpace: HDSKSPC; const TargetFilespec: PWideChar;
  FileSize: Int64; Operation: UINT; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAddToDiskSpaceListW}
function SetupAddToDiskSpaceList(DiskSpace: HDSKSPC; const TargetFilespec: PChar;
  FileSize: Int64; Operation: UINT; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAddToDiskSpaceList}

function SetupAddSectionToDiskSpaceListA(DiskSpace: HDSKSPC; InfHandle: HINF;
  ListInfHandle: HINF; const SectionName: PAnsiChar; Operation: UINT;
  Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAddSectionToDiskSpaceListA}
function SetupAddSectionToDiskSpaceListW(DiskSpace: HDSKSPC; InfHandle: HINF;
  ListInfHandle: HINF; const SectionName: PWideChar; Operation: UINT;
  Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAddSectionToDiskSpaceListW}
function SetupAddSectionToDiskSpaceList(DiskSpace: HDSKSPC; InfHandle: HINF;
  ListInfHandle: HINF; const SectionName: PChar; Operation: UINT;
  Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAddSectionToDiskSpaceList}

function SetupAddInstallSectionToDiskSpaceListA( DiskSpace: HDSKSPC;
  InfHandle: HINF; LayoutInfHandle: HINF; const SectionName: PAnsiChar;
  Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAddInstallSectionToDiskSpaceListA}
function SetupAddInstallSectionToDiskSpaceListW( DiskSpace: HDSKSPC;
  InfHandle: HINF; LayoutInfHandle: HINF; const SectionName: PWideChar;
  Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAddInstallSectionToDiskSpaceListW}
function SetupAddInstallSectionToDiskSpaceList( DiskSpace: HDSKSPC;
  InfHandle: HINF; LayoutInfHandle: HINF; const SectionName: PChar;
  Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupAddInstallSectionToDiskSpaceList}

function SetupRemoveFromDiskSpaceListA(DiskSpace: HDSKSPC; const TargetFilespec: PAnsiChar;
  Operation: UINT; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveFromDiskSpaceListA}
function SetupRemoveFromDiskSpaceListW(DiskSpace: HDSKSPC; const TargetFilespec: PWideChar;
  Operation: UINT; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveFromDiskSpaceListW}
function SetupRemoveFromDiskSpaceList(DiskSpace: HDSKSPC; const TargetFilespec: PChar;
  Operation: UINT; Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveFromDiskSpaceList}

function SetupRemoveSectionFromDiskSpaceListA(DiskSpace: HDSKSPC; InfHandle: HINF;
  ListInfHandle: HINF; const SectionName: PAnsiChar; Operation: UINT; Reserved1: Pointer;
  Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveSectionFromDiskSpaceListA}
function SetupRemoveSectionFromDiskSpaceListW(DiskSpace: HDSKSPC; InfHandle: HINF;
  ListInfHandle: HINF; const SectionName: PWideChar; Operation: UINT; Reserved1: Pointer;
  Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveSectionFromDiskSpaceListW}
function SetupRemoveSectionFromDiskSpaceList(DiskSpace: HDSKSPC; InfHandle: HINF;
  ListInfHandle: HINF; const SectionName: PChar; Operation: UINT; Reserved1: Pointer;
  Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveSectionFromDiskSpaceList}

function SetupRemoveInstallSectionFromDiskSpaceListA(DiskSpace: HDSKSPC;
  InfHandle: HINF; LayoutInfHandle: HINF; const SectionName: PAnsiChar;
  Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveInstallSectionFromDiskSpaceListA}
function SetupRemoveInstallSectionFromDiskSpaceListW(DiskSpace: HDSKSPC;
  InfHandle: HINF; LayoutInfHandle: HINF; const SectionName: PWideChar;
  Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveInstallSectionFromDiskSpaceListW}
function SetupRemoveInstallSectionFromDiskSpaceList(DiskSpace: HDSKSPC;
  InfHandle: HINF; LayoutInfHandle: HINF; const SectionName: PChar;
  Reserved1: Pointer; Reserved2: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveInstallSectionFromDiskSpaceList}

//
// Cabinet APIs
//

function SetupIterateCabinetA(const CabinetFile: PAnsiChar; Reserved: DWORD;
  MsgHandler: TSPFileCallbackA; Context: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupIterateCabinetA}
function SetupIterateCabinetW(const CabinetFile: PWideChar; Reserved: DWORD;
  MsgHandler: TSPFileCallbackW; Context: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupIterateCabinetW}
function SetupIterateCabinet(const CabinetFile: PChar; Reserved: DWORD;
  MsgHandler: TSPFileCallbackA; Context: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupIterateCabinet}

function SetupPromptReboot(FileQueue: HSPFILEQ; Owner: HWND; ScanOnly: LongBool): Integer; stdcall;
{$EXTERNALSYM SetupPromptReboot}

//
// Define flags that are returned by SetupPromptReboot
//
const
  SPFILEQ_FILE_IN_USE        = $00000001;
  {$EXTERNALSYM SPFILEQ_FILE_IN_USE}
  SPFILEQ_REBOOT_RECOMMENDED = $00000002;
  {$EXTERNALSYM SPFILEQ_REBOOT_RECOMMENDED}
  SPFILEQ_REBOOT_IN_PROGRESS = $00000004;
  {$EXTERNALSYM SPFILEQ_REBOOT_IN_PROGRESS}

function SetupInitDefaultQueueCallback(OwnerWindow: HWND): Pointer; stdcall;
{$EXTERNALSYM SetupInitDefaultQueueCallback}

function SetupInitDefaultQueueCallbackEx(OwnerWindow: HWND; AlternateProgressWindow: HWND;
  ProgressMessage: UINT; Reserved1: DWORD; Reserved2: Pointer): Pointer; stdcall;
{$EXTERNALSYM SetupInitDefaultQueueCallbackEx}

procedure SetupTermDefaultQueueCallback(Context: Pointer); stdcall;
{$EXTERNALSYM SetupTermDefaultQueueCallback}

function SetupDefaultQueueCallbackA(Context: Pointer; Notification: UINT;
  Param1, Param2: UINT_PTR): UINT; stdcall;
{$EXTERNALSYM SetupDefaultQueueCallbackA}
function SetupDefaultQueueCallbackW(Context: Pointer; Notification: UINT;
  Param1, Param2: UINT_PTR): UINT; stdcall;
{$EXTERNALSYM SetupDefaultQueueCallbackW}
function SetupDefaultQueueCallback(Context: Pointer; Notification: UINT;
  Param1, Param2: UINT_PTR): UINT; stdcall;
{$EXTERNALSYM SetupDefaultQueueCallback}

//
// Flags for AddReg section lines in INF.  The corresponding value
// is <ValueType> in the AddReg line format given below:
//
// <RegRootString>,<SubKey>,<ValueName>,<ValueType>,<Value>...
//
// The low word contains basic flags concerning the general data type
// and AddReg action. The high word contains values that more specifically
// identify the data type of the registry value.  The high word is ignored
// by the 16-bit Windows 95 SETUPX APIs.
//
const
  FLG_ADDREG_BINVALUETYPE   = ($00000001);
  {$EXTERNALSYM FLG_ADDREG_BINVALUETYPE}
  FLG_ADDREG_NOCLOBBER      = ($00000002);
  {$EXTERNALSYM FLG_ADDREG_NOCLOBBER}
  FLG_ADDREG_DELVAL         = ($00000004);
  {$EXTERNALSYM FLG_ADDREG_DELVAL}
  FLG_ADDREG_APPEND         = ($00000008); // Currently supported only
  {$EXTERNALSYM FLG_ADDREG_APPEND}         // for REG_MULTI_SZ values.
  FLG_ADDREG_KEYONLY        = ($00000010); // Just create the key, ignore value
  {$EXTERNALSYM FLG_ADDREG_KEYONLY}
  FLG_ADDREG_OVERWRITEONLY  = ($00000020); // Set only if value already exists
  {$EXTERNALSYM FLG_ADDREG_OVERWRITEONLY}
  FLG_ADDREG_TYPE_MASK      = DWORD($FFFF0000 or FLG_ADDREG_BINVALUETYPE);
  {$EXTERNALSYM FLG_ADDREG_TYPE_MASK}
  FLG_ADDREG_TYPE_SZ        = ($00000000);
  {$EXTERNALSYM FLG_ADDREG_TYPE_SZ}
  FLG_ADDREG_TYPE_MULTI_SZ  = ($00010000);
  {$EXTERNALSYM FLG_ADDREG_TYPE_MULTI_SZ}
  FLG_ADDREG_TYPE_EXPAND_SZ = ($00020000);
  {$EXTERNALSYM FLG_ADDREG_TYPE_EXPAND_SZ}
  FLG_ADDREG_TYPE_BINARY    = ($00000000 or FLG_ADDREG_BINVALUETYPE);
  {$EXTERNALSYM FLG_ADDREG_TYPE_BINARY}
  FLG_ADDREG_TYPE_DWORD     = ($00010000 or FLG_ADDREG_BINVALUETYPE);
  {$EXTERNALSYM FLG_ADDREG_TYPE_DWORD}
  FLG_ADDREG_TYPE_NONE      = ($00020000 or FLG_ADDREG_BINVALUETYPE);
  {$EXTERNALSYM FLG_ADDREG_TYPE_NONE}

//
// Flags for BitReg section lines in INF.
//
  FLG_BITREG_CLEARBITS = ($00000000);
  {$EXTERNALSYM FLG_BITREG_CLEARBITS}
  FLG_BITREG_SETBITS   = ($00000001);
  {$EXTERNALSYM FLG_BITREG_SETBITS}

//
// Flags for RegSvr section lines in INF
//
  FLG_REGSVR_DLLREGISTER = ($00000001);
  {$EXTERNALSYM FLG_REGSVR_DLLREGISTER}
  FLG_REGSVR_DLLINSTALL  = ($00000002);
  {$EXTERNALSYM FLG_REGSVR_DLLINSTALL}

// Flags for RegSvr section lines in INF
//
  FLG_PROFITEM_CURRENTUSER = ($00000001);
  {$EXTERNALSYM FLG_PROFITEM_CURRENTUSER}
  FLG_PROFITEM_DELETE      = ($00000002);
  {$EXTERNALSYM FLG_PROFITEM_DELETE}
  FLG_PROFITEM_GROUP       = ($00000004);
  {$EXTERNALSYM FLG_PROFITEM_GROUP}
  FLG_PROFITEM_CSIDL       = ($00000008);
  {$EXTERNALSYM FLG_PROFITEM_CSIDL}

//
// The INF may supply any arbitrary data type ordinal in the highword except
// for the following: REG_NONE, REG_SZ, REG_EXPAND_SZ, REG_MULTI_SZ.  If this
// technique is used, then the data is given in binary format, one byte per
// field.
//

function SetupInstallFromInfSectionA(Owner: HWND; InfHandle: HINF;
  const SectionName: PAnsiChar; Flags: UINT; RelativeKeyRoot: HKEY;
  const SourceRootPath: PAnsiChar; CopyFlags: UINT; MsgHandler: TSPFileCallbackA;
  Context: Pointer; DeviceInfoSet: HDEVINFO; DeviceIn: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFromInfSectionA}
function SetupInstallFromInfSectionW(Owner: HWND; InfHandle: HINF;
  const SectionName: PWideChar; Flags: UINT; RelativeKeyRoot: HKEY;
  const SourceRootPath: PWideChar; CopyFlags: UINT; MsgHandler: TSPFileCallbackW;
  Context: Pointer; DeviceInfoSet: HDEVINFO; DeviceIn: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFromInfSectionW}
function SetupInstallFromInfSection(Owner: HWND; InfHandle: HINF;
  const SectionName: PChar; Flags: UINT; RelativeKeyRoot: HKEY;
  const SourceRootPath: PChar; CopyFlags: UINT; MsgHandler: TSPFileCallbackA;
  Context: Pointer; DeviceInfoSet: HDEVINFO; DeviceIn: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFromInfSection}

//
// Flags for SetupInstallFromInfSection
//
const
  SPINST_LOGCONFIG                = $00000001;
  {$EXTERNALSYM SPINST_LOGCONFIG}
  SPINST_INIFILES                 = $00000002;
  {$EXTERNALSYM SPINST_INIFILES}
  SPINST_REGISTRY                 = $00000004;
  {$EXTERNALSYM SPINST_REGISTRY}
  SPINST_INI2REG                  = $00000008;
  {$EXTERNALSYM SPINST_INI2REG}
  SPINST_FILES                    = $00000010;
  {$EXTERNALSYM SPINST_FILES}
  SPINST_BITREG                   = $00000020;
  {$EXTERNALSYM SPINST_BITREG}
  SPINST_REGSVR                   = $00000040;
  {$EXTERNALSYM SPINST_REGSVR}
  SPINST_UNREGSVR                 = $00000080;
  {$EXTERNALSYM SPINST_UNREGSVR}
  SPINST_PROFILEITEMS             = $00000100;
  {$EXTERNALSYM SPINST_PROFILEITEMS}
  SPINST_ALL                      = $000001ff;
  {$EXTERNALSYM SPINST_ALL}
  SPINST_SINGLESECTION            = $00010000;
  {$EXTERNALSYM SPINST_SINGLESECTION}
  SPINST_LOGCONFIG_IS_FORCED      = $00020000;
  {$EXTERNALSYM SPINST_LOGCONFIG_IS_FORCED}
  SPINST_LOGCONFIGS_ARE_OVERRIDES = $00040000;
  {$EXTERNALSYM SPINST_LOGCONFIGS_ARE_OVERRIDES}

function SetupInstallFilesFromInfSectionA(InfHandle: HINF; LayoutInfHandle: HINF;
  FileQueue: HSPFILEQ; const SectionName, SourceRootPath: PAnsiChar;
  CopyFlags: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFilesFromInfSectionA}
function SetupInstallFilesFromInfSectionW(InfHandle: HINF; LayoutInfHandle: HINF;
  FileQueue: HSPFILEQ; const SectionName, SourceRootPath: PWideChar;
  CopyFlags: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFilesFromInfSectionW}
function SetupInstallFilesFromInfSection(InfHandle: HINF; LayoutInfHandle: HINF;
  FileQueue: HSPFILEQ; const SectionName, SourceRootPath: PChar;
  CopyFlags: UINT): LongBool; stdcall;
{$EXTERNALSYM SetupInstallFilesFromInfSection}

//
// Flags for SetupInstallServicesFromInfSection(Ex).  These flags are also used
// in the flags field of AddService or DelService lines in a device INF.  Some
// of these flags are not permitted in the non-Ex API.  These flags are marked
// as such below.
//

//
// (AddService) move service's tag to front of its group order list
//
const
  SPSVCINST_TAGTOFRONT = ($00000001);
  {$EXTERNALSYM SPSVCINST_TAGTOFRONT}

//
// (AddService) **Ex API only** mark this service as the function driver for the
// device being installed
//
  SPSVCINST_ASSOCSERVICE = ($00000002);
  {$EXTERNALSYM SPSVCINST_ASSOCSERVICE}

//
// (DelService) delete the associated event log entry for a service specified in
// a DelService entry
//
  SPSVCINST_DELETEEVENTLOGENTRY = ($00000004);
  {$EXTERNALSYM SPSVCINST_DELETEEVENTLOGENTRY}

//
// (AddService) don't overwrite display name if it already exists
//
  SPSVCINST_NOCLOBBER_DISPLAYNAME = ($00000008);
  {$EXTERNALSYM SPSVCINST_NOCLOBBER_DISPLAYNAME}

//
// (AddService) don't overwrite start type value if service already exists
//
  SPSVCINST_NOCLOBBER_STARTTYPE = ($00000010);
  {$EXTERNALSYM SPSVCINST_NOCLOBBER_STARTTYPE}

//
// (AddService) don't overwrite error control value if service already exists
//
  SPSVCINST_NOCLOBBER_ERRORCONTROL = ($00000020);
  {$EXTERNALSYM SPSVCINST_NOCLOBBER_ERRORCONTROL}

//
// (AddService) don't overwrite load order group if it already exists
//
  SPSVCINST_NOCLOBBER_LOADORDERGROUP = ($00000040);
  {$EXTERNALSYM SPSVCINST_NOCLOBBER_LOADORDERGROUP}

//
// (AddService) don't overwrite dependencies list if it already exists
//
  SPSVCINST_NOCLOBBER_DEPENDENCIES = ($00000080);
  {$EXTERNALSYM SPSVCINST_NOCLOBBER_DEPENDENCIES}

//
// (AddService) don't overwrite description if it already exists
//
  SPSVCINST_NOCLOBBER_DESCRIPTION = ($00000100);
  {$EXTERNALSYM SPSVCINST_NOCLOBBER_DESCRIPTION}

//
// (DelService) stop the associated service specified in
// a DelService entry before deleting the service
//
  SPSVCINST_STOPSERVICE = ($00000200);
  {$EXTERNALSYM SPSVCINST_STOPSERVICE}

function SetupInstallServicesFromInfSectionA(InfHandle: HINF;
  const SectionName: PAnsiChar; Flags: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupInstallServicesFromInfSectionA}
function SetupInstallServicesFromInfSectionW(InfHandle: HINF;
  const SectionName: PWideChar; Flags: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupInstallServicesFromInfSectionW}
function SetupInstallServicesFromInfSection(InfHandle: HINF;
  const SectionName: PChar; Flags: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupInstallServicesFromInfSection}

function SetupInstallServicesFromInfSectionExA(InfHandle: HINF;
  const SectionName: PAnsiChar; Flags: DWORD; DeviceInfoSet: HDEVINFO;
  DeviceInfoData: TSPDevInfoData; Reserved1, Reserved2: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupInstallServicesFromInfSectionExA}
function SetupInstallServicesFromInfSectionExW(InfHandle: HINF;
  const SectionName: PWideChar; Flags: DWORD; DeviceInfoSet: HDEVINFO;
  DeviceInfoData: TSPDevInfoData; Reserved1, Reserved2: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupInstallServicesFromInfSectionExW}
function SetupInstallServicesFromInfSectionEx(InfHandle: HINF;
  const SectionName: PChar; Flags: DWORD; DeviceInfoSet: HDEVINFO;
  DeviceInfoData: TSPDevInfoData; Reserved1, Reserved2: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupInstallServicesFromInfSectionEx}

//
// Define handle type for Setup file log.
//

type
  HSPFILELOG = Pointer;
  {$EXTERNALSYM HSPFILELOG}

function SetupInitializeFileLogA(const LogFileName: PAnsiChar; Flags: DWORD): HSPFILELOG; stdcall;
{$EXTERNALSYM SetupInitializeFileLogA}
function SetupInitializeFileLogW(const LogFileName: PWideChar; Flags: DWORD): HSPFILELOG; stdcall;
{$EXTERNALSYM SetupInitializeFileLogW}
function SetupInitializeFileLog(const LogFileName: PChar; Flags: DWORD): HSPFILELOG; stdcall;
{$EXTERNALSYM SetupInitializeFileLog}

//
// Flags for SetupInitializeFileLog
//
const
  SPFILELOG_SYSTEMLOG = $00000001; // use system log -- must be Administrator
  {$EXTERNALSYM SPFILELOG_SYSTEMLOG}
  SPFILELOG_FORCENEW  = $00000002; // not valid with SPFILELOG_SYSTEMLOG
  {$EXTERNALSYM SPFILELOG_FORCENEW}
  SPFILELOG_QUERYONLY = $00000004; // allows non-administrators to read system log
  {$EXTERNALSYM SPFILELOG_QUERYONLY}

function SetupTerminateFileLog(FileLogHandle: HSPFILELOG): LongBool; stdcall;
{$EXTERNALSYM SetupTerminateFileLog}

function SetupLogFileA(FileLogHandle: HSPFILELOG; const LogSectionName,
  SourceFilename, TargetFilename: PAnsiChar; Checksum: DWORD; DiskTagfile,
  DiskDescription, OtherInfo: PAnsiChar; Flags: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupLogFileA}
function SetupLogFileW(FileLogHandle: HSPFILELOG; const LogSectionName,
  SourceFilename, TargetFilename: PWideChar; Checksum: DWORD; DiskTagfile,
  DiskDescription, OtherInfo: PWideChar; Flags: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupLogFileW}
function SetupLogFile(FileLogHandle: HSPFILELOG; const LogSectionName,
  SourceFilename, TargetFilename: PChar; Checksum: DWORD; DiskTagfile,
  DiskDescription, OtherInfo: PChar; Flags: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupLogFile}

//
// Flags for SetupLogFile
//
const
  SPFILELOG_OEMFILE = $00000001;
  {$EXTERNALSYM SPFILELOG_OEMFILE}

function SetupRemoveFileLogEntryA(FileLogHandle: HSPFILELOG;
  const LogSectionName: PAnsiChar; const TargetFilename: PAnsiChar): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveFileLogEntryA}
function SetupRemoveFileLogEntryW(FileLogHandle: HSPFILELOG;
  const LogSectionName: PWideChar; const TargetFilename: PWideChar): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveFileLogEntryW}
function SetupRemoveFileLogEntry(FileLogHandle: HSPFILELOG;
  const LogSectionName: PChar; const TargetFilename: PChar): LongBool; stdcall;
{$EXTERNALSYM SetupRemoveFileLogEntry}

//
// Items retrievable from SetupQueryFileLog()
//

const
  SetupFileLogSourceFilename  = $00000000;
  {$EXTERNALSYM SetupFileLogSourceFilename}
  SetupFileLogChecksum        = $00000001;
  {$EXTERNALSYM SetupFileLogChecksum}
  SetupFileLogDiskTagfile     = $00000002;
  {$EXTERNALSYM SetupFileLogDiskTagfile}
  SetupFileLogDiskDescription = $00000003;
  {$EXTERNALSYM SetupFileLogDiskDescription}
  SetupFileLogOtherInfo       = $00000004;
  {$EXTERNALSYM SetupFileLogOtherInfo}
  SetupFileLogMax             = $00000005;
  {$EXTERNALSYM SetupFileLogMax}
type
  SetupFileLogInfo = DWORD;
  {$EXTERNALSYM SetupFileLogInfo}

function SetupQueryFileLogA(FileLogHandle: HSPFILELOG; const LogSectionName,
  TargetFilename: PAnsiChar; DesiredInfo: SETUPFILELOGINFO; DataOut: PAnsiChar;
  ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryFileLogA}
function SetupQueryFileLogW(FileLogHandle: HSPFILELOG; const LogSectionName,
  TargetFilename: PWideChar; DesiredInfo: SETUPFILELOGINFO; DataOut: PWideChar;
  ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryFileLogW}
function SetupQueryFileLog(FileLogHandle: HSPFILELOG; const LogSectionName,
  TargetFilename: PChar; DesiredInfo: SETUPFILELOGINFO; DataOut: PChar;
  ReturnBufferSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupQueryFileLog}

//
// Text logging APIs
//

type
  LogSeverity = DWORD;
  {$EXTERNALSYM LogSeverity}

const
  LogSevInformation = $00000000;
  {$EXTERNALSYM LogSevInformation}
  LogSevWarning     = $00000001;
  {$EXTERNALSYM LogSevWarning}
  LogSevError       = $00000002;
  {$EXTERNALSYM LogSevError}
  LogSevFatalError  = $00000003;
  {$EXTERNALSYM LogSevFatalError}
  LogSevMaximum     = $00000004;
  {$EXTERNALSYM LogSevMaximum}

function SetupOpenLog(Erase: LongBool): LongBool; stdcall;
{$EXTERNALSYM SetupOpenLog}

function SetupLogErrorA(const MessageString: PAnsiChar; Severity: LOGSEVERITY): LongBool; stdcall;
{$EXTERNALSYM SetupLogErrorA}
function SetupLogErrorW(const MessageString: PWideChar; Severity: LOGSEVERITY): LongBool; stdcall;
{$EXTERNALSYM SetupLogErrorW}
function SetupLogError(const MessageString: PChar; Severity: LOGSEVERITY): LongBool; stdcall;
{$EXTERNALSYM SetupLogError}

procedure SetupCloseLog; stdcall;
{$EXTERNALSYM SetupCloseLog}

//
// Backup Information API
//

function SetupGetBackupInformationA(QueueHandle: HSPFILEQ;
  var BackupParams: TSPBackupQueueParamsA): LongBool; stdcall;
{$EXTERNALSYM SetupGetBackupInformationA}
function SetupGetBackupInformationW(QueueHandle: HSPFILEQ;
  var BackupParams: TSPBackupQueueParamsW): LongBool; stdcall;
{$EXTERNALSYM SetupGetBackupInformationW}
function SetupGetBackupInformation(QueueHandle: HSPFILEQ;
  var BackupParams: TSPBackupQueueParamsA): LongBool; stdcall;
{$EXTERNALSYM SetupGetBackupInformation}

//
// Device Installer APIs
//

function SetupDiCreateDeviceInfoList(ClassGuid: PGUID; hwndParent: HWND): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInfoList}

function SetupDiCreateDeviceInfoListExA(ClassGuid: PGUID; hwndParent: HWND;
  const MachineName: PAnsiChar; Reserved: Pointer): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInfoListExA}
function SetupDiCreateDeviceInfoListExW(ClassGuid: PGUID; hwndParent: HWND;
  const MachineName: PWideChar; Reserved: Pointer): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInfoListExW}
function SetupDiCreateDeviceInfoListEx(ClassGuid: PGUID; hwndParent: HWND;
  const MachineName: PChar; Reserved: Pointer): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInfoListEx}

function SetupDiGetDeviceInfoListClass(DeviceInfoSet: HDEVINFO;
  var ClassGuid: TGUID): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInfoListClass}

function SetupDiGetDeviceInfoListDetailA(DeviceInfoSet: HDEVINFO;
  var DeviceInfoSetDetailData: TSPDevInfoListDetailDataA): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInfoListDetailA}
function SetupDiGetDeviceInfoListDetailW(DeviceInfoSet: HDEVINFO;
  var DeviceInfoSetDetailData: TSPDevInfoListDetailDataW): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInfoListDetailW}
function SetupDiGetDeviceInfoListDetail(DeviceInfoSet: HDEVINFO;
  var DeviceInfoSetDetailData: TSPDevInfoListDetailDataA): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInfoListDetail}

//
// Flags for SetupDiCreateDeviceInfo
//
const
  DICD_GENERATE_ID       = $00000001;
  {$EXTERNALSYM DICD_GENERATE_ID}
  DICD_INHERIT_CLASSDRVS = $00000002;
  {$EXTERNALSYM DICD_INHERIT_CLASSDRVS}

function SetupDiCreateDeviceInfoA(DeviceInfoSet: HDEVINFO; const DeviceName: PAnsiChar;
  var ClassGuid: TGUID; const DeviceDescription: PAnsiChar; hwndParent: HWND;
  CreationFlags: DWORD; DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInfoA}

function SetupDiCreateDeviceInfoW(DeviceInfoSet: HDEVINFO; const DeviceName: PWideChar;
  var ClassGuid: TGUID; const DeviceDescription: PWideChar; hwndParent: HWND;
  CreationFlags: DWORD; DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInfoW}

function SetupDiCreateDeviceInfo(DeviceInfoSet: HDEVINFO; const DeviceName: PChar;
  var ClassGuid: TGUID; const DeviceDescription: PChar; hwndParent: HWND;
  CreationFlags: DWORD; DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInfo}


//
// Flags for SetupDiOpenDeviceInfo
//
const
  DIOD_INHERIT_CLASSDRVS = $00000002;
  {$EXTERNALSYM DIOD_INHERIT_CLASSDRVS}
  DIOD_CANCEL_REMOVE     = $00000004;
  {$EXTERNALSYM DIOD_CANCEL_REMOVE}

function SetupDiOpenDeviceInfoA(DeviceInfoSet: HDEVINFO;
  const DeviceInstanceId: PAnsiChar; hwndParent: HWND; OpenFlags: DWORD;
  DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiOpenDeviceInfoA}
function SetupDiOpenDeviceInfoW(DeviceInfoSet: HDEVINFO;
  const DeviceInstanceId: PWideChar; hwndParent: HWND; OpenFlags: DWORD;
  DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiOpenDeviceInfoW}
function SetupDiOpenDeviceInfo(DeviceInfoSet: HDEVINFO;
  const DeviceInstanceId: PChar; hwndParent: HWND; OpenFlags: DWORD;
  DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiOpenDeviceInfo}

function SetupDiGetDeviceInstanceIdA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DeviceInstanceId: PAnsiChar;
  DeviceInstanceIdSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInstanceIdA}
function SetupDiGetDeviceInstanceIdW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DeviceInstanceId: PWideChar;
  DeviceInstanceIdSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInstanceIdW}
function SetupDiGetDeviceInstanceId(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DeviceInstanceId: PChar;
  DeviceInstanceIdSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInstanceId}

function SetupDiDeleteDeviceInfo(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiDeleteDeviceInfo}

function SetupDiEnumDeviceInfo(DeviceInfoSet: HDEVINFO;
  MemberIndex: DWORD; var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiEnumDeviceInfo}

function SetupDiDestroyDeviceInfoList(DeviceInfoSet: HDEVINFO): LongBool; stdcall;
{$EXTERNALSYM SetupDiDestroyDeviceInfoList}

function SetupDiEnumDeviceInterfaces(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var InterfaceClassGuid: TGUID;
  MemberIndex: DWORD; var DeviceInterfaceData: TSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiEnumDeviceInterfaces}

//
// Backward compatibility--do not use
//

function SetupDiEnumInterfaceDevice(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var InterfaceClassGuid: TGUID;
  MemberIndex: DWORD; var DeviceInterfaceData: TSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiEnumDeviceInterfaces}

function SetupDiCreateDeviceInterfaceA(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; var InterfaceClassGuid: TGUID;
  const ReferenceString: PAnsiChar; CreationFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInterfaceA}
function SetupDiCreateDeviceInterfaceW(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; var InterfaceClassGuid: TGUID;
  const ReferenceString: PWideChar; CreationFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInterfaceW}
function SetupDiCreateDeviceInterface(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; var InterfaceClassGuid: TGUID;
  const ReferenceString: PChar; CreationFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInterface}

//
// Backward compatibility--do not use.
//

function SetupDiCreateInterfaceDeviceA(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; var InterfaceClassGuid: TGUID;
  const ReferenceString: PAnsiChar; CreationFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiCreateInterfaceDeviceA}
function SetupDiCreateInterfaceDeviceW(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; var InterfaceClassGuid: TGUID;
  const ReferenceString: PWideChar; CreationFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiCreateInterfaceDeviceW}
function SetupDiCreateInterfaceDevice(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; var InterfaceClassGuid: TGUID;
  const ReferenceString: PChar; CreationFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiCreateInterfaceDevice}

//
// Flags for SetupDiOpenDeviceInterface
//
const
  DIODI_NO_ADD = $00000001;
  {$EXTERNALSYM DIODI_NO_ADD}

function SetupDiOpenDeviceInterfaceA(DeviceInfoSet: HDEVINFO;
  const DevicePath: PAnsiChar; OpenFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiOpenDeviceInterfaceA}
function SetupDiOpenDeviceInterfaceW(DeviceInfoSet: HDEVINFO;
  const DevicePath: PWideChar; OpenFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiOpenDeviceInterfaceW}
function SetupDiOpenDeviceInterface(DeviceInfoSet: HDEVINFO;
  const DevicePath: PChar; OpenFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiOpenDeviceInterface}

//
// Backward compatibility--do not use
//

function SetupDiOpenInterfaceDeviceA(DeviceInfoSet: HDEVINFO;
  const DevicePath: PAnsiChar; OpenFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiOpenInterfaceDeviceA}
function SetupDiOpenInterfaceDeviceW(DeviceInfoSet: HDEVINFO;
  const DevicePath: PWideChar; OpenFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiOpenInterfaceDeviceW}
function SetupDiOpenInterfaceDevice(DeviceInfoSet: HDEVINFO;
  const DevicePath: PChar; OpenFlags: DWORD;
  DeviceInterfaceData: PSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiOpenInterfaceDevice}

function SetupDiGetDeviceInterfaceAlias(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; var AliasInterfaceClassGuid: TGUID;
  var AliasDeviceInterfaceData: TSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInterfaceAlias}

//
// Backward compatibility--do not use.
//

function SetupDiGetInterfaceDeviceAlias(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData;
  var AliasInterfaceClassGuid: TGUID;
  var AliasDeviceInterfaceData: TSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetInterfaceDeviceAlias}

function SetupDiDeleteDeviceInterfaceData(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiDeleteDeviceInterfaceData}

//
// Backward compatibility--do not use.
//

function SetupDiDeleteInterfaceDeviceData(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiDeleteInterfaceDeviceData}

function SetupDiRemoveDeviceInterface(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiRemoveDeviceInterface}

//
// Backward compatibility--do not use.
//

function SetupDiRemoveInterfaceDevice(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData): LongBool; stdcall;
{$EXTERNALSYM SetupDiRemoveInterfaceDevice}

function SetupDiGetDeviceInterfaceDetailA(DeviceInfoSet: HDEVINFO;
  DeviceInterfaceData: PSPDeviceInterfaceData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailDataA;
  DeviceInterfaceDetailDataSize: DWORD; RequiredSize: PDWORD;
  Device: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInterfaceDetailA}
function SetupDiGetDeviceInterfaceDetailW(DeviceInfoSet: HDEVINFO;
  DeviceInterfaceData: PSPDeviceInterfaceData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailDataW;
  DeviceInterfaceDetailDataSize: DWORD; RequiredSize: PDWORD;
  Device: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInterfaceDetailW}
function SetupDiGetDeviceInterfaceDetail(DeviceInfoSet: HDEVINFO;
  DeviceInterfaceData: PSPDeviceInterfaceData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailDataA;
  DeviceInterfaceDetailDataSize: DWORD; RequiredSize: PDWORD;
  Device: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInterfaceDetail}

//
// Backward compatibility--do not use.
//

function SetupDiGetInterfaceDeviceDetailA(DeviceInfoSet: HDEVINFO;
  DeviceInterfaceData: PSPDeviceInterfaceData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailDataA;
  DeviceInterfaceDetailDataSize: DWORD; RequiredSize: PDWORD;
  Device: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetInterfaceDeviceDetailA}
function SetupDiGetInterfaceDeviceDetailW(DeviceInfoSet: HDEVINFO;
  DeviceInterfaceData: PSPDeviceInterfaceData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailDataW;
  DeviceInterfaceDetailDataSize: DWORD; RequiredSize: PDWORD;
  Device: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetInterfaceDeviceDetailW}
function SetupDiGetInterfaceDeviceDetail(DeviceInfoSet: HDEVINFO;
  DeviceInterfaceData: PSPDeviceInterfaceData;
  DeviceInterfaceDetailData: PSPDeviceInterfaceDetailDataA;
  DeviceInterfaceDetailDataSize: DWORD; RequiredSize: PDWORD;
  Device: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetInterfaceDeviceDetail}

//
// Default install handler for DIF_INSTALLINTERFACES.
//

function SetupDiInstallDeviceInterfaces(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiInstallDeviceInterfaces}

//
// Backward compatibility--do not use.
//

function SetupDiInstallInterfaceDevices(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiInstallInterfaceDevices}

//
// Default install handler for DIF_REGISTERDEVICE
//

//
// Flags for SetupDiRegisterDeviceInfo
//
const
  SPRDI_FIND_DUPS = $00000001;
  {$EXTERNALSYM SPRDI_FIND_DUPS}

function SetupDiRegisterDeviceInfo(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Flags: DWORD; CompareProc: TSPDetSigCmpProc;
  CompareContext: Pointer; DupDeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiRegisterDeviceInfo}

//
// Ordinal values distinguishing between class drivers and
// device drivers.
// (Passed in 'DriverType' parameter of driver information list APIs)
//
const
  SPDIT_NODRIVER     = $00000000;
  {$EXTERNALSYM SPDIT_NODRIVER}
  SPDIT_CLASSDRIVER  = $00000001;
  {$EXTERNALSYM SPDIT_CLASSDRIVER}
  SPDIT_COMPATDRIVER = $00000002;
  {$EXTERNALSYM SPDIT_COMPATDRIVER}

function SetupDiBuildDriverInfoList(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DriverType: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiBuildDriverInfoList}

function SetupDiCancelDriverInfoSearch(DeviceInfoSet: HDEVINFO): LongBool; stdcall;
{$EXTERNALSYM SetupDiCancelDriverInfoSearch}

function SetupDiEnumDriverInfoA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DriverType: DWORD; MemberIndex: DWORD;
  var DriverInfoData: TSPDrvInfoDataA): LongBool; stdcall;
{$EXTERNALSYM SetupDiEnumDriverInfoA}
function SetupDiEnumDriverInfoW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DriverType: DWORD; MemberIndex: DWORD;
  var DriverInfoData: TSPDrvInfoDataW): LongBool; stdcall;
{$EXTERNALSYM SetupDiEnumDriverInfoW}
function SetupDiEnumDriverInfo(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DriverType: DWORD; MemberIndex: DWORD;
  var DriverInfoData: TSPDrvInfoDataA): LongBool; stdcall;
{$EXTERNALSYM SetupDiEnumDriverInfo}

function SetupDiGetSelectedDriverA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataA): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetSelectedDriverA}
function SetupDiGetSelectedDriverW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataW): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetSelectedDriverW}
function SetupDiGetSelectedDriver(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataA): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetSelectedDriver}

function SetupDiSetSelectedDriverA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DriverInfoData: PSPDrvInfoDataA): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetSelectedDriverA}
function SetupDiSetSelectedDriverW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DriverInfoData: PSPDrvInfoDataW): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetSelectedDriverW}
function SetupDiSetSelectedDriver(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DriverInfoData: PSPDrvInfoDataA): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetSelectedDriver}

function SetupDiGetDriverInfoDetailA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataA;
  DriverInfoDetailData: PSPDrvInfoDetailDataA; DriverInfoDetailDataSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDriverInfoDetailA}
function SetupDiGetDriverInfoDetailW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataW;
  DriverInfoDetailData: PSPDrvInfoDetailDataW; DriverInfoDetailDataSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDriverInfoDetailW}
function SetupDiGetDriverInfoDetail(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataA;
  DriverInfoDetailData: PSPDrvInfoDetailDataA; DriverInfoDetailDataSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDriverInfoDetail}

function SetupDiDestroyDriverInfoList(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; DriverType: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiDestroyDriverInfoList}

//
// Flags controlling what is included in the device information set built
// by SetupDiGetClassDevs
//
const
  DIGCF_DEFAULT         = $00000001; // only valid with DIGCF_DEVICEINTERFACE
  {$EXTERNALSYM DIGCF_DEFAULT}
  DIGCF_PRESENT         = $00000002;
  {$EXTERNALSYM DIGCF_PRESENT}
  DIGCF_ALLCLASSES      = $00000004;
  {$EXTERNALSYM DIGCF_ALLCLASSES}
  DIGCF_PROFILE         = $00000008;
  {$EXTERNALSYM DIGCF_PROFILE}
  DIGCF_DEVICEINTERFACE = $00000010;
  {$EXTERNALSYM DIGCF_DEVICEINTERFACE}

//
// Backward compatibility--do not use.
//

const
  DIGCF_INTERFACEDEVICE = DIGCF_DEVICEINTERFACE;
{$EXTERNALSYM DIGCF_INTERFACEDEVICE}

function SetupDiGetClassDevsA(ClassGuid: PGUID; const Enumerator: PAnsiChar;
  hwndParent: HWND; Flags: DWORD): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiGetClassDevsA}
function SetupDiGetClassDevsW(ClassGuid: PGUID; const Enumerator: PWideChar;
  hwndParent: HWND; Flags: DWORD): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiGetClassDevsW}
function SetupDiGetClassDevs(ClassGuid: PGUID; const Enumerator: PChar;
  hwndParent: HWND; Flags: DWORD): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiGetClassDevs}

function SetupDiGetClassDevsExA(ClassGuid: PGUID; const Enumerator: PAnsiChar;
  hwndParent: HWND; Flags: DWORD; DeviceInfoSet: HDEVINFO; const MachineName: PAnsiChar;
  Reserved: Pointer): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiGetClassDevsExA}
function SetupDiGetClassDevsExW(ClassGuid: PGUID; const Enumerator: PWideChar;
  hwndParent: HWND; Flags: DWORD; DeviceInfoSet: HDEVINFO; const MachineName: PWideChar;
  Reserved: Pointer): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiGetClassDevsExW}
function SetupDiGetClassDevsEx(ClassGuid: PGUID; const Enumerator: PChar;
  hwndParent: HWND; Flags: DWORD; DeviceInfoSet: HDEVINFO; const MachineName: PChar;
  Reserved: Pointer): HDEVINFO; stdcall;
{$EXTERNALSYM SetupDiGetClassDevsEx}

function SetupDiGetINFClassA(const InfName: PAnsiChar; var ClassGuid: TGUID;
  ClassName: PAnsiChar; ClassNameSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetINFClassA}
function SetupDiGetINFClassW(const InfName: PWideChar; var ClassGuid: TGUID;
  ClassName: PWideChar; ClassNameSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetINFClassW}
function SetupDiGetINFClass(const InfName: PChar; var ClassGuid: TGUID;
  ClassName: PChar; ClassNameSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetINFClass}

//
// Flags controlling exclusion from the class information list built
// by SetupDiBuildClassInfoList(Ex)
//
const
  DIBCI_NOINSTALLCLASS = $00000001;
  {$EXTERNALSYM DIBCI_NOINSTALLCLASS}
  DIBCI_NODISPLAYCLASS = $00000002;
  {$EXTERNALSYM DIBCI_NODISPLAYCLASS}

function SetupDiBuildClassInfoList(Flags: DWORD; ClassGuidList: PGUID;
  ClassGuidListSize: DWORD; var RequiredSize: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiBuildClassInfoList}

function SetupDiBuildClassInfoListExA(Flags: DWORD; ClassGuidList: PGUID;
  ClassGuidListSize: DWORD; var RequiredSize: DWORD; const MachineName: PAnsiChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiBuildClassInfoListExA}
function SetupDiBuildClassInfoListExW(Flags: DWORD; ClassGuidList: PGUID;
  ClassGuidListSize: DWORD; var RequiredSize: DWORD; const MachineName: PWideChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiBuildClassInfoListExW}
function SetupDiBuildClassInfoListEx(Flags: DWORD; ClassGuidList: PGUID;
  ClassGuidListSize: DWORD; var RequiredSize: DWORD; const MachineName: PChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiBuildClassInfoListEx}

function SetupDiGetClassDescriptionA(var ClassGuid: TGUID; ClassDescription: PAnsiChar;
  ClassDescriptionSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassDescriptionA}
function SetupDiGetClassDescriptionW(var ClassGuid: TGUID; ClassDescription: PWideChar;
  ClassDescriptionSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassDescriptionW}
function SetupDiGetClassDescription(var ClassGuid: TGUID; ClassDescription: PChar;
  ClassDescriptionSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassDescription}

function SetupDiGetClassDescriptionExA(var ClassGuid: TGUID;
  ClassDescription: PAnsiChar; ClassDescriptionSize: DWORD; RequiredSize: PDWORD;
  const MachineName: PAnsiChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassDescriptionExA}
function SetupDiGetClassDescriptionExW(var ClassGuid: TGUID;
  ClassDescription: PWideChar; ClassDescriptionSize: DWORD; RequiredSize: PDWORD;
  const MachineName: PWideChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassDescriptionExW}
function SetupDiGetClassDescriptionEx(var ClassGuid: TGUID;
  ClassDescription: PChar; ClassDescriptionSize: DWORD; RequiredSize: PDWORD;
  const MachineName: PChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassDescriptionEx}

function SetupDiCallClassInstaller(InstallFunction: DI_FUNCTION;
  DeviceInfoSet: HDEVINFO; DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiCallClassInstaller}

//
// Default install handler for DIF_SELECTDEVICE
//

function SetupDiSelectDevice(DeviceInfoSet:  HDEVINFO;
  DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiSelectDevice}

//
// Default install handler for DIF_SELECTBESTCOMPATDRV
//

function SetupDiSelectBestCompatDrv(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiSelectBestCompatDrv}

//
// Default install handler for DIF_INSTALLDEVICE
//
function SetupDiInstallDevice(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiInstallDevice}

//
// Default install handler for DIF_INSTALLDEVICEFILES
//

function SetupDiInstallDriverFiles(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiInstallDriverFiles}

//
// Default install handler for DIF_REGISTER_COINSTALLERS
//
function SetupDiRegisterCoDeviceInstallers(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiRegisterCoDeviceInstallers}

//
// Default install handler for DIF_REMOVE
//

function SetupDiRemoveDevice(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiRemoveDevice}

//
// Default install handler for DIF_UNREMOVE
//

function SetupDiUnremoveDevice(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiUnremoveDevice}

//
// Default install handler for DIF_MOVEDEVICE
//
function SetupDiMoveDuplicateDevice(DeviceInfoSet: HDEVINFO;
  var DestinationDeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiMoveDuplicateDevice}

//
// Default install handler for DIF_PROPERTYCHANGE
//
function SetupDiChangeState(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiChangeState}

function SetupDiInstallClassA(hwndParent: HWND; const InfFileName: PAnsiChar;
  Flags: DWORD; FileQueue: HSPFILEQ): LongBool; stdcall;
{$EXTERNALSYM SetupDiInstallClassA}
function SetupDiInstallClassW(hwndParent: HWND; const InfFileName: PWideChar;
  Flags: DWORD; FileQueue: HSPFILEQ): LongBool; stdcall;
{$EXTERNALSYM SetupDiInstallClassW}
function SetupDiInstallClass(hwndParent: HWND; const InfFileName: PChar;
  Flags: DWORD; FileQueue: HSPFILEQ): LongBool; stdcall;
{$EXTERNALSYM SetupDiInstallClass}

function SetupDiInstallClassExA(hwndParent: HWND; const InfFileName: PAnsiChar;
  Flags: DWORD; FileQueue: HSPFILEQ; InterfaceClassGuid: PGUID; Reserved1,
  Reserved2: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiInstallClassExA}
function SetupDiInstallClassExW(hwndParent: HWND; const InfFileName: PWideChar;
  Flags: DWORD; FileQueue: HSPFILEQ; InterfaceClassGuid: PGUID; Reserved1,
  Reserved2: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiInstallClassExW}
function SetupDiInstallClassEx(hwndParent: HWND; const InfFileName: PChar;
  Flags: DWORD; FileQueue: HSPFILEQ; InterfaceClassGuid: PGUID; Reserved1,
  Reserved2: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiInstallClassEx}

function SetupDiOpenClassRegKey(ClassGuid: PGUID; samDesired: REGSAM): HKEY; stdcall;
{$EXTERNALSYM SetupDiOpenClassRegKey}

//
// Flags for SetupDiOpenClassRegKeyEx
//
const
  DIOCR_INSTALLER = $00000001; // class installer registry branch
  {$EXTERNALSYM DIOCR_INSTALLER}
  DIOCR_INTERFACE = $00000002; // interface class registry branch
  {$EXTERNALSYM DIOCR_INTERFACE}

function SetupDiOpenClassRegKeyExA(ClassGuid: PGUID; samDesired: REGSAM;
  Flags: DWORD; const MachineName: PAnsiChar; Reserved: Pointer): HKEY; stdcall;
{$EXTERNALSYM SetupDiOpenClassRegKeyExA}
function SetupDiOpenClassRegKeyExW(ClassGuid: PGUID; samDesired: REGSAM;
  Flags: DWORD; const MachineName: PWideChar; Reserved: Pointer): HKEY; stdcall;
{$EXTERNALSYM SetupDiOpenClassRegKeyExW}
function SetupDiOpenClassRegKeyEx(ClassGuid: PGUID; samDesired: REGSAM;
  Flags: DWORD; const MachineName: PChar; Reserved: Pointer): HKEY; stdcall;
{$EXTERNALSYM SetupDiOpenClassRegKeyEx}

function SetupDiCreateDeviceInterfaceRegKeyA(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; Reserved: DWORD;
  samDesired: REGSAM; InfHandle: HINF; const InfSectionName: PAnsiChar): HKEY; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInterfaceRegKeyA}
function SetupDiCreateDeviceInterfaceRegKeyW(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; Reserved: DWORD;
  samDesired: REGSAM; InfHandle: HINF; const InfSectionName: PWideChar): HKEY; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInterfaceRegKeyW}
function SetupDiCreateDeviceInterfaceRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; Reserved: DWORD;
  samDesired: REGSAM; InfHandle: HINF; const InfSectionName: PChar): HKEY; stdcall;
{$EXTERNALSYM SetupDiCreateDeviceInterfaceRegKey}

//
// Backward compatibility--do not use.
//

function SetupDiCreateInterfaceDeviceRegKeyA(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; Reserved: DWORD;
  samDesired: REGSAM; InfHandle: HINF; const InfSectionName: PAnsiChar): HKEY; stdcall;
{$EXTERNALSYM SetupDiCreateInterfaceDeviceRegKeyA}
function SetupDiCreateInterfaceDeviceRegKeyW(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; Reserved: DWORD;
  samDesired: REGSAM; InfHandle: HINF; const InfSectionName: PWideChar): HKEY; stdcall;
{$EXTERNALSYM SetupDiCreateInterfaceDeviceRegKeyW}
function SetupDiCreateInterfaceDeviceRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; Reserved: DWORD;
  samDesired: REGSAM; InfHandle: HINF; const InfSectionName: PChar): HKEY; stdcall;
{$EXTERNALSYM SetupDiCreateInterfaceDeviceRegKey}

function SetupDiOpenDeviceInterfaceRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; Reserved: DWORD;
  samDesired: REGSAM): HKEY; stdcall;
{$EXTERNALSYM SetupDiOpenDeviceInterfaceRegKey}

//
// Backward compatibility--do not use.
//

function SetupDiOpenInterfaceDeviceRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; Reserved: DWORD;
  samDesired: REGSAM): HKEY; stdcall;
{$EXTERNALSYM SetupDiOpenInterfaceDeviceRegKey}

function SetupDiDeleteDeviceInterfaceRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; Reserved: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiDeleteDeviceInterfaceRegKey}

//
// Backward compatibility--do not use.
//

function SetupDiDeleteInterfaceDeviceRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInterfaceData: TSPDeviceInterfaceData; Reserved: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiDeleteInterfaceDeviceRegKey}

//
// KeyType values for SetupDiCreateDevRegKey, SetupDiOpenDevRegKey, and
// SetupDiDeleteDevRegKey.
//
const
  DIREG_DEV  = $00000001; // Open/Create/Delete device key
  {$EXTERNALSYM DIREG_DEV}
  DIREG_DRV  = $00000002; // Open/Create/Delete driver key
  {$EXTERNALSYM DIREG_DRV}
  DIREG_BOTH = $00000004; // Delete both driver and Device key
  {$EXTERNALSYM DIREG_BOTH}

function SetupDiCreateDevRegKeyA(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Scope, HwProfile, KeyType: DWORD;
  InfHandle: HINF; const InfSectionName: PAnsiChar): HKEY; stdcall;
{$EXTERNALSYM SetupDiCreateDevRegKeyA}

function SetupDiCreateDevRegKeyW(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Scope, HwProfile, KeyType: DWORD;
  InfHandle: HINF; const InfSectionName: PWideChar): HKEY; stdcall;
{$EXTERNALSYM SetupDiCreateDevRegKeyW}

function SetupDiCreateDevRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Scope, HwProfile, KeyType: DWORD;
  InfHandle: HINF; const InfSectionName: PChar): HKEY; stdcall;
{$EXTERNALSYM SetupDiCreateDevRegKey}


function SetupDiOpenDevRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Scope, HwProfile, KeyType: DWORD;
  samDesired: REGSAM): HKEY; stdcall;
{$EXTERNALSYM SetupDiOpenDevRegKey}

function SetupDiDeleteDevRegKey(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Scope, HwProfile,
  KeyType: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiDeleteDevRegKey}

function SetupDiGetHwProfileList(HwProfileList: PDWORD; HwProfileListSize: DWORD;
  var RequiredSize: DWORD; CurrentlyActiveIndex: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetHwProfileList}

function SetupDiGetHwProfileListExA(HwProfileList: PDWORD;
  HwProfileListSize: DWORD; var RequiredSize: DWORD; CurrentlyActiveIndex: PDWORD;
  const MachineName: PAnsiChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetHwProfileListExA}
function SetupDiGetHwProfileListExW(HwProfileList: PDWORD;
  HwProfileListSize: DWORD; var RequiredSize: DWORD; CurrentlyActiveIndex: PDWORD;
  const MachineName: PWideChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetHwProfileListExW}
function SetupDiGetHwProfileListEx(HwProfileList: PDWORD;
  HwProfileListSize: DWORD; var RequiredSize: DWORD; CurrentlyActiveIndex: PDWORD;
  const MachineName: PChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetHwProfileListEx}

//
// Device registry property codes
// (Codes marked as read-only (R) may only be used for
// SetupDiGetDeviceRegistryProperty)
//
// These values should cover the same set of registry properties
// as defined by the CM_DRP codes in cfgmgr32.h.
//
const
  SPDRP_DEVICEDESC                  = $00000000; // DeviceDesc (R/W)
  {$EXTERNALSYM SPDRP_DEVICEDESC}
  SPDRP_HARDWAREID                  = $00000001; // HardwareID (R/W)
  {$EXTERNALSYM SPDRP_HARDWAREID}
  SPDRP_COMPATIBLEIDS               = $00000002; // CompatibleIDs (R/W)
  {$EXTERNALSYM SPDRP_COMPATIBLEIDS}
  SPDRP_UNUSED0                     = $00000003; // unused
  {$EXTERNALSYM SPDRP_UNUSED0}
  SPDRP_SERVICE                     = $00000004; // Service (R/W)
  {$EXTERNALSYM SPDRP_SERVICE}
  SPDRP_UNUSED1                     = $00000005; // unused
  {$EXTERNALSYM SPDRP_UNUSED1}
  SPDRP_UNUSED2                     = $00000006; // unused
  {$EXTERNALSYM SPDRP_UNUSED2}
  SPDRP_CLASS                       = $00000007; // Class (R--tied to ClassGUID)
  {$EXTERNALSYM SPDRP_CLASS}
  SPDRP_CLASSGUID                   = $00000008; // ClassGUID (R/W)
  {$EXTERNALSYM SPDRP_CLASSGUID}
  SPDRP_DRIVER                      = $00000009; // Driver (R/W)
  {$EXTERNALSYM SPDRP_DRIVER}
  SPDRP_CONFIGFLAGS                 = $0000000A; // ConfigFlags (R/W)
  {$EXTERNALSYM SPDRP_CONFIGFLAGS}
  SPDRP_MFG                         = $0000000B; // Mfg (R/W)
  {$EXTERNALSYM SPDRP_MFG}
  SPDRP_FRIENDLYNAME                = $0000000C; // FriendlyName (R/W)
  {$EXTERNALSYM SPDRP_FRIENDLYNAME}
  SPDRP_LOCATION_INFORMATION        = $0000000D; // LocationInformation (R/W)
  {$EXTERNALSYM SPDRP_LOCATION_INFORMATION}
  SPDRP_PHYSICAL_DEVICE_OBJECT_NAME = $0000000E; // PhysicalDeviceObjectName (R)
  {$EXTERNALSYM SPDRP_PHYSICAL_DEVICE_OBJECT_NAME}
  SPDRP_CAPABILITIES                = $0000000F; // Capabilities (R)
  {$EXTERNALSYM SPDRP_CAPABILITIES}
  SPDRP_UI_NUMBER                   = $00000010; // UiNumber (R)
  {$EXTERNALSYM SPDRP_UI_NUMBER}
  SPDRP_UPPERFILTERS                = $00000011; // UpperFilters (R/W)
  {$EXTERNALSYM SPDRP_UPPERFILTERS}
  SPDRP_LOWERFILTERS                = $00000012; // LowerFilters (R/W)
  {$EXTERNALSYM SPDRP_LOWERFILTERS}
  SPDRP_BUSTYPEGUID                 = $00000013; // BusTypeGUID (R)
  {$EXTERNALSYM SPDRP_BUSTYPEGUID}
  SPDRP_LEGACYBUSTYPE               = $00000014; // LegacyBusType (R)
  {$EXTERNALSYM SPDRP_LEGACYBUSTYPE}
  SPDRP_BUSNUMBER                   = $00000015; // BusNumber (R)
  {$EXTERNALSYM SPDRP_BUSNUMBER}
  SPDRP_ENUMERATOR_NAME             = $00000016; // Enumerator Name (R)
  {$EXTERNALSYM SPDRP_ENUMERATOR_NAME}
  SPDRP_SECURITY                    = $00000017; // Security (R/W, binary form)
  {$EXTERNALSYM SPDRP_SECURITY}
  SPDRP_SECURITY_SDS                = $00000018; // Security (W, SDS form)
  {$EXTERNALSYM SPDRP_SECURITY_SDS}
  SPDRP_DEVTYPE                     = $00000019; // Device Type (R/W)
  {$EXTERNALSYM SPDRP_DEVTYPE}
  SPDRP_EXCLUSIVE                   = $0000001A; // Device is exclusive-access (R/W)
  {$EXTERNALSYM SPDRP_EXCLUSIVE}
  SPDRP_CHARACTERISTICS             = $0000001B; // Device Characteristics (R/W)
  {$EXTERNALSYM SPDRP_CHARACTERISTICS}
  SPDRP_ADDRESS                     = $0000001C; // Device Address (R)
  {$EXTERNALSYM SPDRP_ADDRESS}
  SPDRP_UI_NUMBER_DESC_FORMAT       = $0000001E; // UiNumberDescFormat (R/W)
  {$EXTERNALSYM SPDRP_UI_NUMBER_DESC_FORMAT}
  SPDRP_MAXIMUM_PROPERTY            = $0000001F; // Upper bound on ordinals
  {$EXTERNALSYM SPDRP_MAXIMUM_PROPERTY}
//
// Class registry property codes
// (Codes marked as read-only (R) may only be used for
// SetupDiGetClassRegistryProperty)
//
// These values should cover the same set of registry properties
// as defined by the CM_CRP codes in cfgmgr32.h.
// they should also have a 1:1 correspondence with Device registers, where applicable
// but no overlap otherwise
//
  SPCRP_SECURITY         = $00000017; // Security (R/W, binary form)
  {$EXTERNALSYM SPCRP_SECURITY}
  SPCRP_SECURITY_SDS     = $00000018; // Security (W, SDS form)
  {$EXTERNALSYM SPCRP_SECURITY_SDS}
  SPCRP_DEVTYPE          = $00000019; // Device Type (R/W)
  {$EXTERNALSYM SPCRP_DEVTYPE}
  SPCRP_EXCLUSIVE        = $0000001A; // Device is exclusive-access (R/W)
  {$EXTERNALSYM SPCRP_EXCLUSIVE}
  SPCRP_CHARACTERISTICS  = $0000001B; // Device Characteristics (R/W)
  {$EXTERNALSYM SPCRP_CHARACTERISTICS}
  SPCRP_MAXIMUM_PROPERTY = $0000001C; // Upper bound on ordinals
  {$EXTERNALSYM SPCRP_MAXIMUM_PROPERTY}

function SetupDiGetDeviceRegistryPropertyA(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Property_: DWORD;
  PropertyRegDataType: PDWORD; PropertyBuffer: PBYTE; PropertyBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceRegistryPropertyA}
function SetupDiGetDeviceRegistryPropertyW(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Property_: DWORD;
  PropertyRegDataType: PDWORD; PropertyBuffer: PBYTE; PropertyBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceRegistryPropertyW}
function SetupDiGetDeviceRegistryProperty(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; Property_: DWORD;
  PropertyRegDataType: PDWORD; PropertyBuffer: PBYTE; PropertyBufferSize: DWORD;
  RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceRegistryProperty}

function SetupDiGetClassRegistryPropertyA(var ClassGuid: TGUID;
  Property_: DWORD; PropertyRegDataType: PDWORD; PropertyBuffer: PBYTE;
  PropertyBufferSize: DWORD; RequiredSize: PDWORD; const MachineName: PAnsiChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassRegistryPropertyA}
function SetupDiGetClassRegistryPropertyW(var ClassGuid: TGUID;
  Property_: DWORD; PropertyRegDataType: PDWORD; PropertyBuffer: PBYTE;
  PropertyBufferSize: DWORD; RequiredSize: PDWORD; const MachineName: PWideChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassRegistryPropertyW}
function SetupDiGetClassRegistryProperty(var ClassGuid: TGUID;
  Property_: DWORD; PropertyRegDataType: PDWORD; PropertyBuffer: PBYTE;
  PropertyBufferSize: DWORD; RequiredSize: PDWORD; const MachineName: PChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassRegistryProperty}

function SetupDiSetDeviceRegistryPropertyA(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Property_: DWORD;
  const PropertyBuffer: PBYTE; PropertyBufferSize: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetDeviceRegistryPropertyA}
function SetupDiSetDeviceRegistryPropertyW(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Property_: DWORD;
  const PropertyBuffer: PBYTE; PropertyBufferSize: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetDeviceRegistryPropertyW}
function SetupDiSetDeviceRegistryProperty(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData; Property_: DWORD;
  const PropertyBuffer: PBYTE; PropertyBufferSize: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetDeviceRegistryProperty}

function SetupDiSetClassRegistryPropertyA(var ClassGuid: TGUID;
  Property_: DWORD; const PropertyBuffer: PBYTE; PropertyBufferSize: DWORD;
  const MachineName: PAnsiChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetClassRegistryPropertyA}
function SetupDiSetClassRegistryPropertyW(var ClassGuid: TGUID;
  Property_: DWORD; const PropertyBuffer: PBYTE; PropertyBufferSize: DWORD;
  const MachineName: PWideChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetClassRegistryPropertyW}
function SetupDiSetClassRegistryProperty(var ClassGuid: TGUID;
  Property_: DWORD; const PropertyBuffer: PBYTE; PropertyBufferSize: DWORD;
  const MachineName: PChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetClassRegistryProperty}

function SetupDiGetDeviceInstallParamsA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData;
  var DeviceInstallParams: TSPDevInstallParamsA): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInstallParamsA}

function SetupDiGetDeviceInstallParamsW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData;
  var DeviceInstallParams: TSPDevInstallParamsW): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInstallParamsW}

function SetupDiGetDeviceInstallParams(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData;
  var DeviceInstallParams: TSPDevInstallParamsA): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDeviceInstallParams}


function SetupDiGetClassInstallParamsA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; ClassInstallParams: PSPClassInstallHeader;
  ClassInstallParamsSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassInstallParamsA}
function SetupDiGetClassInstallParamsW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; ClassInstallParams: PSPClassInstallHeader;
  ClassInstallParamsSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassInstallParamsW}
function SetupDiGetClassInstallParams(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; ClassInstallParams: PSPClassInstallHeader;
  ClassInstallParamsSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassInstallParams}

function SetupDiSetDeviceInstallParamsA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData;
  var DeviceInstallParams: TSPDevInstallParamsA): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetDeviceInstallParamsA}
function SetupDiSetDeviceInstallParamsW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData;
  var DeviceInstallParams: TSPDevInstallParamsW): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetDeviceInstallParamsW}
function SetupDiSetDeviceInstallParams(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData;
  var DeviceInstallParams: TSPDevInstallParamsA): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetDeviceInstallParams}

function SetupDiSetClassInstallParamsA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; ClassInstallParams: PSPClassInstallHeader;
  ClassInstallParamsSize: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetClassInstallParamsA}
function SetupDiSetClassInstallParamsW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; ClassInstallParams: PSPClassInstallHeader;
  ClassInstallParamsSize: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetClassInstallParamsW}
function SetupDiSetClassInstallParams(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; ClassInstallParams: PSPClassInstallHeader;
  ClassInstallParamsSize: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetClassInstallParams}

function SetupDiGetDriverInstallParamsA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataA;
  var DriverInstallParams: TSPDrvInstallParams): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDriverInstallParamsA}
function SetupDiGetDriverInstallParamsW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataW;
  var DriverInstallParams: TSPDrvInstallParams): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDriverInstallParamsW}
function SetupDiGetDriverInstallParams(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataA;
  var DriverInstallParams: TSPDrvInstallParams): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetDriverInstallParams}

function SetupDiSetDriverInstallParamsA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataA;
  var DriverInstallParams: TSPDrvInstallParams): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetDriverInstallParamsA}
function SetupDiSetDriverInstallParamsW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataW;
  var DriverInstallParams: TSPDrvInstallParams): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetDriverInstallParamsW}
function SetupDiSetDriverInstallParams(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var DriverInfoData: TSPDrvInfoDataA;
  var DriverInstallParams: TSPDrvInstallParams): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetDriverInstallParams}

function SetupDiLoadClassIcon(var ClassGuid: TGUID; LargeIcon: PHICON;
  MiniIconIndex: PINT): LongBool; stdcall;
{$EXTERNALSYM SetupDiLoadClassIcon}

//
// Flags controlling the drawing of mini-icons
//
const
  DMI_MASK    = $00000001;
  {$EXTERNALSYM DMI_MASK}
  DMI_BKCOLOR = $00000002;
  {$EXTERNALSYM DMI_BKCOLOR}
  DMI_USERECT = $00000004;
  {$EXTERNALSYM DMI_USERECT}

function SetupDiDrawMiniIcon(hdc: HDC; rc: TRect; MiniIconIndex: Integer;
  Flags: DWORD): Integer; stdcall;
{$EXTERNALSYM SetupDiDrawMiniIcon}

function SetupDiGetClassBitmapIndex(ClassGuid: PGUID;
  var MiniIconIndex: Integer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassBitmapIndex}

function SetupDiGetClassImageList(
  var ClassImageListData: TSPClassImageListData): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassImageList}

function SetupDiGetClassImageListExA(var ClassImageListData: TSPClassImageListData;
  const MachineName: PAnsiChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassImageListExA}
function SetupDiGetClassImageListExW(var ClassImageListData: TSPClassImageListData;
  const MachineName: PWideChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassImageListExW}
function SetupDiGetClassImageListEx(var ClassImageListData: TSPClassImageListData;
  const MachineName: PChar; Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassImageListEx}

function SetupDiGetClassImageIndex(var ClassImageListData: TSPClassImageListData;
  var ClassGuid: TGUID; var ImageIndex: Integer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassImageIndex}

function SetupDiDestroyClassImageList(
  var ClassImageListData: TSPClassImageListData): LongBool; stdcall;
{$EXTERNALSYM SetupDiDestroyClassImageList}

//
// PropertySheetType values for the SetupDiGetClassDevPropertySheets API
//
const
  DIGCDP_FLAG_BASIC    = $00000001;
  {$EXTERNALSYM DIGCDP_FLAG_BASIC}
  DIGCDP_FLAG_ADVANCED = $00000002;
  {$EXTERNALSYM DIGCDP_FLAG_ADVANCED}

function SetupDiGetClassDevPropertySheetsA(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var PropertySheetHeader: TPropSheetHeaderA;
  PropertySheetHeaderPageListSize: DWORD; RequiredSize: PDWORD;
  PropertySheetType: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassDevPropertySheetsA}
function SetupDiGetClassDevPropertySheetsW(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var PropertySheetHeader: TPropSheetHeaderW;
  PropertySheetHeaderPageListSize: DWORD; RequiredSize: PDWORD;
  PropertySheetType: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassDevPropertySheetsW}
function SetupDiGetClassDevPropertySheets(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var PropertySheetHeader: TPropSheetHeaderA;
  PropertySheetHeaderPageListSize: DWORD; RequiredSize: PDWORD;
  PropertySheetType: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetClassDevPropertySheets}

//
// Define ICON IDs publicly exposed from setupapi.
//
const
  IDI_RESOURCEFIRST        = 159;
  {$EXTERNALSYM IDI_RESOURCEFIRST}
  IDI_RESOURCE             = 159;
  {$EXTERNALSYM IDI_RESOURCE}
  IDI_RESOURCELAST         = 161;
  {$EXTERNALSYM IDI_RESOURCELAST}
  IDI_RESOURCEOVERLAYFIRST = 161;
  {$EXTERNALSYM IDI_RESOURCEOVERLAYFIRST}
  IDI_RESOURCEOVERLAYLAST  = 161;
  {$EXTERNALSYM IDI_RESOURCEOVERLAYLAST}
  IDI_CONFLICT             = 161;
  {$EXTERNALSYM IDI_CONFLICT}

  IDI_CLASSICON_OVERLAYFIRST = 500;
  {$EXTERNALSYM IDI_CLASSICON_OVERLAYFIRST}
  IDI_CLASSICON_OVERLAYLAST  = 502;
  {$EXTERNALSYM IDI_CLASSICON_OVERLAYLAST}
  IDI_PROBLEM_OVL            = 500;
  {$EXTERNALSYM IDI_PROBLEM_OVL}
  IDI_DISABLED_OVL           = 501;
  {$EXTERNALSYM IDI_DISABLED_OVL}
  IDI_FORCED_OVL             = 502;
  {$EXTERNALSYM IDI_FORCED_OVL}

function SetupDiAskForOEMDisk(DeviceInfoSet: HDEVINFO; DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiAskForOEMDisk}

function SetupDiSelectOEMDrv(hwndParent: HWND; DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiSelectOEMDrv}

function SetupDiClassNameFromGuidA(var ClassGuid: TGUID; ClassName: PAnsiChar;
  ClassNameSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassNameFromGuidA}
function SetupDiClassNameFromGuidW(var ClassGuid: TGUID; ClassName: PWideChar;
  ClassNameSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassNameFromGuidW}
function SetupDiClassNameFromGuid(var ClassGuid: TGUID; ClassName: PChar;
  ClassNameSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassNameFromGuid}

function SetupDiClassNameFromGuidExA(var ClassGuid: TGUID; ClassName: PAnsiChar;
  ClassNameSize: DWORD; RequiredSize: PDWORD; const MachineName: PAnsiChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassNameFromGuidExA}
function SetupDiClassNameFromGuidExW(var ClassGuid: TGUID; ClassName: PWideChar;
  ClassNameSize: DWORD; RequiredSize: PDWORD; const MachineName: PWideChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassNameFromGuidExW}
function SetupDiClassNameFromGuidEx(var ClassGuid: TGUID; ClassName: PChar;
  ClassNameSize: DWORD; RequiredSize: PDWORD; const MachineName: PChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassNameFromGuidEx}

function SetupDiClassGuidsFromNameA(const ClassName: PAnsiChar; ClassGuidList: PGUID;
  ClassGuidListSize: DWORD; var RequiredSize: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassGuidsFromNameA}
function SetupDiClassGuidsFromNameW(const ClassName: PWideChar; ClassGuidList: PGUID;
  ClassGuidListSize: DWORD; var RequiredSize: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassGuidsFromNameW}
function SetupDiClassGuidsFromName(const ClassName: PChar; ClassGuidList: PGUID;
  ClassGuidListSize: DWORD; var RequiredSize: DWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassGuidsFromName}

function SetupDiClassGuidsFromNameExA(const ClassName: PAnsiChar; ClassGuidList: PGUID;
  ClassGuidListSize: DWORD; var RequiredSize: DWORD; const MachineName: PAnsiChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassGuidsFromNameExA}
function SetupDiClassGuidsFromNameExW(const ClassName: PWideChar; ClassGuidList: PGUID;
  ClassGuidListSize: DWORD; var RequiredSize: DWORD; const MachineName: PWideChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassGuidsFromNameExW}
function SetupDiClassGuidsFromNameEx(const ClassName: PChar; ClassGuidList: PGUID;
  ClassGuidListSize: DWORD; var RequiredSize: DWORD; const MachineName: PChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiClassGuidsFromNameEx}

function SetupDiGetHwProfileFriendlyNameA(HwProfile: DWORD; FriendlyName: PAnsiChar;
  FriendlyNameSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetHwProfileFriendlyNameA}
function SetupDiGetHwProfileFriendlyNameW(HwProfile: DWORD; FriendlyName: PWideChar;
  FriendlyNameSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetHwProfileFriendlyNameW}
function SetupDiGetHwProfileFriendlyName(HwProfile: DWORD; FriendlyName: PChar;
  FriendlyNameSize: DWORD; RequiredSize: PDWORD): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetHwProfileFriendlyName}

function SetupDiGetHwProfileFriendlyNameExA(HwProfile: DWORD; FriendlyName: PAnsiChar;
  FriendlyNameSize: DWORD; RequiredSize: PDWORD; const MachineName: PAnsiChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetHwProfileFriendlyNameExA}
function SetupDiGetHwProfileFriendlyNameExW(HwProfile: DWORD; FriendlyName: PWideChar;
  FriendlyNameSize: DWORD; RequiredSize: PDWORD; const MachineName: PWideChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetHwProfileFriendlyNameExW}
function SetupDiGetHwProfileFriendlyNameEx(HwProfile: DWORD; FriendlyName: PChar;
  FriendlyNameSize: DWORD; RequiredSize: PDWORD; const MachineName: PChar;
  Reserved: Pointer): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetHwProfileFriendlyNameEx}

//
// PageType values for SetupDiGetWizardPage API
//
const
  SPWPT_SELECTDEVICE = $00000001;
  {$EXTERNALSYM SPWPT_SELECTDEVICE}

//
// Flags for SetupDiGetWizardPage API
//
  SPWP_USE_DEVINFO_DATA = $00000001;
{$EXTERNALSYM SPWP_USE_DEVINFO_DATA}

function SetupDiGetWizardPage(DeviceInfoSet: HDEVINFO;
  DeviceInfoData: PSPDevInfoData; var InstallWizardData: TSPInstallWizardData;
  PageType: DWORD; Flags: DWORD): HPROPSHEETPAGE; stdcall;
{$EXTERNALSYM SetupDiGetWizardPage}

function SetupDiGetSelectedDevice(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetSelectedDevice}

function SetupDiSetSelectedDevice(DeviceInfoSet: HDEVINFO;
  var DeviceInfoData: TSPDevInfoData): LongBool; stdcall;
{$EXTERNALSYM SetupDiSetSelectedDevice}

function SetupDiGetActualSectionToInstallA(InfHandle: HINF;
  const InfSectionName: PAnsiChar; InfSectionWithExt: PAnsiChar; InfSectionWithExtSize: DWORD;
  RequiredSize: PDWORD; Extension: PPASTR): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetActualSectionToInstallA}
function SetupDiGetActualSectionToInstallW(InfHandle: HINF;
  const InfSectionName: PWideChar; InfSectionWithExt: PWideChar; InfSectionWithExtSize: DWORD;
  RequiredSize: PDWORD; Extension: PPWSTR): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetActualSectionToInstallW}
function SetupDiGetActualSectionToInstall(InfHandle: HINF;
  const InfSectionName: PChar; InfSectionWithExt: PChar; InfSectionWithExtSize: DWORD;
  RequiredSize: PDWORD; Extension: PPSTR): LongBool; stdcall;
{$EXTERNALSYM SetupDiGetActualSectionToInstall}

implementation

const
  SetupAPIdll = 'SetupAPI.dll';
  CfgMgrDll = 'cfgmgr32.dll';

function CM_Get_Parent; external CfgMgrDll name 'CM_Get_Parent';
function CM_Get_Child; external CfgMgrDll name 'CM_Get_Child';
function CM_Get_Device_IDA; external CfgMgrDll name 'CM_Get_Device_IDA';
function CM_Get_Device_IDW; external CfgMgrDll name 'CM_Get_Device_IDW';
function CM_Get_Device_ID_Size; external CfgMgrDll name 'CM_Get_Device_ID_Size';
function SetupGetInfInformationA; external SetupAPIdll name 'SetupGetInfInformationA';
function SetupGetInfInformationW; external SetupAPIdll name 'SetupGetInfInformationW';
function SetupGetInfInformation; external SetupAPIdll name 'SetupGetInfInformationA';
function SetupQueryInfFileInformationA; external SetupAPIdll name 'SetupQueryInfFileInformationA';
function SetupQueryInfFileInformationW; external SetupAPIdll name 'SetupQueryInfFileInformationW';
function SetupQueryInfFileInformation; external SetupAPIdll name 'SetupQueryInfFileInformationA';
function SetupQueryInfOriginalFileInformationA; external SetupAPIdll name 'SetupQueryInfOriginalFileInformationA';
function SetupQueryInfOriginalFileInformationW; external SetupAPIdll name 'SetupQueryInfOriginalFileInformationW';
function SetupQueryInfOriginalFileInformation; external SetupAPIdll name 'SetupQueryInfOriginalFileInformationA';
function SetupQueryInfVersionInformationA; external SetupAPIdll name 'SetupQueryInfVersionInformationA';
function SetupQueryInfVersionInformationW; external SetupAPIdll name 'SetupQueryInfVersionInformationW';
function SetupQueryInfVersionInformation; external SetupAPIdll name 'SetupQueryInfVersionInformationA';
function SetupGetInfFileListA; external SetupAPIdll name 'SetupGetInfFileListA';
function SetupGetInfFileListW; external SetupAPIdll name 'SetupGetInfFileListW';
function SetupGetInfFileList; external SetupAPIdll name 'SetupGetInfFileListA';
function SetupOpenInfFileA; external SetupAPIdll name 'SetupOpenInfFileA';
function SetupOpenInfFileW; external SetupAPIdll name 'SetupOpenInfFileW';
function SetupOpenInfFile; external SetupAPIdll name 'SetupOpenInfFileA';
function SetupOpenMasterInf; external SetupAPIdll name 'SetupOpenMasterInf';
function SetupOpenAppendInfFileA; external SetupAPIdll name 'SetupOpenAppendInfFileA';
function SetupOpenAppendInfFileW; external SetupAPIdll name 'SetupOpenAppendInfFileW';
function SetupOpenAppendInfFile; external SetupAPIdll name 'SetupOpenAppendInfFileA';
procedure SetupCloseInfFile; external SetupAPIdll name 'SetupCloseInfFile';
function SetupFindFirstLineA; external SetupAPIdll name 'SetupFindFirstLineA';
function SetupFindFirstLineW; external SetupAPIdll name 'SetupFindFirstLineW';
function SetupFindFirstLine; external SetupAPIdll name 'SetupFindFirstLineA';
function SetupFindNextLine; external SetupAPIdll name 'SetupFindNextLine';
function SetupFindNextMatchLineA; external SetupAPIdll name 'SetupFindNextMatchLineA';
function SetupFindNextMatchLineW; external SetupAPIdll name 'SetupFindNextMatchLineW';
function SetupFindNextMatchLine; external SetupAPIdll name 'SetupFindNextMatchLineA';
function SetupGetLineByIndexA; external SetupAPIdll name 'SetupGetLineByIndexA';
function SetupGetLineByIndexW; external SetupAPIdll name 'SetupGetLineByIndexW';
function SetupGetLineByIndex; external SetupAPIdll name 'SetupGetLineByIndexA';
function SetupGetLineCountA; external SetupAPIdll name 'SetupGetLineCountA';
function SetupGetLineCountW; external SetupAPIdll name 'SetupGetLineCountW';
function SetupGetLineCount; external SetupAPIdll name 'SetupGetLineCountA';
function SetupGetLineTextA; external SetupAPIdll name 'SetupGetLineTextA';
function SetupGetLineTextW; external SetupAPIdll name 'SetupGetLineTextW';
function SetupGetLineText; external SetupAPIdll name 'SetupGetLineTextA';
function SetupGetFieldCount; external SetupAPIdll name 'SetupGetFieldCount';
function SetupGetStringFieldA; external SetupAPIdll name 'SetupGetStringFieldA';
function SetupGetStringFieldW; external SetupAPIdll name 'SetupGetStringFieldW';
function SetupGetStringField; external SetupAPIdll name 'SetupGetStringFieldA';
function SetupGetIntField; external SetupAPIdll name 'SetupGetIntField';
function SetupGetMultiSzFieldA; external SetupAPIdll name 'SetupGetMultiSzFieldA';
function SetupGetMultiSzFieldW; external SetupAPIdll name 'SetupGetMultiSzFieldW';
function SetupGetMultiSzField; external SetupAPIdll name 'SetupGetMultiSzFieldA';
function SetupGetBinaryField; external SetupAPIdll name 'SetupGetBinaryField';
function SetupGetFileCompressionInfoA; external SetupAPIdll name 'SetupGetFileCompressionInfoA';
function SetupGetFileCompressionInfoW; external SetupAPIdll name 'SetupGetFileCompressionInfoW';
function SetupGetFileCompressionInfo; external SetupAPIdll name 'SetupGetFileCompressionInfoA';
function SetupDecompressOrCopyFileA; external SetupAPIdll name 'SetupDecompressOrCopyFileA';
function SetupDecompressOrCopyFileW; external SetupAPIdll name 'SetupDecompressOrCopyFileW';
function SetupDecompressOrCopyFile; external SetupAPIdll name 'SetupDecompressOrCopyFileA';
function SetupGetSourceFileLocationA; external SetupAPIdll name 'SetupGetSourceFileLocationA';
function SetupGetSourceFileLocationW; external SetupAPIdll name 'SetupGetSourceFileLocationW';
function SetupGetSourceFileLocation; external SetupAPIdll name 'SetupGetSourceFileLocationA';
function SetupGetSourceFileSizeA; external SetupAPIdll name 'SetupGetSourceFileSizeA';
function SetupGetSourceFileSizeW; external SetupAPIdll name 'SetupGetSourceFileSizeW';
function SetupGetSourceFileSize; external SetupAPIdll name 'SetupGetSourceFileSizeA';
function SetupGetTargetPathA; external SetupAPIdll name 'SetupGetTargetPathA';
function SetupGetTargetPathW; external SetupAPIdll name 'SetupGetTargetPathW';
function SetupGetTargetPath; external SetupAPIdll name 'SetupGetTargetPathA';
function SetupSetSourceListA; external SetupAPIdll name 'SetupSetSourceListA';
function SetupSetSourceListW; external SetupAPIdll name 'SetupSetSourceListW';
function SetupSetSourceList; external SetupAPIdll name 'SetupSetSourceListA';
function SetupCancelTemporarySourceList; external SetupAPIdll name 'SetupCancelTemporarySourceList';
function SetupAddToSourceListA; external SetupAPIdll name 'SetupAddToSourceListA';
function SetupAddToSourceListW; external SetupAPIdll name 'SetupAddToSourceListW';
function SetupAddToSourceList; external SetupAPIdll name 'SetupAddToSourceListA';
function SetupRemoveFromSourceListA; external SetupAPIdll name 'SetupRemoveFromSourceListA';
function SetupRemoveFromSourceListW; external SetupAPIdll name 'SetupRemoveFromSourceListW';
function SetupRemoveFromSourceList; external SetupAPIdll name 'SetupRemoveFromSourceListA';
function SetupQuerySourceListA; external SetupAPIdll name 'SetupQuerySourceListA';
function SetupQuerySourceListW; external SetupAPIdll name 'SetupQuerySourceListW';
function SetupQuerySourceList; external SetupAPIdll name 'SetupQuerySourceListA';
function SetupFreeSourceListA; external SetupAPIdll name 'SetupFreeSourceListA';
function SetupFreeSourceListW; external SetupAPIdll name 'SetupFreeSourceListW';
function SetupFreeSourceList; external SetupAPIdll name 'SetupFreeSourceListA';
function SetupPromptForDiskA; external SetupAPIdll name 'SetupPromptForDiskA';
function SetupPromptForDiskW; external SetupAPIdll name 'SetupPromptForDiskW';
function SetupPromptForDisk; external SetupAPIdll name 'SetupPromptForDiskA';
function SetupCopyErrorA; external SetupAPIdll name 'SetupCopyErrorA';
function SetupCopyErrorW; external SetupAPIdll name 'SetupCopyErrorW';
function SetupCopyError; external SetupAPIdll name 'SetupCopyErrorA';
function SetupRenameErrorA; external SetupAPIdll name 'SetupRenameErrorA';
function SetupRenameErrorW; external SetupAPIdll name 'SetupRenameErrorW';
function SetupRenameError; external SetupAPIdll name 'SetupRenameErrorA';
function SetupDeleteErrorA; external SetupAPIdll name 'SetupDeleteErrorA';
function SetupDeleteErrorW; external SetupAPIdll name 'SetupDeleteErrorW';
function SetupDeleteError; external SetupAPIdll name 'SetupDeleteErrorA';
function SetupBackupErrorA; external SetupAPIdll name 'SetupBackupErrorA';
function SetupBackupErrorW; external SetupAPIdll name 'SetupBackupErrorW';
function SetupBackupError; external SetupAPIdll name 'SetupBackupErrorA';
function SetupSetDirectoryIdA; external SetupAPIdll name 'SetupSetDirectoryIdA';
function SetupSetDirectoryIdW; external SetupAPIdll name 'SetupSetDirectoryIdW';
function SetupSetDirectoryId; external SetupAPIdll name 'SetupSetDirectoryIdA';
function SetupSetDirectoryIdExA; external SetupAPIdll name 'SetupSetDirectoryIdExA';
function SetupSetDirectoryIdExW; external SetupAPIdll name 'SetupSetDirectoryIdExW';
function SetupSetDirectoryIdEx; external SetupAPIdll name 'SetupSetDirectoryIdExA';
function SetupGetSourceInfoA; external SetupAPIdll name 'SetupGetSourceInfoA';
function SetupGetSourceInfoW; external SetupAPIdll name 'SetupGetSourceInfoW';
function SetupGetSourceInfo; external SetupAPIdll name 'SetupGetSourceInfoA';
function SetupInstallFileA; external SetupAPIdll name 'SetupInstallFileA';
function SetupInstallFileW; external SetupAPIdll name 'SetupInstallFileW';
function SetupInstallFile; external SetupAPIdll name 'SetupInstallFileA';
function SetupInstallFileExA; external SetupAPIdll name 'SetupInstallFileExA';
function SetupInstallFileExW; external SetupAPIdll name 'SetupInstallFileExW';
function SetupInstallFileEx; external SetupAPIdll name 'SetupInstallFileExA';
function SetupOpenFileQueue; external SetupAPIdll name 'SetupOpenFileQueue';
function SetupCloseFileQueue; external SetupAPIdll name 'SetupCloseFileQueue';
function SetupSetFileQueueAlternatePlatformA; external SetupAPIdll name 'SetupSetFileQueueAlternatePlatformA';
function SetupSetFileQueueAlternatePlatformW; external SetupAPIdll name 'SetupSetFileQueueAlternatePlatformW';
function SetupSetFileQueueAlternatePlatform; external SetupAPIdll name 'SetupSetFileQueueAlternatePlatformA';
function SetupSetPlatformPathOverrideA; external SetupAPIdll name 'SetupSetPlatformPathOverrideA';
function SetupSetPlatformPathOverrideW; external SetupAPIdll name 'SetupSetPlatformPathOverrideW';
function SetupSetPlatformPathOverride; external SetupAPIdll name 'SetupSetPlatformPathOverrideA';
function SetupQueueCopyA; external SetupAPIdll name 'SetupQueueCopyA';
function SetupQueueCopyW; external SetupAPIdll name 'SetupQueueCopyW';
function SetupQueueCopy; external SetupAPIdll name 'SetupQueueCopyA';
function SetupQueueCopyIndirectA; external SetupAPIdll name 'SetupQueueCopyIndirectA';
function SetupQueueCopyIndirectW; external SetupAPIdll name 'SetupQueueCopyIndirectW';
function SetupQueueCopyIndirect; external SetupAPIdll name 'SetupQueueCopyIndirectA';
function SetupQueueDefaultCopyA; external SetupAPIdll name 'SetupQueueDefaultCopyA';
function SetupQueueDefaultCopyW; external SetupAPIdll name 'SetupQueueDefaultCopyW';
function SetupQueueDefaultCopy; external SetupAPIdll name 'SetupQueueDefaultCopyA';
function SetupQueueCopySectionA; external SetupAPIdll name 'SetupQueueCopySectionA';
function SetupQueueCopySectionW; external SetupAPIdll name 'SetupQueueCopySectionW';
function SetupQueueCopySection; external SetupAPIdll name 'SetupQueueCopySectionA';
function SetupQueueDeleteA; external SetupAPIdll name 'SetupQueueDeleteA';
function SetupQueueDeleteW; external SetupAPIdll name 'SetupQueueDeleteW';
function SetupQueueDelete; external SetupAPIdll name 'SetupQueueDeleteA';
function SetupQueueDeleteSectionA; external SetupAPIdll name 'SetupQueueDeleteSectionA';
function SetupQueueDeleteSectionW; external SetupAPIdll name 'SetupQueueDeleteSectionW';
function SetupQueueDeleteSection; external SetupAPIdll name 'SetupQueueDeleteSectionA';
function SetupQueueRenameA; external SetupAPIdll name 'SetupQueueRenameA';
function SetupQueueRenameW; external SetupAPIdll name 'SetupQueueRenameW';
function SetupQueueRename; external SetupAPIdll name 'SetupQueueRenameA';
function SetupQueueRenameSectionA; external SetupAPIdll name 'SetupQueueRenameSectionA';
function SetupQueueRenameSectionW; external SetupAPIdll name 'SetupQueueRenameSectionW';
function SetupQueueRenameSection; external SetupAPIdll name 'SetupQueueRenameSectionA';
function SetupCommitFileQueueA; external SetupAPIdll name 'SetupCommitFileQueueA';
function SetupCommitFileQueueW; external SetupAPIdll name 'SetupCommitFileQueueW';
function SetupCommitFileQueue; external SetupAPIdll name 'SetupCommitFileQueueA';
function SetupScanFileQueueA; external SetupAPIdll name 'SetupScanFileQueueA';
function SetupScanFileQueueW; external SetupAPIdll name 'SetupScanFileQueueW';
function SetupScanFileQueue; external SetupAPIdll name 'SetupScanFileQueueA';
function SetupCopyOEMInfA; external SetupAPIdll name 'SetupCopyOEMInfA';
function SetupCopyOEMInfW; external SetupAPIdll name 'SetupCopyOEMInfW';
function SetupCopyOEMInf; external SetupAPIdll name 'SetupCopyOEMInfA';
function SetupCreateDiskSpaceListA; external SetupAPIdll name 'SetupCreateDiskSpaceListA';
function SetupCreateDiskSpaceListW; external SetupAPIdll name 'SetupCreateDiskSpaceListW';
function SetupCreateDiskSpaceList; external SetupAPIdll name 'SetupCreateDiskSpaceListA';
function SetupDuplicateDiskSpaceListA; external SetupAPIdll name 'SetupDuplicateDiskSpaceListA';
function SetupDuplicateDiskSpaceListW; external SetupAPIdll name 'SetupDuplicateDiskSpaceListW';
function SetupDuplicateDiskSpaceList; external SetupAPIdll name 'SetupDuplicateDiskSpaceListA';
function SetupDestroyDiskSpaceList; external SetupAPIdll name 'SetupDestroyDiskSpaceList';
function SetupQueryDrivesInDiskSpaceListA; external SetupAPIdll name 'SetupQueryDrivesInDiskSpaceListA';
function SetupQueryDrivesInDiskSpaceListW; external SetupAPIdll name 'SetupQueryDrivesInDiskSpaceListW';
function SetupQueryDrivesInDiskSpaceList; external SetupAPIdll name 'SetupQueryDrivesInDiskSpaceListA';
function SetupQuerySpaceRequiredOnDriveA; external SetupAPIdll name 'SetupQuerySpaceRequiredOnDriveA';
function SetupQuerySpaceRequiredOnDriveW; external SetupAPIdll name 'SetupQuerySpaceRequiredOnDriveW';
function SetupQuerySpaceRequiredOnDrive; external SetupAPIdll name 'SetupQuerySpaceRequiredOnDriveA';
function SetupAdjustDiskSpaceListA; external SetupAPIdll name 'SetupAdjustDiskSpaceListA';
function SetupAdjustDiskSpaceListW; external SetupAPIdll name 'SetupAdjustDiskSpaceListW';
function SetupAdjustDiskSpaceList; external SetupAPIdll name 'SetupAdjustDiskSpaceListA';
function SetupAddToDiskSpaceListA; external SetupAPIdll name 'SetupAddToDiskSpaceListA';
function SetupAddToDiskSpaceListW; external SetupAPIdll name 'SetupAddToDiskSpaceListW';
function SetupAddToDiskSpaceList; external SetupAPIdll name 'SetupAddToDiskSpaceListA';
function SetupAddSectionToDiskSpaceListA; external SetupAPIdll name 'SetupAddSectionToDiskSpaceListA';
function SetupAddSectionToDiskSpaceListW; external SetupAPIdll name 'SetupAddSectionToDiskSpaceListW';
function SetupAddSectionToDiskSpaceList; external SetupAPIdll name 'SetupAddSectionToDiskSpaceListA';
function SetupAddInstallSectionToDiskSpaceListA; external SetupAPIdll name 'SetupAddInstallSectionToDiskSpaceListA';
function SetupAddInstallSectionToDiskSpaceListW; external SetupAPIdll name 'SetupAddInstallSectionToDiskSpaceListW';
function SetupAddInstallSectionToDiskSpaceList; external SetupAPIdll name 'SetupAddInstallSectionToDiskSpaceListA';
function SetupRemoveFromDiskSpaceListA; external SetupAPIdll name 'SetupRemoveFromDiskSpaceListA';
function SetupRemoveFromDiskSpaceListW; external SetupAPIdll name 'SetupRemoveFromDiskSpaceListW';
function SetupRemoveFromDiskSpaceList; external SetupAPIdll name 'SetupRemoveFromDiskSpaceListA';
function SetupRemoveSectionFromDiskSpaceListA; external SetupAPIdll name 'SetupRemoveSectionFromDiskSpaceListA';
function SetupRemoveSectionFromDiskSpaceListW; external SetupAPIdll name 'SetupRemoveSectionFromDiskSpaceListW';
function SetupRemoveSectionFromDiskSpaceList; external SetupAPIdll name 'SetupRemoveSectionFromDiskSpaceListA';
function SetupRemoveInstallSectionFromDiskSpaceListA; external SetupAPIdll name 'SetupRemoveInstallSectionFromDiskSpaceListA';
function SetupRemoveInstallSectionFromDiskSpaceListW; external SetupAPIdll name 'SetupRemoveInstallSectionFromDiskSpaceListW';
function SetupRemoveInstallSectionFromDiskSpaceList; external SetupAPIdll name 'SetupRemoveInstallSectionFromDiskSpaceListA';
function SetupIterateCabinetA; external SetupAPIdll name 'SetupIterateCabinetA';
function SetupIterateCabinetW; external SetupAPIdll name 'SetupIterateCabinetW';
function SetupIterateCabinet; external SetupAPIdll name 'SetupIterateCabinetA';
function SetupPromptReboot; external SetupAPIdll name 'SetupPromptReboot';
function SetupInitDefaultQueueCallback; external SetupAPIdll name 'SetupInitDefaultQueueCallback';
function SetupInitDefaultQueueCallbackEx; external SetupAPIdll name 'SetupInitDefaultQueueCallbackEx';
procedure SetupTermDefaultQueueCallback; external SetupAPIdll name 'SetupTermDefaultQueueCallback';
function SetupDefaultQueueCallbackA; external SetupAPIdll name 'SetupDefaultQueueCallbackA';
function SetupDefaultQueueCallbackW; external SetupAPIdll name 'SetupDefaultQueueCallbackW';
function SetupDefaultQueueCallback; external SetupAPIdll name 'SetupDefaultQueueCallbackA';
function SetupInstallFromInfSectionA; external SetupAPIdll name 'SetupInstallFromInfSectionA';
function SetupInstallFromInfSectionW; external SetupAPIdll name 'SetupInstallFromInfSectionW';
function SetupInstallFromInfSection; external SetupAPIdll name 'SetupInstallFromInfSectionA';
function SetupInstallFilesFromInfSectionA; external SetupAPIdll name 'SetupInstallFilesFromInfSectionA';
function SetupInstallFilesFromInfSectionW; external SetupAPIdll name 'SetupInstallFilesFromInfSectionW';
function SetupInstallFilesFromInfSection; external SetupAPIdll name 'SetupInstallFilesFromInfSectionA';
function SetupInstallServicesFromInfSectionA; external SetupAPIdll name 'SetupInstallServicesFromInfSectionA';
function SetupInstallServicesFromInfSectionW; external SetupAPIdll name 'SetupInstallServicesFromInfSectionW';
function SetupInstallServicesFromInfSection; external SetupAPIdll name 'SetupInstallServicesFromInfSectionA';
function SetupInstallServicesFromInfSectionExA; external SetupAPIdll name 'SetupInstallServicesFromInfSectionExA';
function SetupInstallServicesFromInfSectionExW; external SetupAPIdll name 'SetupInstallServicesFromInfSectionExW';
function SetupInstallServicesFromInfSectionEx; external SetupAPIdll name 'SetupInstallServicesFromInfSectionExA';
function SetupInitializeFileLogA; external SetupAPIdll name 'SetupInitializeFileLogA';
function SetupInitializeFileLogW; external SetupAPIdll name 'SetupInitializeFileLogW';
function SetupInitializeFileLog; external SetupAPIdll name 'SetupInitializeFileLogA';
function SetupTerminateFileLog; external SetupAPIdll name 'SetupTerminateFileLog';
function SetupLogFileA; external SetupAPIdll name 'SetupLogFileA';
function SetupLogFileW; external SetupAPIdll name 'SetupLogFileW';
function SetupLogFile; external SetupAPIdll name 'SetupLogFileA';
function SetupRemoveFileLogEntryA; external SetupAPIdll name 'SetupRemoveFileLogEntryA';
function SetupRemoveFileLogEntryW; external SetupAPIdll name 'SetupRemoveFileLogEntryW';
function SetupRemoveFileLogEntry; external SetupAPIdll name 'SetupRemoveFileLogEntryA';
function SetupQueryFileLogA; external SetupAPIdll name 'SetupQueryFileLogA';
function SetupQueryFileLogW; external SetupAPIdll name 'SetupQueryFileLogW';
function SetupQueryFileLog; external SetupAPIdll name 'SetupQueryFileLogA';
function SetupOpenLog; external SetupAPIdll name 'SetupOpenLog';
function SetupLogErrorA; external SetupAPIdll name 'SetupLogErrorA';
function SetupLogErrorW; external SetupAPIdll name 'SetupLogErrorW';
function SetupLogError; external SetupAPIdll name 'SetupLogErrorA';
procedure SetupCloseLog; external SetupAPIdll name 'SetupCloseLog';
function SetupGetBackupInformationA; external SetupAPIdll name 'SetupGetBackupInformationA';
function SetupGetBackupInformationW; external SetupAPIdll name 'SetupGetBackupInformationW';
function SetupGetBackupInformation; external SetupAPIdll name 'SetupGetBackupInformationA';
function SetupDiCreateDeviceInfoList; external SetupAPIdll name 'SetupDiCreateDeviceInfoList';
function SetupDiCreateDeviceInfoListExA; external SetupAPIdll name 'SetupDiCreateDeviceInfoListExA';
function SetupDiCreateDeviceInfoListExW; external SetupAPIdll name 'SetupDiCreateDeviceInfoListExW';
function SetupDiCreateDeviceInfoListEx; external SetupAPIdll name 'SetupDiCreateDeviceInfoListExA';
function SetupDiGetDeviceInfoListClass; external SetupAPIdll name 'SetupDiGetDeviceInfoListClass';
function SetupDiGetDeviceInfoListDetailA; external SetupAPIdll name 'SetupDiGetDeviceInfoListDetailA';
function SetupDiGetDeviceInfoListDetailW; external SetupAPIdll name 'SetupDiGetDeviceInfoListDetailW';
function SetupDiGetDeviceInfoListDetail; external SetupAPIdll name 'SetupDiGetDeviceInfoListDetailA';
function SetupDiCreateDeviceInfoA; external SetupAPIdll name 'SetupDiCreateDeviceInfoA';
function SetupDiCreateDeviceInfoW; external SetupAPIdll name 'SetupDiCreateDeviceInfoW';
function SetupDiCreateDeviceInfo; external SetupAPIdll name 'SetupDiCreateDeviceInfoA';
function SetupDiOpenDeviceInfoA; external SetupAPIdll name 'SetupDiOpenDeviceInfoA';
function SetupDiOpenDeviceInfoW; external SetupAPIdll name 'SetupDiOpenDeviceInfoW';
function SetupDiOpenDeviceInfo; external SetupAPIdll name 'SetupDiOpenDeviceInfoA';
function SetupDiGetDeviceInstanceIdA; external SetupAPIdll name 'SetupDiGetDeviceInstanceIdA';
function SetupDiGetDeviceInstanceIdW; external SetupAPIdll name 'SetupDiGetDeviceInstanceIdW';
function SetupDiGetDeviceInstanceId; external SetupAPIdll name 'SetupDiGetDeviceInstanceIdA';
function SetupDiDeleteDeviceInfo; external SetupAPIdll name 'SetupDiDeleteDeviceInfo';
function SetupDiEnumDeviceInfo; external SetupAPIdll name 'SetupDiEnumDeviceInfo';
function SetupDiDestroyDeviceInfoList; external SetupAPIdll name 'SetupDiDestroyDeviceInfoList';
function SetupDiEnumDeviceInterfaces; external SetupAPIdll name 'SetupDiEnumDeviceInterfaces';
function SetupDiEnumInterfaceDevice; external SetupAPIdll name 'SetupDiEnumDeviceInterfaces';
function SetupDiCreateDeviceInterfaceA; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceA';
function SetupDiCreateInterfaceDeviceA; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceA';
function SetupDiCreateDeviceInterfaceW; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceW';
function SetupDiCreateInterfaceDeviceW; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceW';
function SetupDiCreateDeviceInterface; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceA';
function SetupDiCreateInterfaceDevice; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceA';
function SetupDiOpenDeviceInterfaceA; external SetupAPIdll name 'SetupDiOpenDeviceInterfaceA';
function SetupDiOpenInterfaceDeviceA; external SetupAPIdll name 'SetupDiOpenDeviceInterfaceA';
function SetupDiOpenDeviceInterfaceW; external SetupAPIdll name 'SetupDiOpenDeviceInterfaceW';
function SetupDiOpenInterfaceDeviceW; external SetupAPIdll name 'SetupDiOpenDeviceInterfaceW';
function SetupDiOpenDeviceInterface; external SetupAPIdll name 'SetupDiOpenDeviceInterfaceA';
function SetupDiOpenInterfaceDevice; external SetupAPIdll name 'SetupDiOpenDeviceInterfaceA';
function SetupDiGetDeviceInterfaceAlias; external SetupAPIdll name 'SetupDiGetDeviceInterfaceAlias';
function SetupDiGetInterfaceDeviceAlias; external SetupAPIdll name 'SetupDiGetDeviceInterfaceAlias';
function SetupDiDeleteDeviceInterfaceData; external SetupAPIdll name 'SetupDiDeleteDeviceInterfaceData';
function SetupDiDeleteInterfaceDeviceData; external SetupAPIdll name 'SetupDiDeleteDeviceInterfaceData';
function SetupDiRemoveDeviceInterface; external SetupAPIdll name 'SetupDiRemoveDeviceInterface';
function SetupDiRemoveInterfaceDevice; external SetupAPIdll name 'SetupDiRemoveDeviceInterface';
function SetupDiGetDeviceInterfaceDetailA; external SetupAPIdll name 'SetupDiGetDeviceInterfaceDetailA';
function SetupDiGetInterfaceDeviceDetailA; external SetupAPIdll name 'SetupDiGetDeviceInterfaceDetailA';
function SetupDiGetDeviceInterfaceDetailW; external SetupAPIdll name 'SetupDiGetDeviceInterfaceDetailW';
function SetupDiGetInterfaceDeviceDetailW; external SetupAPIdll name 'SetupDiGetDeviceInterfaceDetailW';
function SetupDiGetDeviceInterfaceDetail; external SetupAPIdll name 'SetupDiGetDeviceInterfaceDetailA';
function SetupDiGetInterfaceDeviceDetail; external SetupAPIdll name 'SetupDiGetDeviceInterfaceDetailA';
function SetupDiInstallDeviceInterfaces; external SetupAPIdll name 'SetupDiInstallDeviceInterfaces';
function SetupDiInstallInterfaceDevices; external SetupAPIdll name 'SetupDiInstallDeviceInterfaces';
function SetupDiRegisterDeviceInfo; external SetupAPIdll name 'SetupDiRegisterDeviceInfo';
function SetupDiBuildDriverInfoList; external SetupAPIdll name 'SetupDiBuildDriverInfoList';
function SetupDiCancelDriverInfoSearch; external SetupAPIdll name 'SetupDiCancelDriverInfoSearch';
function SetupDiEnumDriverInfoA; external SetupAPIdll name 'SetupDiEnumDriverInfoA';
function SetupDiEnumDriverInfoW; external SetupAPIdll name 'SetupDiEnumDriverInfoW';
function SetupDiEnumDriverInfo; external SetupAPIdll name 'SetupDiEnumDriverInfoA';
function SetupDiGetSelectedDriverA; external SetupAPIdll name 'SetupDiGetSelectedDriverA';
function SetupDiGetSelectedDriverW; external SetupAPIdll name 'SetupDiGetSelectedDriverW';
function SetupDiGetSelectedDriver; external SetupAPIdll name 'SetupDiGetSelectedDriverA';
function SetupDiSetSelectedDriverA; external SetupAPIdll name 'SetupDiSetSelectedDriverA';
function SetupDiSetSelectedDriverW; external SetupAPIdll name 'SetupDiSetSelectedDriverW';
function SetupDiSetSelectedDriver; external SetupAPIdll name 'SetupDiSetSelectedDriverA';
function SetupDiGetDriverInfoDetailA; external SetupAPIdll name 'SetupDiGetDriverInfoDetailA';
function SetupDiGetDriverInfoDetailW; external SetupAPIdll name 'SetupDiGetDriverInfoDetailW';
function SetupDiGetDriverInfoDetail; external SetupAPIdll name 'SetupDiGetDriverInfoDetailA';
function SetupDiDestroyDriverInfoList; external SetupAPIdll name 'SetupDiDestroyDriverInfoList';
function SetupDiGetClassDevsA; external SetupAPIdll name 'SetupDiGetClassDevsA';
function SetupDiGetClassDevsW; external SetupAPIdll name 'SetupDiGetClassDevsW';
function SetupDiGetClassDevs; external SetupAPIdll name 'SetupDiGetClassDevsA';
function SetupDiGetClassDevsExA; external SetupAPIdll name 'SetupDiGetClassDevsExA';
function SetupDiGetClassDevsExW; external SetupAPIdll name 'SetupDiGetClassDevsExW';
function SetupDiGetClassDevsEx; external SetupAPIdll name 'SetupDiGetClassDevsExA';
function SetupDiGetINFClassA; external SetupAPIdll name 'SetupDiGetINFClassA';
function SetupDiGetINFClassW; external SetupAPIdll name 'SetupDiGetINFClassW';
function SetupDiGetINFClass; external SetupAPIdll name 'SetupDiGetINFClassA';
function SetupDiBuildClassInfoList; external SetupAPIdll name 'SetupDiBuildClassInfoList';
function SetupDiBuildClassInfoListExA; external SetupAPIdll name 'SetupDiBuildClassInfoListExA';
function SetupDiBuildClassInfoListExW; external SetupAPIdll name 'SetupDiBuildClassInfoListExW';
function SetupDiBuildClassInfoListEx; external SetupAPIdll name 'SetupDiBuildClassInfoListExA';
function SetupDiGetClassDescriptionA; external SetupAPIdll name 'SetupDiGetClassDescriptionA';
function SetupDiGetClassDescriptionW; external SetupAPIdll name 'SetupDiGetClassDescriptionW';
function SetupDiGetClassDescription; external SetupAPIdll name 'SetupDiGetClassDescriptionA';
function SetupDiGetClassDescriptionExA; external SetupAPIdll name 'SetupDiGetClassDescriptionExA';
function SetupDiGetClassDescriptionExW; external SetupAPIdll name 'SetupDiGetClassDescriptionExW';
function SetupDiGetClassDescriptionEx; external SetupAPIdll name 'SetupDiGetClassDescriptionExA';
function SetupDiCallClassInstaller; external SetupAPIdll name 'SetupDiCallClassInstaller';
function SetupDiSelectDevice; external SetupAPIdll name 'SetupDiSelectDevice';
function SetupDiSelectBestCompatDrv; external SetupAPIdll name 'SetupDiSelectBestCompatDrv';
function SetupDiInstallDevice; external SetupAPIdll name 'SetupDiInstallDevice';
function SetupDiInstallDriverFiles; external SetupAPIdll name 'SetupDiInstallDriverFiles';
function SetupDiRegisterCoDeviceInstallers; external SetupAPIdll name 'SetupDiRegisterCoDeviceInstallers';
function SetupDiRemoveDevice; external SetupAPIdll name 'SetupDiRemoveDevice';
function SetupDiUnremoveDevice; external SetupAPIdll name 'SetupDiUnremoveDevice';
function SetupDiMoveDuplicateDevice; external SetupAPIdll name 'SetupDiMoveDuplicateDevice';
function SetupDiChangeState; external SetupAPIdll name 'SetupDiChangeState';
function SetupDiInstallClassA; external SetupAPIdll name 'SetupDiInstallClassA';
function SetupDiInstallClassW; external SetupAPIdll name 'SetupDiInstallClassW';
function SetupDiInstallClass; external SetupAPIdll name 'SetupDiInstallClassA';
function SetupDiInstallClassExA; external SetupAPIdll name 'SetupDiInstallClassExA';
function SetupDiInstallClassExW; external SetupAPIdll name 'SetupDiInstallClassExW';
function SetupDiInstallClassEx; external SetupAPIdll name 'SetupDiInstallClassExA';
function SetupDiOpenClassRegKey; external SetupAPIdll name 'SetupDiOpenClassRegKey';
function SetupDiOpenClassRegKeyExA; external SetupAPIdll name 'SetupDiOpenClassRegKeyExA';
function SetupDiOpenClassRegKeyExW; external SetupAPIdll name 'SetupDiOpenClassRegKeyExW';
function SetupDiOpenClassRegKeyEx; external SetupAPIdll name 'SetupDiOpenClassRegKeyExA';
function SetupDiCreateDeviceInterfaceRegKeyA; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceRegKeyA';
function SetupDiCreateInterfaceDeviceRegKeyA; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceRegKeyA';
function SetupDiCreateDeviceInterfaceRegKeyW; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceRegKeyW';
function SetupDiCreateInterfaceDeviceRegKeyW; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceRegKeyW';
function SetupDiCreateDeviceInterfaceRegKey; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceRegKeyA';
function SetupDiCreateInterfaceDeviceRegKey; external SetupAPIdll name 'SetupDiCreateDeviceInterfaceRegKeyA';
function SetupDiOpenDeviceInterfaceRegKey; external SetupAPIdll name 'SetupDiOpenDeviceInterfaceRegKey';
function SetupDiOpenInterfaceDeviceRegKey; external SetupAPIdll name 'SetupDiOpenDeviceInterfaceRegKey';
function SetupDiDeleteDeviceInterfaceRegKey; external SetupAPIdll name 'SetupDiDeleteDeviceInterfaceRegKey';
function SetupDiDeleteInterfaceDeviceRegKey; external SetupAPIdll name 'SetupDiDeleteDeviceInterfaceRegKey';
function SetupDiCreateDevRegKeyA; external SetupAPIdll name 'SetupDiCreateDevRegKeyA';
function SetupDiCreateDevRegKeyW; external SetupAPIdll name 'SetupDiCreateDevRegKeyW';
function SetupDiCreateDevRegKey; external SetupAPIdll name 'SetupDiCreateDevRegKeyA';
function SetupDiOpenDevRegKey; external SetupAPIdll name 'SetupDiOpenDevRegKey';
function SetupDiDeleteDevRegKey; external SetupAPIdll name 'SetupDiDeleteDevRegKey';
function SetupDiGetHwProfileList; external SetupAPIdll name 'SetupDiGetHwProfileList';
function SetupDiGetHwProfileListExA; external SetupAPIdll name 'SetupDiGetHwProfileListExA';
function SetupDiGetHwProfileListExW; external SetupAPIdll name 'SetupDiGetHwProfileListExW';
function SetupDiGetHwProfileListEx; external SetupAPIdll name 'SetupDiGetHwProfileListExA';
function SetupDiGetDeviceRegistryPropertyA; external SetupAPIdll name 'SetupDiGetDeviceRegistryPropertyA';
function SetupDiGetDeviceRegistryPropertyW; external SetupAPIdll name 'SetupDiGetDeviceRegistryPropertyW';
function SetupDiGetDeviceRegistryProperty; external SetupAPIdll name 'SetupDiGetDeviceRegistryPropertyA';
function SetupDiGetClassRegistryPropertyA; external SetupAPIdll name 'SetupDiGetClassRegistryPropertyA';
function SetupDiGetClassRegistryPropertyW; external SetupAPIdll name 'SetupDiGetClassRegistryPropertyW';
function SetupDiGetClassRegistryProperty; external SetupAPIdll name 'SetupDiGetClassRegistryPropertyA';
function SetupDiSetDeviceRegistryPropertyA; external SetupAPIdll name 'SetupDiSetDeviceRegistryPropertyA';
function SetupDiSetDeviceRegistryPropertyW; external SetupAPIdll name 'SetupDiSetDeviceRegistryPropertyW';
function SetupDiSetDeviceRegistryProperty; external SetupAPIdll name 'SetupDiSetDeviceRegistryPropertyA';
function SetupDiSetClassRegistryPropertyA; external SetupAPIdll name 'SetupDiSetClassRegistryPropertyA';
function SetupDiSetClassRegistryPropertyW; external SetupAPIdll name 'SetupDiSetClassRegistryPropertyW';
function SetupDiSetClassRegistryProperty; external SetupAPIdll name 'SetupDiSetClassRegistryPropertyA';
function SetupDiGetDeviceInstallParamsA; external SetupAPIdll name 'SetupDiGetDeviceInstallParamsA';
function SetupDiGetDeviceInstallParamsW; external SetupAPIdll name 'SetupDiGetDeviceInstallParamsW';
function SetupDiGetDeviceInstallParams; external SetupAPIdll name 'SetupDiGetDeviceInstallParamsA';
function SetupDiGetClassInstallParamsA; external SetupAPIdll name 'SetupDiGetClassInstallParamsA';
function SetupDiGetClassInstallParamsW; external SetupAPIdll name 'SetupDiGetClassInstallParamsW';
function SetupDiGetClassInstallParams; external SetupAPIdll name 'SetupDiGetClassInstallParamsA';
function SetupDiSetDeviceInstallParamsA; external SetupAPIdll name 'SetupDiSetDeviceInstallParamsA';
function SetupDiSetDeviceInstallParamsW; external SetupAPIdll name 'SetupDiSetDeviceInstallParamsW';
function SetupDiSetDeviceInstallParams; external SetupAPIdll name 'SetupDiSetDeviceInstallParamsA';
function SetupDiSetClassInstallParamsA; external SetupAPIdll name 'SetupDiSetClassInstallParamsA';
function SetupDiSetClassInstallParamsW; external SetupAPIdll name 'SetupDiSetClassInstallParamsW';
function SetupDiSetClassInstallParams; external SetupAPIdll name 'SetupDiSetClassInstallParamsA';
function SetupDiGetDriverInstallParamsA; external SetupAPIdll name 'SetupDiGetDriverInstallParamsA';
function SetupDiGetDriverInstallParamsW; external SetupAPIdll name 'SetupDiGetDriverInstallParamsW';
function SetupDiGetDriverInstallParams; external SetupAPIdll name 'SetupDiGetDriverInstallParamsA';
function SetupDiSetDriverInstallParamsA; external SetupAPIdll name 'SetupDiSetDriverInstallParamsA';
function SetupDiSetDriverInstallParamsW; external SetupAPIdll name 'SetupDiSetDriverInstallParamsW';
function SetupDiSetDriverInstallParams; external SetupAPIdll name 'SetupDiSetDriverInstallParamsA';
function SetupDiLoadClassIcon; external SetupAPIdll name 'SetupDiLoadClassIcon';
function SetupDiDrawMiniIcon; external SetupAPIdll name 'SetupDiDrawMiniIcon';
function SetupDiGetClassBitmapIndex; external SetupAPIdll name 'SetupDiGetClassBitmapIndex';
function SetupDiGetClassImageList; external SetupAPIdll name 'SetupDiGetClassImageList';
function SetupDiGetClassImageListExA; external SetupAPIdll name 'SetupDiGetClassImageListExA';
function SetupDiGetClassImageListExW; external SetupAPIdll name 'SetupDiGetClassImageListExW';
function SetupDiGetClassImageListEx; external SetupAPIdll name 'SetupDiGetClassImageListExA';
function SetupDiGetClassImageIndex; external SetupAPIdll name 'SetupDiGetClassImageIndex';
function SetupDiDestroyClassImageList; external SetupAPIdll name 'SetupDiDestroyClassImageList';
function SetupDiGetClassDevPropertySheetsA; external SetupAPIdll name 'SetupDiGetClassDevPropertySheetsA';
function SetupDiGetClassDevPropertySheetsW; external SetupAPIdll name 'SetupDiGetClassDevPropertySheetsW';
function SetupDiGetClassDevPropertySheets; external SetupAPIdll name 'SetupDiGetClassDevPropertySheetsA';
function SetupDiAskForOEMDisk; external SetupAPIdll name 'SetupDiAskForOEMDisk';
function SetupDiSelectOEMDrv; external SetupAPIdll name 'SetupDiSelectOEMDrv';
function SetupDiClassNameFromGuidA; external SetupAPIdll name 'SetupDiClassNameFromGuidA';
function SetupDiClassNameFromGuidW; external SetupAPIdll name 'SetupDiClassNameFromGuidW';
function SetupDiClassNameFromGuid; external SetupAPIdll name 'SetupDiClassNameFromGuidA';
function SetupDiClassNameFromGuidExA; external SetupAPIdll name 'SetupDiClassNameFromGuidExA';
function SetupDiClassNameFromGuidExW; external SetupAPIdll name 'SetupDiClassNameFromGuidExW';
function SetupDiClassNameFromGuidEx; external SetupAPIdll name 'SetupDiClassNameFromGuidExA';
function SetupDiClassGuidsFromNameA; external SetupAPIdll name 'SetupDiClassGuidsFromNameA';
function SetupDiClassGuidsFromNameW; external SetupAPIdll name 'SetupDiClassGuidsFromNameW';
function SetupDiClassGuidsFromName; external SetupAPIdll name 'SetupDiClassGuidsFromNameA';
function SetupDiClassGuidsFromNameExA; external SetupAPIdll name 'SetupDiClassGuidsFromNameExA';
function SetupDiClassGuidsFromNameExW; external SetupAPIdll name 'SetupDiClassGuidsFromNameExW';
function SetupDiClassGuidsFromNameEx; external SetupAPIdll name 'SetupDiClassGuidsFromNameExA';
function SetupDiGetHwProfileFriendlyNameA; external SetupAPIdll name 'SetupDiGetHwProfileFriendlyNameA';
function SetupDiGetHwProfileFriendlyNameW; external SetupAPIdll name 'SetupDiGetHwProfileFriendlyNameW';
function SetupDiGetHwProfileFriendlyName; external SetupAPIdll name 'SetupDiGetHwProfileFriendlyNameA';
function SetupDiGetHwProfileFriendlyNameExA; external SetupAPIdll name 'SetupDiGetHwProfileFriendlyNameExA';
function SetupDiGetHwProfileFriendlyNameExW; external SetupAPIdll name 'SetupDiGetHwProfileFriendlyNameExW';
function SetupDiGetHwProfileFriendlyNameEx; external SetupAPIdll name 'SetupDiGetHwProfileFriendlyNameExA';
function SetupDiGetWizardPage; external SetupAPIdll name 'SetupDiGetWizardPage';
function SetupDiGetSelectedDevice; external SetupAPIdll name 'SetupDiGetSelectedDevice';
function SetupDiSetSelectedDevice; external SetupAPIdll name 'SetupDiSetSelectedDevice';
function SetupDiGetActualSectionToInstallA; external SetupAPIdll name 'SetupDiGetActualSectionToInstallA';
function SetupDiGetActualSectionToInstallW; external SetupAPIdll name 'SetupDiGetActualSectionToInstallW';
function SetupDiGetActualSectionToInstall; external SetupAPIdll name 'SetupDiGetActualSectionToInstallA';

end.
