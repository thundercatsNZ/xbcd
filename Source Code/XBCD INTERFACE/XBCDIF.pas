unit XBCDIF;

{$WEAKPACKAGEUNIT}

interface

uses
  Windows;

Type
  PXBCD_Device = ^TXBCD_Device;
  TXBCD_Device = packed record
    Index: Integer;
    HIDPath: PChar;
    USBPath: PChar;
  end;
  
{Type
  PXBCD_Version = ^TXBCD_Version;
  TXBCD_Version = packed record
    Major: Byte;
    Minor: Byte;
    Release: Byte;
  end;}

Type
  PEnumCallback = ^TEnumCallback;
  TEnumCallback = function(EnumDevice: PXBCD_Device): Integer;

const
  XBCD_SIGNATURE = $58425355; //'XBSU'
  

function XBCDEnumerate(EnumCallback: TEnumCallback; bUSBPathReq: Boolean): Integer; stdcall;
{$EXTERNALSYM XBCDEnumerate}
//function XBCDGetVersion(HIDPath: PChar; XBCDVersion: PXBCD_Version): Boolean; stdcall;
//{$EXTERNALSYM XBCDGetVersion}

implementation

const
  xbcdifdll = 'xbcdif.dll';

function XBCDEnumerate; external xbcdifdll name 'XBCDEnumerate';
//function XBCDGetVersion; external xbcdifdll name 'XBCDGetVersion';

end.

